unit Reports;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Spin, OGame_Types, DLL_plugin_TEST,
  clipbrd;

type
  TFRM_ScanGen = class(TForm)
    SpinEdit1: TSpinEdit;
    Label1: TLabel;
    CheckBox1: TCheckBox;
    Timer1: TTimer;
    SpinEdit2: TSpinEdit;
    Label2: TLabel;
    Button1: TButton;
    procedure SpinEdit1Change(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  FRM_ScanGen: TFRM_ScanGen;

procedure GenRandomScan(var Scan: TScanBericht);

implementation

uses DateUtils, Math;

{$R *.dfm}

procedure TFRM_ScanGen.SpinEdit1Change(Sender: TObject);
begin
  if SpinEdit1.Text <> '' then
  begin
    Timer1.Interval := SpinEdit1.Value;
  end;
end;

procedure GenRandomScan(var Scan: TScanBericht);
var i: integer;
    sg: TScanGroup;
    p: TPlanetPosition;
begin
  Scan.Head.Planet := IntToStr(random(10000));
  if Random(4) = 0 then
    Scan.Head.Planet := Scan.Head.Planet + ' (Mond)';

  Scan.Head.Time_u := DateTimeToUnix(Now) - Random(3600);
  Scan.Head.Spieler := IntToStr(random(10000));
  Scan.Head.Spionageabwehr := Random(101);
  {Scan.Head.Creator := '';
  Scan.Head.von := ''; 14.04.2008: abgeschafft, neu: Activity}
  case random(10) of
  0..4: Scan.Head.Activity := random(60)*60; //(sekunden der letzten aktivität)
  5..8: Scan.Head.Activity := 0; // l.a. > 1h
  else {9} Scan.Head.Activity := -1; // l.a. nicht vorhanden!
  end;

  p.P[0] := 1;
  p.P[1] := 100;
  p.P[2] := max_Planeten;
  p.Mond := True;
  Scan.Head.Position :=
    AbsPlanetNrToPlanetPosition(Random(PlanetPositionToAbsPlanetNr(p)));

  for sg := low(sg) to high(sg) do
    SetLength(Scan.Bericht[sg], ScanFileCounts[sg]);

  sg := sg_Rohstoffe;
  for i := 0 to ScanFileCounts[sg]-1 do
    Scan.Bericht[sg][i] := Random({high(Integer)} 100000000);
  sg := sg_Flotten;
  for i := 0 to ScanFileCounts[sg]-1 do
    Scan.Bericht[sg][i] := Random({high(Integer)} 1000000);
  sg := sg_Verteidigung;
  for i := 0 to ScanFileCounts[sg]-1 do
    Scan.Bericht[sg][i] := Random({high(Integer)} 1000000);
  sg := sg_Gebaeude;
  for i := 0 to ScanFileCounts[sg]-1 do
    Scan.Bericht[sg][i] := Random({high(ShortInt)} 40);
  sg := sg_Forschung;
  for i := 0 to ScanFileCounts[sg]-1 do
    Scan.Bericht[sg][i] := Random({high(ShortInt)} 40);
end;

procedure TFRM_ScanGen.Timer1Timer(Sender: TObject);
var Scan: TScanBericht;
    s: string;
    i: Integer;
begin
  s := '';
  for i := 0 to SpinEdit2.Value-1 do
  begin
    GenRandomScan(Scan);
    s := s + 'Scan #' + IntToStr(i) + ':' + plugin.ScanToStr(scan, false);
  end;
  try
    Clipboard.AsText := s;
  except

  end;
end;

procedure TFRM_ScanGen.CheckBox1Click(Sender: TObject);
begin
  Timer1.Enabled := CheckBox1.Checked;
end;

procedure TFRM_ScanGen.Button1Click(Sender: TObject);
begin
  Timer1Timer(Self);
end;

end.
