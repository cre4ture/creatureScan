unit cS_networking;

interface

uses
  Classes, TCPSocket, MultiplexList, SplitSocket, OGame_Types,
  ThreadProtocolObject, SysUtils, MergeSocket, SyncObjs, Forms, Inifiles;

const
  crOVersionName = 'cS_networking';
  crOVersionID = 8;

type
  TRight = (gr_Scan,gr_System,gr_Raids,gr_Chat,gr_Stats);
  TRights = set of TRight;
  TGalaxyRight = Byte;
  TGalaxyRights = set of TGalaxyRight;
  TGroup = Record
    Name: string;
    Pass: string;
    Rights: TRights;
    ScanGalaxys: TGalaxyRights;
    SystemGalaxys: TGalaxyRights;
  end;
  TLoginData = record
    ProgName: String[25];
    UniName, SiteName: String[255];
    protVersion: Word;
    Master: Boolean;
    GalaxyCount,
    SolsysCount,
    PlanetCount: Word;
    LangIndex: TLanguage;
    PlayerName: TPlayerName_utf8;
    Login: TGroup;
  end;
  TcSConnectionData = class
  public
    ConnectionTime: Int64;
    UserRights: TGroup;
    RemoteUser: TPlayerName_utf8;
    RecvStatCount: Cardinal;
    SendStatCount: Cardinal;
    SendScanCount: Cardinal;
    SendSystemCount: Cardinal;
    RecvScanCount: Cardinal;
    RecvSystemCount: Cardinal;
    ActualAction: string;
    completeProcess: Word;
    partProcess: byte;
    constructor Create;
    destructor Destroy; override;
  end;
  TConInf = record
    IP: String;
    Port: Integer;
    UniSyncPos: TAbsPlanetNr;
    RemoteUser: string;
    UserRights: TGroup;
    SendScanCount: Cardinal;
    SendSystemCount: Cardinal;
    RecvScanCount: Cardinal;
    RecvSystemCount: Cardinal;
    SendBuffer: Integer;
  end;
  //Um Zwischen FullBuffered und Normal umzuschalten, ändere hier den Typ
  //TcSSocketMultiplex auf
  // - TSocketMultiplexFullBuffered   = FullBuffered
  // - TSocketMultiplex               = Normal
  TcSSocketMultiplex = class(TSocketMultiplexFullBuffered)
  public
    function LockData(Description: String): TcSConnectionData;
  end;
  TcSSocketMultiplexList = class(TSocketMultiplexList)
  private
    function GetSocket(Index: Integer): TcSSocketMultiplex;
  public
    property Sockets[i: integer]: TcSSocketMultiplex read GetSocket; default;
  end;
  TUserList = class
  private
    FUsers: TThreadList;
    Flu_Users: TList;
    function GetUsers(nr: Integer): TGroup;
    procedure SetUsers(nr: Integer; user: TGroup);
    function GetUserCount: Integer;
    procedure SetUserCount(c: Integer);
  public
    procedure LockUsers;
    property Users[nr: Integer]: TGroup read GetUsers write SetUsers;
    property UserCount: Integer read GetUserCount write SetUserCount;
    procedure UnlockUsers;
    function AddUser(user: TGroup): Integer;
    procedure Save(ini: TInifile; Section: String);
    procedure Load(ini: TInifile; Section: String);
    procedure DeleteUser(nr: Integer);
    function GetRights(Login: TGroup): TGroup;
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
  end;
  EcSServerLoginFailed = class(Exception);
  TcSServer = class
  private
    finifile: string;
    function GetServerActive: Boolean;
    function GetServerPort: Integer;
    function GetConnections(nr: Integer): TConInf;
    procedure FGetConInfo_ForEachSplitSocket(Sender: TObject;
      Socket: TSplitSocket; Data: pointer);
    function getlogindata(Master: Boolean): TLoginData;
  protected
    FSocketMList: TcSSocketMultiplexList;
    FSimpleServer: TSimpleServer;
    FLoginMerge: TMergeSocket;
    procedure FSimpleServerClientConnect(Sender: TObject;
      newSocket: TSocket);
    procedure FSocketMListOnNewSocket(Sender: TObject;
      SMulti: TSocketMultiplex);
    procedure FSocketMListOnRemoveSocket(Sender: TObject;
      SMulti: TSocketMultiplex);
    procedure FSocketMListOnOpeningTunnel_ReadThread(Sender: TObject;
      SMulti: TSocketMultiplex; Tunnel: TSplitSocket;
      var Accept: Boolean);
    procedure FSocketMListOnOpenedTunnel(Sender: TObject;
      SMulti: TSocketMultiplex; Tunnel: TSplitSocket);
    procedure FLoginMergeOnNewPacket_ReadThread(Sender: TObject;
      Socket: TSplitSocket);
    procedure FLoginMergeOnNewSocket(Sender: TObject;
      Socket: TSplitSocket);
    function FSocketMListOnHandleException(Sender: TThread; E: Exception;
      msg: String): Boolean;
    function DoSocket(sm: TSocketMultiplex): boolean;
  public
    Users: TUserList;
    log: TThreadProtocol;
    FChatMerge: TMergeSocket;
    FUniMerge: TMergeSocket;
    FStatMerges: array[TStatNameType,TStatPointType] of TMergeSocket;
    FFleetMerge: TMergeSocket;
    property ServerActive: Boolean read GetServerActive;
    property ServerPort: Integer read GetServerPort;
    constructor Create(alog: TThreadProtocol; inifile: String);
    destructor Destroy; override;
    function StartListen(Port: Integer): Boolean;
    procedure StopListen;
    function ConnectTo(Host: String; Port: Integer; aLoginData: TGroup): Boolean;
    function ConnectionCount: Integer;
    property Connections[nr: Integer]: TConInf read GetConnections;
    procedure Disconnect(cNr: Integer);
    procedure DoWork_idle(out Ready: Boolean);
    function FindUsername(name: string): integer;
  end;

