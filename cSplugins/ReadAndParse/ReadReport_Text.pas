unit ReadReport_Text;

interface

uses
  Inifiles, OGame_Types, SysUtils, DateUtils, Classes, regexpname,
  creax_html, parser_types, readsource_cs;

const
  SB_KeyWord_Count = 12;
  SB_activity = 10-1;
  SB_no_activity = 11-1;


type
  TReadReport_Text = class
  private
    STR_Mond: string;
    STR_RegExp_Header: string;
    STR_RegExp_cspio: string;
    V6_RegExp_datetime: string;
    V6_regexp_planet_name_pos: string;
    V6_regexp_player_name: string;
    V6_regexp_report_header: string;
    V6_token_no_info_report_part: string;

    SB_Items: array[TScanGroup] of TStringlist;
    SB_KWords: array[0..SB_KeyWord_Count-1] of string;
    tsep: char;
    function _ScanToStrAsTable(SB: TScanBericht): string;
    function _ScanToStrAsTable_v2(SB: TScanBericht): string;
    function _ReadScanHeader_RegEx(var s1: string; var Head: TScanHead;
       out AskMond: Boolean; current_time: TDateTime): Boolean;
    function _LeseGanzenScanBericht(var _s: String; Bericht: TScanBericht;
       var AskMond: Boolean; current_time: TDateTime): Boolean;
    function _ScanToStr(SB: TScanBericht): string;
    function _ScanHeadToStr(Head: TScanHead): string;
    function _ReadActivity(var Head: TScanHead; scan_body: string): Boolean;
    function _SetTime(month, day, h, m, s: integer; current_time: TDateTime): Int64;
    procedure analyseAndPrepareHTML(html: THTMLElement);
    function checkTagAnalyseRoutine(CurElement: THTMLElement; Data: pointer): Boolean; // bestimmung von Mond oder Planet
    function deleteAppleSpan(CurElement: THTMLElement; Data: pointer): Boolean; // löschen von chrome tags
    function __insert_moon_or_planet_V6(CurElement: THTMLElement; Data: pointer): Boolean; // löschen von chrome tags

    function tryReadScanDirectlyFromHTML_OGameV6(html: THTMLElement;
       rr: TReadReport): boolean;

    function tryReadScanDirectlyFromHTML_OGameV6_ressources(html: THTMLElement;
       rr: TReadReport): boolean;


    function ReadHTML_intern(html: THTMLElement;  reportlist: TReadReportList;
       current_time: TDateTime; gameversion: TOGameVersion): integer;

    function Read_V6_splitter(text: String;  reportlist: TReadReportList;
       current_time: TDateTime): integer;
    function _LeseGanzenScanBericht_V6(_s: String; report: TReadReport; current_time: TDateTime): Boolean;

    function _LeseTeilScanBericht_Flotte_bis_Forschung(
       var s: string; report: TScanBericht): Integer;

    function getUnixTimestampFromNamedRegex(regexp: Tregexpn): Int64;

    function Read_PreV6(text: String;  reportlist: TReadReportList;
       current_time: TDateTime): integer;

  public
    constructor Create(ini: TIniFile);
    destructor Destroy; override;
    function Read(text: String;  reportlist: TReadReportList;
       current_time: TDateTime): integer;
    function ReadHTML(html: THTMLElement;  reportlist: TReadReportList;
       current_time: TDateTime; gameversion: TOGameVersion): integer;
    function ReportToString(report: TScanBericht; table: Boolean): String;

    //for use in ReadPhalanxScan public:
    function _LeseTeilScanBericht(var s: string; report: TScanBericht;
      Sorte: TScanGroup; const ForceHeader: boolean = true): Integer;
  end;

implementation

uses StrUtils, lib_read_html, Clipbrd;

constructor TReadReport_Text.Create(ini: TIniFile);
var i: Integer;
    sg: TScanGroup;

