unit ReadPhalanxScan_fullhtml_betauni;

interface

uses
  Classes, IniFiles, Contnrs, OGame_Types, html, parser, windows,
  ReadReport_Text, readsource, regexpname;

const
  ThtmlPhalanx_inisection = 'html_phalanx';

type
  ThtmlPhalanx_fligthclass = (hpfc_none, hpfc_return, hpfc_flight);
  ThtmlPhalanx_fligthclassEx = (
    hpfce_none,
    hpfce_phalanx_fleet,
    hpfce_owntransport,
    hpfce_attack,
    hpfce_owndeploy,   //Stationieren, TODO: rückkehrende flotte ?
    hpfce_ownharvest,  //Abbau
    hpfce_espionage,    //Spionage
    hpfce_owncolony,   //kolonisieren
    hpfce_ownespionage,
    hpfce_ownattack
  );

  ThtmlPhalanxRead_betauni = class
  private
    //ini-file-content (filled in create())
    str_return,
    str_flight: string;
    str_evtypeex: array[ThtmlPhalanx_fligthclassEx] of string;
    str_planet: string;

    time_regexp: Tregexpn;


    fleets: TList;
    readreport: TReadReport_Text;
    function Add(fleet: TFleetEvent): integer;
    function checkTags(CurElement: THTMLElement; Data: pointer): Boolean;
    function readHtmlTag(tag: THTMLElement): boolean;
    function readHtmlTag_ress_fleet(const tag: THTMLElement;
      const fce: ThtmlPhalanx_fligthclassEx; var fleet: TFleetEvent): boolean;
    function readHtmlTag_planetposition_and_fleettype(const tag: THTMLElement;
      const fce: ThtmlPhalanx_fligthclassEx; var fleet: TFleetEvent): boolean;
    function readHtmlTag_ships(const tag: THTMLElement;
      const fce: ThtmlPhalanx_fligthclassEx; var fleet: TFleetEvent): boolean;
    function GetFleet(nr: integer): TFleetEvent;
  public
    function ReadHTML(html: string): integer;
    constructor Create(ini: TIniFile; aReadReport: TReadReport_Text);
    destructor Destroy; override;
    function Read(text, html: string): integer;
    procedure Clear;
    function ReadHTML_Elements(doc_html: THTMLElement): integer;
    function ReadFromRS(rs: TReadSource): integer;
    property FleetList[nr: integer]: TFleetEvent read GetFleet;
    function Count: Integer;
  end;

const
  html_fleetevent: array[TFleetEventType] of string = (
    'none',       //None
    'Stationieren',  //Stationieren   OK
    'Transport',  //Transportieren    OK
    'Angreifen',     //Angreifen      OK
    'Spionage',  //Spionage           OK
    'Ressourcen abbauen', //Recyclen  OK
    'Kolonisieren'    //Kolonisieren  OK
  );

implementation

uses Math, SysUtils, DateUtils, StrUtils;

function ThtmlPhalanxRead_betauni.Add(fleet: TFleetEvent): integer;
var p: PFleetEvent_;
begin
  New(p);
  p^ := fleet;
  Result := fleets.Add(p);
end;

procedure ThtmlPhalanxRead_betauni.Clear;
begin
  while fleets.Count > 0 do
  begin
    Dispose(fleets.Items[0]);
    fleets.Delete(0);
  end;
end;

function UtcTOLocalDateTime(aUTC : TDateTime) : TDateTime;
var
  tzi : TIME_ZONE_INFORMATION;
  utc : TSystemTime;
  localtime : TSystemTime;
begin
  DateTimeToSystemTime(aUTC,utc);
  GetTimeZoneInformation(tzi);
  SystemTimeToTzSpecificLocalTime(@tzi,utc,localtime);
  Result := SystemTimeToDateTime(localtime);
end;

constructor ThtmlPhalanxRead_betauni.Create(ini: TIniFile;
  aReadReport: TReadReport_Text);
var fevt: ThtmlPhalanx_fligthclassEx;
begin
  inherited Create();
  fleets := TList.Create;
  readreport := aReadReport;

  str_return := ini.ReadString(ThtmlPhalanx_inisection, 'pre_return', 'n/a');
  str_flight := ini.ReadString(ThtmlPhalanx_inisection, 'pre_flight', 'n/a');
  
  for fevt := low(fevt) to high(fevt) do
  begin
    str_evtypeex[fevt] := ini.ReadString(ThtmlPhalanx_inisection, 'fet_' + IntToStr(byte(fevt)), 'n/a');
  end;

  str_planet := ini.ReadString(ThtmlPhalanx_inisection, 'key_planet', 'n/a');

  time_regexp := Tregexpn.Create;
  time_regexp.setexpression(ini.ReadString(ThtmlPhalanx_inisection, 'time_regexp', 'n/a'));
end;

destructor ThtmlPhalanxRead_betauni.Destroy;
begin
  fleets.Free;
  time_regexp.Free;
  inherited;
