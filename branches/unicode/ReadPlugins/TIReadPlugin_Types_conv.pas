unit TIReadPlugin_Types_conv;

interface

uses TIReadPlugin_Types, OGame_Types;

// in this file, the conversion are valid vor the
// none-UNICODE version of Delphi!

// doesn't copy data, uses pointer to existing data
procedure createPortable_Scan(const scan: TScanBericht;
  out portableHead: TPortableScanHead;
  out portableBody: TPortableScanBody);

// copies all data!
procedure makeFromPortable_Scan(
  const portableHead: TPortableScanHead;
  const portableBody: TPortableScanBody;
  scan: TScanBericht);

// copy
procedure createPortable_StatisticPageHead(const stats: TStat;
  const typ: TStatTypeEx;
  out portableHead: TPortableStatisticPageHead);

// doesn't copy data, uses pointer to existing data
procedure createPortable_StatisticEntry(const stats: TStatPlayer;
  out portable: TPortableStatisticEntry);

procedure createPortable_FleetInfoSource(const info: TFleetsInfoSource;
  out portable: TPortableFleetsInfoSource);

// copies only partly
procedure createPortable_SolarSystemPlanet(const planet: TSystemPlanet;
  out portable: TPortableSolarSystemPlanet);

// copies only partly
procedure createPortable_SolarSystemHead(const solsys: TSystemCopy;
  out portable: TPortableSolarSystemHead);

implementation

procedure createPortable_Scan(const scan: TScanBericht;
  out portableHead: TPortableScanHead;
  out portableBody: TPortableScanBody);
begin
  // head
  portableHead.PlanetName := PAnsiChar(scan.Head.Planet);
  createPortable_PlanetPosition(scan.Head.Position, portableHead.Position);
  portableHead.Time_u := scan.Head.Time_u;
  portableHead.Player := PAnsiChar(scan.Head.Spieler);
  portableHead.PlayerId := scan.Head.SpielerId;
  portableHead.Spionageabwehr := scan.Head.Spionageabwehr;
  portableHead.Creator := PAnsiChar(scan.Head.Creator);
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
  scan.Head.Planet := portableHead.PlanetName;
  makeFromPortable_PlanetPosition(portableHead.Position, scan.Head.Position);
  scan.Head.Time_u := scan.Head.Time_u;
  scan.Head.Spieler := portableHead.Player;
  scan.Head.SpielerId := portableHead.PlayerId; 
  scan.Head.Spionageabwehr := portableHead.Spionageabwehr;
  scan.Head.Creator := portableHead.Creator;
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

procedure createPortable_StatisticEntry(const stats: TStatPlayer;
  out portable: TPortableStatisticEntry);
begin
  portable.Name := PAnsiChar(stats.Name);
  portable.NameId := stats.NameId;
  portable.Points := stats.Punkte;
  portable.Ally := PAnsiChar(stats.Ally);
  portable.Members := stats.Mitglieder;
end;

procedure createPortable_FleetInfoSource(const info: TFleetsInfoSource;
  out portable: TPortableFleetsInfoSource);
begin
  portable.typ := integer(info.typ);
  portable.count := info.count;
  createPortable_PlanetPosition(info.planet, portable.planet);
  portable.time_u := info.time;
end;

procedure createPortable_SolarSystemPlanet(const planet: TSystemPlanet;
  out portable: TPortableSolarSystemPlanet);
begin
  portable.Player := PAnsiChar(planet.Player);
  portable.PlayerId := planet.PlayerId;
  portable.PlanetName := PAnsiChar(planet.PlanetName);
  portable.LastActivity := planet.Activity;
  portable.Ally := PAnsiChar(planet.Ally);
  portable.AllyId := planet.AllyId;
  portable.Status := Integer((@planet.Status)^);
  portable.MoonSize := planet.MondSize;
  portable.MoonTemp := planet.MondTemp;
  portable.TF_Metal := planet.TF[0];
  portable.TF_Crystal := planet.TF[1];
end;

procedure createPortable_SolarSystemHead(const solsys: TSystemCopy;
  out portable: TPortableSolarSystemHead);
begin
  portable.Postion[0] := solsys.System.P[0];
  portable.Postion[1] := solsys.System.P[1];
  portable.Creator := PAnsiChar(solsys.Creator);
  portable.Time_u := solsys.Time_u;
end;

end.
