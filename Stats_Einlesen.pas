unit Stats_Einlesen;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, OGame_Types, Prog_Unit, Clipbrd, Languages,
  clipbrdfunctions, Stat_Points, ComCtrls;

type
  TFRM_Stats_Einlesen = class(TForm)
    TabControl1: TTabControl;
    ScrollBox1: TScrollBox;
    pb_points: TPaintBox;
    pb_fleet: TPaintBox;
    pb_place_range: TPaintBox;
    pb_research: TPaintBox;
    Label5: TLabel;
    Label4: TLabel;
    Label2: TLabel;
    Timer1: TTimer;
    Panel1: TPanel;
    Label3: TLabel;
    TXT_punkte: TEdit;
    TXT_Ally: TEdit;
    TXT_fleet: TEdit;
    Button1: TButton;
    Button2: TButton;
    procedure pb_place_rangePaint(Sender: TObject);
    procedure pb_pointsPaint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure TabControl1Change(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure Button2Click(Sender: TObject);
  private
    place_hundred_count: integer;
    nt: TStatNameType;
    procedure refreshStats();
  public
    procedure refreshOwnPoints();
  end;

implementation

uses main;

{$R *.DFM}

procedure TFRM_Stats_Einlesen.pb_place_rangePaint(Sender: TObject);
var i: integer;
begin
  with TPaintBox(Sender) do
  begin
    Canvas.Pen.Style := psClear;
    Canvas.Rectangle(Canvas.ClipRect);
    i := 0;
    while i < place_hundred_count do
    begin
      Canvas.TextOut(5,i*16+1,
        IntToStr((i*100)+1) + ' - ' + IntToStr((i*100)+100));
      inc(i);
    end;
  end;
end;

procedure TFRM_Stats_Einlesen.pb_pointsPaint(Sender: TObject);
var i: integer;
    D: TDateTime;
    St: TStatPoints;
    pt: TStatPointType;
begin
  case TComponent(Sender).Tag of
    0: pt := sptPoints;
    1: pt := sptFleet;
    2: pt := sptResearch;
  else
    Exit;
  end;

  St := ODataBase.Statistic.StatisticType[nt, pt];
  
  with TPaintBox(Sender) do
  begin
    Canvas.Pen.Style := psClear;
    for i := 0 to St.Count-1 do
    begin
      d := St.Datum[i*100+1];
      Canvas.Brush.Color := AlterToColor_dt(
         ODataBase.FleetBoard.GameTime.Time - d,ODataBase.redHours[rh_Stats]);
      Canvas.Rectangle(0,i*16,Width,i*16+16);
      Canvas.TextOut(4,i*16+1,DateTimeToStr(d));
    end;
  end;
end;

procedure TFRM_Stats_Einlesen.FormCreate(Sender: TObject);
begin
  if SaveCaptions then SaveAllCaptions(Self,LangFile);
  if LoadCaptions then LoadAllCaptions(Self,LangFile);
 
  DoubleBuffered := True;
end;

procedure TFRM_Stats_Einlesen.FormShow(Sender: TObject);
begin
  refreshStats;
  refreshOwnPoints;
  Timer1.Enabled := true;
end;

procedure TFRM_Stats_Einlesen.FormHide(Sender: TObject);
begin
  Timer1.Enabled := false;
end;

procedure TFRM_Stats_Einlesen.Timer1Timer(Sender: TObject);
begin
  refreshStats;
end;

procedure TFRM_Stats_Einlesen.refreshStats;
var pt: TStatPointType;
    i: integer;
begin
  if TabControl1.TabIndex = 0 then
    nt := sntPlayer
  else
    nt := sntAlliance;

  place_hundred_count := 0;
  for pt := low(pt) to high(pt) do
  begin
    i := ODataBase.Statistic.StatisticType[nt, pt].Count;
    if (i > place_hundred_count) then
      place_hundred_count := i;
  end;

  pb_place_range.Height := place_hundred_count*16;
  pb_points.Height := pb_place_range.Height;
  pb_fleet.Height := pb_place_range.Height;
  pb_research.Height := pb_place_range.Height;

  pb_points.Refresh;
  pb_fleet.Refresh;
  pb_research.Refresh;
end;

procedure TFRM_Stats_Einlesen.TabControl1Change(Sender: TObject);
begin
  refreshStats;
end;

procedure TFRM_Stats_Einlesen.FormResize(Sender: TObject);
begin
  ClientWidth := 519;
end;

procedure TFRM_Stats_Einlesen.Button1Click(Sender: TObject);
begin
  ODataBase.Stats_own := ReadInt(TXT_punkte.Text, 1);
end;

procedure TFRM_Stats_Einlesen.refreshOwnPoints;
begin
  TXT_punkte.Text := IntToStrKP(ODataBase.Stats_own);
end;

procedure TFRM_Stats_Einlesen.FormMouseWheel(Sender: TObject;
  Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
  var Handled: Boolean);
begin
  ScrollBox1.VertScrollBar.Position :=
    ScrollBox1.VertScrollBar.Position - (WheelDelta div 2);
  handled := true;
end;

procedure TFRM_Stats_Einlesen.Button2Click(Sender: TObject);
begin
  Close;
end;

end.
