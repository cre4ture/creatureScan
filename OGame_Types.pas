unit OGame_Types;

interface

uses
  Sysutils, {$IFNDEF TEST}Languages,{$ENDIF} Math, LibXmlParser, LibXmlComps,
  Classes, Dialogs, clipbrd, windows, CoordinatesRanges, cS_memstream;

type
  TRessType = (rtMetal, rtKristal, rtDeuterium, rtEnergy);
  TcSResource = Int64;
  TSetRessources = array[TRessType] of TcSResource;
  TLanguage = Word;
  TScanGroup = (sg_Rohstoffe, sg_Flotten, sg_Verteidigung, sg_Gebaeude,
                sg_Forschung);

const
  {$IFDEF TEST} STR_M_Mond = 'M'; {$ENDIF}

  max_Galaxy: word = 9;
  max_Systems: word = 499;

  TF_faktor_Fleet: Double = 0.3; //normal 30%
  TF_faktor_Def: Double = 0.0; //normal 0%

  {$IFDEF spacepioneers}
  max_Planeten = 16;
  {$ELSE}
  max_Planeten = 15;
  {$ENDIF}

  maxraids24h: Integer = 5;

  //Fileconsts: Scans
  SF_Group_Count = 5;
  fsc_0_Rohstoffe = 4;
  {$IFDEF spacepioneers}
  fsc_1_Flotten = 13; //SP: Gebäude
  fsc_2_Verteidigung = 18; //SP: Flotte
  fsc_3_Gebaeude = 10; //SP: Def
  sb_Mine_array: array[rtMetal..rtDeuterium] of TScanData = ((1{Gebäude},0{MetallMine}),
                                              (1{Gebäude},1{KristallMine}),
                                              (1{Gebäude},2{TritMine}));
  fsc_4_Forschung = 22;
  {$ELSE}
  // Flotten
  fsc_1_Flotten = 14;
  fleet_group = sg_Flotten;

  sb_SolSat = 10;
  
  // Verteidigung
  fsc_2_Verteidigung = 10;
  def_group = sg_Verteidigung;
  fsc_3_Gebaeude = 18;

  sb_Abfangraketen = 8;
  sb_InterplanetarRaketen = 9;


  //sb_Terraformer: TScanData = (3{Gebäude},12{Mondbasis});
  sb_Metall = 0;
  sb_Kristall = 1;
  sb_Deuterium = 2;
  sb_Energie = 3;
  sb_Mondbasis = 15{Mondbasis};
  sb_Sensorpalanx = 16{Sensorpalax};
  sb_Ress_array: array[TRessType] of Integer =            ((0{Metall}),
                                                           (1{Kristall}),
                                                           (2{Deuterium}),
                                                           (3{Energy}));
  sb_Mine_array: array[rtMetal..rtDeuterium] of Integer = ((0{MetrallMine}),
                                                           (1{KristallMine}),
                                                           (2{DeutMine}));
  sb_Speicher_array: array[rtMetal..rtDeuterium] of Integer = ((8{Metallspeicher}),
                                                           (9{Kristallspeicher}),
                                                           (10{Deuteriumtank}));
  sb_SolKW = 3; //Solarkraftwerk
  sb_FusionsKW = 4{FKW};

  //Forschungen
  fsc_4_Forschung = 16;
  sb_Waffentechnik = 2;
  sb_Schildtechnik = 3;
  sb_Raumschiffpanzerung = 4;
  sb_Energietechnik = 5;
  sb_Intergal_ForschNetz = 13{Intergal.Forsch.Netz};
  sb_Expeditionstechnik = 14{Expeditionstechnik};
  sb_Gravitonforschung = 15{Gravitonforschung};

  {$ENDIF}

  ScanFileCounts: array[TScanGroup] of integer =
    (fsc_0_Rohstoffe,fsc_1_Flotten,fsc_2_Verteidigung,fsc_3_Gebaeude,fsc_4_Forschung);
  //------------------------------------------------------------------------

  sys_playerstat_inactive = 0;
  sys_playerstat_locked = 1;
  sys_playerstat_longinactive = 2;
  sys_playerstat_urlaub = 3;
  sys_playerstat_noob = 4;
  sys_playerstat_hard = 5;

