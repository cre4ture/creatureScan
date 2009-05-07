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
  cS_DB in '..\cS_DB.pas',
  SDBFile in '..\..\lib\uli\TSDBFile\SDBFile.pas',
  cS_DB_reportFile in '..\cS_DB_reportFile.pas',
  TIReadPlugin in '..\ReadPlugins\TIReadPlugin.pas',
  cS_DB_solsysFile in '..\cS_DB_solsysFile.pas',
  Phalanx in 'Phalanx.pas' {FRM_Phalanx},
  notify_fleet_arrival in '..\notify_fleet_arrival.pas' {frm_fleet_arrival},
  cS_XML in '..\cS_XML.pas',
  FileUtils_UH in '..\..\lib\uli\FileUtils_UH.pas',
  OGame_Types in '..\OGame_Types.pas',
  Reports in 'Reports.pas' {FRM_ScanGen},
  zeit_sync in '..\..\Ogame_tools\zeit_sync\zeit_sync.pas',
  MusiPlayer in '..\..\lib\uli\musiPlayer\MusiPlayer.pas',
  clipbrdFunctions in '..\..\lib\uli\TClipboardViewer\clipbrdFunctions.pas',
  ClipboardViewerForm in '..\..\lib\uli\TClipboardViewer\ClipboardViewerForm.pas',
  notifywindow in '..\..\lib\uli\notifyWindow\notifywindow.pas' {frm_notify};

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
