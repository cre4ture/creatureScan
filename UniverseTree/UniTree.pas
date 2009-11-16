unit UniTree;

interface

uses
  SysUtils, Classes, OGame_Types, cS_DB, MergeSocket, LibXmlParser,
  LibXmlComps, SplitSocket, cS_networking, StatusThread,
  Windows, Forms, DateUtils;

type
  PPlayerInformation = ^TPlayerInformation;
  TPlayerInformation = record
    Name: TPlayerName;
    Research: array[0..fsc_4_Forschung-1] of Integer;
    ResearchTime_u: Int64;
    ResearchPlanet: TPlanetPosition;
  end;
  TPlayerDB = class
  private
    FPlayerList: TList;
    function FFindPlayer(aName: TPlayerName): Integer;
  public
    constructor Create;
    destructor Destroy; override;
    procedure ANewReport(Report: TScanBericht);
    function GetPlayerInfo(aName: TPlayerName): TPlayerInformation;
  end;
  TIntegerList = array of Integer;
  PTreePlanet = ^TTreePlanet;
  TTreePlanet = record
    Reports: TIntegerList;
  end;
  ETreeSolSysAlreadySet = class(Exception);
  PTreeSolSys = ^TTreeSolSys;
  TTreeSolSys = record
    SolSys: Integer;
    acMoons: array of TPlanetPosition;
    FPlanets: array of array[Boolean] of TTreePlanet;
  end;
  TTreeDimSize = Integer;
  TPlanetPosList = array of TPlanetPosition;
  TUniTreeEvPos = procedure(Sender: TObject; Pos: TPlanetPosition) of object;
  TUniverseTree = class
  private
    SolSysDB: TcSSolSysDB;
    ReportDB: TcSReportDB;
    //Achtung: Basis0:
    FFTree: array of array of TTreeSolSys;
    FMaxReportsPerPlanet: Integer;
    FMinReportsPerPlanet: Integer;
    FMinReportTime: Int64;

    IdlePos: TPlanetPosition;
    LastIdleWork: TDateTime;
    
    procedure SetTreeDims(d0, d1, d2: Integer);
    procedure LoadSolSysData;
    procedure LoadReportData;
    procedure FInitReport(ScanNr: Integer);
    procedure FInitSolSys(SysNr: Integer);
    procedure FMarkacMoon(Pos: TPlanetPosition; unmark: Boolean);
    function PTreeSys(gala, sys: Integer): PTreeSolSys;
    function PTreePlanet(gala, sys, planet: Integer;
      moon: Boolean): PTreePlanet; overload;
    function PTreePlanet(pos: TPlanetPosition): PTreePlanet; overload;
    function FGetPlayerForScan(pos: TPlanetPosition): TPlayerName;
    procedure FSetPlayerForScansInNewSys(SolSys: TSystemCopy);
    procedure FDeleteScansOfEmptyPlanetsInNewSys(Sys: TSystemCopy);
    function FFindLatestReport(Pos: TPlanetPosition;
      skip: Integer = -1): integer;
    procedure FUnInitReport(ScanNr: Integer);
  protected
    TreeDim: array[0..2] of Integer;
  public
    //ToDo: Zugriff auf interne ReportDB und SolSysDB ermöglichen ;-)
    Player: TPlayerDB;
    OnSolSysChanged: TUniTreeEvPos;
    OnReportChanged: TUniTreeEvPos;
    function genericReport(const pos: TPlanetPosition;
      out report_out: TScanBericht): TScanGroup;
    constructor Create(GalaxyCount, SolSysCount, PlanetCount: Integer;
      aSolSysDB: TcSSolSysDB; aReportDB: TcSReportDB);
    function ValidPosition(Pos: TPlanetPosition): Boolean; overload;
    function ValidPosition(g,s,p: Integer; m: Boolean): Boolean; overload;
    function GetPhalanxList(Gala, Sys: Integer): TPlanetPosList; overload;
    function GetPhalanxList(Solsys: TPlanetPosition): TPlanetPosList; overload;
    function UniSys(Gala, SolSys: Integer): Integer;
    function UniReport(pos: TPlanetPosition): Integer; overload;
    function UniReport(gala,sys,planet: Integer; moon: Boolean): Integer; overload;
    function AddNewSolSys(Sys: TSystemCopy): Integer; virtual;
    function AddNewReport(report: TScanBericht): Integer; virtual;
    procedure DeleteReport(nr: Integer);
    //procedure GetPlanetScanList(List: PPlanetScanList);
    function GetPlanetReportList(Pos: TPlanetPosition): TReportTimeList; overload;
    function GetPlanetReportList(g,s,p: Integer; m: Boolean): TReportTimeList; overload;
    function NextPlanet(var Pos: TPlanetPosition): Boolean;
    procedure DoWork_idle(out Ready: Boolean); virtual;
    function AbsPlanetNrToPlanetPosition(nr: TAbsPlanetNr): TPlanetPosition;
    function PlanetPositionToAbsPlanetNr(pos: TPlanetPosition): TAbsPlanetNr;
    function FindReport(pos: TPlanetPosition; time_u: int64): Integer;
  end;
  TNetUniTreeSocketData = class
  public
    SyncPos: TAbsPlanetNr;
    constructor Create;
  end;
  TNetUniTree = class(TUniverseTree)
  private
    cS_Serv: TcSServer;
    procedure SolSysMergeOnNewPacket_ReadThread(Sender: TObject;
      Socket: TSplitSocket);
    procedure SolSysMergeOnNewSocket(Sender: TObject; Socket: TSplitSocket);
    function DoSync_SendSyncInfo(Socket: TSplitSocket): boolean;
    procedure DoSync_AnswerRequestPacket(parser: TXMLParser;
      Socket: TSplitSocket);
    procedure SolSysMergeNewPacket_DoWork(Sender: TObject;
      Socket: TSplitSocket; Data: pointer; Size: Word);
    procedure SolSysMergeOnRemoveSocket(Sender: TObject;
      Socket: TSplitSocket);
    procedure FDoSync_PlanetReportTimeList(parser: TXMLParser;
      Socket: TSplitSocket; Pos: TPlanetPosition);
    procedure DoSyncReportPlanet(pos: TPlanetPosition;
      list_remote: TReportTimeList; Socket: TSplitSocket);
    procedure DoSync_RecvSyncInfo(Parser: TXMLParser; Socket: TSplitSocket);
    procedure DoSyncSolSys(Pos: TPlanetPosition; time_remote: Int64;
      Socket: TSplitSocket);
  protected
    function AddNewReportFromSocket(report: TScanBericht;
      Socket: TSplitSocket): Integer;
    function AddNewSolSysFromSocket(Sys: TSystemCopy;
      Socket: TSplitSocket): Integer;
    procedure FSendSolSys(Sys: TSystemCopy; Skip: TSplitSocket);
    procedure FSendSolSysToSocket(Sys: TSystemCopy; Socket: TSplitSocket);
    procedure FSendReport(report: TScanBericht; Skip: TSplitSocket);
    procedure FSendReportToSocket(report: TScanbericht;
      Socket: TSplitSocket);
  public
    UniMerge: TMergeSocket;
    constructor Create(GalaxyCount, SolSysCount, PlanetCount: Integer;
      aSolSysDB: TcSSolSysDB; aReportDB: TcSReportDB; cSServer: TcSServer);
    destructor Destroy; override;
    function AddNewSolSys(Sys: TSystemCopy): Integer; override;
    procedure DoWork_idle(out Ready: Boolean); override;
    function AddNewReport(report: TScanBericht): Integer; override;
  end;

