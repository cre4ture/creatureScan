unit moon_or_not;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, VirtualTrees, OGame_Types, Prog_Unit, Bericht_Frame,
  Menus;

type
  PReportRec = ^TReportRec;
  TReportRec = record
    report: TScanBericht;
    addtime: TDateTime;
  end;
  Tfrm_report_basket = class(TForm)
    vst_reports: TVirtualStringTree;
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    Frame_Bericht1: TFrame_Bericht;
    PopupMenu1: TPopupMenu;
    diesisteinMond1: TMenuItem;
    diesisteinPlanetscan1: TMenuItem;
    Lschen1: TMenuItem;
    N1: TMenuItem;
    cb_only_planets: TCheckBox;
    allemarkieren1: TMenuItem;
    procedure vst_reportsFocusChanged(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex);
    procedure vst_reportsGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: String);
    procedure vst_reportsFreeNode(Sender: TBaseVirtualTree;
      Node: PVirtualNode);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure vst_reportsGetNodeDataSize(Sender: TBaseVirtualTree;
      var NodeDataSize: Integer);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure diesisteinMond1Click(Sender: TObject);
    procedure diesisteinPlanetscan1Click(Sender: TObject);
    procedure Lschen1Click(Sender: TObject);
    procedure cb_only_planetsClick(Sender: TObject);
    procedure allemarkieren1Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    procedure addReport(scan: TScanBericht);
    procedure solveSelectedProblemReport(moon: boolean; delete: boolean = false);
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
    report := TScanBericht.Create;
    report.copyFrom(scan);
    addtime := now;
  end;
  Show;   
  BringToFront;
end;

procedure Tfrm_report_basket.solveSelectedProblemReport(moon: boolean;
  delete: boolean = false);
var sel: PVirtualNode;
    clear: TScanBericht;
begin
  sel := vst_reports.GetFirstSelected();
  while (sel <> nil) do
  begin
    if not delete then
      with TReportRec(vst_reports.GetNodeData(sel)^) do
      begin
        report.Head.Position.Mond := moon;
        ODataBase.UniTree.AddNewReport(report);
      end;
    sel := vst_reports.GetNextSelected(sel);
  end;
  // at the end, delete all selected nodes:
  vst_reports.DeleteSelectedNodes;

  vst_reports.FocusedNode := vst_reports.GetFirst();
  if vst_reports.FocusedNode <> nil then
  begin
    vst_reports.Selected[vst_reports.FocusedNode] := true;
  end
  else
  begin  // nothing left in list
    clear := Frame_Bericht1.Bericht;
    clear.Head.Position.P[0] := 0;
    Frame_Bericht1.SetBericht(clear);
  end;
end;

procedure Tfrm_report_basket.vst_reportsFocusChanged(
  Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
begin
  Button1.Enabled := node <> nil;
  Button2.Enabled := Button1.Enabled;
  if node <> nil then
  begin
    with TReportRec(vst_reports.GetNodeData(node)^) do
    begin
      Frame_Bericht1.SetBericht(report);
      frm_main.ShowScan(report.Head.Position);
    end;
  end;
end;

procedure Tfrm_report_basket.vst_reportsGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: String);
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
  data.report.Free;
end;

procedure Tfrm_report_basket.Button1Click(Sender: TObject);
begin
  solveSelectedProblemReport(true);
  vst_reports.SetFocus;
end;

procedure Tfrm_report_basket.Button2Click(Sender: TObject);
begin
  solveSelectedProblemReport(false);
  vst_reports.SetFocus;
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

procedure Tfrm_report_basket.FormShow(Sender: TObject);
begin
  cb_only_planets.Checked := FRM_Main.PlayerOptions.noMoonQuestion;
  vst_reports.SetFocus;
end;

procedure Tfrm_report_basket.diesisteinMond1Click(Sender: TObject);
begin
  solveSelectedProblemReport(true);
end;

procedure Tfrm_report_basket.diesisteinPlanetscan1Click(Sender: TObject);
begin
  solveSelectedProblemReport(false);
end;

procedure Tfrm_report_basket.Lschen1Click(Sender: TObject);
begin
  solveSelectedProblemReport(false (* dont't care *), true);
end;

procedure Tfrm_report_basket.cb_only_planetsClick(Sender: TObject);
begin
  FRM_Main.PlayerOptions.noMoonQuestion := cb_only_planets.Checked;
end;

procedure Tfrm_report_basket.allemarkieren1Click(Sender: TObject);
begin
  vst_reports.SelectAll(false);
  vst_reports.FocusedNode := vst_reports.GetFirstSelected(); // Force focus changed event
end;

end.

