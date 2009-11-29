unit Prog_Unit;

interface
                                     
uses
  Windows, Sysutils, classes, Forms, IniFiles, graphics, Dialogs, spielerdaten,
  FileCtrl, scktcomp, ImportProgress, stdctrls, buttons,
  menus, comctrls, OGame_Types, VirtualTrees, SelectPlugin, Stat_Points, TThreadSocketSplitter,
  ThreadProtocolObject, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdHTTP, DateUtils, LibXmlParser, cS_DB, cS_DB_reportFile,
  SelectUSer, UniTree, cS_networking, MergeSocket, SplitSocket, cS_DB_solsysFile, TIReadPlugin,
  SyncObjs, RaidBoard, frm_pos_size_ini, OGameData;


const
  //Notes
  pi_Note            = 5;  //-> siehe TThreadSocketSplitter!

  //noneThread     <= 1024   //DatenPakete werden mit dem Hauptthread Synchronisiert zur Verarbeitung aufgerufen
  pi_nTScans         = 10;
  pi_nTSysteme       = 11;
  pi_nTRaids         = 12;
  pi_nTDelRaids      = 13;
  pi_nTChat          = 14;
  pi_nTSpieler       = 15;
  pi_nTStats         = 16;
  pi_nTFleetStats    = 17;
  pi_nTAllyStats     = 18;

  //ExtraThread      >= 512  //DatenPakete werden direkt vom ReadThread der Verbindung zur Verarbeitung aufgerufen
  pi_ExTOrderSystem  = 540;
  pi_ExTOrderScan    = 545;
  pi_Statistic_start = 600;
  //hier nach Statistic mindestend 20 abstand halten!!

  //Thread           > 1024  //Datenpakete warten auf Verarbeitung! d.h. der ReadThread wird solange angehalten, bis ein anderer Thread diese Daten abruft und verarbeitet.
  pi_TMain           = 1025;
  pi_TSyncScans      = 1026;
  pi_TSyncSystems    = 1027;
  pi_TSyncRaids      = 1029;
  pi_TSyncStats      = 1030;

const VNumber = '1.8e1';
      

{$DEFINE oanzahl}  //ohne Anzahl!! -- brauchts nirgends mehr!

type
  TProgressEvent = procedure(Sender: TObject; ClientThread: TSplitSocket; Prozent: Byte) of object;
  TProgressNewAction = procedure(Sender: TObject; ClientThread: TSplitSocket; Action: String) of object;
  TPlanet = record
    ScanBericht : Integer;
    {$IFNDEF oanzahl} Anzahl : word; {$ENDIF}
  end;
  PSonnenSystem = ^TSonnenSystem;
  TSonnenSystem = record
    Planeten : Array[1..max_Planeten] of array[false..true] of TPlanet;
    //MondeReached: array of TPlanetPosition;
    SystemCopy : integer;
  end;
  TRaidPlayer = record
    Name: TPlayerName;
    Forschungen: array[0..2] of integer;
  end;
  TRaidAusgang = (kaUnentschieden,kaAngreifer,kaVerteidiger);
  TRaidInfo = Record
    Zeit: TDateTime;
    AngreiferUnits, VerteidigerUnits: word;
    Mondentstehung: Integer;
    TFMetall, TFKristall: Word;
    Ausgang: TRaidAusgang;
    Ende: String[255];
  end;
  TRaidHead = Record
    Angreifer: array of TRaidPlayer;
    Verteidiger: array of TRaidPlayer;
    Info: TRaidInfo;
  end;

  TNREvent = procedure(nr: integer) of object;
  TOgameDataBase = class;
  TOGameDataBase_AskMoon = procedure(Sender: TOGameDataBase; const
    Report: TScanBericht; var isMoon: Boolean; var Handled: Boolean) of object;
  TOgameDataBase = class(TObject)
  protected
    cS_NetServ: TcSServer;
    function FUniRead(G, S: Integer): TSonnensystem;
    function InitStatFiles: Boolean;
  private
    xml_data_file: string;
    Initialised: Boolean;
    function LoadInitFiles: boolean;
    function initSysFile: Boolean;
    function initScanFile: Boolean;
    procedure ImportSys(Filename: String);
    procedure ImportScans(Filename: string);
    procedure SaveOptions;
    function GetStats: TStatPoints;
    function GetFleetStats: TStatPoints;
    function GetAllyStats: TStatPoints;
    procedure ApplicationOnIdle(Sender: TObject; var Done: Boolean);
    function initFleetBoard: Boolean;
    procedure langplugin_onaskmoonprocedure(Sender: TOGameDataBase; const Report: TScanBericht;
      var isMoon: Boolean; var Handled: Boolean);
  public
    game_data: TGameData;

    //Alte Symbole: IMMER UniTree verwenden!
    Berichte: TcSReportDB;
    Systeme: TcSSolSysDB;
    //--------------------------------------
    UniTree: TUniverseTree;
    UserPosition: TPlanetPosition;
    Username: TPlayerName;
    game_domain: string;
    UniDomain: String;  // andromeda
    SaveDir, PlayerInf: String;
    Importing: Boolean;
    DeleteScansWhenAddSys: Boolean;
    redHours: TRedHours;
    MaxTimeToAdd: TDateTime;
    OnRaidInfo: TNREvent;
    LanguagePlugIn: TLangPlugIn;
    Statistic: TStatisticDB;
    Stats_own, FleetStats_own, AllyStats_own: Cardinal;
    FleetBoard: TFleetBoard;
    DefInTF: Boolean;
    SpeedFactor: Single;
    OnAskMoon: TOGameDataBase_AskMoon;
    check_solsys_data_before_askMoon: boolean;
    property Uni[g,s: Integer]: TSonnenSystem read FUniRead;
    property Stats: TStatPoints read GetStats;
    property FleetStats: TStatPoints read GetFleetStats;
    property AllyStats: TStatPoints read GetAllyStats;

    function GetSystemTime_u(p1, p2: word): int64;
    function global_domain(): string;


    function LeseFleets(handle: integer): Boolean;
    function GetPlayerAtPos(planet: TPlanetPosition; addstatus: boolean = true): string;
    property InitialisedF: boolean read Initialised;
    constructor Create(Init: Boolean; UserDir: string; ACLHost: TcSServer;
      xml_data_file: string);
    function Initialise: Boolean;
    destructor Destroy; override;
    procedure ImportFile(Filename: String);
    procedure DeleteDeletedPlanets(Sys: integer);
    procedure DeleteScansOfPlanet(Pos: TPlanetPosition);
    function GetSystemCopyNR(Pos: TPlanetposition): integer; overload;
    function GetSystemCopyNR(g,s: Integer): integer; overload;
    function LeseMehrereScanBerichte(handle: integer): Integer;
    function LeseSystem(handle: integer): Boolean;
    function SelectPlugIn(ForceDialog: boolean): Boolean;
    procedure SaveUserOptions;
    function CheckUserOptions(ForceDialog: Boolean): boolean;
    procedure ImportXML(Filename: String);
    function LeseStats(handle: integer): Boolean;
    function GetLastActivity(pos: TPlanetPosition): int64;
    function GetPlayerStatusAtPos(pos: TPlanetPosition): string;
    function Time_To_AgeStr(time: TDateTime): String;
  end;
  TFUni = (fsAsk,fsNone,fsDeleteAll);