const
  ini_section_name = 'Espionage report';

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
  STR_Mond := ini.ReadString(ini_section_name,'moon','---n/a---');
  STR_RegExp_Header := ini.ReadString(ini_section_name,'regexp_header','---n/a---');
  STR_RegExp_cspio := ini.ReadString(ini_section_name,'regexp_cspio','---n/a---');
  V6_regexp_datetime := ini.ReadString(ini_section_name,'V6_regexp_datetime','---n/a---');
  V6_regexp_planet_name_pos := ini.ReadString(ini_section_name,'V6_regexp_planet_name_pos','---n/a---');
  V6_regexp_player_name := ini.ReadString(ini_section_name,'V6_regexp_player_name','---n/a---');
  V6_regexp_report_header := ini.ReadString(ini_section_name,'V6_regexp_report_header','---n/a---');
  V6_token_no_info_report_part := ini.ReadString(ini_section_name,'V6_token_no_info_report_part','---n/a---');
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

function TReadReport_Text.Read_PreV6(text: String; reportlist: TReadReportList;
    current_time: TDateTime): integer;
var rr: TReadReport;
    i: integer;
begin
  i := 0;
  rr := TReadReport.Create;
  try
    while _LeseGanzenScanBericht(text, rr, rr.AskMoon, current_time) do
    begin
      reportlist.push_back(rr);
      inc(i);
    end;
  finally
    rr.Free;
  end;
  Result := i;
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
  if (SB.Bericht[sg,0] <> -1) then
  begin
    x := 0;
    for j := 0 to SB.Count(sg)-1 do
    if SB.Bericht[sg,j] <> 0 then
    begin
      s := SB_Items[sg][j+1] + ' ' + IntToStrKP(SB.Bericht[sg,j],
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
  if (SB.Bericht[sg,0] <> -1) then
  begin
    if sg <> sg_Rohstoffe then  //keine extra headline für ressourcen!
    begin
      s := SB_Items[sg][0] + ' ';
      while length(s) < maxl1 + maxl2 + 3 do
        s := s + '-';
      Result := Result + s + #13 + #10; 
      //headlines zb.: Verteidigung
    end;
    x := 0;
    for j := 0 to SB.Count(sg)-1 do
    if SB.Bericht[sg,j] <> 0 then
    begin
      s := SB_Items[sg][j+1];
      inc(x);
      if x > 1 then
      begin
        x := 0;
        while length(s + IntToStrKP(SB.Bericht[sg,j],tsep)) < maxl2 do
          s := s + ' ';
        s := s + IntToStrKP(SB.Bericht[sg,j],tsep);
        Result := Result + s + #13 + #10;
      end
      else
      begin
        while length(s + IntToStrKP(SB.Bericht[sg,j],tsep)) < maxl1 do
          s := s + ' ';
        s := s + IntToStrKP(SB.Bericht[sg,j],tsep);
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
  //v2: idee is nicht überl, aber es bringt nicht viel und man verliert dabei
  //an übersichtlichkeit!

  Result := SB_KWords[0] + SB.Head.Planet + SB_KWords[1] + PositionToStr_(SB.Head.Position);
  // Rohstoffe auf ... [....]
  DecodeDate(UnixToDateTime(SB.Head.Time_u),y,m,d);
  result := Result + SB_KWords[2] + inttostr(m) + '-' + inttostr(d) +
            SB_KWords[3] + TimeToStr(UnixToDateTime(SB.Head.Time_u)) + #13 + #10;
  // .... [...] + um <uhrzeit>
  for sg := low(sg) to high(sg) do
  if (SB.Bericht[sg,0] <> -1) then
  begin
    maxl1[sg] := 0;
    maxl2[sg] := 0;
    x := 0;
    for j := 0 to SB.Count(sg)-1 do
    if SB.Bericht[sg,j] <> 0 then
    begin
      s := SB_Items[sg][j+1] + ' ' + inttostr(SB.Bericht[sg,j]);
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
  if (SB.Bericht[sg,0] <> -1) then
  begin
    if sg <> sg_Rohstoffe then  //keine extra headline für ressourcen!
    begin
      s := SB_Items[sg][0] + ' ';
      while length(s) < maxl1[sg] + maxl2[sg] + 3 do
        s := s + '-';
      Result := Result + s + #13 + #10;
      //headlines zb.: Verteidigung
    end;
    x := 0;
    for j := 0 to SB.Count(sg)-1 do
    if SB.Bericht[sg,j] <> 0 then
    begin
      s := SB_Items[sg][j+1];
      inc(x);
      if x > 1 then
      begin
        x := 0;
        while length(s + inttostr(SB.Bericht[sg,j])) < maxl2[sg] do
          s := s + ' ';
        s := s + inttostr(SB.Bericht[sg,j]);
        Result := Result + s + #13 + #10;
      end
      else
      begin
        while length(s + inttostr(SB.Bericht[sg,j])) < maxl1[sg] do
          s := s + ' ';
        s := s + inttostr(SB.Bericht[sg,j]);
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
  s: integer; current_time: TDateTime): Int64;
