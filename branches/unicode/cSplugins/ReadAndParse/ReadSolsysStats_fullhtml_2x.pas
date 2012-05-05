unit ReadSolsysStats_fullhtml_2x;

interface

uses
  Inifiles, OGame_Types, creax_html, cpp_dll_interface,
  DateUtils, SysUtils, readsource, parser_types, ReadClassFactory;

const
   HTMLTrimChars = [' ',#$D, #$A, #9];

type
  ThtmlStatRead_betauni = class(TStatsReadClassInterface)
  protected
    function ReadStatType(root_div: THTMLElement;
      var typ: TStatTypeEx): Boolean;
    function CheckForTable(CurElement: THTMLElement; Data: pointer): Boolean;
    function CheckForFormTable(CurElement: THTMLElement; Data: pointer): Boolean;
    function readStatEntry_ally(row_tag: THTMLElement; stattype: TStatTypeEx;
      var statentry: TStatPlayer): Boolean;
    function readStatEntry_player(row_tag: THTMLElement; stattype: TStatTypeEx;
      var statentry: TStatPlayer): Boolean;
  public
    constructor Create(ini: TIniFile);
    destructor Destroy; override;
    function Read(text, html: string; var stats: TStat; var Typ: TStatTypeEx): Boolean;
    function ReadFullHtml(doc_html: THTMLElement; var stats: TStat;
      var Typ: TStatTypeEx): Boolean;
    function ReadFromRS(rs: TReadSource; var Stats: TStat;
      var Typ: TStatTypeEx): Boolean; override;

  end;
  ThtmlSysRead_betauni = class
  protected
    StatusItems_HTML: array[TStati] of string;
    function CheckForTable(CurElement: THTMLElement; Data: pointer): Boolean;
    function CheckStatusSpans(CurElement: THTMLElement; Data: pointer): Boolean;
    function _read_HTMLStatusStr(s: string): TStatus;
    function CheckForRankElement(CurElement: THTMLElement;
      Data: pointer): Boolean;
    function ReadRow_PlanetInfo(CurElement: THTMLElement;
      Data: pointer): Boolean;
  public
    constructor Create(ini: TIniFile);
    function Read(text, html: string; var solsys: TSystemCopy): Boolean;
    function ReadFullHTML(doc_html: THTMLElement;
      var solsys: TSystemCopy): Boolean;
    procedure Test(text, html: string;
      var solsys: TSystemCopy);
    function ReadFromRS(rs: TReadSource; var solsys: TSystemCopy): Boolean;
  end;

implementation

uses StrUtils;

function extractPlayerIdFromSendMSGUrl(url: string): int64;
var s: string;
    p: integer;
begin
  s := url;
  p := Pos('&amp;to=', s);
  s := copy(s,p+8, PosEx('&', s, p+1)-8-p);
  Result := StrToIntDef(s, -1);
end;

function ReadInt(s: string; p: integer; tsep: Boolean = True): integer;
//Spezial for HTML!
begin
  if tsep then
    Result := ReadIntEx(s,p,ot_tousandsseperator, HTMLTrimChars)
  else Result := ReadIntEx(s,p,'', HTMLTrimChars);
end;

procedure FindAndReplace(substring: string; var s: string; replace: string);
var p: integer;
begin
  p := pos(substring, s);
  while (p > 0) do
  begin
    s := copy(s, 1, p-1) + replace + copy(s, p+length(substring), high(integer));
    p := Pos(substring, s);
  end;
end;

function Trim(s: String): String;
//Spezial for HTML!
var p: integer;
begin
  FindAndReplace(#$D#$A, s, '');
  FindAndReplace('&nbsp;', s, ' ');

  p := pos(#160, s);
  while (p > 0) do
  begin
    s[p] := ' ';
    p := pos(#160, s);
  end;
  Result := sysutils.Trim(s);
end;

function ThtmlStatRead_betauni.ReadStatType(root_div: THTMLElement;
  var typ: TStatTypeEx): Boolean;
var form, tag: THTMLElement;
    who_l: array[TStatNameType] of string[255];
    typ_l: array[TStatPointType] of string[255];
    sn: TStatNameType;
    sp: TStatPointType;
begin
  //Result ist immer False, da kein bestimmtes element gefunden werden soll!
  Result := False;
  form := HTMLFindRoutine_NameAttribute(root_div, 'form', 'id', 'send');
  if form = nil then
    Exit;

  typ.NameType := sntPlayer;
  typ.PointType := sptPoints;

  who_l[sntPlayer] := 'player';
  who_l[sntAlliance] := 'alliance';
  typ_l[sptPoints] := 'points';
  typ_l[sptFleet] := 'fleet';
  typ_l[sptResearch] := 'research';

  for sn := sntPlayer to sntAlliance do
  begin
    tag := HTMLFindRoutine_NameAttribute(form, 'a', 'id', who_l[sn]);
    if tag = nil then
      Exit;

    if pos('active', tag.AttributeValue['class']) > 0 then
    begin
      typ.NameType := sn;
      break;
    end;
  end;

  for sp := sptPoints to sptResearch do
  begin
    tag := HTMLFindRoutine_NameAttribute(form, 'a', 'id', typ_l[sp]);
    if tag = nil then
      Exit;

    if pos('active', tag.AttributeValue['class']) > 0 then
    begin
      typ.PointType := sp;
      break;
    end;
  end;

  Result := true;
end;

function ThtmlStatRead_betauni.CheckForTable(CurElement: THTMLElement;
  Data: pointer): Boolean;
var body: THTMLElement;
    rc: Integer;
begin
  Result := False;
  with CurElement do
  begin
    if (TagType = pttStartTag)and
       (TagName = 'table')and
       (ParentElement.TagName <> 'form')and
       (ReadInt(AttributeValue['width'],1) > 500) then
    begin
      body := FindChildTag('tbody');
      THTMLElement(Data^) := body;
      if body <> nil then
      begin
        rc := body.ChildNameCount('tr');
        Result := (rc <= 101);
      end;
    end;
  end;
end;

function ThtmlStatRead_betauni.CheckForFormTable(CurElement: THTMLElement;
  Data: pointer): Boolean;
var body: THTMLElement;
    rc: Integer;
begin
  Result := False;
  with (CurElement) do
  begin
    if (TagType = pttStartTag)and
       (TagName = 'table')and
       (ParentElement.TagName = 'form')and
       (ReadInt(AttributeValue['width'],1) > 500) then
    begin
      body := FindChildTag('tbody');
      THTMLElement(Data^) := body;
      if body <> nil then
      begin
        rc := body.ChildNameCount('tr');
        Result := (rc = 2);
      end;
    end;
  end;
end;

constructor ThtmlStatRead_betauni.Create(ini: TIniFile);
begin
  inherited Create;
end;

destructor ThtmlStatRead_betauni.Destroy;
begin
  inherited;
end;

function ThtmlStatRead_betauni.Read(text, html: string; var stats: TStat;
  var Typ: TStatTypeEx): Boolean;
var doc_html: THTMLElement;
begin
  doc_html := THTMLElement.Create(nil,'root');
  try
    doc_html.ParseHTMLCode(html);
    Result := ReadFullHtml(doc_html,stats,Typ);
  except
    Result := false;
  end;
  doc_html.Free;
end;

function findfirstnumericchar(s: string; pos: Integer = 1): Integer;
var l: integer;
begin
  Assert(pos > 0, 'Position must be > 0!');

  Result := pos;
  l := length(s);
  while (Result <= l)and(not(s[Result] in ['0'..'9'])) do
    inc(Result);

  if Result > l then Result := 0;
end;

function ThtmlSysRead_betauni.CheckForTable(CurElement: THTMLElement;
  Data: pointer): Boolean;
begin
  Result := False;
  with (CurElement) do
  begin
    if (TagType = pttStartTag)and
       (TagName = 'table')and
       (AttributeValue['id'] = 'galaxytable') then
    begin
      THTMLElement(Data^) := FindChildTag('tbody');
      Result := true;
    end;
  end;
end;

function ThtmlSysRead_betauni._read_HTMLStatusStr(s: string): TStatus;
var i: TStati;
begin
  Result := [];
  for i := low(i) to high(i) do
    if (pos(StatusItems_HTML[i],s) > 0) then
    begin
      include(Result,i);
    end;
end;

function ThtmlSysRead_betauni.CheckStatusSpans(CurElement: THTMLElement;
  Data: pointer): Boolean;
begin
  //Result ist immer False, da kein bestimmtes element gefunden werden soll!

  //BETAUNI: THIS FUNCTION IS NOT IN USE!!!
  Result := False;
  {with (CurElement) do
  begin
    if (TagName = 'span') then
    begin
      _StrToStatus_HTML(AttributeValue['class'],TStatus(Data^));
    end;
  end; }
end;

constructor ThtmlSysRead_betauni.Create(ini: TIniFile);
var i: integer;
begin
  inherited Create;
  for i := low(TStati) to high(TStati) do
  begin
    StatusItems_HTML[i] := ini.ReadString('html','status'+IntToStr(i),'--error--')
  end;
end;

function ThtmlSysRead_betauni.Read(text, html: string;
  var solsys: TSystemCopy): Boolean;
var doc_html: THTMLElement;
begin
  doc_html := THTMLElement.Create(nil,'root');
  try
    doc_html.ParseHTMLCode(html);
    Result := ReadFullHTML(doc_html,solsys);
  except
    Result := False;
  end;
  doc_html.Free;
end;

function ThtmlSysRead_betauni.ReadFromRS(rs: TReadSource;
  var solsys: TSystemCopy): Boolean;
begin
  try
    Result := ReadFullHTML(rs.GetHTMLRoot(),solsys);
    solsys.Time_u := rs.GetServerTime;
  except
    Result := False;
  end;
end;

function ThtmlSysRead_betauni.ReadFullHTML(doc_html: THTMLElement;
  var solsys: TSystemCopy): Boolean;
var tbody, tag, tag_row, tag_pos, tag_a: THTMLElement;
    table: THTMLTable;
    i, row_nr, r_nr, p, j: Integer;
    got_koords: boolean;
    s: string;
begin
  Result := false;

  //Clear Solsys
  FillChar(solsys, sizeof(solsys), 0);

  //Galaxie-Table finden:
  table := THTMLTable(doc_html.FindTagRoutine(CheckForTable, @tbody));
  if table <> nil then
  begin
    got_koords := false;

    {//Galaxie auslesen:
    tag := HTMLFindRoutine_NameAttribute(doc_html, 'input', 'id', 'galaxy_input');
    //tag := table.FindChildTagPath('tbody:0/tr:0/td:0/div:0/form:0/div:0/div:0/input:0');
    if tag = nil then
      raise Exception.Create('ThtmlSysRead_betauni.ReadFullHTML: '+
                             'Galaxy-<input> not found!');
    solsys.System.p[0] := StrToInt(tag.AttributeValue['value']);
    //Sonnensystem auslesen:
    tag := HTMLFindRoutine_NameAttribute(doc_html, 'input', 'id', 'system_input');
    //tag := table.FindChildTagPath('tbody:0/tr:0/td:0/div:0/form:0/div:1/div:0/input:0');
    if tag = nil then
      raise Exception.Create('ThtmlSysRead_betauni.ReadFullHTML: '+
                             'Solsys-<input> not found!');
    solsys.System.p[1] := StrToInt(tag.AttributeValue['value']);
    solsys.System.P[2] := 1;
    solsys.System.Mond := false;   }


    // try to find the "cshelper"-tag:
    if (table.ParentElement <> nil) then
    begin
      tag := table.ParentElement.FindChildTag('cshelper');
      if (tag <> nil) then
      begin
        solsys.System.P[0] := StrToIntDef(tag.AttributeValue['galaxy'], 0);
        solsys.System.P[1] := StrToIntDef(tag.AttributeValue['system'], 0);
        solsys.System.P[2] := 1;
        solsys.System.Mond := false;
        got_koords := ValidPosition(solsys.System); // when this position is valid -> success!
      end;
    end;

    if tbody <> nil then
      tbody.ChildsMove(table);

    //Reihen Abarbeiten
    row_nr := 1;
    i := 0;
    while (i < table.ChildCount)and(row_nr <= max_planeten) do
    begin
      tag_row := table.ChildElements[i];
      if (tag_row.TagName = 'tr')and
         (tag_row.AttributeValue['class'] = 'row') then
      begin
        //Lese Planeten NR
        tag := tag_row.FindChildTagPath('td:1');
        if tag <> nil then
        begin
          r_nr := ReadInt(trim(tag.FullTagContent),1);
          if r_nr = row_nr then
          begin
            // clear
            solsys.Planeten[row_nr].PlayerId := -1;
            solsys.Planeten[row_nr].AllyId := -1;

            //Lese Zeile Ein:
            tag_row.FindTagRoutine(ReadRow_PlanetInfo, @solsys.Planeten[row_nr]);

            // Suche nach Sonnensystem-Koordinaten:
            if (not got_koords)and(solsys.Planeten[row_nr].PlanetName <> '') then
            begin
              tag_pos := HTMLFindRoutine_NameAttribute(tag_row, 'span', 'id', 'pos-planet');
              if tag_pos <> nil then
              begin
                s := tag_pos.FullTagContent;
                p := pos('[',s);
                p := ReadPosOrTime(tag_pos.FullTagContent, p+1, solsys.System);
                got_koords := (p>0);
                solsys.System.P[2] := 1;
                solsys.System.Mond := false;
              end;
            end;

            // Suche nach "Umsiedeln"-Tags auch für koords:
            if (not got_koords)and(solsys.Planeten[row_nr].Player = '') then
            begin
              tag_pos := HTMLFindRoutine_NameAttribute(tag_row, 'td', 'class', 'planetname1');
              if tag_pos <> nil then
              begin
                for j := 0 to 1 do
                begin
                  tag_a := tag_pos.FindChildTag('a', j);
                  if (tag_a <> nil) and
                     (pos('planetMoveDefault',tag_a.AttributeValue['class']) > 0) then
                  begin
                    s := tag_a.AttributeValue['onclick'];
                    p := pos('galaxy=',s);
                    if p > 0 then
                    begin
                      solsys.System.P[0] := ReadInt(s,p+7);
                      p := pos('system=',s);

                      got_koords := (p>0);
                      if got_koords then
                      begin
                        solsys.System.P[1] := ReadInt(s,p+7);
                        solsys.System.P[2] := 1;
                        solsys.System.Mond := false;
                      end;
                    end;
                  end;
                  if got_koords then
                    break;
                end;
              end;
            end;
              

            inc(row_nr);
          end;
        end;
      end;
      inc(i);
    end;

    solsys.Time_u := DateTimeToUnix(Now)-1;
    Result := got_koords;
  end;
end;

function ThtmlSysRead_betauni.ReadRow_PlanetInfo(CurElement: THTMLElement;
  Data: pointer): Boolean;
var
  row: PSystemPlanet;
  p: integer;
  attr_class, s: string;
  tag_, tag_b : THTMLElement;
begin
  Result := False; //Nur durchlaufen!!

  if CurElement.TagName = 'td' then
  begin
    row := Data;
    attr_class := CurElement.AttributeValue['class'];

    if attr_class = 'position' then
    begin
      // wird ebene höher ausgelsen
    end
    //---------------------------------------------PLANETENNAME-----------------
    else
    if attr_class = 'planetname' then
    begin
      s := CurElement.FullTagContent;
      p := pos('(',s);
      //Aktivitäten := Copy(s,p+1,high(Integer));
      if p > 0 then
        s := copy(s,1,p-1);
      row^.PlanetName := trim(s);
      //------------------AKTIVITÄT--------------------------
      tag_ := CurElement.FindChildTag('span');
      if tag_ <> nil then
      begin
        if tag_.AttributeValue['class'] = 'undermark' then
        begin
          s := Trim(tag_.FullTagContent);
          row^.Activity := StrToIntDef(s, 0)*60; // seconds!
          if (row^.Activity = 0)and(s = '*') then
          begin
            row^.Activity := -15; // (*) -> activity in last 15min
          end;
        end;
      end;
    end
    //-------------------------------------------MOND---------------------------
    else
    if attr_class = 'moon' then
    begin
      //Monddaten einlesen
      row^.MondTemp := 0;   //TODO: TEMPERATUR?
      tag_ := HTMLFindRoutine_NameAttribute(CurElement,'span','id','moonsize');
      if tag_ <> nil then
      begin
        row^.MondSize := ReadInt(tag_.FullTagContent, 1);
      end
      else
      begin  // alternative möglichkeit die Mondgroesse einzulesen
        tag_ := CurElement.FindChildTagPath('a:0/img:0/');
        if tag_ <> nil then
        begin
          row^.MondSize := ReadIntEx(tag_.AttributeValue['alt'], 1, 'Moon: ');
          if (row^.MondSize = 0) then
          begin
            row^.MondSize := 1; // das Vorhandensein dieses Bildes beweist die Existenz eines Mondes... halt ohne Info über die Größe
          end;
        end;
      end;
    end
    //-------------------------------------------TRÜMMERFELD--------------------
    else
    if attr_class = 'debris' then
    begin
      tag_ := HTMLFindRoutine_NameAttribute(CurElement,'li','class','debris-content');
      if tag_ <> nil then
      begin
        //Metall:
        s := tag_.FullTagContent;
        p := findfirstnumericchar(s);
        row^.TF[0] := ReadInt(s,p);
        //Kristall:
        tag_ := tag_.ParentElement.FindChildTag('li',tag_.TagNameNr+1);
        if tag_ <> nil then
        begin
          s := tag_.FullTagContent;
          p := findfirstnumericchar(s);
          row^.TF[1] := ReadInt(s,p);
        end;
      end;
    end
    //-------------------------------------------SPIELERNAME--------------------
    else
    if copy(attr_class,1,10) = 'playername' then
    begin
      // remove status
      tag_ := HTMLFindRoutine_NameAttribute(CurElement,'span','class','status');
      if tag_ <> nil then
        tag_.ClearChilds;

      // remove antigame rank 1.27
      tag_ := HTMLFindRoutine_NameAttribute(CurElement,'a','class','anti_rank');
      if tag_ <> nil then
        tag_.ClearChilds;
      // remove antigame rank 1.28
      tag_ := HTMLFindRoutine_NameAttribute(CurElement,'span','class','anti_rank');
      if tag_ <> nil then
        tag_.ClearChilds;

      tag_ := HTMLFindRoutine_NameAttribute(CurElement,'div','id','TTWrapper');
      if tag_ <> nil then
      begin
        tag_b := tag_.FindChildTagPath('div:0/div:0/table:0/tbody:0/tr:0/th:0');
        if tag_b <> nil then
        begin
          s := trim(tag_b.FullTagContent);
          p := pos(' ',s);
          if p > 0 then
            row^.Player := copy(s,p+1,9999);
        end;
        tag_.ClearChilds;
      end;

      if row^.Player = '' then
      begin
        row^.Player := trim(CurElement.FullTagContent);
      end;

        //PLAYER ID: tag_.AttributeValue['rel']  (rel="#playerXXXXX")

      //---------------------STATUS------------------
      row^.Status := _read_HTMLStatusStr(attr_class);
    end
    //-------------------------------------------ALLIANZ------------------------
    else
    if attr_class = 'allytag' then
    begin
      // name
      tag_ := CurElement.FindChildTagPath('span:0/><:0');
      if tag_ <> nil then
      begin
        row^.Ally := trim(tag_.Content);

        // id
        tag_ := tag_.ParentElement;
        row^.AllyId := ReadInt(tag_.AttributeValue['rel'], 10);

      end
      else
        row^.Ally := '';
    end
    //-------------------------------------------AKTIONEN-----------------------
    else
    if attr_class = 'action' then
    begin
      tag_ := HTMLFindRoutine_NameAttribute_Value_Within(
        CurElement, 'a', 'href', '/game/index.php?page=writemessage&amp;');
      if tag_ <> nil then
      begin
        row^.PlayerId := extractPlayerIdFromSendMSGUrl(
          tag_.AttributeValue['href']);
      end;
    end

  end;
end;

function ThtmlStatRead_betauni.ReadFromRS(rs: TReadSource; var Stats: TStat;
  var Typ: TStatTypeEx): Boolean;
begin
  try
    Result := ReadFullHtml(rs.GetHTMLRoot, Stats, Typ);
  except
    Result := False;
  end;
end;

function ThtmlStatRead_betauni.ReadFullHtml(doc_html: THTMLElement; var stats: TStat;
  var Typ: TStatTypeEx): Boolean;
var tbody: THTMLElement;
    root_div, tag: THTMLElement;
    table: THTMLTable;
    s: string;
    i, first, p: Integer;
begin
  Result := False;
  //Leeren:
  FillChar(stats,SizeOf(Stats),0);


  //Find Root DIV
  root_div := HTMLFindRoutine_NameAttribute(doc_html,'div','class','contentbox');
  if root_div <> nil then
  begin

    //Datum + Uhrzeit --------------------------------------------------------
    tag := root_div.FindChildTagPath('div:0');
    if tag = nil then Exit;

    s := tag.FullTagContent;
    p := findfirstnumericchar(s);
    if p > 0 then
    begin
      {p := ReadPosOrTime(s,p,timepos);
      y := timepos.P[0];
      m := timepos.P[1];
      d := timepos.P[2];
      p := ReadPosOrTime(s,p+2,timepos);
      h := timepos.P[0];
      min := timepos.P[1];

      stats.Time_u := DateTimeToUnix(EncodeDateTime(y,m,d,h,min,0,0));}
      stats.Time_u := DateTimeToUnix(StrToDateTime(copy(s,p,length(s)-p)));
    end;

    //Statistiktyp -----------------------------------------------------------
    if not ReadStatType(root_div,Typ) then Exit;
  end else Exit;

  table := THTMLTable(HTMLFindRoutine_NameAttribute(root_div,'table','id','ranks'));
  if table <> nil then
  begin
    tbody := table.FindChildTag('tbody');
    if tbody <> nil then
      tbody.ChildsMove(table);

    first := ReadInt(table.Cells[1,0].FullTagContent,1);
    stats.first := first;
    stats.count := 0;
    for i := 0 to 99 do
    begin
      try
        s := table.Cells[i+1,0].FullTagContent;
        if ReadInt(s,1) <> i+first then
          break
        else
        begin
          case (Typ.NameType) of
            sntPlayer: if not readStatEntry_player(table.Rows[i+1],Typ,stats.Stats[i]) then
                          Exit;
            sntAlliance: if not readStatEntry_ally(table.Rows[i+1],Typ,stats.Stats[i]) then
                            Exit;
          end;
          inc(stats.count);
        end;
      except
        break;
      end;
    end;
  end else Exit;

  Result := True;
end;

function ThtmlStatRead_betauni.readStatEntry_ally(row_tag: THTMLElement; stattype: TStatTypeEx;
  var statentry: TStatPlayer): Boolean;
var tag_cell, atag: THTMLElement;
    s: string;
    p: integer;
begin
  Result := False;
  statentry.NameId := -1;

  tag_cell := row_tag.FindChildTag('td',1);
  if tag_cell = nil then Exit;
  s := tag_cell.FullTagContent;
  statentry.Name := trim(s);

  // --- extract allyid
  atag := tag_cell.FindChildTag('a',0);
  if atag <> nil then
  begin
    s := atag.AttributeValue['href'];
    p := pos('?allyid=', s);
    s := copy(s, p+8, 99999);
    statentry.NameId := StrToIntDef(s, -1);
  end;
  // --- end

  tag_cell := row_tag.FindChildTag('td',3);
  if tag_cell = nil then Exit;
  statentry.Punkte := readint(trim(tag_cell.FullTagContent),1);

  tag_cell := row_tag.FindChildTag('td',4);
  if tag_cell = nil then Exit;
  statentry.Elemente := readint(trim(tag_cell.FullTagContent),1);

  Result := True;
end;

function ThtmlStatRead_betauni.readStatEntry_player(row_tag: THTMLElement; stattype: TStatTypeEx;
  var statentry: TStatPlayer): Boolean;
var i: integer;
    tag_cell, tag: THTMLElement;
    tag_class: string;
    b_name, b_score: Boolean;
begin
  b_name := false;
  b_score := false;
  statentry.NameId := -1;

  for i := 0 to row_tag.ChildCount - 1 do
    begin
      tag_cell := row_tag.ChildElements[i];
      if (tag_cell.TagName = 'td') then
      begin
        tag_class := tag_cell.AttributeValue['class'];
        if tag_class = 'position' then
        begin
           //Eine Ebene höher!
        end
        //Name -------------------------------------------------------------
        else
        if tag_class = 'name' then
        begin
          if stattype.NameType = sntPlayer then
          begin
            //Suche Ally-Tag:
            tag := HTMLFindRoutine_NameAttribute(tag_cell,'span','class','ally-tag');
            if tag <> nil then
            begin
              //Ally-Tag einlesen
              statentry.Ally := trim(tag.FullTagContent);
              //Ally-Tag "leeren"
              tag.ClearChilds;
              tag.Content := '';
            end
            else
            begin
              // versuche Ally tag aus erstem <a> element zu lesen
              if tag_cell.ChildNameCount('a') = 2 then
              begin
                tag := tag_cell.FindChildTag('a',0);
                statentry.Ally := trim(tag.FullTagContent);
                tag.ClearChilds;
                tag.Content := '';
              end;
            end;
          end;

          statentry.Name := trim(tag_cell.FullTagContent);
          b_name := true;
        end
        else
        if tag_class = 'score' then
        begin
          statentry.Punkte := ReadInt(Trim(tag_cell.FullTagContent),1);
          b_score := true;
        end
        else
        if tag_class = 'sendmsg' then
        begin
          tag := tag_cell.FindChildTagPath('a:0'); // nachricht schreiben
          if tag <> nil then
          begin
            statentry.NameId := extractPlayerIdFromSendMSGUrl(
              tag.AttributeValue['href']);
          end;
        end;
      end;
      
    end;
  {
  //Ally oder Mitglieder ---------------------------------------------
  if Typ.NameType = sntPlayer then
    statentry.Ally := trim(table.Cells[i+1,3].FullTagContent)
  else statentry.Mitglieder := ReadInt
         (table.Cells[i+1,3].FullTagContent,1);
  //Punkte -----------------------------------------------------------
  statentry.Punkte := ReadInt(table.Cells[i+1,4].FullTagContent,1);  }

  Result := b_name and b_score;
end;

function ThtmlSysRead_betauni.CheckForRankElement(CurElement: THTMLElement;
  Data: pointer): Boolean;
begin
  with (CurElement) do
  begin
    Result := (TagType = pttStartTag)and
              (TagName = 'span')and
              (
               (AttributeValue['class'] = 'rank') or
               (copy(AttributeValue['style'], 1, 7) = 'color: ')
               //((length(FullTagContent) > 0)and(FullTagContent[1] = '#'))
              );
  end;
end;

procedure ThtmlSysRead_betauni.Test(text, html: string;
  var solsys: TSystemCopy);
var doc_html: THTMLElement;
begin
  doc_html := THTMLElement.Create(nil,'root');
  try
    doc_html.ParseHTMLCode(html);
  finally
    doc_html.free;
  end;
end;

end.
 