const
  {PI-Nummern und deren Zweck}
  pi_login = 1; //User/Rechte - Management
  pi_chat = 100;
  pi_uni = 21;
  pi_fleet = 31;
  pi_stats: array[TStatNameType,TStatPointType] of Word =
                  ((200,201,202),(210,211,212));

function RightsToStr(Rights: TGroup): String;
procedure StrToRights(var Rights: TGroup; s: string);
procedure FusionRights(var myRights: TGroup; remoteRights: TGroup);

implementation

uses DateUtils, Prog_Unit, UniTree;

procedure FusionRights(var myRights: TGroup; remoteRights: TGroup);
var Right: TRight;
    Gala: TGalaxyRight;
begin
  for Right := low(right) to high(right) do
    if not(Right in remoteRights.Rights) then
      exclude(myRights.Rights,Right);

  for Gala := low(Gala) to high(Gala) do
    if not(Gala in remoteRights.ScanGalaxys) then
      exclude(myRights.ScanGalaxys,Gala);
  for Gala := low(Gala) to high(Gala) do
    if not(Gala in remoteRights.SystemGalaxys) then
      exclude(myRights.SystemGalaxys,Gala);
end;

procedure StrToRights(var Rights: TGroup; s: string);
var r: TRight;
    gr: TGalaxyRight;