//Funktion um das richtige Jahr "herrauszufinden"
var Y_,M_,D_: Word;
    Time_dt: TDateTime;
begin
  DecodeDate(current_time,Y_,M_,D_);
  Time_dt := EncodeDate(Y_,month,day);
  if Time_dt > current_time+200 then        //200 tage darf uhr falschgehn  (auch nur am 31.12. wichtig!)
    Time_dt := EncodeDate(Y_-1,month,day)
  else
  if Time_dt < current_time-200 then        //200 tage darf uhr falschgehn  (auch nur am 01.01. wichtig!)
    Time_dt := EncodeDate(Y_+1,month,day);

  Result := DateTimeToUnix(Time_dt + EncodeTime(h,m,s,0));
end;

function TReadReport_Text._LeseTeilScanBericht(var s: string;
  report: TScanBericht; Sorte: TScanGroup; const ForceHeader: boolean = true): Integer;
var p, i, max, p2 : integer;                       //Result = Anzahl eingelesener Arten / oder -1 wenn Bereich nicht vorhanden
    followingchar: char; //UHO 29.12.2008: "Flotten" soll erkannt werden "Flottenkontakt" nicht!!
begin                                   //alles nur Beispiel Flotte:
  max := 0; //max -> ende dieses "ScanTeils"
  p := 0;

  followingchar := ' ';

  repeat
    p := PosEx(SB_Items[sorte][0],s,p+1);        //[p]'Flotten'.....   -> Kategorie
    if (p > 0) then
    begin
      p2 := p + length(SB_Items[sorte][0]);
      if (p2 < length(s)) then
        followingchar := s[p2];
    end;
  until (p = 0) or
    (not (followingchar in ['a'..'z','A'..'Z']));
  
  if (p <> 0) or (not ForceHeader) then
  begin
    result := 0;                          //wenn 'Flotten' (Kategorie) gefunden dann Result schonmal := 0;
    delete(s,1,p-1);                      //aus Gesamtstring alles vorherige löschen:   0'Flotten........
    for i := 1 to SB_Items[sorte].Count-1 do
    begin
      p := pos(SB_Items[sorte][i],s);          //suche nach einzelnen Schiffen
      if p <> 0 then
      begin
        p := p + length(SB_Items[sorte][i]);   //.....Schlachtschiff'[p]
        report.Bericht[sorte,i-1] := ReadInt(s,p{+1}{,SB_tsep});   //hier nicht! plus 1 da es auch scans gibt, die keine Lehrzeichen dazwischen haben
        //UHO 20.09.08: damit die reihenfolge egal ist darf hier nicht alles gleich wieder gelöscht werden
        //delete(s,1,p);                    //aus ursprungsstring löschen!
        //statt delete: max -> ende des scanteils, dann später löschen!
        if (p > max) then max := p;
        inc(Result);                      //result um 1 erhöhen
      end
      else
        report.Bericht[sorte,i-1] := 0;                  //Typ nicht aufgelistet -> Typ := 0;
    end;

    //gesammten bereich aus string löschen:
    delete(s,1,max);
  end
  else
    Result := -1;
end;

function TReadReport_Text._ReadScanHeader_RegEx(var s1: string;
   var Head: TScanHead; out AskMond: Boolean; current_time: TDateTime): Boolean;
var regex: Tregexpn;
    p: integer;
    M,D,h,min,sec: integer;
    tmp: string;
