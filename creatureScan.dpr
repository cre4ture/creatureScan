program creatureScan;



uses
  XPMan,
  Forms,
  Controls,
  Classes,
  registry,
  windows,
  messages,
  Sysutils,
  inifiles,
  FileCtrl,
  Dialogs,
  Main in 'Main.pas' {FRM_Main},
  Galaxy_Explorer in 'Galaxy_Explorer.pas' {Explorer},
  Bericht_Frame in 'Bericht_Frame.pas' {Frame_Bericht: TFrame},
  Notizen in 'Notizen.pas' {FRM_Notizen},
  Suche in 'Suche.pas' {TFRM_Suche},
  Favoriten in 'Favoriten.pas' {FRM_Favoriten},
  Mond_Abfrage in 'Mond_Abfrage.pas' {FRM_Mond},
  Info in 'Info.pas' {FRM_Info},
  Uebersicht in 'Uebersicht.pas' {FRM_Uebersicht},
  Spielerdaten in 'Spielerdaten.pas' {FRM_Spielerdaten},
  Connections in 'Connections.pas' {FRM_Connections},
  Einstellungen in 'Einstellungen.pas' {FRM_Einstellungen},
  Export in 'Export.pas' {FRM_Export},
  ImportProgress in 'ImportProgress.pas' {FRM_ImportProgress},
  SelectUser in 'SelectUser.pas' {FRM_SelectUser},
  UeberSichtOptions in 'UeberSichtOptions.pas' {FRM_Marker},
  AddNotiz in 'AddNotiz.pas' {FRM_AddNotiz},
  Suchen_Ersetzen in 'Suchen_Ersetzen.pas' {FRM_Suchen_Ersetzen},
  ClientLogin in 'ClientLogin.pas' {FRM_ClientLogin},
  Galaxien_Rechte in 'Galaxien_Rechte.pas' {FRM_Galaxy_Rights},
  Group_Rights in 'Group_Rights.pas' {FRM_Group_Rights},
  KB_List in 'KB_List.pas' {FRM_KB_List},
  Add_KB in 'Add_KB.pas' {FRM_Add_Raid},
  Languages in 'Languages.pas',
  Connect in 'Connect.pas' {FRM_Connect},
  OGame_Types in 'OGame_Types.pas',
  Notizen_Images_Einstellungen in 'Notizen_Images_Einstellungen.pas' {FRM_Notizen_Images_einstellungen},
  SelectLanguage in 'SelectLanguage.pas' {FRM_SelectLanguage},
  SelectPlugin in 'SelectPlugin.pas' {FRM_SelectPlugin},
  Delete_Scans in 'Delete_Scans.pas' {FRM_Delete_Scans},
  Stat_Points in 'Stat_Points.pas',
  Stats_Einlesen in 'Stats_Einlesen.pas' {FRM_Stats_Einlesen},
  ThreadProtocolObject in 'ThreadProtocolObject.pas',
  cS_XML in 'cS_XML.pas',
  VSTPopup in 'VSTPopup.pas',
  Prog_Unit in 'Prog_Unit.pas',
  ReadWriteEvent in 'ReadWriteEvent.pas',
  Chat in 'Chat.pas' {FRM_Chat},
  CoordinatesRanges in 'CoordinatesRanges.pas',
  FavFilter in 'FavFilter.pas' {FRM_Filter},
  _test_POST in '_test_POST.pas' {FRM_POST_TEST},
  oFight in 'oFight.pas',
  SDBFile in 'D:\lib\uli\TSDBFile\SDBFile.pas',
  cS_DB_reportFile in 'cS_DB_reportFile.pas',
  cS_DB in 'cS_DB.pas',
  cS_networking in 'cS_networking.pas',
  cS_DB_solsysFile in 'cS_DB_solsysFile.pas',
  TIReadPlugin in 'ReadPlugins\TIReadPlugin.pas',
  UniTree in 'UniverseTree\UniTree.pas',
  RaidBoard in 'RaidBoard.pas',
  cS_DB_fleetfile in 'cS_DB_fleetfile.pas',
  OtherTime in 'OtherTime.pas',
  languagemodul in 'languagemodul.pas',
  langmodform in 'langmodform.pas',
  sliding_window in 'sliding_window.pas',
  notify_fleet_arrival in 'notify_fleet_arrival.pas' {frm_fleet_arrival},
  EditScan in 'EditScan.pas' {FRM_EditScan},
  zeit_sync in '..\Ogame_tools\zeit_sync\zeit_sync.pas',
  config_cS_db_engine in 'config_cS_db_engine.pas' {frm_config_cS_engine},
  sync_cS_db_engine in 'sync_cS_db_engine.pas' {frm_sync_cS_db_engine},
  OGameData in 'OGameData.pas';

{$R *.RES}

const
  {$IFDEF spacepioneers}
  XML_InitFile = 'data\spacepioneers_consts.xml';
  {$ELSE}
  XML_InitFile = 'data\ogame_consts.xml';
  {$ENDIF}

procedure LoadMainOptions;
var ini: TIniFile;
begin
  ini := TIniFile.Create(GetCurrentDir + '/creatureScan.ini');
  userdatadir := ini.ReadString('directory','userdatadir','userdata/');
  DefaultUser := ini.ReadString('user','defaultuser','');
  LastUser := ini.ReadString('user','lastuser','');
  LangFile := ini.ReadString('language','languagefile','');
  ini.free;
