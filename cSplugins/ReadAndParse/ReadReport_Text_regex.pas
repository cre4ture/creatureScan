unit ReadReport_Text_regex;

interface

uses
  IniFiles, regexpname, OGame_Types, SysUtils, DateUtils;

type
  TRegexReportRead = class
  protected
    regexp_head: string;
    regexp_group, regexp_item: string;
    readbodytype: (rbt_old, rbt_regexp);
    function ReadHeader_regexp(var s1: string; var head: TScanHead): Boolean;
    function ReadGroup(var s: string; var INFAR: TInfoArray;
      Sorte: TScanGroup; withheader: boolean = true): Integer;
  public
    constructor Create(ini: TIniFile);
    function Read(var _s: String;
      var Bericht: TScanBericht; var AskMoon: Boolean): Boolean;
    function ReadRaidFleets(s: string; INFAR: TInfoArray): Boolean;
  end;

implementation

function LoadRegexprFromFile(Filename: string): String;
var sl: TStringList;
begin
  sl := TStringList.Create;
  sl.LoadFromFile(Filename);
  Result := StringReplace(sl.Text,#13+#10,'',[rfReplaceAll]);
  sl.Free;
end;

procedure CheckForFile(var value: string; dir: string);
var s: string;
begin
  s := 'file:';
  if Copy(value,1,length(s)) = s then
    value := LoadRegexprFromFile
      (dir + Copy(value,length(s)+1,high(Integer)));
end;

constructor TRegexReportRead.Create(ini: TIniFile);
var i: integer;
    b: Boolean;
    s: string;
begin
  inherited Create;
  regexp_head := ini.ReadString('report','regexp_head','---n/a---');
  s := ini.ReadString('report','readbodytype','regexp');

  if (s = 'regexp') then
    readbodytype := rbt_regexp
  else readbodytype := rbt_old;

  regexp_group := ini.ReadString('report','regexp_group','%%group%%');
  regexp_item := ini.ReadString('report','regexp_item','%%item%%[ \t]+(?<%%item%%>[0-9.]+)');
end;

function TRegexReportRead.ReadHeader_regexp(var s1: string;
  var head: TScanHead): Boolean;
var y,m,d,h,min,sec: word;
    datum: TDateTime;
    regex: Tregexpn;
begin             //liest den kopf eines Scans
  result := False;
  regex := Tregexpn.Create;
  regex.setexpression(regexp_head);
  if regex.match(s1) then
  try
    with regex do
    begin
      head.Planet := getsubexpr('planet');
      head.Position.Mond := (getsubexpr('moon') <> '');
      head.Position.P[0] := ReadInt(getsubexpr('gala'),1);
      head.Position.P[1] := ReadInt(getsubexpr('sys'),1);
      head.Position.P[2] := ReadInt(getsubexpr('pos'),1);
      //----- time ---------------------------------------------------------------
      DecodeDate(now,y,m,d);
      m := StrToInt(getsubexpr('month'));
      d := StrToInt(getsubexpr('day'));
      datum := EncodeDate(y,m,d);
      if (datum - now) > 300 then //300 Tage in der Zukunft (Jahreswechsel)
      begin
        dec(y);
        datum := EncodeDate(y,m,d);
      end;
      h := StrToInt(getsubexpr('hour'));
      min := StrToInt(getsubexpr('min'));
      sec := StrToInt(getsubexpr('sec'));
      head.Time_u := DateTimeToUnix(datum + EncodeTime(h,min,sec,0));
      //----- time end -----------------------------------------------------------
      head.Spieler := getsubexpr('player'); //steht im scan ja nochnicht drin!
                                            //wird also immer '' sein!
      head.Spionageabwehr := StrToInt(getsubexpr('cspio'));
      head.Creator := '';
      head.geraidet := False;
      head.von := '';
      s1 := getsubexpr('body');
      Result := true;
    end;
  except
  end;
  regex.Free;
end;

function TRegexReportRead.Read(var _s: String;
  var Bericht: TScanBericht; var AskMoon: Boolean): Boolean;
var j  : integer;
    s: string;
    sg: TScanGroup;
begin
  s := _s;
  //Head einlesen und Gesamtstring auf Scanbereich kürzen
  Result := Self.ReadHeader_regexp(s,Bericht.Head);

  //Scan aus Rückgabestring löschen
  j := pos(s,_s);
  delete(_s,1,j + length(s));
  if not Result then
    exit;

  for sg := low(sg) to high(sg) do
  begin
    if ((readbodytype = rbt_old)and(true{_LeseTeilScanBericht(s,Bericht.Bericht[sg],sg) = -1}))or
       ((readbodytype = rbt_regexp)and(ReadGroup(s,Bericht.Bericht[sg],sg) = -1)) then
        //wenn gesamter scanbereich _nicht_ vorhanden
    begin
      for j := 0 to length(Bericht.Bericht[sg])-1 do            //dann alle -1 setzten
        Bericht.Bericht[sg][j] := -1;
    end;
  end;

  //Wenn hier schon mond, dann hat Readheader schon richtig eingelesen!
  if not Bericht.Head.Position.Mond then
    AskMoon := not checkMoonScan(Bericht);
end;

function TRegexReportRead.ReadGroup(var s: string;
  var INFAR: TInfoArray; Sorte: TScanGroup; withheader: boolean = true): Integer;
var j: integer;
    b: string;
    fg: boolean;
    regex: Tregexpn;
begin
  regex := Tregexpn.Create;
  Result := -1;
  SetLength(INFAR,SB_Items[sorte].Count-1);
  with regex do
  begin

    //Suche Gruppe:  (wenn 0 (Rohstoffe) brauchts kein check! wenn negativ soll
    // keiner durchgeführt werden!! Wird für ReadRaid gebraucht!)
    fg := not withheader;
    if not fg then
    begin
      b := AnsiReplaceStr(regexp_group,'%%group%%',SB_Items[Sorte][0]);
      setexpression(b);
      fg := match(s);
      if fg then delete(s,1,regexpr.MatchPos[0]);
    end;

    if fg then
    begin
      Result := 0;
      for j := 1 to SB_Items[Sorte].Count-1 do
      begin
        b := AnsiReplaceStr(regexp_item,'%%item%%',SB_Items[Sorte][j]);
        setexpression(b);
        if match(s) then inc(Result);

        b := getsubexpr('value');
        INFAR[j-1] := ReadInt(b,1);
      end;
    end;
  end;
  regex.Free;
end;

function TRegexReportRead.ReadRaidFleets(s: string;
  INFAR: TInfoArray): Boolean;
begin
  Result := ReadGroup(s,INFAR,sg_Flotten,false) >= 0;
  //Der negative Gruppenindex sorgt dafür das kein Gruppenheader gesucht wird!
end;


end.
 