begin
  Result := False;
  AskMond := true;

  regex := Tregexpn.Create;
  try
    regex.setexpression(STR_RegExp_Header);
    if regex.match(s1) then
    begin
      //Löschen alles vorher:
      Delete(s1, 1, regex.regexpr.MatchPos[0]-1);

      Head.Planet := regex.getsubexpr('name');
      Head.Position.P[0] := StrToInt(regex.getsubexpr('p0'));
      Head.Position.P[1] := StrToInt(regex.getsubexpr('p1'));
      Head.Position.P[2] := StrToInt(regex.getsubexpr('p2'));
      Head.Position.Mond := false;

      tmp := regex.getsubexpr('kmoon');
      if (length(tmp) > 0) and (tmp[2] in [STR_M_Mond, STR_P_Planet]) then
      begin
        AskMond := false;  // hier können wir direkt festnageln ob mond oder nicht!
        Head.Position.Mond := (tmp[2] = STR_M_Mond);
      end;

      if (AskMond) and (regex.getsubexpr('moon') <> '') then
      begin
        AskMond := false;  // hier können wir direkt festnageln wenn mond!
        Head.Position.Mond := true;
      end;

      M := StrToInt(regex.getsubexpr('m'));
      D := StrToInt(regex.getsubexpr('d'));
      h := StrToInt(regex.getsubexpr('h'));
      min := StrToInt(regex.getsubexpr('min'));
      sec := StrToInt(regex.getsubexpr('s'));
      Head.Time_u := _SetTime(M,D,h,min,sec,current_time);

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

        //Lese Aktivität:
        if not _ReadActivity(Head, s1) then
          Head.Activity := activity_no_info;

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

  //Suche nach Aktivitätsnachricht:
  p := pos(SB_KWords[SB_activity], scan_body);
  if p > 0 then
  begin
    Head.Activity := 60*ReadInt(scan_body,p + length(SB_KWords[SB_activity]));
    Result := True;
  end
  else
  begin
    //Suche nach _nich_Aktivitätsnachricht:
    p := pos(SB_KWords[SB_no_activity], scan_body);
    if p > 0 then
    begin
      Head.Activity := activity_gt_60min;
      Result := True;                                  
    end;
  end;
end;

function TReadReport_Text._LeseGanzenScanBericht(var _s: String;
    Bericht: TScanBericht; var AskMond: Boolean; current_time: TDateTime): Boolean;
var j: integer;
    sg: TScanGroup;
    s: string;
begin
  AskMond := true;
  s := _s;
  //ShowMessage('All: ' + _S);
  Result := _ReadScanHeader_RegEx(s,Bericht.Head,AskMond,current_time); //Head einlesen und Gesamtstring auf Scanbereich kürzen
  //ShowMessage('Result von ReadHead: ' + inttostr(byte(Result)));
  //ShowMessage('Scan: ' + s);
  j := pos(s,_s);
  delete(_s,1,j + length(s));
  // UHO 19.09.08: Vorsichtshalber Planeten Namen Löschen, da so keine Einlesefehler aufgrund
  // Irreführender Planetennamen ('Metall: 40000000' oder so...) entstehen können:
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
    if _LeseTeilScanBericht(s, Bericht, sg) = -1 then   //wenn gesamter scanbereich nicht vorhanden
    begin
      for j := 0 to Bericht.Count(sg)-1 do            //dann alle -1 setzten
        Bericht.Bericht[sg,j] := -1;
    end;
  end;

  if (AskMond) then // wenns bis hierher nochnicht klar ist ob Mond oder nicht, nochmal überprüfen:
  begin
    AskMond := (not Bericht.Head.Position.Mond)and   //Wenn hier schon mond, dann hat Readheader schon richtig eingelesen!
               (not checkMoonScan(Bericht));
  end;
end;

function TReadReport_Text._ScanToStr(SB: TScanBericht): string;
var j,x : integer;
    sg: TScanGroup;
