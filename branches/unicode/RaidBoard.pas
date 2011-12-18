unit RaidBoard;

interface

uses
  {$ifdef CS_USE_NET_COMPS}cS_networking, SplitSocket, MergeSocket,{$endif} OGame_Types, cS_DB, cS_DB_fleetfile, OtherTime,
  SysUtils, LibXmlParser, LibXmlComps, xml_parser_unicode;

type
  TFleetBoard_NotifyFleetArrival = procedure(Sender: TObject; Nr: Integer) of object;
  TFleetBoard = class
  private
    fGameTime: TDeltaSystemTime;
    UniDomainID: string;
  protected
  public
    Fleets: TcSFleetDB;
    History: TcSFleetDB;
    OnFleetArrived: TFleetBoard_NotifyFleetArrival;
    property GameTime: TDeltaSystemTime read fGameTime;
    constructor Create(const SaveDir: String; const UniDomainID: string);
    destructor Destroy; override;
    function AddFleet(fleet: TFleetEvent): Integer; virtual;
    function AddHistoryFleet(fleet: TFleetEvent): Integer;
    procedure DeleteFleet(nr: Integer); virtual;
    procedure DeleteHistoryFleet(nr: Integer);
    procedure DoWork_idle(out Ready: Boolean); virtual;
    function FindNextArrivingFleet(Ziel: TPlanetPosition;
      Auftrag: TFleetEventType; all_jobs: boolean = false): Integer;
    function FindLastArrivedFleet(Ziel: TPlanetPosition;
      all_jobs: boolean = true; Auftrag: TFleetEventType = fet_attack): Integer;
    function GetLast24HoursRaidCount(Position: TPlanetPosition): integer;
    function GetRaidCount(Position: TPlanetPosition): integer;
  end;
{$ifdef CS_USE_NET_COMPS}
  TFleetBoard_NET_SData = class
  public
    Synchronised: Boolean;
    PlayerName: String;
    constructor Create;
  end;
  TFleetBoard_NET = class(TFleetBoard)
  private
    procedure DeletePlayerFleets(Player: String);
  protected
    cS_Serv: TcSServer;
    FleetMerge: TMergeSocket;
    function DoSync_ready(Socket: TSplitSocket): Boolean;
    procedure FleetMergeNewPacket_DoWork(Sender: TObject;
      Socket: TSplitSocket; Data: pointer; Size: Word);
    function AddNewFleetFromSocket(fleet: TFleetEvent;
      Socket: TSplitSocket): Integer;
    procedure DeleteFleetFromSocket(fleet: TFleetEvent;
      Socket: TSplitSocket);
    procedure FleetMergeOnNewSocket(Sender: TObject; Socket: TSplitSocket);
    procedure FleetMergeOnRemoveSocket(Sender: TObject;
      Socket: TSplitSocket);
    procedure FleetMergeOnNewPacket_ReadThread(Sender: TObject;
      Socket: TSplitSocket);  
  public
    constructor Create(SaveDir: String; UniDomainID: string;
      cSServer: TcSServer);
    procedure DoWork_idle(out Ready: Boolean); override;
    procedure DeleteFleet(nr: Integer); override;
    function AddFleet(fleet: TFleetEvent): Integer; override;
    destructor Destroy; override;
  end;
{$endif}

function FindFleet(Start, Ziel: TPlanetPosition;
      Auftrag: TFleetEventType; Ankunft: Int64; Spieler: String;
      DB: TcSFleetDB): Integer;

implementation

uses cS_XML, Classes, Prog_Unit, Windows;

function TFleetBoard.AddFleet(fleet: TFleetEvent): Integer;
begin
  Result := -1;
  if  ValidPosition(fleet.head.origin) and
      ValidPosition(fleet.head.target) and
     (fleet.head.arrival_time_u > GameTime.UnixTime)and
     (FindFleet(fleet.head.origin, fleet.head.target,
                fleet.head.eventtype, fleet.head.arrival_time_u,
                fleet.head.player, Fleets) = -1) then
  begin
    Result := Fleets.AddFleet(fleet);
  end;
end;

function TFleetBoard.AddHistoryFleet(fleet: TFleetEvent): Integer;
begin
  Result := -1;
  if (fleet.head.arrival_time_u < GameTime.UnixTime)and
     (FindFleet(fleet.head.origin, fleet.head.target,
                fleet.head.eventtype, fleet.head.arrival_time_u, fleet.head.player, History) = -1) then
  begin
    Result := History.AddFleet(fleet);
  end;
