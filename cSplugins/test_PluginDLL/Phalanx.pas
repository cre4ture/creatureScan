unit Phalanx;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, VirtualTrees, DateUtils, OGame_Types,
  Bericht_Frame;

type
  TFRM_Phalanx = class(TForm)
    Button1: TButton;
    Shape1: TShape;
    vst_fleets: TVirtualStringTree;
    Frame_Bericht1: TFrame_Bericht;
    procedure Button1Click(Sender: TObject);
    procedure vst_fleetsGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure vst_fleetsFocusChanged(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex);
    procedure FormCreate(Sender: TObject);
  private
    fleets: array of TFleetEvent;
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  FRM_Phalanx: TFRM_Phalanx;

implementation

uses DLL_plugin_TEST, Sources;

{$R *.dfm}

procedure TFRM_Phalanx.Button1Click(Sender: TObject);
var count, i: integer;
    afleet: TFleetEvent;
begin
  count := plugin.ReadPhalanxScan();
  if count > 0 then
    Shape1.Brush.Color := clGreen
  else
    Shape1.Brush.Color := clRed;

  SetLength(fleets, 0);
  while plugin.ReadPhalanxScanGet(afleet) do
  begin
    i := length(fleets);
    SetLength(fleets,i+1);
    fleets[i] := afleet;
  end;

  vst_fleets.RootNodeCount := length(fleets);
  vst_fleets.Refresh;
end;

procedure TFRM_Phalanx.vst_fleetsGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var index: cardinal;
begin
  index := Node.Index;
  case Column of
    0: CellText := DateTimeToStr(UnixToDateTime(fleets[index].head.arrival_time_u));
    1: CellText := PositionToStrMond(fleets[index].head.origin);
    2: CellText := PositionToStrMond(fleets[index].head.target);
    3: begin
         CellText := FleetEventTypeToStr(fleets[index].head.eventtype);
         if fef_return in fleets[index].head.eventflags then
           CellText := CellText + ' return';
         if fef_friendly in fleets[index].head.eventflags then
           CellText := CellText + ' friendly';
         if fef_neutral in fleets[index].head.eventflags then
           CellText := CellText + ' neutral';
         if fef_hostile in fleets[index].head.eventflags then
           CellText := CellText + ' hostile';
       end;
    4: CellText := fleets[index].head.player;
    5: CellText := IntToStr(fleets[index].head.unique_id);
  end;
end;

procedure TFRM_Phalanx.vst_fleetsFocusChanged(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex);
var scan: TScanBericht;
    sg: TScanGroup;
    i: integer;
begin
  if (Node = nil) or (Node.Index >= length(fleets)) then Exit;

  with fleets[Node.Index] do
  begin
    FillChar(scan.Head,sizeof(scan.Head),0);
    for sg := low(sg) to high(sg) do
    begin
      SetLength(scan.Bericht[sg], ScanFileCounts[sg]);
      scan.Bericht[sg][0] := -1;
    end;

    scan.Bericht[sg_Rohstoffe][0] := ress[0];
    scan.Bericht[sg_Rohstoffe][1] := ress[1];
    scan.Bericht[sg_Rohstoffe][2] := ress[2];
    scan.Bericht[sg_Rohstoffe][3] := 0;

    for i := 0 to ScanFileCounts[sg_Flotten]-1 do
      scan.Bericht[sg_Flotten][i] := ships[i];
    scan.Head.Position := head.target;
    scan.Head.Spieler := head.player;

  end;
  Frame_Bericht1.Bericht := scan;
end;

procedure TFRM_Phalanx.FormCreate(Sender: TObject);
begin
  Frame_Bericht1.DontShowRaids := True;
  Frame_Bericht1.plugin := plugin;
  Frame_Bericht1.ShowProduction := False;
  Frame_Bericht1.calc_resources := False;
end;

end.