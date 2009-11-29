unit cS_DB_solsysFile;

{

Autor: Ulrich Hornung
Datum: 8.8.2007

}

interface

uses
  SDBFile, Windows, SysUtils, OGame_Types, DateUtils, cS_DB, Dialogs;

type
  TcSSolSysFileFormat =
  (css_none, {        css_21 ,}            css_22,                    css_30);
const
  cSSSFFStart = 'cscan_sys_';
  cSSolSysFileFormatstr: array[TcSSolSysFileFormat] of shortstring =
  ( 'error', {'cscan_sys_2.1',} cSSSFFStart+'2.2', 'creatureScan_SolSysDB_3.0');

  StatusItems_21_22 = 'igIuns';

  new_file_ident = 'new_file';

{

Formatversionen:

...
...
...

21 auf 22:

Stat Mond als Boolean gibts jetzt den Mond als Word:

alt:
    Status: TStatusStr;
    Mond: Boolean;

    und noch nen paar andere Änderungen....

neu:
    MondSize: Word;
    MondTemp: Smallint;
    TF: packed array[0..1] of Cardinal;  //0=Metall 1=Kristall


weil es das alte format aber schon lange nicht mehr gibt,
lass ich es hier einfach weg!

22 auf 40:

Fileheader vereinfacht.

}

type
  EcSDBUnknownFileFormat = class(Exception);

  TcSSolSysHeader_10 = record
    V: string[13];
    Uni: Byte;
  end;
  TcSSolSysHeader_20 = packed record
    filetype: string[30];
    domain: string[255];
    dummy_buffer: string[255];
  end;

  TStatusStr_10 = String[8]; //iIg -> 8 falls noch mehr kommt

  TcSSolSysItem_22_Head = packed Record
    Time: TTimeStamp;
    SystemPos: packed array[0..1] of Word;
  end;
  TcSSolSysItem_22_Planet = packed record
    Player: TPlayerName;
    PlanetName: TPlanetName;
    Ally: TAllyName;
    Status: TStatusStr_10;
    MondSize: Word;
    MondTemp: Smallint;
    TF: packed array[0..1] of Cardinal;  //0=Metall 1=Kristall
  end;
  TcSSolSysItem_22 = packed record
    Head: TcSSolSysItem_22_Head;
    Planets: packed Array[1..15] of TcSSolSysItem_22_Planet;
  end;

  TcSSolSysItemToSystemCopy = function(const ItemBuf: pointer): TSystemCopy;
  TSystemCopytocSSolSysItem = procedure(const Scan: TSystemCopy; const ItemBuf: pointer);
  TcSSolSysDBFile = class(TSimpleDBCachedFile)
  private
    FHeader: TcSSolSysHeader_20;
    FFormat: TcSSolSysFileFormat;
    FSysToItem: TSystemCopytocSSolSysItem;
    FItemToSys: TcSSolSysItemToSystemCopy;
    procedure InitFormat;
    function GetUni: string;
    procedure SetUni(Uni: string);
  protected
    function NewItemPtr: pointer; override;
    procedure DisposeItemPtr(const p: pointer); override;
    procedure ItemToPtr(var Buf; const p: pointer); override;
    procedure PtrToItem(const p: pointer; var Buf); override;
  public
    function GetSolSys(nr: Cardinal): TSystemCopy;
    procedure SetSolSys(nr: Cardinal; SolSys: TSystemCopy);
    property SolSys[nr: Cardinal]: TSystemCopy read GetSolSys write SetSolSys;
    property UniDomain: string read GetUni write SetUni;
    constructor Create(aFilename: string);
  end;

  TcSSolSysDB_for_File = class(TcSSolSysDB)
  private
    DBFile: TcSSolSysDBFile;
  protected
    function GetSolSys(nr: cardinal): TSystemCopy; override;
    procedure SetSolSys(nr: cardinal; SolSys: TSystemCopy); override;
    function GetCount: Integer; override;
  public
    constructor Create(aFilename: string; UniDomain: string);
    destructor Destroy; override;

    //Only for compatibility to the old Code:
    procedure DeleteLastSys; override;
    function IsOldFormat: Boolean;
    function AddSolSys(Sys: TSystemCopy): Integer; override;
  end;

implementation


function StatusToStr_21_22(Status: TStatus): String;
var st: TStati;
begin
  Result := '';
  for st := low(st) to high(st) do
    if (st in Status)and(word(st) < length(StatusItems_21_22)) then
      Result := Result + StatusItems_21_22[word(st)+1];
