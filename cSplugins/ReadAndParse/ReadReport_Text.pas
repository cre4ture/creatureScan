unit ReadReport_Text;

interface

uses
  Inifiles, OGame_Types, SysUtils, DateUtils, Classes, regexpname;

const
  SB_KeyWord_Count = 12;
  SB_activity = 10-1;
  SB_no_activity = 11-1;


type
  TReadReport = record
    Report: TScanbericht;
    AskMoon: Boolean;
  end;
  TReportList = array of TReadReport;
  TReadReport_Text = class
  private
  protected
    STR_Mond: string;
    STR_RegExp_Header: string;
    STR_RegExp_cspio: string;
    
    SB_Items: array[TScanGroup] of TStringlist;
    SB_KWords: array[0..SB_KeyWord_Count-1] of string;
    tsep: char;
    function _ScanToStrAsTable(SB: TScanBericht): string;
    function _ScanToStrAsTable_v2(SB: TScanBericht): string;
    function _ReadScanHeader_RegEx(var s1: string; var Head: TScanHead): Boolean;
    function _ReadScanHeaders(var s1: string; var Head: TScanHead): Boolean;
    function _LeseGanzenScanBericht(var _s: String; var Bericht: TScanBericht; var AskMond: Boolean): Boolean;
    function _ScanToStr(SB: TScanBericht): string;
    function _ScanHeadToStr(Head: TScanHead): string;
    function _ReadActivity(var Head: TScanHead; scan_body: string): Boolean;
    function _SetTime(month, day, h, m, s: integer): Int64;
  public
    constructor Create(ini: TIniFile);
    destructor Destroy; override;
    function Read(text: String): TReportList;
    function ReportToString(report: TScanBericht; table: Boolean): String;

    //for use in ReadPhalanxScan public:
    function _LeseTeilScanBericht(var s: string; var INFAR: TInfoArray;
      Sorte: TScanGroup; const ForceHeader: boolean = true): Integer;
  end;

implementation

uses StrUtils;

constructor TReadReport_Text.Create(ini: TIniFile);
var i: Integer;
    sg: TScanGroup;
begin
  inherited Create;

  for i := 1 to SB_KeyWord_Count do
  begin
    SB_KWords[i-1] := {TrimStringChar(}ini.ReadString('Espionage report','Z'+inttostr(i),'---n/a---'){,'"')};
  end;
  for sg := low(sg) to high(sg) do
  begin
    SB_Items[sg] := TStringList.Create;
    ini.ReadSection('SB'+inttostr(integer(sg)),SB_Items[sg]);
  end;
  STR_Mond := ini.ReadString('Espionage report','moon','---n/a---');
  STR_RegExp_Header := ini.ReadString('Espionage report','regexp_header','---n/a---');
  STR_RegExp_cspio := ini.ReadString('Espionage report','regexp_cspio','---n/a---');
  tsep := (ini.ReadString('Espionage report','tsep','.'))[1];
end;

destructor TReadReport_Text.Destroy;
var sg: TScanGroup;
begin
  for sg := low(sg) to high(sg) do
  begin
    SB_Items[sg].free;
  end;
  inherited;
end;

function TReadReport_Text.Read(text: String): TReportList;
var rr: TReadReport;
    i: integer;
begin
  SetLength(Result, 0);
  i := 0;
  while _LeseGanzenScanBericht(text, rr.Report, rr.AskMoon) do
  begin
    SetLength(Result, i+1);
    Result[i] := rr;
    inc(i);
  end;
end;

function TReadReport_Text.ReportToString(report: TScanBericht;
  table: Boolean): String;
begin
  if table then Result := _ScanToStrAsTable(report)
    else REsult := _ScanToStr(report);
end;

function TReadReport_Text._ScanToStrAsTable(SB: TScanBericht): string;
var j,x : integer;
    maxl1, maxl2 : integer;
    s : string;
    sg: TScanGroup;