var ODataBase: TOgameDataBase;
    login: boolean;  //wird verwendet um beim beenden weider neu zum starten mit login!
    cSServer: TcSServer;
    Protocol: TThreadProtocol;
    userdatadir: string;
var
  DefaultUser: String;
  LastUser: String;
  LangFile: String;

//function LeseSystemPlanet(s: string; var SP: TSystemPlanet): boolean;
//function ScanToFileName(Scan: TScanBericht): string;
function AlterToColor_dt(Alter: TDateTime; maxhours: integer): TColor;
function CheckNewestVersion: string;
function dPunkteToColor(dPunkte: Integer; redgreenLine: Integer): TColor;
function ReadSysFromStream_1_0(stream: TStream): TSystemCopy;
procedure WriteSysToStream_1_0(Sys: TSystemCopy; stream: TStream);
procedure WriteStringToStream(s: shortstring; stream: TStream);
function ReadStringFromStream(stream: TStream): ShortString;
function LogSenderToStr(Sender, SenderToIdentify: TObject;
    var SenderName: string): Boolean;
function Time_To_AgeStr_Ex(a_now, time: TDateTime): String;

implementation

uses Languages, Connections, cS_XML, Export,
  SDBFile;


function TOgameDataBase.LeseFleets(handle: integer): Boolean;
var count, i, j: integer;
    fleet: TFleetEvent;
    info: TFleetsInfoSource;
begin
  info := LanguagePlugIn.ReadPhalanxScan(handle);
  count := info.count;

  Result := (count > 0)and(info.typ = fist_events);
  if Result then
  begin
    //Vorher alle eingelesenen Flotten löschen:
    // (damit alle "frisch" wieder eingelesen werden)
    i := 0;
    while (i < FleetBoard.Fleets.Count) do
    begin
      with FleetBoard.Fleets[i] do
      begin
        if (head.player = Username)and
           (head.unique_id >= 0)and
           (
             (GetPlayerAtPos(head.origin, false) = Username)or
             (GetPlayerAtPos(head.target, false) = Username)
           ) then
          FleetBoard.DeleteFleet(i)
        else
          inc(i);
      end;
    end;
  end;

  for i := 0 to count -1 do
  begin
    if LanguagePlugIn.ReadPhalanxScanGet(fleet) then
    begin
      if (fleet.head.eventtype <> fet_espionage){ and
         (not ((fef_return in fleet.head.eventflags) and
                (fef_own in fleet.head.eventflags)))} then
      begin
        j := UniTree.UniReport(fleet.head.target);
        if j >= 0 then
        begin
          fleet.ress[0] := Berichte[j].Bericht[sg_Rohstoffe][0] div 2;
          fleet.ress[1] := Berichte[j].Bericht[sg_Rohstoffe][1] div 2;
          fleet.ress[2] := Berichte[j].Bericht[sg_Rohstoffe][2] div 2;
        end;

        fleet.head.player := Username;
        FleetBoard.AddFleet(fleet);
      end;
    end;
  end;
end;

function TOgameDataBase.GetPlayerAtPos(planet: TPlanetPosition;
  addstatus: boolean = true): string;
var i: integer;
begin
  i := UniTree.UniSys(planet.P[0],planet.P[1]);
  if i >= 0 then
  with Systeme[i] do
  begin
    Result := Planeten[planet.P[2]].Player;
    if addstatus and (Planeten[planet.P[2]].Status <> []) then
      Result := Result + ' (' +
        LanguagePlugIn.StatusToStr(Planeten[planet.P[2]].Status) +
        ')';
  end
  else
  begin
    i := UniTree.UniReport(planet);
    if i >= 0 then
    begin
      Result := Berichte[i].Head.Spieler;
    end
    else
      Result := '???';

    if addstatus then
      Result := Result + ' (?)';
  end;
