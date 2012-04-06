unit cS_DB_generic;

{

Autor: Ulrich Hornung
Datum: 14.7.2007

}

interface

uses
  SDBFile, Windows, SysUtils, DateUtils, cS_DB, Dialogs;

const
   generic_version_string = 'generic_db_1.0';
   new_file_ident = 'new_file';

type
  EcSDBUnknownGenericItemFileFormat = class(Exception);
  EcSDBFFGenericItemUniDiffers = class(Exception)
  public
    file_universe_name: string;
    constructor Create(const Msg: string; const uniname: string);
  end;

  TAbstractGenericItemManager<TItem: class> = class
  protected
    // Create a new Item and give pointer back to it
    function NewItemPtr: TItem; virtual; abstract;
    // Convert Pointer to Item and delete it
    procedure DisposeItemPtr(const p: TItem); virtual; abstract;
    // Copy content of BufItem (from file) to Pointer-Item-Instance
    procedure ItemToPtr(var Buf; const p: TItem); virtual; abstract;
    // Copy content of Pointer-Item-Instance to BufItem (written to file)
    procedure PtrToItem(const p: TItem; var Buf); virtual; abstract;
    // returns string that identifies the version in param format
    function getFormatString(format: integer): string; virtual; abstract;
    // returns newest (default) format version number
    function getNewestFormat: integer; virtual; abstract;
    // returns elementsize for given format version
    function getFormatElementSize(format: integer): Cardinal; virtual; abstract;
    // configures self for given version format
    procedure initFormat(format: integer; elementSize: cardinal); virtual; abstract;
  end;

  TGenericItemDBFileHeader = packed record // 1 kb header
    header_format: string[127];    // 128
    header_size: Cardinal;         // 4
    element_size: Cardinal;        // 4
    dummy_buffer0: string[127-8];  // fill 256b!
    element_format: string[255];   // 256
    security_token: string[255];   // 256
    dummy_buffer2: string[255];    // fill 1kb!
  end;

  TcSGenericItemDBFile<T: class> = class(TSimpleDBCachedFile)
  private
    FHeader: TGenericItemDBFileHeader;
    FItemFormat: integer;
    ItemManager: TAbstractGenericItemManager<T>;
    function GetUni: string;
    procedure SetUni(Uni: string);
  protected
    function NewItemPtr: pointer; override;
    procedure DisposeItemPtr(const p: pointer); override;
    procedure ItemToPtr(var Buf; const p: pointer); override;
    procedure PtrToItem(const p: pointer; var Buf); override;
  public
    function GetGenericItem(nr: Cardinal): T;
    procedure SetGenericItem(nr: Cardinal; GenericItem: T);
    property GenericItems[nr: Cardinal]: T read GetGenericItem write SetGenericItem;
    property UniDomain: string read GetUni write SetUni;
    constructor Create(aFilename: string; aItemManager: TAbstractGenericItemManager<T>);
    destructor Destroy; override;
  end;

  TcSGenericItemDB_for_File<T: class> = class(TcSGenericItemDB<T>)
  private
    DBFile: TcSGenericItemDBFile<T>;
  protected
    function GetGenericItem(nr: cardinal): T; override;
    procedure SetGenericItem(nr: cardinal; GenericItem: T); override;
    function GetCount: Integer; override;
  public
    constructor Create(aFilename: string; UniDomain: string; manager: TAbstractGenericItemManager<T>);
    destructor Destroy; override;
    function AddGenericItem(GenericItem: T): Integer; override;

    //Only for compatibility to the old Code:
    procedure DeleteLastGenericItem; override;
    function IsOldFormat: Boolean;
  end;

implementation

uses cS_utf8_conv;

constructor TcSGenericItemDBFile<T>.Create(aFilename: string;
  aItemManager: TAbstractGenericItemManager<T>);
var frmt: Integer;
begin
  ItemManager := aItemManager;
  FHeaderSize := Sizeof(FHeader);
  if (FHeaderSize <> 1024) then
    raise Exception.Create('TcSGenericItemDBFile<T>.Create(): Internal: Headersize != 1024');

  inherited Create(aFilename,False);

  if (not GetHeader(FHeader)) then
  begin
    FillChar(FHeader, SizeOf(FHeader), 0);
    FItemFormat := ItemManager.getNewestFormat;
    FHeader.header_format := generic_version_string;
    FHeader.header_size := FHeaderSize;
    FHeader.element_size := ItemManager.getFormatElementSize(FItemFormat);
    FHeader.element_format := trnsltoUTF8(ItemManager.getFormatString(FItemFormat));
    FHeader.security_token := new_file_ident;
    SetHeader(FHeader);
  end
  else
  begin
    if (FHeader.header_format <> generic_version_string) then
      raise Exception.Create('TcSGenericItemDBFile<T>.Create(): Formatstring does not Match!');

    FItemFormat := -1;
    for frmt := ItemManager.getNewestFormat downto 0 do
      if ItemManager.getFormatString(frmt) = trnslShortStr(FHeader.element_format) then
      begin
        FItemFormat := frmt;
        break;
      end;

    if (FItemFormat < 0) then
      raise EcSDBUnknownGenericItemFileFormat.Create(
        'TcSGenericItemDBFile<T>.Create: Unknown element format (File: "' +
          aFilename  + '", Format: "' + String(FHeader.element_format) + '")');
  end;

  FItemSize := FHeader.element_size;
  ItemManager.initFormat(FItemFormat, FItemSize);

  LoadList;