begin
  Result := _ScanHeadToStr(SB.Head);
  
  maxl1 := 0;
  maxl2 := 0;
  for sg := low(sg) to high(sg) do
  if (length(SB.Bericht[sg]) > 0)and(SB.Bericht[sg][0] <> -1) then
  begin
    x := 0;
    for j := 0 to length(SB.Bericht[sg])-1 do
    if SB.Bericht[sg][j] <> 0 then
    begin
      s := SB_Items[sg][j+1] + ' ' + IntToStrKP(SB.Bericht[sg][j],
                                                tsep);
      inc(x);
      if x > 1 then
      begin
        x := 0;
        if length(s) > maxl2 then
          maxl2 := length(s);
      end
      else
      begin
        if length(s) > maxl1 then
          maxl1 := length(s);
      end;
    end;
  end;
  for sg := low(sg) to high(sg) do
  if (length(SB.Bericht[sg]) > 0)and(SB.Bericht[sg][0] <> -1) then
  begin
    if sg <> sg_Rohstoffe then  //keine extra headline f�r ressourcen!
    begin
      s := SB_Items[sg][0] + ' ';
      while length(s) < maxl1 + maxl2 + 3 do
        s := s + '-';
      Result := Result + s + #13 + #10; 
      //headlines zb.: Verteidigung
    end;
    x := 0;
    for j := 0 to length(SB.Bericht[sg])-1 do
    if SB.Bericht[sg][j] <> 0 then
    begin
      s := SB_Items[sg][j+1];
      inc(x);
      if x > 1 then
      begin
        x := 0;
        while length(s + IntToStrKP(SB.Bericht[sg][j],tsep)) < maxl2 do
          s := s + ' ';
        s := s + IntToStrKP(SB.Bericht[sg][j],tsep);
        Result := Result + s + #13 + #10;
      end
      else
      begin
        while length(s + IntToStrKP(SB.Bericht[sg][j],tsep)) < maxl1 do
          s := s + ' ';
        s := s + IntToStrKP(SB.Bericht[sg][j],tsep);
        Result := Result + s + ' ! ';
      end;
    end;
    if Result[length(Result)] <> #10 then
    begin
      result := copy(result,1,length(result)-1);
      result := result + #13 + #10;
    end;
  end;
  result := result + SB_KWords[4] + inttostr(SB.Head.Spionageabwehr) + SB_KWords[5];
end;

function TReadReport_Text._ScanToStrAsTable_v2(SB: TScanBericht): string;
var j,x : integer;
    y,m,d : word;
    maxl1, maxl2 : array[TScanGroup] of integer;
    s : string;
    sg: TScanGroup;
