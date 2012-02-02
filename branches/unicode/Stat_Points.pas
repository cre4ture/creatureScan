unit Stat_Points;

interface

uses classes, OGame_Types, Windows, SysUtils, SDBFile,
  {$ifdef CS_USE_NET_COMPS}MergeSocket, SplitSocket,
  cS_networking,{$endif} LibXmlParser, LibXmlComps, xml_parser_unicode;

const
  StatFileV = 'creatureScan_StatisticBD_2.2';

  // log: 2.2: Neues Format mit Int64

  new_file_ident = 'new_file';

type
  EcSStatsWrongFormat = class(Exception);

  TStatFileInf_10 = Record
    V: String[13];
    Uni: Word;
  end;
  TStatFileInf_20 = packed record
    filetype: string[30];
    domain: string[255];
    dummy_buffer: string[255];
  end;

  TStatFilePlayer_1 = packed record
    Name: string[25];
    Punkte: Cardinal;
    case TStatType of
    st_Player: (Ally: String[10]);
    st_Ally: (Mitglieder: Word);
  end;
  TStatFileStat_1 = packed record
    first: Word;
    Time_u: Int64;
    Stats: packed array[0..99] of TStatFilePlayer_1;
  end;

  TStatFilePlayer_11 = packed record
    Name: string[25];
    NameId: Int64;
    Punkte: Cardinal;
    case TStatType of
    st_Player: (Ally: String[10]);
    st_Ally: (Mitglieder: Word);
  end;
  TStatFileStat_11 = packed record
    first: Word;
    Time_u: Int64;
    Stats: packed array[0..99] of TStatFilePlayer_11;
  end;

  TStatFilePlayer_22 = packed record
    NameId: Int64;
    Punkte: Int64;
    Mitglieder: Int64;
    Name: string[127];
    Ally: string[127];
  end;
  TStatFileStat_22 = packed record
    first: Integer;
    count: Integer;
    Time_u: Int64;
    Stats: packed array[0..99] of TStatFilePlayer_22;
  end;

  TStatisticDBFile = class(TSimpleDBCachedFile)
  protected
    fType: TStatTypeEx;
    FHeader: TStatFileInf_20;
    function GetUni: string;
    procedure SetUni(u: string);
    function GetStat(nr: Cardinal): TStat;
    procedure SetStat(nr: Cardinal; st: TStat);
    function NewItemPtr: pointer; override;
    procedure ItemToPtr(var Buf; const p: pointer); override;
    procedure PtrToItem(const p: pointer; var Buf); override;
    procedure DisposeItemPtr(const p: pointer); override;
  public
    constructor Create(aFilename: string; aType: TStatTypeEx);
    property UniDomain: string read GetUni write SetUni;
    property Stats[nr: Cardinal]: TStat read GetStat write SetStat; default;
  end;