end;

procedure SaveMainOptions;
var ini: TIniFile;
begin
  ini := TIniFile.Create(GetCurrentDir + '/creatureScan.ini');
  ini.WriteString('directory','userdatadir',userdatadir);
  ini.WriteString('user','defaultuser',DefaultUser);
  ini.WriteString('user','lastuser',LastUser);
  ini.WriteString('language','languagefile',LangFile);
  ini.UpdateFile;
  ini.free;
end;

function DoSelectUser: string;
var dialog: TFRM_SelectUser;
    f: TSearchRec;
    r: integer;
begin
  dialog := TFRM_SelectUser.Create(Application);
  dialog.ComboBox1.Text := LastUser;
  dialog.CheckBox1.Checked := (DefaultUser <> '');

  r := FindFirst(userdatadir + '*.*',faDirectory,f);
  while (r = 0) do
  begin
    if (f.Name <> '.')and(f.Name <> '..') then
    dialog.ComboBox1.Items.Add(copy(f.Name,1,length(f.Name)));
    r := FindNext(f);
  end;
  FindClose(f);

  if (dialog.ShowModal = IDOK) then
  begin
    Result := dialog.ComboBox1.Text;

    if dialog.CheckBox1.Checked then DefaultUser := Result
    else DefaultUser := '';
  end else Result := '';
  dialog.free;
end;

function LoadLanguageFile(User: string): Boolean;
var ini: TIniFile;
begin
  ini := TIniFile.Create('User_Files\User_'+User+'.inf');
  LangFile := ini.ReadString('Language','LanguageFile','');
  Result := FileExists(LangFile);
  if not Result then
  begin
    Result := SelectLanguageDialog;
    if Result then
    begin
      ini.WriteString('Language','LanguageFile',LangFile);
      ini.UpdateFile;
    end;
  end;
  ini.Free;
  if Result then LanguageFile(LangFile);
end;

begin
  Application.Initialize;
  Application.Title := 'creatureScan';
  ChDir(ExtractFilePath(Application.ExeName));

  LoadMainOptions;
  GlobalLangMod_Init(LangFile);
  login := false; ///???????

  if (DefaultUser = '')or(ParamStr(1) = '-selectuser') then
    LastUser := DoSelectUser
  else LastUser := DefaultUser;

  if LastUser = '' then Exit;

  if not DirectoryExists(userdatadir) then
    CreateDir(userdatadir);
  if not DirectoryExists(userdatadir + LastUser) then
    CreateDir(userdatadir + LastUser);
  SaveMainOptions;

  if FileExists(XML_InitFile) then
  begin
    OGame_Types.Initialise(XML_InitFile);
  end
  else ShowMessage('XML-iniData not found!');

  Protocol := TThreadProtocol.Create(ExtractFilePath(Application.ExeName) +
    userdatadir + LastUser + '\proto');
  Protocol.OnIdentifySender := LogSenderToStr;

  cSServer := TcSServer.Create(Protocol, GetCurrentDir + '/' + userdatadir + LastUser + '/server.ini');
  ODataBase := TOgameDataBase.Create(true,GetCurrentDir + '/' + userdatadir + LastUser + '/', cSServer, XML_InitFile);

  if not ODataBase.InitialisedF then
  begin
    ODataBase.free;
    Exit;
  end;

  ChDir(ExtractFilePath(Application.ExeName));

  Application.CreateForm(TFRM_Main, FRM_Main);
  Application.CreateForm(TFRM_Export, FRM_Export);
  Application.CreateForm(TFRM_Notizen, FRM_Notizen);
  Application.CreateForm(TFRM_Marker, FRM_Marker);
  Application.CreateForm(TFRM_Suchen_Ersetzen, FRM_Suchen_Ersetzen);
  Application.CreateForm(TFRM_KB_List, FRM_KB_List);
  Application.CreateForm(TFRM_Delete_Scans, FRM_Delete_Scans);
  Application.CreateForm(TFRM_Chat, FRM_Chat);
  Application.CreateForm(TFRM_Filter, FRM_Filter);
  Application.CreateForm(TFRM_POST_TEST, FRM_POST_TEST);
  Application.CreateForm(TFRM_Connections, FRM_Connections);
  Application.CreateForm(TFRM_Uebersicht, FRM_Uebersicht);
  Application.CreateForm(TFRM_Favoriten, FRM_Favoriten);
  Application.CreateForm(TFRM_Info, FRM_Info);
  Application.CreateForm(TFRM_EditScan, FRM_EditScan);
  Application.CreateForm(Tfrm_sync_cS_db_engine, frm_sync_cS_db_engine);
  Application.Run;

  FRM_Chat.Free;
  FRM_Notizen.Free;
  FRM_Connections.Free;
  FRM_KB_List.Free;
  FRM_KB_List := nil;
  FRM_Main.Free;
  ODataBase.Free;
  cSServer.Free;
  Protocol.Free;
  if login then
    WinExec(PChar('"' + Application.Exename + '" -selectuser'), SW_SHOWNORMAL);

  GlobalLangMod_Free;
end.


