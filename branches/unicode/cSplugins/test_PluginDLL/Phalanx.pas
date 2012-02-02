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
    ComboBox1: TComboBox;
    procedure Button1Click(Sender: TObject);
    procedure vst_fleetsGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: String);
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
var i: integer;
    afleet: TFleetEvent;
    info: TFleetsInfoSource;
begin
  info := plugin.ReadPhalanxScan(FRM_Sources.plugin_handle);
  if info.count > 0 then
    Shape1.Brush.Color := clGreen
  else
    Shape1.Brush.Color := clRed;

  ComboBox1.ItemIndex := byte(info.typ);

  SetLength(fleets, 0);
  i := 0;
  while plugin.ReadPhalanxScanGet(FRM_Sources.plugin_handle, i, afleet) do
  begin
    SetLength(fleets,i+1);
    fleets[i] := afleet;
    inc(i);
  end;

  vst_fleets.RootNodeCount := length(fleets);
  vst_fleets.Refresh;
end;

procedure TFRM_Phalanx.vst_fleetsGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: String);
var index: cardinal;
begin
  index := Node.Index;
  case Column of
    0: CellText := DateTimeToStr(UnixToDateTime(fleets[index].head.arrival_time_u));
    1: CellText := PositionToStrMond(fleets[index].head.origin);
    2: CellText := PositionToStrMond(fleets[index].head.target);
    3: begin
         CellText := FleetEventTypeToStrEx_(fleets[index]);
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
  Scan := TScanBericht.Create;
  try
    if (Node = nil) or (Node.Index >= Cardinal(length(fleets))) then Exit;

    with fleets[Node.Index] do
    begin
      FillChar(scan.Head,sizeof(scan.Head),0);
      for sg := low(sg) to high(sg) do
      begin
        scan.Bericht[sg,0] := -1;
      end;

      scan.Bericht[sg_Rohstoffe,0] := ress[0];
      scan.Bericht[sg_Rohstoffe,1] := ress[1];
      scan.Bericht[sg_Rohstoffe,2] := ress[2];
      scan.Bericht[sg_Rohstoffe,3] := 0;

      for i := 0 to ScanFileCounts[sg_Flotten]-1 do
        scan.Bericht[sg_Flotten,i] := ships[i];
      scan.Head.Position := head.target;
      scan.Head.Spieler := head.player;

    end;
    Frame_Bericht1.SetBericht(scan);
  finally
    scan.Free;
  end;
end;

procedure TFRM_Phalanx.FormCreate(Sender: TObject);
begin
  Frame_Bericht1.DontShowRaids := True;
  Frame_Bericht1.plugin := plugin;
  Frame_Bericht1.ShowProduction := False;
  Frame_Bericht1.calc_resources := False;
end;

end.
