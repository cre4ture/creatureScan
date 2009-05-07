unit OtherTime;

interface

type
  TCustomTime = class
  protected
    function GetTime: TDateTime; virtual; abstract;
    function GetUnixTime: Int64;
  public
    property Time: TDateTime read GetTime;
    property UnixTime: Int64 read GetUnixTime;
  end;
  TSystemTime = class(TCustomTime)
  protected
    function GetTime: TDateTime; override;
  public
  end;
  TDeltaSystemTime = class(TCustomTime)
  protected
    fTimeDelta: TDateTime;
    function GetTime: TDateTime; override;
  public
    procedure setTime(reference_time: TDateTime);
    constructor Create(aTimeDelta: TDateTime = 0);
    property TimeDelta: TDateTime read fTimeDelta write fTimeDelta;
  end;

implementation

uses DateUtils, SysUtils;

constructor TDeltaSystemTime.Create(aTimeDelta: TDateTime = 0);
begin
  inherited Create();
  fTimeDelta := aTimeDelta;
end;

function TDeltaSystemTime.GetTime: TDateTime;
begin
  Result := Now + TimeDelta;
end;

procedure TDeltaSystemTime.setTime(reference_time: TDateTime);
begin
  TimeDelta := reference_time - Now();
end;

function TSystemTime.GetTime: TDateTime;
begin
  Result := Now;
end;

function TCustomTime.GetUnixTime: Int64;
begin
  Result := DateTimeToUnix(GetTime);
end;

end.
 