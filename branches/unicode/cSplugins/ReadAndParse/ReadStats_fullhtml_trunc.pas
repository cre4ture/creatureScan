unit ReadStats_fullhtml_trunc;

interface

uses
  Inifiles, OGame_Types, creax_html, cpp_dll_interface,
  DateUtils, SysUtils, readsource, parser_types, ReadClassFactory,
  cshelper_tag_reader;

const
   HTMLTrimChars = [' ',#$D, #$A, #9];

type
  ThtmlStatRead = class(TStatsReadClassInterface)
  protected
    function ReadStatType(root_div: THTMLElement;
      var typ: TStatTypeEx): Boolean;
    function CheckForTable(CurElement: THTMLElement; Data: pointer): Boolean;
    function CheckForFormTable(CurElement: THTMLElement; Data: pointer): Boolean;
    function readStatEntry_ally(row_tag: THTMLElement; stattype: TStatTypeEx;
      var statentry: TStatPlayer; const meta: TOGameMetaInfo): Boolean;
    function readStatEntry_player(row_tag: THTMLElement; stattype: TStatTypeEx;
      var statentry: TStatPlayer; const meta: TOGameMetaInfo): Boolean;
  public
    constructor Create(ini: TIniFile);
    destructor Destroy; override;
    function Read(text, html: string; var stats: TStat; var Typ: TStatTypeEx): Boolean;
    function ReadFullHtml(doc_html: THTMLElement; var stats: TStat;
      var Typ: TStatTypeEx): Boolean;
    function ReadFromRS(rs: TReadSource; var Stats: TStat;
      var Typ: TStatTypeEx): Boolean; override;

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

function ReadInt(s: string; p: integer; tsep: Boolean = True): Int64;
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

function ThtmlStatRead.ReadStatType(root_div: THTMLElement;
  var typ: TStatTypeEx): Boolean;
var form, tag: THTMLElement;
    who_l: array[TStatNameType] of string[255];
    typ_l: array[TStatPointType] of string[255];
    sn: TStatNameType;
    sp: TStatPointType;
    snb, spb: boolean;
    i: integer;
begin
  //Result ist immer False, da kein bestimmtes element gefunden werden soll!
  Result := False;
  form := HTMLFindRoutine_NameAttribute(root_div, 'form', 'id', 'send');
  if form = nil then
    Exit;

  typ.NameType := sntPlayer;
  snb := false;
  typ.PointType := sptPoints;
  spb := false;

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
      snb := true;
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
      spb := true;
      break;
    end;
  end;

  // be sure there is no "subnav"-button selected:
  tag := HTMLFindRoutine_NameAttribute(form, 'div', 'id', 'subnav_fleet');
  if tag <> nil then
  begin
    for i := 0 to tag.ChildCount-1 do
    begin
      if pos('active', tag.ChildElements[i].AttributeValue['class']) > 0 then
      begin
        spb := false; // subnav-types not suported!
        break;
      end;
    end;
  end;

  Result := snb and spb; // beide parameter bestimmt?
end;

function ThtmlStatRead.CheckForTable(CurElement: THTMLElement;
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

function ThtmlStatRead.CheckForFormTable(CurElement: THTMLElement;
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

constructor ThtmlStatRead.Create(ini: TIniFile);
begin
  inherited Create;
end;

destructor ThtmlStatRead.Destroy;
begin
  inherited;
end;

function ThtmlStatRead.Read(text, html: string; var stats: TStat;
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

function ThtmlStatRead.ReadFromRS(rs: TReadSource; var Stats: TStat;
  var Typ: TStatTypeEx): Boolean;
begin
  try
    Result := ReadFullHtml(rs.GetHTMLRoot, Stats, Typ);
    if Result then
    begin
      if Stats.Time_u = 0 then
        Stats.Time_u := rs.GetServerTime;
    end;
  except
    Result := False;
  end;
end;

function ThtmlStatRead.ReadFullHtml(doc_html: THTMLElement; var stats: TStat;
  var Typ: TStatTypeEx): Boolean;
var tbody: THTMLElement;
    root_div, tag: THTMLElement;
    table: THTMLTable;
    s: string;
    i, first, p, rowoffset: Integer;
    meta: TOGameMetaInfo;
begin
  Result := False;
  //Leeren:
  FillChar(stats,SizeOf(Stats),0);

  // get own player information
  meta := getOGameMeta(doc_html);

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

    // find first rank in table (skip header etc...)
    rowoffset := -1;
    repeat
      inc(rowoffset);
      if (rowoffset > table.RowCount) then exit;
      first := ReadInt(table.Cells[rowoffset,0].FullTagContent,1);
    until (first > 0);

    stats.first := first;
    stats.count := 0;
    for i := 0 to 99 do
    begin
      try
        s := table.Cells[i+rowoffset,0].FullTagContent;
        if ReadInt(s,1) <> i+first then
          break
        else
        begin
          case (Typ.NameType) of
            sntPlayer: if not readStatEntry_player(table.Rows[i+rowoffset],
                                          Typ,
                                          stats.Stats[i],meta) then
                          Exit;
            sntAlliance: if not readStatEntry_ally(table.Rows[i+rowoffset],Typ,stats.Stats[i], meta) then
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

function ThtmlStatRead.readStatEntry_ally(row_tag: THTMLElement; stattype: TStatTypeEx;
  var statentry: TStatPlayer; const meta: TOGameMetaInfo): Boolean;
var tag_cell, atag: THTMLElement;
    s, tdclass: string;
    p, i: integer;
begin
  statentry.NameId := -1;

  for i := 0 to row_tag.ChildCount-1 do
  begin
    tag_cell := row_tag.ChildElements[i];
    if tag_cell.TagName = 'td' then
    begin
      tdclass := tag_cell.AttributeValue['class'];

      if pos('score', tdclass) > 0 then
      begin
        statentry.Punkte := readint(trim(tag_cell.FullTagContent),1);
      end;

      if pos('name tipsStan', tdclass) > 0 then
      begin
        statentry.Elemente := readint(trim(tag_cell.FullTagContent),1);
      end;

      if 'name' = tdclass then
      begin
        // --- extract allyid + name
        atag := tag_cell.FindChildTag('span',0);
        if atag = nil then
          atag := tag_cell.FindChildTag('a',0); // try a (this is the case when own ally)

        if atag <> nil then
        begin
          // --- get ally name
          s := atag.FullTagContent;
          statentry.Name := trim(s);

          // get ally id
          atag := atag.FindChildTag('a',0);
          if atag <> nil then
          begin
            s := atag.AttributeValue['href'];
            p := pos('?allyid=', s);
            if p > 0 then
            begin
              s := copy(s, p+8, 99999);
              statentry.NameId := StrToIntDef(s, -1);
            end
            else
            begin
              // eigene ally?
              p := pos('/game/index.php?page=alliance', s);
              if p > 0 then
                statentry.NameId := meta.allyid;
            end;
          end;
        end;
      end;

    end;
  end;

  Result := True;
end;

function ThtmlStatRead.readStatEntry_player(row_tag: THTMLElement; stattype: TStatTypeEx;
  var statentry: TStatPlayer; const meta: TOGameMetaInfo): Boolean;
var i, p: integer;
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
          end;

          tag := tag_cell.FindChildTagPath('a:0/span:0');
          b_name := tag <> nil;
          if b_name then
          begin
            statentry.Name := trim(tag.FullTagContent);
          end;
        end
        else
        if pos('score', tag_class) > 0 then
        begin
          statentry.Punkte := ReadInt(Trim(tag_cell.FullTagContent),1);
          b_score := true;
          if stattype.PointType = sptFleet then
          begin
            statentry.Elemente := ReadIntEx(tag_cell.AttributeValue['title'],
                                       1, '.',['|','a'..'z','A'..'Z',':',' ']);
          end;
        end
        else
        if tag_class = 'sendmsg' then
        begin
          tag := tag_cell.FindChildTagPath('a:0'); // nachricht schreiben
          if tag <> nil then
          begin
            statentry.NameId := extractPlayerIdFromSendMSGUrl(
              tag.AttributeValue['href']);
          end
          else
          begin
            if tag_cell.ChildNameCount('a') = 0 then
            begin
              // own player
              statentry.NameId := meta.playerid;
            end;
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

end.
 