{$ifdef CS_USE_NET_COMPS}
  TStatPointsNet_SplitSocketData = class
  public
    Synced: Boolean;
    constructor Create;
  end;
{$endif}
  TStatPoints = class(TObject)
  protected
    FStats: TStatisticDBFile;
    function GetPlayerAtPlace(Platz: Word): TStatPlayer;
    function GetDateAtPos(Platz: Word): TDateTime;
    function GetStat(nr: Integer): TStat;
    function GetCount: Integer;
    procedure SetCount(c: integer);
  public
    constructor Create(AFile: String; UniDomain: String; aType: TStatTypeEx);
    function AddStat(Stats: TStat): boolean; virtual;
    property Statistik[Platz: Word]: TStatPlayer read GetPlayerAtPlace;
    property Datum[Platz: Word]: TDateTime read GetDateAtPos;
    function PartTime_u(partnr: integer): Int64;
    property Stats[nr: Integer]: TStat read GetStat;
    destructor Destroy; override;
    function StatPoints(AName: string; APlayerID: TNameID): Cardinal;
    function StatPlace(AName: string; APlayerID: TNameID): Cardinal;
    function StatAll(AName: string; APlayerID: TNameID): TStatPlayer;
    property Count: Integer read GetCount write SetCount;
    procedure DoWork_Idle(out Ready: Boolean); virtual;
  end;
{$ifdef CS_USE_NET_COMPS}
  TStatPointsNet = class(TStatPoints)
  private
    cS_Serv: TcSServer;
    StatMerge: TMergeSocket;
    StatTyp: TStatTypeEx;

    procedure StatMergeOnNewSocket(Sender: TObject; Socket: TSplitSocket);
    procedure StatMergeOnRemoveSocket(Sender: TObject;
      Socket: TSplitSocket);
    procedure StatMergeOnNewPacket_ReadThread(Sender: TObject;
      Socket: TSplitSocket);
    procedure StatMergeNewPacket_DoWork(Sender: TObject;
      Socket: TSplitSocket; Data: pointer; Size: Word);
    function DoSync_Master_ready(Socket: TSplitSocket): Boolean;
    function AddNewStatFromSocket(Stat: TStat; Socket: TSplitSocket): Boolean;
    procedure DoSync_Slave(Parser: TUnicodeXmlParser; Socket: TSplitSocket);
    procedure AnswerRequest(parser: TUnicodeXmlParser; Socket: TSplitSocket);
    procedure FSendStatToSocket(Stat: TStat; Socket: TSplitSocket);
    procedure FSendStat(Stat: TStat; Skip: TSplitSocket);
  public
    constructor Create(AFile: String; UniDomain: String;
      cSServer: TcSServer; aStatTyp: TStatTypeEx);
    destructor Destroy; override;
    procedure DoWork_Idle(out Ready: Boolean); override;
    function AddStat(Stats: TStat): boolean; override;
  end;
{$endif}
  TStatisticDB = class
  protected
    FStats: array[TStatNameType,TStatPointType] of TStatPoints;
    
    function StatPoints(nt: TStatNameType; pt: TStatPointType;
      AName: string; APlayerID: TNameID): Cardinal;
    function StatRank(nt: TStatNameType; pt: TStatPointType;
      AName: string; APlayerID: TNameID): Cardinal;
    function StatInfo(nt: TStatNameType; pt: TStatPointType;
      Rank: Cardinal): TStatPlayer;
    function StatType(nt: TStatNameType; pt: TStatPointType): TStatPoints;
  public
    property StatisticType[nt: TStatNameType; pt: TStatPointType
      ]: TStatPoints read StatType;
    property Statistic[nt: TStatNameType; pt: TStatPointType;
      rank: Cardinal]: TStatPlayer read StatInfo; default;
    property StatisticPoints[nt: TStatNameType; pt: TStatPointType;
      AName: string; APlayerID: TNameID]: Cardinal read StatPoints;
    property StatisticRank[nt: TStatNameType; pt: TStatPointType;
      AName: string; APlayerID: TNameID]: Cardinal read StatRank;
    constructor Create(filenameMask: string; UniDomain: String);
    destructor Destroy; override;
    function AddStats(nt: TStatNameType; pt: TStatPointType;
      Stats: TStat): boolean;
    procedure DoWork_idle(out Ready: Boolean);
  end;

implementation

uses prog_unit, DateUtils, cS_XML, cS_utf8_conv;

function TStatPoints.GetDateAtPos(Platz: Word): TDateTime;
var i: integer;
begin
  i := Platz div 100;
  if (i >= 0)and(i < FStats.Count) then
    Result := UnixToDateTime(FStats[i].Time_u)
  else Result := -1;
end;

constructor TStatPoints.Create(AFile: String; UniDomain: String; aType: TStatTypeEx);
begin
  inherited Create;
  try
    FStats := TStatisticDBFile.Create(AFile, aType);
  except
    on EcSStatsWrongFormat do // bei falschem oder altem Format
    begin  // (convertierung lohnt sich nicht bei stats)
      DeleteFile(AFile);  // -> löschen und neu erstellen!
      FStats := TStatisticDBFile.Create(AFile, aType);
    end;
  end;
  
  if (FStats.UniDomain <> UniDomain) then
  begin  // bei falschem uni -> stats löschen
    FStats.UniDomain := UniDomain;
    FStats.Count := 0; //Clear!
  end;
end;

function TStatPoints.GetPlayerAtPlace(Platz: Word): TStatPlayer;
var i, j: integer;
begin
  if (Platz > 0)and(Platz <= Count*100) then
  begin
    dec(Platz);
    i := Platz div 100;
    j := Platz mod 100;
    Result := FStats[i].Stats[j];
  end
  else
  begin
    Result.Name := '';
    Result.Punkte := 0;
  end;
end;

