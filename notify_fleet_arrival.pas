unit notify_fleet_arrival;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, notifywindow, StdCtrls, Ogame_Types, ExtCtrls, Prog_Unit, Main, OtherTime;

type
  Tfrm_fleet_arrival = class(Tfrm_notify)
    lbl_title: TLabel;
    lbl_description: TLabel;
    lbl_desc_2: TLabel;
    procedure Timer1Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClick(Sender: TObject);
  private
    finfo_fleet: TFleetEvent;
    { Private-Deklarationen }
    procedure InitInfo;
    procedure SetInfoFleet(flt: TFleetEvent);
  public
    time_to_live: integer;
    gameTime: TCustomTime;
    close_when_arrived: boolean;
    { Public-Deklarationen }
    property info_fleet: TFleetEvent read finfo_fleet write SetInfoFleet;
  end;

function CountDownStr(sec: int64): string;

implementation

uses DateUtils;

{$R *.dfm}

procedure Tfrm_fleet_arrival.Timer1Timer(Sender: TObject);
var zeit: int64;
    s: string;
begin
  zeit := info_fleet.head.arrival_time_u - gameTime.UnixTime;

  s := CountDownStr(zeit);
  s := s + ' [' + PositionToStrMond(info_fleet.head.target) + ']';
  s := s + ' ' + FleetEventTypeToStr_(info_fleet.head.eventtype);

  lbl_title.Caption := s;
  lbl_description.Caption := '[' + PositionToStrMond(info_fleet.head.origin) + '] ' +
                             info_fleet.head.player + ' -> ' +
                             ODataBase.GetPlayerAtPos(info_fleet.head.target);
  lbl_desc_2.Caption := 'arrival: ' +  DateTimeToStr(UnixToDateTime(info_fleet.head.arrival_time_u));

  priority := zeit;
  dec(time_to_live);
  if time_to_live < 0 then
  begin
    if (close_when_arrived) then
      Release;
    Color := not Color;
  end;
end;

procedure Tfrm_fleet_arrival.FormShow(Sender: TObject);
begin
  Timer1Timer(Sender);
  group_owner.refresh_positions;
end;

procedure Tfrm_fleet_arrival.FormCreate(Sender: TObject);
begin
  inherited;
  time_to_live := 1;  //Damit das der erste timeraufruf bei OnShow überlebt!
  gameTime := ODataBase.FleetBoard.GameTime;
  close_when_arrived := true;
end;

procedure Tfrm_fleet_arrival.FormClick(Sender: TObject);
begin
  inherited;
  if time_to_live > 0 then
  begin
    FRM_Main.ShowScan(info_fleet.head.target);
    FRM_Main.Show;
  end
  else
  begin
    Release; // remove window!
  end;
end;

function CountDownStr(sec: int64): string;
var h,m,s: int64;
begin
  h := sec div 3600;
  m := (sec div 60) mod 60;
  s := sec mod 60;
  Result := FormatFloat('00',m) + ':' + FormatFloat('00',s);
  if h > 0 then
    Result := FormatFloat('00',h) + ':' + Result;
end;

procedure Tfrm_fleet_arrival.InitInfo;
begin
  if fef_return in info_fleet.head.eventflags then
  begin
    Color := clWhite;
    lbl_title.Top := lbl_description.Height;
    lbl_description.Top := 0;
  end;
  if fef_hostile in info_fleet.head.eventflags then
  begin
    Color := clRed;
  end;
end;

procedure Tfrm_fleet_arrival.SetInfoFleet(flt: TFleetEvent);
begin
  finfo_fleet := flt;
  InitInfo;
end;

procedure ReleaseTimer;
begin

end;

end.