begin
  //v2: idee is nicht �berl, aber es bringt nicht viel und man verliert dabei
  //an �bersichtlichkeit!

  Result := SB_KWords[0] + SB.Head.Planet + SB_KWords[1] + PositionToStr_(SB.Head.Position);
  // Rohstoffe auf ... [....]
  DecodeDate(UnixToDateTime(SB.Head.Time_u),y,m,d);
  result := Result + SB_KWords[2] + inttostr(m) + '-' + inttostr(d) +
            SB_KWords[3] + TimeToStr(UnixToDateTime(SB.Head.Time_u)) + #13 + #10;
  // .... [...] + um <uhrzeit>
  for sg := low(sg) to high(sg) do
  if (length(SB.Bericht[sg]) > 0)and(SB.Bericht[sg][0] <> -1) then
  begin
    maxl1[sg] := 0;
    maxl2[sg] := 0;
    x := 0;
    for j := 0 to length(SB.Bericht[sg])-1 do
    if SB.Bericht[sg][j] <> 0 then
    begin
      s := SB_Items[sg][j+1] + ' ' + inttostr(SB.Bericht[sg][j]);
      inc(x);
      if x > 1 then
      begin
        x := 0;
        if length(s) > maxl2[sg] then
          maxl2[sg] := length(s);
      end
      else
      begin
        if length(s) > maxl1[sg] then
          maxl1[sg] := length(s);
      end;
    end;
  end;
  for sg := low(sg) to high(sg) do
  if (length(SB.Bericht[sg]) > 0)and(SB.Bericht[sg][0] <> -1) then
  begin
    if sg <> sg_Rohstoffe then  //keine extra headline f�r ressourcen!
    begin
      s := SB_Items[sg][0] + ' ';
      while length(s) < maxl1[sg] + maxl2[sg] + 3 do
        s := s + '-';
      Result := Result + s + #13 + #10;
      //headlines zb.: Verteidigung
    end;
    x := 0;
    for j := 0 to length(SB.Bericht[sg])-1 do
    if SB.Bericht[sg][j] <> 0 then
    begin
      s := SB_Items[sg][j+1];
      inc(x);
      if x > 1 then
      begin
        x := 0;
        while length(s + inttostr(SB.Bericht[sg][j])) < maxl2[sg] do
          s := s + ' ';
        s := s + inttostr(SB.Bericht[sg][j]);
        Result := Result + s + #13 + #10;
      end
      else
      begin
        while length(s + inttostr(SB.Bericht[sg][j])) < maxl1[sg] do
          s := s + ' ';
        s := s + inttostr(SB.Bericht[sg][j]);
        Result := Result + s + ' ! ';
      end;
    end;
    if Result[length(Result)] <> #10 then
    begin
      result := copy(result,1,length(result)-1);
      result := result + #13 + #10;
    end;
  end;
  result := result + SB_KWords[4] + inttostr(SB.Head.Spionageabwehr) + SB_KWords[5];
end;


function TReadReport_Text._SetTime(month, day, h, m,
  s: integer): Int64;
//Funktion um das richtige Jahr "herrauszufinden"
var Y_,M_,D_: Word;
    Time_dt: TDateTime;
begin
  DecodeDate(now,Y_,M_,D_);
  Time_dt := EncodeDate(Y_,month,day);
  if Time_dt > now+200 then        //200 tage darf uhr falschgehn  (auch nur am 31.12. wichtig!)
    Time_dt := EncodeDate(Y_-1,month,day)
  else
  if Time_dt < now-200 then        //200 tage darf uhr falschgehn  (auch nur am 01.01. wichtig!)
    Time_dt := EncodeDate(Y_+1,month,day);

  Result := DateTimeToUnix(Time_dt + EncodeTime(h,m,s,0));
end;

function TReadReport_Text._LeseTeilScanBericht(var s: string;
  var INFAR: TInfoArray; Sorte: TScanGroup; const ForceHeader: boolean = true): Integer;
var p, i, max : integer;                       //Result = Anzahl eingelesener Arten / oder -1 wenn Bereich nicht vorhanden
    followingchar: char; //UHO 29.12.2008: "Flotten" soll erkannt werden "Flottenkontakt" nicht!!
begin                                   //alles nur Beispiel Flotte:
  max := 0; //max -> ende dieses "ScanTeils"
  p := 0;

  repeat
    p := PosEx(SB_Items[sorte][0],s,p+1);        //[p]'Flotten'.....   -> Kategorie
    followingchar := s[p + length(SB_Items[sorte][0])];
  until (p = 0) or
    (not (followingchar in ['a'..'z','A'..'Z']));
  
  SetLength(INFAR,SB_Items[sorte].Count-1);    //L�nge Setzten
  if (p <> 0) or (not ForceHeader) then
  begin
    result := 0;                          //wenn 'Flotten' (Kategorie) gefunden dann Result schonmal := 0;
    delete(s,1,p-1);                      //aus Gesamtstring alles vorherige l�schen:   0'Flotten........
    for i := 1 to SB_Items[sorte].Count-1 do
    begin
      p := pos(SB_Items[sorte][i],s);          //suche nach einzelnen Schiffen
      if p <> 0 then
      begin
        p := p + length(SB_Items[sorte][i]);   //.....Schlachtschiff'[p]
        INFAR[i-1] := ReadInt(s,p{+1}{,SB_tsep});   //hier nicht! plus 1 da es auch scans gibt, die keine Lehrzeichen dazwischen haben
        //UHO 20.09.08: damit die reihenfolge egal ist darf hier nicht alles gleich wieder gel�scht werden
        //delete(s,1,p);                    //aus ursprungsstring l�schen!
        //statt delete: max -> ende des scanteils, dann sp�ter l�schen!
        if (p > max) then max := p;
        inc(Result);                      //result um 1 erh�hen
      end
      else
        INFAR[i-1] := 0;                  //Typ nicht aufgelistet -> Typ := 0;
    end;

    //gesammten bereich aus string l�schen:
    delete(s,1,max);
  end
  else
    Result := -1;