begin
  Rights.Rights := [];
  Rights.ScanGalaxys := [];
  Rights.SystemGalaxys := [];
  r := low(r);
  while (r <= high(r))and(AnsiChar(s[1]) in ['0','1']) do
  begin
    if s[1] = '1' then include(Rights.Rights,r);
    delete(s,1,1);
    if r < high(r) then inc(r);
  end;
  delete(s,1,1);
  gr := 1;
  while (gr <= max_Galaxy)and(AnsiChar(s[1]) in ['0','1']) do
  begin
    if s[1] = '1' then include(Rights.ScanGalaxys,gr);
    delete(s,1,1);
    inc(gr);
  end;
  delete(s,1,1);
  gr := 1;
  while (gr <= max_Galaxy)and(length(s)>0)and(AnsiChar(s[1]) in ['0','1']) do
  begin
    if s[1] = '1' then include(Rights.SystemGalaxys,gr);
    delete(s,1,1);
    inc(gr);
  end;
end;


function RightsToStr(Rights: TGroup): String;
var r: TRight;
    gr: TGalaxyRight;
begin
  Result := '';
  for r := low(r) to high(r) do
    if (r in Rights.Rights) then Result := Result + '1' else Result := Result + '0';
  Result := Result + '/';
  for gr := 1 to max_Galaxy do
    if (gr in Rights.ScanGalaxys) then Result := Result + '1' else Result := Result + '0';
  Result := Result + '/';
  for gr := 1 to max_Galaxy do
    if (gr in Rights.SystemGalaxys) then Result := Result + '1' else Result := Result + '0';
  Result := Result + '/';
end;


procedure TcSServer.FSocketMListOnNewSocket(Sender: TObject;
  SMulti: TSocketMultiplex);
var p: TcSConnectionData;
    addr: TTCPHost;
begin
  addr := SMulti.RemoteHost;
  log.AddEntry(SMulti,
               Format('Connected(%s:%d)',[addr.IP, addr.Port]),
               llNormal);

  //Datenspeicher für Verbindung einrichten
  p := TcSConnectionData.Create;
  //Zeitstempel
  p.ConnectionTime := DateTimeToUnix(Now);
  
  SMulti.LockData('TcSServer.FSocketMListOnNewSocket');
  SMulti.SetData_locked_(P);
  SMulti.UnlockData;
end;

procedure TcSServer.FSocketMListOnRemoveSocket(Sender: TObject;
  SMulti: TSocketMultiplex);
var Data: TcSConnectionData;
    addr: TTCPHost;
begin
  log.AddEntry(SMulti,
               Format('Disconnected(%s:%d)',[addr.IP, addr.Port]),
               llNormal);

  Data := SMulti.LockData('TcSServer.FSocketMListOnRemoveSocket');
  try
    if (Data <> nil) then
    begin
      with Data do
      begin
        log.AddEntry(SMulti,'Username: ' + RemoteUser +
                            ' Transfer: SndScn:' + IntToStr(SendScanCount) +
                            ' SndSys:' + IntToStr(SendSystemCount) +
                            ' RcvScn:' + IntToStr(RecvScanCount) +
                            ' RcvSys:' + IntToStr(RecvSystemCount), llNormal);
      end;
      Data.Free;
      SMulti.SetData_locked_(nil);
    end
    else raise Exception.Create('TcSServer.FSocketMListOnRemoveSocket: ' +
                                'not Assigned(SMulti.Data)!');
  finally
    SMulti.UnlockData;
  end;
end;

procedure TcSServer.FSocketMListOnOpeningTunnel_ReadThread(Sender: TObject;
  SMulti: TSocketMultiplex; Tunnel: TSplitSocket;
  var Accept: Boolean);
var snt: TStatNameType;
    spt: TStatPointType;