implementation

uses
  cS_XML;

function TUniverseTree.GetPhalanxList(Solsys: TPlanetPosition): TPlanetPosList;
begin
  Result := GetPhalanxList(Solsys.P[0],Solsys.P[1]);
end;

function TUniverseTree.GetPhalanxList(Gala, Sys: Integer): TPlanetPosList;
var c, i: Integer;
begin
  c := length(PTreeSys(Gala,Sys).acMoons);
  setlength(Result,c);
  for i := 0 to c-1 do
  begin
    Result[i] := PTreeSys(Gala,Sys)^.acMoons[i];
  end;
end;

function TUniverseTree.UniSys(Gala, SolSys: Integer): Integer;
begin
  Result := PTreeSys(Gala,SolSys)^.SolSys;
end;

function TUniverseTree.UniReport(pos: TPlanetPosition): Integer;
begin
  //Achtung: Overloads rufen sich hier nicht gegenseitig auf!
  with PTreePlanet(pos.P[0],pos.P[1],pos.P[2],pos.mond)^ do
  begin
    if (length(Reports) > 0) then
      Result := Reports[0]
    else
      Result := -1;
  end;
end;

function TUniverseTree.UniReport(gala,sys,planet: Integer; moon: Boolean): Integer;
begin
  //Achtung: Overloads rufen sich hier nicht gegenseitig auf!
  with PTreePlanet(gala,sys,planet,moon)^ do
  begin
    if (length(Reports) > 0) then
      Result := Reports[0]
    else
      Result := -1;
  end;
end;


function TUniverseTree.FFindLatestReport(Pos: TPlanetPosition;
  skip: Integer = -1): integer;
//Sucht(!) den Aktuellsten(Neusten!) Scan eines Planeten!
//Verwendet dabei nicht(!) das Uni-Verzeichniss
//Verwendung: FInitScan(un_init)!
var i: integer;
    t: Int64;
begin
  Result := -1;  //Rückgabe -1 bei keinem Fund!
  t := low(t);
  for i := 0 to ReportDB.Count-1 do
    if (i <> skip) then
      with ReportDB[i] do
      begin
        if SamePlanet(Head.Position,Pos)and
           (Head.Time_u > t) then
        begin
          Result := i;
          t := Head.Time_u;
        end;
      end;
end;


procedure TUniverseTree.FMarkacMoon(Pos: TPlanetPosition; unmark: Boolean);

  procedure DoMark(g,s: integer);
  var i: integer;
  begin
    with PTreeSys(g,s)^ do
    begin
      i := length(acMoons);
      SetLength(acMoons,i+1);
      acMoons[i] := Pos;
    end;
  end;
  procedure DoUnMark(g,s: integer);
  var i, c: integer;
  begin
    with PTreeSys(g,s)^ do
    begin
      i := 0;
      c := length(acMoons);
      while (i < c) do
      begin
        if SamePlanet(pos,acMoons[i]) then
        begin
          acMoons[i] := acMoons[c-1];
          dec(c);
          SetLength(acMoons,c);
        end
        else inc(i);
      end;
    end;
  end;

var Range, i, report: Integer;
begin
  report := UniReport(pos);
  //wenn scan vorhanden, und in diesem scan eine sesorpalax gibt
  if (Pos.Mond)and  //nur auf monden steht eine Sensorphalanx!
     (report >= 0)and
     (ReportDB[report]
        .Bericht[sg_Gebaeude,sb_Sensorpalanx] > 0) then
  begin
    Range := ReportDB[Report]
               .Bericht[sg_Gebaeude,sb_Sensorpalanx];
    Range := sqr(Range)-1;
    for i := 0 to range do
    begin
      if (pos.P[1]+i <= max_systems) then
        if unmark then
          DoUnMark(pos.P[0],pos.P[1]+i)
        else
          DoMark(pos.P[0],pos.P[1]+i);
      if (i <> 0)and(pos.P[1]-i >= 1) then
        if unmark then
          DoUnMark(pos.P[0],pos.P[1]-i)
        else
          DoMark(pos.P[0],pos.P[1]-i);
    end;
  end;
end;


procedure TUniverseTree.FInitSolSys(SysNr: Integer);
var pos: TPlanetPosition;
begin
  pos := SolSysDB[SysNr].System;
  with PTreeSys(pos.p[0],pos.P[1])^ do
  begin
    if (SolSys = -1) then
      SolSys := SysNr
    else raise ETreeSolSysAlreadySet.Create(
                 'TUniverseTree.FInitSolSys: nr:' + PositionToStr_(pos));
  end;
end;

procedure TUniverseTree.FInitReport(ScanNr: Integer);
var Scan: TScanBericht;
    inr, j, c: integer;
begin
  Scan := ReportDB[ScanNr];
  with PTreePlanet(Scan.Head.Position)^ do
  begin
    //Position im Array Suchen:
    c := length(Reports);
    inr := 0;
    while (inr < c)and
          (Scan.Head.Time_u < ReportDB[Reports[inr]].Head.Time_u) do
      inc(inr);

    //<MarkacMoon>

      //Wenn Es einen neuen "aktuellsten" Scan gibt, dann muss das durch
      //FMarkacMoon!!!
      if (inr = 0) then
        //Alte Mond-Reaches enfernen
        FMarkacMoon(Scan.Head.Position, True);
        
    //</MarkacMoon>

    //Array um eins verlängern
    //(hier nicht gleich ans löschen der "überflüssigen" Scans denken!
    // Bisheriger Code geht nicht davon aus, das beim Hinzufügen eines Scans
    // auch Welche verschwinden und Andere ihren Index ändern können!)
    inc(c);
    SetLength(Reports,c);

    //Reports im Array verschieben
    for j := c-2 downto inr do
      Reports[j+1] := Reports[j];

    //Neuen report setzen
    Reports[inr] := ScanNr;

    //<MarkacMoon>

      //Siehe weiter oben
      if (inr = 0) then
        //Neue Mond-Reaches hinzufügen
        FMarkacMoon(Scan.Head.Position, False);

    //</MarkacMoon>
  end;

  Player.ANewReport(Scan);
end;

procedure TUniverseTree.FUnInitReport(ScanNr: Integer);
var Scan: TScanBericht;
    j, inr, c: integer;