function TStatPoints.AddStat(Stats: TStat): boolean;
var i: integer;
begin
  Result := ((Stats.first mod 100) = 1);
  if Result then
  begin
    i := Stats.first div 100;
    Result := (i >= FStats.Count);
    
    if Result then FStats.Count := i+1
    else Result := (Stats.Time_u > FStats[i].Time_u);

    if Result then
    begin
      FStats[i] := Stats;
    end;
  end;
end;

destructor TStatPoints.Destroy;
begin
  FStats.Free;
  inherited;
end;

function TStatPoints.StatPoints(AName: string; APlayerID: TNameID): Cardinal;
begin
  Result := StatAll(AName,APlayerID).Punkte;
end;

function TStatPoints.StatPlace(AName: string; APlayerID: TNameID): Cardinal;
var i, j: Integer;
    Found: Boolean;
    block: TStat;
    actPlayerID: TNameID;
begin
  if (AName = '') and (APlayerID <= 0) then
  begin
    Result := 0;
    Exit;
  end;

  i := 0;
  j := 0;
  Found := False;
  while (not Found)and(i <= Count-1) do
  begin
    block := FStats[i];
    j := 0;
    while (not Found)and(j <= 99) do
    begin
      actPlayerID := block.Stats[j].NameId;
      if (APlayerID <= 0)or(actPlayerID <= 0) then
        Found := (block.Stats[j].Name = AName)
      else
        Found := (block.Stats[j].NameId = APlayerID);
        
      inc(j);
    end;
    inc(i);
  end;
  if Found then
    Result := (i-1)*100+(j-1)+1 //-1 jeweils, weil nachdem der platz gefunden wurde, ja nochmal beide erhöht werden!
  else Result := 0;
end;

function TStatPoints.StatAll(AName: string; APlayerID: TNameID): TStatPlayer;
begin
  Result := Statistik[StatPlace(AName, APlayerID)];
end;

function TStatisticDB.StatPoints(nt: TStatNameType; pt: TStatPointType;
  AName: string; APlayerID: TNameID): Cardinal;
begin
  Result := FStats[nt,pt].StatPoints(AName, APlayerID);
end;

function TStatisticDB.StatRank(nt: TStatNameType; pt: TStatPointType;
  AName: string; APlayerID: TNameID): Cardinal;
begin
  Result := FStats[nt,pt].StatPlace(AName, APlayerID);
end;

function TStatisticDB.StatInfo(nt: TStatNameType; pt: TStatPointType;
  Rank: Cardinal): TStatPlayer;
begin
  Result := FStats[nt,pt].Statistik[Rank];
end;

constructor TStatisticDB.Create(filenameMask: string; UniDomain: String);
var nt: TStatNameType;
    pt: TStatPointType;
    s: string;
    tex: TStatTypeEx;
begin
  inherited Create;

  if not(pos('%%',filenameMask) > 0) then
    raise Exception.Create('constructor TStatDB.Create: Error FilenameMask: "'+
    filenameMask + '"');

  filenameMask := StringReplace(filenameMask,'%%','%s',[]);

  for nt := low(nt) to high(nt) do
    for pt := low(pt) to high(pt) do
    begin
      case nt of
        sntPlayer: s := 'player';
        sntAlliance: s := 'alliance';
      end;
      case pt of
        sptPoints: s := s + 'points';
        sptFleet: s := s + 'fleet';
        sptResearch: s := s + 'research';
      end;
      tex.NameType := nt;
      tex.PointType := pt;
{$ifdef CS_USE_NET_COMPS}
      FStats[nt,pt] := TStatPointsNet.Create(Format(filenameMask,[s]),
                          UniDomain, cSServer, tex);
{$else}
      FStats[nt,pt] := TStatPoints.Create(Format(filenameMask,[s]),
                          UniDomain, tex);
{$endif}
    end;
end;

destructor TStatisticDB.Destroy;
var nt: TStatNameType;
    pt: TStatPointType;
begin
  for nt := low(nt) to high(nt) do
    for pt := low(pt) to high(pt) do
    begin
      FStats[nt,pt].Free;
    end;

  inherited;
end;

function TStatisticDB.AddStats(nt: TStatNameType; pt: TStatPointType;
      Stats: TStat): boolean;
begin
  Result := FStats[nt,pt].AddStat(Stats);
end;