end;

function StrToStatus_21_22(s: string): TStatus;
var i, p: integer;
begin
  Result := [];
  for i := 1 to length(s) do
  begin
    p := pos(s[i],StatusItems_21_22)-1;
    if (p >= low(TStati))and(p <= high(TStati)) then
      Result := Result + [p];
  end;
end;

constructor TcSSolSysDBFile.Create(aFilename: string);
var frmt: TcSSolSysFileFormat;
begin
  FHeaderSize := SizeOf(TcSSolSysHeader_20);
  inherited Create(aFilename,False);

  if (not GetHeader(FHeader)) then
  begin
    FillChar(FHeader, SizeOf(FHeader), 0);
    FFormat := high(cSSolSysFileFormatstr);
    FHeader.filetype := cSSolSysFileFormatstr[FFormat];
    FHeader.domain := new_file_ident;
    FHeader.dummy_buffer := '';
    SetHeader(FHeader);
  end
  else
  begin
    FFormat := css_none;
    for frmt := high(frmt) downto low(frmt) do
      if cSSolSysFileFormatstr[frmt] = FHeader.filetype then
      begin
        FFormat := frmt;
        break;
      end;

    if (FFormat = css_none) then
      raise EcSDBUnknownFileFormat.Create(
        'TcSSolSysDB.Create: Unknown file format (File: "' +
         aFilename  + '", Format: "' + FHeader.filetype + '")');
  end;
  InitFormat;

  LoadList;
end;

function cSSolSysItem_22_to_Sys(const ItemBuf: pointer): TSystemCopy;
var Item: TcSSolSysItem_22;
    i: integer;
begin
  Item := TcSSolSysItem_22(ItemBuf^);

  Result.Time_u := DateTimeToUnix(TimeStampToDateTime(Item.Head.Time));
  Result.System.P[0] := Item.Head.SystemPos[0];
  Result.System.P[1] := Item.Head.SystemPos[1];
  Result.System.P[2] := 1;
  Result.System.Mond := False;

  for i := 1 to length(Result.Planeten) do           //Clear
  begin
    FillChar(Result.Planeten[i],Sizeof(Result.Planeten[i]),0);
  end;

  for i := 1 to length(Item.Planets) do
  begin
    with Result.Planeten[i] do
    begin
      Player := Item.Planets[i].Player;
      PlanetName := Item.Planets[i].PlanetName;
      Ally := Item.Planets[i].Ally;
      Status := StrToStatus_21_22(Item.Planets[i].Status);
      MondSize := Item.Planets[i].MondSize;
      MondTemp := Item.Planets[i].MondTemp;
      TF[0] := Item.Planets[i].TF[0];
      TF[1] := Item.Planets[i].TF[1];
    end;
  end;
end;

procedure Sys_to_cSSolSysItem_22(const Sys: TSystemCopy;
  const ItemBuf: pointer);
var Item: TcSSolSysItem_22;
    i: integer;
begin
  with Item.Head do
  begin
    Time := DateTimeToTimeStamp(UnixToDateTime(Sys.Time_u));
    SystemPos[0] := Sys.System.P[0];
    SystemPos[1] := Sys.System.P[1];
  end;

  for i := 1 to length(Item.Planets) do           //Clear
  begin
    FillChar(Item.Planets[i],Sizeof(Item.Planets[i]),0);
  end;

  for i := 1 to length(Item.Planets) do
  begin
    with Item.Planets[i] do
    begin
      Player := Sys.Planeten[i].Player;
      PlanetName := Sys.Planeten[i].PlanetName;
      Ally := Sys.Planeten[i].Ally;
      Status := StatusToStr_21_22(Sys.Planeten[i].Status);
      MondSize := Sys.Planeten[i].MondSize;
      MondTemp := Sys.Planeten[i].MondTemp;
      TF[0] := Sys.Planeten[i].TF[0];
      TF[1] := Sys.Planeten[i].TF[1];
    end;
  end;

  TcSSolSysItem_22(ItemBuf^) := Item;
end;

procedure TcSSolSysDBFile.DisposeItemPtr(const p: pointer);
begin
  Dispose(PSystemCopy(p));
end;

function TcSSolSysDBFile.GetSolSys(nr: Cardinal): TSystemCopy;
begin
  Result := TSystemCopy(GetCachedItem(nr)^);
end;

function TcSSolSysDBFile.GetUni: string;
begin
  Result := FHeader.domain;
end;

