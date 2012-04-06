unit cS_DB;

{

Autor: Ulrich Hornung
Datum: 14.7.2007

23.5.2008: Neu: TcSActivityStatDB

}

interface

uses
  OGame_Types;

type
  TcSReportDB = class
  protected
    function GetReport(nr: cardinal): TScanBericht; virtual; abstract;
    procedure SetReport(nr: cardinal; Report: TScanBericht); virtual; abstract;
    function GetCount: Integer; virtual; abstract;
  public
    property Reports[nr: cardinal]: TScanBericht read GetReport write SetReport; default;
    property Count: Integer read GetCount;
    function FindLatestReport(pos: TPlanetPosition): Integer; virtual;
    function AddReport(Report: TScanBericht): Integer; virtual; abstract;

    //Only for compatibility to the old Code:
    property ScanCount: Integer read GetCount;
    procedure DeleteLastScan; virtual; abstract;
  end;

  TcSGenericItemDB<T> = class
  protected
    function GetGenericItem(nr: cardinal): T; virtual; abstract;
    procedure SetGenericItem(nr: cardinal; GenericItem: T); virtual; abstract;
    function GetCount: Integer; virtual; abstract;
  public
    property GenericItems[nr: cardinal]: T read GetGenericItem write SetGenericItem; default;
    property Count: Integer read GetCount;
    function AddGenericItem(Item: T): Integer; virtual; abstract;
    procedure DeleteLastGenericItem; virtual; abstract;
  end;

  TcSSolSysDB = class
  protected
    function GetSolSys(nr: Cardinal): TSystemCopy; virtual; abstract;
    procedure SetSolSys(nr: Cardinal; SolSys: TSystemCopy); virtual; abstract;
    function GetCount: Integer; virtual; abstract;
  public
    property SolSys[nr: cardinal]: TSystemCopy read GetSolSys write SetSolSys; default;
    property Count: Integer read GetCount;
    function FindLatestSolSys(pos: TSolSysPosition): Integer;  //WithoutUse
    function AddSolSys(Sys: TSystemCopy): Integer; virtual; abstract;

    //Only for compatibility to the old Code:
    property SysCount: Integer read GetCount;
    procedure DeleteLastSys; virtual; abstract;
  end;

  TcSFleetDB = class
  protected
    function GetFleet(nr: Cardinal): TFleetEvent; virtual; abstract;
    procedure SetFleet(nr: Cardinal; Fleet: TFleetEvent); virtual; abstract;
    function GetCount: Integer; virtual; abstract;
  public
    property Fleets[nr: cardinal]: TFleetEvent read GetFleet write SetFleet; default;
    property Count: Integer read GetCount;
    function AddFleet(Fleet: TFleetEvent): Integer; virtual; abstract;

    //Only for compatibility to the old Code:
    procedure DeleteLastFleet; virtual; abstract;
  end;

  TcSActivityStatDB = class
  protected
    function Get(nr: Cardinal): TFleetEvent; virtual; abstract;
    procedure SetFleet(nr: Cardinal; Fleet: TFleetEvent); virtual; abstract;
    function GetCount: Integer; virtual; abstract;
  public
    //blablabla
  end;

implementation

function TcSReportDB.FindLatestReport(pos: TPlanetPosition): Integer;
var i: Integer;
    t: Int64;
begin
  Result := -1;
  t := low(t);
  for i := 0 to Count-1 do
    if SamePlanet(pos,Reports[i].Head.Position)and
       (Reports[i].Head.Time_u > t) then
    begin
      Result := i;
      t := Reports[i].Head.Time_u;
    end;
end;

function TcSSolSysDB.FindLatestSolSys(pos: TSolSysPosition): Integer;
var i: Integer;
    t: Int64;
begin
  Result := -1;
  t := low(t);
  for i := 0 to Count-1 do
    if (pos[0] = SolSys[i].System.P[0])and
       (pos[1] = SolSys[i].System.P[1])and
       (SolSys[i].Time_u > t) then
    begin
      Result := i;
      t := SolSys[i].Time_u;
    end;
end;

end.