function TStatisticDB.StatType(nt: TStatNameType; pt: TStatPointType): TStatPoints;
begin
  Result := FStats[nt,pt];
end;

function TStatPoints.GetStat(nr: Integer): TStat;
begin
  if (nr >= 0)and(nr < FStats.Count) then
    Result := FStats[nr]
  else raise Exception.Create(Format('TStatPoints.GetStat: nr(%d) out of range', [nr]));
end;

function TStatPoints.GetCount: Integer;
begin
  Result := FStats.Count;
end;

procedure TStatPoints.SetCount(c: integer);
begin
  FStats.Count := c;
end;

constructor TStatisticDBFile.Create(aFilename: string; aType: TStatTypeEx);
begin
  FHeaderSize := SizeOf(FHeader);
  FItemSize := SizeOf(TStatFileStat_22);
  fType := aType;

  inherited Create(aFilename, false);
  
  if GetHeader(FHeader) then
  begin
    if FHeader.filetype <> StatFileV then
      raise EcSStatsWrongFormat.Create(
        'TStatisticDBFile.Create: Unknown, or old Fileformat! ('
           + aFilename + ')');
  end
  else
  begin
    FillChar(FHeader, sizeof(FHeader), 0);
    FHeader.filetype := StatFileV;
    FHeader.domain := new_file_ident;
    FHeader.dummy_buffer := '';
    SetHeader(FHeader);
  end;
  LoadList;
end;

procedure TStatisticDBFile.DisposeItemPtr(const p: pointer);
begin
  Dispose(PStat(p));
end;

function TStatisticDBFile.GetStat(nr: Cardinal): TStat;
begin
  Result := TStat(GetCachedItem(nr)^);
end;

function TStatisticDBFile.GetUni: string;
begin
  Result := trnslShortStr(FHeader.domain);
end;

procedure TStatisticDBFile.ItemToPtr(var Buf; const p: pointer);
var i: integer;
begin
  with TStatFileStat_22(buf) do
  begin
    TStat(p^).first := first;
    TStat(p^).count := count;
    TStat(p^).Time_u := Time_u;
    for i := 0 to length(Stats)-1 do
    begin
      TStat(p^).Stats[i].Name := trnslShortStr(Stats[i].Name);
      TStat(p^).Stats[i].NameId := Stats[i].NameId;
      TStat(p^).Stats[i].Punkte := Stats[i].Punkte;
      if fType.NameType = sntPlayer then
      begin
        TStat(p^).Stats[i].Ally := trnslShortStr(Stats[i].Ally);
        if sptFleet = fType.PointType then
          TStat(p^).Stats[i].Elemente := Stats[i].Mitglieder
        else
          TStat(p^).Stats[i].Elemente := 0;
      end
      else
      begin
        TStat(p^).Stats[i].Ally := '';
        TStat(p^).Stats[i].Elemente := Stats[i].Mitglieder;
      end;
    end;
  end;
end;

function TStatisticDBFile.NewItemPtr: pointer;
begin
  New(PStat(Result));
  PStat(Result).Time_u := 0;
end;

procedure TStatisticDBFile.PtrToItem(const p: pointer; var Buf);
var i: integer;
begin
  // clear all to 0
  FillChar(buf, FItemSize,0);
  // fill with data
  with TStatFileStat_22(Buf) do
  begin
    first := TStat(p^).first;
    count := TStat(p^).count;
    Time_u := TStat(p^).Time_u;
    for i := 0 to length(Stats)-1 do
    begin
      Stats[i].Name := trnsltoUTF8(TStat(p^).Stats[i].Name);
      Stats[i].NameId := TStat(p^).Stats[i].NameId;
      Stats[i].Punkte := TStat(p^).Stats[i].Punkte;
      if fType.NameType = sntPlayer then
        Stats[i].Ally := trnsltoUTF8(TStat(p^).Stats[i].Ally)
      else
        Stats[i].Mitglieder := TStat(p^).Stats[i].Elemente;
    end;
  end;
end;

procedure TStatisticDBFile.SetStat(nr: Cardinal; st: TStat);
begin
  SetItem(nr,@st);
end;

procedure TStatisticDBFile.SetUni(u: string);
begin
  FHeader.domain := trnsltoUTF8(u);
  SetHeader(FHeader);
end;

procedure TStatPoints.DoWork_Idle(out Ready: Boolean);
begin
  Ready := True;
