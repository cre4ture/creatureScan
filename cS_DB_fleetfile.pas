unit cS_DB_fleetfile;

interface

uses
  SDBFile, SysUtils, OGame_Types, DateUtils, cS_DB, Dialogs;

type
  TcSFleetFileFormat =
  (cff_none,           cff_20 );
const
  cSFleetFileFormatstr: array[TcSFleetFileFormat] of shortstring =
  ( 'error', 'cscan_fleet_2.0');

type
  EcSDBUnknownFileFormat = class(Exception);

  TcSFleetHeader_10 = record
    V: string[15];
    Uni: Cardinal;
  end;

  TcSFleetItem_20_Head_PlanetPos = packed record
    Position: packed array[0..2] of Word;
    P_Mond: Boolean;
  end;
  TcSFleetItemHead_20 = packed record
    unique_id: integer;  //ID from ogame database
    eventtype: Byte;
    eventflags: Byte;
    origin, target: TcSFleetItem_20_Head_PlanetPos;
    time_u: Int64;
    player: string[25];
    joined_id: integer;  //set an id > 0 if Fleet belongs to a "Verbands-Angriff"
  end;
  TcSFleetItem_20 = packed record
    head: TcSFleetItemHead_20;
    ress: packed array[0..2] of integer;
    ships: packed array[1..14] of integer;
  end;


  TcSFleetItemToFleet = function(const ItemBuf: pointer): TFleetEvent;
  TFleettocSFleetItem = procedure(const Scan: TFleetEvent; const ItemBuf: pointer);
  TcSFleetDBFile = class(TSimpleDBCachedFile)
  private
    FHeader: TcSFleetHeader_10;
    FFormat: TcSFleetFileFormat;
    FFleetToItem: TFleettocSFleetItem;
    FItemToFleet: TcSFleetItemToFleet;
    procedure InitFormat;
    function GetUni: Byte;
    procedure SetUni(Uni: byte);
  protected
    function NewItemPtr: pointer; override;
    procedure DisposeItemPtr(const p: pointer); override;
    procedure ItemToPtr(var Buf; const p: pointer); override;
    procedure PtrToItem(const p: pointer; var Buf); override;
  public
    function GetFleet(nr: Cardinal): TFleetEvent;
    procedure SetFleet(nr: Cardinal; Fleet: TFleetEvent);
    property Fleets[nr: Cardinal]: TFleetEvent read GetFleet write SetFleet;
    property Universe: Byte read GetUni write SetUni;
    constructor Create(aFilename: string);
  end;

  TcSFleetDB_for_File = class(TcSFleetDB)
  private
    DBFile: TcSFleetDBFile;
  protected
    function GetFleet(nr: cardinal): TFleetEvent; override;
    procedure SetFleet(nr: cardinal; Fleet: TFleetEvent); override;
    function GetCount: Integer; override;
  public
    constructor Create(aFilename: string; Universe: Integer);
    destructor Destroy; override;

    //Only for compatibility to the old Code:
    procedure DeleteLastFleet; override;
    function IsOldFormat: Boolean;
    function AddFleet(Fleet: TFleetEvent): Integer; override;
  end;

implementation

constructor TcSFleetDBFile.Create(aFilename: string);
var frmt: TcSFleetFileFormat;
begin
  FHeaderSize := SizeOf(TcSFleetHeader_10);
  inherited Create(aFilename,False);

  if (not GetHeader(FHeader)) then
  begin
    FFormat := high(cSFleetFileFormatstr);
    FHeader.V := cSFleetFileFormatstr[FFormat];
    FHeader.Uni := 0;
    SetHeader(FHeader);
  end
  else
  begin
    FFormat := cff_none;
    for frmt := high(frmt) downto low(frmt) do
      if cSFleetFileFormatstr[frmt] = FHeader.V then
      begin
        FFormat := frmt;
        break;
      end;

    if (FFormat = cff_none) then
      raise EcSDBUnknownFileFormat.Create('TcSFleetDB.Create: Unknown file format (File: "' + aFilename  + '", Format: "' + FHeader.V + '")');
  end;
  InitFormat;

  LoadList;