begin
  Result := _ScanHeadToStr(SB.Head);
  
  for sg := low(sg)to high(sg) do
  if (SB.Bericht[sg,0] <> -1) then
  begin
    if sg <> sg_Rohstoffe then
    begin
      Result := Result + SB_Items[sg][0] + #13 + #10;
    end;
    x := 0;
    for j := 0 to SB.Count(sg)-1 do
    if (SB.Bericht[sg,j] <> 0)or(sg = sg_Rohstoffe){Ressourcen immer!} then
    begin
      Result := Result + SB_Items[sg][j+1] + #9 + IntToStrKP(SB.Bericht[sg,j],tsep);
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

function TReadReport_Text.ReadHTML(html: THTMLElement;
  reportlist: TReadReportList; current_time: TDateTime; gameversion: TOGameVersion): integer;
var text: string;
begin
  analyseAndPrepareHTML(html);
  text := trim_html(HTMLGenerateHumanReadableText(html));
  Result := Read(text, reportlist, current_time);
end;

procedure TReadReport_Text.analyseAndPrepareHTML(html: THTMLElement);
begin
  html.DeleteTagRoutine(checkTagAnalyseRoutine, nil);
  html.DeleteTagRoutine(deleteAppleSpan, nil);
  html.DeleteTagRoutine(__insert_moon_or_planet_V6, nil);
end;

function TReadReport_Text.checkTagAnalyseRoutine(CurElement: THTMLElement;
  Data: pointer): Boolean;
var btn_tag, koords_tag: THTMLElement;
    href: string;
    regexp: Tregexpn;
    pos_header, pos_btn: TPlanetPosition;
const regexp_for_href = 'galaxy=(?<galaxy>[0-9]+)&amp;system=(?<system>[0-9]+)&amp;position=(?<position>[0-9]+)&amp;type=(?<type>[0-9]+)&amp;mission=(?<mission>[0-9]+)';
begin
  Result := false;
  try
    if (CurElement.TagName = 'div') and
       (CurElement.AttributeValue['id'] = 'showSpyReportsNow') then
    begin
      koords_tag := CurElement.FindChildTagPath_e('table:0/tbody:0/tr:0/th:0/a:0/><:0');
      if (koords_tag = nil) then exit;
      pos_header := StrToPositionEx(trim_html(koords_tag.Content));

      btn_tag := HTMLFindRoutine_NameAttribute(CurElement, 'a', 'class', 'buttonSave');
      if (btn_tag = nil) then exit;
//      if (btn_tag.AttributeValue['class'] = 'buttonSave') then
      begin
        href := btn_tag.AttributeValue['href'];
        regexp := Tregexpn.Create;
        try
          regexp.setexpression(regexp_for_href);
          if (regexp.match(href)) then // be sure its the same report!
          begin
            pos_btn.P[0] := StrToInt(regexp.getsubexpr('galaxy'));
            pos_btn.P[1] := StrToInt(regexp.getsubexpr('system'));
            pos_btn.P[2] := StrToInt(regexp.getsubexpr('position'));
            pos_btn.Mond := false;

            if SamePlanet(pos_header, pos_btn) then
            begin
              pos_btn.Mond := (regexp.getsubexpr('type') = '3');
              koords_tag.Content := '[' + PositionToStrMondPlanet(pos_btn) + ']';
            end;
          end;
        finally
          regexp.Free;
        end;
      end;
    end;
  except
    // nothing!
  end;
end;

function TReadReport_Text.deleteAppleSpan(CurElement: THTMLElement;
  Data: pointer): Boolean;
begin
  Result := false;
  if (CurElement.TagName = 'span') and
     (CurElement.AttributeValue['class'] = 'Apple-converted-space') then
  begin
    CurElement.ClearChilds;
    CurElement.TagType := pttContent;
    CurElement.Content := ' ';
  end;
end;

function TReadReport_Text.tryReadScanDirectlyFromHTML_OGameV6(   // currently not used!!
  html: THTMLElement; rr: TReadReport): boolean;
var
  root_div, date_span, title_span, figure_moon, a_tag, player_tag, activity_tag: THTMLElement;
  text_content: string;
  regexp: Tregexpn;