end;

{$ifdef CS_USE_NET_COMPS}
constructor TStatPointsNet_SplitSocketData.Create;
begin
  inherited;

  Synced := False;
end;

function TStatPointsNet.AddNewStatFromSocket(Stat: TStat;
  Socket: TSplitSocket): Boolean;
begin
  Result := inherited AddStat(Stat);

  if Result then
  begin
    FSendStat(Stat,Socket);

    with Socket.HostSocket as TSocketMultiplex,
       TcSConnectionData(LockData('TStatPointsNet.AddNewStatFromSocket')) do
    try
      inc(RecvStatCount);
    finally
      UnlockData;
    end;
  end;
end;

function TStatPointsNet.AddStat(Stats: TStat): boolean;
begin
  Result := inherited AddStat(Stats);

  if Result then
  begin
    StatMerge.LockList;
    try
      FSendStat(Stats, nil);
    finally
      StatMerge.UnlockList;
    end;
  end;
end;

procedure TStatPointsNet.AnswerRequest(parser: TUnicodeXmlParser;
  Socket: TSplitSocket);
var nr: Integer;
begin
  if parser.CurAttr.Value('type') = xstat_group then
  begin
    nr := parser.attrAsInt('nr');
    FSendStatToSocket(Stats[nr],Socket);
  end else raise Exception.Create('TStatPointsNet.AnswerRequest: ' +
                   'Falscher "type" im request!');
end;

constructor TStatPointsNet.Create(AFile: String; UniDomain: String;
  cSServer: TcSServer; aStatTyp: TStatTypeEx);
begin
  inherited Create(AFile, UniDomain, aStatTyp);
  StatTyp := aStatTyp;
  cS_Serv := cSServer;
  StatMerge := TMergeSocket.Create;
  StatMerge.OnNewPacket_ReadThread := StatMergeOnNewPacket_ReadThread;
  StatMerge.OnNewSocket := StatMergeOnNewSocket;
  StatMerge.OnRemoveSocket := StatMergeOnRemoveSocket;
  cS_Serv.FStatMerges[StatTyp.NameType][StatTyp.PointType] := StatMerge;
end;

destructor TStatPointsNet.Destroy;
begin
  cS_Serv.FStatMerges[StatTyp.NameType][StatTyp.PointType] := nil;
  StatMerge.Free;
  inherited;
end;

function TStatPointsNet.DoSync_Master_ready(Socket: TSplitSocket): Boolean;
var i: Integer;
    s: AnsiString;
begin
  Result := True;
  with TStatPointsNet_SplitSocketData(Socket.LockData('TStatPointsNet.DoSync_Master_ready')) do
  try
    if not Synced then
    begin
      s := '<syncdata>';
      for i := 0 to Count-1 do
      begin
        s := s + trnsltoUTF8(Format('<stattime nr="%d" %s="%d"/>',
                        [i, xstat_group_time, Stats[i].Time_u]));
      end;
      s := s + '</syncdata>';

      Socket.SendPacket(PAnsiChar(s)^,length(s));

      Synced := True;
    end;
  finally
    Socket.UnlockData;
  end;
end;

procedure TStatPointsNet.DoSync_Slave(Parser: TUnicodeXmlParser;
  Socket: TSplitSocket);
var roottag: AnsiString;
    t: int64;
    nr, pos: Integer;
    s: AnsiString;
begin
  roottag := Parser.CurName;
  pos := 0;
  while parser.Scan do
  begin
    case parser.CurPartType of
      ptStartTag, ptEmptyTag:
        if (parser.CurName = 'stattime') then
        begin
          nr := Parser.attrAsInt('nr');
          pos := nr+1;
          t := StrToInt64(Parser.attrAsString(xstat_group_time));
          if (nr >= Count)or(t > Stats[nr].Time_u) then
          begin
            s := trnsltoUTF8(Format('<request type="%s" nr="%d"/>',
                        [xstat_group, nr]));
            Socket.SendPacket(PAnsiChar(s)^,length(s));
          end
          else
          if (t < Stats[nr].Time_u) then
          begin
            FSendStatToSocket(Stats[nr],Socket);
          end;
        end;
      ptEndTag:
        if (Parser.CurName = roottag) then
        begin
          for nr := pos to Count-1 do
            FSendStatToSocket(Stats[nr],Socket);

          Break;
        end;
      end;
    end;