end;

function TFleetBoard.GetLast24HoursRaidCount(Position: TPlanetPosition): integer;
var i: integer;
begin
  Result := 0;
  for i := 0 to History.Count-1 do
    if SamePlanet(History[i].head.target,Position)and
       (History[i].head.eventtype = fet_attack)and
       (not (fef_return in History[i].head.eventflags))and
       (History[i].head.arrival_time_u > GameTime.UnixTime - ({1tag in sekunden}24*60*60)) then
      inc(Result);
end;

function TFleetBoard.GetRaidCount(Position: TPlanetPosition): integer;
var i: integer;
begin
  Result := 0;
  for i := 0 to History.Count-1 do
    if SamePlanet(History[i].head.target,Position)and
       (History[i].head.eventtype = fet_attack)and
       (not (fef_return in History[i].head.eventflags)) then
      inc(Result);
end;

constructor TFleetBoard.Create(const SaveDir: String; const UniDomainID: string);

  function __importold(Filename: string; fleetDB: TcSFleetDB_for_File): boolean;
  var old: TcSFleetDB_for_File;
      i: integer;
  begin
    old := TcSFleetDB_for_File.Create(Filename, UniDomainID);
    try
      for i := 0 to old.Count-1 do
      begin
        fleetDB.AddFleet(old.Fleets[i]);
      end;
    finally
      old.Free;
    end;
    Result := true;
  end;

  function openFleetDBFile(Filename: string): TcSFleetDB_for_File;
  begin
    result := TcSFleetDB_for_File.Create(Filename, UniDomainID);
    if result.IsOldFormat then
    begin
      result.Free;
      RenameFile(Filename,Filename+'.old');
      result := TcSFleetDB_for_File.Create(Filename, UniDomainID);
      if __importold(Filename+'.old', result) then
        SysUtils.DeleteFile(Filename+'.old');
    end;
  end;

begin
  inherited Create();
  Self.UniDomainID := UniDomainID;
  fGameTime := TDeltaSystemTime.Create;

  Fleets := openFleetDBFile(SaveDir + 'fleets.csflt');
  History := openFleetDBFile(SaveDir + 'fleets_history.csflt');
end;

procedure TFleetBoard.DeleteFleet(nr: Integer);
begin
  if (nr < 0)or(nr >= Fleets.Count) then
    raise Exception.Create(
      'TFleetBoard.DeleteFleet: nr auserhalb des gültigen Bereichs');

  if (nr  <> Fleets.Count-1) then
    Fleets[nr] := Fleets[Fleets.Count-1];
  Fleets.DeleteLastFleet;
end;

procedure TFleetBoard.DeleteHistoryFleet(nr: Integer);
begin
  if (nr < 0)or(nr >= History.Count) then
    raise Exception.Create(
      'TFleetBoard.DeleteHistoryFleet: nr auserhalb des gültigen Bereichs');

  if (nr  <> History.Count-1) then
    History[nr] := History[History.Count-1];
  History.DeleteLastFleet;
end;

{$ifdef CS_USE_NET_COMPS}
procedure TFleetBoard_NET.DeletePlayerFleets(Player: String);
var i: Integer;
begin
  i := 0;
  while (i < Fleets.Count) do
  begin
    if (Fleets[i].head.player = Player) then
    begin
      //Die Spielernamenabfrage umgehen:
      inherited DeleteFleet(i);
    end
    else inc(i);
  end;
end;
{$endif}

destructor TFleetBoard.Destroy;
begin
  Fleets.Free;
  History.Free;
  GameTime.Free;
end;

procedure TFleetBoard.DoWork_idle(out Ready: Boolean);
var i: integer;
begin
  i := 0;
  while (i < Fleets.Count) do
  begin
    if (Fleets[i].head.arrival_time_u <= GameTime.UnixTime) then
    begin
      if Assigned(OnFleetArrived) then
        OnFleetArrived(Self,i);

      if Fleets[i].head.player = ODataBase.Username then
        History.AddFleet(Fleets[i]);
        
      Fleets[i] := Fleets[Fleets.Count-1];
      Fleets.DeleteLastFleet;
    end
    else inc(i);
  end;
end;

function FindFleet(Start, Ziel: TPlanetPosition;
  Auftrag: TFleetEventType; Ankunft: Int64; Spieler: String;
  DB: TcSFleetDB): Integer;
