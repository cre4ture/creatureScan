unit ReadPhalanxScan_fullhtml_betauni;

interface

uses
  Classes, IniFiles, Contnrs, OGame_Types, creax_html, parser, windows,
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
    hpfce_espionage,   //Spionage
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
    str_moon: string;
    str_url_key_events: string;

    time_regexp: Tregexpn;
    arrival_regexp: Tregexpn;


    fleets: TList;
    readreport: TReadReport_Text;
    function Add(fleet: TFleetEvent): integer;
    function checkTags(CurElement: THTMLElement; Data: pointer): Boolean;
    function readHtmlTag(tag: THTMLElement): boolean;
    function readHtmlTag_ress_fleet(const tag: THTMLElement;
      var fleet: TFleetEvent): boolean;
    function readHtmlTag_planetposition_and_fleettype(const tag: THTMLElement;
      const fce: ThtmlPhalanx_fligthclassEx; var fleet: TFleetEvent): boolean;
    function readHtmlTag_ships(const tag: THTMLElement;
      const fce: ThtmlPhalanx_fligthclassEx; var fleet: TFleetEvent): boolean;
    function GetFleet(nr: integer): TFleetEvent;
    procedure readSourceInfo(html: string; var info: TFleetsInfoSource);
    procedure initFleet(var fleet: TFleetEvent);
  public
    procedure ReadHTML_BuildTimer(doc_html: THTMLElement);
    function ReadHTML(html: string): TFleetsInfoSource;
    constructor Create(ini: TIniFile; aReadReport: TReadReport_Text);
    destructor Destroy; override;
    function Read(text, html: string): TFleetsInfoSource;
    procedure Clear;
    function ReadHTML_Elements(doc_html: THTMLElement): integer;
    function ReadFromRS(rs: TReadSource): TFleetsInfoSource;
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
    'Abbau',     //Recyclen  OK
    'Kolonisieren',    //Kolonisieren  OK
    'Expedition'
  );

implementation

uses Math, SysUtils, DateUtils, StrUtils, creaturesStrUtils;

procedure ThtmlPhalanxRead_betauni.readSourceInfo(html: string;
  var info: TFleetsInfoSource);