begin
  Scan := ReportDB[ScanNr];
  with PTreePlanet(Scan.Head.Position)^ do
  begin
    //Report im Array suchen
    c := length(Reports);
    inr := -1;
    for j := 0 to c-1 do
      if (Reports[j] = ScanNr) then
      begin
        inr := j;
        break;
      end;

    //Wenn report nicht gefunden -> kritischer fehler!!!
    if (inr = -1) then
      raise Exception.Create('TUniverseTree.FUnInitReport: Speicherleck! ' +
                             'Report wurde im UniTree nicht eingetragen!');
    //<MarkacMoon>

      //Wenn der "aktuellste" Scan gelöscht wird, dann muss das durch
      //FMarkacMoon!!!
      if (inr = 0) then
        //Alte Mond-Reaches enfernen
        FMarkacMoon(Scan.Head.Position, True);

    //</MarkacMoon>

    //Reports im Array verschieben:
    for j := inr to c-2 do
      Reports[j] := Reports[j+1];

    //Letzten im Array löschen
    Setlength(Reports,c-1);

    //<MarkacMoon>

      //siehe weiter oben
      if (inr = 0) then
        //Neue Mond-Reaches hinzufügen
        FMarkacMoon(Scan.Head.Position, False);

    //</MarkacMoon>
  end;

  //Player.ANewReport(Scan);
end;


function TUniverseTree.genericReport(const pos: TPlanetPosition;
  out report_out: TScanBericht): TScanGroup;
var sl: TReportTimeList;
    sl_i, i: integer;
    sg: TScanGroup;
    scan: TScanBericht;
begin
  Result := sg_Rohstoffe;
  for sg := low(sg) to high(sg) do
  begin
    SetLength(report_out.Bericht[sg], ScanFileCounts[sg]);
    for i := 0 to ScanFileCounts[sg]-1 do
    begin
      report_out.Bericht[sg][i] := -1;
    end;
  end;
  FillChar(report_out.Head, sizeof(report_out.Head), 0);
  report_out.Head.Position := pos;
  report_out.Head.Time_u := -1;

  sl := GetPlanetReportList(pos);

  // Head des neusten scans kopieren
  if length(sl) > 0 then
  begin
    scan := ReportDB[sl[0].ID];
    report_out.Head := scan.head;
    for sg := low(sg) to high(sg) do
      if scan.Bericht[sg][0] <> -1 then
      begin
        Result := sg;
      end;
  end;

  for sl_i := 0 to length(sl) - 1 do
  begin
    scan := ReportDB[sl[sl_i].ID];
    for sg := low(sg) to sg_Gebaeude do  // nur bis Gebäude, da Forschung auch von anderen
                                         // Planeten kommen kann
    begin
      if (report_out.Bericht[sg][0] = -1)and
         (scan.Bericht[sg][0] <> -1) then
      begin
        for i := 0 to ScanFileCounts[sg] - 1 do
        begin
          report_out.Bericht[sg][i] := scan.Bericht[sg][i];
        end;
      end;
    end;
  end;
end;

constructor TUniverseTree.Create(GalaxyCount, SolSysCount,
  PlanetCount: Integer; aSolSysDB: TcSSolSysDB; aReportDB: TcSReportDB);
begin
  inherited Create;
  FMaxReportsPerPlanet := high(FMaxReportsPerPlanet);
  FMinReportsPerPlanet := 5;
  FMinReportTime := low(FMinReportTime);
  LastIdleWork := now;
  FillChar(IdlePos,SizeOf(IdlePos),0);
  
  SetTreeDims(GalaxyCount,SolSysCount,PlanetCount);
  SolSysDB := aSolSysDB;
  ReportDB := aReportDB;

  Player := TPlayerDB.Create;

  LoadReportData;
  LoadSolSysData;
end;

function TUniverseTree.AddNewSolSys(Sys: TSystemCopy): Integer;
var i : integer;
    b : Boolean;
begin
  if not ValidPosition(Sys.System) then
    raise Exception.Create('TUniverseTree.AddNewSolSys: Position out of range');

  Sys.System.P[2] := 1;
  Sys.System.Mond := False;


  i := PTreeSys(Sys.System.P[0],Sys.System.P[1])^.SolSys;
  b := (i = -1);
  if b then
  begin
    i := SolSysDB.AddSolSys(Sys);
    PTreeSys(Sys.System.P[0],Sys.System.P[1])^.SolSys := i;
  end
  else
  begin
    b := (SolSysDB[i].Time_u < sys.Time_u);
    if b then
      SolSysDB[i] := sys;
  end;

  if b then
  begin
    Result := i;
    FDeleteScansOfEmptyPlanetsInNewSys(Sys);
    FSetPlayerForScansInNewSys(Sys);

    if Assigned(OnSolSysChanged) then
      OnSolSysChanged(Self,Sys.System);
  end
  else
    Result := -1;
end;

procedure TUniverseTree.LoadReportData;
var i: integer;
begin
  if (ReportDB = nil) then
    raise Exception.Create('TUniverseTree.LoadReportData: ReportDB == nil');

  i := ReportDB.Count-1;
  while (i >= 0) do
  begin
    FInitReport(i);
    dec(i);
  end;
end;

procedure TUniverseTree.LoadSolSysData;
var i: integer;
begin
  if (SolSysDB = nil) then
    raise Exception.Create('TUniverseTree.LoadSolSysData: SolSysDB == nil');

  i := SolSysDB.Count-1;
  while (i >= 0) do
  begin
    try FInitSolSys(i) except
      on ETreeSolSysAlreadySet do
      begin
        //sys löschen (mit anderem überschreiben)
        SolSysDB[i] := SolSysDB[SolSysDB.Count-1];
        SolSysDB.DeleteLastSys;

        //Verschiebung in FFTree nachvollziehen!
        if PTreeSys(SolSysDB[i].System.P[0],SolSysDB[i].System.P[1])^.SolSys <> SolSysDB.Count then
          raise Exception.Create('TUniverseTree.LoadSolSysData: Logical Error: Sorry, something is going terribly wrong!');
        PTreeSys(SolSysDB[i].System.P[0],SolSysDB[i].System.P[1])^.SolSys := i;
      end;
    end;

    dec(i);
  end;
end;

procedure TUniverseTree.SetTreeDims(d0, d1, d2: Integer);
var x0,x1,x2: Integer;
    b: Boolean;
begin
  TreeDim[0] := d0;
  TreeDim[1] := d1;
  TreeDim[2] := d2;
  SetLength(FFTree,TreeDim[0]);

  for x0 := 0 to TreeDim[0]-1 do  //FFTree hat basis 0!
  begin
    SetLength(FFTree[x0],TreeDim[1]);

    for x1 := 0 to TreeDim[1]-1 do
    begin
      SetLength(FFTree[x0,x1].FPlanets,TreeDim[2]);
      FFTree[x0,x1].SolSys := -1;

      for x2 := 0 to TreeDim[2]-1 do
        for b := false to true do
        begin
          SetLength(FFTree[x0,x1].FPlanets[x2,b].Reports,0);
        end;
    end;
  end;
end;

function TUniverseTree.ValidPosition(Pos: TPlanetPosition): Boolean;
begin
  Result := ValidPosition(pos.P[0],pos.P[1],pos.P[2],pos.Mond);
end;

function TUniverseTree.ValidPosition(g,s,p: Integer; m: Boolean): Boolean;
begin
  Result := (g > 0)and(g <= TreeDim[0])and
            (s > 0)and(s <= TreeDim[1])and
            (p > 0)and(p <= TreeDim[2]);
end;



procedure TPlayerDB.ANewReport(Report: TScanBericht);
var i: integer;
    ppi: PPlayerInformation;