var i: integer;
begin
  Result := -1;
  for i := 0 to DB.Count-1 do
  begin
    if (DB[i].head.arrival_time_u = Ankunft)and
       (DB[i].head.player = Spieler)and
       (DB[i].head.eventtype = Auftrag)and
       (SamePlanet(DB[i].head.origin,Start))and
       (SamePlanet(DB[i].head.target,Ziel)) then
    begin
      Result := i;
      break;
    end;
  end;
end;

function TFleetBoard.FindNextArrivingFleet(Ziel: TPlanetPosition;
  Auftrag: TFleetEventType; all_jobs: boolean = false): Integer;
var i: integer;
    t: int64;
begin
  Result := -1;
  t := high(t);
  for i := 0 to Fleets.Count-1 do
  begin
    if (SamePlanet(Fleets[i].head.target,Ziel)) and
       (all_jobs or (Fleets[i].head.eventtype = Auftrag))and
       (Fleets[i].head.arrival_time_u < t) then
    begin
      Result := i;
      t := Fleets[i].head.arrival_time_u;
    end;
  end;
end;

function TFleetBoard.FindLastArrivedFleet(Ziel: TPlanetPosition;
  all_jobs: boolean = true; Auftrag: TFleetEventType = fet_attack): Integer;
var i: integer;
    t: int64;
begin
  Result := -1;
  t := 0;
  for i := 0 to History.Count-1 do
  begin
    if (SamePlanet(History[i].head.target,Ziel)) and
       (all_jobs or (History[i].head.eventtype = Auftrag))and
       (History[i].head.arrival_time_u > t) then
    begin
      Result := i;
      t := History[i].head.arrival_time_u;
    end;
  end;
end;

{$ifdef CS_USE_NET_COMPS}
function TFleetBoard_NET.AddFleet(fleet: TFleetEvent): Integer;
var s: string;
begin
  //Siehe delete, add, addfromsocket
  Result := inherited AddFleet(fleet);
  
  if (Result >= 0) then
  begin
    s := AnsiToUtf8(FleetToXML_(fleet));
    FleetMerge.SendPacket(PChar(s)^,length(s));
  end;
end;

function TFleetBoard_NET.AddNewFleetFromSocket(fleet: TFleetEvent;
  Socket: TSplitSocket): Integer;
var s: string;
begin
  //Siehe delete, add, addfromsocket
  Result := inherited AddFleet(fleet);
  if (Result >= 0) then
  begin
    s := AnsiToUtf8(FleetToXML_(fleet));
    FleetMerge.SendPacket(PChar(s)^,length(s),Socket);
  end;
end;

procedure TFleetBoard_NET.DeleteFleetFromSocket(fleet: TFleetEvent;
  Socket: TSplitSocket);
var s: string;
    i: integer;
begin
  //Siehe delete, add, addfromsocket, deletefromsocket
  i := FindFleet(fleet.head.origin,fleet.head.target,fleet.head.eventtype,
                 fleet.head.arrival_time_u,fleet.head.player,Fleets);
  if (i >= 0) then
  begin
    inherited DeleteFleet(i);
    s := '<delete>' + AnsiToUtf8(FleetToXML_(fleet)) + '</delete>';
    FleetMerge.SendPacket(PChar(s)^,length(s),Socket);
  end;
end;

constructor TFleetBoard_NET.Create(SaveDir: String; UniDomainID: String;
  cSServer: TcSServer);
begin
  inherited Create(SaveDir, UniDomainID);
  cS_Serv := cSServer;
  FleetMerge := TMergeSocket.Create;
  cS_Serv.FFleetMerge := FleetMerge;

  FleetMerge.OnNewPacket_ReadThread := FleetMergeOnNewPacket_ReadThread;
  FleetMerge.OnNewSocket := FleetMergeOnNewSocket;
  FleetMerge.OnRemoveSocket := FleetMergeOnRemoveSocket;
end;

procedure TFleetBoard_NET.DeleteFleet(nr: Integer);
var s: string;
begin
  if (Fleets[nr].head.player = ODataBase.Username) then
  begin
    //Siehe delete, add, addfromsocket, deletefromsocket
    s := '<delete>' + AnsiToUtf8(FleetToXML_(Fleets[nr])) + '</delete>';
    inherited;
    FleetMerge.SendPacket(PChar(s)^,length(s));
  end;
end;

destructor TFleetBoard_NET.Destroy;
begin
  cS_Serv.FFleetMerge := nil;
  FleetMerge.Free;
end;