begin
  Accept := (Tunnel.WorkProcessIndex = pi_login);

  if (not Accept) then
  begin
    with TcSConnectionData(SMulti.LockData('TcSServer.FSocketMListOnOpeningTunnel_ReadThread')) do
    begin
      try
        Accept :=
             ((Tunnel.WorkProcessIndex = pi_chat)and
               (gr_Chat in UserRights.Rights))or
              ((Tunnel.WorkProcessIndex = pi_uni)and
               (gr_System in UserRights.Rights))or
              ((Tunnel.WorkProcessIndex = pi_fleet)and
               (gr_raids in UserRights.Rights))or
              (false);

        //Statistiken:
        if (not Accept)and(gr_Stats in UserRights.Rights) then
          for snt := low(snt) to high(snt) do
          begin
            for spt := low(spt) to high(spt) do
            begin
              if (Tunnel.WorkProcessIndex = pi_stats[snt,spt]) then
              begin
                Accept := True;
                break;
              end;
            end;
            if Accept then break;
          end;
      finally
        SMulti.UnlockData;
      end;
    end;
  end;

  if not Accept then
    raise Exception.Create('TcSServer.FSocketMListOnOpeningTunnel: ' +
      'Verbindung nicht zugelassen(' +
      IntToStr(Tunnel.WorkProcessIndex) + ')');
end;

procedure TcSServer.FSocketMListOnOpenedTunnel(Sender: TObject;
  SMulti: TSocketMultiplex; Tunnel: TSplitSocket);
var e: Boolean;
    snt: TStatNameType;
    spt: TStatPointType;
begin
  case Tunnel.WorkProcessIndex of
    pi_login: FLoginMerge.AddSocket(Tunnel);
    pi_chat: if FChatMerge <> nil then FChatMerge.AddSocket(Tunnel);
    pi_uni: if FUniMerge <> nil then FUniMerge.AddSocket(Tunnel);
    pi_fleet: if FFleetMerge <> nil then FFleetMerge.AddSocket(Tunnel);
  else
    e := false;
    for snt := low(snt) to high(snt) do
    begin
      for spt := low(spt) to high(spt) do
      begin
        if (Tunnel.WorkProcessIndex = pi_stats[snt,spt])and
           (FStatMerges[snt,spt] <> nil) then
        begin
          e := True;
          FStatMerges[snt,spt].AddSocket(Tunnel);
        end;
      end;
      if e then break;
    end;
  end;
end;

constructor TcSServer.Create(alog: TThreadProtocol; inifile: String);
var ini: TIniFile;
begin
  inherited Create;
  log := alog;
  Users := TUserList.Create;
  finifile := inifile;
  ini := TIniFile.Create(finifile);
  Users.Load(ini, 'server');
  ini.Free;

  FLoginMerge := TMergeSocket.Create;
  FLoginMerge.OnNewPacket_ReadThread := FLoginMergeOnNewPacket_ReadThread;
  FLoginMerge.OnNewSocket := FLoginMergeOnNewSocket;
  FSocketMList := TcSSocketMultiplexList.Create;
  FSocketMList.OnNewSocket := FSocketMListOnNewSocket;
  FSocketMList.OnSocketOpeningTunnel_ReadThread :=
       FSocketMListOnOpeningTunnel_ReadThread;
  FSocketMList.OnSocketOpenedTunnel := FSocketMListOnOpenedTunnel;
  FSocketMList.OnRemoveSocket := FSocketMListOnRemoveSocket;
  FSocketMList.OnHandleException := FSocketMListOnHandleException;
  FSimpleServer := TSimpleServer.Create;
  FSimpleServer.OnClientConnect := FSimpleServerClientConnect;
end;

destructor TcSServer.Destroy;
var ini: TIniFile;
begin
  try
    ini := TIniFile.Create(finifile);
    Users.Save(ini, 'server');
    ini.Free;
  except

  end;

  FSimpleServer.Free;
  FSocketMList.Free;
  FLoginMerge.Free;
  Users.Free;
  inherited;
end;

function TcSServer.StartListen(Port: Integer): Boolean;
begin
  Result := FSimpleServer.Start(Port);
end;

procedure TcSServer.StopListen;
begin
  FSimpleServer.Stop;
end;

procedure TcSServer.FSimpleServerClientConnect(Sender: TObject;
  newSocket: TSocket);
