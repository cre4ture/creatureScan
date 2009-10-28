unit ReadPhalanxScan_fullhtml;

interface

uses
  Classes, IniFiles, Contnrs, OGame_Types, html, parser, windows,
  ReadReport_Text, readsource;

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

  ThtmlPhalanxRead = class
  private
    //ini-file-content (filled in create())
    str_return,
    str_flight: string;
    str_evtypeex: array[ThtmlPhalanx_fligthclassEx] of string;
    str_planet: string;
    str_ulr_key_events: string;


    fleets: TList;
    readreport: TReadReport_Text;
    procedure readSourceInfo(html: string; var info: TFleetsInfoSource);
    function Add(fleet: TFleetEvent): integer;
    function ReadHTML(html: string): TFleetsInfoSource;
    function checkTags(CurElement: THTMLElement; Data: pointer): Boolean;
    function readHtmlTag(tag: THTMLElement; fc: ThtmlPhalanx_fligthclass): boolean;
    function readHtmlTag_transport(const tag: THTMLElement;
      const fce: ThtmlPhalanx_fligthclassEx; var fleet: TFleetEvent): boolean;
    function readHtmlTag_planetposition(const tag: THTMLElement;
      const fce: ThtmlPhalanx_fligthclassEx; var fleet: TFleetEvent): boolean;
    function readHtmlTag_ships(const tag: THTMLElement;
      const fce: ThtmlPhalanx_fligthclassEx; var fleet: TFleetEvent): boolean;
    function GetFleet(nr: integer): TFleetEvent;
  public
    constructor Create(ini: TIniFile; aReadReport: TReadReport_Text);
    destructor Destroy; override;
    function Read(text, html: string): TFleetsInfoSource;
    procedure Clear;
    function ReadFromRS(rs: TReadSource): TFleetsInfoSource;
    property FleetList[nr: integer]: TFleetEvent read GetFleet;
    function Count: Integer;
  end;

implementation

uses Math, SysUtils, DateUtils, StrUtils;

function ThtmlPhalanxRead.Add(fleet: TFleetEvent): integer;
var p: PFleetEvent_;
begin
  New(p);
  p^ := fleet;
  Result := fleets.Add(p);
end;

procedure ThtmlPhalanxRead.Clear;
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