end;

function cSFleetItem_to_Fleet_20(const ItemBuf: pointer): TFleetEvent;
var Item: TcSFleetItem_20;
    i: integer;
begin
  Item := TcSFleetItem_20(ItemBuf^);
  FillChar(Result, SizeOf(Result), 0);

  Result.head.unique_id := Item.head.unique_id;
  Result.head.eventtype := TFleetEventType(Item.Head.eventtype);
  Result.head.eventflags := TFleetEventFlags(Item.Head.eventflags);

  Result.head.origin.P[0] := Item.Head.origin.Position[0];
  Result.head.origin.P[1] := Item.Head.origin.Position[1];
  Result.head.origin.P[2] := Item.Head.origin.Position[2];
  Result.head.origin.Mond := Item.Head.origin.P_Mond;

  Result.head.target.P[0] := Item.Head.target.Position[0];
  Result.head.target.P[1] := Item.Head.target.Position[1];
  Result.head.target.P[2] := Item.Head.target.Position[2];
  Result.head.target.Mond := Item.Head.target.P_Mond;

  Result.head.arrival_time_u := Item.Head.time_u;
  Result.head.player := Item.Head.player;
  Result.head.joined_id := Item.Head.joined_id;

  SetLength(Result.ress,length(Item.ress));
  for i := 0 to length(Item.ress)-1 do
  begin
    Result.ress[i] := Item.ress[i];
  end;

  SetLength(Result.ships,length(Item.ships));
  for i := 1 to length(Item.ships) do
  begin
    Result.ships[i-1] := Item.ships[i];
  end;
end;

procedure Fleet_to_cSFleetItem_20(const Fleet: TFleetEvent;
  const ItemBuf: pointer);
var Item: TcSFleetItem_20;
    i: integer;
begin
  FillChar(Item, SizeOf(Item), 0);

  Item.Head.unique_id := Fleet.head.unique_id;
  Item.Head.eventtype := Byte(Fleet.head.eventtype);
  Item.Head.eventflags := Byte(Fleet.head.eventflags);

  Item.Head.origin.Position[0] := Fleet.head.origin.P[0];
  Item.Head.origin.Position[1] := Fleet.head.origin.P[1];
  Item.Head.origin.Position[2] := Fleet.head.origin.P[2];
  Item.Head.origin.P_Mond := Fleet.head.origin.Mond;

  Item.Head.target.Position[0] := Fleet.head.target.P[0];
  Item.Head.target.Position[1] := Fleet.head.target.P[1];
  Item.Head.target.Position[2] := Fleet.head.target.P[2];
  Item.Head.target.P_Mond := Fleet.head.target.Mond;

  Item.Head.time_u := Fleet.head.arrival_time_u;
  Item.Head.player := Fleet.head.player;
  Item.Head.joined_id := Fleet.head.joined_id;

  for i := 0 to length(Item.ress)-1 do
  begin
    Item.ress[i] := Fleet.ress[i];
  end;
  for i := 1 to length(Item.ships) do
  begin
    Item.ships[i] := Fleet.ships[i-1];
  end;

  TcSFleetItem_20(ItemBuf^) := Item;
end;

procedure TcSFleetDBFile.DisposeItemPtr(const p: pointer);
begin
  Dispose(PFleetEvent_(p));
end;

function TcSFleetDBFile.GetFleet(nr: Cardinal): TFleetEvent;
begin
  Result := TFleetEvent(GetCachedItem(nr)^);
end;

function TcSFleetDBFile.GetUni: Byte;
begin
  Result := FHeader.Uni;
end;