var sm: TSocketMultiplex;
begin
  //old:
  //  sm := FSocketMList.AddSocketMultiplex(newSocket,False);

  //new: (weil verwedung von TcSSocketMultiplex!)
  sm := TcSSocketMultiplex.Create(TTCPSocket.Create(newSocket), False);
  FSocketMList.AddSocketMultiplex(sm);
end;

function TcSServer.GetServerActive: Boolean;
begin
  Result := FSimpleServer.ServerActive;
end;

function TcSServer.GetServerPort: Integer;
begin
  Result := FSimpleServer.ServerPort;
end;

function TcSServer.ConnectTo(Host: String; Port: Integer; aLoginData: TGroup): Boolean;
var sm: TcSSocketMultiplex;
    tcp: TTCPSocket;
begin
  tcp := TTCPSocket.Create;
  Result := tcp.Connect(Host,Port);
  if Result then
  begin
    sm := TcSSocketMultiplex.Create(tcp,True);
    FSocketMList.AddSocketMultiplex(sm);
    with sm.LockData('TcSServer.ConnectTo') do
    try
      UserRights := aLoginData;
    finally
      sm.UnlockData;
    end;
  end
  else tcp.Free;
end;

function TcSServer.ConnectionCount: Integer;
begin
  Result := FSocketMList.Count;
end;

function TcSServer.GetConnections(nr: Integer): TConInf;
begin
  if (nr >= 0)and(FSocketMList.Count > nr) then
  begin
    FillChar(Result, SizeOf(Result), 0);

    Result.IP := FSocketMList[nr].RemoteHost.IP;
    Result.Port := FSocketMList[nr].RemoteHost.Port;
    with FSocketMList[nr].LockData('TcSServer.GetConnections') do
    try
      Result.RemoteUser := RemoteUser;
      Result.UserRights := UserRights;
      Result.SendScanCount := SendScanCount;
      Result.SendSystemCount := SendSystemCount;
      Result.RecvScanCount := RecvScanCount;
      Result.RecvSystemCount := RecvSystemCount;
    finally
      FSocketMList[nr].UnlockData;
    end;
    if (FSocketMList[nr] is TSocketMultiplexFullBuffered) then
    begin
      with FSocketMList[nr] as TSocketMultiplexFullBuffered do
      begin
        Result.SendBuffer := GetSendBufferCount;
      end;
    end else Result.SendBuffer := -1;

    FSocketMList[nr].ForEachTunnel(FGetConInfo_ForEachSplitSocket, @Result);
  end;
end;

procedure TcSServer.FLoginMergeOnNewPacket_ReadThread(Sender: TObject;
  Socket: TSplitSocket);
var p: pointer;
    size: Word;
    success: Boolean;
    Vinf: TLoginData;
    cscond: TcSConnectionData;
begin
  while Socket.GetPacket(p,size) do
  try
    if (size = sizeof(TLoginData)) then
    begin
      with TLoginData(p^) do
      begin
        if (ProgName = crOVersionName)and
           (protVersion = crOVersionID)and
           (Master = not TSocketMultiplex(Socket.HostSocket).Master)and
           (UniName = ODataBase.UniDomain)and
           (SiteName = ODataBase.game_domain)and
           (GalaxyCount = max_Galaxy)and
           (SolsysCount = max_Systems)and
           (PlanetCount = max_Planeten)and
           (LangIndex = domainTolangindex(ODataBase.game_domain)) then
        begin
          cscond := TcSConnectionData(TSocketMultiplex(Socket.HostSocket).LockData('TcSServer.FLoginMergeOnNewPacket_ReadThread'));
          with cscond do
          try
            if (not TSocketMultiplex(Socket.HostSocket).Master) then
            begin
              //not Master -> Server: Muss Rechte suchen:
              UserRights := Users.GetRights(Login);
              Vinf := getlogindata(TSocketMultiplex(Socket.HostSocket).Master);
              Vinf.Login := UserRights;
              Socket.SendPacket(Vinf, Sizeof(Vinf));
            end
            else
            begin
              //Master -> Client: Rechte stehen schon in "UserRights"
              FusionRights(UserRights, Login);
            end;
            Login := UserRights;
            RemoteUser := PlayerName;
            success := UserRights.Name <> '';
          finally
            TSocketMultiplex(Socket.HostSocket).UnlockData;
          end;

          if success then
          begin
            log.AddEntry(Socket.HostSocket,
                         'Login successfull (Username: ' + Login.Name + ')',
                         llNormal);
          end
          else
          begin
            log.AddEntry(Socket.HostSocket,
                         'Login failed (Username: ' + Login.Name + ')',
                         llNormal);
                         
            raise EcSServerLoginFailed.Create(
              'TcSServer.FLoginMergeOnNewPacket_ReadThread: Invalid Login');
          end;
                       
        end else log.AddEntry(Socket.HostSocket,'Login failed!', llNormal);
      end;
    end else raise Exception.Create(
                     'TcSServer.FLoginMergeOnNewPacket_ReadThread: ' +
                     'Packet mit falscher Größe vorhanden! (critical error)');
  finally
    FreeMem(p);
  end;
