unit OGame_Types;

interface

uses
  Sysutils, {$IFNDEF TEST}Languages,{$ENDIF} Math, LibXmlParser, LibXmlComps,
  Classes, Dialogs, clipbrd, windows, CoordinatesRanges;

type
  TRessType = (rtMetal, rtKristal, rtDeuterium, rtEnergy);
  TLanguage = Word;
  TScanGroup = (sg_Rohstoffe, sg_Flotten, sg_Verteidigung, sg_Gebaeude,
                sg_Forschung);

const
  {$IFDEF TEST} STR_M_Mond = 'M'; {$ENDIF}

  max_Galaxy: word = 9;
  max_Systems: word = 499;

  truemmerfeld_faktor: Double = 0.3; //normal 30%      

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
  fsc_1_Flotten = 14;
  fleet_group = sg_Flotten;
  fsc_2_Verteidigung = 10;
  def_group = sg_Verteidigung;
  fsc_3_Gebaeude = 18;

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
  sb_FusionsKW = 4{FKW};
  fsc_4_Forschung = 16;
  sb_Waffentechnik = 2;
  sb_Schildtechnik = 3;
  sb_Raumschiffpanzerung = 4;
  sb_Intergal_ForschNetz = 13{Intergal.Forsch.Netz};
  sb_Expeditionstechnik = 14{Expeditionstechnik};
  sb_Gravitonforschung = 15{Gravitonforschung};

  sb_Abfangraketen = 8;
  sb_InterplanetarRaketen = 9;
  {$ENDIF}

  ScanFileCounts: array[TScanGroup] of integer =
    (fsc_0_Rohstoffe,fsc_1_Flotten,fsc_2_Verteidigung,fsc_3_Gebaeude,fsc_4_Forschung);
  //------------------------------------------------------------------------

  sys_playerstat_urlaub = 3;
  sys_playerstat_noob = 4;