type
  TNameID = Int64;
  TPlayerName = String[25]; //vermutlich 20
  TAllyName = String[10];  //vermutlich 8
  TPlanetName = String[25]; //eigentlich 20
  TStati = 0..15;  //16 Bit
  TStatus = set of TStati;
  PPlanetPosition = ^TPlanetPosition;
  TPlanetPosition = record
    P : array[0..2] of Word;
    Mond : Boolean;
  end;
  TAbsPlanetNr = Cardinal;
  PSystemPlanet = ^TSystemPlanet;
  TSystemPlanet = record
    Player: TPlayerName;
    PlayerId: TNameID;
    PlanetName: TPlanetName;
    Ally: TAllyName;
    AllyId: TNameID;
    Status: TStatus;
    MondSize: Word;
    MondTemp: SmallInt;
    TF: array[0..1] of Cardinal;
    Activity: Integer; {Time in Seconds (min*60) befor Time_u, -15 -> (*) within last 15min, 0 -> activity > 60 minutes}
  end;
  PSystemCopy = ^TSystemCopy; 
  TSystemCopy = record
    Time_u : Int64;  //Unix
    System : TPlanetPosition; //nur 0,1 wird dann verwendet!
    Planeten : Array[1..max_Planeten] of TSystemPlanet;
    Creator: TPlayerName;
  end;
  TSystemPosition = Array[0..1] of Word;
  TSolSysPosition = TSystemPosition;
  TScanHead = record
    Planet: TPlanetName;
    Position: TPlanetPosition;
    Time_u: Int64;    //Unix
    Spieler: TPlayerName;
    SpielerId: TNameID;
    Spionageabwehr: integer;
    Creator: TPlayerName;
    {geraidet: Boolean;
    von: TPlayerName;}
    Activity: Integer; {Time in Seconds (min*60) befor Time_u, -1 -> no info, 0 -> activity > 60 minutes}
  end;
  TInfoArray = array of integer;
  TScanBericht = class
  private
    fReadOnly: Boolean;
    function getElement(sg: TScanGroup; index: integer): Int64;
    procedure setElement(sg: TScanGroup; index: integer;
      const Value: Int64);
  public
    Head     : TScanHead;
    resources: array[0..fsc_0_Rohstoffe-1]    of TcSResource;
    fleets   : array[0..fsc_1_Flotten-1]      of Integer;
    defence  : array[0..fsc_2_Verteidigung-1] of Integer;
    buildings: array[0..fsc_3_Gebaeude-1]     of ShortInt;
    research : array[0..fsc_4_Forschung-1]    of ShortInt;

    property Bericht[sg: TScanGroup; index: integer]: Int64 read getElement write setElement;
    property isReadOnly: Boolean read fReadOnly;
    procedure lock;
    procedure unlock;
    class function Count(sg: TScanGroup): Integer;
    constructor Create;
    destructor Destroy; override;
    function copy(): TScanBericht;
    procedure copyFrom(scan: TScanBericht);
    procedure clear();
    procedure serialize(stream: TAbstractFixedMemoryStream);
    procedure deserialize(stream: TAbstractFixedMemoryStream);
    function serialize_size(): cardinal;
  end;

  TReadReport = class(TScanBericht)
  public
    AskMoon: Boolean;
  end;
  TReadReportList = class
  private
    flist: TList;
    function getReport(index: integer): TReadReport;
  public
    property reports[index: integer]: TReadReport read getReport; default;
    function push_back(scan: TReadReport): integer;
    function Count: integer;
    procedure clear;
    constructor Create;
    destructor Destroy; override;
  end;

  TRaidAuftrag = record
    Start, Ziel: TPlanetPosition;
    Zeit: TDateTime;
  end;
  TReportTime = record
    Time_u: Int64;
    ID: Integer;
  end;
  TReportTimeList = array of TReportTime;
  TPlanetScanListSortType = (pslst_Nummer, pslst_Alter);
  TStatType = (st_Player, st_Fleet, st_Ally);
  TStatPlayer = record
    Name: TPlayerName;
    NameId: TNameID;
    Punkte: Cardinal;
    case TStatType of
    st_Player: (Ally: TAllyName);    //nur für spielerstats! bei allystats wird der allyname in den Spielernamen geschrieben!
    st_Ally: (Mitglieder: Word);
  end;
  TStatNameType = (sntPlayer, sntAlliance);
  TStatPointType = (sptPoints, sptFleet, sptResearch);
  TStatTypeEx = record
    NameType: TStatNameType;
    PointType: TStatPointType;
  end;
  PStat = ^TStat;
  TStat = record
    first: Word;
    count: byte; 
    Stats: array[0..99] of TStatPlayer;
    Time_u: Int64;
  end;
  TredHoursTypes = (rh_Scans, rh_Systems, rh_Stats, rh_Points);
  TredHours = array[TredHoursTypes] of Integer;
  TResources = array[0..2] of TcSResource;
  TReadDataXMLScanner = class(TXmlScanner)
  private
    group: Integer;
    PROCEDURE ScannerProcessTag(Sender : TObject; TagName : STRING; Attributes : TAttrList; Empty: Boolean);
    PROCEDURE ScannerStartTag(Sender : TObject; TagName : STRING; Attributes : TAttrList);
    PROCEDURE ScannerEmptyTag(Sender : TObject; TagName : STRING; Attributes : TAttrList);
    PROCEDURE ScannerTagReady(Sender : TObject; TagName : STRING);
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TFleetsInfoSourceType = (fist_none, fist_events, fist_phalanx);
  TFleetsInfoSource = record
    typ: TFleetsInfoSourceType;
    count: integer;
    planet: TPlanetPosition;
    time: Int64;
  end;
  PFleetEventScan = ^TFleetEventScan;
  TFleetEventScanType = (fes_none, fes_own, fes_phalanx, fes_manuel);
  TFleetEventScan = record
    scanplayer: TPlayerName;
    scantype: TFleetEventScanType;
    scantime_u: Int64;
  end;
  TFleetEventType = (
    fet_none,
    fet_deploy,     //Stationieren
    fet_transport,  //Transportieren
    fet_attack,     //Angreifen
    fet_espionage,  //Spionage
    fet_harvest,    //Recyclen
    fet_colony,     //Kolonisieren
    fet_expedition  //Expedition
  );
  const
  FleetEventTypeNames: array[TFleetEventType] of string = (
    'none',
    'deploy',
    'transport',
    'attack',
    'espionage',
    'harvest',
    'colony',
    'expedition'
  );
  FleetEventTypeTranslate_: array[TFleetEventType] of string = (
    'none',
    'Stationieren',
    'Transport',
    'Angriff',
    'Spionage',
    'Abbauen',
    'Kolonisieren',
    'Expedition'
  );
  type
  TFleetEventFlag = (fef_return, fef_friendly, fef_neutral, fef_hostile);
  TFleetEventFlags = set of TFleetEventFlag;
  TFleetEventHead = record
    unique_id: integer;  //ID from ogame database
    eventtype: TFleetEventType;
    eventflags: TFleetEventFlags;
    origin, target: TPlanetPosition;
    arrival_time_u: Int64;
    player: TPlayerName;
    joined_id: integer;  //set an id > 0 if Fleet belongs to a "Verbands-Angriff"
  end;
  PFleetEvent_ = ^TFleetEvent;
  TFleetEvent = record
    head: TFleetEventHead;
    ress: TInfoArray; 
    ships: TInfoArray;
  end;

  {TFleetJob = (fj_transport, fj_attack, fj_spy, fj_recycle, fj_colonize);
  TFleetHead = record
    Auftrag: TFleetJob;
    Ankunft: Int64;
    Spieler: TPlayerName;

    StartPlanet,
    ZielPlanet: TPlanetPosition;

    Metall,
    Kristall,
    Deuterium: Integer;

    notified: Boolean;
  end;
  PFleet = ^TFleet;
  TFleet = record
    head: TFleetHead;
    ships: TInfoArray;
  end;}

  TOGameOptions = class
  public
    constructor Create(XML_Data_File: string);
  end;

  TTrimCharSet = set of Char;

var
  game_sites_OLD: array of String;
  xspio_idents: array[TScanGroup] of array of String;
  maxPlanetTemp: array[1..max_Planeten] of single;
  maxPlanetTemp_redesign: array[1..max_Planeten] of single;
  fleet_resources: array[0..fsc_1_Flotten-1] of Tresources;
  def_resources: array[0..fsc_2_Verteidigung-1] of Tresources;

  // Interplanetarraketen und Abfangraketen werden nicht ins TF gerechnet, da
  // sie nie am Kampf teilnehmen!  (wird aus der xml-datei gelesen)
  // def_ignoreTF == true heist also -> nicht ins TF reinrechnen
  def_ignoreFight: array[0..fsc_2_Verteidigung-1] of Boolean;
  ot_tousandsseperator: string;
  UpdateCheckUrl, QuickUpdateUrl: string;
  FOGameRangeList: TCoordinatesRangeList;

  // Uni6 BetaUni bzw. Redesign
  OGame_IsBetaUni: Boolean;


