unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, OGame_Types, Prog_Unit, Inifiles, Galaxy_Explorer, Grids, ExtCtrls,
  Bericht_Frame, ComCtrls, Menus, Suche, shellapi, Buttons,
  AppEvnts, jpeg, Math, ImgList, VirtualTrees, cS_DB_solsysFile, cS_DB_reportFile,
  clipbrd, ClipboardViewerForm, EditScan, stringlistedit, xmldom,
  XMLIntf, msxmldom, XMLDoc, cs_XML, oFight, clipbrdfunctions, UniTree,
  frm_pos_size_ini, MusiPlayer, TIReadPlugin, PlanetListInterface,
  TrayIcon, PostErrorReport, quickupdate;

const
  Transporter_space = 25000;
  Transporter_oil = 50;
  Schlachtschiff_space = 1500;
  Schlachtschiff_oil = 500;

  WM_MOUSESpezialKeyDown  = $020B;
  WM_MOUSESpezialKeyUp  = $020C;

  svk_back = $00010000;
  svk_forward = $00020000;

type
  TSuchInetTyp = (sitPlayer, sitAllanz);
  TSuchInetVorlage = record
    Allianz, Spieler, Name: String;
  end;
  TAngriffsLogig = (al_Drago,al_PlanDB);
  TPlayerOptions = Record
    Transporter: TShip;
    Schlachtschiff: TShip;
    StartPlanet: TPlanetPosition;
    Flugzeit_u: Int64;
    AngriffsLogig: TAngriffsLogig;
    SuchInet: TSuchInetVorlage;
    ServerPort: Word;
    phpPost: String;
    StartSystray: Boolean;

    // Scan/Systeme
    noMoonQuestion: boolean;

    //BeepSound
    Beep_SoundFile: String;

    //Fleets:
    Fleet_ShowArivalMessage: boolean;
    Fleet_AMSG_Time_s: Integer;
    Fleet_alert: Boolean;
    Fleet_Soundfile: String;
    Fleet_auto_time_sync: Boolean;

    // Websim
    websim_techs: array[0..2] of integer;
    websim_engines: array[0..2] of integer;

    // cshelper_listener
    cshl_active: boolean;
    cshl_port: integer;
  end;
  TFRM_Main = class(TClipboardViewer)
    MainMenu1: TMainMenu;
    Datenbank1: TMenuItem;
    NeuerGalaxyExplorer1: TMenuItem;
    StatusBar1: TStatusBar;
    Info1: TMenuItem;
    TrayIconPopup: TPopupMenu;
    MainWindow1: TMenuItem;
    N1: TMenuItem;
    Close1: TMenuItem;
    Beenden1: TMenuItem;
    NetConnections1: TMenuItem;
    Fenster1: TMenuItem;
    Dir: TMenuItem;
    Import2: TMenuItem;
    Export1: TMenuItem;
    N5: TMenuItem;
    P_ExplorerDock: TPanel;
    OpenDialog1: TOpenDialog;
    alsandererBenutzerneustarten1: TMenuItem;
    Einstellungen1: TMenuItem;
    P_Scan: TPanel;
    Frame_Bericht2: TFrame_Bericht;
    Info2: TMenuItem;
    TIM_Start: TTimer;
    il_trayicon: TImageList;
    Zwischenablageberwachen1: TMenuItem;
    Splitter1: TSplitter;
    Panel2: TPanel;
    P_WF: TPanel;
    LBL_WF_1: TLabel;
    LBL_WF_0_1: TLabel;
    LBL_WF_2: TLabel;
    LBL_WF_3: TLabel;
    Test1: TMenuItem;
    LBL_WF_0_2: TLabel;
    LBL_WF_0_3: TLabel;
    Languagefile1: TMenuItem;
    N3: TMenuItem;
    Funktionen1: TMenuItem;
    Scanslschen1: TMenuItem;
    Statistiken1: TMenuItem;
    Einlesen1: TMenuItem;
    ApplicationEvents1: TApplicationEvents;
    TIM_afterClipboardchange: TTimer;
    NewScan1: TMenuItem;
    N2: TMenuItem;
    VergelicheSysDateimitDB1: TMenuItem;
    N4: TMenuItem;
    writeunitsinconstsxml1: TMenuItem;
    VergleicheScanDateimitDB1: TMenuItem;
    N6: TMenuItem;
    SaveClipboardtoFile1: TMenuItem;
    SaveDialog1: TSaveDialog;
    POST1: TMenuItem;
    TIM_FakeCV: TTimer;
    N7: TMenuItem;
    exportxml1: TMenuItem;
    Timer1: TTimer;
    selectkoordranges1: TMenuItem;
    ScansDatumLschen1: TMenuItem;
    Frame_Bericht1: TFrame_Bericht;
    N8: TMenuItem;
    Flottenbersicht1: TMenuItem;
    Notizen1: TMenuItem;
    neueSuche1: TMenuItem;
    Universumsbersicht1: TMenuItem;
    Listenansicht1: TMenuItem;
    IL_ScanSize: TImageList;
    N9: TMenuItem;
    frmevents1: TMenuItem;
    PopupMenu1: TPopupMenu;
    Lschen1: TMenuItem;
    Galaxie1: TMenuItem;
    btn_fight_start: TButton;
    popup_auftrag: TPopupMenu;
    Angriff1: TMenuItem;
    Spionage1: TMenuItem;
    N10: TMenuItem;
    Raideintragen1: TMenuItem;
    p_startscreen: TPanel;
    lbl_title: TLabel;
    Label1: TLabel;
    lbl_wiki_link: TLabel;
    Label3: TLabel;
    lbl_forum_link: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    phpSync1: TMenuItem;
    Panel1: TPanel;
    lst_others: TListView;
    BTN_Paste: TButton;
    BTN_Copy: TButton;
    BTN_Liste: TButton;
    BTN_Suche: TButton;
    BTN_Universum: TButton;
    btn_last: TButton;
    btn_next: TButton;
    Scan1: TMenuItem;
    nchstenAuswhlen1: TMenuItem;
    vorherigenauswhlen1: TMenuItem;
    sb_start_bg: TShape;
    Forum1: TMenuItem;
    Wiki1: TMenuItem;
    ico_active: TImage;
    ico_inactive: TImage;
    N11: TMenuItem;
    PostErrorReport1: TMenuItem;
    Update1: TMenuItem;
    Softupdate1: TMenuItem;
    updatecheck2: TMenuItem;
    ZwischenablagefrMondScans1: TMenuItem;
    lbl_dbl_click: TLabel;
    Button1: TButton;
    Spionage2: TMenuItem;
    Expedition1: TMenuItem;
    procedure btn_lastClick(Sender: TObject);
    procedure btn_nextClick(Sender: TObject);
    procedure LblWikiLinkClick(Sender: TObject);
    procedure Raideintragen1Click(Sender: TObject);
    procedure Spionage1Click(Sender: TObject);
    procedure Angriff1Click(Sender: TObject);
    procedure btn_fight_startClick(Sender: TObject);
    procedure BTN_PasteClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BTN_CopyClick(Sender: TObject);
    procedure lst_othersSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure lst_othersCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure BTN_DeleteClick(Sender: TObject);
    procedure NeuerGalaxyExplorer1Click(Sender: TObject);
    procedure Info1Click(Sender: TObject);
    procedure MainWindow1Click(Sender: TObject);
    procedure Beenden1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure StatusBar1DrawPanel(StatusBar: TStatusBar;
      Panel: TStatusPanel; const Rect: TRect);
    procedure DirClick(Sender: TObject);
    procedure Export1Click(Sender: TObject);
    procedure BTN_GalaxieClick(Sender: TObject);
    procedure P_ExplorerDockResize(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Import2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lst_othersColumnClick(Sender: TObject; Column: TListColumn);
    procedure alsandererBenutzerneustarten1Click(Sender: TObject);
    procedure Einstellungen1Click(Sender: TObject);
    procedure Frame_Bericht1Copy1Click(Sender: TObject);
    procedure Frame_Bericht1KopiereinTabellenform1Click(Sender: TObject);
    procedure P_WFResize(Sender: TObject);
    procedure BTN_UniversumClick(Sender: TObject);
    procedure BTN_SucheClick(Sender: TObject);
    procedure BTN_ListeClick(Sender: TObject);
    procedure BTN_TopmostClick(Sender: TObject);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure updatecheck1Click(Sender: TObject);
    procedure TIM_StartTimer(Sender: TObject);
    procedure Zwischenablageberwachen1Click(Sender: TObject);
    procedure SuchenErsetzen1Click(Sender: TObject);
    procedure Languagefile1Click(Sender: TObject);
    procedure Scanslschen1Click(Sender: TObject);
    procedure Einlesen1Click(Sender: TObject);
    procedure NetConnections1Click(Sender: TObject);
    procedure ApplicationEvents1Message(var Msg: tagMSG;
      var Handled: Boolean);
    procedure TIM_afterClipboardchangeTimer(Sender: TObject);
    procedure TrayIconPopupPopup(Sender: TObject);
    procedure lst_othersKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure NewScan1Click(Sender: TObject);
    procedure VergelicheSysDateimitDB1Click(Sender: TObject);
    procedure writeunitsinconstsxml1Click(Sender: TObject);
    procedure VergleicheScanDateimitDB1Click(Sender: TObject);
    procedure SaveClipboardtoFile1Click(Sender: TObject);
    procedure POST1Click(Sender: TObject);
    procedure TIM_FakeCVTimer(Sender: TObject);
    procedure Frame_Bericht1Timer1Timer(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure ScansDatumLschen1Click(Sender: TObject);
    procedure Frame_Bericht1Timer2Timer(Sender: TObject);
    procedure Flottenbersicht1Click(Sender: TObject);
    procedure Notizen1Click(Sender: TObject);
    procedure neueSuche1Click(Sender: TObject);
    procedure Universumsbersicht1Click(Sender: TObject);
    procedure Listenansicht1Click(Sender: TObject);
    procedure Frame_Bericht1PB_BDblClick(Sender: TObject);
    procedure Frame_Bericht1PB_BPaint(Sender: TObject);
    procedure StatusBar1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure phpSync1Click(Sender: TObject);
    procedure Forum1Click(Sender: TObject);
    procedure Wiki1Click(Sender: TObject);
    procedure PostErrorReport1Click(Sender: TObject);
    procedure Softupdate1Click(Sender: TObject);
    procedure ZwischenablagefrMondScans1Click(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Spionage2Click(Sender: TObject);
    procedure Expedition1Click(Sender: TObject);
    procedure frmevents1Click(Sender: TObject);
  published
    procedure FormClipboardContentChanged(Sender: TObject);
  private
    fLatestPlanetListSource: TPlanetListInterface;
    beenden: boolean;
    eee: integer;
    IniFile: String;
    CloseToSystray: Boolean;
    FakeCVClipbrdSequenceNumber: DWORD;
    _____time: TDateTime;
    _____mittelwehrt: Integer;
    topmost: boolean;
    procedure setPlanetListSource(list: TPlanetListInterface);
    property mLatestPlanetListSource: TPlanetListInterface
      read fLatestPlanetListSource write setPlanetListSource;
    procedure simplyShowScan(Pos: TPlanetPosition);
    procedure SearchList(nr: integer; pos: TPlanetPosition);
    procedure PaintScan(scan: TScanBericht; save: TScanGroup = sg_Forschung);
    procedure Wellenangriff(Scan: TScanbericht);
    procedure LoadOptions;
    procedure SaveOptions;
    procedure ODB_UniTree_ReportChanged(Sender: TObject; Pos: TPlanetPosition);
    procedure ODB_UniTree_SolSysChanged(Sender: TObject; Pos: TPlanetPosition);
    procedure SaveLoad_SimpleOptions(ini: TIniFile; save: boolean);
    procedure ShowExplorerPanel;
    procedure ShowScanPanel;
    procedure LangPluginOnAskMoon(Sender: TOgameDataBase;
      const Report: TScanBericht; var isMoon, Handled: Boolean);
  private
    fSearchWindows: TList;
    function getSearchWindow(index: integer): TFRM_Suche;
  protected
    property SearchWindows[index: integer]: TFRM_Suche read getSearchWindow;
    procedure SetCVActive(B: Boolean); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation);
      override;
  public
    frm_quickupdate: Tfrm_quickupdate;
    TrayIco: TTrayIcon;
    DockExplorer: TExplorer;
    PlayerOptions: TPlayerOptions;
    Einstellungen: set of (soAddNewScanToList,
                           soShowScanCountMessage,
                           soBeepByWatchClipboard,
                           soUniCheck,
                           soAutoUpdateCheck,
                           soStartupServer
                           );
    LastClipBoard: String;   //LastClipboard wird nurnoch gesetzt, wenn das programm selber in die Zwischenablage setzt, die nicht verarbeitet werden sollen! (z.b. Copy_button)
    SoundModul: TMusiPlayer;
    procedure intelligentReadData(const text, html: string);
    procedure ShowScan(NR: integer); overload;
    procedure ShowScan(Pos: TPlanetPosition; list: TPlanetListInterface = nil); overload;
    function NewExplorer: TExplorer;
    procedure RightClick(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Play_Alert_Sound(filename: string);
    procedure RefreshDBListSize(Sender: TObject);

    procedure RefreshExplorers(P: TPlanetPosition);

    function NewSearch: TFRM_Suche;
    procedure ShowGalaxie(Pos: TPlanetPosition);
    procedure ShowSmallScan(P: TPlanetPosition);
    procedure OpenInBrowser(url: String);
    procedure SetTrayIcon_;
    procedure RaidDialog(Position: TPlanetPosition); overload;
    function RaidDialog(var Fleet: TFleetEvent): boolean; overload;
    procedure SucheImInet(Typ: TSuchInetTyp; Allianz, Player: String;
      Uni: String);
    procedure ClipbrdReadScan;
    procedure ClipbrdReadSys;
    procedure ShowSearchPlayer(name: string);
    procedure ShowSearchPlayerID(id: Int64);
    procedure ShowSearchAlly(ally: string);
    procedure Show;
    { Public-Deklarationen }
  end;
const
  GeneralSection = 'UserOptions';

var
  FRM_Main: TFRM_Main;
  explorer : array of TExplorer;

procedure callLink(url: string);


implementation

uses Notizen, Favoriten, Info,
  Uebersicht, Connections, Export, Einstellungen, Suchen_Ersetzen,
  KB_List, Add_KB, Languages, Delete_Scans,
  Stats_Einlesen, DateUtils, _test_POST, ComConst, StrUtils, sync_cS_db_engine,
  SDBFile, Mond_Abfrage, moon_or_not, chelper_server;

{$R *.DFM}

procedure TFRM_Main.RightClick(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin

end;

procedure TFRM_Main.BTN_PasteClick(Sender: TObject);
begin
  ClipbrdReadScan;
end;

procedure TFRM_Main.FormDestroy(Sender: TObject);
begin
  mLatestPlanetListSource := nil; // remove free notification
  ODataBase.OnAskMoon := nil;

  SaveOptions;
  Stopp; // Clipboard Viewer
  Beenden := True;
  SoundModul.Free;
  TrayIco.free;

  while fSearchWindows.Count > 0 do
  begin
    SearchWindows[0].Free;
    // The object is removed from the list
    // by the public function "notification"
  end;
  fSearchWindows.Free;
  frm_quickupdate.Free;
end;

procedure TFRM_Main.BTN_CopyClick(Sender: TObject);
var s: string;
begin
  s := ODataBase.LanguagePlugIn.ScanToStr(Frame_Bericht1.Bericht,False);
  LastClipBoard := s;
  Clipboard.AsText := s;
end;

procedure TFRM_Main.ShowScan(Pos: TPlanetPosition; list: TPlanetListInterface = nil);
begin
  mLatestPlanetListSource := list;
  simplyShowScan(Pos);
end;

procedure TFRM_Main.simplyShowScan(Pos: TPlanetPosition);
var scan_gen: TScanBericht;
    info: TSystemPlanet;
    snr: Integer;
begin
  //ACHTUNG: Überladene Funktionen rufen sich nicht gegenseitig auf!

  // Ändere Titel
  Application.Title := 'cS [' + PositionToStrMond(Pos) + ']';

  // Zeigt Generic Scan:
  scan_gen := TScanBericht.Create;
  try
    ODataBase.UniTree.genericReport(Pos, scan_gen);
    if scan_gen.Head.Time_u >= 0 then
    begin
      // Suche Liste
      SearchList(-1,scan_gen.Head.Position);
    end
    else
    begin
      lst_others.Clear;    //Wenn nicht, zeige Sonnensystem-Informationen:
      snr := ODataBase.UniTree.UniSys(Pos.P[0],Pos.P[1]);
      if snr >= 0 then
      begin
        info := ODataBase.Systeme[snr].Planeten[Pos.P[2]];
        Frame_Bericht1.ShowPlanetInfo(Pos,info);

        p_startscreen.Visible := false;
        ShowScanPanel();
      end
      else
      begin
        ShowScan(-1);   //Wenn keine Sonnensystem vorhanden, Zeige NIX!
      end;
    end;
  finally
    scan_gen.Free;
  end;
end;

procedure TFRM_Main.ShowScan(NR: integer);
var scan: TScanBericht;
begin
  //ACHTUNG: Überladene Funktionen rufen sich nicht gegenseitig auf!
  
  if ((NR >= 0)and(NR < ODataBase.Berichte.Count)) then
  begin
    scan := ODataBase.berichte[nr];

    SearchList(nr,scan.Head.Position);
    Application.Title := 'cS [' + PositionToStrMond(scan.Head.Position) + ']';
    PaintScan(scan);
  end
  else
  begin
    Frame_Bericht1.Clear;
    lst_others.Clear;
  end;
end;

procedure TFRM_Main.lst_othersSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
var Scan: TScanBericht;
    nr: integer;
    save: TScanGroup;
begin
  scan := TScanBericht.Create();
  try
    if Selected then
    begin
      nr := StrToInt(item.SubItems[0]);
      if nr >= 0 then
      begin
        Scan.copyFrom(ODataBase.Berichte[nr]);
        save := sg_Forschung;
      end
      else
      begin
        save := ODataBase.UniTree.genericReport(Frame_Bericht1.Bericht.Head.Position,
                                                Scan);
      end;

      PaintScan(Scan, Save);
    end;
  finally
    Scan.Free;
  end;
end;

procedure TFRM_Main.FormCreate(Sender: TObject);
begin
  fSearchWindows := TList.Create;
  fLatestPlanetListSource := nil; // initialise
  mLatestPlanetListSource := nil; // set buttons enabled
  frm_quickupdate := Tfrm_quickupdate.Create(Self, ODataBase, true);
  
  lbl_title.Caption := lbl_title.Caption + VNumber;

  topmost := false;
  StatusBar1.Panels[0].Text := STR_normal;

  {
  TrayIco := TTrayIcon.Create(Self);
  TrayIco.Icons := il_trayicon;
  TrayIco.IconIndex := -1;
  Caption := Caption + ' Uni: ' +
             ODataBase.UniDomain + '.' + ODataBase.game_domain +
             ' User: ' + ODataBase.Username;
  TrayIco.Hint := FRM_Main.Caption;
  TrayIco.PopupMenu := TrayIconPopup;
  TrayIco.OnDblClick := MainWindow1Click;
  TrayIco.Visible := true;
  }
  TrayIco := TTrayIcon.Create(Self);
  TrayIco.Icon := ico_active.Picture.Icon;
  Caption := Caption + ' Uni: ' +
             ODataBase.UniDomain + '.' + ODataBase.game_domain +
             ' User: ' + ODataBase.Username;
  TrayIco.ToolTip := FRM_Main.Caption;
  TrayIco.PopupMenu := TrayIconPopup;
  TrayIco.OnDblClick := MainWindow1Click;
  TrayIco.Active := true;

  SoundModul := TMusiPlayer.Create(Self);

  if SaveCaptions then SaveAllCaptions(Self,LangFile);
  if LoadCaptions then LoadAllCaptions(Self,LangFile);

  LastClipBoard := '<<<<<NEU>>>>>'; //clipboard.AsText;

  OnClipboardContentChanged := FormClipboardContentChanged;
  beenden := false;
  eee := 0;
  ODataBase.UniTree.OnSolSysChanged := ODB_UniTree_SolSysChanged;
  ODataBase.UniTree.OnReportChanged := ODB_UniTree_ReportChanged;
  IniFile := ODataBase.PlayerInf;
  Frame_Bericht2.Style := 2;

  LoadOptions;
  if PlayerOptions.StartSystray then
    Visible := False;

  DockExplorer := TExplorer.Create(self, 1, 'Explorer_Main');
  DockExplorer.dock(P_ExplorerDock,rect(0,0,P_ExplorerDock.ClientWidth,P_ExplorerDock.ClientHeight));
  DockExplorer.Initialise(ODataBase.UserPosition);
  DockExplorer.show;

  LoadFormSizePos(IniFile,self);
  RefreshDBListSize(Self);

  ODataBase.OnAskMoon := LangPluginOnAskMoon;

  StatusBar1.DoubleBuffered := True;
end;

procedure TFRM_Main.lst_othersCompare(Sender: TObject; Item1,
  Item2: TListItem; Data: Integer; var Compare: Integer);
begin
  if StrToDateTime(Item1.SubItems[1]) > StrToDateTime(Item2.SubItems[1]) then
  begin
    Compare := -1;
  end
  else
  begin
    Compare := 1;
  end;
end;

procedure TFRM_Main.BTN_DeleteClick(Sender: TObject);
var p: TPlanetPosition;
    item: TListItem;
    list: TStringList;
    i, ID: integer;
begin
  if lst_others.Selected = nil then
    Exit;

  ID := strtoint(lst_others.Selected.SubItems[0]);
  if ID < 0 then
    Exit;
  

  if Application.MessageBox(
       PChar(STR_Scans_Loeschen_text),
       PChar(STR_Scans_Loeschen_title),
       MB_OKCANCEL)
     <> ID_OK then Exit;


  //wichtig: der löschvorgang muss von hohem index zu niedrigen gehen!
  if lst_others.SelCount > 0 then
  begin
    list := TStringList.Create;
    p := ODataBase.Berichte[ID].Head.Position;
    item := lst_others.Items[0];
    while item <> nil do
    begin
      if item.Selected then
      begin
        list.Add(item.SubItems[0]);
        item.Delete;
      end;
      if lst_others.Items.Count > 0 then
      begin
        if lst_others.Items[0].Selected then
          item := lst_others.Items[0]
        else                                 
          item := lst_others.GetNextItem(lst_others.Items[0],sdAll,[isSelected]);
      end
      else
        item := nil;
    end;
    list.Sort;
    for i := list.Count-1 downto 0 do //rückwärts, weil, wenn du einen niederen index löscht, es sein kann, das die höheren nichtmehr stimmen, wohl aber die drunnter!
      ODataBase.UniTree.DeleteReport(StrToIntDef(list[i], -1));

    list.Free;
    lst_others.Items.Clear;
    if (ODataBase.Uni[p.P[0],p.P[1]].Planeten[p.P[2],p.Mond].ScanBericht >= 0) then
      ShowScan(ODataBase.Uni[p.P[0],p.P[1]].Planeten[p.P[2],p.Mond].ScanBericht);
  end;
end;

function TFRM_Main.NewExplorer: TExplorer;
var i : integer;
begin
  i := 0;
  while (i < length(Explorer))and(Explorer[i].Visible) do
  begin
    inc(i);
  end;

  if i + 1 >= length(Explorer) then
  begin
    setlength(explorer,i+1);
  end;

  if explorer[i] = nil then explorer[i] := TExplorer.Create(Self,0,'Explorer_Extra_' + IntToStr(i));
  
  explorer[i].Initialise(ODataBase.UserPosition);
  explorer[i].show;
  Result := explorer[i];
end;

procedure TFRM_Main.NeuerGalaxyExplorer1Click(Sender: TObject);
begin
  NewExplorer;
end;

procedure TFRM_Main.Info1Click(Sender: TObject);
begin
  FRM_Info.ShowModal;
end;

procedure TFRM_Main.MainWindow1Click(Sender: TObject);
begin
  Show;
  SetFocus;
  BringToFront;
end;

procedure TFRM_Main.SearchList(nr: integer; pos: TPlanetPosition);
var i: integer;                //nr -> damit ich weis welchen zum selektieren
    item, gitem: TListItem;
    list: TReportTimeList;
    stime: TDateTime;
begin
  lst_others.Items.BeginUpdate;
  // this is necessary couse we save our MainPosition in the FRAME!
  Frame_Bericht1.Bericht.Head.Position := pos;

  try
    lst_others.Items.Clear;

    // Füge generic hinzu:
    item := lst_others.Items.Add;
    item.Caption := 'generic';
    item.SubItems.Add('-1');  // SCAN ID
    item.SubItems.Add(DateTimeToStr(now()+99999));  // Date
    gitem := item;


    list := ODataBase.UniTree.GetPlanetReportList(pos);
    for i := 0 to length(list)-1 do
    begin
      item := lst_others.Items.Add;
      stime := UnixToDateTime(list[i].Time_u);
      if trunc(stime) = trunc(now) then //wenn Gleicher Tag
        item.Caption := TimeToStr(stime)
      else
        item.Caption := DateTimeToStr(stime);

      item.SubItems.add(inttostr(list[i].ID));
      if (list[i].ID = nr) then
        item.Selected := true;
      item.SubItems.Add(DateTimeToStr(stime));

      //Zähle vorhandene Scangruppen:
      item.ImageIndex := GetScanGrpCount(ODataBase.Berichte[list[i].ID]);
    end;

    // Wenn NR nicht gefunden, generic markieren
    if lst_others.Selected = nil then
      gitem.Selected := true;

  finally
    lst_others.Items.EndUpdate;
  end;
end;

procedure TFRM_Main.Beenden1Click(Sender: TObject);
begin
  Beenden := true;
  Close;
end;

procedure TFRM_Main.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := (not CloseToSystray) or beenden or
     not((Mouse.CursorPos.x > Left + Width - 50)and
         (Mouse.CursorPos.x < Left + Width + 50)and
         (Mouse.CursorPos.y > Top - 50)and
         (Mouse.CursorPos.y < Top + 50)
         );

  if CanClose and ( frm_report_basket.vst_reports.RootNodeCount > 0 ) then
  begin
    if Application.MessageBox('Die Zwischenablage für Mond?Scans enthält noch '#13#10 +
      'ungespeicherte Scanberichte, wirklich beenden?',
      'Ungespeicherte Scans in der TmpReportBox',
      MB_YESNO or MB_ICONQUESTION) = IDNO then
    begin
      frm_report_basket.Show;
      CanClose := False;
      beenden := false;
      exit;
    end;
  end;

  Beenden := CanClose;
  if not CanClose then
  begin
    DockExplorer.Hide;
    Hide;
  end
  else
  begin
    inc(eee);
    if eee = 1 then
    begin
      TrayIco.Active := false;
      DockExplorer.Release;
      //Close;
    end; 
  end;
end;

procedure TFRM_Main.StatusBar1DrawPanel(StatusBar: TStatusBar;
  Panel: TStatusPanel; const Rect: TRect);
//var re : TRect;
var c: TColor;
begin
  with StatusBar.Canvas do
  begin
    {re := Rect;
    re.Right := trunc((Rect.Right-Rect.Left) * (StrToInt(Panel.Text) / 100)) + Rect.Left;
    Brush.Color := StatusBar.Color;
    FillRect(Rect);
    Brush.Color := clBlue;
    FillRect(re);}
    case StrToInt(Panel.Text) of
    0..70: c := clLime;
    71..200: c := clYellow;
    else c := clRed;
    end;
    Brush.Color := c;
    FillRect(Rect);
    TextOut(Rect.Left,Rect.Top,Panel.Text);
  end;
end;

procedure TFRM_Main.RefreshDBListSize(Sender: TObject);
begin
  StatusBar1.Panels[2].Text := STR_Scanberichte + ': ' + IntToStr(ODataBase.Berichte.Count);
  StatusBar1.Panels[3].Text := STR_Systeme + ': ' + IntToStr(ODataBase.Systeme.Count);
end;

procedure TFRM_Main.DirClick(Sender: TObject);
begin
  WinExec(PChar('"explorer" "' + ExtractFileDir(application.exename)), SW_SHOWNORMAL);
end;

procedure TFRM_Main.Export1Click(Sender: TObject);
begin
  FRM_Export.Show;
end;

procedure TFRM_Main.BTN_GalaxieClick(Sender: TObject);
begin
  if P_Scan.Visible then
  begin
    if ValidPosition(Frame_Bericht1.Bericht.Head.Position) then
      ShowGalaxie(Frame_Bericht1.Bericht.Head.Position)
    else
      ShowGalaxie(ODataBase.UserPosition);
  end
  else
  begin
    ShowScanPanel;
  end;
end;

procedure TFRM_Main.btn_lastClick(Sender: TObject);
var pos: TPlanetPosition;
begin
  if mLatestPlanetListSource <> nil then
  begin
    if mLatestPlanetListSource.selectPreviousPlanet(pos) then
      simplyShowScan(pos);
  end;
end;

procedure TFRM_Main.P_ExplorerDockResize(Sender: TObject);
begin
  if DockExplorer <> nil then
  begin
    DockExplorer.Width := P_ExplorerDock.ClientWidth;
    Frame_Bericht2.Height := P_ExplorerDock.ClientHeight - DockExplorer.Height;
  end;
end;

procedure TFRM_Main.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    integer('W'):
      BTN_GalaxieClick(Sender);
    VK_LEFT:
      btn_lastClick(Sender);
    VK_RIGHT:
      btn_nextClick(Sender);
  end;
end;

procedure TFRM_Main.Import2Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    ODataBase.ImportFile(OpenDialog1.FileName);
  end;
end;

procedure TFRM_Main.FormShow(Sender: TObject);
begin
  if DockExplorer <> nil then
    DockExplorer.Show;
end;

procedure TFRM_Main.lst_othersColumnClick(Sender: TObject;
  Column: TListColumn);
var i : integer;
begin
  for i := 0 to lst_others.Items.Count-1 do
    lst_others.Items[i].Selected := true;
end;

procedure TFRM_Main.alsandererBenutzerneustarten1Click(Sender: TObject);
begin
  login := true;
  Beenden1Click(self);
end;

procedure TFRM_Main.Einstellungen1Click(Sender: TObject);
var i: integer;
    form: TFRM_Einstellungen;
begin
  Form := TFRM_Einstellungen.Create(self);
  
  for i := 0 to length(FRM_Favoriten.FleetDefRessValues)-1 do
    Form.FDRessValues[i] := FRM_Favoriten.FleetDefRessValues[i];
  for i := 0 to length(FRM_Favoriten.FleetDefValues)-1 do
    Form.FDValues[i] := FRM_Favoriten.FleetDefValues[i];


  form.CH_AddNewScan.Checked := soAddNewScanToList in Einstellungen;
  form.CH_ShowCountScan.Checked := soShowScanCountMessage in Einstellungen;
  form.CH_Clipboard.Checked := CVActive;
  form.txt_beep_sound_file.Text := PlayerOptions.Beep_SoundFile;
  form.CH_Unicheck.Checked := soUniCheck in Einstellungen;
  form.txt_UniCheckName.Text := ODataBase.UniCheckName;
  form.CH_Beep.Checked := soBeepByWatchClipboard in Einstellungen;
  form.CH_AutoDelete.Checked := ODataBase.DeleteScansWhenAddSys;
  form.ch_startupServer.Checked := soStartupServer in Einstellungen;
  form.TXT_ServerStartPort.Text := IntToStr(PlayerOptions.ServerPort);
  form.cb_no_moon.Checked := PlayerOptions.noMoonQuestion;
  form.cb_check_solsys_data_for_moon.Checked := ODataBase.check_solsys_data_before_askMoon;

  form.TXT_SS.Text := LBL_WF_0_2.Caption;
  form.TXT_gT.Text := LBL_WF_0_3.Caption;
  form.TXT_Schlachter_Laderaum.Text := IntToStr(PlayerOptions.Schlachtschiff.space);
  form.TXT_Transporter_Laderaum.Text := IntToStr(PlayerOptions.Transporter.space);
  form.TXT_Schlachter_Treibstoff.Text := IntToStr(PlayerOptions.Schlachtschiff.oil);
  form.TXT_Transporter_Treibstoff.Text := IntToStr(PlayerOptions.Transporter.oil);

  form.TXT_RaidStart.Text := PositionToStrMond(PlayerOptions.StartPlanet);
  form.TXT_Flugzeit.Text := TimeToStr(UnixToDateTime(PlayerOptions.Flugzeit_u));

  form.redHours := ODataBase.redHours;
  form.TXT_maxhourstoadd.Text := IntToStr(trunc(ODataBase.MaxTimeToAdd*24));
  if PlayerOptions.AngriffsLogig = al_Drago then form.RB_Dragologic.Checked := True
  else form.RB_PlanDBlogic.Checked := True;
  form.CH_AutoUpdate.Checked := soAutoUpdateCheck in Einstellungen;
  form.CH_MiniSysTray.Checked := CloseToSystray;

  //Flotteneinstellugen (Raid-List)
  form.cb_fleet_popup_enabled.Checked := PlayerOptions.Fleet_ShowArivalMessage;
  form.txts_fleet_popup_time_s.Value := PlayerOptions.Fleet_AMSG_Time_s;
  form.txt_fleet_alert_sound.Text := PlayerOptions.Fleet_Soundfile;
  form.cb_fleet_alert_sound.Checked := PlayerOptions.Fleet_alert;
  form.cb_auto_serverzeit.Checked := PlayerOptions.Fleet_auto_time_sync;

  // websim
  form.se_tech_0.Value := PlayerOptions.websim_techs[0];
  form.se_tech_1.Value := PlayerOptions.websim_techs[1];
  form.se_tech_2.Value := PlayerOptions.websim_techs[2];
  form.se_engine_0.Value := PlayerOptions.websim_engines[0];
  form.se_engine_1.Value := PlayerOptions.websim_engines[1];
  form.se_engine_2.Value := PlayerOptions.websim_engines[2];

  with cSServer.Users do
  begin
    LockUsers;
    try
      if (UserCount > 0) then
      begin
        form.ClientGroup := Users[0];

        setlength(form.Groups,UserCount-1);
        for i := 1 to UserCount-1 do
          form.Groups[i-1] := Users[i];
      end
      else
      begin
        setlength(form.Groups,0);
      end;
    finally
      UnlockUsers;
    end;
  end;

  form.TXT_Allysuche.Text := PlayerOptions.SuchInet.Allianz;
  form.TXT_Spielersuche.Text := PlayerOptions.SuchInet.Spieler;
  form.TXT_SuchenName.Text := PlayerOptions.SuchInet.Name;

  form.RB_Explorer_nurDatum.Checked := explorer_Zeitformat = ezf_Datum;
  form.RB_Explorer_genaueZeitangabe.Checked := explorer_Zeitformat = ezf_DatumUhrzeit;
  form.CH_explorer_MouseOver.Checked := explorer_mouseover;
  form.TXT_TF_markierung_groesse.Text := IntToStr(explorer_TF_Size);
  form.sh_lbl_vacation.Brush.Color := explorer_bgcolor_vaction;
  form.sh_lbl_noob.Brush.Color := explorer_bgcolor_noob;
  form.sh_lbl_inactive.Brush.Color := explorer_bgcolor_inactive;

  //Fake ClipboadViewer (für Linux/Wine)
  form.CB_FakeClipbrdViewer.Checked := TIM_FakeCV.Enabled;
  form.TXT_FakeCVIntervall.Text := IntToStr(TIM_FakeCV.Interval);

  //Start im Hintergrund (minimze to systray at start)
  form.cb_start_systray.Checked := PlayerOptions.StartSystray;

  form.cb_auto_fav_list.Checked := (FRM_Favoriten.ListType = flt_all_auto_list);

  // cshelper_listener
  form.cb_cshelper_listener.Checked := PlayerOptions.cshl_active;
  form.txt_cshelper_listener_port.Text := IntToStr(PlayerOptions.cshl_port);

  if Form.ShowModal = mrOK then
  begin
    for i := 0 to length(FRM_Favoriten.FleetDefRessValues)-1 do
       FRM_Favoriten.FleetDefRessValues[i] := Form.FDRessValues[i];
    for i := 0 to length(FRM_Favoriten.FleetDefValues)-1 do
       FRM_Favoriten.FleetDefValues[i] := Form.FDValues[i];

    Einstellungen := [];
    if form.CH_AddNewScan.Checked then include(Einstellungen,soAddNewScanToList);
    if form.CH_ShowCountScan.Checked then include(Einstellungen,soShowScanCountMessage);
    CVActive := form.CH_Clipboard.Checked;
    if form.CH_Beep.Checked then include(Einstellungen,soBeepByWatchClipboard);
    PlayerOptions.Beep_SoundFile := form.txt_beep_sound_file.Text;
    if form.CH_Unicheck.Checked then Include(Einstellungen,soUniCheck);
    ODataBase.UniCheckName := form.txt_UniCheckName.Text;
    ODataBase.DeleteScansWhenAddSys := form.CH_AutoDelete.Checked;
    ODataBase.check_solsys_data_before_askMoon := form.cb_check_solsys_data_for_moon.Checked;
    PlayerOptions.noMoonQuestion := form.cb_no_moon.Checked;
    frm_report_basket.cb_only_planets.Checked := PlayerOptions.noMoonQuestion;

    if form.ch_startupServer.Checked then Include(Einstellungen,soStartupServer);
    PlayerOptions.ServerPort := StrToInt(form.TXT_ServerStartPort.Text);

    LBL_WF_0_2.Caption := form.TXT_SS.Text;
    LBL_WF_0_3.Caption := form.TXT_gT.Text;
    PlayerOptions.Schlachtschiff.space := StrToIntDef(form.TXT_Schlachter_Laderaum.Text,PlayerOptions.Schlachtschiff.space);
    PlayerOptions.Transporter.space := StrToIntDef(form.TXT_Transporter_Laderaum.Text,PlayerOptions.Transporter.space);
    PlayerOptions.Schlachtschiff.oil := StrToIntDef(form.TXT_Schlachter_Treibstoff.Text,PlayerOptions.Schlachtschiff.oil);
    PlayerOptions.Transporter.oil := StrToIntDef(form.TXT_Transporter_Treibstoff.Text,PlayerOptions.Transporter.oil);

    PlayerOptions.StartPlanet := StrToPosition(form.TXT_RaidStart.Text);
    try
      PlayerOptions.Flugzeit_u := DateTimeToUnix(StrToTime(form.TXT_Flugzeit.Text));
    except
      ShowMessage(STR_MSG_Cant_ReadFlyTime);
    end;

    ODataBase.redHours := form.redHours;
    ODataBase.MaxTimeToAdd := StrToIntDef(form.TXT_maxhourstoadd.Text,trunc(ODataBase.MaxTimeToAdd*24))/24;
    if form.RB_Dragologic.Checked then PlayerOptions.AngriffsLogig := al_Drago
    else PlayerOptions.AngriffsLogig := al_PlanDB;
    if form.CH_AutoUpdate.Checked then include(Einstellungen,soAutoUpdateCheck);
    CloseToSystray := form.CH_MiniSysTray.Checked;

    with cSServer.Users do
    begin
      LockUsers;
      try
        if (UserCount = 0) then
          AddUser(form.ClientGroup)
        else Users[0] := form.ClientGroup;

        UserCount := 1 + length(form.Groups);

        for i := 0 to length(form.Groups)-1 do
          Users[i+1] := form.Groups[i];
      finally
        UnlockUsers;
      end;
    end;

    PlayerOptions.SuchInet.Allianz := form.TXT_Allysuche.Text;
    PlayerOptions.SuchInet.Spieler := form.TXT_Spielersuche.Text;
    PlayerOptions.SuchInet.Name := form.TXT_SuchenName.Text;

    if form.RB_Explorer_nurDatum.Checked then explorer_Zeitformat := ezf_Datum else explorer_Zeitformat := ezf_DatumUhrzeit;
    explorer_mouseover := form.CH_explorer_MouseOver.Checked;
    explorer_TF_Size := StrToInt(form.TXT_TF_markierung_groesse.Text);
    explorer_bgcolor_vaction := form.sh_lbl_vacation.Brush.Color;
    explorer_bgcolor_noob := form.sh_lbl_noob.Brush.Color;
    explorer_bgcolor_inactive := form.sh_lbl_inactive.Brush.Color;

    //Fake ClipboadViewer (für Linux/Wine)
    TIM_FakeCV.Enabled := form.CB_FakeClipbrdViewer.Checked;
    TIM_FakeCV.Interval := StrToInt(form.TXT_FakeCVIntervall.Text);

    //Start im Hintergrund (minimze to systray at start)
    PlayerOptions.StartSystray := form.cb_start_systray.Checked;

    //Flotteneinstellugen (Raid-List)
    PlayerOptions.Fleet_ShowArivalMessage := form.cb_fleet_popup_enabled.Checked;
    PlayerOptions.Fleet_AMSG_Time_s := form.txts_fleet_popup_time_s.Value;
    PlayerOptions.Fleet_Soundfile := form.txt_fleet_alert_sound.Text;
    PlayerOptions.Fleet_alert := form.cb_fleet_alert_sound.Checked;
    PlayerOptions.Fleet_auto_time_sync := form.cb_auto_serverzeit.Checked;

    // websim
    PlayerOptions.websim_techs[0] := form.se_tech_0.Value;
    PlayerOptions.websim_techs[1] := form.se_tech_1.Value;
    PlayerOptions.websim_techs[2] := form.se_tech_2.Value;
    PlayerOptions.websim_engines[0] :=  form.se_engine_0.Value;
    PlayerOptions.websim_engines[1] :=  form.se_engine_1.Value;
    PlayerOptions.websim_engines[2] :=  form.se_engine_2.Value;

    if form.cb_auto_fav_list.Checked then
      FRM_Favoriten.ListType := flt_all_auto_list
    else
      FRM_Favoriten.ListType := flt_list;

    // cshelper_listener
    PlayerOptions.cshl_active := form.cb_cshelper_listener.Checked;
    PlayerOptions.cshl_port := StrToInt(form.txt_cshelper_listener_port.Text);
    frm_cshelper_ctrl.update(PlayerOptions.cshl_port, PlayerOptions.cshl_active);

    ODataBase.SaveUserOptions;

  end;
  Form.free;
end;

procedure TFRM_Main.ODB_UniTree_ReportChanged(Sender: TObject; Pos: TPlanetPosition);
var nr: Integer;
begin
  nr := ODataBase.UniTree.UniReport(pos);
  if (soAddNewScanToList in Einstellungen)and(nr >= 0)and
     (
      (ODataBase.MaxTimeToAdd = 0)or
      (now-UnixToDateTime(ODataBase.Berichte[nr].Head.Time_u) < ODataBase.MaxTimeToAdd)
      ) then
    FRM_Favoriten.Add(Pos);

  ODB_UniTree_SolSysChanged(Sender,Pos);

  //Aktualisiere EigeneScan-Liste:
  if (SamePlanet(Pos, Frame_Bericht1.Bericht.Head.Position)) then
  begin
    ShowScan(pos);
  end;
end;

procedure TFRM_Main.RefreshExplorers(P: TPlanetPosition);
var i: integer;
begin
  for i := 0 to length(Explorer)-1 do
    if explorer[i].Visible = true then
      explorer[i].NewSysAtPos(P);
      
  if DockExplorer <> nil then
    DockExplorer.NewSysAtPos(P);
end;

procedure TFRM_Main.ODB_UniTree_SolSysChanged(Sender: TObject;
  Pos: TPlanetPosition);
begin
  RefreshDBListSize(Self);
  RefreshExplorers(Pos);
end;

procedure TFRM_Main.Frame_Bericht1Copy1Click(Sender: TObject);
begin
  Frame_Bericht1.Copy1Click(Sender);
end;

procedure TFRM_Main.Frame_Bericht1KopiereinTabellenform1Click(
  Sender: TObject);
begin
  Frame_Bericht1.KopiereinTabellenform1Click(Sender);
end;

procedure TFRM_Main.P_WFResize(Sender: TObject);
begin
  LBL_WF_1.Left := LBL_WF_0_1.Left + LBL_WF_0_1.Width;
  LBL_WF_1.Width := (P_WF.ClientWidth - LBL_WF_0_1.Left - LBL_WF_0_1.Width)div 3;
  LBL_WF_2.Left := LBL_WF_1.Left + LBL_WF_1.Width;
  LBL_WF_2.Width := LBL_WF_1.Width;
  LBL_WF_3.Left := LBL_WF_2.Left + LBL_WF_2.Width;
  LBL_WF_3.Width := P_WF.ClientWidth - LBL_WF_3.Left-2;
end;

procedure TFRM_Main.PaintScan(scan: TScanBericht; save: TScanGroup = sg_Forschung);
var gpi: PPlayerInformation;
begin
  Frame_Bericht1.SetBericht(Scan, save);

  p_startscreen.Visible := False;
  if P_Scan.Visible = false then
  begin
    ShowScanPanel;
  end;

  //Suche Forschungen:
  with Frame_Bericht1.Bericht do
  if (Bericht[sg_Forschung,0] = -1) then
  begin
    gpi := ODataBase.UniTree.Player.GetPlayerInfo(Head.Spieler);
    if (gpi <> nil)and(gpi^.ResearchTime_u <> 0) then
    begin
      Frame_Bericht1.Add_PlayerInfo(gpi^);
    end;
  end;
  Frame_Bericht1.Report_Refresh;
  Wellenangriff(Frame_Bericht1.Bericht);
end;

procedure TFRM_Main.phpSync1Click(Sender: TObject);
begin
  frm_sync_cS_db_engine.show();
end;

procedure TFRM_Main.BTN_UniversumClick(Sender: TObject);
begin
  FRM_Uebersicht.Show;
end;

function TFRM_Main.NewSearch: TFRM_Suche;
begin
  Result := TFRM_Suche.Create(Self);
  fSearchWindows.Add(Result);
  Result.Show;
end;

procedure TFRM_Main.BTN_SucheClick(Sender: TObject);
begin
  NewSearch;
end;

procedure TFRM_Main.BTN_ListeClick(Sender: TObject);
begin
  FRM_Favoriten.show;
end;

procedure TFRM_Main.btn_nextClick(Sender: TObject);
var pos: TPlanetPosition;
begin
  if mLatestPlanetListSource <> nil then
  begin
    if mLatestPlanetListSource.selectNextPlanet(pos) then
      simplyShowScan(pos);
  end;
end;

procedure TFRM_Main.ShowGalaxie(pos: TPlanetPosition);
begin
  DockExplorer.Initialise(Pos);
  ShowExplorerPanel;
  BringToFront;
end;

procedure TFRM_Main.ShowSmallScan(P: TPlanetPosition);
var i: integer;
    gpi: PPlayerInformation;
    gen_report: TScanBericht;
    save: TScanGroup;
begin
  gen_report := TScanBericht.Create;
  try
    i := ODataBase.UniTree.UniReport(P);
    if (i >= 0) then
    begin
      P_ExplorerDockResize(self);
      save := ODataBase.UniTree.genericReport(P, gen_report);
      Frame_Bericht2.SetBericht(gen_report, save);
      with Frame_Bericht2.Bericht do
        if (Bericht[sg_Forschung,0] = -1) then
        begin
          gpi := ODataBase.UniTree.Player.GetPlayerInfo(Head.Spieler);
          if (gpi <> nil) and (gpi^.ResearchTime_u <> 0) then
          begin
            Frame_Bericht2.Add_PlayerInfo(gpi^);
          end;
        end;
      Frame_Bericht2.Report_Refresh;
    end
    else
    begin
      Frame_Bericht2.Clear;
    end;
  finally
    gen_report.Free;
  end;
end;

procedure TFRM_Main.Spionage1Click(Sender: TObject);
begin
  ODataBase.LanguagePlugIn.directCallFleet(
    Frame_Bericht1.Bericht.Head.Position, fet_espionage);
end;

procedure TFRM_Main.OpenInBrowser(url: String);
var TSI: TStartupInfo;
    TPI: TProcessInformation;
const X = 0;
      Y = 0;
      Xs = 500;
      Ys = 500;
begin
  FillChar(TSI,sizeof(TSI),0);
  TSI.dwX := X;
  TSI.dwY := Y;
  TSI.dwXSize := Xs;
  TSI.dwYSize := Ys;
  TSI.dwFlags := STARTF_USEPOSITION or STARTF_USESIZE;
  CreateProcess(nil,PCHAR(url),nil,nil,False,NORMAL_PRIORITY_CLASS,nil,nil,TSI,TPI);
end;

procedure TFRM_Main.Wellenangriff(Scan: TScanbericht);
var Ress,TR_Transporter,TR_Schlachtschiff: integer;
{$IFDEF spacepioneers} Ress2: integer; {$ENDIF}
    WBRec_Schl: TWBRec;
    WBRec_Trans: TWBRec;
begin
  Ress := Frame_Bericht1.Bericht.Bericht[sg_Rohstoffe,0]+
          Frame_Bericht1.Bericht.Bericht[sg_Rohstoffe,1]+
          Frame_Bericht1.Bericht.Bericht[sg_Rohstoffe,2];
  {$IFNDEF spacepioneers}
  if PlayerOptions.AngriffsLogig = al_Drago then
  begin
    WBRec_Schl.Scan := Scan;
    WBRec_Schl.StartPlanet := PlayerOptions.StartPlanet;
    WBRec_Schl.ZielPlanet := Scan.Head.Position;
    WBRec_Schl.Ship := PlayerOptions.Schlachtschiff;
    WBRec_Trans := WBRec_Schl;
    WBRec_Trans.Ship := PlayerOptions.Transporter;

    Ress := Ress div 2;
    LBL_WF_1.Caption := FloatToStrF(Ress,ffNumber,60000000,0) + #10 + #13 +
                        IntToStr(CalcDragoShips(WBRec_Schl,1)) + #10 + #13 +
                        IntToStr(CalcDragoShips(WBRec_Trans,1));
    Ress := Ress div 2;
    LBL_WF_2.Caption := FloatToStrF(Ress,ffNumber,60000000,0) + #10 + #13 +
                        IntToStr(CalcDragoShips(WBRec_Schl,2)) + #10 + #13 +
                        IntToStr(CalcDragoShips(WBRec_Trans,2));
    Ress := Ress div 2;
    LBL_WF_3.Caption := FloatToStrF(Ress,ffNumber,60000000,0) + #10 + #13 +
                        IntToStr(CalcDragoShips(WBRec_Schl,3)) + #10 + #13 +
                        IntToStr(CalcDragoShips(WBRec_Trans,3));
  end
  else
  begin
    Ress := Ress div 2;
    TR_Transporter := 0;
    TR_Schlachtschiff := 0;
    LBL_WF_1.Caption := FloatToStrF(Ress,ffNumber,60000000,0) + #10 + #13 +
                        IntToStr(ceil(Ress / (PlayerOptions.Schlachtschiff.space-TR_Schlachtschiff))) + #10 + #13 +
                        IntToStr(ceil(Ress / (PlayerOptions.Transporter.space-TR_Transporter)));
    Ress := Ress div 2;
    LBL_WF_2.Caption := FloatToStrF(Ress,ffNumber,60000000,0) + #10 + #13 +
                        IntToStr(ceil(Ress / (PlayerOptions.Schlachtschiff.space-TR_Schlachtschiff))) + #10 + #13 +
                        IntToStr(ceil(Ress / (PlayerOptions.Transporter.space-TR_Transporter)));
    Ress := Ress div 2;
    LBL_WF_3.Caption := FloatToStrF(Ress,ffNumber,60000000,0) + #10 + #13 +
                        IntToStr(ceil(Ress / (PlayerOptions.Schlachtschiff.space-TR_Schlachtschiff))) + #10 + #13 +
                        IntToStr(ceil(Ress / (PlayerOptions.Transporter.space-TR_Transporter)));
  end;
  {$ELSE}
  Ress2 := Ress;
  Ress := Ress div 2;

  LBL_WF_1.Caption := IntToStrKP(Ress) + ' / ' + IntToStrKP(trunc(Ress2*0.6)) + #10 + #13 +
                      IntToStr(ceil(Ress / (PlayerOptions.Schlachtschiff.space))) + ' / ' + IntToStr(ceil((Ress2*0.6) / (PlayerOptions.Schlachtschiff.space))) + #10 + #13 +
                      IntToStr(ceil(Ress / (PlayerOptions.Transporter.space))) + ' / ' + IntToStr(ceil((Ress2*0.6) / (PlayerOptions.Transporter.space)));

  Ress2 := Ress2 - trunc(Ress2 * 0.6);
  Ress := Ress div 2;

  LBL_WF_2.Caption := IntToStrKP(Ress) + ' / ' + IntToStrKP(trunc(Ress2*0.6)) + #10 + #13 +
                      IntToStr(ceil(Ress / (PlayerOptions.Schlachtschiff.space))) + ' / ' + IntToStr(ceil((Ress2*0.6) / (PlayerOptions.Schlachtschiff.space))) + #10 + #13 +
                      IntToStr(ceil(Ress / (PlayerOptions.Transporter.space))) + ' / ' + IntToStr(ceil((Ress2*0.6) / (PlayerOptions.Transporter.space)));

  Ress2 := Ress2 - trunc(Ress2 * 0.6);
  Ress := Ress div 2;

  LBL_WF_3.Caption := IntToStrKP(Ress) + ' / ' + IntToStrKP(trunc(Ress2*0.6)) + #10 + #13 +
                      IntToStr(ceil(Ress / (PlayerOptions.Schlachtschiff.space))) + ' / ' + IntToStr(ceil((Ress2*0.6) / (PlayerOptions.Schlachtschiff.space))) + #10 + #13 +
                      IntToStr(ceil(Ress / (PlayerOptions.Transporter.space))) + ' / ' + IntToStr(ceil((Ress2*0.6) / (PlayerOptions.Transporter.space)));
  {$ENDIF}
end;

procedure TFRM_Main.BTN_TopmostClick(Sender: TObject);
begin
  topmost := not topmost;

  {if BTN_Topmost.Down then
    FormStyle := fsStayOnTop
  else
    FormStyle := fsNormal;} //alt (hatt manchmal komische probleme mit Kernel.dll gemacht (erst nach winXP-themeunterstützung)
  if topmost
    then SetWindowPos(Handle,HWND_TOPMOST,0,0,0,0,SWP_NOMOVE OR SWP_NOSIZE)
    else SetWindowPos(Handle,HWND_NOTOPMOST,0,0,0,0,SWP_NOMOVE OR SWP_NOSIZE);

  if topmost
    then StatusBar1.Panels[0].Text := STR_topmost
    else StatusBar1.Panels[0].Text := STR_normal;
end;

procedure TFRM_Main.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  if P_Scan.Visible then
    Frame_Bericht1.OnMouseWheel(Sender,Shift,WheelDelta,MousePos,Handled)
  else Frame_Bericht2.OnMouseWheel(Sender,Shift,WheelDelta,MousePos,Handled);
end;

procedure TFRM_Main.updatecheck1Click(Sender: TObject);
var aktuell: string;
begin
  aktuell := CheckNewestVersion;
  if (aktuell <= VNumber)and(aktuell <> '') then
    ShowMessage(STR_MSG_Aktuellste_Version)
  else
    if aktuell <> '' then
    begin
      if Application.MessageBox(PCHar(STR_MSG_aktuellere_Version + aktuell + #13 + #10 + STR_ASK_Homepage_oeffnen),PChar(STR_Neue_Version),MB_YESNO or MB_ICONQUESTION) = idYes then
      begin
        ShellExecute(Self.Handle,'open',PChar('http://www.creatureScan.creax.de'),'','',0);
      end;
    end
    else
      ShowMessage(STR_MSG_konnte_aktuellste_Version_nicht_ermitteln);

  if frm_quickupdate.getUpdates then
  begin
    if Application.MessageBox(
         PCHar('Es gibt QuickUpdates, soll der Updatedialog geöffnet werden?'),
           'Quick Updates',MB_YESNO or MB_ICONQUESTION) = idYes then
    begin
      frm_quickupdate.ShowModal;
    end;
  end;
end;

procedure TFRM_Main.TIM_StartTimer(Sender: TObject);
var Version: String;
//    OldFile: String;
begin
  TIM_Start.Enabled := False;

  (* Wird hoffentlich nicht mehr benötigt!!!
  //Alte Scandatei importieren
  OldFile := ODataBase.SaveDir + inttostr(ODataBase.LangIndex) + '_Spioarchiv' + IntToStr(ODataBase.UserUni) + '.csscan.old';
  if FileExists(OldFile) then
  begin
    ODataBase.ImportFile(OldFile);
    if Application.MessageBox(PChar(STR_ScanImportFertig_loeschn),'cS Import',MB_YESNO) = idYes then
      DeleteFile(OldFile)
    else RenameFile(OldFile,OldFile+'.csscan');
  end;
  //Alte Sysdatei Importieren
  OldFile := ODataBase.SaveDir + Inttostr(ODataBase.LangIndex) + '_Universum' + IntToStr(ODataBase.UserUni) + '.cssys.old';
  if FileExists(OldFile) then
  begin
    ODataBase.ImportFile(OldFile);
    if Application.MessageBox(PChar(STR_SysImportFertig_loeschn),'cS Import',MB_YESNO) = idYes then
      DeleteFile(OldFile)
    else RenameFile(OldFile,OldFile+'.cssys');
  end; *)

  if soAutoUpdateCheck in Einstellungen then
  begin
    Version := CheckNewestVersion;
    if (Version <> '')and(Version > VNumber) then
      if Application.MessageBox(PCHar(STR_MSG_aktuellere_Version + Version + #13 + #10 + STR_ASK_Homepage_oeffnen),PChar(STR_Neue_Version),MB_YESNO or MB_ICONQUESTION) = idYes then
      begin
        callLink('http://www.creatureScan.creax.de');
      end;
  end;
  if (soStartupServer in Einstellungen) then
  begin
    FRM_Connections.SpinEdit1.Value := PlayerOptions.ServerPort;
    FRM_Connections.CheckBox1.Checked := True;
  end;

  if (PlayerOptions.StartSystray) then
  begin
    //siehe CloseQuery!
    DockExplorer.Hide;
    Hide;
  end;

  // start cshl_server
  frm_cshelper_ctrl.update(PlayerOptions.cshl_port, PlayerOptions.cshl_active);
end;

procedure TFRM_Main.Zwischenablageberwachen1Click(Sender: TObject);
begin
  Zwischenablageberwachen1.Checked := not Zwischenablageberwachen1.Checked;
  CVActive := Zwischenablageberwachen1.Checked;
end;

procedure TFRM_Main.SetCVActive(B: Boolean);
begin
  inherited;
  SetTrayIcon_();
end;

procedure TFRM_Main.setPlanetListSource(list: TPlanetListInterface);
var available: Boolean;
begin
  if fLatestPlanetListSource <> nil then
    fLatestPlanetListSource.RemoveFreeNotification(self);

  fLatestPlanetListSource := list;
  available := list <> nil;
  if available then
    list.FreeNotification(self);

  btn_next.Enabled := available;
  btn_last.Enabled := available;
  nchstenAuswhlen1.Enabled := available;
  vorherigenauswhlen1.Enabled := available;
end;

procedure TFRM_Main.SetTrayIcon_;
begin  //aktualisiert das TrayIcon
  if CVActive then
    TrayIco.Icon := ico_active.Picture.Icon
  else TrayIco.Icon := ico_inactive.Picture.Icon;
end;

procedure TFRM_Main.SuchenErsetzen1Click(Sender: TObject);
begin
  FRM_Suchen_Ersetzen.Show;
end;

procedure TFRM_Main.Languagefile1Click(Sender: TObject);
begin
  LanguageFile(ExtractFilePath(Application.ExeName)+'Lang\de_muster.cSlgn');
end;

function TFRM_Main.RaidDialog(var Fleet: TFleetEvent): boolean;
var form: TFRM_Add_Raid;
begin
  form := TFRM_Add_Raid.Create(self);
  try
    form.Fleet := Fleet;
    if Fleet.head.arrival_time_u = -1 then
      form.ResetTime(PlayerOptions.Flugzeit_u);

    Result := form.ShowModal = mrOK;
    if Result then
    begin
      Fleet := form.Fleet;
      Fleet.head.unique_id := -3; // "Selbstgemacht" (Per hand eingegeben")
    end;
  finally
    form.Free;
  end;
end;

procedure TFRM_Main.RaidDialog(Position: TPlanetPosition);
var SB: TScanBericht;
    rd: TFleetEvent;
     g, i: Integer;
begin
  if not ValidPosition(Position) then
    exit;

  fillchar(rd,sizeof(rd),0);

  rd.head.eventtype := fet_attack;
  rd.head.origin := PlayerOptions.StartPlanet;
  rd.head.target := Position;

  g := ODataBase.UniTree.UniReport(Position);
  if g >= 0 then
  begin
    SB := ODataBase.Berichte[g];
//    if length(SB.Bericht[sg_Rohstoffe]) = 4 then
    begin
      SetLength(rd.ress,3);
      for i := 0 to 2 do
        rd.ress[i] := SB.Bericht[sg_Rohstoffe,i] div 2;
    end;
  end
  else
  begin
    // Trotzdem muss des Ress-Array gefüllt werden:
    SetLength(rd.ress,3);
    for i := 0 to 2 do
      rd.ress[i] := 0;
  end;

  rd.head.arrival_time_u := -1; //siehe überladene Funktion

  if RaidDialog(rd) then
  begin
    ODataBase.FleetBoard.AddFleet(rd);
  end;
end;

procedure TFRM_Main.Raideintragen1Click(Sender: TObject);
begin
  RaidDialog(Frame_Bericht1.Bericht.Head.Position);
end;

procedure TFRM_Main.Scanslschen1Click(Sender: TObject);
begin
  FRM_Delete_Scans.Show;
end;

procedure TFRM_Main.SucheImInet(Typ: TSuchInetTyp; Allianz, Player: String;
  Uni: String);
var s: string;
procedure SetzePlatzhalter(var Line: String; Variable, Wert: string);
var i: integer;
begin
  i := pos(Variable,s);
  if i > 0 then
  begin
    s := copy(s,1,i-1) + Wert + copy(s,i+length(Variable),length(s)-i);
  end;
end;
begin
  case Typ of
    sitPlayer: s := PlayerOptions.SuchInet.Spieler;
    sitAllanz: s := PlayerOptions.SuchInet.Allianz;
  else s := '';
  end;
  SetzePlatzhalter(s,'%P',Player);
  SetzePlatzhalter(s,'%A',Allianz);
  SetzePlatzhalter(s,'%U',Uni);
  ShellExecute(Self.Handle,'open',PChar(s),'','',0);
end;

procedure TFRM_Main.LoadOptions;
var ini: TIniFile;
begin
  ini := TIniFile.Create(IniFile);
  Dir.Visible := ini.ReadBool(GeneralSection,'ShowDirButton',False);
  Test1.Visible := Dir.Visible;
  Einstellungen := [];
  if ini.ReadBool(GeneralSection,'AddNewScanToList',true) then include(Einstellungen,soAddNewScanToList);
  if ini.ReadBool(GeneralSection,'ShowScanCountMessage',false) then include(Einstellungen,soShowScanCountMessage);
  if ini.ReadBool(GeneralSection,'BeepByWatchClipboard',true) then include(Einstellungen,soBeepByWatchClipboard);
  if ini.readBool(GeneralSection,'soUniCheck',false) then include(Einstellungen,soUniCheck);
  if ini.ReadBool(GeneralSection,'soStartupServer',false) then include(Einstellungen,soStartupServer);
  CVActive := ini.ReadBool(GeneralSection,'WatchClipboard',true);
  PlayerOptions.ServerPort := ini.ReadInteger(GeneralSection,'StartupServerPort',44456);

  LBL_WF_0_2.Caption := ini.ReadString(GeneralSection,'Schlachtschiff_Name',LBL_WF_0_2.Caption);
  LBL_WF_0_3.Caption := ini.ReadString(GeneralSection,'Transporter_Name',LBL_WF_0_3.Caption);

  PlayerOptions.Transporter.space := ini.ReadInteger(GeneralSection,'Transporter_space',Transporter_space);
  PlayerOptions.Transporter.oil := ini.ReadInteger(GeneralSection,'Transporter_oil',Transporter_oil);
  PlayerOptions.Schlachtschiff.space := ini.ReadInteger(GeneralSection,'Schlachtschiff_space',Schlachtschiff_space);
  PlayerOptions.Schlachtschiff.oil := ini.ReadInteger(GeneralSection,'Schlachtschiff_oil',Schlachtschiff_oil);

  PlayerOptions.StartPlanet := StrToPosition(ini.ReadString(GeneralSection,'RaidPlanet',PositionToStrMond(ODataBase.UserPosition)));
  PlayerOptions.Flugzeit_u := StrToInt64Def(ini.ReadString(GeneralSection,'Flugzeit',''),60*50);
  PlayerOptions.AngriffsLogig := TAngriffslogig(ini.ReadInteger(GeneralSection,'AngriffsLogig',0));
  if ini.ReadBool(GeneralSection,'AutoUpdateCheck',True) then include(Einstellungen,soAutoUpdateCheck);
  CloseToSystray := ini.ReadBool(GeneralSection,'CloseToSysTray',True);
  PlayerOptions.SuchInet.Name := ini.ReadString(GeneralSection,'Suche_Name','ostat.de');
  PlayerOptions.SuchInet.Spieler := ini.ReadString(GeneralSection,'Suche_Spieler','http://uni%U.ostat.de/index.php?ext=player&name=%P');
  PlayerOptions.SuchInet.Allianz := ini.ReadString(GeneralSection,'Suche_Allianz','http://uni%U.ostat.de/index.php?ext=allyueber&name=%A');

  PlayerOptions.phpPost := ini.ReadString(GeneralSection,'phpPOSTAdrs','');

  //Fake ClipboadViewer (für Linux/Wine)
  TIM_FakeCV.Enabled := ini.ReadBool(GeneralSection, 'FakeCVEnabled', TIM_FakeCV.Enabled);
  TIM_FakeCV.Interval := ini.ReadInteger(GeneralSection, 'FakeCVInterval', TIM_FakeCV.Interval);

  //Start im Hintergrund (minimze to systray at start)
  PlayerOptions.StartSystray := ini.ReadBool(GeneralSection, 'StartSystray', false);

  SaveLoad_SimpleOptions(ini,false);

  Frame_Bericht1.LoadOptions(ini);
  Frame_Bericht2.LoadOptions(ini);

  explorer_load(ini); //generelle explorer-einstellungen

  ini.Free;
end;

procedure TFRM_Main.SaveOptions;
var ini: TIniFile;
begin
  SaveFormSizePos(IniFile,self);

  ini := TIniFile.Create(IniFile);

  ini.WriteBool(GeneralSection,'AddNewScanToList',soAddNewScanToList in Einstellungen);
  ini.WriteBool(GeneralSection,'ShowScanCountMessage',soShowScanCountMessage in Einstellungen);
  ini.WriteBool(GeneralSection,'BeepByWatchClipboard',soBeepByWatchClipboard in Einstellungen);
  ini.WriteBool(GeneralSection,'soUniCheck',soUniCheck in Einstellungen);
  ini.WriteBool(GeneralSection,'AutoUpdateCheck',soAutoUpdateCheck in Einstellungen);
  ini.WriteBool(GeneralSection,'CloseToSysTray',CloseToSystray);
  ini.WriteBool(GeneralSection,'WatchClipboard',CVActive);
  ini.WriteBool(GeneralSection,'soStartupServer',soStartupServer in Einstellungen);

  ini.WriteString(GeneralSection,'Schlachtschiff_Name',LBL_WF_0_2.Caption);
  ini.WriteString(GeneralSection,'Transporter_Name',LBL_WF_0_3.Caption);

  ini.WriteInteger(GeneralSection,'StartupServerPort',PlayerOptions.ServerPort);
  ini.WriteInteger(GeneralSection,'Transporter_space',PlayerOptions.Transporter.space);
  ini.WriteInteger(GeneralSection,'Transporter_oil',PlayerOptions.Transporter.oil);
  ini.WriteInteger(GeneralSection,'Schlachtschiff_space',PlayerOptions.Schlachtschiff.space);
  ini.WriteInteger(GeneralSection,'Schlachtschiff_oil',PlayerOptions.Schlachtschiff.oil);

  ini.WriteString(GeneralSection,'RaidPlanet',PositionToStrMond(PlayerOptions.StartPlanet));
  ini.WriteString(GeneralSection,'Flugzeit',IntToStr(PlayerOptions.Flugzeit_u));
  ini.WriteInteger(GeneralSection,'AngriffsLogig',integer(PlayerOptions.AngriffsLogig));
  ini.WriteString(GeneralSection,'Suche_Name',PlayerOptions.SuchInet.Name);
  ini.WriteString(GeneralSection,'Suche_Spieler',PlayerOptions.SuchInet.Spieler);
  ini.WriteString(GeneralSection,'Suche_Allianz',PlayerOptions.SuchInet.Allianz);

  ini.WriteString(GeneralSection,'phpPOSTAdrs',PlayerOptions.phpPost);

  //Fake ClipboadViewer (für Linux/Wine)
  ini.WriteBool(GeneralSection, 'FakeCVEnabled', TIM_FakeCV.Enabled);
  ini.WriteInteger(GeneralSection, 'FakeCVInterval', TIM_FakeCV.Interval);

  //Start im Hintergrund (minimze to systray at start)
  ini.WriteBool(GeneralSection, 'StartSystray', PlayerOptions.StartSystray);

  SaveLoad_SimpleOptions(ini,true);

  Frame_Bericht1.SaveOptions(ini);
  Frame_Bericht2.SaveOptions(ini);

  explorer_save(ini); //generelle explorer-einstellungen

  ini.UpdateFile;
  ini.free;
end;

procedure TFRM_Main.Einlesen1Click(Sender: TObject);
var dialog: TFRM_Stats_Einlesen;
begin
  dialog := TFRM_Stats_Einlesen.Create(Self);
  try

    dialog.TXT_punkte.Text := IntToStrKP(ODataBase.Stats_own);
    dialog.TXT_fleet.Text := IntToStrKP(ODataBase.FleetStats_own);
    dialog.TXT_Ally.Text := IntToStrKP(ODataBase.AllyStats_own);

    if dialog.ShowModal = mrOK then
    begin
      ODataBase.Stats_own := ReadInt(dialog.TXT_punkte.Text, 1);
      ODataBase.FleetStats_own := ReadInt(dialog.TXT_fleet.Text, 1);
      ODataBase.AllyStats_own := ReadInt(dialog.TXT_Ally.Text, 1);
    end;
    
  finally
    dialog.free;
  end;
end;

procedure TFRM_Main.FormClipboardContentChanged(Sender: TObject);
begin
  TIM_afterClipboardchange.Enabled := True;
end;

procedure TFRM_Main.NetConnections1Click(Sender: TObject);
begin
  FRM_Connections.show;
end;

procedure TFRM_Main.Angriff1Click(Sender: TObject);
begin
  ODataBase.LanguagePlugIn.CallFleet_(
    Frame_Bericht1.Bericht.Head.Position, fet_attack);
end;

procedure TFRM_Main.ApplicationEvents1Message(var Msg: tagMSG;
  var Handled: Boolean);
var key: word;
begin
  if Msg.message = WM_MOUSESpezialKeyUp then
  begin
    key := integer('W');
    if (Msg.WParam and svk_back) > 0 then
      KeyDown(key,[]);
    {if (message.WParam and svk_forward) > 0 then
      Label1.Caption := 'vor up';}
  end;
end;

procedure TFRM_Main.intelligentReadData(const text, html: string);
var handle: integer;
begin
  handle := ODataBase.LanguagePlugIn.ReadSource_New();
  try

    ODataBase.LanguagePlugIn.SetReadSourceText(handle,
      text, ODataBase.FleetBoard.GameTime.UnixTime);
    ODataBase.LanguagePlugIn.SetReadSourceHTML(handle,
      html, ODataBase.FleetBoard.GameTime.UnixTime);

    if
       (
         (not(soUniCheck in Einstellungen))or
         (ODataBase.LanguagePlugIn.CheckClipboardUni(handle))
       )
       then
    begin
      if (ODataBase.LeseMehrereScanberichte(handle) > 0)or
         (ODataBase.LeseSystem(handle))or
         (ODataBase.LeseStats(handle))or
         (ODataBase.LeseFleets(handle)) then
      begin
        //Erfolgreich Eingelesen
        if soBeepByWatchClipboard in Einstellungen then
          Play_Alert_Sound(PlayerOptions.Beep_SoundFile);
      end;
    end;

  finally
    ODataBase.LanguagePlugIn.ReadSource_Free(handle);
  end;
end;

procedure TFRM_Main.TIM_afterClipboardchangeTimer(Sender: TObject);
var Text, Html: string;
    i: integer;
begin
  TIM_afterClipboardchange.Enabled := False;

  i := 0;
  while (i < 10)and(not OpenClipboard) do
  begin
    sleep(20);
    inc(i);
  end;
  if i >= 10 then Exit;
  
  try
    Html := GetClipboardHtml;
    if ClipboardHasText then
      Text := GetClipboardText
    else
    begin
      Text := '';
    end;
  finally
    CloseClipboard;
  end;

  if ((Text <> LastClipBoard)) then
  begin
    intelligentReadData(text, html);
  end;
end;

procedure TFRM_Main.TrayIconPopupPopup(Sender: TObject);
begin
  Zwischenablageberwachen1.Checked := CVActive;
end;

procedure TFRM_Main.lst_othersKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = VK_DELETE then
  begin
    BTN_DeleteClick(self);
  end;
end;

procedure TFRM_Main.NewScan1Click(Sender: TObject);
var FRM: TFRM_EditScan;
    scan: TScanBericht;
begin
  scan := TScanBericht.Create;
  FRM := TFRM_EditScan.Create(self);
  try
    If FRM.ShowModal = idOK then
    begin
      FRM.GetScan(scan);
      ODataBase.UniTree.AddNewReport(scan); // copy
    end;
  finally
    FRM.Free;
    scan.Free;
  end;
end;

procedure TFRM_Main.VergelicheSysDateimitDB1Click(Sender: TObject);
var sysfile: TcSSolSysDBFile;
    sys: TSystemCopy;
    i, s: integer;
    m: string;
    FRM: TFRM_StringlistEdit;
begin
  OpenDialog1.FileName := 'SolsysDB';
  if OpenDialog1.Execute then
  begin
    // You better use TcSSolSysDBFile!!!
    sysfile := TcSSolSysDBFile.Create(OpenDialog1.FileName);
    FRM := TFRM_StringlistEdit.Create(self);
    FRM.Show;

    //if sysfile.Universe <> ODataBase.UserUni then // TODO
    //  FRM.Memo1.Lines.Add('Universe: ' + IntToStr(sysfile.Universe));

    for i := 0 to sysfile.Count-1 do
    begin
      sys := sysfile.SolSys[i];
      s := ODataBase.Uni[sys.System.P[0],sys.System.P[1]].SystemCopy;
      if s >= 0 then
        m := CompareSys(sys,ODataBase.Systeme[s])
      else m := ('Sys nicht vorhanden: ' + PositionToStr_(sys.System));

      if m <> '' then FRM.Memo1.Lines.Add(m);
    end;
    sysfile.Free;
    FRM.Memo1.Lines.Add('Fertig!');
  end;
end;

procedure TFRM_Main.writeunitsinconstsxml1Click(Sender: TObject);
{function FindOrAddNode(ParentNode: IXMLNode; name: String): IXMLNode;
begin
  Result := ParentNode.ChildNodes.FindNode(name);
  if Result = nil then
    Result := ParentNode.AddChild(name);
end;
var j: integer;
    sg: TScanGroup;
    unitsNode, groupNode, node: IXMLNode;}
begin
  {XMLDocument1.Active := false;
  XMLDocument1.XML.Text := '<?xml version="1.0" encoding="UTF-8"?><data></data>';

  if FileExists('consts.xml') then
    XMLDocument1.LoadFromFile('consts.xml');

  XMLDocument1.Active := True;

  unitsNode := FindOrAddNode(XMLDocument1.DocumentElement,'units');
  unitsNode.Attributes['groupcount'] := SF_Group_Count;
  for sg := low(sg) to high(sg) do
  begin
    groupNode := FindOrAddNode(unitsNode,'group' + IntToStr(Integer(sg)));
    groupNode.Attributes['count'] := scanfilecounts[sg];
    groupNode.Attributes['xml'] := xspio_idents[sg,0];
    for j := 0 to ScanFileCounts[sg]-1 do
    begin
      node := FindOrAddNode(groupNode,'unit' + IntToStr(j));
      node.Attributes['xml'] := xspio_idents[sg,j+1];
    end;
  end;
  XMLDocument1.SaveToFile('consts.xml');         }
end;

procedure TFRM_Main.VergleicheScanDateimitDB1Click(Sender: TObject);
var ScanFile: TcSReportDBFile;
    FRM: TFRM_StringlistEdit;
    i, j: integer;
    Scan: TScanBericht;
    found: Boolean;
    m: string;
begin
  OpenDialog1.FileName := 'ScanDB';
  If OpenDialog1.Execute then
  begin
    // You better use TcSReportDBFile!!!
    ScanFile := TcSReportDBFile.Create(OpenDialog1.FileName);
    FRM := TFRM_StringlistEdit.Create(self);
    FRM.Show;

//      if ScanFile.Universe <> ODataBase.UserUni then // TODO
 //   FRM.Memo1.Lines.Add('Universe: ' + IntToStr(ScanFile.Universe));

    for i := 0 to Scanfile.Count-1 do
    begin
      Scan := ScanFile.Reports[i];
      found := False;
      m := '';
      for j := 0 to ODataBase.Berichte.Count-1 do
        if SamePlanet(ODataBase.Berichte[j].Head.Position,Scan.Head.Position)and
                     (ODataBase.Berichte[j].Head.Time_u = Scan.Head.Time_u) then
        begin
          found := true;
          m := CompareScans(Scan, ODataBase.Berichte[j]);
          break;
        end;

      if not found then m := ' Nicht gefunden!';

      if m <> '' then
      begin
        m := PositionToStrMond(Scan.Head.Position) + m;
        FRM.Memo1.Lines.Add(m);
      end;
    end;
    ScanFile.Free;
    FRM.Memo1.Lines.Add('Fertig!');
  end;
end;

procedure TFRM_Main.SaveClipboardtoFile1Click(Sender: TObject);
var filename: string;
begin
  if SaveDialog1.Execute then
  begin
    filename := SaveDialog1.FileName;
    if ExtractFileExt(filename) = '' then
      filename := filename + '.bin';

    clipbrdfunctions.SaveClipboardtoFile(filename,
      ODataBase.LanguagePlugIn.PluginFilename,
      ODataBase.LanguagePlugIn.PlugInName,
      ODataBase.game_domain,
      ODataBase.UniDomain);
  end;
end;

procedure TFRM_Main.POST1Click(Sender: TObject);
begin
  FRM_POST_TEST.Show;
end;

procedure TFRM_Main.ClipbrdReadScan;
var r, handle: integer;
begin
  handle := ODataBase.LanguagePlugIn.ReadSource_New();
  try
    ODataBase.LanguagePlugIn.SetReadSourceText(handle,
      clipboard.AsText + ' ', ODataBase.FleetBoard.GameTime.UnixTime);
    r := ODataBase.LeseMehrereScanberichte(handle);
    if r > 0 then
    begin
      if soShowScanCountMessage in Einstellungen then
        ShowMessage(IntToStr(r) + ' ' + STR_Scans_gespeichert);
    end
    else
      ShowMessage(STR_konnte_keine_Scans_suslesen);
  finally
    ODataBase.LanguagePlugIn.ReadSource_Free(handle);
  end;
end;

procedure TFRM_Main.ClipbrdReadSys;
var handle: integer;
begin
  handle := ODataBase.LanguagePlugIn.ReadSource_New();
  try
    ODataBase.LanguagePlugIn.SetReadSourceText(handle,
      GetClipboardText, ODataBase.FleetBoard.GameTime.UnixTime);
    ODataBase.LanguagePlugIn.SetReadSourceHTML(handle,
      GetClipboardHtml, ODataBase.FleetBoard.GameTime.UnixTime);
    ODataBase.LeseSystem(handle);
  finally
    ODataBase.LanguagePlugIn.ReadSource_Free(handle);
  end;
end;

procedure TFRM_Main.TIM_FakeCVTimer(Sender: TObject);
var nsn: DWORD;
begin
  nsn := GetClipboardSequenceNumber;
  if (nsn <> FakeCVClipbrdSequenceNumber)and CVActive then
    TIM_afterClipboardchange.Enabled := True;
  FakeCVClipbrdSequenceNumber := nsn;
end;

procedure TFRM_Main.Frame_Bericht1Timer1Timer(Sender: TObject);
begin
  Frame_Bericht1.tim_next_fleetTimer(Sender);
  Wellenangriff(Frame_Bericht1.Bericht);
end;

procedure TFRM_Main.Timer1Timer(Sender: TObject);
var d: Integer;

const count = 20;
begin
  if TComponent(Sender).Tag = 0 then
  begin
    _____time := now;
    _____mittelwehrt := 1;
    TComponent(Sender).Tag := 1;
  end;

  d := Trunc((now-_____time)*24*60*60*1000);

  if d < 10 then
  begin
    //zu kurze zeiten nicht werten!
    exit;
  end;

  _____mittelwehrt := trunc(((_____mittelwehrt*count) + d)/(count+1));

  StatusBar1.Panels[1].Text := IntToStr(_____mittelwehrt);//  IntToStr(d);
  _____time := Now;
end;

procedure TFRM_Main.ScansDatumLschen1Click(Sender: TObject);
var s: string;
    u_t, su_t: Int64;
    i: integer;
begin
  if InputQuery('Scans eines bestimmten Datums löschen:', 'Datum:', s) then
  begin
    u_t := DateTimeToUnix(StrToDate(s));

    for i := ODataBase.Berichte.Count-1 downto 0 do
    begin
      su_t := ODataBase.Berichte[i].Head.Time_u;
      if (su_t >= u_t)and(su_t < u_t + 60*60*24) then
        ODataBase.UniTree.DeleteReport(i);
    end;
  end;
end;


procedure TFRM_Main.Frame_Bericht1Timer2Timer(Sender: TObject);
begin
  Frame_Bericht1.Timer2Timer(Sender);

end;

function TFRM_Main.getSearchWindow(index: integer): TFRM_Suche;
begin
  Result := TFRM_Suche(fSearchWindows[index]);
end;

procedure TFRM_Main.Flottenbersicht1Click(Sender: TObject);
begin
  FRM_KB_List.Show;
end;

procedure TFRM_Main.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;

  if Operation = opRemove then
  begin

    if AComponent = mLatestPlanetListSource then
      mLatestPlanetListSource := nil;

    if AComponent is TFRM_Suche then
    begin
      fSearchWindows.Remove(AComponent);
    end;
    
  end;
end;

procedure TFRM_Main.Notizen1Click(Sender: TObject);
begin
  FRM_Notizen.Show;
end;

procedure TFRM_Main.neueSuche1Click(Sender: TObject);
begin
  NewSearch;
end;

procedure TFRM_Main.Universumsbersicht1Click(Sender: TObject);
begin
  FRM_Uebersicht.Show;
end;

procedure TFRM_Main.Listenansicht1Click(Sender: TObject);
begin
  FRM_Favoriten.show;
end;

procedure TFRM_Main.Frame_Bericht1PB_BDblClick(Sender: TObject);
begin
  BTN_GalaxieClick(Sender);
end;

procedure TFRM_Main.SaveLoad_SimpleOptions(ini: TIniFile; save: boolean);
//Diese Funktion tut beides, laden und speichern. Sie soll Tipparbeit sparen
//und schützt vor Copy-Paste Fehlern

  procedure DoOption(const Section, Ident, Default: string; var Value: String); overload;
  begin
    if save then
      ini.WriteString(Section,Ident,Value)
    else
      Value := ini.ReadString(Section,Ident,Default);
  end;

  procedure DoOption(const Section, Ident: String; Default: Boolean; var Value: Boolean); overload;
  begin
    if save then
      ini.WriteBool(Section,Ident,Value)
    else
      Value := ini.ReadBool(Section,Ident,Default);
  end;

  procedure DoOption(const Section, Ident: String; Default: Integer; var Value: Integer); overload;
  begin
    if save then
      ini.WriteInteger(Section,Ident,Value)
    else
      Value := ini.ReadInteger(Section,Ident,Default);
  end;

var i: integer;
begin
  //BeepSoundfile
  DoOption(GeneralSection,'Beep_SoundFile'           ,'.\data\read_sound.wav'   ,PlayerOptions.Beep_SoundFile);

  //Flotten:
  DoOption(GeneralSection,'fleet_ShowArivalMessage'  ,true                      ,PlayerOptions.Fleet_ShowArivalMessage);
  DoOption(GeneralSection,'fleet_AMSG_time_s'        ,240                       ,PlayerOptions.Fleet_AMSG_Time_s);
  DoOption(GeneralSection,'fleet_alert_sound'        ,true                      ,PlayerOptions.Fleet_alert);
  DoOption(GeneralSection,'fleet_alert_sound_file'   ,'.\data\3_beep.wav'       ,PlayerOptions.Fleet_Soundfile);
  DoOption(GeneralSection,'fleet_auto_time_sync'     ,false                     ,PlayerOptions.Fleet_auto_time_sync);

  // Nachfrage nach Mond:
  DoOption(GeneralSection,'check_solsys_data_askMoon',false                     ,ODataBase.check_solsys_data_before_askMoon);
  DoOption(GeneralSection,'no_moon_question'         ,false                     ,PlayerOptions.noMoonQuestion);

  //websim

  for i := 0 to 2 do
    DoOption(GeneralSection,'websim_tech_'+IntToStr(i)   ,0                     ,PlayerOptions.websim_techs[i]);
  for i := 0 to 2 do
    DoOption(GeneralSection,'websim_engine_'+IntToStr(i) ,0                     ,PlayerOptions.websim_engines[i]);

  // cshelper-listener
  DoOption(GeneralSection,'cshelper_listener_active' ,false                     ,PlayerOptions.cshl_active);
  DoOption(GeneralSection,'cshelper_listener_port'   ,32432                     ,PlayerOptions.cshl_port);

end;

procedure TFRM_Main.Play_Alert_Sound(filename: string);
begin
  if FileExists(filename) then
  begin
    FRM_Main.SoundModul.PlayFile(filename);
  end
  else
  begin
    beep;
  end;
end;


procedure TFRM_Main.ShowExplorerPanel;
begin
//  BTN_Galaxie.Caption := '&Scan';
  Galaxie1.Caption := '  <Scan>  ';

  P_Scan.Visible := false;
  P_ExplorerDock.Visible := True;  
end;

procedure TFRM_Main.ShowScanPanel;
begin
  P_Scan.Visible := true;
  P_ExplorerDock.Visible := False;

//  BTN_Galaxie.Caption := '&Galaxie';
  Galaxie1.Caption := '<Galaxie>';
end;

procedure TFRM_Main.Frame_Bericht1PB_BPaint(Sender: TObject);
begin
  Frame_Bericht1.PB_BPaint(Sender);

end;

procedure TFRM_Main.StatusBar1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var X1,X2: integer;
begin
  X1 := StatusBar1.Panels[0].Width +
        StatusBar1.Panels[1].Width +
        StatusBar1.Panels[2].Width +
        StatusBar1.Panels[3].Width;
  X2 := X1 + StatusBar1.Panels[4].Width;

  if (X > X1)and(X < X2) then
    FRM_KB_List.Show;

  if (X < StatusBar1.Panels[0].Width) then
  begin
    BTN_TopmostClick(Sender);
  end;
end;

procedure TFRM_Main.ShowSearchAlly(ally: string);
var FRM: TFRM_Suche;
begin
  FRM := FRM_Main.NewSearch;
  FRM.TXT_ally.Text := ally;
  FRM.BTN_SucheClick(self);
end;

procedure TFRM_Main.ShowSearchPlayer(name: string);
var FRM: TFRM_Suche;
begin
  FRM := FRM_Main.NewSearch;
  FRM.TXT_Player.Text := name;
  FRM.BTN_SucheClick(self);
end;

procedure TFRM_Main.ShowSearchPlayerID(id: Int64);
var FRM: TFRM_Suche;
begin
  FRM := FRM_Main.NewSearch;
  FRM.txt_playerID.Text := IntToStr(id);
  FRM.BTN_SucheClick(self);
end;

procedure TFRM_Main.Show;
begin
  if WindowState = wsMinimized then
    WindowState := wsNormal;
  inherited Show;
  Application.Restore;
  Application.BringToFront;
end;

procedure TFRM_Main.LblWikiLinkClick(Sender: TObject);
begin
  with sender as TLabel do
  begin
    callLink(Caption);
  end;
end;

procedure TFRM_Main.LangPluginOnAskMoon(Sender: TOgameDataBase;
  const Report: TScanBericht; var isMoon, Handled: Boolean);
begin
  if PlayerOptions.noMoonQuestion then
  begin
    Handled := true;  // simply add it to DB
  end
  else
  begin
    frm_report_basket.addReport(Report);
    Handled := false; // so we don't add it to DB, we do it later!
  end;
end;

procedure TFRM_Main.btn_fight_startClick(Sender: TObject);
begin
  popup_auftrag.Popup(Mouse.CursorPos.X, Mouse.CursorPos.Y);
end;

procedure callLink(url: string);
begin
  ShellExecute(0,'open',PChar(url),'','',0);
end;

procedure TFRM_Main.Forum1Click(Sender: TObject);
begin
  LblWikiLinkClick(lbl_forum_link);
end;

procedure TFRM_Main.Wiki1Click(Sender: TObject);
begin
  LblWikiLinkClick(lbl_wiki_link);
end;

procedure TFRM_Main.PostErrorReport1Click(Sender: TObject);
begin
  frm_postErrorReport.ShowModal;
end;

procedure TFRM_Main.Softupdate1Click(Sender: TObject);
begin
  frm_quickupdate.ShowModal;
end;

procedure TFRM_Main.ZwischenablagefrMondScans1Click(Sender: TObject);
begin
  frm_report_basket.Show;
end;

procedure TFRM_Main.PopupMenu1Popup(Sender: TObject);
begin
  Lschen1.Enabled := (lst_others.Selected <> nil) and
    (lst_others.Selected.SubItems[0] <> '-1');
end;

procedure TFRM_Main.Button1Click(Sender: TObject);
var url: string;

  procedure param(pname, pvalue: string); overload;
  begin
    url := url + '&' + pname + '=' + pvalue;
  end;

  procedure param(pname: string; pvalue: int64); overload;
  begin
    if pvalue = -1 then
      param(pname, 'undefined')
    else
      param(pname, IntToStr(pvalue));
  end;

  procedure param(pname: string; pvalue: boolean); overload;
  begin
    if pvalue then
      param(pname, '1')
    else
      param(pname, '0');
  end;

var scan: TScanBericht;
    i: integer;
begin
  scan := Frame_Bericht1.Bericht;
  if not ValidPosition(scan.Head.Position) then
    exit;

  // Description of params:
  // http://forum.speedsim.net/viewtopic.php?t=430

  url := 'http://websim.speedsim.net/index.php?lang=de&referrer=cS';

  for i := 0 to 2 do
    param('tech_a0_' + IntToStr(i),PlayerOptions.websim_techs[i]);

  for i := 0 to 2 do
    param('engine0_' + IntToStr(i),PlayerOptions.websim_engines[i]);

  param('start_pos', PositionToStr_(PlayerOptions.StartPlanet));

  param('perc-df', round(TF_faktor_Fleet*100));
  param('def_to_df', TF_faktor_Def > 0);

  param('enemy_name', scan.Head.Planet);
  param('enemy_pos', PositionToStr_(scan.Head.Position)); // don't know if sim supports the [x:xxx:x M] extension
  param('enemy_metal', scan.Bericht[sg_Rohstoffe,sb_Metall]);
  param('enemy_crystal', scan.Bericht[sg_Rohstoffe,sb_Kristall]);
  param('enemy_deut', scan.Bericht[sg_Rohstoffe,sb_Deuterium]);

  param('tech_d0_0', scan.Bericht[sg_Forschung,sb_Waffentechnik]);
  param('tech_d0_1', scan.Bericht[sg_Forschung,sb_Schildtechnik]);
  param('tech_d0_2', scan.Bericht[sg_Forschung,sb_Raumschiffpanzerung]);

  for i := 0 to fsc_1_Flotten-1 do
  begin
    param('ship_d0_' + IntToStr(i) + '_b',
      scan.Bericht[sg_Flotten,i]);
  end;

  for i := 0 to fsc_2_Verteidigung-1 do
  begin
    param('ship_d0_' + IntToStr(fsc_1_Flotten + i) + '_b',
      scan.Bericht[sg_Verteidigung,i]);
  end;

  ShellExecute(Self.Handle,'open',PChar(url),'','',0);
end;

procedure TFRM_Main.Spionage2Click(Sender: TObject);
begin
  ODataBase.LanguagePlugIn.CallFleet_(
    Frame_Bericht1.Bericht.Head.Position, fet_espionage);
end;

procedure TFRM_Main.Expedition1Click(Sender: TObject);
var fleet: TFleetEvent;
    i: integer;
begin
  fleet.head.target := Frame_Bericht1.Bericht.Head.Position;
  fleet.head.target.P[2] := 16;
  fleet.head.eventtype := fet_expedition;

  SetLength(fleet.ships, fsc_1_Flotten);
  for i := 0 to fsc_1_Flotten-1 do
    fleet.ships[i] := 0;

  SetLength(fleet.ress, fsc_0_Rohstoffe);
  for i := 0 to fsc_0_Rohstoffe-1 do
    fleet.ress[i] := 0;

  fleet.ships[1] := 37; // Großer Transporter
  fleet.ships[3] := 66; // Schwerer Jäger
  fleet.ships[8] := 1;  // Spionagesonde

  ODataBase.LanguagePlugIn.CallFleetEx(fleet);
end;

procedure TFRM_Main.frmevents1Click(Sender: TObject);
begin
  frm_cshelper_ctrl.show();
end;

end.