type
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
    PlanetName: TPlanetName;
    Ally: TAllyName;
    Status: TStatus;
    MondSize: Word;
    MondTemp: SmallInt;
    TF: array[0..1] of Cardinal;
  end;
  PSystemCopy = ^TSystemCopy; 
  TSystemCopy = record
    Time_u : Int64;  //Unix
    System : TPlanetPosition; //nur 0,1 wird dann verwendet!
    Planeten : Array[1..max_Planeten] of TSystemPlanet;
  end;
  TSystemPosition = Array[0..1] of Word;
  TSolSysPosition = TSystemPosition;
  TScanHead = record
    Planet: TPlanetName;
    Position: TPlanetPosition;
    Time_u: Int64;    //Unix
    Spieler: TPlayerName;
    Spionageabwehr: integer;
    Creator: TPlayerName;
    {geraidet: Boolean;
    von: TPlayerName;}
    Activity: Integer; {Time in Seconds (min*60) befor Time_u, -1 -> no info, 0 -> activity > 60 minutes}
  end;
  TInfoArray = array of integer;
  PScanBericht = ^TScanBericht;
  TScanBericht = record
    Head: TScanHead;
    Bericht: array[TScanGroup] of TInfoArray;
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
    Stats: array[0..99] of TStatPlayer;
    Time_u: Int64;
  end;
  TredHoursTypes = (rh_Scans, rh_Systems, rh_Stats, rh_Points);
  TredHours = array[TredHoursTypes] of Integer;
  TResources = array[0..2] of Int64;
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
    fet_colony      //Kolonisieren
  );
  const
  FleetEventTypeTranslate: array[TFleetEventType] of string = (
    'none',
    'deploy',
    'transport',
    'attack',
    'espionage',
    'harvest',
    'colony'
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
  game_sites: array of String;
  xspio_idents: array[TScanGroup] of array of String;
  maxPlanetTemp: array[1..max_Planeten] of single;
  fleet_resources: array[0..fsc_1_Flotten-1] of Tresources;
  def_resources: array[0..fsc_2_Verteidigung-1] of Tresources;

  // Interplanetarraketen und Abfangraketen werden nicht ins TF gerechnet, da
  // sie nie am Kampf teilnehmen!  (wird aus der xml-datei gelesen)
  // def_ignoreTF == true heist also -> nicht ins TF reinrechnen
  def_ignoreFight: array[0..fsc_2_Verteidigung-1] of Boolean;
  ot_tousandsseperator: string;
  UpdateCheckUrl: string;
  FOGameRangeList: TCoordinatesRangeList;

  // Uni6 BetaUni
  OGame_IsBetaUni: Boolean;


function FleetEventTypeToStrEx(flt: TFleetEvent): string;
function FleetEventTypeToStr(fj: TFleetEventType): string;
function ReadBufScan(Buffer: Pointer): TScanBericht;
function WriteBufScan(Scan: TScanBericht; var Buf: pointer): integer;
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
function ReadInt(s: string; p: integer; tsep: Boolean = True): integer;
function ReadIntEx(s: string; p: integer; IgnoreChars: string = '';
  TrimChars: TTrimCharSet = ['-',' ',#9{Tab},#10]): integer;
procedure SortPlanetScanList(var List: TReportTimeList;
  Typ: TPlanetScanListSortType);
function GetMineEnergyConsumption(Scan: TScanbericht): Integer;
function calcProduktionsFaktor(Scan: TScanBericht; var needed_energy: Integer): single;
function GetMineProduction_(Scan: TScanBericht; const SpeedFactor: Single;
  const Mine: TRessType; prod_faktor: single): Integer;
function MineProduction(Stufe: Integer; Mine: TRessType; planetPos: integer;
  prod_faktor: single): Integer;
procedure Initialise(XML_Data_File: string);
function CalcTF(Scan: TScanBericht; DefInTF: Boolean): Tresources;
function FusionsKWDeut(stufe: integer): integer;
function NextPlanet(var Pos: TPlanetPosition): Boolean;
function CompareSys(Sys1, Sys2: TSystemCopy;
  ignoreTime: Boolean = False): string;
function CompareScans(Scan1, Scan2: TScanBericht): string;
function SamePlanet(const Pos1, Pos2: TPlanetPosition): Boolean;
function IntToStrKP(i: Int64; kpc: char = #0): String;
function PosBigger(pos1, pos2: TPlanetPosition): boolean;
function StrToPosition(S: string): TPlanetPosition;
function SameFleetEvent(Fleet1, Fleet2: TFleetEvent): Boolean;
function ScanSize: integer;
function OGameRangeList: TCoordinatesRangeList;
function AbsPlanetNrToPlanetPosition(nr: TAbsPlanetNr): TPlanetPosition;
function PlanetPositionToAbsPlanetNr(pos: TPlanetPosition): TAbsPlanetNr;
function checkMoonScan(var Report: TScanBericht): Boolean;
function NewScanBericht(Source: TScanBericht): TScanBericht;
procedure ClearScanBericht(var scan: TScanBericht);
function BufFleetSize: Integer;
function ReadBufFleet(Buffer: Pointer): TFleetEvent;
procedure WriteBufFleet(const Fleet: TFleetEvent; Buffer: Pointer);
function CalcScanRess_Now(Scan: TScanBericht; const Mine: TRessType;
  alter_h: single; production_per_h: integer): Integer;
function GetStorageSize(scan: TScanBericht; resstype: TRessType): integer;
function GetScanGrpCount(Scan: TScanBericht): integer;


implementation

function NewScanBericht(Source: TScanBericht): TScanBericht;
var j: integer;
    sg: TScanGroup;
begin
  Result.Head := Source.Head;
  for sg := low(sg) to high(sg) do
  begin
    SetLength(Result.Bericht[sg],ScanFileCounts[sg]);
    for j := 0 to ScanFileCounts[sg]-1 do
      Result.Bericht[sg,j] := Source.Bericht[sg,j];
  end;
end;

procedure ClearScanBericht(var scan: TScanBericht);
var j: integer;
    sg: TScanGroup;
begin
  FillChar(scan.Head, sizeof(scan.Head), 0);

  for sg := low(sg) to high(sg) do
  begin
    SetLength(scan.Bericht[sg],ScanFileCounts[sg]);
    for j := 0 to ScanFileCounts[sg]-1 do
      scan.Bericht[sg,j] := 0;
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
  end;
end;


function ScanSize: integer;
var sg: TScanGroup;
begin
  Result := sizeof(TScanHead);
  for sg := low(sg) to high(sg) do
    Result := Result + (sizeof(Integer) * ScanFileCounts[sg]);
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
  if TagName = 'raids' then
    maxraids24h := StrToIntDef(Attributes.Value('maxraids24h'),maxraids24h)
  else
  if TagName = 'game' then
  begin
    s := Attributes.Value('count');
    if s <> '' then i := StrToInt(s) else i := 0;
    SetLength(game_sites,i);
  end
  else
  if TagName = 'site' then
  begin
    s := Attributes.Value('index');
    if s <> '' then i := StrToInt(s) else i := 0;
    if (length(game_sites) <= i) then
      ShowMessage('game sites count in Data is wrong!')
    else game_sites[i] := Attributes.Value('name');
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
  TrimChars: TTrimCharSet = ['-',' ',#9{Tab},#10]): integer;
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
    result := strtoint(val)
  else
    result := 0;
end;

function ReadInt(s: string; p: integer; tsep: Boolean = True): integer;
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

function ReadBufScan(Buffer: Pointer): TScanBericht;
var z: pointer;
    j: integer;
    sg: TScanGroup;
begin
  z := Buffer;
  Result.Head := TScanHead(z^);
  z := pointer(integer(z)+sizeof(TScanHead));
  for sg := low(sg) to high(sg) do
  begin
    SetLength(Result.Bericht[sg],ScanFileCounts[sg]);
    for j := 0 to ScanFileCounts[sg]-1 do
    begin
      Result.Bericht[sg,j] := Integer(z^);
      z := pointer(integer(z)+sizeof(Integer));
    end;
  end;                          
end;

function WriteBufScan(Scan: TScanBericht; var Buf: pointer): integer;
var j: integer;
    z: pointer;
    sg: TScanGroup;
begin
  Result := 0;
  z := buf;
  TScanHead(z^) := Scan.Head;
  z := pointer(integer(z)+sizeof(TScanHead));
  for sg := low(sg) to high(sg) do
  begin
    if length(Scan.Bericht[sg]) = ScanFileCounts[sg] then
    for j := 0 to ScanFileCounts[sg]-1 do
    begin
      Integer(z^) := Scan.Bericht[sg,j];
      z := pointer(integer(z)+sizeof(Integer));
    end;
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

function CalcScanRess_Now(Scan: TScanBericht; const Mine: TRessType;
  alter_h: single; production_per_h: integer): Integer;
var max, ress: Integer;
begin
  if (Mine > rtDeuterium) then
    raise Exception.Create('function CalcScanProductionRess: wrong Mine parameter!');

  max := GetStorageSize(Scan, Mine);

  ress := Scan.Bericht[sg_Rohstoffe][sb_Ress_array[mine]];

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

function calcProduktionsFaktor(Scan: TScanBericht; var needed_energy: Integer): single;
begin
  needed_energy := GetMineEnergyConsumption(Scan);
  if needed_energy <> 0 then
  begin
    Result := Scan.Bericht[sg_Rohstoffe][sb_Ress_array[rtEnergy]]
                         / needed_energy;

    if Result > 1 then Result := 1;
  end
  else
    Result := 1;
end;

function GetMineProduction_(Scan: TScanBericht; const SpeedFactor: Single;
  const Mine: TRessType; prod_faktor: single): Integer;
//var M: TRessType;
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
                        Scan.Head.Position.P[2],
                        prod_faktor);
    rtKristal: Result := {Grundeinkommen 10kris} 10 +
        MineProduction(Scan.Bericht[sg_Gebaeude,sb_Mine_array[Mine]],
                        Mine,
                        Scan.Head.Position.P[2],
                        prod_faktor);
    rtDeuterium:
      begin
        Result := MineProduction(Scan.Bericht[sg_Gebaeude,sb_Mine_array[Mine]],
                                  Mine,
                                  Scan.Head.Position.P[2],
                                  prod_faktor);
        Result := Result - FusionsKWDeut(Scan.Bericht[sg_Gebaeude,sb_FusionsKW]);
      end;
    rtEnergy: Result := 0; {Es gibt keine Mine für Energie ^^}
    else
      raise Exception.Create('GetMineProduction: Unknown type of mine!');
    end;
    //Speedfactor miteinberechnen:
    Result := trunc(Result * SpeedFactor);
  end;
end;

function MineProduction(Stufe: Integer; Mine: TRessType; planetPos: integer;
  prod_faktor: single): integer;
begin
  if Stufe <= 0 then
    Result := 0
  else
  begin
    case Mine of
      rtMetal: Result := trunc(30 * Stufe * IntPower(1.1,Stufe));
      rtKristal: Result := trunc(20 * Stufe * IntPower(1.1,Stufe));
      rtDeuterium: Result := trunc(10 * Stufe * IntPower(1.1,Stufe) * (-0.002 * maxPlanetTemp[planetPos] + 1.28));
    else
      raise Exception.Create('MineProduction: Unknown type of mine for calculation!');
    end;

    Result := trunc(Result * prod_faktor);
  end;
end;

function CalcTF(Scan: TScanBericht; DefInTF: Boolean): TResources;

  procedure AddToResult(res: TResources; count: integer);
  var r: integer;
  begin
    for r := 0 to length(res)-1 do
      Result[r] := Result[r] + res[r]*count;
  end;

var i: integer;
begin
  FillChar(Result,Sizeof(result),0);  //alles 0 setzen!

  // Normale Flotte
  for i := 0 to ScanFileCounts[fleet_group]-1 do
    if (Scan.Bericht[fleet_group][i] > 0) then
      AddToResult(fleet_resources[i], Scan.Bericht[fleet_group][i]);

  // Verteidigung
  if DefInTF then
    for i := 0 to ScanFileCounts[def_group]-1 do
    if not def_ignoreFight[i] then
      begin
        if (Scan.Bericht[def_group][i] > 0) then
          AddToResult(def_resources[i], Scan.Bericht[def_group][i]);
      end;

  //Bis hier wurden nur einfach alle Resourcen zusammengezählt!
  // -> jetzt kommt die Auswehrtung!

  Result[0] := round(Result[0] * truemmerfeld_faktor);  //30% vom Metall
  Result[1] := round(Result[1] * truemmerfeld_faktor);  //30% vom Kristall
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
    if Sys1.Planeten[i].Player     <> Sys2.Planeten[i].Player     then s := s + IntToStr(i) + ' Player!';
    if Sys1.Planeten[i].PlanetName <> Sys2.Planeten[i].PlanetName then s := s + IntToStr(i) + ' PlanetName!';
    if Sys1.Planeten[i].Ally       <> Sys2.Planeten[i].Ally       then s := s + IntToStr(i) + ' Ally!';
    if Sys1.Planeten[i].Status     <> Sys2.Planeten[i].Status     then s := s + IntToStr(i) + ' Status!';
    if Sys1.Planeten[i].MondSize   <> Sys2.Planeten[i].MondSize   then s := s + IntToStr(i) + ' MondSize!';
    if Sys1.Planeten[i].MondTemp   <> Sys2.Planeten[i].MondTemp   then s := s + IntToStr(i) + ' MondTemp!';
    if Sys1.Planeten[i].TF[0]      <> Sys2.Planeten[i].TF[0]      then s := s + IntToStr(i) + ' TF[0]!';
    if Sys1.Planeten[i].TF[1]      <> Sys2.Planeten[i].TF[1]      then s := s + IntToStr(i) + ' TF[1]!';
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
  if Scan1.Head.Planet <> Scan2.Head.Planet then Result := Result + ' Planetenname!';
  if not SamePlanet(Scan1.Head.Position,Scan2.Head.Position) then Result := Result + ' Position!';
  if Scan1.Head.Time_u <> Scan2.Head.Time_u then Result := Result + ' Time!';

  if Scan1.Head.Spieler <> Scan2.Head.Spieler then Result := Result + ' Spieler!';  //-> bei XML nicht dabei!

  if Scan1.Head.Spionageabwehr <> Scan2.Head.Spionageabwehr then Result := Result + ' Spionageabwehr!';
  if Scan1.Head.Creator <> Scan2.Head.Creator then Result := Result + ' Creator!';

  {if Scan1.Head.geraidet <> Scan2.Head.geraidet then Result := Result + ' geraidet!';
  if Scan1.Head.von <> Scan2.Head.von then Result := Result + ' von!'; } //-> ist auch in xml nicht vorhanden!

  if Scan1.Head.Activity <> Scan2.Head.Activity then Result := Result + ' Activity!';

  for sg := low(sg) to high(sg) do
  begin
    for j := 0 to ScanFileCounts[sg]-1 do
    begin
      if Scan1.Bericht[sg][j] <> Scan2.Bericht[sg][j] then
        Result := Result + ' [' + IntToStr(byte(sg)) + '][' + IntToStr(j+1) +
                           '](' + IntToStr(Scan1.Bericht[sg][j]) +
                           '/' + IntToStr(Scan2.Bericht[sg][j]) + ')';
    end;
  end;
end;

function FleetEventTypeToStr(fj: TFleetEventType): string;
begin
  Result := FleetEventTypeTranslate[fj];
end;
function FleetEventTypeToStrEx(flt: TFleetEvent): string;
begin
  Result := FleetEventTypeTranslate[flt.head.eventtype];
  if fef_return in flt.head.eventflags then
    Result := Result + ' return';
  if fef_friendly in flt.head.eventflags then
    Result := Result + ' friendly';
  if fef_neutral in flt.head.eventflags then
    Result := Result + ' neutral';
  if fef_hostile in flt.head.eventflags then
    Result := Result + ' hostile';
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

function GetStorageSize(scan: TScanBericht; resstype: TRessType): integer;
var speicherstufe: integer;
begin
  speicherstufe := Scan.Bericht[sg_Gebaeude][sb_Speicher_array[resstype]];
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
    if (Scan.Bericht[g][0] >= 0) then
      inc(Result);
  end;
end;

initialization
  ot_tousandsseperator := '.';

end.