function FleetEventTypeToStrEx_(flt: TFleetEvent): string;
function FleetEventTypeToStr_(fj: TFleetEventType): string;
function FleetEventTypeToNameStr(fj: TFleetEventType): string;
procedure DeleteEmptyChar(var s: string);
function ReadPosOrTime(const s: string; p: Integer; var Position: TPlanetPosition): integer;
function PositionToStr_(pos: TPlanetPosition): string;
function PositionToStrA(pos: TPlanetPosition): string;
function PositionToStrMond(Pos: TplanetPosition): string;
function PositionToStrAMond(Pos: TPlanetPosition): string;
function ValidPosition(pos: TPlanetPosition): boolean; overload;
function ValidPosition(pos: TSystemPosition): boolean; overload;
function TrimStringChar(S: string; C: Char): String;
function CountdownTimeToStr(time: TDateTime): String;
function ReadInt(s: string; p: integer; tsep: Boolean = True): int64;
function ReadIntEx(s: string; p: integer; IgnoreChars: string = '';
  TrimChars: TTrimCharSet = ['-',' ',#9{Tab},#10]): int64;
procedure SortPlanetScanList(var List: TReportTimeList;
  Typ: TPlanetScanListSortType);
function GetMineEnergyConsumption(Scan: TScanbericht): Integer;
function calcPlanetTemp(solsatenergy: single): single;
function calcSolSatEnergy(Scan: TScanBericht): Integer;
function calcProduktionsFaktor(Scan: TScanBericht; out needed_energy: Integer): single;
function GetMineProduction_(const Scan: TScanBericht;
  const SpeedFactor: Single;
  const Mine: TRessType;
  const prod_faktor: single;
  const calcMaxTemp: single (* set NaN for no use*)): TcSResource;
function MineProduction(Stufe: Integer; Mine: TRessType;
  prod_faktor: single; planetTempMax: single): TcSResource;
procedure Initialise(XML_Data_File: string);
function CalcTF(Scan: TScanBericht): Tresources;
function FusionsKWDeut(stufe: integer): integer;
function NextPlanet(var Pos: TPlanetPosition): Boolean;
function CompareSys(Sys1, Sys2: TSystemCopy;
  ignoreTime: Boolean = False): string;
function CompareScans(Scan1, Scan2: TScanBericht): string;
function SamePlanet(const Pos1, Pos2: TPlanetPosition): Boolean;
function IntToStrKP(i: Int64; kpc: char = #0): String;
function PosBigger(pos1, pos2: TPlanetPosition): boolean;
function StrToPosition(S: string): TPlanetPosition;
function StrToPositionEx(S: string): TPlanetPosition;
function SameFleetEvent(Fleet1, Fleet2: TFleetEvent): Boolean;
function OGameRangeList: TCoordinatesRangeList;
function AbsPlanetNrToPlanetPosition(nr: TAbsPlanetNr): TPlanetPosition;
function PlanetPositionToAbsPlanetNr(pos: TPlanetPosition): TAbsPlanetNr;
function checkMoonScan(var Report: TScanBericht): Boolean;
function BufFleetSize: Integer;
function ReadBufFleet(Buffer: Pointer): TFleetEvent;
procedure WriteBufFleet(const Fleet: TFleetEvent; Buffer: Pointer);
function CalcScanRess_Now_(Scan: TScanBericht; const Mine: TRessType;
  alter_h: single; production_per_h: TcSResource): TcSResource;
function GetStorageSize(scan: TScanBericht; resstype: TRessType): TcSResource;
function GetScanGrpCount(Scan: TScanBericht): integer;
function domainTolangindex(domain: string): integer;


implementation

function domainTolangindex(domain: string): integer;
  var i: integer;
  begin
    Result := -1;
    for i := 0 to length(game_sites_OLD) - 1 do
    begin
      if domain = game_sites_OLD[i] then
      begin
        Result := i;
        break;
      end;
    end;
  end;

function checkMoonScan(var Report: TScanBericht): Boolean;
begin
  {Diese Funktion überprüft anhand der Gebäudedaten ob es sich um einen Mond
   handeln kann/muss oder nicht.
   Falls der Mond(ob ja oder nein) eindeutig feststellbar ist wird True
   zurückgegeben, und der Mond-Wert im Scan auf True bzw. False gesetzt.
   falls es nicht eindeutig ist wird False zurückgegeben und am Scan nichts
   unternommen.}

  Result := False;

  If (Report.Bericht[sg_Gebaeude,sb_Mine_array[rtMetal]] > 0)or
     (Report.Bericht[sg_Gebaeude,sb_Mine_array[rtKristal]] > 0)or
     (Report.Bericht[sg_Gebaeude,sb_Mine_array[rtDeuterium]] > 0) then
  begin
    Result := True;      //Sicher kein Mond!
    Report.Head.Position.Mond := False;
  end
  else if (Report.Bericht[sg_Gebaeude,sb_Mondbasis] > 0) then
  begin
    Result := True;      //Sicher ein Mond!
    Report.Head.Position.Mond := True;
  end
  else if (Report.Bericht[sg_Verteidigung,sb_Abfangraketen] > 0) or
          (Report.Bericht[sg_Verteidigung,sb_InterplanetarRaketen] > 0) then
  begin
    Result := True;      //Sicher kein Mond!
    Report.Head.Position.Mond := false;
  end;
       
end;

function IntToStrKP(i: Int64; kpc: char = #0): String;
var restore: char;
begin
  restore := ThousandSeparator;
  if kpc <> #0 then
    ThousandSeparator := kpc;

  Result := FloatToStrF(i,ffNumber,60000000,0);

  ThousandSeparator := restore;
end;

function SamePlanet(const Pos1, Pos2: TPlanetPosition): Boolean;
begin
  Result := (Pos1.P[0] = Pos2.P[0])and
            (Pos1.P[1] = Pos2.P[1])and
            (Pos1.P[2] = Pos2.P[2])and
            (Pos1.Mond = Pos2.Mond);
end;

PROCEDURE TReadDataXMLScanner.ScannerProcessTag(Sender : TObject; TagName : STRING; Attributes : TAttrList; Empty: Boolean);
var s: string;
    i: integer;
begin
  DecimalSeparator := '.';
  if TagName = 'updatecheck' then
    UpdateCheckUrl := Attributes.Value('url')
  else
  if TagName = 'quickupdate' then
    QuickUpdateUrl := Attributes.Value('url')
  else
  if TagName = 'raids' then
    maxraids24h := StrToIntDef(Attributes.Value('maxraids24h'),maxraids24h)
  else
  if TagName = 'game' then
  begin
    s := Attributes.Value('count');
    if s <> '' then i := StrToInt(s) else i := 0;
    SetLength(game_sites_OLD,i);
  end
  else
  if TagName = 'site' then
  begin
    s := Attributes.Value('index');
    if s <> '' then i := StrToInt(s) else i := 0;
    if (length(game_sites_OLD) <= i) then
      ShowMessage('game sites count in Data is wrong!')
    else game_sites_OLD[i] := Attributes.Value('name');
  end
  else
  if TagName = 'planets' then
  begin
    s := Attributes.Value('count');
    if (s = '')or(StrToInt(s) <> max_Planeten) then
      ShowMessage('planetcount in Data is wrong!');
  end
  else
  if copy(TagName,1,6) = 'planet' then
  begin
    i := ReadInt(TagName,7);
    s := Attributes.Value('maxtemp');
    if (i >= 1)and(i <= max_Planeten)and(s <> '') then
      maxPlanetTemp[i] := StrToFloat(s);
    s := Attributes.Value('maxtemp_redesign');
    if (i >= 1)and(i <= max_Planeten)and(s <> '') then
      maxPlanetTemp_redesign[i] := StrToFloat(s);
  end
  else
  if TagName = 'units' then
  begin
    s := Attributes.Value('groupcount');
    if (s = '')or(StrToInt(s) <> SF_Group_Count) then
      ShowMessage('groupcount in Data is wrong!');
  end
  else
  if copy(TagName,1,5) = 'group' then
  begin
    i := ReadInt(TagName,6);
    s := Attributes.Value('count');
    if (i >= 0)and(i <= SF_Group_Count-1)and(s <> '') then
    begin
      if StrToInt(s) <> scanfilecounts[TScanGroup(i)] then ShowMessage('unitcount(' + IntToStr(i) + ') in Data is wrong!');

      group := i;
      SetLength(xspio_idents[TScanGroup(i)],scanfilecounts[TScanGroup(i)]+1);

      xspio_idents[TScanGroup(i)][0] := Attributes.Value('xml');
    end else group := -1;
  end
  else
  if copy(TagName,1,4) = 'unit' then
  begin
    i := ReadInt(TagName,5);
    if (group >= 0)and(i >= 0)and(i <= scanfilecounts[TScanGroup(group)]-1) then
    begin
      xspio_idents[TScanGroup(group)][i+1] := Attributes.Value('xml');

      if (group = Integer(fleet_group)) then
      begin
        s := Attributes.Value('met');
        if s = '' then s := '0';
        fleet_resources[i][0] := StrToInt(s);
        s := Attributes.Value('crys');
        if s = '' then s := '0';
        fleet_resources[i][1] := StrToInt(s);
        s := Attributes.Value('deut');
        if s = '' then s := '0';
        fleet_resources[i][2] := StrToInt(s);
      end;
      if (group = Integer(def_group)) then
      begin
        s := Attributes.Value('met');
        if s = '' then s := '0';
        def_resources[i][0] := StrToInt(s);
        s := Attributes.Value('crys');
        if s = '' then s := '0';
        def_resources[i][1] := StrToInt(s);
        s := Attributes.Value('deut');
        if s = '' then s := '0';
        def_resources[i][2] := StrToInt(s);

        def_ignoreFight[i] := Attributes.Value('ignoreFight') = '1';
      end;
    end;
  end;
end;

PROCEDURE TReadDataXMLScanner.ScannerStartTag(Sender : TObject; TagName : STRING; Attributes : TAttrList);
begin
  ScannerProcessTag(Sender,TagName,Attributes,False);
end;

PROCEDURE TReadDataXMLScanner.ScannerEmptyTag(Sender : TObject; TagName : STRING; Attributes : TAttrList);
begin
  ScannerProcessTag(Sender,TagName,Attributes,True);
end;

PROCEDURE TReadDataXMLScanner.ScannerTagReady(Sender : TObject; TagName : STRING);
begin
  //nix!
end;

constructor TReadDataXMLScanner.Create(AOwner: TComponent);
begin
  inherited;
  OnStartTag := ScannerStartTag;
  OnEmptyTag := ScannerEmptyTag;
  OnEndTag := ScannerTagReady;
  group := -1;
end;

procedure Initialise(XML_Data_File: string);
var XMLScanner: TReadDataXMLScanner;
    sg: TScanGroup;
begin
  XMLScanner := TReadDataXMLScanner.Create(nil);
  XMLScanner.Filename := XML_Data_File;
  XMLScanner.Execute;
  XMLScanner.Free;

  for sg := low(sg) to high(sg) do
  begin
    if (Length(xspio_idents[sg]) <> ScanFileCounts[sg]+1) then
    begin
      ShowMessage('Error in datafile! xspio_idents[' + IntToStr(Integer(sg)) + ']');
      SetLength(xspio_idents[sg],ScanFileCounts[sg]+1);
    end;
  end;

  FOGameRangeList := TCoordinatesRangeList.Create;

  OGame_IsBetaUni := False;
end;

function ReadIntEx(s: string; p: integer; IgnoreChars: string = '';
  TrimChars: TTrimCharSet = ['-',' ',#9{Tab},#10]): int64;
var apos : integer;
    val : string;
begin
  apos := p;
  val := '';
  while (apos <= length(s))and(s[apos] in TrimChars) do
    inc(apos);
  while (apos <= length(s))and
        (    (s[apos] in ['0'..'9'])or(pos(s[apos],IgnoreChars) > 0)    ) do
  begin
    if (s[apos] in ['0'..'9']) then
      val := val + s[apos];
    inc(apos);
  end;
  if val <> '' then
    result := StrToInt64(val)
  else
    result := 0;
end;

function ReadInt(s: string; p: integer; tsep: Boolean = True): int64;
begin
  if tsep then
    Result := ReadIntEx(s,p,ot_tousandsseperator)
  else Result := ReadIntEx(s,p);
end;

function CountdownTimeToStr(time: TDateTime): String;
var h,m,s: integer;
    str: string;
begin
  h := trunc(time*24);
  time := time - (h/24);
  m := trunc(time*24*60);
  time := time - (m/(24*60));
  s := trunc(time*24*60*60);
  str := IntToStr(m);
  while length(str) < 2 do
    str := '0'+str;
  Result := IntToStr(h) + ':' + str + ':';
  str := IntToStr(s);
  while length(str) < 2 do
    str := '0'+str;
  Result := Result + str;
end;

function BufFleetSize: Integer;
var Fleet: TFleetEvent;
begin
  Fleet.head.unique_id := 0;  //Damit Compiler nicht warnt!

  Result := SizeOf(Fleet.head);
  Result := Result + (ScanFileCounts[sg_Flotten] * sizeof(Integer))
                   + (ScanFileCounts[sg_Rohstoffe] * sizeof(Integer));
end;

function ReadBufFleet(Buffer: Pointer): TFleetEvent;
var z: pointer;
    j: integer;
begin
  z := Buffer;
  j := SizeOf(Result.head);
  CopyMemory(@Result.head, z, j);
  z := pointer(integer(z)+j);

  SetLength(Result.ress, ScanFileCounts[sg_Rohstoffe]);
  SetLength(Result.ships, ScanFileCounts[sg_Flotten]);
  for j := 0 to ScanFileCounts[sg_Rohstoffe]-1 do
  begin
    Result.ress[j] := Integer(z^);
    z := pointer(integer(z)+sizeof(Integer));
  end;
  for j := 0 to ScanFileCounts[sg_Flotten]-1 do
  begin
    Result.ships[j] := Integer(z^);
    z := pointer(integer(z)+sizeof(Integer));
  end;
end;

procedure WriteBufFleet(const Fleet: TFleetEvent; Buffer: Pointer);
var z: pointer;
    j: integer;
begin
  z := Buffer;
  j := SizeOf(Fleet.head);
  CopyMemory(z, @Fleet.head, j);
  z := pointer(integer(z)+j);
  if length(Fleet.ships) <> ScanFileCounts[sg_Flotten] then
    raise Exception.Create('WriteBufFleet: shiplist with unexpected length');

  for j := 0 to ScanFileCounts[sg_Rohstoffe]-1 do
  begin
    Integer(z^) := Fleet.ress[j];
    z := pointer(integer(z)+sizeof(Integer));
  end;
  for j := 0 to ScanFileCounts[sg_Flotten]-1 do
  begin
    Integer(z^) := Fleet.ships[j];
    z := pointer(integer(z)+sizeof(Integer));
  end;
end;

procedure DeleteEmptyChar(var s: string);
begin
  while (length(s) > 0)and(s[1] in [' ',#9,#13,#10]) do
    delete(s,1,1);
  while (length(s) > 0)and(s[length(s)] in [' ',#9,#13,#10]) do
    delete(s,length(s),1);
end;

function PosBigger(pos1, pos2: TPlanetPosition): boolean;
begin
  Result := (pos1.P[0] > Pos2.P[0])or
            ((pos1.P[0] = Pos2.P[0])and(pos1.P[1] > Pos2.P[1]))or
            ((pos1.P[0] = Pos2.P[0])and(pos1.P[1] = Pos2.P[1])and(pos1.P[2] > Pos2.P[2]))or
            ((pos1.P[0] = Pos2.P[0])and(pos1.P[1] = Pos2.P[1])and(pos1.P[2] = Pos2.P[2])and(pos1.Mond > pos2.Mond));
end;

// returns 0 when failed to extract koords!
function ReadPosOrTime(const s: string; p: Integer; var Position: TPlanetPosition): integer;
var val : string;
    pos, i, l : integer;
begin
  Result := 0;
  pos := p;
  val := '';
  i := 0;
  l := length(s);
  while (pos <= l) and (s[pos] in ['0'..'9',':','-']) do
  begin
    if s[pos] in ['-',':'] then
    begin
      if val <> '' then
        Position.P[i] := strtoint(val)
      else
        exit;
      val := '';
      inc(i);
    end
    else
      val := val + s[pos];
    inc(pos);
  end;
  if val <> '' then
    Position.P[i] := strtoint(val)
  else
    exit;
  Result := pos;
end;

function PositionToStr_(pos: TPlanetPosition): string;
var i : integer;
begin
  Result := '';
  for i := 0 to 2 do
  begin
    result := result + inttostr(pos.P[i]);
    if i <> 2 then result := result + ':';
  end;
end;

function PositionToStrA(pos: TPlanetPosition): string;
var i : integer;
    s : string;
begin
  Result := '';
  for i := 0 to 2 do
  begin
    s := IntToStr(pos.P[i]);
    if i = 1 then
      while length(s) < 3 do
        s := '0' + s;
    if i = 2 then
      while length(s) < 2 do
        s := '0' + s;
    result := result + s;
    if i <> 2 then result := result + ':';
  end;
end;

function PositionToStrMond(Pos: TplanetPosition): string;
begin
  Result := PositionToStr_(pos);
  if Pos.Mond then Result := Result + ' ' + STR_M_Mond;
end;

function PositionToStrAMond(Pos: TPlanetPosition): string;
begin
  Result := PositionToStrA(pos);
  if Pos.Mond then Result := Result + ' ' + STR_M_Mond;
end;

function ValidPosition(pos: TPlanetPosition): boolean;
begin
  Result := (pos.p[0] > 0)and(pos.p[0] <= max_Galaxy)and
            (pos.p[1] > 0)and(pos.p[1] <= max_Systems)and
            (pos.p[2] > 0)and(pos.p[2] <= max_Planeten);
end;

function ValidPosition(pos: TSystemPosition): boolean;
begin
  Result := (pos[0] > 0)and(pos[0] <= max_Galaxy)and
            (pos[1] > 0)and(pos[1] <= max_Systems);
end;

function TrimStringChar(S: string; C: Char): String;
begin
  if Length(s) = 0 then
  if s[1] = C then
    delete(s,1,1);
  if Length(s) = 0 then
  if s[length(s)] = C then
    s := Copy(s,1,length(s)-1);
  Result := s;
end;

procedure SortPlanetScanList(var List: TReportTimeList;
  Typ: TPlanetScanListSortType);
  procedure QuickSortNR(var A: array of TReportTime; iLo, iHi: Integer);  //geklaut aus threaddemo!
  var
    Lo, Hi, Mid: Integer;
    T: TReportTime;
  begin
    Lo := iLo;
    Hi := iHi;
    Mid := A[(Lo + Hi) div 2].ID;
    repeat
      while A[Lo].ID < Mid do Inc(Lo);
      while A[Hi].ID > Mid do Dec(Hi);
      if Lo <= Hi then
      begin
        //Sleep(Time);
        //VisualSwap(A[Lo], A[Hi], Lo, Hi);
        T := A[Lo];
        A[Lo] := A[Hi];
        A[Hi] := T;
        Inc(Lo);
        Dec(Hi);
      end;
    until Lo > Hi;
    if Hi > iLo then QuickSortNR(A, iLo, Hi);
    if Lo < iHi then QuickSortNR(A, Lo, iHi);
  end;
  procedure QuickSortAlter(var A: array of TReportTime; iLo, iHi: Integer);  //geklaut aus threaddemo!
  var
    Lo, Hi: Integer;
    Mid: TDateTime;
    T: TReportTime;
  begin
    Lo := iLo;
    Hi := iHi;
    Mid := A[(Lo + Hi) div 2].Time_u;
    repeat
      while A[Lo].Time_u < Mid do Inc(Lo);
      while A[Hi].Time_u > Mid do Dec(Hi);
      if Lo <= Hi then
      begin
        //Sleep(Time);
        //VisualSwap(A[Lo], A[Hi], Lo, Hi);
        T := A[Lo];
        A[Lo] := A[Hi];
        A[Hi] := T;
        Inc(Lo);
        Dec(Hi);
      end;
    until Lo > Hi;
    if Hi > iLo then QuickSortAlter(A, iLo, Hi);
    if Lo < iHi then QuickSortAlter(A, Lo, iHi);
  end;
begin
  case Typ of
  pslst_Nummer: QuickSortNR(List, Low(List), High(List));
  pslst_Alter: QuickSortAlter(List, Low(List), High(List));
  end;
end; 

function CalcScanRess_Now_(Scan: TScanBericht; const Mine: TRessType;
  alter_h: single; production_per_h: TcSResource): TcSResource;
var max, ress: TcSResource;
begin
  if (Mine > rtDeuterium) then
    raise Exception.Create('function CalcScanProductionRess: wrong Mine parameter!');

  max := GetStorageSize(Scan, Mine);

  ress := Scan.Bericht[sg_Rohstoffe,sb_Ress_array[mine]];

  if ress > max then  //Wenn schon mehr als Speicherkapazitär erlaubt -> keine Produktion!
    Result := ress
  else
  begin
    Result := ress + trunc(alter_h * production_per_h);
    //Wenn Produktion höher als Speicherkapazität erlaubt -> Voll, und nicht mehr!!
    if Result > max then
      Result := max;
  end;
end;

function GetMineEnergyConsumption(Scan: TScanbericht): Integer;
var stufe: integer;
    mine: TRessType;
const konst_a: array[rtMetal..rtDeuterium] of Integer = (10, 10, 20);
begin
  //Wenn Gebäude nicht bekannt:
  if Scan.Bericht[sg_Gebaeude, 0] < 0 then
  begin
    Result := -1;
    Exit;
  end;

  // Ansonsten:
  Result := 0;
  for mine := rtMetal to rtDeuterium do
  begin
    stufe := Scan.Bericht[sg_Gebaeude,sb_Mine_array[mine]];
    if stufe >= 0 then
      Result := Result + Ceil( konst_a[mine]*stufe*IntPower(1.1, stufe) );
  end;
end;

function calcPlanetTemp(solsatenergy: single): single;
begin
  solsatenergy := solsatenergy + 0.5; // Aufgrund Abrundung bei Energieberechnung in OGame
                                      // kann der "Echte" Wert zwischen
                                      // Solsatenergy und (Solsatenergy+1) liegen
                                      // -> Mittelwert ist meist genauer

  if OGame_IsBetaUni then
    Result := (solsatenergy * 6) - 140
  else
    Result := (solsatenergy - 20) * 4;
end;

function calcSolSatEnergy(Scan: TScanBericht): Integer;
var enrgy_SolKW, enrgy_FusionKW, gesammt: integer;
    stufe_SolKW, stufe_FusionKW, anzahl_solsat: integer;
    stufe_energytech: Integer;
begin
  Result := -1;

  gesammt := Scan.Bericht[sg_Rohstoffe,sb_Ress_array[rtEnergy]];
  
  stufe_SolKW := Scan.Bericht[sg_Gebaeude,sb_SolKW];
  if stufe_SolKW < 0 then Exit;
  
  stufe_FusionKW := Scan.Bericht[sg_Gebaeude,sb_FusionsKW];
  if stufe_FusionKW < 0 then Exit;

  stufe_energytech := Scan.Bericht[sg_Forschung,sb_Energietechnik];
  if stufe_energytech < 0 then Exit;

  anzahl_solsat := Scan.Bericht[sg_Flotten,sb_SolSat];
  if anzahl_solsat <= 0 then Exit;

  enrgy_SolKW := trunc( 20*stufe_SolKW* IntPower(1.1,stufe_SolKW) );
  enrgy_FusionKW := trunc( 30*stufe_FusionKW*
             IntPower((1.05 + stufe_energytech * 0.01),stufe_FusionKW) );

  Result := trunc((gesammt - enrgy_SolKW - enrgy_FusionKW) / anzahl_solsat);
end;

function calcProduktionsFaktor(Scan: TScanBericht; out needed_energy: Integer): single;
begin
  needed_energy := GetMineEnergyConsumption(Scan);
  if needed_energy >= 0 then
  begin
    if needed_energy = 0 then
      Result := 1
    else
    begin
      Result := Scan.Bericht[sg_Rohstoffe,sb_Ress_array[rtEnergy]]
                           / needed_energy;

      if Result > 1 then Result := 1;
    end;
  end
  else
    Result := -1;
end;

function GetMineProduction_(const Scan: TScanBericht;
  const SpeedFactor: Single;
  const Mine: TRessType;
  const prod_faktor: single;
  const calcMaxTemp: single): TcSResource;
var maxTemp: single;
begin
  if Scan.Head.Position.Mond then  //UHO: 26.08.08 Monde haben keine Produktion!!
  begin
    Result := 0;
  end
  else
  begin
    //Einkommen durch Minen:
    case Mine of
    {omAll:
      begin
        Result := {Grundeinkommen 20met, 10kris}{ 30;
        for M := omMetal to omDeuterium do
          Result := Result + MineProduction(Scan.Bericht[sg_Gebaeude,sb_Mine_array[M]],M,Scan.Head.Position.P[2]);
      end;                                       }
    rtMetal: Result := {Grundeinkommen 20met} 20 +
        MineProduction(Scan.Bericht[sg_Gebaeude,sb_Mine_array[Mine]],
                        Mine,
                        prod_faktor,
                        -1); // temperature is not needed for MetalMine
    rtKristal: Result := {Grundeinkommen 10kris} 10 +
        MineProduction(Scan.Bericht[sg_Gebaeude,sb_Mine_array[Mine]],
                        Mine,
                        prod_faktor,
                        -1); // temperature is not needed for Crystal mine
    rtDeuterium:
      begin
        if IsNan(calcMaxTemp) then
        begin
          if OGame_IsBetaUni then
            maxTemp := maxPlanetTemp_redesign[Scan.Head.Position.P[2]]
          else
            maxTemp := maxPlanetTemp[Scan.Head.Position.P[2]];
        end
        else
          maxTemp := calcMaxTemp;

        Result := MineProduction(Scan.Bericht[sg_Gebaeude,sb_Mine_array[Mine]],
                                  Mine,
                                  prod_faktor,
                                  maxTemp);
        Result := Result - FusionsKWDeut(Scan.Bericht[sg_Gebaeude,sb_FusionsKW]);
        if (Result < 0) then Result := 0;
      end;
    rtEnergy: Result := 0; {Es gibt keine Mine für Energie ^^}
    else
      raise Exception.Create('GetMineProduction: Unknown type of mine!');
    end;
    //Speedfactor miteinberechnen:
    Result := trunc(Result * SpeedFactor);
  end;
end;

function MineProduction(Stufe: Integer; Mine: TRessType;
  prod_faktor: single; planetTempMax: single): TcSResource;
begin
  if Stufe <= 0 then
    Result := 0
  else
  begin
    case Mine of
      rtMetal: Result := trunc(30 * Stufe * IntPower(1.1,Stufe));
      rtKristal: Result := trunc(20 * Stufe * IntPower(1.1,Stufe));
      rtDeuterium:
        if OGame_IsBetaUni then
          Result := trunc(10 * Stufe * IntPower(1.1,Stufe)
            * (1.44 - (0.004 * planetTempMax)))
        else
          Result := trunc(10 * Stufe * IntPower(1.1,Stufe)
            * (-0.002 * planetTempMax + 1.28));
    else
      raise Exception.Create('MineProduction: Unknown type of mine for calculation!');
    end;

    Result := trunc(Result * prod_faktor);
  end;
end;

function CalcTF(Scan: TScanBericht): TResources;

  procedure AddToResult(res: TResources; count: integer; faktor: Double);
  var r: integer;
  begin
    for r := 0 to length(res)-1 do
      Result[r] := Result[r] + round((res[r]*count)*faktor);
  end;

var i: integer;
begin
  FillChar(Result,Sizeof(result),0);  //alles 0 setzen!

  // Normale Flotte
  for i := 0 to ScanFileCounts[fleet_group]-1 do
    if (Scan.Bericht[fleet_group,i] > 0) then
      AddToResult(fleet_resources[i], Scan.Bericht[fleet_group,i], TF_faktor_Fleet);

  // Verteidigung
  if TF_faktor_Def > 0 then
    for i := 0 to ScanFileCounts[def_group]-1 do
    if not def_ignoreFight[i] then
      begin
        if (Scan.Bericht[def_group,i] > 0) then
          AddToResult(def_resources[i], Scan.Bericht[def_group,i], TF_faktor_Def);
      end;

  Result[2] := 0; //Deut kommt nicht ins TF!
end;

function FusionsKWDeut(stufe: integer): integer;
begin
  if stufe > 0 then Result := trunc(10 * Stufe * IntPower(1.1,Stufe))
  else Result := 0;
end;

function NextPlanet(var Pos: TPlanetPosition): Boolean;
begin
  Result := True;
  Pos.Mond := not Pos.Mond;
  If Pos.Mond = False then
  begin
    Pos.P[2] := Pos.P[2] +1;
    if Pos.P[2] > max_Planeten then
    begin
      Pos.P[2] := 1;
      Pos.P[1] := Pos.P[1] +1;
      if Pos.P[1] > max_Systems then
      begin
        Pos.P[1] := 1;
        Pos.P[0] := Pos.P[0] +1;
        Result := Pos.P[0] <= max_Galaxy;
      end;
    end;
  end;
end;

function StrToPosition(S: string): TPlanetPosition;
begin
  FillChar(result,sizeof(Result),0);
  s := s + '    abs  ';
  Result.Mond := (s[ReadPosOrTime(s,1,Result)+1] = STR_M_Mond);
end;

function StrToPositionEx(S: string): TPlanetPosition;
var p: integer;
begin
  if s[1] = '[' then
    s := copy(s, 2, 999); // remove first'['
  FillChar(result,sizeof(Result),0);
  s := s + '    abs'; // be sure string does not end exactly after coords
  p := ReadPosOrTime(s,1,Result)+1;
  if (p <= 0) or (p >= length(s)) then
    raise Exception.Create('StrToPositionM(): failed to read coordinates!');
  while (s[p] = ' ') do inc(p); // skip spaces
  Result.Mond := (s[p] = STR_M_Mond);
end;

function CompareSys(Sys1, Sys2: TSystemCopy;
  ignoreTime: Boolean = False): string;
var i: integer;
    s: string;
begin
  s := '';
  If (not ignoreTime) and (Sys1.Time_u <> Sys2.Time_u)
    then s := s + ' Zeit!';

  for i := 1 to max_planeten do
  begin
    if Sys1.Planeten[i].Player     <> Sys2.Planeten[i].Player     then s := s + IntToStr(i) + Format(' Player(%s|%s)!'    , [Sys1.Planeten[i].Player,     Sys2.Planeten[i].Player]);;
    if Sys1.Planeten[i].PlayerId   <> Sys2.Planeten[i].PlayerId   then s := s + IntToStr(i) + Format(' PlayerID(%d|%d)!'  , [Sys1.Planeten[i].PlayerId,   Sys2.Planeten[i].PlayerId]);;
    if Sys1.Planeten[i].PlanetName <> Sys2.Planeten[i].PlanetName then s := s + IntToStr(i) + Format(' PlanetName(%s|%s)!', [Sys1.Planeten[i].PlanetName, Sys2.Planeten[i].PlanetName]);
    if Sys1.Planeten[i].Ally       <> Sys2.Planeten[i].Ally       then s := s + IntToStr(i) + Format(' Ally(%s|%s)!'      , [Sys1.Planeten[i].Ally,       Sys2.Planeten[i].Ally]);
    if Sys1.Planeten[i].AllyId     <> Sys2.Planeten[i].AllyId     then s := s + IntToStr(i) + Format(' AllyID(%d|%d)!'    , [Sys1.Planeten[i].AllyId,     Sys2.Planeten[i].AllyId]);
    if Sys1.Planeten[i].Status     <> Sys2.Planeten[i].Status     then s := s + IntToStr(i) + Format(' Status(%d|%d)!'    , [WORD(Sys1.Planeten[i].Status), WORD(Sys2.Planeten[i].Status)]);
    if Sys1.Planeten[i].MondSize   <> Sys2.Planeten[i].MondSize   then s := s + IntToStr(i) + Format(' MondSize(%d|%d)!'  , [Sys1.Planeten[i].MondSize,   Sys2.Planeten[i].MondSize]);
    if Sys1.Planeten[i].MondTemp   <> Sys2.Planeten[i].MondTemp   then s := s + IntToStr(i) + Format(' MondTemp(%d|%d)!'  , [Sys1.Planeten[i].MondTemp,   Sys2.Planeten[i].MondTemp]);
    if Sys1.Planeten[i].TF[0]      <> Sys2.Planeten[i].TF[0]      then s := s + IntToStr(i) + Format(' TF[0](%d|%d)!'     , [Sys1.Planeten[i].TF[0],      Sys2.Planeten[i].TF[0]]);
    if Sys1.Planeten[i].TF[1]      <> Sys2.Planeten[i].TF[1]      then s := s + IntToStr(i) + Format(' TF[1](%d|%d)!'     , [Sys1.Planeten[i].TF[1],      Sys2.Planeten[i].TF[1]]);
    if Sys1.Planeten[i].Activity   <> Sys2.Planeten[i].Activity   then s := s + IntToStr(i) + Format(' Activity(%d|%d)!'  , [Sys1.Planeten[i].Activity,   Sys2.Planeten[i].Activity]);
  end;
  Result := '';
  if s <> '' then
    Result := ('System: ' + PositionToStrMond(Sys1.System) + '  ' + S);
end;

function CompareScans(Scan1, Scan2: TScanBericht): string;
var j: integer;
    sg: TScanGroup;
begin
  Result := '';
  if Scan1.Head.Planet         <> Scan2.Head.Planet          then Result := Result + ' Planetenname!';
  if not SamePlanet(Scan1.Head.Position,Scan2.Head.Position) then Result := Result + ' Position!';
  if Scan1.Head.Time_u         <> Scan2.Head.Time_u          then Result := Result + ' Time!';

  if Scan1.Head.Spieler        <> Scan2.Head.Spieler         then Result := Result + ' Spieler!';  //-> bei XML nicht dabei!
  if Scan1.Head.SpielerId      <> Scan2.Head.SpielerId       then Result := Result + ' SpielerID!';  //-> bei XML nicht dabei!

  if Scan1.Head.Spionageabwehr <> Scan2.Head.Spionageabwehr  then Result := Result + ' Spionageabwehr!';
  if Scan1.Head.Creator        <> Scan2.Head.Creator         then Result := Result + ' Creator!';

  if Scan1.Head.Activity       <> Scan2.Head.Activity        then Result := Result + ' Activity!';

  for sg := low(sg) to high(sg) do
  begin
    for j := 0 to ScanFileCounts[sg]-1 do
    begin
      if Scan1.Bericht[sg,j] <> Scan2.Bericht[sg,j] then
        Result := Result + ' [' + IntToStr(byte(sg)) + '][' + IntToStr(j+1) +
                           '](' + IntToStr(Scan1.Bericht[sg,j]) +
                           '/' + IntToStr(Scan2.Bericht[sg,j]) + ')';
    end;
  end;
end;

function FleetEventTypeToNameStr(fj: TFleetEventType): string;
begin
  Result := FleetEventTypeNames[fj];
end;

function FleetEventTypeToStr_(fj: TFleetEventType): string;
begin
  Result := FleetEventTypeTranslate_[fj];
end;

function FleetEventTypeToStrEx_(flt: TFleetEvent): string;
begin
  Result := FleetEventTypeTranslate_[flt.head.eventtype];
  if fef_return in flt.head.eventflags then
    Result := Result + ' (R)';
  if fef_friendly in flt.head.eventflags then
    Result := Result + ', freundlich';
  if fef_neutral in flt.head.eventflags then
    Result := Result + ', neutral';
  if fef_hostile in flt.head.eventflags then
    Result := Result + ', feindlich';
end;

function SameFleetEvent(Fleet1, Fleet2: TFleetEvent): Boolean;
begin
  Result := (Fleet1.Head.unique_id = Fleet2.Head.unique_id)and
            (Fleet1.Head.eventtype = Fleet2.Head.eventtype)and
            (Fleet1.Head.eventflags = Fleet2.Head.eventflags)and
            (SamePlanet(Fleet1.Head.origin,Fleet2.Head.origin))and
            (SamePlanet(Fleet1.Head.target,Fleet2.Head.target))and
            (Fleet1.Head.arrival_time_u = Fleet2.Head.arrival_time_u)and
            (Fleet1.Head.player = Fleet2.Head.player)and
            (Fleet1.Head.joined_id = Fleet2.Head.joined_id);
end;

constructor TOGameOptions.Create(XML_Data_File: string);
begin
  inherited Create;
end;

function OGameRangeList: TCoordinatesRangeList;
var r: TCoordinatesRange;
begin
  FOGameRangeList.Clear;

  r.start := 1;
  r.ende := max_Galaxy;
  FOGameRangeList.AddRange(r);
  r.start := 1;
  r.ende := max_Systems;
  FOGameRangeList.AddRange(r);
  r.start := 1;
  r.ende := max_Planeten;
  FOGameRangeList.AddRange(r);
  Result := FOGameRangeList;
end;

function AbsPlanetNrToPlanetPosition(nr: TAbsPlanetNr): TPlanetPosition;
begin
  //Written and tested by Ulrich Hornung, 20.10.2007

  Result.Mond := (nr mod 2) = 1;
  nr := nr div 2;
  Result.P[2] := 1+ (nr mod max_Planeten);
  nr := nr div max_Planeten;
  Result.P[1] := 1+ (nr mod max_Systems);
  nr := nr div max_Systems;
  if (1+nr > high(Result.P[0])) then
    raise Exception.Create('AbsPlanetNrToPlanetPosition: Bereich für P[0] ist überschritten!');
  Result.P[0] := 1+ nr; //(nr mod max_Galaxy);
end;

function PlanetPositionToAbsPlanetNr(pos: TPlanetPosition): TAbsPlanetNr;
begin
  //Written and tested by Ulrich Hornung, 20.10.2007

  Result := (pos.P[0]-1)*max_Systems*max_Planeten*2 +
            (pos.P[1]-1)*max_Planeten*2 +
            (pos.P[2]-1)*2; // 2 = max_Monde
  if pos.Mond then
    inc(Result);
end;

function GetStorageSize(scan: TScanBericht; resstype: TRessType): TcSResource;
var speicherstufe: integer;
begin
  speicherstufe := Scan.Bericht[sg_Gebaeude,sb_Speicher_array[resstype]];
  if speicherstufe < 0 then speicherstufe := 0;

  //Berechnung Speicherkapazität:
  try
    if not OGame_IsBetaUni then
      Result := (1+ (ceil(  IntPower(1.6,speicherstufe)  ))) * 50000   // Alte Unis
    else
      Result := trunc(2.5*IntPower(1.833195477,speicherstufe))*5000;  // Neue Unis
      //ABRUNDEN(2,5*1,833195477^Stufe)*5000
  except
    Result := 0;
  end;
end;

function GetScanGrpCount(Scan: TScanBericht): integer;
var g: TScanGroup;
begin
  Result := 0;
  for g := low(g) to high(g) do
  begin
    if (Scan.Bericht[g,0] >= 0) then
      inc(Result);
  end;
end;

{ TScanBericht }

procedure TScanBericht.clear;
begin
  if fReadOnly then raise Exception.Create('TScanBericht.clear(): Report is read Only!');

  FillChar(Head,      sizeof(Head),       0);
  FillChar(resources, sizeof(resources), -1);
  FillChar(fleets,    sizeof(fleets),    -1);
  FillChar(defence,   sizeof(defence),   -1);
  FillChar(buildings, sizeof(buildings), -1);
  FillChar(research,  sizeof(research),  -1);
end;

function TScanBericht.copy: TScanBericht;
begin
  Result := TScanBericht.Create;
  Result.copyFrom(Self);
end;

procedure TScanBericht.copyFrom(scan: TScanBericht);
var j: integer;
    sg: TScanGroup;
begin
  if fReadOnly then
    raise Exception.Create('TScanBericht.copyFrom(): Report is read Only!');

  Head := Scan.Head;
  for sg := low(sg) to high(sg) do
  begin
    for j := 0 to ScanFileCounts[sg]-1 do
      Bericht[sg,j] := Scan.Bericht[sg,j];
  end;
end;

constructor TScanBericht.Create;
begin
  inherited;
  Head.Time_u := 0;
  fReadOnly := false;
end;

destructor TScanBericht.Destroy;
begin
  if fReadOnly then
    raise Exception.Create('TScanBericht.Destroy(): Report is read Only!');
    
  inherited;
end;

function TScanBericht.getElement(sg: TScanGroup; index: integer): Int64;
begin
  // check boundings:
  if (index >= ScanFileCounts[sg]) then
    raise Exception.Create(
      'TScanBericht.getElement(): Zugriff auf nicht existierendes Element!');

  case sg of
  sg_Rohstoffe:    Result := resources[index];
  sg_Flotten:      Result := fleets   [index];
  sg_Verteidigung: Result := defence  [index];
  sg_Gebaeude:     Result := buildings[index];
  sg_Forschung:    Result := research [index];
  else
    raise Exception.Create('TScanBericht.getElement(): unknown ScanGroup!');
  end;
end;

procedure TScanBericht.setElement(sg: TScanGroup; index: integer;
  const Value: Int64);
begin
  if fReadOnly then
    raise Exception.Create('TScanBericht.setElement(): Report is read Only!');

  // check boundings:
  if (index >= ScanFileCounts[sg]) then
    raise Exception.Create(
      'TScanBericht.getElement(): Zugriff auf nicht existierendes Element!');

  case sg of
  sg_Rohstoffe:    resources[index] := Value;
  sg_Flotten:      fleets   [index] := Value;
  sg_Verteidigung: defence  [index] := Value;
  sg_Gebaeude:     buildings[index] := Value;
  sg_Forschung:    research [index] := Value;
  else
    raise Exception.Create('TScanBericht.getElement(): unknown ScanGroup!');
  end;
end;

procedure TScanBericht.serialize(stream: TAbstractFixedMemoryStream);
begin
  stream.WriteBuffer(Head,      sizeof(Head));
  stream.WriteBuffer(resources, sizeof(resources));
  stream.WriteBuffer(fleets,    sizeof(fleets));
  stream.WriteBuffer(defence,   sizeof(defence));
  stream.WriteBuffer(buildings, sizeof(buildings));
  stream.WriteBuffer(research,  sizeof(research));
end;

procedure TScanBericht.deserialize(stream: TAbstractFixedMemoryStream);
begin
  if fReadOnly then
    raise Exception.Create('TScanBericht.deserialize(): Report is read Only!');

  stream.ReadBuffer(Head,      sizeof(Head));
  stream.ReadBuffer(resources, sizeof(resources));
  stream.ReadBuffer(fleets,    sizeof(fleets));
  stream.ReadBuffer(defence,   sizeof(defence));
  stream.ReadBuffer(buildings, sizeof(buildings));
  stream.ReadBuffer(research,  sizeof(research));
end;

function TScanBericht.serialize_size: cardinal;
begin
  Result := sizeof(Head) + sizeof(resources) + sizeof(fleets) +
    sizeof(defence) + sizeof(buildings) + sizeof(research);
end;

class function TScanBericht.Count(sg: TScanGroup): Integer;
begin
  Result := ScanFileCounts[sg];
end;

procedure TScanBericht.lock;
begin
  fReadOnly := True;
end;

procedure TScanBericht.unlock;
begin
  fReadOnly := false;
end;

{ TReportList }

procedure TReadReportList.clear;
begin
  while flist.Count > 0 do
  begin
    TReadReport(flist[0]).Free;
    flist.Delete(0);
  end;
end;

function TReadReportList.Count: integer;
begin
  Result := flist.Count;
end;

constructor TReadReportList.Create;
begin
  inherited;
  flist := TList.Create;
end;

destructor TReadReportList.Destroy;
begin
  clear;
  flist.Free;
  inherited;
end;

function TReadReportList.getReport(index: integer): TReadReport;
begin
  Result := TReadReport(flist[index]);
end;

function TReadReportList.push_back(scan: TReadReport): integer;
var myscan: TReadReport;
begin
  myscan := TReadReport.Create;
  myscan.copyFrom(scan);
  myscan.AskMoon := scan.AskMoon;
  result := flist.Add(myscan);
end;

initialization
  ot_tousandsseperator := '.';

end.
