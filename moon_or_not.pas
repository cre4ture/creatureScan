unit moon_or_not;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, VirtualTrees, OGame_Types, Prog_Unit, Bericht_Frame;

type
  PReportRec = ^TReportRec;
  TReportRec = record
    report: ^TScanBericht;
    addtime: TDateTime;
  end;
  Tfrm_report_basket = class(TForm)
    vst_reports: TVirtualStringTree;
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    Frame_Bericht1: TFrame_Bericht;
    procedure vst_reportsFocusChanged(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex);
    procedure vst_reportsGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure vst_reportsFreeNode(Sender: TBaseVirtualTree;
      Node: PVirtualNode);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure vst_reportsGetNodeDataSize(Sender: TBaseVirtualTree;
      var NodeDataSize: Integer);
    procedure FormCreate(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    procedure addReport(scan: TScanBericht);
    procedure solveSelectedProblemReport(moon: boolean);
    { Public-Deklarationen }
  end;

var
  frm_report_basket: Tfrm_report_basket;

implementation

uses Main;

{$R *.dfm}

procedure Tfrm_report_basket.addReport(scan: TScanBericht);
begin
  with TReportRec(vst_reports.GetNodeData(vst_reports.AddChild(nil))^) do
  begin
    New(report);
    report^ := scan;
    addtime := now;
  end;
  Show;   
  BringToFront;
end;

procedure Tfrm_report_basket.solveSelectedProblemReport(moon: boolean);
var sel: PVirtualNode;
    clear: TScanBericht;
begin
  sel := vst_reports.GetFirstSelected();
  if sel <> nil then
  begin
    with TReportRec(vst_reports.GetNodeData(sel)^) do
    begin
      report^.Head.Position.Mond := moon;
      ODataBase.UniTree.AddNewReport(report^);
    end;
    vst_reports.DeleteNode(sel);
    clear := Frame_Bericht1.Bericht;
    clear.Head.Position.P[0] := 0;
    Frame_Bericht1.SetBericht(clear);
  end;
end;

procedure Tfrm_report_basket.vst_reportsFocusChanged(
  Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
var snode: PVirtualNode;
begin
  snode := vst_reports.GetFirstSelected();
  Button1.Enabled := snode <> nil;
  Button2.Enabled := Button1.Enabled;
  if snode <> nil then
  begin
    with TReportRec(vst_reports.GetNodeData(node)^) do
    begin
      Frame_Bericht1.SetBericht(report^);
      frm_main.ShowScan(report^.Head.Position);
    end;
  end;
end;

procedure Tfrm_report_basket.vst_reportsGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var data: PReportRec;
begin
  data := vst_reports.GetNodeData(Node);
  case Column of
  0: CellText := PositionToStr_(data.report.Head.Position);
  1: CellText := DateTimeToStr(data.addtime);
 end;
end;

procedure Tfrm_report_basket.vst_reportsFreeNode(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var data: PReportRec;
begin
  data := vst_reports.GetNodeData(Node);
  Dispose(data.report);
end;

procedure Tfrm_report_basket.Button1Click(Sender: TObject);
begin
  solveSelectedProblemReport(true);
end;

procedure Tfrm_report_basket.Button2Click(Sender: TObject);
begin
  solveSelectedProblemReport(false);
end;

procedure Tfrm_report_basket.vst_reportsGetNodeDataSize(
  Sender: TBaseVirtualTree; var NodeDataSize: Integer);
begin
  NodeDataSize := SizeOf(TReportRec);
end;

procedure Tfrm_report_basket.FormCreate(Sender: TObject);
begin
  vst_reportsFocusChanged(vst_reports, nil, 0);
end;

end.
