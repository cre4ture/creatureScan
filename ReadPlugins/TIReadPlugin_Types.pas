unit TIReadPlugin_Types;

interface

uses OGame_Types, Classes;

const MaxListSize = MaxInt div 16;

type
  // 0 -> gala, 1 -> sys, 2 -> pos, 3 -> planet(0), moon(1), tf(2)
  PPortablePlanetPosition = ^TPortablePlanetPosition;
  TPortablePlanetPosition = array[0..3] of integer;
  TPortableSolarSystemPosition = array[0..1] of integer;

  TPortableArrayInteger = array[0..MaxListSize] of Integer;
  TPortableArrayInt64 = array[0..MaxListSize] of Int64;
  TPortableArrayShortInt = array[0..MaxListSize] of ShortInt;

  PPortableScanHead = ^TPortableScanHead;
  PPPortableScanHead = ^PPortableScanHead;
  TPortableScanHead = packed record
    PlanetName: PAnsiChar;
    Position: TPortablePlanetPosition;
    Time_u: Int64;    //Unix
    Player: PAnsiChar;
    PlayerId: Int64;
    Spionageabwehr: Integer;
    Creator: PAnsiChar;
    Activity: Integer; {Time in Seconds (min*60) befor Time_u, -1 -> no info, 0 -> activity > 60 minutes}
  end;

  PPortableScanBody = ^TPortableScanBody;
  PPPortableScanBody = ^PPortableScanBody;
  TPortableScanBody = packed record
    resources: ^TPortableArrayInt64;
    fleets   : ^TPortableArrayInteger;
    defence  : ^TPortableArrayInteger;
    buildings: ^TPortableArrayShortInt;
    research : ^TPortableArrayShortInt;
  end;

  PPortableFleetsInfoSource = ^TPortableFleetsInfoSource;
  PPPortableFleetsInfoSource = ^PPortableFleetsInfoSource;
  TPortableFleetsInfoSource = packed record
    typ: Integer;
    count: Integer;
    planet: TPortablePlanetPosition;
    time_u: Int64;
  end;

  PPortableStatisticEntry = ^TPortableStatisticEntry;
  PPPortableStatisticEntry = ^PPortableStatisticEntry;
  TPortableStatisticEntry = packed record
    NameId: Int64;
    Points: Int64;
    Elements: Int64;    // Anzahl Spieler in Ally oder Anzahl Schiffe
    Name: PAnsiChar;
    Ally: PAnsiChar;    //nur für spielerstats! bei allystats wird der allyname in den Spielernamen geschrieben!
  end;
  
  PPortableStatisticPageHead = ^TPortableStatisticPageHead;
  PPPortableStatisticPageHead = ^PPortableStatisticPageHead;
  TPortableStatisticPageHead = packed record
    nametype: integer;
    pointtype: integer;
    first: Integer;
    count: Integer;
    Time_u: Int64;
  end;

  PPortableSolarSystemHead = ^TPortableSolarSystemHead;
  PPPortableSolarSystemHead = ^PPortableSolarSystemHead;
  TPortableSolarSystemHead = packed record
    Postion: TPortableSolarSystemPosition;
    Creator: PAnsiChar;
    Time_u: Int64;
  end;

  PPortableSolarSystemPlanet = ^TPortableSolarSystemPlanet;
  PPPortableSolarSystemPlanet = ^PPortableSolarSystemPlanet;
  TPortableSolarSystemPlanet = packed record
    Player: PAnsiChar;
    PlayerId: Int64;
    PlanetName: PAnsiChar;
    LastActivity: Integer; {Time in Seconds (min*60) befor Time_u, -15 -> (*) within last 15min, 0 -> activity > 60 minutes}
    Ally: PAnsiChar;
    AllyId: Int64;
    Status: Integer;
    MoonSize: Integer;
    MoonTemp: Integer;
    TF_Metal: Int64;
    TF_Crystal: Int64;
  end;

// in this file only the UNICODE-independent conversion can be done:

procedure createPortable_PlanetPosition(const pos: TPlanetPosition;
  out portable: TPortablePlanetPosition);

procedure makeFromPortable_PlanetPosition(
  const portable: TPortablePlanetPosition;
  var pos: TPlanetPosition);

implementation

uses Math;

procedure createPortable_PlanetPosition(const pos: TPlanetPosition;
  out portable: TPortablePlanetPosition);
begin
  portable[0] := pos.P[0];
  portable[1] := pos.P[1];
  portable[2] := pos.P[2];
  portable[3] := IfThen(pos.Mond,1,0);
end;

procedure makeFromPortable_PlanetPosition(
  const portable: TPortablePlanetPosition;
  var pos: TPlanetPosition);
begin
  pos.P[0] := portable[0];
  pos.P[1] := portable[1];
  pos.P[2] := portable[2];
  pos.Mond := (portable[3] = 1);
end;

end.