end;

function TReadReport_Text._ReadScanHeader_RegEx(var s1: string; var Head: TScanHead): Boolean;
var regex: Tregexpn;
    p, i: integer;
    M,D,h,min,sec: integer;
begin
  Result := False;

  regex := Tregexpn.Create;
  try
    regex.setexpression(STR_RegExp_Header);
    if regex.match(s1) then
    begin
      //L�schen alles vorher:
      Delete(s1, 1, regex.regexpr.MatchPos[0]-1);

      Head.Planet := regex.getsubexpr('name');
      Head.Position.P[0] := StrToInt(regex.getsubexpr('p0'));
      Head.Position.P[1] := StrToInt(regex.getsubexpr('p1'));
      Head.Position.P[2] := StrToInt(regex.getsubexpr('p2'));
      Head.Position.Mond := (regex.getsubexpr('moon') <> '');

      M := StrToInt(regex.getsubexpr('m'));
      D := StrToInt(regex.getsubexpr('d'));
      h := StrToInt(regex.getsubexpr('h'));
      min := StrToInt(regex.getsubexpr('min'));
      sec := StrToInt(regex.getsubexpr('s'));
      Head.Time_u := _SetTime(M,D,h,min,sec);

      Head.Spieler := regex.getsubexpr('player');
      Head.Creator := '';

      //Suche ScanEnde: "Spionageabwehr:X%"
      p := regex.regexpr.MatchLen[0];
      regex.setexpression(STR_RegExp_cspio);
      if regex.match(s1,p) then
      begin
        Head.Spionageabwehr := StrToInt(regex.getsubexpr('cspio'));

        p := regex.regexpr.MatchPos[0] + regex.regexpr.MatchLen[0];
        s1 := copy(s1,1,p-1);

        //Lese Aktivit�t:
        if not _ReadActivity(Head, s1) then
          Head.Activity := -1;

        Result := True;
      end;
    end;
  finally
    regex.Free;
  end;
end;

function TReadReport_Text._ReadActivity(var Head: TScanHead; scan_body: string): Boolean;
var p: integer;
begin
  Result := False;

  //Suche nach Aktivit�tsnachricht:
  p := pos(SB_KWords[SB_activity], scan_body);
  if p > 0 then
  begin
    Head.Activity := 60*ReadInt(scan_body,p + length(SB_KWords[SB_activity]));
    Result := True;
  end
  else
  begin
    //Suche nach _nich_Aktivit�tsnachricht:
    p := pos(SB_KWords[SB_no_activity], scan_body);
    if p > 0 then
    begin
      Head.Activity := 0;
      Result := True;                                  
    end;
  end;
end;

function TReadReport_Text._ReadScanHeaders(var s1: string; var Head: TScanHead): Boolean;
var p,p2 : integer;
    Y,M,D : Word;
    month, day: integer;
    TimePos : TPlanetPosition;
    Time_dt: TDateTime;
    s, delemch : string;

    function readPlayerName: boolean;
    var p: integer;
    begin
      result := false;

      p := pos(SB_KWords[6], s); //"(Spieler '"
      if (p <= 0)or(p > 10) then exit;
      p := p+length(SB_KWords[6])-1;
      Delete(s, 1, p);
      p := pos(SB_KWords[7], s); //"')"
      if p <= 0 then exit;
      Head.Spieler := copy(s,1,p-1);
      Delete(s, 1, p+length(SB_KWords[7])-1);
      {p := pos(SB_KWords[8],s);   //"am "
      Delete(s, 1, p-1); }

      result := true;
    end;
    //10.01.2009 -> veraltet! siehe _RegExp