begin
  if (Report.Head.Spieler <> '')and(Report.Bericht[sg_Forschung][0] >= 0) then
  begin
    i := FFindPlayer(Report.Head.Spieler);
    if (i = -1) then
    begin
      New(ppi);
      ppi^.ResearchTime_u := 0;
      ppi^.Name := Report.Head.Spieler;
      FPlayerList.Add(ppi);
    end
    else ppi := FPlayerList[i];

    if (ppi^.ResearchTime_u < Report.Head.Time_u) then
    begin
      ppi^.ResearchTime_u := Report.Head.Time_u;
      ppi^.ResearchPlanet := Report.Head.Position;
      for i := 0 to ScanFileCounts[sg_Forschung]-1 do
        ppi^.Research[i] := Report.Bericht[sg_Forschung][i];
    end;
  end;
end;

constructor TPlayerDB.Create;
begin
  inherited;
  FPlayerList := TList.Create;
end;

destructor TPlayerDB.Destroy;
begin
  FPlayerList.Free;
  inherited;
end;

function TPlayerDB.FFindPlayer(aName: TPlayerName): Integer;
var i: integer;
begin
  Result := -1;
  for i := 0 to FPlayerList.Count-1 do
  with TPlayerInformation(FPlayerList[i]^) do
  begin
    if (Name = aName) then
    begin
      Result := i;
      Break;
    end;
  end;
end;

function TPlayerDB.GetPlayerInfo(aName: TPlayerName): TPlayerInformation;
var i: integer;
begin
  i := FFindPlayer(aName);
  if (i >= 0) then
  begin
    Result := TPlayerInformation(FPlayerList[i]^);
  end
  else Result.Name := '';
end;

function TUniverseTree.PTreeSys(gala, sys: Integer): PTreeSolSys;
begin
  if not ValidPosition(gala,sys,1,false) then
    raise Exception.Create(
      Format('TUniverseTree.PTreeSys: Invalid coordinates! (%d:%d)',
        [gala,sys]));

  Result := Addr(FFTree[gala-1,sys-1]);
end;

function TUniverseTree.PTreePlanet(pos: TPlanetPosition): PTreePlanet;
begin
  Result := PTreePlanet(pos.P[0],pos.P[1],pos.P[2],pos.Mond);
end;

function TUniverseTree.PTreePlanet(gala, sys, planet: Integer;
  moon: Boolean): PTreePlanet;
begin
  if not ValidPosition(gala,sys,planet,moon) then
    raise Exception.Create(
      Format('TUniverseTree.PTreePlanet: Invalid coordinates! (%d:%d:%d)',
        [gala,sys,planet]));

  Result := Addr(FFTree[gala-1,sys-1].FPlanets[planet-1,moon]);
end;

function TUniverseTree.AddNewReport(report: TScanBericht): Integer;
begin
  Result := -1;
  if not ValidPosition(report.Head.Position) then
    Exit;

  //Suchen ob, Scan schon vorhanden:
  if (0 <= FindReport(report.Head.Position, report.Head.Time_u)) then
  begin
    Result := -2;
  end;
  { alt -> dauert viel zu lang!
  for i := 0 to ReportDB.Count-1 do
  begin
    if SamePlanet(ReportDB[i].Head.Position,report.Head.Position)and
                 (ReportDB[i].Head.Time_u = report.Head.Time_u) then
    begin
      Result := -2;
      break;
    end;
  end;
  }

  if (Result = -1) then
  begin
    if (report.Head.Spieler = '') then
      report.Head.Spieler := FGetPlayerForScan(report.Head.Position);

    Result := ReportDB.AddReport(report);
    FInitReport(Result);

    if Assigned(OnReportChanged) then
      OnReportChanged(Self,report.Head.Position);
  end;
end;

function TUniverseTree.FGetPlayerForScan(
  pos: TPlanetPosition): TPlayerName;
var t: Int64;
    i: integer;
begin
  //Suche Spielernamen für neue Scans! (In AddNewReport verwendet)

  t := low(t);
  Result := '';
  i := PTreeSys(pos.P[0],pos.P[1])^.SolSys;
  if (i >= 0) then
  begin
    t := SolSysDB[i].Time_u;
    Result := SolSysDB[i].Planeten[pos.P[2]].Player;
  end;

  i := UniReport(pos);
  if (i >= 0)and
     ((Result = '')or(ReportDB[i].Head.Time_u > t))and
     (ReportDB[i].Head.Spieler <> '') then
  begin
    Result := ReportDB[i].Head.Spieler;
  end;
end;

procedure TUniverseTree.FSetPlayerForScansInNewSys(SolSys: TSystemCopy);
{ -> Funktion:
     Diese Procedure Durchsucht ein Sonnensystem(sys) nach Scans die noch
     keinen Spielernamen eingetragen haben und setzt diesen, falls an dieser
     Position im SolSys ein Planet eingetragen ist. Der alte Scan wird dann
     durch den neuen ersetzt und abgespeichert.
  -> Verwendung:
     Wenn ein neues Sonnensystem eingelesen wurde(AddNewSolSys)}
var {SolSys: TSystemCopy;}
    Report: TScanBericht;
    i, r: Integer;
    m: Boolean;
begin
  {i := UniSys(Sys.P[0],Sys.P[1]);
  if (i >= 0) then
  begin
    SolSys := SolSysDB[i];}
    for i := 1 to TreeDim[2] do
      for m := false to true do
      begin
        r := UniReport(SolSys.System.P[0],SolSys.System.P[1],i,m);
        if (r >= 0) then
        begin
          Report := ReportDB[r];
          if (Report.Head.Spieler = '')and(SolSys.Planeten[i].Player <> '') then
          begin
            Report.Head.Spieler := SolSys.Planeten[i].Player;
            ReportDB[r] := Report; //Speichern!
          end;
        end;
      end;
  {end;}
end;

procedure TUniverseTree.FDeleteScansOfEmptyPlanetsInNewSys(
  Sys: TSystemCopy);

//Wenn ein Planet im ogame gelöscht wird, ist er im neuen solsys nicht
//vorhanden. Die Scans von diesem planeten können hier gelöscht werden.
//verwendung von: AddNewSolSys 

  procedure DelScansOfPlanet(Pos: TPlanetPosition);
  var i: integer;
  begin
    for i := ReportDB.Count-1 downto 0 do
    with ReportDB[i] do
    begin
      if SamePlanet(Head.Position,Pos) then
      begin
        DeleteReport(i);
      end;
    end;
  end;

var p: integer;
    m: boolean;
    pos: TPlanetPosition;
begin
  with sys do
  for p := 1 to max_Planeten do
    for m := false to true do
      if (UniReport(System.P[0],System.P[1],p,m) >= 0)and(Planeten[p].Player = '') then
      begin
        pos := system;
        pos.P[2] := p;
        pos.Mond := m;
        DelScansOfPlanet(pos);
      end;
end;

procedure TUniverseTree.DeleteReport(nr: Integer);
var last: Integer;
    pos: TPlanetPosition;