var p1,p2,p3: integer;
begin
  info.typ := fist_phalanx;

  p1 := pos('SourceURL:', html);
  if (p1 > 0) then
  begin
    p2 := PosEx(str_url_key_events, html, p1);
    p3 := PosEx(#13, html, p1);

    if (p2 > p1)and(p3 > p2) then
    begin
      info.typ := fist_events;
    end;
  end;

  info.planet.P[0] := 1;
  info.planet.P[1] := 1;
  info.planet.P[2] := 1;
  info.planet.Mond := false;
  info.time := DateTimeToUnix(Now());
end;

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
  str_moon := ini.ReadString(ThtmlPhalanx_inisection, 'moon_name', 'Mond');

  time_regexp := Tregexpn.Create;
  time_regexp.setexpression(
    ini.ReadString(ThtmlPhalanx_inisection, 'time_regexp', 'n/a'));

  arrival_regexp := Tregexpn.Create;
  arrival_regexp.setexpression(
    ini.ReadString(ThtmlPhalanx_inisection, 'arrival_regexp', 'n/a'));

  str_url_key_events := ini.ReadString(ThtmlPhalanx_inisection, 'url_key_events', 'n/a');
end;

destructor ThtmlPhalanxRead_betauni.Destroy;
begin
  fleets.Free;
  time_regexp.Free;
  inherited;
end;

function ThtmlPhalanxRead_betauni.ReadHTML(html: string): TFleetsInfoSource;
var doc_html: THTMLElement;
begin
  doc_html := THTMLElement.Create(nil, 'root');
  try
    doc_html.ParseHTMLCode(html);
    Result.count := ReadHTML_Elements(doc_html);
    readSourceInfo(html, Result);
  except
    Result.count := 0;
    Result.typ := fist_none;
  end;
  doc_html.Free;
end;

function ThtmlPhalanxRead_betauni.Read(text, html: string): TFleetsInfoSource;
begin
  Result := ReadHTML(html);
end;

function ThtmlPhalanxRead_betauni.ReadFromRS(rs: TReadSource): TFleetsInfoSource;
var doc_html: THTMLElement;
begin
  try
    doc_html := rs.GetHTMLRoot();
    Result.count := ReadHTML_Elements(doc_html);
    readSourceInfo(rs.GetHTMLString, Result);
  except
    Result.count := 0;
    Result.typ := fist_none;
  end;
end;

function ThtmlPhalanxRead_betauni.checkTags(CurElement: THTMLElement;
  Data: pointer): Boolean;
begin
  Result := false; // never delete!
  if (CurElement.TagName = 'tr') then
  begin
    if (Copy(CurElement.AttributeValue['id'],1,8) = 'eventRow')or
       (CurElement.AttributeValue['class'] = 'allianceAttack') then
    begin
      readHtmlTag(CurElement);
    end;
  end;
end;

function ThtmlPhalanxRead_betauni.readHtmlTag_ships(const tag: THTMLElement;
  const fce: ThtmlPhalanx_fligthclassEx; var fleet: TFleetEvent): boolean;
var s: string;
    el: THTMLElement;
    tmp_report: TScanBericht;
    c, i: integer;
begin
  Result := False;

  el := tag.FindChildTagPath('th:1/span:0/a:1');
  if el = nil then exit;
  s := el.AttributeValue['title'];
  tmp_report := TScanBericht.Create;
  try
    c := readreport._LeseTeilScanBericht(s, tmp_report, sg_Flotten, false);
    Result := c > 0;
    if Result then
    begin
      for i := 0 to length(fleet.ships)-1 do
      begin
        fleet.ships[i] := tmp_report.Bericht[sg_Flotten,i];
      end;
    end;
  finally
    tmp_report.Free;
  end;
end;

procedure ThtmlPhalanxRead_betauni.ReadHTML_BuildTimer(doc_html: THTMLElement);
var node: THTMLElement;
    regex: Tregexpn;
    h, min, sec: integer;
    fleet: TFleetEvent;
    end_time: TDateTime;
begin
  initFleet(fleet);

  regex := Tregexpn.Create;
  try
    node := HTMLFindRoutine_NameAttribute(doc_html, 'table', 'class', 'construction');
    if (node <> nil) then
    begin
      node := node.FindChildTagPath('tbody:0/tr:4/td:1/');
      if (node <> nil) then
      begin
        regex.setexpression('((?<day>[0-9]+)/(?<month>[0-9]+) )?(?<h>[0-9]+):(?<min>[0-9]+):(?<sec>[0-9]+)');
        if regex.match(node.FullTagContent) then
        begin
          h := StrToInt(regex.getsubexpr('h'));
          min := StrToInt(regex.getsubexpr('min'));
          sec := StrToInt(regex.getsubexpr('sec'));
          end_time := Date + h/24 + min/24/60 + sec/24/60/60;

          fleet.head.unique_id := 0;
          fleet.head.eventtype := fet_none;
          fleet.head.eventflags := [];
          fleet.head.origin := StrToPosition('1:1:1');
          fleet.head.target := StrToPosition('1:1:1');
          fleet.head.arrival_time_u := DateTimeToUnix(end_time);
          fleet.head.player := 'self';
          fleet.head.joined_id := 0;

          Add(fleet);
        end;
      end;
    end;
  finally
    regex.Free;
  end;
end;

function ThtmlPhalanxRead_betauni.ReadHTML_Elements(
  doc_html: THTMLElement): integer;
begin
  //Find and read FleetEvents:
  doc_html.DeleteTagRoutine(checkTags, nil);

  // search for building time:
  ReadHTML_BuildTimer(doc_html);

  Result := fleets.Count;
end;

// read antigame fleetinfo
function ThtmlPhalanxRead_betauni.readHtmlTag_ress_fleet(const tag: THTMLElement;
   var fleet: TFleetEvent): boolean;
var s, s_ships: string;
    el: THTMLElement;
    tmp_report: TScanBericht;
    c, i: integer;
begin
  Result := False;

  el := tag.ParentElement;
  if el = nil then Exit;

  el := el.FindChildTag(tag.TagName, tag.TagNameNr+1); // get next tr-tag in table!
  if el = nil then Exit;

  // check tag-class:
  if copy(el.AttributeValue['class'], 1, 19) <> 'antigame_evtDetails' then Exit;

  s := el.FullTagContent + (tag.TagPath);
  //s := ReplaceStr(s,#13,' ');
  //s := ReplaceStr(s,#10,' ');
  s_ships := ReplaceStr(s,':',' ');

  tmp_report := TScanBericht.Create;
  try
    c := readreport._LeseTeilScanBericht(s_ships, tmp_report, sg_Flotten, False);
    Result := c > 0;
    if Result then
    begin
      SetLength(fleet.ships, tmp_report.Count(sg_Flotten));
      for i := 0 to length(fleet.ships)-1 do
      begin
        fleet.ships[i] := tmp_report.Bericht[sg_Flotten,i];
      end;
    end;

    c := readreport._LeseTeilScanBericht(s, tmp_report, sg_Rohstoffe, False);
    Result := c > 0;
    if Result then
    begin
      SetLength(fleet.ress, tmp_report.Count(sg_Rohstoffe));
      for i := 0 to length(fleet.ress)-1 do
      begin
        fleet.ress[i] := tmp_report.Bericht[sg_Rohstoffe,i];
      end;
    end;
  except
    Result := false;
  end;
  tmp_report.Free;
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
var el, tag_ul, tag_x: THTMLElement;
    fleet: TFleetEvent;
    i, sec: integer;
    timepos, tmppos: TPlanetPosition;
    p1, p2: TPlanetPosition;
    time_ber: TDateTime;

    s: string;
    p: integer;

    fet: TFleetEventType;
begin
  sec := 0;
  Result := false;
  FillChar(fleet, sizeof(fleet), 0);

  //unique ID
  s := tag.AttributeValue['id'];
  p := pos('-',s);
  if (p = 0) then
  begin
    // try to get counter id:
    el := tag.FindChildTag('td');
    if el = nil then Exit;
    s := el.AttributeValue['id'];
    p := pos('-',s);
  end;
  if p = 0 then Exit;
  fleet.head.unique_id := ReadInt(s,p+1);


  //tag_ul := tag.FindChildTag('ul');
  //if (tag_ul = nil) then exit;+
  tag_ul := tag;
  for i := 0 to tag_ul.ChildCount - 1 do
  begin
    el := tag_ul.ChildElements[i];
    s := el.AttributeValue['class'];

    if s = 'missionFleet' then
    begin
      tag_x := el.FindChildTag('img');
      if (tag_x <> nil) then
      begin
        s := tag_x.AttributeValue['title'];

        for fet := low(fet) to high(fet) do
        begin
          if PosEx(html_fleetevent[fet], s, 1) > 0 then
          begin
            fleet.head.eventtype := fet;
            break;
          end;
        end;

        if (fleet.head.eventtype = fet_none) then
        begin
          // check for alliance attack
          s := tag_x.AttributeValue['src'];
          if pos('icon-verband.gif', s) > 0 then
          begin
            fleet.head.eventtype := fet_attack; // alliance attack!
            p1.P[0] := 1;
            p1.P[1] := 1;
            p1.P[2] := 1;
          end;
        end;

        (*if pos('(R)', s) > 0 then
        begin
          include(fleet.head.eventflags, fef_return);

          // tausche positionen, if positions was first read
          tmppos := fleet.head.origin;
          fleet.head.origin := fleet.head.target;
          fleet.head.target := tmppos;
        end;*)
      end;
    end
    else
    if s = 'icon_movement_reserve' then
    begin
      include(fleet.head.eventflags, fef_return); 
    end
    else
    if s = 'coordsOrigin' then
    begin
      s := el.FullTagContent;
      p := pos('[',s);
      FillChar(tmppos, sizeof(tmppos), 0);
      ReadPosOrTime(s,p+1,tmppos);
      if tmppos.P[0] <> 0 then
        p1.P := tmppos.P;
    end
    else
    if s = 'originFleet' then
    begin
      s := Trim(el.FullTagContent);
      if s = str_moon then
        p1.Mond := true;
    end
    else
    if s = 'destFleet' then
    begin
      s := Trim(el.FullTagContent);
      if s = str_moon then
        p2.Mond := true;
    end
    else
    if s = 'destCoords' then
    begin
      s := el.FullTagContent;
      p := pos('[',s);
      FillChar(tmppos, sizeof(tmppos), 0);
      ReadPosOrTime(s,p+1,tmppos);
      p2.P := tmppos.P;
    end
    else
    if s = 'arrivalTime' then
    begin
      s := trim(el.FullTagContent);
      arrival_regexp.match(s);
      timepos.P[0] := StrToInt(arrival_regexp.getsubexpr('h'));
      timepos.P[1] := StrToInt(arrival_regexp.getsubexpr('min'));
      timepos.P[2] := StrToInt(arrival_regexp.getsubexpr('sec'));
    end
    else
    if (copy(s,1,9) = 'countDown')or
       (copy(el.AttributeValue['id'],1,8) = 'counter-') then
    begin
      // read netral/friendly/hostile
      if pos('friendly',s) > 0 then
      begin
        include(fleet.head.eventflags, fef_friendly);
      end;
      if pos('hostile',s) > 0 then
      begin
        include(fleet.head.eventflags, fef_hostile);
      end;
      if pos('neutral',s) > 0 then
      begin
        include(fleet.head.eventflags, fef_neutral);
      end;

      // get time
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
    end
    else
    if copy(s,1,9) = 'sendProbe' then
    begin
      (*tag_x := el.FindChildTag('a');
      if (tag_x <> nil) then
      begin
        s := tag_x.AttributeValue['href'];
        if pos('&amp;planetType=1&amp;', s) > 0 then
          fleet.head.target.Mond := true
        else
        if pos('&amp;planetType=0&amp;', s) > 0 then
          fleet.head.target.Mond := false;
      end;*)
    end;

  end;

  if (fef_return in fleet.head.eventflags) then
  begin
    fleet.head.origin := p2;
    fleet.head.target := p1;
  end
  else
  begin
    fleet.head.origin := p1;
    fleet.head.target := p2;
  end;

  //Zeiten:
  time_ber := Now() + sec/60/60/24;
  time_ber := trunc(time_ber) + timepos.P[0]/24 + timepos.P[1]/24/60 + timepos.P[2]/24/60/60;
  fleet.Head.arrival_time_u := DateTimeToUnix(time_ber);

  {//Planeten Koords
  if not readHtmlTag_planetposition_and_fleettype(tag, fce, fleet) then
    Exit;}

  // fleet ress and ships init
  initFleet(fleet);

  //Ress/Fleet einlesen
  readHtmlTag_ress_fleet(tag_ul,fleet);

  // quickfix: creaturesScan is currently
  // not able to handle the x:xxx:16 position in expeditions
  // -> replace with x:xxx:15
  if (fleet.head.eventtype = fet_expedition) then
  begin
    if (fef_return in fleet.head.eventflags) then
    begin
      fleet.head.origin.P[2] := 15;
    end
    else
    begin
      fleet.head.target.P[2] := 15;
    end;
  end;

  Add(fleet);
end;

procedure ThtmlPhalanxRead_betauni.initFleet(var fleet: TFleetEvent);
var i: integer;
begin
  //REss initialisieren:
  SetLength(fleet.ress, ScanFileCounts[sg_Rohstoffe]);
  for i := 0 to length(fleet.ress)-1 do
    fleet.ress[i] := 0;

  //Flotte initialisieren:
  SetLength(fleet.ships, ScanFileCounts[sg_Flotten]);
  for i := 0 to length(fleet.ships)-1 do
    fleet.ships[i] := 0;
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