begin
  Result := true;

  regexp := Tregexpn.Create;
  try

    root_div := HTMLFindRoutine_NameAndClass(html,'div','detail_msg');
    if root_div <> nil then
    begin
      date_span := HTMLFindRoutine_NameAndClass(html,'span','msg_date');
      if date_span <> nil then
      begin
        text_content := trim_html(date_span.FullTagContent);

        regexp.setexpression(V6_RegExp_datetime);
        Result := regexp.match(text_content);
        if Result then
        begin
          rr.Head.Time_u := getUnixTimestampFromNamedRegex(regexp);

          title_span := HTMLFindRoutine_NameAndClass(root_div,'span','msg_title');
          if title_span <> nil then
          begin
            a_tag := HTMLFindRoutine_NameAndClass(title_span,'a','txt_link');
            if a_tag <> nil then
            begin
              text_content := trim_html(a_tag.FullTagContent);

              // read name an planet coordinates:
              regexp.setexpression(V6_regexp_planet_name_pos);
              Result := regexp.match(text_content);
              if Result then
              begin
                rr.Head.Position.P[0] := StrToInt(regexp.getsubexpr('p0'));
                rr.Head.Position.P[1] := StrToInt(regexp.getsubexpr('p1'));
                rr.Head.Position.P[2] := StrToInt(regexp.getsubexpr('p2'));
                rr.Head.Position.Mond := false;
                rr.Head.Planet := regexp.getsubexpr('name');

                // check for moon (moons have exta figure in HTML):
                rr.AskMoon := false;
                figure_moon := HTMLFindRoutine_NameAndClass(title_span,'figure','moon');
                rr.Head.Position.Mond := (figure_moon <> nil);

                player_tag := root_div.FindChildTagPath_e('div:1/div:0/div:0/div:0');
                if player_tag <> nil then
                begin
                  text_content := trim_html(player_tag.FullTagContent);

                  regexp.setexpression(V6_regexp_player_name);
                  Result := regexp.match(text_content);
                  if Result then
                  begin
                    rr.Head.Spieler := trim_html(regexp.getsubexpr('name'));

                    activity_tag := root_div.FindChildTagPath_e('div:1/div:0/div:0/div:1');
                    if activity_tag <> nil then
                    begin
                      text_content := trim_html(activity_tag.FullTagContent);

                      regexp.setexpression('Chance auf Spionageabwehr:[ ]?(?<cspio>[0-9]+)[ ]?%');
                      Result := regexp.match(text_content);
                      if Result then
                      begin
                        rr.Head.Spionageabwehr := StrToInt(regexp.getsubexpr('cspio'));

                        // Lese Aktivität:
                        if not _ReadActivity(rr.Head, text_content) then
                          rr.Head.Activity := activity_no_info;

                        Result := tryReadScanDirectlyFromHTML_OGameV6_ressources(root_div, rr);
                      end;
                    end;
                  end;
                end;
              end;
            end;
          end;
        end;
      end;
    end;
  finally
    regexp.Free;
  end;
end;

function TReadReport_Text.ReadHTML_intern(html: THTMLElement;
  reportlist: TReadReportList; current_time: TDateTime;
  gameversion: TOGameVersion): integer;
var rr: TReadReport;
    i: integer;
    success: boolean;
begin
  i := 0;
  rr := TReadReport.Create;
  try
    success := tryReadScanDirectlyFromHTML_OGameV6(html, rr);
    if success then
    begin
      reportlist.push_back(rr);
      inc(i);
    end;
  finally
    rr.Free;
  end;
  Result := i;
end;

function TReadReport_Text.tryReadScanDirectlyFromHTML_OGameV6_ressources(
  html: THTMLElement; rr: TReadReport): boolean;

  function readResource(nr: integer; name: string): boolean;
  var
    ressource_tag: THTMLElement;
    text_ress: string;
  begin
    ressource_tag := HTMLFindRoutine_NameAndClass(html,'div','resourceIcon ' + name);
    Result := ressource_tag <> nil;
    if Result then
    begin
      text_ress := trim_html(ressource_tag.ParentElement.FullTagContent);
      rr.resources[nr] := ReadInt(text_ress, 1);
    end;
  end;

var
  text_content: string;