begin
  if (nr >= 0) and (nr < ReportDB.Count) then
  begin
    //pos für später merken:
    pos := ReportDB[nr].Head.Position;

    //Aus FTree Entfernen:
    FUnInitReport(nr);

    last := ReportDB.Count-1;
    if last <> nr then           //wenn der letzte nicht der zu löschende ist
    begin
      //letzten verschieben:
      ReportDB[nr] := ReportDB[last];

      //Verschiebung in FTree nachvollziehen:
      FUnInitReport(last);
      FInitReport(nr);
    end;
    //Jetzt letzten löschen:
    ReportDB.DeleteLastScan;

    if Assigned(OnReportChanged) then
      OnReportChanged(Self, pos);
  end;
end;

function TNetUniTree.AddNewSolSys(Sys: TSystemCopy): Integer;
begin
  Result := inherited AddNewSolSys(Sys);
  if (Result >= 0) then
  begin
    UniMerge.LockList;
    try
      FSendSolSys(Sys,nil);
    finally
      UniMerge.UnlockList;
    end;
  end;
end;

function TNetUniTree.AddNewSolSysFromSocket(Sys: TSystemCopy;
  Socket: TSplitSocket): Integer;
begin
  Result := inherited AddNewSolSys(Sys);

  if (Result >= 0) then
  begin
    FSendSolSys(Sys,Socket);

    with Socket.HostSocket as TSocketMultiplex,
      TcSConnectionData(LockData('TNetUniTree.AddNewSolSysFromSocket')) do
    try
      inc(RecvSystemCount);
    finally
      UnlockData;
    end;
  end;
end;

constructor TNetUniTree.Create(GalaxyCount, SolSysCount, PlanetCount: Integer;
  aSolSysDB: TcSSolSysDB; aReportDB: TcSReportDB; cSServer: TcSServer);
begin
  cS_Serv := cSServer;
  UniMerge := TMergeSocket.Create;
  UniMerge := TMergeSocket.Create;
  UniMerge.OnNewPacket_ReadThread := SolSysMergeOnNewPacket_ReadThread;
  UniMerge.OnNewSocket := SolSysMergeOnNewSocket;
  UniMerge.OnRemoveSocket := SolSysMergeOnRemoveSocket;
  cS_Serv.FUniMerge := UniMerge;
  inherited Create(GalaxyCount,SolSysCount,PlanetCount,aSolSysDB,aReportDB);
end;

destructor TNetUniTree.Destroy;
begin
  cS_Serv.FUniMerge := nil;
  UniMerge.Free;
  inherited;
end;

procedure TNetUniTree.DoWork_idle(out Ready: Boolean);
var Data: pointer;
    Size: Word;
    Socket: TSplitSocket;
    R: Boolean;
    i: Integer;
begin
  { Diese Procedure wird im Mainthread aufgerufen, wenn gerade nichts zu tun ist.
    Sie verarbeitet ankommende Packete, und treibt den sync-Vorgang weiter! } 

  Ready := true;
  inherited DoWork_idle(Ready);

  UniMerge.LockList;
  try
    for i := 0 to UniMerge.Count-1 do
    begin
      Socket := UniMerge.Sockets[i];
      try
        if (Socket.Master)and         //wenn ich "client" (mehr RechenPower!) in dieser Verbindung bin,
           (Socket.GetBufferCount < 10)and         //und sonst gerade nicht viel zu tun habe,
           (not DoSync_SendSyncInfo(Socket)) then  //dann checke ob der sync-vorgang noch läuft,
          Ready := False;                          //wenn ja, meldung dass ich noch nicht fertig bist!

        R := Socket.GetPacket(Data,Size);
        if R then
        begin
          SolSysMergeNewPacket_DoWork(Self,Socket,Data,Size);
          FreeMem(Data);
          Ready := False;
        end;
      except
        on E: Exception do
          cS_Serv.log.AddEntry(Socket.HostSocket,'TNetUniTree.DoWork_idle' +
            ': Exception(' + E.ClassName +
            '): ' + E.Message);
      end;
    end;
  finally
    UniMerge.UnlockList;
  end;
end;

procedure TNetUniTree.FSendSolSys(Sys: TSystemCopy; Skip: TSplitSocket);
var i: integer;
begin
  for i := 0 to UniMerge.Count-1 do
    if (UniMerge.Sockets[i] <> Skip) then
    begin
      FSendSolSysToSocket(Sys,UniMerge.Sockets[i]);
    end;
end;

function TNetUniTree.DoSync_SendSyncInfo(Socket: TSplitSocket): boolean;

  function SyncData_SolSys(Pos: TPlanetPosition): String;
  var uss: Integer;
  begin
    Result := '';
    uss := UniSys(Pos.P[0],Pos.P[1]);
    if (uss >= 0) then
    begin
      Result := Format('<solsystime %s="%d"/>',
                       [xsys_group_time, SolSysDB[uss].Time_u]);
    end;
  end;

  function SyncData_Planet(Pos: TPlanetPosition): String;
  var list: TReportTimeList;
      i: integer;
  begin
    Result := '';
    SetLength(List,0);
    if (UniReport(Pos) >= 0) then
    begin
      Result := '<planettimelist>';

      list := GetPlanetReportList(Pos);
      for i := 0 to length(list)-1 do
      begin
        Result := Result + '<reporttime ' + xspio_group_time + '="' +
               IntToStr(list[i].Time_u) + '" id="' + IntToStr(list[i].ID) + '"/>';
      end;

      Result := Result + '</planettimelist>';
    end;
  end;

var c: Integer;
    xmla, xml: string;
    pos_a, pos_z, spos: TPLanetPosition;
begin
  Result := False;
  with TNetUniTreeSocketData(Socket.LockData('TNetUniTree.DoSync_Master_ready')) do
  try
    //Wenn Ende
    if (AbsPlanetNrToPlanetPosition(SyncPos).P[0] > TreeDim[0]) then
    begin
      Result := True;
      Exit;
    end;

    c := 0;
    xmla := '';
    pos_a := AbsPlanetNrToPlanetPosition(SyncPos);
    spos := AbsPlanetNrToPlanetPosition(SyncPos);
    while (c < 10) and (length(xmla) < 15000) and ValidPosition(spos) do
    begin
      xml := '';
      //Beim ersten Planeten im SolSys wird dieses Syncronisiert:
      if (spos.P[2] = 1)and
         (not spos.Mond) then
      begin
        xml := xml + SyncData_SolSys(spos);
      end;

      //Reports syncen:
      xml := xml + SyncData_Planet(spos);

      //Verpacken und zum verschicken tun:
      if length(xml) > 0 then
      begin
        xmla := xmla + Format('<position %s="%d" %s="%d" %s="%d"',
                             [xpos_gala, spos.P[0],
                              xpos_sys,  spos.P[1],
                              xpos_pos,  spos.P[2]]);
        if spos.Mond then
          xmla := xmla + ' ' + xpos_moon + '="1">'
        else xmla := xmla + '>';

        xmla := xmla + xml + '</position>';
      end;

      pos_z := spos;
      inc(SyncPos);
      spos := AbsPlanetNrToPlanetPosition(SyncPos);
      inc(c); //damit, auch wenn wenig/keine daten vorhanden die gegenseite,
      //die womöglich da wesentlich mehr hat, nicht zu viel auf einmal zu tun bekommt.
    end;


    //Einpacken:
    xmla := AnsiToUtf8('<syncdata from="' + PositionToStrMond(pos_a) + '"' +
                                   'to="' + PositionToStrMond(pos_z) + '">' +
                        xmla + '</syncdata>');

    if (length(xmla) > high(word)) then
      raise Exception.Create('TNetUniTree.FSendSolSysTimes: ' +
              ' Sorry, packet is to big!!');

  finally
    Socket.UnlockData;
  end;

  Socket.SendPacket(PChar(xmla)^,length(xmla));