end;

function LogSenderToStr(Sender, SenderToIdentify: TObject;
    var SenderName: string): Boolean;
begin
  Result := True;
  if (SenderToIdentify is TSocketMultiplex) then
  begin
    with SenderToIdentify as TSocketMultiplex do
    if Master then
      SenderName := 'NCon_M_' + IntToHex(Handle,6)
    else
      SenderName := 'NCon_S_' + IntToHex(Handle,6);
  end
  else
  if (SenderToIdentify is TThread) then
    SenderName := 'Thread_' + IntToHex(TThread(SenderToIdentify).Handle,6)
  else
    Result := False;
end;

function TOgameDataBase.FUniRead(G, S: Integer): TSonnensystem;
var i: Integer;
    m: Boolean;
begin
  //ToDo: Diese Funktion komplett entfernen/ rausoptimieren/ ersetzen
  Result.SystemCopy := UniTree.UniSys(G,S);
  for i := 1 to max_planeten do
    for m := false to true do
      Result.Planeten[i,m].ScanBericht := UniTree.UniReport(G,S,i,m);
end;


constructor TOgameDataBase.Create(Init: Boolean; UserDir: string;
  ACLHost: TcSServer; xml_data_file: string);
begin
  inherited Create;
  OnAskMoon := nil;
  check_solsys_data_before_askMoon := false;
  cS_NetServ := ACLHost;
  self.xml_data_file := xml_data_file;

  Application.OnIdle := ApplicationOnIdle;
  
  {CThreadHost.AddNoThreadDataProc(pi_nTScans,CThreadHostNoThreadScan_R);
  CThreadHost.AddNoThreadDataProc(pi_nTSysteme,CThreadHostNoThreadSystem_R);
  CThreadHost.AddNoThreadDataProc(pi_ExTOrderSystem,CThreadHostAsyncOrderSystem_R);
  CThreadHost.AddNoThreadDataProc(pi_ExTOrderScan,CThreadHostAsyncOrderScan_R); }

  LanguagePlugIn := TLangPlugIn.Create;
  SaveDir := UserDir;
  if not DirectoryExists(SaveDir) then CreateDir(SaveDir);

  PlayerInf := SaveDir + 'options.inf';
  if init then
  begin
    if Initialise then
    begin
      UniTree := TNetUniTree.Create(max_Galaxy, max_Systems, max_Planeten,
                                  Systeme, Berichte, cS_NetServ);
    end;
  end;
end;

procedure TOgameDataBase.SaveUserOptions;
var i: integer;
    ini: TMemIniFile;
begin
  //Es gibt hier zwei Proceduren!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  //SaveOptions -> wird von Self.Destroy aufgerufen!
  //SaveUserOptions -> wird bei Änderung der Spieler daten über "Einstellungen" aufgerufen
  //                   und direkt nach den reinladen, in LoadInitFiles!


   
  ini := TMemIniFile.Create(PlayerInf);
  ini.WriteString('UserOptions', 'OwnName',Username);
  for i := 0 to 2 do
    ini.WriteInteger('StartPosition', 'Pos' + inttostr(i),UserPosition.P[i]);
  ini.WriteString('UserOptions', 'UniDomain', UniDomain);
  ini.WriteBool('UserOptions', 'DefInTF', DefInTF);
  ini.WriteFloat('UserOptions', 'SpeedFactor', SpeedFactor);
  ini.WriteString('UserOptions', 'PluginFile', LanguagePlugIn.PluginFilename);
  ini.WriteString('UserOptions', 'ogame_domain', game_domain);
  ini.WriteInteger('UserOptions', 'Galaxy_Count', max_Galaxy);
  ini.WriteInteger('UserOptions', 'System_Count', max_Systems);
  ini.WriteFloat('UserOptions', 'tf_factor', truemmerfeld_faktor);

  ini.WriteBool('UserOptions', 'BetaUni', OGame_IsBetaUni);

  ini.UpdateFile;
  ini.free;
end;

function TOgameDataBase.LoadInitFiles: boolean;
var i : integer;
    ini : TMemIniFile;
    rh: TredHoursTypes;
