unit ReadSolsysStats_fullhtml_betauni;

interface

uses
  Inifiles, OGame_Types, html, parser, DateUtils, SysUtils, readsource{, Dialogs{};

const
   HTMLTrimChars = [' ',#$D, #$A, #9];

type
  ThtmlStatRead_betauni = class
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
      var Typ: TStatTypeEx): Boolean;

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
var s: string;
    tag: THTMLElement;
begin
  //Result ist immer False, da kein bestimmtes element gefunden werden soll!
  Result := False;
  tag := HTMLFindRoutine_NameAttribute(root_div, 'input', 'id', 'who');
  if tag = nil then
    Exit;

  s := tag.AttributeValue['value'];
  if s = 'player' then
    typ.NameType := sntPlayer
  else
  if s = 'ally' then
    typ.NameType := sntAlliance
  else Exit;

  tag := HTMLFindRoutine_NameAttribute(root_div, 'input', 'id', 'type');
  if tag = nil then
    Exit;

  s := tag.AttributeValue['value'];
  if (s = 'ressources')or(s = '') then  //default "" bei punkten
    typ.PointType := sptPoints
  else
  if s = 'fleet' then
    typ.PointType := sptFleet
  else
  if s = 'research' then
    typ.PointType := sptResearch
  else Exit;

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
var tbody, tag, tag_row, tag_pos: THTMLElement;
    table: THTMLTable;
    i, row_nr, r_nr, p: Integer;
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
                tag_pos := tag_pos.FindChildTag('a');
                if (tag_pos <> nil) and
                   (pos('planetMoveDefault',tag_pos.AttributeValue['class']) > 0) then
                begin
                  s := tag_pos.AttributeValue['onclick'];
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
      {tag_ := CurElement.FindChildTag('span');
      if tag_ <> nil then
      begin
        if tag_.AttributeValue['class'] = 'undermark' then
        begin
          //Letzte Aktivität = IntToStr(tag_.Content);
        end;
      end;}
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
      tag_ := HTMLFindRoutine_NameAttribute(CurElement,'span','class','status');
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
      tag_ := CurElement.FindChildTagPath('span:0/><:0');
      if tag_ <> nil then
      begin
        row^.Ally := trim(tag_.Content);
      end
      else
        row^.Ally := '';
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
var tag_cell: THTMLElement;
begin
  Result := False;

  tag_cell := row_tag.FindChildTag('td',1);
  if tag_cell = nil then Exit;
  statentry.Name := trim(tag_cell.FullTagContent);

  tag_cell := row_tag.FindChildTag('td',3);
  if tag_cell = nil then Exit;
  statentry.Punkte := readint(trim(tag_cell.FullTagContent),1);

  tag_cell := row_tag.FindChildTag('td',4);
  if tag_cell = nil then Exit;
  statentry.Mitglieder := readint(trim(tag_cell.FullTagContent),1);

  Result := True;
end;

function ThtmlStatRead_betauni.readStatEntry_player(row_tag: THTMLElement; stattype: TStatTypeEx;
  var statentry: TStatPlayer): Boolean;
var i: integer;
    tag_cell, tag: THTMLElement;
    s: string;
    b_name, b_score: Boolean;
begin
  b_name := false;
  b_score := false;

  for i := 0 to row_tag.ChildCount - 1 do
    begin
      tag_cell := row_tag.ChildElements[i];
      if (tag_cell.TagName = 'td') then
      begin
        s := tag_cell.AttributeValue['class'];
        if s = 'position' then
        begin
           //Eine Ebene höher!
        end
        //Name -------------------------------------------------------------
        else
        if s = 'name' then
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
        if s = 'score' then
        begin
          statentry.Punkte := ReadInt(Trim(tag_cell.FullTagContent),1);
          b_score := true;
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
 