end;

procedure TStatPointsNet.DoWork_idle(out Ready: Boolean);
var Data: pointer;
    Size: Word;
    Socket: TSplitSocket;
    R: Boolean;
    i: Integer;
begin
  Ready := true;
  inherited DoWork_idle(Ready);

  StatMerge.LockList;
  try
    for i := 0 to StatMerge.Count-1 do
    begin
      Socket := StatMerge.Sockets[i];
      try
        if (Socket.Master)and(not DoSync_Master_ready(Socket)) then
          Ready := False;

        R := Socket.GetPacket(Data,Size);
        if R then
        begin
          StatMergeNewPacket_DoWork(Self,Socket,Data,Size);
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
    StatMerge.UnlockList;
  end;
end;

procedure TStatPointsNet.FSendStat(Stat: TStat; Skip: TSplitSocket);
var i: Integer;
begin
  for i := 0 to StatMerge.Count-1 do
    if (StatMerge.Sockets[i] <> Skip) then
    begin
      FSendStatToSocket(Stat,StatMerge.Sockets[i]);
    end;
end;

procedure TStatPointsNet.FSendStatToSocket(Stat: TStat;
  Socket: TSplitSocket);
var s: AnsiString;
begin
  s := trnsltoUTF8(StatToXML_(Stat,StatTyp));
  Socket.SendPacket(PAnsiChar(s)^,length(s));

  with Socket.HostSocket as TSocketMultiplex,
       TcSConnectionData(LockData('TStatPointsNet.FSendStatToSocket')) do
  try
    inc(SendStatCount);
  finally
    UnlockData;
  end;
end;

procedure TStatPointsNet.StatMergeNewPacket_DoWork(Sender: TObject;
  Socket: TSplitSocket; Data: pointer; Size: Word);
var s: AnsiString;
    parser: TUnicodeXmlParser;
    stat: TStat;
    snt: TStatNameType;
    spt: TStatPointType;
begin
  parser := TUnicodeXmlParser.Create;
  try
    SetLength(s, Size);
    Move(Data^, PAnsiChar(s)^, Size);

    parser.LoadFromBuffer(PAnsiChar(s));
    parser.StartScan;

    while parser.Scan do
    begin
      case parser.CurPartType of
        ptStartTag, ptEmptyTag:
          begin
            if (parser.CurName = xstat_group)and
                parse_stat(parser,stat,snt,spt)and
               (StatTyp.NameType = snt)and
               (StatTyp.PointType = spt) then
              AddNewStatFromSocket(Stat,Socket)
            else
            if (parser.CurName = 'syncdata') then
              DoSync_Slave(parser,Socket)
            else
            if (parser.CurName = 'request') then
              AnswerRequest(parser,Socket)
            else;
          end;
      end;
    end;
  finally
    parser.Free;
  end;
end;

procedure TStatPointsNet.StatMergeOnNewPacket_ReadThread(Sender: TObject;
  Socket: TSplitSocket);
begin
  WakeMainThread(Self);
end;

procedure TStatPointsNet.StatMergeOnNewSocket(Sender: TObject;
  Socket: TSplitSocket);
begin
  Socket.LockData('TStatPointsNet.StatMergeOnNewSocket');
  Socket.SetData_locked_(TStatPointsNet_SplitSocketData.Create);
  Socket.UnlockData;
end;

procedure TStatPointsNet.StatMergeOnRemoveSocket(Sender: TObject;
  Socket: TSplitSocket);
begin
  TStatPointsNet_SplitSocketData(Socket.LockData('TStatPointsNet.StatMergeOnRemoveSocket')).Free;
  Socket.SetData_locked_(nil);
  Socket.UnlockData;
end;
{$endif}

procedure TStatisticDB.DoWork_idle(out Ready: Boolean);
var re: Boolean;
    snt: TStatNameType;
    spt: TStatPointType;
begin
  Ready := true;
  for snt := low(snt) to high(snt) do
    for spt := low(spt) to high(spt) do
    begin
      StatisticType[snt,spt].DoWork_Idle(re);
      if not re then
        Ready := false;
    end;
end;

function TStatPoints.PartTime_u(partnr: integer): Int64;
begin
  Result := 0;
  if partnr < Count then
    Result := Stats[partnr].Time_u;
end;

end.