procedure TcSSolSysDBFile.InitFormat;
var old_h_10: TcSSolSysHeader_10;
begin
  case FFormat of
    css_22:
    begin
      FItemSize := SizeOf(TcSSolSysItem_22);
      FSysToItem := Sys_to_cSSolSysItem_22;
      FItemToSys := cSSolSysItem_22_to_Sys;

      // import old header
      FHeaderSize := SizeOf(old_h_10);
      GetHeader(old_h_10); // low level stream read
      FHeader.domain := 'uni' + IntToStr(old_h_10.Uni);
    end;
    css_30:
    begin
      // FHeaderSize := SizeOf(TcSSolSysHeader_20); -> default value
      FItemSize := SizeOf(TcSSolSysItem_22);
      FSysToItem := Sys_to_cSSolSysItem_22;
      FItemToSys := cSSolSysItem_22_to_Sys;
    end; //Hier Neue Formate eintragen!
    else
      raise Exception.Create('TcSSolSysDBFile.InitFormat: Es soll eine Datei mit einem nicht definierten Format geöffnet werden!');
  end;
end;

procedure TcSSolSysDBFile.ItemToPtr(var Buf; const p: pointer);
begin
  TSystemCopy(p^) := FItemToSys(@Buf);
end;

function TcSSolSysDBFile.NewItemPtr: pointer;
begin
  New(PSystemCopy(Result));
  PSystemCopy(Result).Time_u := 0;
end;

procedure TcSSolSysDBFile.PtrToItem(const p: pointer; var Buf);
begin
  FSysToItem(TSystemCopy(p^),@Buf);
end;

procedure TcSSolSysDBFile.SetSolSys(nr: Cardinal; SolSys: TSystemCopy);
begin
  SetItem(nr,@SolSys);
end;

procedure TcSSolSysDBFile.SetUni(Uni: string);
begin
  if FFormat < high(FFormat) then
    raise Exception.Create('TcSSolSysDBFile.SetUni: can''t change old fileformat');

  FHeader.domain := Uni;
  SetHeader(FHeader);
end;

function TcSSolSysDB_for_File.AddSolSys(Sys: TSystemCopy): Integer;
begin
  Result := DBFile.Count;
  DBFile.Count := Result + 1;
  DBFile.SolSys[Result] := Sys;
end;

constructor TcSSolSysDB_for_File.Create(aFilename: string;
  UniDomain: string);
var domain: string;
begin
  inherited Create;
  try
    DBFile := TcSSolSysDBFile.Create(aFilename);
  except
    on E: EcSDBUnknownFileFormat do
    begin
      DBFile.Free;
      ShowMessage(Format('The DBFile(%s) is in an unknown Format or broken' +
                         'and will be deleted now!' + #13 + #10 +
                         'If you want so save it, do this before you press OK!',
                         [aFilename]));
      DeleteFile(aFilename);
      DBFile := TcSSolSysDBFile.Create(aFilename);
    end;
  end;

  if (DBFile.UniDomain = new_file_ident) then
  begin
    DBFile.UniDomain := UniDomain;
  end;

  if (UniDomain <> DBFile.UniDomain) then
  begin
    domain := DBFile.UniDomain;
    DBFile.Free;
    ShowMessage(Format('The DBFile(%s) belongs to an other universe(%d)' +
                       'and will be deleted now!' + #13 + #10 +
                       'If you want so save it, do this before you press OK!',
                       [aFilename, domain]));
    DeleteFile(aFilename);
    DBFile := TcSSolSysDBFile.Create(aFilename);
    DBFile.UniDomain := UniDomain;
  end;
end;

procedure TcSSolSysDB_for_File.DeleteLastSys;
begin
  DBFile.Count := DBFile.Count-1;
end; 

destructor TcSSolSysDB_for_File.Destroy;
begin
  DBFile.Free;
  inherited;
end;

function TcSSolSysDB_for_File.GetCount: Integer;
begin
  Result := DBFile.Count;
end;

function TcSSolSysDB_for_File.GetSolSys(nr: cardinal): TSystemCopy;
begin
  Result := DBFile.GetSolSys(nr);
end;

function TcSSolSysDB_for_File.IsOldFormat: Boolean;
begin
  Result := DBFile.FFormat <> high(DBFile.FFormat);
end;

procedure TcSSolSysDB_for_File.SetSolSys(nr: cardinal;
  SolSys: TSystemCopy);
begin
  DBFile.SetSolSys(nr,SolSys);
end;

end.
