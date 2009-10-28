unit ReadSolsysStats_fullhtml;

interface

uses
  Inifiles, OGame_Types, html, parser, DateUtils, SysUtils, readsource{, Dialogs{};

const
   HTMLTrimChars = [' ',#$D, #$A, #9];

type
  ThtmlStatRead = class
  protected
    function CheckForOptions(CurElement: THTMLElement; Data: pointer): Boolean;
    function CheckForTable(CurElement: THTMLElement; Data: pointer): Boolean;
    function CheckForFormTable(CurElement: THTMLElement; Data: pointer): Boolean;
  public
    constructor Create(ini: TIniFile);
    destructor Destroy; override;
    function Read(text, html: string; var stats: TStat; var Typ: TStatTypeEx): Boolean;
    function ReadFullHtml(doc_html: THTMLElement; var stats: TStat;
      var Typ: TStatTypeEx): Boolean;
    function ReadFromRS(rs: TReadSource; var Stats: TStat;
      var Typ: TStatTypeEx): Boolean;

  end;
  ThtmlSysRead = class
  protected
    StatusItems_HTML: array[TStati] of string;
    function CheckForTable(CurElement: THTMLElement; Data: pointer): Boolean;
    function CheckStatusSpans(CurElement: THTMLElement; Data: pointer): Boolean;
    function _StrToStatus_HTML(s: string; var status: TStatus): Boolean;
    function CheckForRankElement(CurElement: THTMLElement;
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

function ThtmlStatRead.CheckForOptions(CurElement: THTMLElement;
  Data: pointer): Boolean;
var s: string;
begin
  //Result ist immer False, da kein bestimmtes element gefunden werden soll!
  Result := False;
  with (CurElement) do
  begin
    if (TagName = 'option') then
    begin
      if (AttributeValue['selected'] = 'selected') then
      begin
        s := AttributeValue['value'];
        if s = 'player' then
          TStatTypeEx(Data^).NameType := sntPlayer
        else
        if s = 'ally' then
          TStatTypeEx(Data^).NameType := sntAlliance
        else
        if s = 'ressources' then
          TStatTypeEx(Data^).PointType := sptPoints
        else
        if s = 'fleet' then
          TStatTypeEx(Data^).PointType := sptFleet
        else
        if s = 'research' then
          TStatTypeEx(Data^).PointType := sptResearch;
      end;
    end;
  end;
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

function ThtmlStatRead.Read(text, html: string; var stats: TStat; var Typ: TStatTypeEx): Boolean;
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

function ThtmlSysRead.CheckForTable(CurElement: THTMLElement;
  Data: pointer): Boolean;
var body: THTMLElement;
    rc: Integer;
begin
  Result := False;
  with (CurElement) do
  begin
    if (TagType = pttStartTag)and
       (TagName = 'table')and
       (AttributeValue['width'] = '569') then
    begin
      body := FindChildTag('tbody');
      THTMLElement(Data^) := body;
      if body <> nil then
      begin
        rc := body.ChildNameCount('tr');
        //ShowMessage(Inttostr(rc));
        Result := (rc > 17)or(CurElement.ChildNameCount('tr') > 17);
      end;
    end;
  end;
end;

function ThtmlSysRead._StrToStatus_HTML(s: string; var status: TStatus): Boolean;
var i: TStati;
begin
  Result := False;
  for i := low(i) to high(i) do
    if (s = StatusItems_HTML[i]) then
    begin
      include(status,i);
      Result := True;
    end;
end;

function ThtmlSysRead.CheckStatusSpans(CurElement: THTMLElement;
  Data: pointer): Boolean;
begin
  //Result ist immer False, da kein bestimmtes element gefunden werden soll!
  Result := False;
  with (CurElement) do
  begin
    if (TagName = 'span') then
    begin
      _StrToStatus_HTML(AttributeValue['class'],TStatus(Data^));
    end;
  end;
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
var tbody, tag, tag2: THTMLElement;
    table: THTMLTable;
    smalltable: Boolean;
    stk: Integer;
    r,rc: Integer;
    s: WideString;
    p, i: Integer;
begin
  Result := false;
  table := THTMLTable(doc_html.FindTagRoutine(CheckForTable, @tbody));
  if table <> nil then
  begin
    //Rank entfernen (foxgame-erweiterung)
    table.DeleteTagRoutine(CheckForRankElement, nil);
    //------------------------------------

    if tbody <> nil then
      tbody.ChildsMove(table);

    //smalltable := (table.Rows[1].RowItemCount = 7);
    //UHO 19.09.08
    //Suche einfach nach nem Bild (sicherer)
    smalltable := true;
    for i := 1 to max_Planeten do
      if table.Cells[1+i,1].FindChildTagPath('a:0/img:0') <> nil then
      begin
        smalltable := false;
        break;
      end;

    if smalltable then stk := -1 else stk := 0;

    s := table.Cells[0,0].FullTagContent;
    p := findfirstnumericchar(s);
    if p = 0 then Exit;
    ReadPosOrTime(s+'ende',p,solsys.System);
    solsys.System.P[2] := 1;
    solsys.System.Mond := False;

    rc := table.RowCount;
    for r := 1 to max_Planeten do
    begin
      //Planetenname -----------------------------------------------------------
      s := table.Cells[r+1,stk+2].FullTagContent;
      p := pos('(',s);
      //Aktivitäten := Copy(s,p+1,high(Integer));
      if p > 0 then
        s := copy(s,1,p-1);
      solsys.Planeten[r].PlanetName := trim(s);
      //Mond -------------------------------------------------------------------
      solsys.Planeten[r].MondSize := 0;
      solsys.Planeten[r].MondTemp := 0;
      tag := table.Cells[r+1,stk+3].FindChildTag('a');
      if tag <> nil then
      begin
        tag.ParseHTMLCode(tag.AttributeValue['onmouseover']);
        tag2 := tag.FindChildTagPath('table/tr:1/th:1/table/tr:1/th:1');
        if tag2 <> nil then
        begin
          s := trim(tag2.FullTagContent);
          solsys.Planeten[r].MondSize := ReadInt(s,1);
        end;
        tag2 := tag.FindChildTagPath('table/tr:1/th:1/table/tr:2/th:1');
        if tag2 <> nil then
        begin
          s := trim(tag2.FullTagContent);
          solsys.Planeten[r].MondTemp := StrToInt(s);
        end;
      end;
      //Trümmerfeld ------------------------------------------------------------
      solsys.Planeten[r].TF[0] := 0;
      solsys.Planeten[r].TF[1] := 0;
      tag := table.Cells[r+1,stk+4].FindChildTag('a');
      if tag <> nil then
      begin
        tag.ParseHTMLCode(tag.AttributeValue['onmouseover']);
        tag2 := tag.FindChildTagPath('table/tr:1/th:1/table/tr:1/th:1');
        if tag2 <> nil then
        begin
          s := trim(tag2.FullTagContent);
          solsys.Planeten[r].TF[0] := ReadInt(s,1);
        end;
        tag2 := tag.FindChildTagPath('table/tr:1/th:1/table/tr:2/th:1');
        if tag2 <> nil then
        begin
          s := trim(tag2.FullTagContent);
          solsys.Planeten[r].TF[1] := ReadInt(s,1);
        end;
      end;
      //Spielername ------------------------------------------------------------
      s := table.Cells[r+1,stk+5].FullTagContent;
      p := pos('(',s);
      if p > 0 then
        s := copy(s,1,p-1);
      solsys.Planeten[r].Player := trim(s);
      //Status -----------------------------------------------------------------
      solsys.Planeten[r].Status := [];
      table.Cells[r+1,stk+5].FindTagRoutine(CheckStatusSpans,@(solsys.Planeten[r].Status));
      //Allianz ----------------------------------------------------------------
      solsys.Planeten[r].Ally := trim(table.Cells[r+1,stk+6].FullTagContent);
    end;

    solsys.Time_u := DateTimeToUnix(Now)-1;
    Result := True;
  end;
end;

function ThtmlStatRead.ReadFromRS(rs: TReadSource; var Stats: TStat;
  var Typ: TStatTypeEx): Boolean;
begin
  try
    Result := ReadFullHtml(rs.GetHTMLRoot, Stats, Typ);
  except
    Result := False;
  end;
end;

function ThtmlStatRead.ReadFullHtml(doc_html: THTMLElement; var stats: TStat;
  var Typ: TStatTypeEx): Boolean;
var tbody: THTMLElement;
    table: THTMLTable;
    s: string;
    i, first, p: Integer;
    timepos: TPlanetPosition;
    y,m,d,h,min: Word;
begin
  Result := False;
  //Leeren:
  FillChar(stats,SizeOf(Stats),0);

  table := THTMLTable(doc_html.FindTagRoutine(CheckForFormTable,@tbody));
  if table <> nil then
  begin
    if tbody <> nil then
      tbody.ChildsMove(table);

    //Datum + Uhrzeit --------------------------------------------------------
    s := table.Cells[0,0].FullTagContent;
    p := findfirstnumericchar(s);
    if p > 0 then
    begin
      p := ReadPosOrTime(s,p,timepos);
      y := timepos.P[0];
      m := timepos.P[1];
      d := timepos.P[2];
      p := ReadPosOrTime(s,p+2,timepos);
      h := timepos.P[0];
      min := timepos.P[1];

      stats.Time_u := DateTimeToUnix(EncodeDateTime(y,m,d,h,min,0,0));
    end;

    //Statistiktyp -----------------------------------------------------------
    table.Rows[1].FindTagRoutine(CheckForOptions,@Typ);
  end else Exit;

  table := THTMLTable(doc_html.FindTagRoutine(CheckForTable,@tbody));
  if table <> nil then
  begin
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
          //Name -------------------------------------------------------------
          stats.Stats[i].Name := trim(table.Cells[i+1,1].FullTagContent);
          //Ally oder Mitglieder ---------------------------------------------
          if Typ.NameType = sntPlayer then
            stats.Stats[i].Ally := trim(table.Cells[i+1,3].FullTagContent)
          else stats.Stats[i].Mitglieder := ReadInt
                 (table.Cells[i+1,3].FullTagContent,1);
          //Punkte -----------------------------------------------------------
          stats.Stats[i].Punkte := ReadInt(table.Cells[i+1,4].FullTagContent,1);
        end;
      except
        break;
      end;
    end;
  end else Exit;

  Result := True;
end;

function ThtmlSysRead.CheckForRankElement(CurElement: THTMLElement;
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
 