function TFleetBoard_NET.DoSync_ready(
  Socket: TSplitSocket): Boolean;
var p: TFleetBoard_NET_SData;
    i: integer;
    s: string;
begin
  Result := True;
  p := TFleetBoard_NET_SData(Socket.LockData('TFleetBoard_NET.DoSync_ready'));
  try
    if (not p.Synchronised) then
    begin
      for i := 0 to Fleets.Count-1 do
      begin
        s := AnsiToUtf8(FleetToXML_(Fleets[i]));
        Socket.SendPacket(PChar(s)^,length(s));
      end;
      p.Synchronised := True;
    end;
  finally
    Socket.UnlockData;
  end;
end;

procedure TFleetBoard_NET.DoWork_idle(out Ready: Boolean);
var Data: pointer;
    Size: Word;
    Socket: TSplitSocket;
    R: Boolean;
    i: Integer;
begin
  Ready := true;
  inherited DoWork_idle(Ready);

  FleetMerge.LockList;
  try
    for i := 0 to FleetMerge.Count-1 do
    begin
      Socket := FleetMerge.Sockets[i];
      try
        if (not DoSync_ready(Socket)) then
          Ready := False;

        R := Socket.GetPacket(Data,Size);
        if R then
        begin
          FleetMergeNewPacket_DoWork(Self,Socket,Data,Size);
          FreeMem(Data);
          Ready := False;
        end;
      except
        on E: Exception do
          cS_Serv.log.AddEntry(Socket.HostSocket,'TStatPointsNet.DoWork_idle' +
            ': Exception(' + E.ClassName +
            '): ' + E.Message);
      end;
    end;
  finally
    FleetMerge.UnlockList;
  end;
end;

procedure TFleetBoard_NET.FleetMergeNewPacket_DoWork(Sender: TObject;
  Socket: TSplitSocket; Data: pointer; Size: Word);
var s: AnsiString;
    parser: TUnicodeXmlParser;
    delete: Boolean;
    fleet: TFleetEvent;
begin
  parser := TUnicodeXmlParser.Create;
  try
    SetLength(s, Size);
    Move(Data^, PAnsiChar(s)^, Size);
    
    parser.LoadFromBuffer(PAnsiChar(s));
    parser.StartScan;

    delete := false;
    while parser.Scan do
    begin
      case parser.CurPartType of
        ptStartTag, ptEmptyTag:
          begin
            if (parser.CurName = xflt_group)and
               (parse_fleet(parser,fleet)) then
              if delete then
                DeleteFleetFromSocket(fleet,Socket)
              else
                AddNewFleetFromSocket(fleet,Socket)
            else
            if (parser.CurName = 'delete') then
              delete := (parser.CurPartType = ptStartTag);
          end;

        ptEndTag:
          if (parser.CurName = 'delete') then
            delete := false;
      end;
    end;
  finally
    parser.Free;
  end;
end;

procedure TFleetBoard_NET.FleetMergeOnNewPacket_ReadThread(Sender: TObject;
  Socket: TSplitSocket);
begin
  WakeMainThread(Self);
end;

procedure TFleetBoard_NET.FleetMergeOnNewSocket(Sender: TObject;
  Socket: TSplitSocket);
var p: TFleetBoard_NET_SData;
begin
  Socket.LockData('TFleetBoard_NET.FleetMergeOnNewSocket');
  try
    p := TFleetBoard_NET_SData.Create;
    Socket.SetData_locked_(p);
    with TcSConnectionData(TSocketMultiplex(Socket.HostSocket).LockData('TFleetBoard_NET.FleetMergeOnNewSocket')) do
      try
        p.PlayerName := RemoteUser;
      finally
        TSocketMultiplex(Socket.HostSocket).UnlockData;
      end;

  finally
    Socket.UnlockData;
  end;
end;

procedure TFleetBoard_NET.FleetMergeOnRemoveSocket(Sender: TObject;
  Socket: TSplitSocket);
var p: TFleetBoard_NET_SData;
begin
  p := TFleetBoard_NET_SData(Socket.LockData('TFleetBoard_NET.FleetMergeOnRemoveSocket'));
  try
    DeletePlayerFleets(p.PlayerName);
    p.Free;
    Socket.SetData_locked_(nil);
  finally
    Socket.UnlockData;
  end;
end;

constructor TFleetBoard_NET_SData.Create;
begin
  inherited;
  Synchronised := false;
  PlayerName := '';
end;
{$endif}

end.