begin
  //Laden der Daten
  ini := TMemIniFile.Create(PlayerInf);
  max_Galaxy := ini.ReadInteger('UserOptions','Galaxy_Count',0);
  max_Systems := ini.ReadInteger('UserOptions','System_Count',0);

  truemmerfeld_faktor := ini.ReadFloat('UserOptions', 'tf_factor', truemmerfeld_faktor);

  OGame_IsBetaUni := ini.ReadBool('UserOptions', 'BetaUni', OGame_IsBetaUni);

  for i := 0 to 2 do
    UserPosition.P[i] := ini.ReadInteger('StartPosition','Pos' + inttostr(i),0);
  UserPosition.Mond := false;
  Username := ini.ReadString('UserOptions','OwnName','');
  
  UniDomain := ini.ReadString('UserOptions','UniDomain','');
  if UniDomain = '' then
     UniDomain := 'uni' + ini.ReadString('UserOptions','Uni',''); // import old settings
     
  DefInTF := ini.ReadBool('UserOptions','DefInTF',False);
  SpeedFactor := ini.ReadFloat('UserOptions','SpeedFactor', 1);
  game_domain := ini.ReadString('UserOptions','ogame_domain','--n/a--');
  if game_domain = '--n/a--' then  // for compatibility to old version
    game_domain := game_sites_OLD[ini.ReadInteger('UserOptions','LanguageIndex',0)];

  LanguagePlugIn.PluginFilename := ini.ReadString('UserOptions','PluginFile','');
  DeleteScansWhenAddSys := ini.ReadBool('UserOptions','AutoDeleteScans',true);

  Stats_own := ini.ReadInteger('UserOptions','Punkte',0);
  FleetStats_own := ini.ReadInteger('UserOptions','FleetPunkte',0);
  AllyStats_own := ini.ReadInteger('UserOptions','AllyPunkte',0);

  redHours[rh_Scans] := 340;
  redHours[rh_Systems] := 340;
  redHours[rh_Stats] := 340;
  redHours[rh_Points] := 100000;

  for rh := low(rh) to high(rh) do
    redHours[rh] := ini.ReadInteger('UserOptions','redHours'+IntToStr(integer(rh)),redHours[rh]);

  MaxTimeToAdd := ini.ReadDateTime('UserOptions','MaxTimeToAdd',2);
  ini.free;

  Result := CheckUserOptions(False);
  if Result then
  begin {dann hatt alles funzt- >}
    SelectPlugIn(False);
    SaveUserOptions;
  end;
end;

function AlterToColor_dt(Alter: TDateTime; maxhours: integer): TColor;
var r,g,b : integer;
begin
  if Alter < 0 then //Zukunft!?
  begin
    Result := clsilver;
    exit;
  end;

  alter := (alter * 255) * (24/maxhours); //aufteilen in 255 stufen

  r := trunc(alter); if r > 255 then r := 255;

  g := 255 - trunc(alter); if g < 0 then g := 0;

  b := (g-r);

  if b<0 then b := -b;
  b := 255-b;
  Result := rgb(r,g,b);
end;


function TOgameDataBase.Initialise: Boolean;
begin

  try
    game_data := TGameData.Create(xml_data_file);
  finally
    // ... TODO
  end;

  Result := LoadInitFiles and
            initScanFile and
            initSysFile and
            InitStatFiles and
            initFleetBoard;
  Initialised := Result;
end;

destructor TOgameDataBase.Destroy;
begin
  if Initialised then
    SaveOptions;

  Statistic.Free;

  FleetBoard.Free;
  UniTree.Free;
  Systeme.Free;
  Berichte.Free;

  LanguagePlugIn.Free;

  game_data.Free;
  inherited Destroy;
end;

function TOgameDataBase.initSysFile: Boolean;
(* Allgemein: Öffnet die Sonnensystem-Datenbank
   Speziell: Öffnet die Datei für die Sonnensystem-Datenbank.
             Falls diese ein altes Format besitzt, wird
             eine neue Datenbank erstellt und die alte Datei importiert,
             dannach gelöscht! *)

  function __importold(filename: string): Boolean;
  var old: TcSSolSysDB_for_File;
      i: integer;
  begin
    old := TcSSolSysDB_for_File.Create(filename, UniDomain); 
    try
      for i := 0 to old.Count-1 do
      begin
        Systeme.AddSolSys(old[i]);
      end;
    finally
      old.Free;
    end;
    Result := True;
  end;

