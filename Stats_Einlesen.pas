unit Stats_Einlesen;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, OGame_Types, Prog_Unit, Clipbrd, Languages,
  clipbrdfunctions, Stat_Points;

type
  TFRM_Stats_Einlesen = class(TForm)                                             
    PaintBox1: TPaintBox;
    PaintBox2: TPaintBox;
    PaintBox3: TPaintBox;
    PaintBox4: TPaintBox;
    Timer1: TTimer;
    Label5: TLabel;
    Label4: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    TXT_punkte: TEdit;
    TXT_Ally: TEdit;
    TXT_fleet: TEdit;
    Button1: TButton;
    procedure PaintBox3Paint(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

implementation

uses main;

{$R *.DFM}

procedure TFRM_Stats_Einlesen.PaintBox3Paint(Sender: TObject);
var i: integer;
begin
  with TPaintBox(Sender) do
  begin
    Canvas.Pen.Style := psClear;
    Canvas.Rectangle(Canvas.ClipRect);
    i := 0;
    while (i-1)*16 + 1 < PaintBox3.Height do
    begin
      Canvas.TextOut(5,(i-1)*16+1,IntToStr(((i-1)*100)+1));
      inc(i);
    end;
  end;
end;

procedure TFRM_Stats_Einlesen.PaintBox1Paint(Sender: TObject);
var i: integer;
    D: TDateTime;
    St: TStatPoints;
begin
  case TComponent(Sender).Tag of
    0: St := ODataBase.Stats;
    1: St := ODataBase.FleetStats;
    2: St := ODataBase.AllyStats;
  else
    Exit;
  end;
  with TPaintBox(Sender) do
  begin
    Canvas.Pen.Style := psClear;
    i := 0;
    d := St.Datum[i*100+1];
    while d <> -1 do
    begin
      Canvas.Brush.Color := AlterToColor_dt(
         ODataBase.FleetBoard.GameTime.Time - D,ODataBase.redHours[rh_Stats]);
      Canvas.Rectangle(0,i*16,Width,i*16+16);
      Canvas.TextOut(4,i*16+1,DateTimeToStr(D));

      inc(i);
      d := St.Datum[i*100+1];
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
  Timer1.Enabled := true;
end;

procedure TFRM_Stats_Einlesen.FormHide(Sender: TObject);
begin
  Timer1.Enabled := false;
end;

procedure TFRM_Stats_Einlesen.Timer1Timer(Sender: TObject);
begin
  PaintBox1.Refresh;
  PaintBox2.Refresh;
  PaintBox4.Refresh;
end;

end.