begin             //liest den kopf eines Scans
  Result := false;
  Head.Spieler := '';
  Head.Creator := '';
  {Head.geraidet := false;
  Head.von := ''; }


  p := pos(SB_KWords[0],s1);  //'Rohstoffe auf '
  delete(s1,1,p-1);          //k�rzt den Ursprungsstring bis zum ersten Scanbericht!
  s := s1;
  if p = 0 then              //wenn keiner gefunden dann Exit!
    Exit;
  p2 := pos(SB_KWords[1],s);  //' ['
  if p2 = 0 then             //wenn keine Koordinaten dann exit!
    Exit;
  p := length(SB_KWords[0]) + 1;      //'Rohstoffe auf '[p] .... [p2]' ['
  Head.Planet := copy(s,p,p2-p);     //Planetname
  //----nachtrag:---------------------------------------------------------------
  delemch := Head.Planet;
  //----------------------------------------------------------------------------
  //----Ogame version 0.75------Monde: namelala (Mond)---------------------------
  p := pos('(' + STR_Mond + ')',delemch);
  Head.Position.Mond := p > 0;
  if Head.Position.Mond then
    Delete(delemch,p,high(integer));
  //----------------------------------------------------------------------------
  DeleteEmptyChar(delemch);   //nur f�r t�rkische version muss auch #13 und #10 noch enfernt werden
  Head.Planet := delemch;     //kann wieder abgestellt werden, sobalt die datfiles auch zeilenumbr�che k�nnen!
  //----------------------------------------------------------------------------
  p := p2 + length(SB_KWords[1]);     //[p2]' ['[p].......
  readPosOrTime(s,p,Head.Position);  //Position
  p := pos(SB_KWords[2],s);           //[p]'] '
  if p = 0 then
    Exit;
  p := p + length(SB_KWords[2]);      //'] '[p]
  delete(s,1,p-1);                   //String bis dahin l�schen
  readPlayerName;
  p := pos(SB_KWords[8],s) + length(SB_KWords[8]);          //'am '[p]'.......
  //Zeit und Datum:
  ReadPosOrTime(s,p,TimePos);        //DatumEinlesen
  month := TimePos.P[1];
  day := TimePos.P[0];
  p := PosEx(SB_KWords[3],s,p);           //[p]' '.......
  if p = 0 then Exit;
  p := p + length(SB_KWords[3]);      //' '[p].....
  ReadPosOrTime(s,p,TimePos);        //Uhrzeiteinlesen
  Head.Time_u := _SetTime(month,day,TimePos.P[0],TimePos.P[1],TimePos.P[2]);
  //---------------------------------------------------------------------------------------------------------------------
  //ShowMessage('Rest in read Head: ' + s);
  p := pos(SB_KWords[4],s);           //[p]'Chance auf Spionageabwehr:'...
  if p = 0 then
    Exit                             //dann is der Scan nicht Vollst�ndig, und es fehlen wom�glich Forschungen am Schluss!
  else
  begin
    p := p + length(SB_KWords[4]);    //'Chance auf Spionageabwehr:'[p]...
    Head.Spionageabwehr := ReadInt(s,p);    //Einlesen der Spioabwehr
    delete(s,1,p+1);                        //Gesammten eingelesenen Scan aus s L�schen
    s1 := copy(s1,1,length(s1)-length(s));  //da length(s) den reststring angibt, wird dieser von der gesamtl�nge abgezogen. Dadurch ist in s1 nurnoch der scan!
  end;
  Result := true;                    //da alles funzt Result := true;

  //14.02.2008: Einlesen der Aktivit�t auf dem Planeten (Anomalie usw...)
  if not _ReadActivity(Head, s1) then
    Head.Activity := -1;
