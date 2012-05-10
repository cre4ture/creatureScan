program TEST;

uses
  Forms,
  DLL_plugin_TEST in 'DLL_plugin_TEST.pas' {FRM_MainTest},
  Sources in 'Sources.pas' {FRM_Sources},
  SolSys in 'SolSys.pas' {FRM_Solsys},
  Scan in 'Scan.pas' {FRM_Scan},
  Stats in 'Stats.pas' {FRM_Stats},
  Phalanx in 'Phalanx.pas' {FRM_Phalanx},
  Reports in 'Reports.pas' {FRM_ScanGen},
  Prog_Unit in '..\..\Prog_Unit.pas',
  RaidBoard in '..\..\RaidBoard.pas',
  OtherTime in '..\..\OtherTime.pas',
  cS_DB_fleetfile in '..\..\cS_DB_fleetfile.pas',
  cS_DB in '..\..\cS_DB.pas',
  OGame_Types in '..\..\OGame_Types.pas',
  CoordinatesRanges in '..\..\CoordinatesRanges.pas',
  Languages in '..\..\Languages.pas',
  SelectLanguage in '..\..\SelectLanguage.pas' {FRM_SelectLanguage},
  ThreadProtocolObject in '..\..\ThreadProtocolObject.pas',
  UniTree in '..\..\UniverseTree\UniTree.pas',
  TIReadPlugin in '..\..\ReadPlugins\TIReadPlugin.pas',
  Bericht_Frame in '..\..\Bericht_Frame.pas' {Frame_Bericht: TFrame},
  Notizen in '..\..\Notizen.pas' {FRM_Notizen},
  cS_DB_reportFile in '..\..\cS_DB_reportFile.pas',
  chelper_server in '..\..\chelper_server.pas' {frm_cshelper_ctrl},
  creax_html in '..\..\..\lib\uli\htmllib\creax_html.pas',
  cpp_dll_interface in '..\..\..\lib\uli\htmllib\cpp_dll_interface.pas',
  parser_types in '..\..\..\lib\uli\htmllib\parser_types.pas',
  TIReadPlugin_Types in '..\..\ReadPlugins\TIReadPlugin_Types.pas',
  TIReadPlugin_Types_conv_UNICODE in '..\..\ReadPlugins\TIReadPlugin_Types_conv_UNICODE.pas',
  zeit_sync in '..\..\..\Ogame_tools\zeit_sync\zeit_sync.pas',
  Connect in '..\..\Connect.pas' {FRM_Connect},
  UnitTestDB in 'UnitTestDB.pas',
  UnitTestFactory in 'UnitTestFactory.pas',
  CSUnitTest_ScanBerichtHTTP in 'CSUnitTest_ScanBerichtHTTP.pas',
  cS_XML in '..\..\cS_XML.pas',
  unit_test_explorer in 'unit_test_explorer.pas' {frm_unit_test};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFRM_MainTest, FRM_MainTest);
  Application.CreateForm(Tfrm_cshelper_ctrl, frm_cshelper_ctrl);
  Application.CreateForm(TFRM_Sources, FRM_Sources);
  Application.CreateForm(TFRM_Solsys, FRM_Solsys);
  Application.CreateForm(TFRM_Scan, FRM_Scan);
  Application.CreateForm(TFRM_Stats, FRM_Stats);
  Application.CreateForm(TFRM_Phalanx, FRM_Phalanx);
  Application.CreateForm(TFRM_ScanGen, FRM_ScanGen);
  Application.CreateForm(Tfrm_unit_test, frm_unit_test);
  Application.Run;
end.