constructor ThtmlPhalanxRead.Create(ini: TIniFile;
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
  str_ulr_key_events := ini.ReadString(ThtmlPhalanx_inisection, 'url_key_events', 'n/a');
end;

destructor ThtmlPhalanxRead.Destroy;
begin
  fleets.Free;
  inherited;
end;

function ThtmlPhalanxRead.ReadHTML(html: string): TFleetsInfoSource;
var doc_html: THTMLElement;
begin
  doc_html := THTMLElement.Create(nil, 'root');
  try
    doc_html.ParseHTMLCode(html);
    Result.Count := doc_html.DeleteTagRoutine(checkTags, nil);
    readSourceInfo(html, Result);
  except
    Result.typ := fist_none;
    Result.count := 0;
  end;
  doc_html.Free;
end;

function ThtmlPhalanxRead.Read(text, html: string): TFleetsInfoSource;
begin
  Result := ReadHTML(html);
end;

function ThtmlPhalanxRead.ReadFromRS(rs: TReadSource): TFleetsInfoSource;
var doc_html: THTMLElement;
begin
  try
    doc_html := rs.GetHTMLRoot();
    Result.count := doc_html.DeleteTagRoutine(checkTags, nil);
    readSourceInfo(rs.GetHTMLString, Result);
  except
    Result.typ := fist_none;
    Result.count := 0;
  end;
end;

function ThtmlPhalanxRead.checkTags(CurElement: THTMLElement;
  Data: pointer): Boolean;
var fc: ThtmlPhalanx_fligthclass;
begin
  Result := false;
  if (CurElement.TagName = 'tr') then
  begin
    fc := hpfc_none;
    if (CurElement.AttributeValue['class'] = str_return) then
      fc := hpfc_return
    else
    if (CurElement.AttributeValue['class'] = str_flight) then
      fc := hpfc_flight;
    //if (curElement.AttributeValue

    if fc <> hpfc_none then
    begin
      Result := True;
      readHtmlTag(CurElement, fc);
    end;
  end;
end;

function ThtmlPhalanxRead.readHtmlTag_ships(const tag: THTMLElement;
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

function ThtmlPhalanxRead.readHtmlTag_transport(const tag: THTMLElement;
  const fce: ThtmlPhalanx_fligthclassEx; var fleet: TFleetEvent): boolean;
var s: string;
    el: THTMLElement;
    ress: TInfoArray;
    c: integer;
begin
  Result := False;

  el := tag.FindChildTagPath('th:1/span:0/a:5');
  if el = nil then Exit;

  s := el.AttributeValue['title'];
  c := readreport._LeseTeilScanBericht(s, ress, sg_Rohstoffe, False);
  Result := c > 0;
  if Result then
  begin
    fleet.ress := ress;
  end;
end;

procedure ThtmlPhalanxRead.readSourceInfo(html: string;
  var info: TFleetsInfoSource);
var p1,p2,p3: integer;
begin
  p1 := pos('SourceURL:', html);
  p2 := PosEx(str_ulr_key_events, html, p1);
  p3 := PosEx(#13, html, p1);

  if (p1 > 0)and(p2 > p1)and(p3 > p2) then
  begin
    info.typ := fist_events;
  end
  else
  begin
    info.typ := fist_phalanx;
  end;

  info.planet.P[0] := 1;
  info.planet.P[1] := 1;
  info.planet.P[2] := 1;
  info.planet.Mond := false;
  info.time := DateTimeToUnix(Now());
end;

function ThtmlPhalanxRead.readHtmlTag_planetposition(const tag: THTMLElement;
  const fce: ThtmlPhalanx_fligthclassEx; var fleet: TFleetEvent): boolean;
var s: string;
    el, eltmp: THTMLElement;
    i, p: integer;
    //moon: Boolean;

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
  //Startplanet (suche alle <a>-tags ab!)
  eltmp := tag.FindChildTagPath('th:1/span:0');

  i := 0;
  findnext_a_koord();

  Result := el <> nil;
  if not Result then Exit;
  ReadPosOrTime(s,p+1,fleet.Head.origin);
  //Mond?
  el := eltmp.ChildElements[i-1];
  s := el.Content;
  fleet.head.origin.Mond := not (pos(str_planet, s) > 0);

  //ZielPlanet
  findnext_a_koord();

  Result := el <> nil;
  if not Result then Exit;
  ReadPosOrTime(s,p+1,fleet.Head.target);
  //Mond?
  el := eltmp.ChildElements[i-1];
  s := el.Content;
  fleet.head.target.Mond := not (pos(str_planet, s) > 0);

end;

function ThtmlPhalanxRead.readHtmlTag(tag: THTMLElement;
  fc: ThtmlPhalanx_fligthclass): boolean;
var el: THTMLElement;
    fleet: TFleetEvent;
    i: integer;

    s: string;
    fce: ThtmlPhalanx_fligthclassEx;
begin
  Result := false;
  FillChar(fleet, sizeof(fleet), 0);

  //Zeiten:
  el := tag.FindChildTagPath('th:0/div:0');
  if el = nil then Exit;
  fleet.Head.arrival_time_u := StrToInt64(el.AttributeValue['star']);

  //Zeitzone umrechnen:
  fleet.Head.arrival_time_u := DateTimeToUnix( UtcTOLocalDateTime (UnixToDateTime(fleet.Head.arrival_time_u)));

  //Flugtyp: -------------------------------------------------------------------
  el := tag.FindChildTagPath('th:1/span:0');
  if el = nil then Exit;
  //prefix löschen:
  s := el.AttributeValue['class'];
  case fc of
    hpfc_return: s := copy(s,length(str_return)+2, high(integer));
    hpfc_flight: s := copy(s,length(str_flight)+2, high(integer));
  end;
  //typ bestimmen:
  fce := high(fce);
  while (fce > hpfce_none) do
  begin
    if str_evtypeex[fce] = s then
      break;
    dec(fce);
  end;


  //Planeten Koords
  if not readHtmlTag_planetposition(tag, fce, fleet) then
    Exit;


  //Auftrag:
  //????

  //REss initialisieren:
  SetLength(fleet.ress, ScanFileCounts[sg_Rohstoffe]);
  for i := 0 to length(fleet.ress)-1 do
    fleet.ress[i] := 0;
  //Flotte initialisieren:
  SetLength(fleet.ships, ScanFileCounts[sg_Flotten]);
  for i := 0 to length(fleet.ships)-1 do
    fleet.ships[i] := 0;
  //Flotte einlesen:
  readHtmlTag_ships(tag,fce,fleet);

  //Auftrag + Flags setzen:
  //Clear:
  fleet.head.eventflags := [];
  //Rückflug?
  if fc = hpfc_return then
    Include(fleet.head.eventflags, fef_return);

  //Auftrag bestimmen:
  case fce of
    hpfce_none: fleet.head.eventtype := fet_none;
    hpfce_phalanx_fleet: fleet.head.eventtype := fet_none;
    hpfce_owntransport:
      begin
        include(fleet.head.eventflags, fef_friendly);
        fleet.head.eventtype := fet_transport;
      end;
    hpfce_attack: fleet.head.eventtype := fet_attack;
    hpfce_owndeploy:
      begin
        include(fleet.head.eventflags, fef_friendly);
        fleet.head.eventtype := fet_deploy;
      end;
    hpfce_ownharvest: 
      begin
        include(fleet.head.eventflags, fef_friendly);
        fleet.head.eventtype := fet_harvest;
      end;
    hpfce_espionage: fleet.head.eventtype := fet_espionage;
    hpfce_ownespionage:
      begin
        include(fleet.head.eventflags, fef_friendly);
        fleet.head.eventtype := fet_espionage;
      end;
    hpfce_owncolony: 
      begin
        include(fleet.head.eventflags, fef_friendly);
        fleet.head.eventtype := fet_colony;
      end;
    hpfce_ownattack:
      begin
        include(fleet.head.eventflags, fef_friendly);
        fleet.head.eventtype := fet_attack;
      end;
  else
    raise Exception.Create('ThtmlPhalanxRead.readHtmlTag: undefined fleeteventtype');
  end;

  if (fleet.head.eventtype = fet_transport)and
     (not (fef_return in fleet.head.eventflags)) then
    readHtmlTag_transport(tag,fce,fleet);

  Add(fleet);
end;

function ThtmlPhalanxRead.GetFleet(nr: integer): TFleetEvent;
begin
  if nr >= fleets.Count then
    raise Exception.Create('ThtmlPhalanxRead.GetFleet: ungültige Nummer!');

  Result := TFleetEvent(fleets[nr]^);
end;

function ThtmlPhalanxRead.Count: Integer;
begin
  Result := fleets.Count;
end;

end.