procedure TcSFleetDBFile.InitFormat;
begin
  case FFormat of
    cff_20:
    begin
      FItemSize := SizeOf(TcSFleetItem_20);
      FFleetToItem := Fleet_to_cSFleetItem_20;
      FItemToFleet := cSFleetItem_to_Fleet_20;
    end;
    {csr_36:
    begin
      FItemSize := SizeOf(TcSFleetItem_36);
      FScanToItem := Scan_to_cSFleetItem_36;
      FItemToScan := cSFleetItem_36_to_Scan;
    end; }  //Hier Neue Formate eintragen!
    else
      raise Exception.Create('TcSFleetDBFile.InitFormat: Es soll eine Datei mit einem nicht definierten Format geöffnet werden!');
  end;
end;

procedure TcSFleetDBFile.ItemToPtr(var Buf; const p: pointer);
begin
  TFleetEvent(p^) := FItemToFleet(@Buf);
end;

function TcSFleetDBFile.NewItemPtr: pointer;
begin
  New(PFleetEvent_(Result));
end;

procedure TcSFleetDBFile.PtrToItem(const p: pointer; var Buf);
begin
  FFleetToItem(TFleetEvent(p^),@Buf);
end;

procedure TcSFleetDBFile.SetFleet(nr: Cardinal; Fleet: TFleetEvent);
begin
  SetItem(nr,@Fleet);
end;

procedure TcSFleetDBFile.SetUni(Uni: byte);
begin
  FHeader.Uni := Uni;
  SetHeader(FHeader);
end;

function TcSFleetDB_for_File.AddFleet(Fleet: TFleetEvent): Integer;
begin
  Result := DBFile.Count;
  DBFile.Count := Result + 1;
  DBFile.Fleets[Result] := Fleet;
end;

constructor TcSFleetDB_for_File.Create(aFilename: string;
  Universe: Integer);
var Uni: Integer;
begin
  inherited Create;
  try
    DBFile := TcSFleetDBFile.Create(aFilename);
  except
    on E: EcSDBUnknownFileFormat do
    begin
      DBFile.Free;
      ShowMessage(Format('The DBFile(%s) is in an unknown Format or broken' +
                         'and will be deleted now!' + #13 + #10 +
                         'If you want so save it, do this before you press OK!',
                         [aFilename]));
      DeleteFile(aFilename);
      DBFile := TcSFleetDBFile.Create(aFilename);
    end;
  end;

  //Wenn die datei neu angeleg wurde, ist uni = 0 (und Count = 0)!
  if (DBFile.Universe = 0)and(DBFile.Count = 0) then
  begin
    DBFile.Universe := Universe;
  end;

  if (Universe <> DBFile.Universe) then
  begin
    Uni := DBFile.Universe;
    DBFile.Free;
    ShowMessage(Format('The DBFile(%s) belongs to an other universe(%d)' +
                       'and will be deleted now!' + #13 + #10 +
                       'If you want so save it, do this before you press OK!',
                       [aFilename, Uni]));
    DeleteFile(aFilename);
    DBFile.Create(aFilename);
  end;
end;

procedure TcSFleetDB_for_File.DeleteLastFleet;
begin
  DBFile.Count := DBFile.Count-1;
end; 

destructor TcSFleetDB_for_File.Destroy;
begin
  DBFile.Free;
  inherited;
end;

function TcSFleetDB_for_File.GetCount: Integer;
begin
  Result := DBFile.Count;
end;

function TcSFleetDB_for_File.GetFleet(nr: cardinal): TFleetEvent;
begin
  Result := DBFile.GetFleet(nr);
end;

function TcSFleetDB_for_File.IsOldFormat: Boolean;
begin
  Result := DBFile.FFormat <> high(DBFile.FFormat);
end;

procedure TcSFleetDB_for_File.SetFleet(nr: cardinal;
  Fleet: TFleetEvent);
begin
  DBFile.SetFleet(nr,Fleet);
end;

end.