end;

function ThtmlPhalanxRead_betauni.ReadHTML(html: string): integer;
var doc_html: THTMLElement;
begin
  doc_html := THTMLElement.Create(nil, 'root');
  try
    doc_html.ParseHTMLCode(html);
    Result := ReadHTML_Elements(doc_html);
  finally
    doc_html.Free;
  end;
end;

function ThtmlPhalanxRead_betauni.Read(text, html: string): integer;
begin
  try
    Result := ReadHTML(html);
  except
    Result := 0;
  end;
end;

function ThtmlPhalanxRead_betauni.ReadFromRS(rs: TReadSource): integer;
var doc_html: THTMLElement;
begin
  try
    doc_html := rs.GetHTMLRoot();
    Result := ReadHTML_Elements(doc_html);
  except
    Result := 0;
  end;
end;

function ThtmlPhalanxRead_betauni.checkTags(CurElement: THTMLElement;
  Data: pointer): Boolean;
begin
  Result := false;
  if (CurElement.TagName = 'div') then
  begin
    if (Copy(CurElement.AttributeValue['id'],1,8) = 'eventRow') then
    begin
      Result := True;
      readHtmlTag(CurElement);
    end;
  end;
end;

function ThtmlPhalanxRead_betauni.readHtmlTag_ships(const tag: THTMLElement;
  const fce: ThtmlPhalanx_fligthclassEx; var fleet: TFleetEvent): boolean;
var s: string;
    el: THTMLElement;
    list: TInfoArray;
    c, i: integer;
begin
  Result := False;

  el := tag.FindChildTagPath('th:1/span:0/a:1');
  if el = nil then exit;
  s := el.AttributeValue['title'];
  c := readreport._LeseTeilScanBericht(s, list, sg_Flotten, false);
  Result := c > 0;
  if Result then
  begin
    for i := 0 to length(fleet.ships)-1 do
    begin
      fleet.ships[i] := list[i];
    end;
  end;
end;

function ThtmlPhalanxRead_betauni.ReadHTML_Elements(
  doc_html: THTMLElement): integer;
begin
  //Find and read FleetEvents:
  Result := doc_html.DeleteTagRoutine(checkTags, nil);
end;

function ThtmlPhalanxRead_betauni.readHtmlTag_ress_fleet(const tag: THTMLElement;
  const fce: ThtmlPhalanx_fligthclassEx; var fleet: TFleetEvent): boolean;
var s, s_ships: string;
    el: THTMLElement;
    ress: TInfoArray;
    ships: TInfoArray;
    c: integer;
