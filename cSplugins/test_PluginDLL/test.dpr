program TEST;

uses
  Forms,
  DLL_plugin_TEST in 'DLL_plugin_TEST.pas' {FRM_MainTest},
  Bericht_Frame in '..\Bericht_Frame.pas' {Frame_Bericht: TFrame},
  Notizen in '..\Notizen.pas' {FRM_Notizen},
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
  cS_networking in '..\..\cS_networking.pas',
  ThreadProtocolObject in '..\..\ThreadProtocolObject.pas',
  NetUniverseTree in '..\..\UniverseTree\NetUniverseTree.pas',
  UniTree in '..\..\UniverseTree\UniTree.pas',
  TIReadPlugin in '..\..\ReadPlugins\TIReadPlugin.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFRM_MainTest, FRM_MainTest);
  Application.CreateForm(TFRM_Sources, FRM_Sources);
  Application.CreateForm(TFRM_Solsys, FRM_Solsys);
  Application.CreateForm(TFRM_Scan, FRM_Scan);
  Application.CreateForm(TFRM_Stats, FRM_Stats);
  Application.CreateForm(TFRM_Phalanx, FRM_Phalanx);
  Application.CreateForm(TFRM_ScanGen, FRM_ScanGen);
  Application.Run;
end.