begin
  Result := readResource(sb_Metall, 'metal');
  if Result then
    Result := readResource(sb_Kristall, 'crystal');
  if Result then
    Result := readResource(sb_Deuterium, 'deuterium');
  if Result then
    Result := readResource(sb_Energie, 'energy');

  if Result then
  begin
    text_content := trim_html(html.FullTagContent);

    _LeseTeilScanBericht_Flotte_bis_Forschung(text_content, rr);
  end;
end;

function TReadReport_Text.Read_V6_splitter(text: String;
  reportlist: TReadReportList; current_time: TDateTime): integer;
var
  parts: array of string;
  regexp: Tregexpn;
  p, partLen, count, i, matchLen: integer;
  success: boolean;
  rr: TReadReport;

  procedure addPart(start, size: integer);
  begin
    inc(count);
    SetLength(parts, count);
    parts[count-1] := Copy(text, start, size);
  end;

begin
  regexp := Tregexpn.Create;
  try
    // first: split available text into parts which each contains at max. one scan
    regexp.setexpression(V6_regexp_report_header);
    p := 1;
    matchLen := 0;
    count := 0;
    while regexp.match(text, p+matchLen) do
    begin
      partLen := regexp.regexpr.MatchPos[0] - p;
      addPart(p, partLen);
      p := p + partLen;
      matchLen := regexp.regexpr.MatchLen[0];
    end;
    addPart(p, length(text) - p);
  finally
    regexp.Free;
  end;

  Result := 0;
  rr := TReadReport.Create;
  try
    for i := 0 to count-1 do
    begin
      success := _LeseGanzenScanBericht_V6(parts[i], rr, current_time);
      if (success) then
      begin
        reportlist.push_back(rr);
        inc(Result);
      end;
    end;
  finally
    rr.Free;
  end;
end;

function TReadReport_Text._LeseGanzenScanBericht_V6(_s: String;
  report: TReadReport; current_time: TDateTime): Boolean;
var
  regexp: Tregexpn;
  moon_info, activity_info: string;

  function readResource(nr: integer; name: string): boolean;
  begin
    report.resources[nr] := ReadInt(regexp.getsubexpr(name), 1);
    Result := true;
  end;

begin
  regexp := Tregexpn.Create;
  try
    regexp.setexpression(V6_regexp_report_header);
    Result := regexp.match(_s, 1);
    if Result then
    begin
      report.Head.Position.P[0] := StrToInt(regexp.getsubexpr('p0'));
      report.Head.Position.P[1] := StrToInt(regexp.getsubexpr('p1'));
      report.Head.Position.P[2] := StrToInt(regexp.getsubexpr('p2'));
      report.Head.Planet := trim_html(regexp.getsubexpr('name'));

      moon_info := trim_html(regexp.getsubexpr('kmoon'));
      report.AskMoon := (moon_info = '');
      report.Head.Position.Mond := (moon_info = 'M');

      report.Head.Time_u := getUnixTimestampFromNamedRegex(regexp);
      report.Head.Spieler := trim_html(regexp.getsubexpr('player'));
      report.Head.Spionageabwehr := StrToInt(regexp.getsubexpr('cspio'));

      report.Head.Activity := activity_no_info;
      activity_info := regexp.getsubexpr('noactivity');
      if (activity_info <> '') then
        report.Head.Activity := activity_gt_60min
      else
      begin
        activity_info := regexp.getsubexpr('activity');
        report.Head.Activity := StrToInt(activity_info)*60;
      end;

      Result := readResource(sb_Metall, 'metal');
      if Result then
        Result := readResource(sb_Kristall, 'crystal');
      if Result then
        Result := readResource(sb_Deuterium, 'deuterium');
      if Result then
        Result := readResource(sb_Energie, 'energy');

      if Result then
      begin
        // remove start and matched part of string:
        Delete(_s, 1, regexp.regexpr.MatchPos[0] + regexp.regexpr.MatchLen[0]);
        _LeseTeilScanBericht_Flotte_bis_Forschung(_s, report);
      end;
    end;
  finally
    regexp.Free;
  end;
end;

function TReadReport_Text._LeseTeilScanBericht_Flotte_bis_Forschung(
  var s: string; report: TScanBericht): Integer;
