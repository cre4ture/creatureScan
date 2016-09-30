unit ReadSolsys_fullhtml_trunc;

interface

uses
  Inifiles, OGame_Types, creax_html, cpp_dll_interface,
  DateUtils, SysUtils, readsource, parser_types, ReadClassFactory,
  cshelper_tag_reader;

const
   HTMLTrimChars = [' ',#$D, #$A, #9];

type
  TRowDataHelper = record
    row: PSystemPlanet;
    meta: TOGameMetaInfo;
  end;
  ThtmlSysRead = class(TSolsysReadClassInterface)
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
    function ReadFromRS(rs: TReadSource; var solsys: TSystemCopy): Boolean; override;
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

function ThtmlSysRead.CheckForTable(CurElement: THTMLElement;
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

function ThtmlSysRead._read_HTMLStatusStr(s: string): TStatus;
var i: TStati;
begin
  Result := [];
  for i := low(i) to high(i) do
    if (pos(StatusItems_HTML[i],s) > 0) then
    begin
      include(Result,i);
    end;
end;

function ThtmlSysRead.CheckStatusSpans(CurElement: THTMLElement;
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

constructor ThtmlSysRead.Create(ini: TIniFile);
var i: integer;
begin
  inherited Create;
  for i := low(TStati) to high(TStati) do
  begin
    StatusItems_HTML[i] := ini.ReadString('html','status'+IntToStr(i),'--error--')
  end;
end;

function ThtmlSysRead.Read(text, html: string;
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

function ThtmlSysRead.ReadFromRS(rs: TReadSource;
  var solsys: TSystemCopy): Boolean;
begin
  try
    Result := ReadFullHTML(rs.GetHTMLRoot(),solsys);
    solsys.Time_u := rs.GetServerTime;
  except
    Result := False;
  end;
end;

function ThtmlSysRead.ReadFullHTML(doc_html: THTMLElement;
  var solsys: TSystemCopy): Boolean;
var tbody, tag, tag_row, tag_pos, tag_a: THTMLElement;
    table: THTMLTable;
    i, row_nr, r_nr, p: Integer;
    got_koords: boolean;
    s: string;
    meta: TOGameMetaInfo;
    row_data: TRowDataHelper;
begin
  Result := false;

  // get own player informations:
  meta := getOGameMeta(doc_html);

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
    if true and (table.ParentElement <> nil) then
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
         (tag_row.html_isClass('row')) then
      begin
        //Lese Planeten NR
        //tag := tag_row.FindChildTagPath('td:1');
        tag := HTMLFindRoutine_NameAndClass(tag_row, 'td', 'position');
        if tag <> nil then
        begin
          r_nr := ReadInt(trim(tag.FullTagContent),1);
          if r_nr = row_nr then
          begin
            // clear
            solsys.Planeten[row_nr].PlayerId := 0;
            solsys.Planeten[row_nr].AllyId := 0;

            //Lese Zeile Ein:
            row_data.row := @solsys.Planeten[row_nr];
            row_data.meta := meta;
            tag_row.FindTagRoutine(ReadRow_PlanetInfo, @row_data);

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
            if (not got_koords) then
            begin
              tag_a := HTMLFindRoutine_NameAndClass(tag_row, 'a', 'planetMoveIcons');
              if tag_a <> nil then
              begin
                s := tag_a.AttributeValue['href'];        // try href
                s := s + tag_a.AttributeValue['onclick']; // and on click to find params
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

function ThtmlSysRead.ReadRow_PlanetInfo(CurElement: THTMLElement;
  Data: pointer): Boolean;
var
  row: PSystemPlanet;
  p: integer;
  attr_class, s: string;
  tag_, tag_b : THTMLElement;
  row_data: ^TRowDataHelper;
begin
  Result := False; //Nur durchlaufen!!

  row_data := Data;

  if CurElement.TagName = 'td' then
  begin
    row := row_data^.row;
    attr_class := CurElement.AttributeValue['class'];

    if CurElement.html_isClass('position') then
    begin
      // wird ebene höher ausgelsen
    end
    //---------------------------------------------PLANETENNAME-----------------
    else
    if CurElement.html_isClass('planetname') then
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
        if tag_.html_isClass('undermark') then
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
    if CurElement.html_isClass('moon') then
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
        end
        else
        begin
          // ogame 6.3.0:
          tag_ := HTMLFindRoutine_NameAndClass(CurElement, 'div', 'moon_a');
          if (tag_ <> nil) then
          begin
            row^.MondSize := 1; // das Vorhandensein dieses Bildes beweist die Existenz eines Mondes... halt ohne Info über die Größe
          end;
        end;
      end;
    end
    //-------------------------------------------TRÜMMERFELD--------------------
    else
    if CurElement.html_isClass('debris') then
    begin
      tag_ := HTMLFindRoutine_NameAndClass(CurElement,'li','debris-content');
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
    if CurElement.html_isClass('playername') then
    begin
      // remove status
      tag_ := HTMLFindRoutine_NameAndClass(CurElement,'span','status');
      if tag_ <> nil then
        tag_.ClearChilds;

      // remove antigame rank 1.27
      tag_ := HTMLFindRoutine_NameAndClass(CurElement,'a','anti_rank');
      if tag_ <> nil then
        tag_.ClearChilds;
      // remove antigame rank 1.28
      tag_ := HTMLFindRoutine_NameAndClass(CurElement,'span','anti_rank');
      if tag_ <> nil then
        tag_.ClearChilds;

      // search full player name in ToolTip
      tag_b := CurElement.FindChildTagPath('div:0/h1:0/span:0/');
      if tag_b <> nil then
      begin
        s := trim(tag_b.FullTagContent);
        row.Player := s;
      end;

      // If ToolTip player name was not found, take name from table:
      if row^.Player = '' then
      begin
        // trim honorrank
        tag_ := HTMLFindRoutine_NameAndClass(CurElement, 'span', 'honorRank');
        if (tag_ <> nil) then tag_.ClearChilds;
        // trim tooltips
        tag_ := HTMLFindRoutine_NameAndClass(CurElement, 'div', 'htmlTooltip');
        if (tag_ <> nil) then tag_.ClearChilds;

        row^.Player := trim(CurElement.FullTagContent);
      end;

      if CurElement.ChildNameCount('a') = 0 then
      begin
        row^.PlayerId := row_data^.meta.playerid;
      end;

      //---------------------STATUS------------------
      row^.Status := _read_HTMLStatusStr(attr_class);
    end
    //-------------------------------------------ALLIANZ------------------------
    else
    if CurElement.html_isClass('allytag') then
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
    if CurElement.html_isClass('action') then
    begin
      tag_ := HTMLFindRoutine_NameAttribute_Value_Within(
        CurElement, 'a', 'href', '/game/index.php?page=writemessage&amp;');
      if tag_ <> nil then
      begin
        row^.PlayerId := extractPlayerIdFromSendMSGUrl(
          tag_.AttributeValue['href']);
      end
      else
      begin
        // for ogame 6.3.0:
        tag_ := HTMLFindRoutine_NameAndClass(CurElement, 'a', 'sendMail');
        if tag_ <> nil then
        begin
          row^.PlayerId := ReadInt(tag_.AttributeValue['data-playerid'], 1, false);
        end
      end;
    end

  end;
end;

function ThtmlSysRead.CheckForRankElement(CurElement: THTMLElement;
  Data: pointer): Boolean;
begin
  with (CurElement) do
  begin
    Result := (TagType = pttStartTag)and
              (TagName = 'span')and
              (
               (html_isClass('rank')) or
               (copy(AttributeValue['style'], 1, 7) = 'color: ')
               //((length(FullTagContent) > 0)and(FullTagContent[1] = '#'))
              );
  end;
end;

procedure ThtmlSysRead.Test(text, html: string;
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
 