end;

procedure TcSServer.FLoginMergeOnNewSocket(Sender: TObject;
  Socket: TSplitSocket);
var VInf: TLoginData;
begin
  if TcSSocketMultiplex(Socket.HostSocket).Master then
  begin
    //Sende Logindaten:
    VInf := getlogindata(TcSSocketMultiplex(Socket.HostSocket).Master);

    with TcSSocketMultiplex(Socket.HostSocket).LockData('TcSServer.FLoginMergeOnNewSocket') do
    try
      VInf.Login := UserRights;
    finally
      TcSSocketMultiplex(Socket.HostSocket).UnlockData;
    end;
    
    Socket.SendPacket(VInf,Sizeof(VInf));
  end
  else
  begin

  end;
end;

function TcSServer.DoSocket(sm: TSocketMultiplex): boolean;
var tunnel: TSplitSocket;

  function CheckStats: boolean;
  var snt: TStatNameType;
      spt: TStatPointType;
  begin
    Result := False;
    for snt := low(snt) to high(snt) do
      for spt := low(spt) to high(spt) do
      begin
        if (not sm.TunnelExists(pi_stats[snt,spt])) then
        begin
          sm.OpenTunnel(pi_stats[snt,spt], tunnel);

          Result := True;
          Exit;
        end;
      end;
  end;

begin
  Result := true;
  if (not sm.Master)and
     (not sm.TunnelExists(pi_login)) then
  begin
    sm.OpenTunnel(pi_login, tunnel);
  end
  else
  with TcSConnectionData(sm.LockData('TcSServer.DoSocket')) do
  try
    if (not sm.Master)and
       (gr_Chat in UserRights.Rights)and
       (not sm.TunnelExists(pi_chat)) then
    begin
      sm.OpenTunnel(pi_chat, tunnel);
    end
    else
      if (not sm.Master)and
         (gr_System in UserRights.Rights)and
         (not sm.TunnelExists(pi_uni)) then
        sm.OpenTunnel(pi_uni, tunnel)
      else
        if (not sm.Master)and
           (gr_Stats in UserRights.Rights) and
           (CheckStats) then
        begin
          ;//Nothing
        end
        else
          if (not sm.Master)and
             (gr_raids in UserRights.Rights) and
             (not sm.TunnelExists(pi_fleet)) then
          begin
            sm.OpenTunnel(pi_fleet, tunnel)
          end
        else Result := false;
  finally
    sm.UnlockData;
  end;
end;

procedure TcSServer.Disconnect(cNr: Integer);
begin
  if (cNR >= 0)and(cNr < FSocketMList.Count) then
  begin
    FSocketMList[cNr].Free;
  end;
end;

function TcSServer.FSocketMListOnHandleException(Sender: TThread; E: Exception;
  msg: String): Boolean;