end;

{ -> Is Old!!! New: GetPlanetReportList
procedure TUniverseTree.GetPlanetScanList(List: PPlanetScanList);
var i, it: integer;                 //Position in List muss gesetzt werden!
begin
  if (List = nil) or (not ValidPosition(List^.Planet)) then exit;

  SetLength(List^.Items,0);
  for i := 0 to ReportDB.Count-1 do
  if SamePlanet(ReportDB[i].Head.Position,List^.Planet) then
  begin
    it := length(List^.Items);
    setlength(List^.Items,it+1);
    List^.Items[it].NR := i;
    List^.Items[it].Alter := UnixToDateTime(ReportDB[i].Head.Time_u);
  end;
end;  }

function TUniverseTree.GetPlanetReportList(g,s,p: Integer; m: Boolean): TReportTimeList;
var pos: TPlanetPosition;
begin
  pos.p[0] := g;
  pos.p[1] := s;
  pos.p[2] := p;
  pos.Mond := m;
  Result := GetPlanetReportList(pos)
end;

function TUniverseTree.GetPlanetReportList(Pos: TPlanetPosition): TReportTimeList;
var i{,j,k}: Integer;
    c: integer;
    a: TIntegerList;
    {scan: TScanBericht;}
begin      //Schon sortierte Liste!!!
  with PTreePlanet(Pos)^ do
  begin
    a := Reports;
    c := length(Reports);
    SetLength(Result,c);
    for i := 0 to c-1 do
    begin
      Result[i].ID := Reports[i];
      Result[i].Time_u := ReportDB[Reports[i]].Head.Time_u;
    end;
  end;

  //Das volgende ist alt (aus der zeit wo er noch suchen musste):
  {if not ValidPosition(Pos) then
    raise Exception.Create('TUniverseTree.GetPlanetReportList: Invalid pos' +
      PositionToStrA(pos));

  c := 0;
  Setlength(Result,c);

  //Wenn kein einziger im UniTree vermerkt ist, brauchen wir auchnicht suchen!
  if (UniReport(Pos) >= 0) then
  for i := 0 to ReportDB.Count-1 do //Schleife zum Suchen nach Scans vom angegebenen Planeten
  begin
    scan := ReportDB[i];
    if SamePlanet(Pos, scan.Head.Position) then
    begin
      j := 0;    //Schleife um richtige Position in schon vorhandenen Ergebnissen zu finden!
      while (j < c)and(Result[j].Time_u > scan.Head.Time_u) do
        inc(j);
      inc(c);
      Setlength(Result,c);
      for k := c-1 downto j+1 do  //Verschieben der Elemente um dem Neuen Platzzumachen!
      begin
        Result[k] := Result[k-1];
      end;
      Result[j].Time_u := scan.Head.Time_u;
      Result[j].ID := i;
    end;
  end;}
end;

procedure TNetUniTree.FSendSolSysToSocket(Sys: TSystemCopy;
  Socket: TSplitSocket);
var s: string;
begin
  s := AnsiToUtf8(SysToXML_(Sys)) + #0;
  Socket.SendPacket(PChar(s)^,length(s)+1);

  with Socket.HostSocket as TSocketMultiplex,
       TcSConnectionData(LockData('TNetUniTree.FSendSolSysToSocket')) do
  try
    inc(SendSystemCount);
  finally
    UnlockData;
  end;
end;

procedure TNetUniTree.DoSync_AnswerRequestPacket(parser: TXMLParser; Socket: TSplitSocket);
var i: Integer;
    sys: TSystemCopy;
    typ: string;
    pos: TPlanetPosition;
begin
  typ := parser.CurAttr.Value('type');
  pos.P[0] := StrToIntDef(parser.CurAttr.Value(xpos_gala),0);
  pos.P[1] := StrToIntDef(parser.CurAttr.Value(xpos_sys),0);
  pos.P[2] := StrToIntDef(parser.CurAttr.Value(xpos_pos),0);
  pos.Mond := (parser.CurAttr.Value(xpos_moon) = '1');

  if (typ = xsys_group) then
  begin
    i := UniSys(pos.p[0],pos.P[1]);
    if (i >= 0) then
    begin
      sys := SolSysDB[i];
      FSendSolSysToSocket(sys,Socket);
    end;
  end
  else
  if (typ = xspio_group) then
  begin
    i := StrToInt(parser.CurAttr.Value('id'));
    if (i < ReportDB.Count)and
       SamePlanet(pos,ReportDB[i].Head.Position) then
    begin
      FSendReportToSocket(ReportDB[i],Socket);
    end else raise Exception.Create('TNetUniTree.FSend_request:' +
               'Sync konnte nicht vollständig abgeschlossen werden....' +
               'scanid passt nichtmehr zur position!');
  end;
end;

procedure TNetUniTree.SolSysMergeNewPacket_DoWork(Sender: TObject;
  Socket: TSplitSocket; Data: pointer; Size: Word);
var s: string;
    parser: TXmlParser;
    sys: TSystemCopy;
    report: TScanBericht;
begin
  parser := TXmlParser.Create;
  try
    SetLength(s, Size);
    Move(Data^, PChar(s)^, Size);
    s := Utf8ToAnsi(s);

    //FreeMem(data);  -> wird von DoWork_idle ausgeführt!

    parser.LoadFromBuffer(PChar(s));
    parser.StartScan;

    while parser.Scan do
    begin
      case parser.CurPartType of
        ptStartTag, ptEmptyTag:
          if (parser.CurName = xsys_group)and
              parse_Sys(parser,sys) then
            AddNewSolSysFromSocket(sys,socket)
          else
          if (parser.CurName = xspio_group)and
              parse_report(parser,report)  then
            AddNewReportFromSocket(report,Socket)
          else
          if (parser.CurName = 'syncdata') then
            DoSync_RecvSyncInfo(parser,Socket)
          else
          if (parser.CurName = 'request') then
            DoSync_AnswerRequestPacket(parser,Socket)
          else;
      end;
    end;
  finally
    parser.Free;
  end;
end;

procedure TNetUniTree.SolSysMergeOnNewPacket_ReadThread(Sender: TObject;
  Socket: TSplitSocket);
begin
  //Den HauptThread "Aufwecken" damit DoWork_idle wieder gestartet wird:
  WakeMainThread(Self);
end;

procedure TNetUniTree.SolSysMergeOnNewSocket(Sender: TObject;
  Socket: TSplitSocket);
begin
  Socket.LockData('TNetUniTree.SolSysMergeNewSocket');
  try
    Socket.SetData_locked_(TNetUniTreeSocketData.Create);
  finally
    Socket.UnlockData;
  end;
end;

procedure TNetUniTree.SolSysMergeOnRemoveSocket(Sender: TObject;
  Socket: TSplitSocket);
