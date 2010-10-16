unit SolSys;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Spin, Stat_Points, Ogame_Types, Galaxy_Explorer,
  VirtualTrees, ExtCtrls, DateUtils, ImgList, cS_DB_solsysFile;

type
  TFRM_Solsys = class(TForm)
    VST_Gala: TVirtualStringTree;
    Button1: TButton;
    Shape1: TShape;
    VST_Tests: TVirtualStringTree;
    Button2: TButton;
    Button3: TButton;
    ImageList1: TImageList;
    procedure VST_GalaGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure VST_TestsGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure VST_TestsFocusChanged(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex);
    procedure VST_TestsGetNodeDataSize(Sender: TBaseVirtualTree;
      var NodeDataSize: Integer);
    procedure VST_TestsGetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: Integer);
  private
    function TestFileName(nr: Integer): String;
    { Private-Deklarationen }
  public
    TestSys: TSystemCopy;
    SysTestFile: TcSSolSysDB_for_file;
    procedure AddSysTest;
    procedure OnPluginInitialised;
    function DoTestSys(nr: Integer): Boolean;
    procedure OnPluginEjected;
    { Public-Deklarationen }
  end;

var
  FRM_Solsys: TFRM_Solsys;

implementation

uses DLL_plugin_TEST, Sources, Math;

{$R *.dfm}

procedure TFRM_Solsys.VST_GalaGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
begin
  CellText := '';
  with TestSys.Planeten[node^.Index+1] do
  case Column of
    0: CellText := inttostr(node^.Index+1);
    1: CellText := IntToStr(MondSize);
    2: CellText := IntToStr(MondTemp);
    3: CellText := PlanetName;
    4: CellText := Player;
    5: CellText := plugin.StatusToStr(Status);
    6: CellText := Ally;
    7: CellText := IntToStr(TF[0]);
    8: CellText := IntToStr(TF[1]);
  end;
end;

procedure TFRM_Solsys.Button1Click(Sender: TObject);
begin
  FillChar(TestSys,SizeOf(TestSys),0);
  if plugin.ReadSystem(FRM_Sources.plugin_handle, TestSys) then
    Shape1.Brush.Color := cllime
  else Shape1.Brush.Color := clRed;
  Caption := PositionToStrMond(TestSys.System);
  VST_Gala.Refresh;
end;

procedure TFRM_Solsys.FormCreate(Sender: TObject);
begin
  VST_Gala.RootNodeCount := 15;
end;

procedure TFRM_Solsys.Button2Click(Sender: TObject);
begin
  AddSysTest;
end;

procedure TFRM_Solsys.AddSysTest;
begin
  Button1Click(Button1);
  FRM_Sources.SaveToFile(TestFileName(SysTestFile.AddSolSys(TestSys)));
  VST_Tests.RootNodeCount := SysTestFile.SysCount;
end;

procedure TFRM_Solsys.VST_TestsGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
begin
  case Column of
  0: CellText := DateTimeToStr(UnixToDateTime(SysTestFile[node.Index].Time_u));
  end;
end;

procedure TFRM_Solsys.OnPluginInitialised;
var filename: string;
    mode: word;
begin
  filename := ExtractFilePath(Application.ExeName) +
    FRM_MainTest.txt_serverURL.Text + '\sys_tests.cssys';

  if not DirectoryExists(ExtractFilePath(filename)) then
    CreateDir(ExtractFilePath(filename));

  if FileExists(filename) then
   mode := fmOpenReadWrite
  else mode := fmCreate;
  SysTestFile := TcSSolSysDB_for_File.Create(filename,FRM_MainTest.txt_serverURL.Text);

  VST_Tests.RootNodeCount := SysTestFile.SysCount;
end;

function TFRM_Solsys.DoTestSys(nr: Integer): Boolean;
var s: string;
begin
  FRM_Sources.LoadFromFile(TestFileName(nr));
  Button1Click(Button1);
  s := CompareSys(TestSys,SysTestFile[nr],True);  //Ignoretime = true,
    //da die zeit nicht aus der seite geladen wird, sondern per now!
  Result := s = '';
  if not Result then ShowMessage(s);
end;

procedure TFRM_Solsys.VST_TestsFocusChanged(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex);
begin
  if vsSelected in Node.States then
  begin
    Integer(VST_Tests.GetNodeData(Node)^) := IfThen(DoTestSys(node.Index),1,2);
  end;
end;

procedure TFRM_Solsys.VST_TestsGetNodeDataSize(Sender: TBaseVirtualTree;
  var NodeDataSize: Integer);
begin
  NodeDataSize := Sizeof(Integer);
end;

procedure TFRM_Solsys.VST_TestsGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);
begin
  ImageIndex := Integer(Sender.GetNodeData(Node)^);
end;

function TFRM_Solsys.TestFileName(nr: Integer): String;
begin
  Result := ExtractFilePath(Application.ExeName) +
    ExtractFileName(plugin.PluginFilename) +
    '\sys_' + IntToStr(nr) + '.txt';
end;

procedure TFRM_Solsys.OnPluginEjected;
begin
  VST_Tests.Clear;
  VST_Tests.Refresh;
  SysTestFile.Free;
end;

end.