begin
  Result := False;

  el := tag.ParentElement.FindChildTag('div',tag.TagNameNr-1);
  if el = nil then Exit;

  s := el.FullTagContent;
  s := ReplaceStr(s,#13,' ');
  //s := ReplaceStr(s,#10,' ');
  s_ships := ReplaceStr(s,':',' ');

  c := readreport._LeseTeilScanBericht(s_ships, ships, sg_Flotten, False);
  Result := c > 0;
  if Result then
  begin
    fleet.ships := ships;
  end;

  c := readreport._LeseTeilScanBericht(s, ress, sg_Rohstoffe, False);
  Result := c > 0;
  if Result then
  begin
    fleet.ress := ress;
  end;
end;

function ThtmlPhalanxRead_betauni.readHtmlTag_planetposition_and_fleettype(const tag: THTMLElement;
  const fce: ThtmlPhalanx_fligthclassEx; var fleet: TFleetEvent): boolean;
var s: string;
    el, eltmp: THTMLElement;
    i, p: integer;
    //moon: Boolean;
    fet: TFleetEventType;

  procedure findnext_a_koord();
  begin
    inc(i);
    el := eltmp.ChildElements[i];
    while (el <> nil) do
    begin
      if el.TagName = 'a' then
      begin
        s := el.FullTagContent;
        p := pos('[', s);
        if p >= 1 then
          break;
      end;
      inc(i);
      el := eltmp.ChildElements[i];
    end;
  end;

begin
  Result := false;

  //Startplanet (suche alle <a>-tags ab!)
  eltmp := tag.FindChildTagPath('div:2/div:0');

  i := 0;
  findnext_a_koord();

  if not (el <> nil) then Exit;
  ReadPosOrTime(s,p+1,fleet.Head.origin);
  //Mond?
  el := eltmp.ChildElements[i-1];
  s := el.Content;
  fleet.head.origin.Mond := not (pos(str_planet, s) > 0);

  //ZielPlanet
  findnext_a_koord();

  if not (el <> nil) then Exit;
  ReadPosOrTime(s,p+1,fleet.Head.target);
  //Mond?
  el := eltmp.ChildElements[i-1];
  s := el.FullTagContent;
  fleet.head.target.Mond := not (pos(str_planet, s) > 0);

  //Auftrag
  el := eltmp.ChildElements[i+1];
  s := el.FullTagContent;
  p := pos('Auftrag ist: ',s);
  if p > 0 then
  begin
    //Normale Flotte
  end
  else
  begin
    p := pos('Auftrag war: ',s);
    if p > 0 then
    begin
      Include(fleet.head.eventflags, fef_return);
    end
    else
      Exit;
  end;

  for fet := low(fet) to high(fet) do
  begin
    if PosEx(html_fleetevent[fet], s, p) > 0 then
    begin
      fleet.head.eventtype := fet;
      Result := True;
      break;
    end;
  end;

  if fleet.head.eventtype = fet_harvest then
  begin
    if fef_return in fleet.head.eventflags then
      fleet.head.origin.Mond := False
    else
      fleet.head.target.Mond := False;
  end;
end;

function ThtmlPhalanxRead_betauni.readHtmlTag(tag: THTMLElement): boolean;
var el, tag_ul: THTMLElement;
    fleet: TFleetEvent;
    i, sec: integer;
    timepos: TPlanetPosition;
    time_ber: TDateTime;

    s: string;
    p: integer;
    fce: ThtmlPhalanx_fligthclassEx;

    fet: TFleetEventType;
begin
  Result := false;
  FillChar(fleet, sizeof(fleet), 0);

  //unique ID
  s := tag.AttributeValue['id'];
  p := pos('-',s);
  if p = 0 then Exit;
  fleet.head.unique_id := ReadInt(s,p+1);


  tag_ul := tag.FindChildTag('ul');
  for i := 0 to tag_ul.ChildCount - 1 do
  begin
    el := tag_ul.ChildElements[i];
    s := el.AttributeValue['class'];

    if s = 'missionFleet' then
    begin
      s := el.FullTagContent;

      for fet := low(fet) to high(fet) do
      begin
        if PosEx(html_fleetevent[fet], s, 1) > 0 then
        begin
          fleet.head.eventtype := fet;
          break;
        end;
      end;

      if pos('(R)', s) > 0 then
        include(fleet.head.eventflags, fef_return);

    end
    else
    if s = 'coordsOrigin' then
    begin
      s := el.FullTagContent;
      p := pos('[',s);
      ReadPosOrTime(s,p+1,fleet.head.origin);
    end
    else
    if s = 'destCoords' then
    begin
      s := el.FullTagContent;
      p := pos('[',s);
      ReadPosOrTime(s,p+1,fleet.head.target);
    end
    else
    if s = 'arrivalTime' then
    begin
      s := trim(el.FullTagContent);
      ReadPosOrTime(s,1,timepos);
    end
    else
    if s = 'countDown' then
    begin
      sec := 0;
      s := el.FullTagContent;
      time_regexp.match(s);
      s := time_regexp.getsubexpr('d');
      sec := sec + ReadInt(s,1)*24*60*60;
      s := time_regexp.getsubexpr('h');
      sec := sec + ReadInt(s,1)*60*60;
      s := time_regexp.getsubexpr('min');
      sec := sec + ReadInt(s,1)*60;
      s := time_regexp.getsubexpr('sec');
      sec := sec + ReadInt(s,1);
    end;

  end;


  //Typ:
  el := tag.FindChildTagPath('ul:0/li:0/span:0');
  if el <> nil then
  begin
    s := el.AttributeValue['class'];
    if pos('friendly',s) > 0 then
    begin
      include(fleet.head.eventflags, fef_friendly);
    end;
    if pos('hostile',s) > 0 then
    begin
      include(fleet.head.eventflags, fef_hostile);
    end;
  end;

  //Zeiten:
  time_ber := Now() + sec/60/60/24;
  time_ber := trunc(time_ber) + timepos.P[0]/24 + timepos.P[1]/24/60 + timepos.P[2]/24/60/60;
  fleet.Head.arrival_time_u := DateTimeToUnix(time_ber);

  {//Planeten Koords
  if not readHtmlTag_planetposition_and_fleettype(tag, fce, fleet) then
    Exit;}

  //REss initialisieren:
  SetLength(fleet.ress, ScanFileCounts[sg_Rohstoffe]);
  for i := 0 to length(fleet.ress)-1 do
    fleet.ress[i] := 0;

  //Flotte initialisieren:
  SetLength(fleet.ships, ScanFileCounts[sg_Flotten]);
  for i := 0 to length(fleet.ships)-1 do
    fleet.ships[i] := 0;

  {//Ress/Fleet einlesen
  readHtmlTag_ress_fleet(tag,fce,fleet);}

  Add(fleet);
end;

function ThtmlPhalanxRead_betauni.GetFleet(nr: integer): TFleetEvent;
begin
  if nr >= fleets.Count then
    raise Exception.Create('ThtmlPhalanxRead.GetFleet: ungültige Nummer!');

  Result := TFleetEvent(fleets[nr]^);
end;

function ThtmlPhalanxRead_betauni.Count: Integer;
begin
  Result := fleets.Count;
end;

end.
