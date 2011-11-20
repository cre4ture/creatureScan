unit TIReadPlugin_Types_conv_UNICODE;

interface

uses TIReadPlugin_Types, OGame_Types, Generics.Collections;

// in this file, the conversion are valid vor the
// UNICODE version of Delphi!

type
  TUtf8StringContainer = class
  private
    fStringList: TList<AnsiString>;
  public
    function pushBackUtf8(utf8: AnsiString): PAnsiChar; // no convertion is done!
    function pushBackString(text: string): PAnsiChar; // auto convert to utf8

    constructor Create;
    destructor Destroy; override;
  end;

// doesn't copy data, uses pointer to existing data
procedure createPortable_Scan(const scan: TScanBericht;
  out portableHead: TPortableScanHead;
  out portableBody: TPortableScanBody;
  container: TUtf8StringContainer);

// copies all data!
procedure makeFromPortable_Scan(
  const portableHead: TPortableScanHead;
  const portableBody: TPortableScanBody;
  scan: TScanBericht);

procedure makeFromPortable_StatisticPageHead(
  const portableHead: TPortableStatisticPageHead;
  var stats: TStat;
  var typ: TStatTypeEx);

procedure makeFromPortable_StatisticEntry(
  const portable: TPortableStatisticEntry;
  var stats: TStatPlayer);

procedure makeFromPortable_FleetInfoSource(
  const portable: TPortableFleetsInfoSource;
  var info: TFleetsInfoSource);

procedure makeFromPortable_SolarSystemPlanet(
  const portable: TPortableSolarSystemPlanet;
  var planet: TSystemPlanet);

procedure makeFromPortable_SolarSystemHead(
  const portable: TPortableSolarSystemHead;
  var solsys: TSystemCopy);

implementation

procedure createPortable_Scan(const scan: TScanBericht;
  out portableHead: TPortableScanHead;
  out portableBody: TPortableScanBody;
  container: TUtf8StringContainer);
begin
  // head
  portableHead.PlanetName := container.pushBackString(scan.Head.Planet);
  createPortable_PlanetPosition(scan.Head.Position, portableHead.Position);
  portableHead.Time_u := scan.Head.Time_u;
  portableHead.Player := container.pushBackString(scan.Head.Spieler); // internal convertion to utf8
  portableHead.PlayerId := scan.Head.SpielerId;
  portableHead.Spionageabwehr := scan.Head.Spionageabwehr;
  portableHead.Creator := container.pushBackString(scan.Head.Creator);
  portableHead.Activity := scan.Head.Activity;

  // body
  portableBody.resources := @scan.resources;
  portableBody.fleets := @scan.fleets;
  portableBody.defence := @scan.defence;
  portableBody.buildings := @scan.buildings;
  portableBody.research := @scan.research;
end;

procedure makeFromPortable_Scan(
  const portableHead: TPortableScanHead;
  const portableBody: TPortableScanBody;
  scan: TScanBericht);
  
var i: integer;
begin
  // head
  scan.Head.Planet := UTF8ToWideString(portableHead.PlanetName);
  makeFromPortable_PlanetPosition(portableHead.Position, scan.Head.Position);
  scan.Head.Time_u := scan.Head.Time_u;
  scan.Head.Spieler := UTF8ToWideString(portableHead.Player);
  scan.Head.SpielerId := portableHead.PlayerId; 
  scan.Head.Spionageabwehr := portableHead.Spionageabwehr;
  scan.Head.Creator := UTF8ToWideString(portableHead.Creator);
  scan.Head.Activity := portableHead.Activity;

  // body
  for i := 0 to length(scan.resources)-1 do
    scan.resources[i] := portableBody.resources[i];
  for i := 0 to length(scan.fleets)-1 do
    scan.fleets[i] := portableBody.fleets[i];
  for i := 0 to length(scan.defence)-1 do
    scan.defence[i] := portableBody.defence[i];
  for i := 0 to length(scan.buildings)-1 do
    scan.buildings[i] := portableBody.buildings[i];
  for i := 0 to length(scan.research)-1 do
    scan.research[i] := portableBody.research[i];
end;

procedure createPortable_StatisticPageHead(const stats: TStat;
  const typ: TStatTypeEx;
  out portableHead: TPortableStatisticPageHead);
begin
  portableHead.nametype := Integer(typ.NameType);
  portableHead.pointtype := Integer(typ.PointType);
  portableHead.first := stats.first;
  portableHead.count := stats.count;
  portableHead.Time_u := stats.Time_u;
end;

procedure makeFromPortable_StatisticPageHead(
  const portableHead: TPortableStatisticPageHead;
  var stats: TStat;
  var typ: TStatTypeEx);
begin
  typ.NameType := TStatNameType(portableHead.nametype);
  typ.PointType := TStatPointType(portableHead.pointtype);
  stats.first := portableHead.first;
  stats.count := portableHead.count;
  stats.Time_u := portableHead.Time_u;
end;

procedure makeFromPortable_StatisticEntry(
  const portable: TPortableStatisticEntry;
  var stats: TStatPlayer);
begin
  stats.Name := UTF8ToWideString(portable.Name);
  stats.NameId := portable.NameId;
  stats.Punkte := portable.Points;
  stats.Ally := UTF8ToWideString(portable.Ally);
  stats.Mitglieder := portable.Members;
end;

procedure makeFromPortable_FleetInfoSource(
  const portable: TPortableFleetsInfoSource;
  var info: TFleetsInfoSource);
begin
  info.typ := TFleetsInfoSourceType(portable.typ);
  info.count := portable.count;
  makeFromPortable_PlanetPosition(portable.planet, info.planet);
  info.time := portable.time_u;
end;

procedure makeFromPortable_SolarSystemPlanet(
  const portable: TPortableSolarSystemPlanet;
  var planet: TSystemPlanet);
begin
  planet.Player := UTF8ToWideString(portable.Player);
  planet.PlayerId := portable.PlayerId;
  planet.PlanetName := UTF8ToWideString(portable.PlanetName);
  planet.Ally := UTF8ToWideString(portable.Ally);
  planet.AllyId := portable.AllyId;
  planet.Status := TStatus((@portable.Status)^);
  planet.MondSize := portable.MoonSize;
  planet.MondTemp := portable.MoonTemp;
  planet.TF[0] := portable.TF_Metal;
  planet.TF[1] := portable.TF_Crystal;
  planet.Activity := portable.LastActivity;
end;

procedure makeFromPortable_SolarSystemHead(
  const portable: TPortableSolarSystemHead;
  var solsys: TSystemCopy);
begin
  solsys.Time_u := portable.Time_u;
  solsys.System.P[0] := portable.Postion[0];
  solsys.System.P[1] := portable.Postion[1];
  solsys.System.P[2] := 1;
  solsys.System.Mond := false;
  solsys.Creator := UTF8ToWideString(portable.Creator);
end;

{ TUtf8StringContainer }

constructor TUtf8StringContainer.Create;
begin
  fStringList := TList<AnsiString>.Create;
end;

destructor TUtf8StringContainer.Destroy;
begin
  fStringList.Free;
  inherited;
end;

function TUtf8StringContainer.pushBackUtf8(utf8: AnsiString): PAnsiChar;
var i: integer;
begin
  i := fStringList.Add(utf8);
  Result := PAnsiChar(fStringList[i]);
end;

function TUtf8StringContainer.pushBackString(text: string): PAnsiChar;
begin
  result := pushBackUtf8(UTF8Encode(text));
end;

end.
