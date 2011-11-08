unit Scan;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Bericht_Frame, DLL_plugin_TEST, OGame_Types,
  VirtualTrees, Spin, cS_DB_reportFile, cS_XML, LibXmlParser, FileUtils_UH,
  DateUtils;

type
  TScanTest = class(TReadReport)
  public
    filename: string;
    QuellText: String;
    last_check: string;
    function LoadTestScan(filename: string): Boolean;
    procedure SaveTestScan(filename: string);
  end;
  
  TFRM_Scan = class(TForm)
    Frame_Bericht1: TFrame_Bericht;
    btn_read: TButton;
    ListBox1: TListBox;
    VST_tests: TVirtualStringTree;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    SpinEdit1: TSpinEdit;
    OpenDialog1: TOpenDialog;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Frame_Bericht2: TFrame_Bericht;
    Label1: TLabel;
    lbl_scancount: TLabel;
    procedure btn_readClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure SpinEdit1Change(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure VST_testsFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure VST_testsGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure VST_testsDblClick(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    Scans: TReadReportList;
    function GetNewScanFilename(Scan: TScanBericht): string;
    function CheckTestScan(st: TScanTest): Boolean;
  public
    testScanDir: string;
    db: TcSReportDBFile;
    procedure LoadTestDir(dir: string);
    function ReadScans(): Integer;
    function TestVSTNode(node: PVirtualNode): Boolean;
    { Public-Deklarationen }
  end;

var
  FRM_Scan: TFRM_Scan;

function RemoveYear_u(time_u: int64): int64;

implementation

uses Sources, Math;

{$R *.dfm}

function TFRM_Scan.ReadScans(): Integer;
var s: string;
    i: integer;
    Scan: TReadReport;
begin
  s := FRM_Sources.M_Text.Text;
  i := 0;
  ListBox1.Clear;
  Scans.clear;
  Result := plugin.ReadReports(FRM_Sources.plugin_handle);

  scan := TReadReport.Create;
  try

    while plugin.GetReport(FRM_Sources.plugin_handle, Scan, Scan.askMoon) do
    begin
      Scans.push_back(Scan); // copy
      ListBox1.Items.Add(IntToStr(i));
      inc(i);
    end;
    Frame_Bericht1.Refresh;
    if Result <> i then
      raise Exception.Create('Fehler im Plugin: Anzahl Scans stimmt mit Rückgabewert nicht überein!');

  finally
    Scan.Free;
  end;
end;

procedure TFRM_Scan.btn_readClick(Sender: TObject);
begin
  lbl_scancount.Caption := IntToStr(ReadScans());
end;

procedure TFRM_Scan.FormCreate(Sender: TObject);
begin
  Scans := TReadReportList.Create;

  Frame_Bericht1.DontShowRaids := True;
  Frame_Bericht1.plugin := plugin;
  Frame_Bericht2.DontShowRaids := True;
  Frame_Bericht2.plugin := plugin;

  VST_tests.NodeDataSize := sizeof(pointer);
  testScanDir := ExtractFilePath(Application.Exename);
end;

procedure TFRM_Scan.ListBox1Click(Sender: TObject);
begin
  Frame_Bericht1.SetBericht(Scans[ListBox1.ItemIndex]);
  Frame_Bericht1.Refresh;
end;

procedure TFRM_Scan.LoadTestDir(dir: string);
var filelist: TStringList;
    i: integer;
    st: TScanTest;
begin
  VST_tests.Clear;

  filelist := TStringList.Create;
  GetDirFileList(dir,filelist,'*.txt');
  for i := 0 to filelist.Count - 1 do
  begin
    st := TScanTest.Create;
    if st.LoadTestScan(dir + filelist[i]) then
    begin
      VST_tests.AddChild(nil,st);
    end
    else
      st.Free;
  end;
end;

function TFRM_Scan.GetNewScanFilename(Scan: TScanBericht): string;
var i: integer;
begin
  Result := testScanDir + IntToStr(Scan.Head.Position.P[0]) + '_'
                        + IntToStr(Scan.Head.Position.P[1]) + '_'
                        + IntToStr(Scan.Head.Position.P[2]) + '_';
  if Scan.Head.Position.Mond then
    Result := Result + 'M_';

  i := 0;
  while FileExists(Result + IntToStr(i) + '.txt') do
    inc(i);

  Result := Result + IntToStr(i) + '.txt';
end;

procedure TFRM_Scan.Button2Click(Sender: TObject);
var st: TScanTest;
begin
  if Scans.Count = 1 then
  begin
    st := TScanTest.Create;
    st.copyFrom(Scans[0]);
    st.AskMoon := Scans[0].AskMoon;
    st.QuellText := FRM_Sources.M_Text.Text;
    st.SaveTestScan(GetNewScanFilename(st));
    VST_tests.AddChild(nil,st);
  end
  else
    ShowMessage('Genau ein Scan einlesen!!!!');
end;

procedure TFRM_Scan.Button3Click(Sender: TObject);
var node: PVirtualNode;
begin
  node := VST_tests.GetFirstSelected;
  while node <> nil do
  with TScanTest(VST_tests.GetNodeData(node)^) do
  begin
    if FileExists(filename) then
      DeleteFile(filename);

    node := VST_tests.GetNextSelected(node);
  end;
  VST_tests.DeleteSelectedNodes;
end;

procedure TFRM_Scan.Button4Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    db := TcSReportDBFile.Create(OpenDialog1.FileName);
  end;
end;

procedure TFRM_Scan.SpinEdit1Change(Sender: TObject);
begin
  Frame_Bericht1.SetBericht(db.Reports[SpinEdit1.Value]);
  Frame_Bericht1.Refresh;
end;

function TFRM_Scan.TestVSTNode(node: PVirtualNode): Boolean;
var st: TScanTest;
begin
  st := TScanTest(VST_tests.GetNodeData(node)^);
  Frame_Bericht2.setBericht(st);

  Result := CheckTestScan(st);
  if scans.Count > 0 then
    Frame_Bericht1.setBericht(Scans[0]);
  if not Result then
  begin
    Beep;
    ShowMessage(st.last_check);
  end;
end;

function TFRM_Scan.CheckTestScan(st: TScanTest): Boolean;
begin
  FRM_Sources.m_Text.Text := st.QuellText;
  FRM_Sources.m_Html.Text := '';
  if ReadScans() = 1 then
  begin
    //Da in keinem Scan das Jahr vorhanden ist, wird dieses beim einlesen gesetzt!
    //Weil dieser Test aber auch später in einem anderen Jahr auf die gleichen
    //Daten angewandt wird, wird diese Information gelöscht!

    st.Head.Time_u := RemoveYear_u(st.Head.Time_u);
    Scans[0].Head.Time_u := RemoveYear_u(Scans[0].Head.Time_u);

    st.last_check := CompareScans(st, Scans[0]);
  end
  else
    st.last_check := 'kein Scan eingelesen (oder zuviele)';

  Result := st.last_check = '';
  if Result then
    st.last_check := 'OK';
end;

procedure TFRM_Scan.VST_testsDblClick(Sender: TObject);
begin
  if VST_tests.FocusedNode <> nil then
  begin
    TestVSTNode(VST_tests.FocusedNode);
  end;
end;

procedure TFRM_Scan.VST_testsFreeNode(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
begin
  TScanTest(VST_tests.GetNodeData(Node)^).Free;
end;

procedure TFRM_Scan.VST_testsGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
begin
  case Column of
    0: CellText := PositionToStrMond(
              TScanTest(Sender.GetNodeData(node)^).Head.Position);
    1: CellText := TScanTest(Sender.GetNodeData(node)^).last_check;
  end;
end;

procedure TFRM_Scan.Button5Click(Sender: TObject);
var i: integer;
begin
  for i := 0 to db.Count-1 do
  begin
    Frame_Bericht1.setBericht(db.Reports[i]);
  end;
end;

procedure TFRM_Scan.Button6Click(Sender: TObject);
var node: PVirtualNode;
    allok: Boolean;
begin
  allok := true;
  node := VST_tests.GetFirst;
  while node <> nil do
  begin
    if not TestVSTNode(node) then
      allok := False;
    node := VST_tests.GetNext(node);
  end;
  if allok then
    ShowMessage('alle Tests OK!');
  VST_tests.Refresh;
end;

procedure TFRM_Scan.Button7Click(Sender: TObject);
var s: string;
begin
  s := testScanDir;
  if InputQuery('Dir','Dir',s) then
  begin
    if not (s[length(s)] in ['\','/']) then
      s := s + '/';
      
    testScanDir := s;
    LoadTestDir(s);
  end;
end;

function TScanTest.LoadTestScan(filename: string): boolean;
var parser: TXmlParser;
    sl: TStringList;
    s: string;
begin
  Result := False;
  parser := TXmlParser.Create;
  sl := TStringList.Create;
  try
    sl.LoadFromFile(filename);
    s := sl[0];
    sl.Delete(0);

    parser.LoadFromBuffer(PChar(s));
    parser.StartScan;
    if parser.Scan then
    begin
      Result := parse_report(parser, Self);
      if Result then
      begin
        self.filename := filename;
        Self.QuellText := sl.Text;
      end;
    end;
  finally
    parser.free;
    sl.Free;
  end;
end;

procedure TScanTest.SaveTestScan(filename: string);
var sf: TStringList;
    s: string;
begin
  sf := TStringList.Create;
  try
    s := ScanToXML_(Self, '9.99');
    sf.Add(s);
    sf.Add(Self.QuellText);
    sf.SaveToFile(filename);
    self.filename := filename;
  finally
    sf.Free;
  end;
end;

function RemoveYear_u(time_u: int64): int64;
var Y,M,D,h,min,sec,ms: word;
    dt: TDateTime;
begin
  dt := UnixToDateTime(time_u);
  DecodeDateTime(dt,Y,M,D,h,min,sec,ms);
  Result := DateTimeToUnix(EncodeDateTime(1970,M,D,h,min,sec,ms));
end;

procedure TFRM_Scan.FormDestroy(Sender: TObject);
begin
  Scans.Free;
end;

end.