var Filename: String;
begin
  Result := False;
  Filename := SaveDir + 'solsys.cssys';

  try
    try
      Systeme := TcSSolSysDB_for_File.Create(Filename, UniDomain);
    except
      ShowMessage(STR_Sonnensystemdatei_konnte_nicht_geoeffnetwerden_Prog_wird_beendet +
                  #10 + #13 + STR_vllt_andere_Instanz);
      Exit;
    end;

    with Systeme as TcSSolSysDB_for_File do
    begin
      if IsOldFormat then
      begin
        Systeme.Free;
        RenameFile(Filename,Filename+'.old');
        Systeme := TcSSolSysDB_for_File.Create(Filename, UniDomain);
        if  __importold(Filename+'.old') then
          DeleteFile(Filename+'.old');
      end;
    end;
  finally

  end;
  Result := True;
end;

function TOgameDataBase.initScanFile: boolean;
(* Allgemein: Öffnet die Berichte-Datenbank
   Speziell: Öffnet die Datei für die Berichte-Datenbank.
             Falls diese ein altes Format besitzt, wird
             eine neue Datenbank erstellt und die alte Datei importiert,
             dannach gelöscht! *)

  function __importold(filename: string): Boolean;
  var old: TcSReportDB_for_File;
      i: integer;
  begin
    old := TcSReportDB_for_File.Create(filename, UniDomain); 
    try
      for i := 0 to old.Count-1 do
      begin
        Berichte.AddReport(old[i])
      end;
    finally
      old.Free;
    end;
    Result := True;
  end;

var Filename: String;
begin
  Result := False;
  //öffnen der Scans-datei! + überprüfung auf neu und/oder falsches Universum!
  Filename := SaveDir + 'reports.csscan';

  try
    try
      Berichte := TcSReportDB_for_File.Create(Filename, UniDomain);
    except
      Berichte.Free;
      ShowMessage(STR_Scanberichtdatei_konnte_nicht_geoeffnetwerden_Prog_wird_beendet +
                   #10 + #13 + STR_vllt_andere_Instanz);
      Exit;
    end;

    with Berichte as TcSReportDB_for_File do
    begin
      if IsOldFormat then
      begin
        Berichte.Free;
        RenameFile(Filename,Filename+'.old');
        Berichte := TcSReportDB_for_File.Create(Filename, UniDomain);
        if  __importold(Filename+'.old') then
          DeleteFile(Filename+'.old');
      end;
    end;
  finally

  end;
  Result := True;
end;


procedure TOgameDataBase.ImportFile(Filename: String);
//Mit dieser Procedure wird ein Importvorgang gestartet. Sie ermittelt, ob Scan oder Sytem-Datei und leitet die internen Importfunktionen ein!
var datei: TFileStream;
    V: String[20]; // einfach mal mehr einlesen, mach ja nix
begin
  //Lesen der Versionsimformationen:
  datei := TFileStream.Create(Filename,fmOpenRead);
  datei.Read(V,sizeof(V));
  datei.free;

  //Auswahl und Start der iternen Funktionen (ImportSys / ImportScans)
  if (copy(V,1,length(cSSSFFStart)) = cSSSFFStart) then
    ImportSys(Filename)
  else
  if (copy(V,1,length(cSRFFStart)) = cSRFFStart) then
    ImportScans(Filename)
  else
  if (copy(V,1,6) = 'export')or(copy(V,1,4) = '?xml') then
    ImportXML(Filename)
  else
  if (copy(V,1,3) = 'cSe') then
    FRM_Export.ImportcSe_1_0(Filename)
  else
    ShowMessage(STR_MSG_keine_creatureScan_datei);

end;

procedure TOgameDataBase.ImportSys(Filename: String);
//Wird normalerweise nur durch die Pulic-Procedure ImportFile aufgerufen. Importiert alle neueren Sonnensysteme in der Datei (filename)
var ImportSysFile: TcSSolSysDBFile;
    i: integer;
    FRM_Progress: TFRM_ImportProgress;
    e: Boolean;
begin
  ImportSysFile := TcSSolSysDBFile.Create(Filename);
  try
    //überprüfung auf Uni (nicht auf Sprache, da nicht in der Dateiinformation enthalten!)
    if (*(ImportSysFile.Universe = UserUni)*) (true) or  // TODO
       (Application.MessageBox(
         PChar(STR_MSG_Falsches_Universum + ImportSysFile.UniDomain),
         PChar(Application.Title),MB_YESNO or MB_ICONQUESTION) = idYes) then
    begin
      //erstellen und initialisieren des FortschrittFenster
      FRM_Progress := TFRM_ImportProgress.Create(Application);
      FRM_Progress.GroupBox1.Caption := STR_Importiere_Sonnensysteme;
      FRM_Progress.Gauge1.MaxValue := ImportSysFile.Count;

      //Ausschalter
      FRM_Progress.ende := @e;
      e := false;

      FRM_Progress.show;
      for i := 0 to ImportSysFile.Count-1 do
        begin
          try
            //AddSysToList überprüft selbst, ob die Daten neuer sind oder nicht!
            UniTree.AddNewSolSys(ImportSysFile.SolSys[i]);
          except
            Application.HandleException(self);
            if Application.MessageBox(Pchar('Error importing solsys #' + IntToStr(i)),'cS Import',MB_OKCANCEL) = IDCancel then
              e := True;
          end;

          FRM_Progress.Label1.Caption := STR_Systeme + ': ' + IntToStr(i);
          FRM_Progress.Gauge1.Progress := i+1;

          //wird in keinem eigenen Thread ausgeführt!
          Application.ProcessMessages;

          if e then Break;
        end;

      FRM_Progress.ende := nil;
      FRM_Progress.Release;
    end;
  finally
    ImportSysFile.Free;
  end;
end;

procedure TOgameDataBase.ImportScans(Filename: string);
var ImportScanFile: TcSReportDBFile;
    i: integer;
    FRM_Progress: TFRM_ImportProgress;
    e: boolean;
begin
  ImportScanFile := TcSReportDBFile.Create(Filename);

  //überprüfung auf Uni (nicht auf Sprache, da nicht in der Dateiinformation enthalten!)
  if (*(ImportScanFile.Universe = UserUni)*) (true)or // TODO
     (Application.MessageBox(PChar(STR_MSG_Falsches_Universum + ImportScanFile.UniDomain),PChar(Application.Title),MB_YESNO or MB_ICONQUESTION) = idYes) then
  begin
    //erstellen und initialisieren des FortschrittsFenster
    FRM_Progress := TFRM_ImportProgress.Create(Application);
    FRM_Progress.GroupBox1.Caption := STR_Importiere_Scanberichte;
    FRM_Progress.Gauge1.MaxValue := ImportScanFile.Count;

    //Ausschalter
    FRM_Progress.ende := @e;
    e := False;

    FRM_Progress.show;
    for i := 0 to ImportScanFile.Count-1 do
      begin
        Importing := true;
        try
          UniTree.AddNewReport(ImportScanFile.Reports[i]);
        except
          ShowMessage('Error importing report #' + IntToStr(i));
        end;
        Importing := false;

        FRM_Progress.Label1.Caption := STR_Scanberichte + ': ' + IntToStr(i+1);
        FRM_Progress.Gauge1.Progress := i+1;

        //wird in keinem eigenen Thread ausgeführt!
        Application.ProcessMessages;

        if e then Break;
      end;
    FRM_Progress.ende := nil;
    FRM_Progress.Release;
  end;
  ImportScanFile.Free;
end;

procedure TOgameDataBase.DeleteDeletedPlanets(Sys: integer);
var p: integer;
    m: boolean;
    pos: TPlanetPosition;
begin
  with Systeme[sys] do
  for p := 1 to max_Planeten do for m := false to true do
    if (Uni[System.P[0],System.P[1]].Planeten[p,m].ScanBericht >= 0)and(Planeten[p].Player = '') then
    begin
      pos := system;
      pos.P[2] := p;
      pos.Mond := m;
      DeleteScansOfPlanet(pos);
    end;
end;

procedure TOgameDataBase.DeleteScansOfPlanet(Pos: TPlanetPosition);
var i: integer;
begin
  i := UniTree.UniReport(Pos);
  while (i >= 0) do
  begin
    UniTree.DeleteReport(i);
    i := UniTree.UniReport(Pos);
  end;
end;

procedure TOgameDataBase.SaveOptions;
var ini: TMemIniFile;
    rh: TredHoursTypes;
begin
  //Es gibt hier zwei Proceduren!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  //SaveOptions -> wird von Self.Destroy aufgerufen!
  //SaveUserOptions -> wird bei Änderung der Spieler daten über "Einstellungen" aufgerufen
  //                   und direkt nach den reinladen, in LoadInitFiles!


  ini := TMemIniFile.Create(PlayerInf);
  ini.WriteBool('UserOptions','AutoDeleteScans',DeleteScansWhenAddSys);
  for rh := low(rh) to high(rh) do
    ini.WriteInteger('UserOptions','redHours'+IntToStr(integer(rh)),redHours[rh]);
  ini.WriteDateTime('UserOptions','MaxTimeToAdd',MaxTimeToAdd);

  ini.WriteInteger('UserOptions','Punkte',Stats_own);
  ini.WriteInteger('UserOptions','FleetPunkte',FleetStats_own);
  ini.WriteInteger('UserOptions','AllyPunkte',AllyStats_own);
  
  ini.UpdateFile;
  ini.free;
end;


function CheckNewestVersion: string;
var net: TIdHTTP;
    mem: TMemoryStream;
    ende: byte;
    parser: TXmlParser;
    tag_cS, tag_version_main: Boolean;
begin
  net := TIdHTTP.Create(Application);
  mem := TMemoryStream.Create;
  try
    net.Get(UpdateCheckUrl,mem);
    ende := 0;
    mem.Write(ende,sizeof(ende));

    parser := TXmlParser.Create;
    parser.SetBuffer(mem.Memory);
    tag_cS := False;
    tag_version_main := False;
    parser.StartScan;
    while parser.Scan do
    begin
      if parser.CurName = 'creaturescan' then
        tag_cS := parser.CurPartType = ptStartTag;

      case parser.CurPartType of
      ptStartTag: if (parser.CurName = 'version')and
                     (parser.CurAttr.Value('type') = 'main') then
                  begin
                    tag_version_main := true;
                  end;
      ptContent: if tag_cS and tag_version_main then
                 begin
                   Result := trim(parser.CurContent);
                   break;
                 end;
      end;
    end;
    parser.Free;
  except
    Result := '';
  end;
  net.free;
  mem.Free;
end;

function TOgameDataBase.GetSystemCopyNR(Pos: TPlanetposition): integer;
  //kürzerer weg zum erfahren der systemcopyNR
begin
  if ValidPosition(pos) then
    Result := Uni[pos.p[0],pos.p[1]].SystemCopy
  else Result := -1;
end;

function TOgameDataBase.GetSystemCopyNR(g,s: Integer): integer;
  //kürzerer weg zum erfahren der systemcopyNR
var pos: TPlanetPosition;
begin
  pos.P[0] := g;
  pos.P[1] := s;
  pos.P[2] := 1;
  pos.Mond := False;
  Result := GetSystemCopyNR(pos);
end;


function TOgameDataBase.LeseMehrereScanBerichte(handle: integer): Integer;
var Scan: TScanBericht;
    c: integer;
    moon_unknown, phandled: boolean;
begin
  Result := 0;
  c := LanguagePlugIn.ReadReports(handle);

  while LanguagePlugIn.GetReport(handle, Scan, moon_unknown) do
  begin
    Scan.Head.Creator := Username;

    if moon_unknown then
    begin
      phandled := false;
      langplugin_onaskmoonprocedure(Self, Scan,
                                    Scan.Head.Position.Mond,
                                    phandled);
    end;

    UniTree.AddNewReport(Scan);
    inc(Result);
  end;

  if c <> Result then
    raise Exception.Create('TOgameDataBase.LeseMehrereScanBerichte: Plugin fehlerhaft,' +
      ' Anzahl einegelesener Scans stimmt nicht mit Rückgabewert überein!');

end;


function TOgameDataBase.LeseSystem(handle: integer): Boolean;
var Sys: TSystemCopy;
begin
  Result := LanguagePlugIn.ReadSystem(handle, Sys);
  if Result then
    UniTree.AddNewSolSys(sys);
end;

function TOgameDataBase.SelectPlugIn(ForceDialog: boolean): Boolean;
var dialog: TFRM_SelectPlugin;
    serverURL: string;
begin
  serverURL := UniDomain + '.' + game_domain;
  chdir(ExtractFilePath(Application.ExeName));
  LanguagePlugIn.LoadPluginFile(LanguagePlugIn.PluginFilename,
      serverURL, PlayerInf);
  Result :=  (not ForceDialog) and
             LanguagePlugIn.ValidFile and
             (game_domain = LanguagePlugIn.configGameDomain);
  if not Result then
  begin
    dialog := TFRM_SelectPlugin.Create(Application,game_domain);
    dialog.PluginFile := LanguagePlugIn.PluginFilename;
    if dialog.ShowModal = IDOK then
    begin
      LanguagePlugIn.LoadPluginFile(dialog.PluginFile, serverURL, PlayerInf);
      if not LanguagePlugIn.ValidFile then
          ShowMessage('Die Plugindatei ist fehlerhaft!');
      Result := LanguagePlugIn.ValidFile and
                (game_domain = LanguagePlugIn.configGameDomain);
    end;
    dialog.free;
  end;
end;

function TOgameDataBase.CheckUserOptions(ForceDialog: Boolean): boolean;

  function ValidUserOptions: boolean;
  begin
    Result := (Username <> '')and
              ValidPosition(UserPosition)and
              (UniDomain <> '')and
              (max_Galaxy > 0)and
              (max_Systems > 0);
  end;

  function ExecuteSpiDaForm: boolean;
  var spidaForm: TFRM_Spielerdaten;
  begin
    spidaForm := TFRM_Spielerdaten.Create(Application, Self);
    spidaForm.IngameName := Username;
    spidaForm.UniverseName := UniDomain;
    spidaForm.DefInTF := DefInTF;
    spidaForm.game_domain := game_domain;
    spidaForm.GalaCount := max_Galaxy;
    spidaForm.SysCount := max_Systems;
    spidaForm.HomePlanet := UserPosition;
    spidaForm.SpeedFaktor := SpeedFactor;
    spidaForm.TF_factor := truemmerfeld_faktor;
    spidaForm.redesign := OGame_IsBetaUni;
    if ForceDialog then //im nachhinnein
    begin
      spidaForm.CB_OGame_Site.Enabled := False;
      spidaForm.CB_OGame_Universename.Enabled := False;
      spidaForm.RB_GalaCount9.Enabled := False;
      spidaForm.RB_GalaCount19.Enabled := False;
      spidaForm.RB_GalaCount50.Enabled := False; 
    end;
    Result := spidaForm.Execute;
    if Result then
    begin
      max_Galaxy := spidaForm.GalaCount;
      max_Systems := spidaForm.SysCount;
      UniDomain := spidaForm.UniverseName;
      DefInTF := spidaForm.DefInTF;
      Username := spidaForm.IngameName;
      UserPosition := spidaForm.HomePlanet;
      game_domain := spidaForm.game_domain;
      SpeedFactor := spidaForm.SpeedFaktor;
      truemmerfeld_faktor := spidaForm.TF_factor;
      OGame_IsBetaUni := spidaForm.redesign;
    end;
    spidaForm.free;
  end;

var r: integer;
begin
  if (not ForceDialog) and ValidUserOptions then r := idYes else r := idNo;
  while r = idNo do
  begin
    if ExecuteSpiDaForm then
    begin
      if ValidUserOptions then r := idYes else r := idNo;
    end
    else
      r := idCancel;
  end;
  Result := r <> idCancel;
end;

function TOgameDataBase.InitStatFiles: Boolean;
begin
  Statistic := TStatisticDB.Create(SaveDir + 'statistic%%.cSst', global_domain); // TODO
  Result := True;
end;

procedure TOgameDataBase.ImportXML(Filename: String);
begin
  ImportXMLODB_(Filename,Self);
end;

function dPunkteToColor(dPunkte: Integer; redgreenLine: Integer): TColor;
var x: double;
    r,g,b,h: double;
begin
  x := dPunkte/redgreenLine;
  if x > 1 then x := 1;
  if x < -1 then x := -1;

  {h := abs(x);
  b := -abs(x) + 1;
  if (dPunkte > 0) then Result := rgb(trunc(h*255),0,trunc(b*255)) else Result := rgb(0,trunc(h*255),trunc(b*255));}

  //h := -x*x + 0.10; if h < 0 then h := 0;
  h := 0;
  r :=  0.5*x + 0.5 + h;
  g := -0.5*x + 0.5 + h;
  b := - abs(x) + 1;

  Result := rgb(trunc(r*255),trunc(g*255),trunc(b*255));
end;

function ReadSysFromStream_1_0(stream: TStream): TSystemCopy;
var p: integer;
    uts: Int64;
begin
  FillChar(Result,Sizeof(Result),0);

   //<Head>
  stream.ReadBuffer(uts,SizeOf(uts));
  Result.Time_u := uts;
  stream.ReadBuffer(p,SizeOf(p));
  Result.System.P[0] := p;
  stream.ReadBuffer(p,SizeOf(p));
  Result.System.P[1] := p;
  Result.System.P[2] := 1;
  Result.System.Mond := False;
  //</Head>

  for p := 1 to max_planeten do
  begin
    with Result.Planeten[p] do
    begin
      Player := ReadStringFromStream(stream);
      PlanetName := ReadStringFromStream(stream);
      Ally := ReadStringFromStream(stream);
      stream.ReadBuffer(Status,sizeof(Status));

      stream.ReadBuffer(MondSize,SizeOf(MondSize));
      stream.ReadBuffer(MondTemp,SizeOf(MondTemp));
      stream.ReadBuffer(TF[0],SizeOf(TF[0]));
      stream.ReadBuffer(TF[1],SizeOf(TF[1]));
    end;
  end;
end;

procedure WriteSysToStream_1_0(Sys: TSystemCopy; stream: TStream);
var p: integer;
    uts: Int64;
begin
  //<Head>
  uts := Sys.Time_u;
  stream.WriteBuffer(uts,SizeOf(uts));
  p := Sys.System.P[0];
  stream.WriteBuffer(p,SizeOf(p));
  p := Sys.System.P[1];
  stream.WriteBuffer(p,SizeOf(p));
  //</Head>

  for p := 1 to max_planeten do
  begin
    with Sys.Planeten[p] do
    begin
      WriteStringToStream(Player,stream);
      WriteStringToStream(PlanetName,stream);
      WriteStringToStream(Ally,stream);
      stream.WriteBuffer(Status,sizeof(Status));

      stream.WriteBuffer(MondSize,SizeOf(MondSize));
      stream.WriteBuffer(MondTemp,SizeOf(MondTemp));
      stream.WriteBuffer(TF[0],SizeOf(TF[0]));
      stream.WriteBuffer(TF[1],SizeOf(TF[1]));
    end;
  end;
end;

procedure WriteStringToStream(s: shortstring; stream: TStream);
begin           //keine längeren Strings als 255 zeichen!
  stream.WriteBuffer(s,length(s)+1);
end;

function ReadStringFromStream(stream: TStream): ShortString;
var c: byte;    //keine längeren Strings als 255 zeichen!
begin
  stream.ReadBuffer(c,sizeof(c));
  SetLength(Result,c);
  stream.ReadBuffer(pointer(cardinal(@Result)+1)^,c);
end;


function TOgameDataBase.GetSystemTime_u(p1, p2: word): int64;
begin
  if (Uni[p1,p2].SystemCopy >= 0) then
    Result := Systeme[Uni[p1,p2].SystemCopy].Time_u
  else Result := -1;
end;

function TOgameDataBase.global_domain: string;
begin
  Result := UniDomain + '.' + game_domain;
end;

function TOgameDataBase.LeseStats(handle: integer): Boolean;
begin
  Result := False;
  //Geht leider nochnicht, da nochnicht alle plugins automatisch unterscheiden
  //können welchen typ von statitik es einliest!
end;

function TOgameDataBase.GetStats: TStatPoints;
begin
  Result := Statistic.StatisticType[sntPlayer,sptPoints];
end;

function TOgameDataBase.GetFleetStats: TStatPoints;
begin
  Result := Statistic.StatisticType[sntPlayer,sptFleet];
end;

function TOgameDataBase.GetAllyStats: TStatPoints;
begin
  Result := Statistic.StatisticType[sntAlliance,sptPoints];
end;

procedure TOgameDataBase.ApplicationOnIdle(Sender: TObject;
  var Done: Boolean);
var Ready: Boolean;
begin
  Done := True;
  if Initialised then
  begin
    cS_NetServ.DoWork_idle(Ready);
    if not Ready then
      Done := False;

    if (UniTree is TNetUniTree) then
    begin
      TNetUniTree(UniTree).DoWork_idle(Ready);

      if not Ready then
        Done := False;
    end;

    Statistic.DoWork_idle(Ready);
    if not Ready then
      Done := False;

    FleetBoard.DoWork_idle(Ready);
    if not Ready then
      Done := False;
  end;
end;

function TOgameDataBase.Time_To_AgeStr(time: TDateTime): String;
begin
  Result := Time_To_AgeStr_Ex(FleetBoard.GameTime.Time, time);
end;

function Time_To_AgeStr_Ex(a_now, time: TDateTime): String;
var d: integer;
begin
  d := trunc((a_now-time)/ 1);
  if d = 0 then
    Result := TimeToStr(a_now-time)
  else
    Result := 'd:' + IntToStr(d) + ' ' + TimeToStr(a_now-time);
end;

function TOgameDataBase.GetLastActivity(pos: TPlanetPosition): int64;
var i: integer;
begin
  Result := 0;
  i := UniTree.UniReport(pos);
  if i >= 0 then
  begin
    Result := Berichte[i].Head.Time_u;
  end;

  i := FleetBoard.FindLastArrivedFleet(pos);
  if i >= 0 then
  begin
    if (FleetBoard.History[i].head.arrival_time_u > Result) then
      Result := FleetBoard.History[i].head.arrival_time_u;
  end;
end;

function TOgameDataBase.GetPlayerStatusAtPos(pos: TPlanetPosition): string;
var sys: integer;
begin
  Result := '';
  sys := UniTree.UniSys(pos.p[0], pos.P[1]);
  if sys >= 0 then
  begin
    with Systeme[sys] do
    begin
      Result := LanguagePlugIn.StatusToStr(planeten[pos.P[2]].Status);
    end;
  end
  else
    Result := '?';
end;

function TOgameDataBase.initFleetBoard: Boolean;
begin
  FleetBoard := TFleetBoard_NET.Create(SaveDir, Self.UniDomain, cS_NetServ); // TODO
  Result := True;
end;

procedure TOgameDataBase.langplugin_onaskmoonprocedure(Sender: TOGameDataBase;
  const Report: TScanBericht; var isMoon: Boolean; var Handled: Boolean);
var sys, planet: integer;
begin
  if check_solsys_data_before_askMoon then
  begin
    sys := UniTree.UniSys(Report.Head.Position.P[0],
                          Report.Head.Position.P[1]);
    if sys >= 0 then
    with Systeme[sys] do
    begin
      planet := Report.Head.Position.P[2];
      // Wenn es keinen Mond an dieser stelle gibt, brauchste auchnet fragen!
      Handled := (Planeten[planet].MondSize = 0); 
      isMoon := false;
    end;
  end;

  if (not Handled) and Assigned(OnAskMoon) then
    OnAskMoon(Sender, Report, isMoon, Handled);
end;

end.