var p: TNetUniTreeSocketData;
begin
  p := TNetUniTreeSocketData(Socket.LockData('TNetUniTree.SolSysMergeRemoveSocket'));
  try
    p.Free;
    Socket.SetData_locked_(nil);
  finally
    Socket.UnlockData;
  end;
end;

function TUniverseTree.AbsPlanetNrToPlanetPosition(nr: TAbsPlanetNr): TPlanetPosition;
begin
  //Written by Ulrich Hornung, 26.10.2007

  Result.Mond := (nr mod 2) = 1;
  nr := nr div 2;
  Result.P[2] := 1+ (nr mod TreeDim[2]);
  nr := nr div max_Planeten;
  Result.P[1] := 1+ (nr mod TreeDim[1]);
  nr := nr div max_Systems;
  if (1+nr > high(Result.P[0])) then
    raise Exception.Create('AbsPlanetNrToPlanetPosition: Bereich für P[0] ist überschritten!');
  Result.P[0] := 1+ nr; //(nr mod max_Galaxy);
end;

function TUniverseTree.PlanetPositionToAbsPlanetNr(pos: TPlanetPosition): TAbsPlanetNr;
begin
  //Written by Ulrich Hornung, 26.10.2007

  Result := (pos.P[0]-1)*TreeDim[1]*TreeDim[2]*2 +
            (pos.P[1]-1)*TreeDim[2]*2 +
            (pos.P[2]-1)*2; // 2 = max_Monde
  if pos.Mond then
    inc(Result);
end;

constructor TNetUniTreeSocketData.Create;
begin
  inherited;
  SyncPos := 0;
end;

procedure TNetUniTree.FDoSync_PlanetReportTimeList(parser: TXMLParser;
  Socket: TSplitSocket; Pos: TPlanetPosition);
var roottag: string;
    i, j: Integer;
    t: Int64;
    list_remote: TReportTimeList;
begin
  roottag := parser.CurName;
  setlength(list_remote,0);

  if (parser.CurPartType <> ptEmptyTag) then
  while parser.Scan do
  begin
    case parser.CurPartType of
    ptStartTag, ptEmptyTag:
      begin
        if (parser.CurName = 'reporttime') then
        begin
          t := StrToInt64(parser.CurAttr.Value(xspio_group_time));
          i := 0;
          while (i < length(list_remote))and
                (t < list_remote[i].Time_u) do
            inc(i);

          SetLength(list_remote,i+1);
          for j := length(list_remote)-2 downto i do
            list_remote[j+1] := list_remote[j];

          list_remote[i].Time_u := t;
          list_remote[i].ID := StrToInt(parser.CurAttr.Value('id'));
        end;
      end;
    ptEndTag:
      begin
        if (parser.CurName = roottag) then
          Break;
      end;
    end;
  end;
  
  DoSyncReportPlanet(pos,list_remote,Socket);
end;

procedure TNetUniTree.FSendReportToSocket(report: TScanbericht;
  Socket: TSplitSocket);
var s: string;
begin
  s := AnsiToUtf8(ScanToXML_(report)) + #0;
  Socket.SendPacket(PChar(s)^,length(s));

  with Socket.HostSocket as TSocketMultiplex,
       TcSConnectionData(LockData('TNetUniTree.FSendReportToSocket')) do
  try
    inc(SendScanCount);
  finally
    UnlockData;
  end;
end;

procedure TNetUniTree.DoSyncReportPlanet(pos: TPlanetPosition;
  list_remote: TReportTimeList; Socket: TSplitSocket);
var ole, rle: Boolean;
    xml: string;
    op, rp: Integer;
    list_own: TReportTimeList;
begin
  list_own := GetPlanetReportList(pos);

  xml := '';
  op := 0;
  rp := 0;
  ole := (op >= length(list_own));     //own_list_end
  rle := (rp >= length(list_remote));  //remote_list_end
  while (not ole) or (not rle) do
  begin

    if (not ole)and(
       (rle)or
       (list_own[op].Time_u > list_remote[rp].Time_u)) then
    begin
      //-> Send report
      FSendReportToSocket(ReportDB[list_own[op].ID],Socket);
      inc(op);
    end
    else
    if (not rle)and(
       (ole)or(list_own[op].Time_u < list_remote[rp].Time_u)) then
    begin
      //<- get report
      xml := xml + Format('<request type="%s" gala="%d" sys="%d" pos="%d" id="%d"',
                          [xspio_group, pos.P[0], pos.P[1], pos.P[2], list_remote[rp].ID]);
      if pos.Mond then
        xml := xml + ' moon="1"/>'
      else xml := xml + '/>';

      inc(rp);
    end
    else //wenn also beide reports die gleiche zeit haben ^= gleiche scans!
    begin
      inc(op);
      inc(rp);
    end;

    ole := (op >= length(list_own));     //own_list_end
    rle := (rp >= length(list_remote))   //remote_list_end
  end;

  if (xml <> '') then
  begin
    xml := xml + #0;
    Socket.SendPacket(PChar(xml)^,length(xml));
  end;
end;

function TUniverseTree.NextPlanet(var Pos: TPlanetPosition): Boolean;
begin
  Result := True;
  Pos.Mond := not Pos.Mond;
  If Pos.Mond = False then
  begin
    Pos.P[2] := Pos.P[2] +1;
    if (Pos.P[2] > TreeDim[2]) then
    begin
      Pos.P[2] := 1;
      Pos.P[1] := Pos.P[1] +1;
      if (Pos.P[1] > TreeDim[1]) then
      begin
        Pos.P[1] := 1;
        Pos.P[0] := Pos.P[0] +1;
        Result := (Pos.P[0] <= TreeDim[0]);
      end;
    end;
  end;
end;

procedure TNetUniTree.DoSync_RecvSyncInfo(Parser: TXMLParser; Socket: TSplitSocket);
var time: int64;
    nulllist: TReportTimeList;

  procedure DoUntilPosition(pos: TAbsPlanetNr;
    const endpos: TAbsPlanetNr);
  var spos: TPlanetPosition;
  begin
    while pos <= endpos do
    begin
      spos := AbsPlanetNrToPlanetPosition(pos);

      if (spos.P[2] = 1)and
         (spos.Mond = False) then
        DoSyncSolSys(spos,low(time),Socket);

      DoSyncReportPlanet(spos,nulllist,Socket);

      inc(pos);
    end;
  end;

  procedure __PositionTag(const Parser: TXMLParser; const Socket: TSplitSocket;
    const pos: TPlanetPosition);
  var roottag: string;
      sync_solsys, sync_planet: Boolean;
  begin
    roottag := Parser.CurName;
    //SolSys muss nur immer beim ersten planeten im solsys
    //gesynct werden!
    sync_solsys := not((pos.P[2] = 1)and(pos.Mond = False));
    //Planet muss immer gesynct werden!
    sync_planet := false;

    if Parser.CurPartType = ptStartTag then
    while Parser.Scan do
    begin
      case Parser.CurPartType of
      ptStartTag, ptEmptyTag:
        begin
          if (Parser.CurName = 'solsystime') then
          begin
            if sync_solsys then
              raise Exception.Create('TNetUniTree.DoSync_Slave: ' +
                'nicht mehr als ein solsystime-Tag erlaubt!');

            time := StrToInt64(parser.CurAttr.Value('time'));
            DoSyncSolSys(pos,time,Socket);
            sync_solsys := True;
          end
          else
          if (Parser.CurName = 'planettimelist') then
          begin
            if sync_planet then
              raise Exception.Create('TNetUniTree.DoSync_Slave: ' +
                'nicht mehr als ein planettimelist-Tag erlaubt!');

            FDoSync_PlanetReportTimeList(Parser,Socket,pos);
            sync_planet := True;
          end;
        end;
      ptEndTag:
        begin
          if (parser.CurName = roottag) then
          begin
            if (not sync_solsys) then
              DoSyncSolSys(pos,low(time),Socket);
            if (not sync_planet) then
              DoSyncReportPlanet(pos,nulllist,Socket);

            break;
          end;
        end;
      end;
    end;
  end;

