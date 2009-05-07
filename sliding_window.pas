unit sliding_window;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls;

type
  TSlidingForm = class(TForm)
  private
    sollpos_left, sollpos_top: integer;
    sld_timer: TTimer;
    procedure sld_timer_timer(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SlideTo(aleft, atop: integer);
    { Public-Deklarationen }
  end;

implementation

constructor TSlidingForm.Create(AOwner: TComponent);
begin
  inherited;
  
  sld_timer := TTimer.Create(self);
  sld_timer.Interval := 25;
  sld_timer.OnTimer := sld_timer_timer;
  sld_timer.Enabled := true;
  
  sollpos_left := Left;
  sollpos_top := Top;
end;

destructor TSlidingForm.Destroy;
begin
  sld_timer.Free;
  inherited;
end;

procedure TSlidingForm.sld_timer_timer(Sender: TObject);
var dist_g: single;
    dx,dy,dist_x,dist_y: integer;
begin
  dist_x := sollpos_left-left;
  dist_y := sollpos_top-top;
  dist_g := sqrt(sqr(dist_x)+sqr(dist_y));
  if dist_g > 0 then
  begin
    dx := trunc(10* dist_x / dist_g);
    dy := trunc(10* dist_y / dist_g);
    if abs(dx) > abs(dist_x) then dx := dist_x;
    if abs(dy) > abs(dist_y) then dy := dist_y;

      Left := Left + dx;
      top := top + dy;
  end
  else
    sld_timer.Enabled := False;
end;

procedure TSlidingForm.SlideTo(aleft, atop: integer);
begin
  sollpos_left := aleft;
  sollpos_top := atop;
  sld_timer.Enabled := true;
end;

end.
 