var s: string;
begin
  s := 'Exception(' + E.ClassName + '): ' + E.Message + '////' + msg;
  log.AddEntry(Sender,s,llNormal);
  Result := False;
end;

constructor TcSConnectionData.Create;
begin
  ConnectionTime := 0;
  FillChar(UserRights,SizeOf(UserRights),0);
  RemoteUser := '';
  SendStatCount := 0;
  RecvStatCount := 0;
  SendScanCount := 0;
  SendSystemCount := 0;
  RecvScanCount := 0;
  RecvSystemCount := 0;
  ActualAction := '';
  completeProcess := 0;
  partProcess := 0;
  fillchar(Login, SizeOf(Login), 0);
  inherited;
end;

destructor TcSConnectionData.Destroy;
begin
  inherited;
end;

procedure TcSServer.DoWork_idle(out Ready: Boolean);
var i: Integer;
begin
  Ready := True;
  for i := 0 to self.FSocketMList.Count-1 do
  begin
    try
      if DoSocket(self.FSocketMList.Sockets[i]) then
        Ready := False;
    except
      on E: Exception do
      begin
        self.log.AddEntry(self.FSocketMList.Sockets[i],
          'Exception(' + E.ClassName + '): ' + E.Message,llNormal);
      end;
    end;
  end;
end;

procedure TUserList.LockUsers;
begin
  Flu_Users := FUsers.LockList;
end;

procedure TUserList.UnlockUsers;
begin
  Flu_Users := nil;
  FUsers.UnlockList;
end;

function TUserList.GetUsers(nr: Integer): TGroup;
begin
  if Flu_Users = nil then
    raise Exception.Create('TUserList.GetUsers: lu_LockUser have to be first!');

  if (nr >= 0)and(nr < Flu_Users.Count) then
    Result := TGroup(Flu_Users[nr]^)
  else raise Exception.Create('TUserList.GetUsers: wrong listindex!');
end;

procedure TUserList.SetUsers(nr: Integer; user: TGroup);
begin
  if Flu_Users = nil then
    raise Exception.Create('TUserList.GetUsers: lu_LockUser have to be first!');

  if (nr >= 0)and(nr < Flu_Users.Count) then
    TGroup(Flu_Users[nr]^) := user
  else raise Exception.Create('TUserList.GetUsers: wrong listindex!');
end;

function TUserList.AddUser(user: TGroup): Integer;
var p: pointer;
begin
  if Flu_Users = nil then
    raise Exception.Create('TUserList.AddUser: LockUser have to be first!');

  GetMem(P,SizeOf(TGroup));
  TGroup(p^) := user;
  Result := Flu_Users.Add(p);
end;

function TcSSocketMultiplex.LockData(Description: String): TcSConnectionData;
begin
  Result := TcSConnectionData(inherited LockData(Description));
end;

function TcSSocketMultiplexList.GetSocket(
  Index: Integer): TcSSocketMultiplex;
begin
  Result := TcSSocketMultiplex(inherited Sockets[Index]);
end;

procedure TcSServer.FGetConInfo_ForEachSplitSocket(Sender: TObject;
  Socket: TSplitSocket; Data: pointer);
begin
  if Socket.WorkProcessIndex = pi_uni then
  begin
{$ifdef CS_USE_NET_COMPS}
    with TNetUniTreeSocketData(Socket.LockData('TcSServer.FGetConInfo_ForEachSplitSocket')) do
    try
      TConInf(Data^).UniSyncPos := SyncPos;
    finally
      Socket.UnlockData;
    end;
{$endif}
  end;
end;

function TUserList.GetUserCount: Integer;
begin
  if Flu_Users = nil then
    raise Exception.Create('TUserList.GetUserCount: lu_LockUser have to be first!');

  Result := Flu_Users.Count;
end;