var rootnode: String;
    pos_a, pos_z, pos_n: TPlanetPosition;
    p: TAbsPlanetNr;
    d: TNetUniTreeSocketData;
begin
  rootnode := Parser.CurName;
  pos_a := StrToPosition(Parser.CurAttr.Value('from'));
  pos_z := StrToPosition(Parser.CurAttr.Value('to'));
  if (not ValidPosition(pos_a))or
     (not ValidPosition(pos_z)) then
    raise Exception.Create('TNetUniTree.DoSync_Slave: ' +
                           'Unvalid start or end coordinates!');

  SetLength(nulllist,0);

  d := TNetUniTreeSocketData(Socket.LockData('TNetUniTree.DoSync_Slave'));
  with d do
  try
    if SyncPos <> PlanetPositionToAbsPlanetNr(pos_a) then
      OutputDebugString(PChar('(SyncPos <> pos_a) ' +
        PositionToStrMond(AbsPlanetNrToPlanetPosition(SyncPos)) + ' <> ' + PositionToStrMond(pos_a)));

    SyncPos := PlanetPositionToAbsPlanetNr(pos_a);
    while Parser.Scan do
    begin
      case Parser.CurPartType of
      ptStartTag, ptEmptyTag:
        begin
          if (Parser.CurName = 'position') then
          begin
            pos_n.P[0] := StrToIntDef(parser.CurAttr.Value(xpos_gala),-1);
            pos_n.P[1] := StrToIntDef(parser.CurAttr.Value(xpos_sys),-1);
            pos_n.P[2] := StrToIntDef(parser.CurAttr.Value(xpos_pos),-1);
            pos_n.Mond := (parser.CurAttr.Value(xpos_moon) = '1');

            if PosBigger(pos_a,pos_n) then
              raise Exception.Create('TNetUniTree.DoSync_RecvSyncInfo: Unvalid position!');

            p := PlanetPositionToAbsPlanetNr(pos_n);
            if (p > SyncPos) then
            begin
              DoUntilPosition(SyncPos, p-1);
              SyncPos := p;
            end;
            __PositionTag(Parser, Socket, pos_n);
            inc(SyncPos);
          end;
        end;
      ptEndTag:
        begin
          if (Parser.CurName = rootnode) then
          begin
            p := PlanetPositionToAbsPlanetNr(pos_z);
            DoUntilPosition(SyncPos, p);
            SyncPos := p+1;
            break;
          end;
        end;
      end;
    end;
  finally
    Socket.UnlockData;
  end;
end;

procedure TNetUniTree.DoSyncSolSys(Pos: TPlanetPosition;
  time_remote: Int64; Socket: TSplitSocket);
var uss: Integer;
    xml: string;
begin
  uss := UniSys(Pos.P[0],Pos.P[1]);
  if (uss < 0)or(time_remote > SolSysDB[uss].Time_u) then
  begin
    xml := Format('<request type="%s" gala="%d" sys="%d"/>',
                  [xsys_group, Pos.P[0], Pos.P[1]]);

    xml := AnsiToUtf8(xml) + #0;
    Socket.SendPacket(PChar(xml)^,length(xml));
  end
  else
  if (time_remote < SolSysDB[uss].Time_u) then
  begin
    FSendSolSysToSocket(SolSysDB[uss],Socket);
  end;
end;

function TNetUniTree.AddNewReport(report: TScanBericht): Integer;
begin
  Result := inherited AddNewReport(report);
  if (Result >= 0) then
  begin
    UniMerge.LockList;
    try
      FSendReport(report,nil);
    finally
      UniMerge.UnlockList;
    end;
  end;
end;

procedure TNetUniTree.FSendReport(report: TScanBericht;
  Skip: TSplitSocket);
var i: integer;
begin
  for i := 0 to UniMerge.Count-1 do
    if (UniMerge.Sockets[i] <> Skip) then
    begin
      FSendReportToSocket(report,UniMerge.Sockets[i]);
    end;
end;

function TNetUniTree.AddNewReportFromSocket(report: TScanBericht;
  Socket: TSplitSocket): Integer;
begin
  Result := inherited AddNewReport(report);

  if (Result >= 0) then
  begin
    FSendReport(report,Socket);

    with Socket.HostSocket as TSocketMultiplex,
      TcSConnectionData(LockData('TNetUniTree.AddNewReportFromSocket')) do
    try
      inc(RecvScanCount);
    finally
      UnlockData;
    end;
  end;
end;

procedure TUniverseTree.DoWork_idle(out Ready: Boolean);
var c, i: integer;
begin
  //Nur wenn am Anfang gestartet wurde, kann er überhaupt fertig werden!
  Ready := (IdlePos.P[0] = 0);
  if Ready then
  begin
    //Nur alle 10 Sekunden! (währ sonst zu viel Auslastung!)
    if (now - LastIdleWork) < 1/24/60/60*10 then
      Exit;

    IdlePos.P[0] := 1;
    IdlePos.P[1] := 1;
    IdlePos.P[2] := 1;
    IdlePos.Mond := false;

    LastIdleWork := now;
  end;

  c := 0;
  while (c < 50)and(ValidPosition(IdlePos)) do
  begin
    with PTreePlanet(IdlePos)^ do
    begin
      while (length(Reports) > FMaxReportsPerPlanet) do
      begin
        DeleteReport(Reports[length(Reports)-1]);
        inc(c);
      end;
      i := 0;
      while (length(Reports) > FMinReportsPerPlanet)and(i < length(Reports)) do
      begin
        if (ReportDB[Reports[i]].Head.Time_u < FMinReportTime) then
        begin
          DeleteReport(Reports[i]);
          inc(c);
        end else inc(i);
      end;
    end;

    NextPlanet(IdlePos);
  end;

  //Wenn irgendwo zwischendrinn ->nicht fertig!
  //ansonsten IdlePos nullen!
  if ValidPosition(IdlePos) then
    Ready := False
  else
    FillChar(IdlePos,SizeOf(IdlePos),0);
end;

function TUniverseTree.FindReport(pos: TPlanetPosition;
  time_u: int64): Integer;
var list: TReportTimeList;
    i: integer;
begin
  Result := -1;
  //Geht sehr schnell, da UniTree verwendet:
  list := GetPlanetReportList(pos);
  for i := 0 to length(list)-1 do
  begin
    if time_u = list[i].Time_u then
    begin
      Result := list[i].ID;
      break;
    end;
  end;
end;

end.