end;

function TReadReport_Text._LeseGanzenScanBericht(var _s: String; var Bericht: TScanBericht; var AskMond: Boolean): Boolean;
var j  : integer;
    sg: TScanGroup;
    s: string;
begin
  s := _s;
  //ShowMessage('All: ' + _S);
  Result := _ReadScanHeader_RegEx(s,Bericht.Head); //Head einlesen und Gesamtstring auf Scanbereich k�rzen
  //ShowMessage('Result von ReadHead: ' + inttostr(byte(Result)));
  //ShowMessage('Scan: ' + s);
  j := pos(s,_s);
  delete(_s,1,j + length(s));
  // UHO 19.09.08: Vorsichtshalber Planeten Namen L�schen, da so keine Einlesefehler aufgrund
  // Irref�hrender Planetennamen ('Metall: 40000000' oder so...) entstehen k�nnen:
  j := pos(SB_KWords[0] {'Rohstoffe auf '} + Bericht.Head.Planet, s);
  if (j > 0) then
  begin
    Delete(s, j + length(SB_KWords[0] {'Rohstoffe auf '}), length(Bericht.Head.Planet));
  end;
  //ShowMessage('Rest: ' + _s);
  if not Result then
    exit;
  for sg := low(sg) to high(sg) do
  begin
    if _LeseTeilScanBericht(s,Bericht.Bericht[sg], sg) = -1 then   //wenn gesamter scanbereich nicht vorhanden
    begin
      for j := 0 to length(Bericht.Bericht[sg])-1 do            //dann alle -1 setzten
        Bericht.Bericht[sg][j] := -1;
    end;
  end;

  AskMond := (not Bericht.Head.Position.Mond)and   //Wenn hier schon mond, dann hat Readheader schon richtig eingelesen!
             (not checkMoonScan(Bericht));
end;

function TReadReport_Text._ScanToStr(SB: TScanBericht): string;
var j,x : integer;
    sg: TScanGroup;
begin
  Result := _ScanHeadToStr(SB.Head);
  
  for sg := low(sg)to high(sg) do
  if (length(SB.Bericht[sg]) > 0)and(SB.Bericht[sg][0] <> -1) then
  begin
    if sg <> sg_Rohstoffe then
    begin
      Result := Result + SB_Items[sg][0] + #13 + #10;
    end;
    x := 0;
    for j := 0 to length(SB.Bericht[sg])-1 do
    if (SB.Bericht[sg][j] <> 0)or(sg = sg_Rohstoffe){Ressourcen immer!} then
    begin
      Result := Result + SB_Items[sg][j+1] + #9 + IntToStrKP(SB.Bericht[sg][j],tsep);
      inc(x);
      if x > 1 then
      begin
        x := 0;
        Result := Result + #13 + #10;
      end
      else
        Result := Result + #9;
    end;
    if Result[length(Result)] <> #10 then
    begin
      result := copy(result,1,length(result)-1);
      result := result + #13 + #10;
    end;
  end;
  result := result + SB_KWords[4] + inttostr(SB.Head.Spionageabwehr) + SB_KWords[5];
end;


function TReadReport_Text._ScanHeadToStr(Head: TScanHead): string;
var y,m,d : word;
begin
  Result := SB_KWords[0]{Rohstoffe auf } + Head.Planet +
            SB_KWords[1]{ [} + PositionToStr_(Head.Position) +
            SB_KWords[2]{] };

  Result := Result + SB_KWords[6]{(Spieler '} + Head.Spieler +
            SB_KWords[7]{')} + #13 + #10;

  DecodeDate(UnixToDateTime(Head.Time_u),y,m,d);
  result := Result + SB_KWords[8]{am } + inttostr(m) + '-' + inttostr(d) +
            SB_KWords[3]{ } + TimeToStr(UnixToDateTime(Head.Time_u)) + #13 + #10;
end;

end.