procedure TUserList.SetUserCount(c: Integer);
var gr: TGroup;
begin
  if Flu_Users = nil then
    raise Exception.Create('TUserList.SetUserCount: lu_LockUser have to be first!');

  FillChar(gr, sizeof(gr), 0);

  while (Flu_Users.Count < c) do
    AddUser(gr);

  while (Flu_Users.Count > c) do
  begin
    Flu_Users.Delete(Flu_Users.Count-1);
  end;
end;


procedure TUserList.Save(ini: TInifile; Section: String);
var i: integer;
begin
  LockUsers;
  try
    ini.WriteInteger(Section,'GroupCount',UserCount);
    for i := 0 to UserCount-1 do
    begin
      ini.WriteString(Section,'gr'+inttostr(i)+'Rights',RightsToStr(Users[i]));
      ini.WriteString(Section,'gr'+inttostr(i)+'Name',Users[i].Name);
      ini.WriteString(Section,'gr'+inttostr(i)+'Pass',Users[i].Pass);
    end;
  finally
    UnlockUsers;
  end;
end;

procedure TUserList.Load(ini: TInifile; Section: String);
var i, c: integer;
    rg: TGroup;
begin
  LockUsers;
  try
    c := ini.ReadInteger(Section,'GroupCount',0);
    for i := 0 to c-1 do
    begin
      StrToRights(rg,ini.ReadString(Section,'gr'+inttostr(i)+'Rights','')+'//');
      rg.Name := ini.ReadString(Section,'gr'+inttostr(i)+'Name','');
      rg.Pass := ini.ReadString(Section,'gr'+inttostr(i)+'Pass','');
      if (rg.Name <> '')or(i = 0) then
        AddUser(rg);
    end;
  finally
    UnlockUsers;
  end;
end;

function TUserList.GetRights(Login: TGroup): TGroup;
var i: integer;
begin
  FillChar(Result, SizeOF(Result), 0);
  LockUsers;
  try
    if (UserCount <= 1) then
      raise Exception.Create('TcSServer.FLoginMergeOnNewSocket: Keine Logindaten vorhanden!')
    else
    begin
      for i := 1 to UserCount-1 do
      begin
        if (Users[i].Name = Login.Name)and
           (Users[i].Pass = Login.Pass) then
        begin
          Result := Users[i];
          FusionRights(Result, Login);
          Result.Pass := '';
          break;
        end;
      end;
    end;
  finally
    UnlockUsers;
  end;
end;

procedure TUserList.DeleteUser(nr: Integer);
begin
  if Flu_Users = nil then
    raise Exception.Create('TUserList.DeleteUser: LockUser have to be first!');

  if (nr < 0)or(nr >= UserCount) then
    raise Exception.Create('TUserList.DeleteUser: invalid index!');

  FreeMem(Flu_Users[nr]);
  Flu_Users.Delete(nr);
end;

constructor TUserList.Create;
begin
  inherited;
  FUsers := TThreadList.Create;
end;

destructor TUserList.Destroy;
begin
  FUsers.Free;
  inherited;
end;

procedure TUserList.Clear;
begin

end;

function TcSServer.getlogindata(Master: Boolean): TLoginData;
begin
  Result.ProgName := crOVersionName;
  Result.protVersion := crOVersionID;
  Result.Master := Master;
  Result.SiteName := ODataBase.game_domain;
  Result.UniName := ODataBase.UniDomain;
  Result.GalaxyCount := max_Galaxy;
  Result.SolsysCount := max_Systems;
  Result.PlanetCount := max_Planeten;
  Result.LangIndex := domainTolangindex(ODataBase.game_domain);
  Result.PlayerName := ODataBase.Username;
end;

function TcSServer.FindUsername(name: string): integer;
var i: integer;
begin
  Result := -1;
  for i := 0 to ConnectionCount-1 do
  begin
    if Connections[i].RemoteUser = name then
      Result := i;
  end;
end;

end.
