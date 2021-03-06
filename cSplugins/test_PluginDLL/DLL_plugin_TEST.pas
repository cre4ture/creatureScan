unit DLL_plugin_TEST;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Prog_Unit, Spin, OGame_Types, clipbrdfunctions,
  TIReadPlugin, Inifiles, cS_DB_reportFile;

type
  TFRM_MainTest = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    OpenDialog1: TOpenDialog;
    Label3: TLabel;
    Edit1: TEdit;
    GroupBox1: TGroupBox;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    GroupBox2: TGroupBox;
    Button8: TButton;
    Button9: TButton;
    txt_serverURL: TEdit;
    Button10: TButton;
    Button11: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    lastplugin: string;
    procedure ejectPlugin;
    function loadPlugin(filename: string): boolean;
    procedure LoadOptions(ini: TInifile);
    { Public-Deklarationen }
  end;

var
  FRM_MainTest: TFRM_MainTest;
  plugin: TLangPlugIn;

implementation

uses Sources, SolSys, Scan, Stats, Reports, Phalanx, chelper_server;

{$R *.dfm}

procedure TFRM_MainTest.Button1Click(Sender: TObject);
begin
  if plugin.ValidFile then
  begin
    ejectPlugin();
  end
  else
  begin
    OpenDialog1.InitialDir := lastplugin;
    if FileExists(lastplugin) then
      OpenDialog1.FileName := lastplugin;
    if OpenDialog1.Execute then
    begin
      loadPlugin(OpenDialog1.FileName);
    end;
  end;
end;

procedure TFRM_MainTest.FormCreate(Sender: TObject);
begin
  max_Galaxy := 20;
  plugin := TLangPlugIn.Create;

  Initialise('D:\devel\creatureScan\creatureScan\data\ogame_consts.xml');
end;

procedure TFRM_MainTest.FormDestroy(Sender: TObject);
begin
  plugin.Free;
end;

procedure TFRM_MainTest.Button2Click(Sender: TObject);
begin
  FRM_Sources.Show;
end;

procedure TFRM_MainTest.Button3Click(Sender: TObject);
begin
  FRM_Solsys.show;
end;

procedure TFRM_MainTest.Button4Click(Sender: TObject);
begin
  FRM_Scan.Show;
end;

procedure TFRM_MainTest.Button5Click(Sender: TObject);
begin
  plugin.RunOptions;
end;

procedure TFRM_MainTest.Button6Click(Sender: TObject);
begin
  FRM_Stats.Show;
end;

procedure TFRM_MainTest.Button7Click(Sender: TObject);
var s: string;
begin
  if plugin.CheckClipboardUni(FRM_Sources.plugin_handle) then
  begin
    s := 'Uni identified!' + #10 + #13 +
         'isCommander: ' + BoolToStr(plugin.has_commander, true);
    ShowMessage(s);
  end
  else ShowMessage('Uni not identified!');
end;

procedure TFRM_MainTest.Button8Click(Sender: TObject);
begin
  FRM_ScanGen.Show;
end;

procedure TFRM_MainTest.LoadOptions(ini: TInifile);
begin
  lastplugin := ini.ReadString('dir','stdplugindir',GetCurrentDir);
end;

function TFRM_MainTest.loadPlugin(filename: string): boolean;
begin
  if plugin.ValidFile then
  begin
    plugin.LoadPluginFile('','','');
    Button1.Caption := 'load plugin';
    Label1.Caption := 'n/a';

    FRM_Solsys.OnPluginEjected;
  end
  else
  begin
    Result := plugin.LoadPluginFile(fileName, txt_serverURL.Text, Edit1.Text);
    if Result then
    begin
      lastplugin := fileName;
      Label1.Caption := fileName;
      Button1.Caption := 'eject plugin';

      FRM_Solsys.OnPluginInitialised;
    end
    else Label1.Caption := 'n/a';
  end;

  txt_serverURL.Enabled := not plugin.ValidFile;
  Edit1.Enabled := not plugin.ValidFile;

  FRM_Sources.OnPluginRefresh();

  Result := true;
end;

procedure TFRM_MainTest.FormActivate(Sender: TObject);
var ini: TIniFile;
begin
  ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'test.ini');
  LoadOptions(ini);
  FRM_Sources.LoadOptions(ini);
  ini.Free;

  // Load plugin in parameters
  if (ParamCount > 1) and (ParamStr(1) = '-plugin') then
  begin
    loadPlugin(ParamStr(2));
    OpenDialog1.HistoryList.Add(ParamStr(2));
  end;
end;

procedure TFRM_MainTest.Button9Click(Sender: TObject);
begin
  FRM_Phalanx.Show;
end;

procedure TFRM_MainTest.ejectPlugin;
begin
  loadPlugin('n/a');
end;

procedure TFRM_MainTest.Button10Click(Sender: TObject);
var testDB: TcSReportDBFile;
    report: TScanBericht;
    i, j, nr: integer;
    dbfilename: string;
begin
  dbfilename := 'TESTDB.ScanDB';
  for j := 0 to 0 do
  begin
    if FileExists(dbfilename) then
      DeleteFile(dbfilename);
    testDB := TcSReportDBFile.Create(dbfilename);
    report := TScanBericht.Create;
    try
      for i := 0 to 2000 do
      begin
        GenRandomScan(report);

        nr := testDB.Count;
        testDB.Count := nr+1;
        testDB.SetReport(nr, report);
      end;
    finally
      testDB.Free;
      report.Free;
    end;
    testDB := TcSReportDBFile.Create(dbfilename);
    report := TScanBericht.Create;
    try
      for i := 0 to 2000 do
      begin
        report.copyFrom(testDB.GetReport(i));
      end;
    finally
      testDB.Free;
      report.Free;
    end;
  end;
end;

procedure TFRM_MainTest.Button11Click(Sender: TObject);
begin
  frm_cshelper_ctrl.Show;
end;

end.