var
  sg_start, sg_prev, sg: TScanGroup;
  regexp: Tregexpn;
  success: boolean;
  parts: array[TScanGroup] of string;
  p, mlen, elements: integer;
begin
  regexp := Tregexpn.Create;
  try

    // first: split string into parts:
    sg_prev := low(sg);
    sg_start := sg_prev;
    inc(sg_start); // skip ressources
    p := 1;
    mlen := 0;

    for sg := sg_start to high(sg) do
    begin
      regexp.setexpression('[\s]+' + SB_Items[sg][0] + '[\s]');
      
      success := regexp.match(s, p + mlen);
      if (success) then
      begin
        parts[sg_prev] := Copy(s, p, regexp.regexpr.MatchPos[0] - p);
      end
      else
        break;

      sg_prev := sg;
      p := regexp.regexpr.MatchPos[0];
      mlen := regexp.regexpr.MatchLen[0];
    end;
    parts[high(sg)] := Copy(s, p, length(s) - p);
  finally
    regexp.Free;
  end;

  // second: read parts:
  for sg := sg_start to high(sg) do
  begin
    elements := _LeseTeilScanBericht(parts[sg], report, sg);
    if elements = -1 then   //wenn gesamter scanbereich nicht vorhanden
    begin
      report.clearPart(sg);
    end
    else
    begin
      if (elements = 0) then
      begin
        p := Pos(V6_token_no_info_report_part, parts[sg]); // "Wir konnten für diesen Typ keine verlässlichen Daten beim Scannen ermitteln."
        if (p <> 0) then
        begin
          report.clearPart(sg);
        end;
      end;
    end;
  end;

  Result := 0;
end;

function TReadReport_Text.getUnixTimestampFromNamedRegex(
  regexp: Tregexpn): Int64;
var
  dt: TDateTime;
begin
  dt := EncodeDateTime(
    StrToInt(regexp.getsubexpr('y')),
    StrToInt(regexp.getsubexpr('m')),
    StrToInt(regexp.getsubexpr('d')),
    StrToInt(regexp.getsubexpr('h')),
    StrToInt(regexp.getsubexpr('min')),
    StrToInt(regexp.getsubexpr('s')),
    0 //msec
    );

  Result := DateTimeToUnix(dt);
end;

function TReadReport_Text.Read(text: String; reportlist: TReadReportList;
    current_time: TDateTime): integer;
begin
  Result := Read_PreV6(text, reportlist, current_time);
  if (Result = 0) then
  begin
    Result := Read_V6_splitter(text, reportlist, current_time);
  end;
end;

function TReadReport_Text.__insert_moon_or_planet_V6(
  CurElement: THTMLElement; Data: pointer): Boolean;
var
  figure_tag, koords_tag: THTMLElement;
  text_content, pname: string;
  moon: boolean;
  pos_btn: TPlanetPosition;
  regexp: Tregexpn;
begin
  Result := false;
  try
    if (CurElement.TagName = 'div') and
       (CurElement.html_isClass('detail_msg_head')) then
    begin
      koords_tag := CurElement.FindChildTagPath('span:0/a:0/><:0/');
      if (koords_tag = nil) then exit;
      
      text_content := trim_html(koords_tag.Content);
      regexp := Tregexpn.Create;
      try
        regexp.setexpression(V6_regexp_planet_name_pos);
        if (regexp.match(text_content)) then // be sure its the same report!
        begin
          pname := regexp.getsubexpr('name');
          pos_btn.P[0] := StrToInt(regexp.getsubexpr('p0'));
          pos_btn.P[1] := StrToInt(regexp.getsubexpr('p1'));
          pos_btn.P[2] := StrToInt(regexp.getsubexpr('p2'));

          figure_tag := CurElement.FindChildTagPath('span:0/a:0/figure:0');
          moon := (figure_tag <> nil);
          if moon then
          begin
            moon := (figure_tag.html_isClass('planetIcon') and
                    figure_tag.html_isClass('moon'));
          end;

          pos_btn.Mond := moon;
          koords_tag.Content := pname + ' [' + PositionToStrMondPlanet(pos_btn) + ']';
        end;
      finally
        regexp.Free;
      end;
    end;
  except
    // nothing!
  end;
end;

end.
