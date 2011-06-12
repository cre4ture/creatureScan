unit ActivityFinder;

interface

uses Classes, SysUtils, Ogame_Types;

type
  TActivity = class
  private
    ftime: int64;
    fpos: TPlanetPosition;
  public
    property time: Int64 read ftime;
    property pos: TPlanetPosition read fpos;
    constructor Create(time: Int64; pos: TPlanetPosition);
  end;
  TActivityFinder = class
  private
    fname: string;
    ftimes: TList;
    baseDate: Int64;
    function getTimes(index: integer): int64;
    procedure clear;

  public
    property name: string read fname;
    property times_u[index: integer]: int64 read getTimes;
    procedure addActivity(time_u: int64; pos: TPlanetPosition);
    function count: integer;
    constructor Create(playerName: string);
    destructor Destroy;
  end;

implementation

uses DateUtils;

{ ActivityFinder }

procedure TActivityFinder.addActivity(time_u: int64; pos: TPlanetPosition);
var act: TActivity;
begin
  act := TActivity.Create(time_u, pos);
  ftimes.Add(act);
end;

procedure TActivityFinder.clear;
var i: integer;
begin
  for i := 0 to ftimes.Count-1 do
  begin
    TActivity(ftimes[i]).Free;
  end;
  ftimes.Clear;
end;

function TActivityFinder.count: integer;
begin
  Result := ftimes.Count;
end;

constructor TActivityFinder.Create(playerName: string);
begin
  inherited Create();
  fname := playerName;
end;

destructor TActivityFinder.Destroy;
begin
  clear;
  ftimes.Free;
  inherited;
end;

function TActivityFinder.getTimes(index: integer): int64;
begin
  result := TActivity(ftimes[index]).time;
end;

{ TActivity }

constructor TActivity.Create(time: Int64; pos: TPlanetPosition);
begin
  inherited Create();
  ftime := time;
  fpos := pos;
end;

end.