end;

destructor TcSGenericItemDBFile<T>.Destroy;
begin
  inherited;
end;

procedure TcSGenericItemDBFile<T>.DisposeItemPtr(const p: pointer);
begin
  ItemManager.DisposeItemPtr(T(TObject(p)));
end;

function TcSGenericItemDBFile<T>.GetGenericItem(nr: Cardinal): T;
begin
  Result := T(TObject(GetCachedItem(nr)));
end;

function TcSGenericItemDBFile<T>.GetUni: string;
begin
  Result := trnslShortStr(FHeader.security_token);
end;

procedure TcSGenericItemDBFile<T>.ItemToPtr(var Buf; const p: pointer);
begin
  ItemManager.ItemToPtr(Buf, T(TObject(p)));
end;

function TcSGenericItemDBFile<T>.NewItemPtr: pointer;
begin
  T(TObject(Result)) := ItemManager.NewItemPtr();
end;

procedure TcSGenericItemDBFile<T>.PtrToItem(const p: pointer; var Buf);
begin
   ItemManager.PtrToItem(T(TObject(p)), Buf);
end;

procedure TcSGenericItemDBFile<T>.SetGenericItem(nr: Cardinal; GenericItem: T);
begin
  SetItem(nr,Pointer(TObject(GenericItem)));
end;

procedure TcSGenericItemDBFile<T>.SetUni(Uni: string);
begin
  if FItemFormat <> ItemManager.getNewestFormat then
    raise Exception.Create('TcSGenericItemDBFile<T>.SetUni: can''t change old itemformat');

  FHeader.security_token := trnslToUtf8(Uni);
  SetHeader(FHeader);
end;

function TcSGenericItemDB_for_File<T>.AddGenericItem(GenericItem: T): Integer;
begin
  Result := DBFile.Count;
  DBFile.Count := Result + 1;
  DBFile.GenericItems[Result] := GenericItem;
end;

constructor TcSGenericItemDB_for_File<T>.Create(aFilename: string;
  UniDomain: string; manager: TAbstractGenericItemManager<T>);
begin
  inherited Create;
  DBFile := TcSGenericItemDBFile<T>.Create(aFilename, manager);

  // wenn die datei gerade neu angelegt wurde,
  // muss noch die domain gesetzt werden!
  if (DBFile.UniDomain = new_file_ident) then
  begin
    DBFile.UniDomain := UniDomain;
  end;

  if (UniDomain <> DBFile.UniDomain) then
  begin
    raise EcSDBFFGenericItemUniDiffers.Create('TcSGenericItemDB_for_File.Create():' +
      'the file is for an other universe!', DBFile.UniDomain);
  end;
end;

procedure TcSGenericItemDB_for_File<T>.DeleteLastGenericItem;
begin
  DBFile.Count := DBFile.Count-1;
end;

destructor TcSGenericItemDB_for_File<T>.Destroy;
begin
  DBFile.Free;
  inherited;
end;

function TcSGenericItemDB_for_File<T>.GetCount: Integer;
begin
  Result := DBFile.Count;
end;

function TcSGenericItemDB_for_File<T>.GetGenericItem(nr: cardinal): T;
begin
  Result := DBFile.GetGenericItem(nr);
end;

function TcSGenericItemDB_for_File<T>.IsOldFormat: Boolean;
begin
  Result := DBFile.FItemFormat <> DBFile.ItemManager.getNewestFormat;
end;

procedure TcSGenericItemDB_for_File<T>.SetGenericItem(nr: cardinal;
  GenericItem: T);
begin
  DBFile.SetGenericItem(nr,GenericItem);
end;

{ EcSDBFFSysUniDiffers }

constructor EcSDBFFGenericItemUniDiffers.Create(const Msg, uniname: string);
begin
  inherited Create(Msg);
  file_universe_name := uniname;
end;

end.



