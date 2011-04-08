unit cS_DB_reportFile;

{

Autor: Ulrich Hornung
Datum: 14.7.2007

}

interface

uses
  SDBFile, Windows, SysUtils, OGame_Types, DateUtils, cS_DB, Dialogs;

type
  TcSReportFileFormat =
  (csr_none,           csr_25,           csr_36,           csr_37,
   csr_38          , csr_40);
const
  cSRFFStarT_ = 'cscan_scan_'; // don't use for new versions
  cSReportFileFormatstr: array[TcSReportFileFormat] of shortstring =
  ( 'error', cSRFFStarT_+'2.5', cSRFFStarT_+'3.6', cSRFFStarT_+'3.7',
   cSRFFStarT_+'3.8', 'creatureScan_ScanDB_4.0');

   new_file_ident = 'new_file';
{

Formatversionen:

...
...
...

***25 auf 36:***

keine Format�nderungen! Nur der bcru(Schlachtkreutzer) wurde neu eingef�hrt! (kam auch gl�cklicherweise ans ende der liste dazu!)
deswegen ist auch die einelseroutine kopiert und es hat sich auser der struktur nix ge�ndert!

36, deswegen weil ich mich vertippt hab und eigentlich 26 meinte, aber hab ich erst zu zusp�t gemerkt!

***36 auf 37:***
-Neue Forschung: Expeditionstechnik (nach Intergalaktisches Forschungsnetzwerk, vor Gravitonforschung)

***37 auf 38:***
-Aktivit�tsanzeige eigelesen!

***39 auf 40***
einfacherer DateiHeader

}

type
  EcSDBUnknownReportFileFormat = class(Exception);

  TcSReportHeader_10 = record
    V: string[14];
    Uni: Byte;
  end;
  TcSReportHeader_20 = packed record
    filetype: string[30];
    domain: string[255];
    dummy_buffer: string[255];
  end;

  TcSReportItem_25_36_37_Head = packed record
    Planet: TPlanetName;
    Position : packed array[0..2] of Word;
    P_Mond : Boolean;
    Time: TTimeStamp;
    Spieler: TPlayerName;
    Spionageabwehr: Smallint;
    Creator: TPlayerName;
    Raid: Boolean;
    Raid_Von: TPlayerName;
  end;
  TcSReportItem_38_Head = packed record
    Planet: TPlanetName;
    Position : packed array[0..2] of Word;
    P_Mond : Boolean;
    Time: TTimeStamp;
    Spieler: TPlayerName;
    Spionageabwehr: Smallint;
    Creator: TPlayerName;
    Activity: Smallint;
  end;
  TcSReportItem_25 = packed record
    Head: TcSReportItem_25_36_37_Head;
    g0_resources: packed array[1..4] of Integer;
    g1_fleets: packed array[1..13] of Integer;
    g2_defence: packed array[1..10] of Integer;
    g3_buildings: packed array[1..18] of Shortint;
    g4_research: packed array[1..15] of Shortint;
  end;
  TcSReportItem_36 = packed record
    Head: TcSReportItem_25_36_37_Head;
    g0_resources: packed array[1..4] of Integer;
    g1_fleets: packed array[1..14] of Integer;
    g2_defence: packed array[1..10] of Integer;
    g3_buildings: packed array[1..18] of Shortint;
    g4_research: packed array[1..15] of Shortint;
  end;
  TcSReportItem_37 = packed record
    Head: TcSReportItem_25_36_37_Head;
    g0_resources: packed array[1..4] of Integer;
    g1_fleets: packed array[1..14] of Integer;
    g2_defence: packed array[1..10] of Integer;
    g3_buildings: packed array[1..18] of Shortint;
    g4_research: packed array[1..16] of Shortint;
  end;
  TcSReportItem_38 = packed record
    Head: TcSReportItem_38_Head;
    g0_resources: packed array[1..4] of Integer;
    g1_fleets: packed array[1..14] of Integer;
    g2_defence: packed array[1..10] of Integer;
    g3_buildings: packed array[1..18] of Shortint;
    g4_research: packed array[1..16] of Shortint;
  end;

  TcSReportItemToScan = function(const ItemBuf: pointer): TScanBericht;
  TScantocSReportItem = procedure(const Scan: TScanBericht; const ItemBuf: pointer);
  TcSReportDBFile = class(TSimpleDBCachedFile)
  private
    FHeader: TcSReportHeader_20;
    FFormat: TcSReportFileFormat;
    FScanToItem: TScantocSReportItem;
    FItemToScan: TcSReportItemToScan;
    procedure InitFormat;
    function GetUni: string;
    procedure SetUni(Uni: string);
  protected
    function NewItemPtr: pointer; override;
    procedure DisposeItemPtr(const p: pointer); override;
    procedure ItemToPtr(var Buf; const p: pointer); override;
    procedure PtrToItem(const p: pointer; var Buf); override;
  public
    function GetReport(nr: Cardinal): TScanBericht;
    procedure SetReport(nr: Cardinal; Report: TScanBericht);
    property Reports[nr: Cardinal]: TScanBericht read GetReport write SetReport;
    property UniDomain: string read GetUni write SetUni;
    constructor Create(aFilename: string);
  end;

  TcSReportDB_for_File = class(TcSReportDB)
  private
    DBFile: TcSReportDBFile;
  protected
    function GetReport(nr: cardinal): TScanBericht; override;
    procedure SetReport(nr: cardinal; Report: TScanBericht); override;
    function GetCount: Integer; override;
  public
    constructor Create(aFilename: string; UniDomain: string);
    destructor Destroy; override;
    function AddReport(Report: TScanBericht): Integer; override;

    //Only for compatibility to the old Code:
    procedure DeleteLastScan; override;
    function IsOldFormat: Boolean;
  end;

implementation

constructor TcSReportDBFile.Create(aFilename: string);
var frmt: TcSReportFileFormat;
begin
  FHeaderSize := SizeOf(TcSReportHeader_20);
  inherited Create(aFilename,False);

  if (not GetHeader(FHeader)) then
  begin
    FillChar(FHeader, SizeOf(FHeader), 0);
    FFormat := high(cSReportFileFormatstr);
    FHeader.filetype := cSReportFileFormatstr[FFormat];
    FHeader.domain := new_file_ident;
    FHeader.dummy_buffer := '';
    SetHeader(FHeader);
  end
  else
  begin
    FFormat := csr_none;
    for frmt := high(frmt) downto low(frmt) do
      if cSReportFileFormatstr[frmt] = FHeader.filetype then
      begin
        FFormat := frmt;
        break;
      end;

    if (FFormat = csr_none) then
      raise EcSDBUnknownReportFileFormat.Create(
        'TcSReportDB.Create: Unknown file format (File: "' +
        aFilename  + '", Format: "' + FHeader.filetype + '")');
  end;
  InitFormat;

  LoadList;
end;

function cSReportItem_37_to_Scan(const ItemBuf: pointer): TScanBericht;
var Item: TcSReportItem_37;
    i: integer;
    sg: TScanGroup;
begin
  Item := TcSReportItem_37(ItemBuf^);

  with Result.Head do
  begin
    Planet := Item.Head.Planet;
    Position.P[0] := Item.Head.Position[0];
    Position.P[1] := Item.Head.Position[1];
    Position.P[2] := Item.Head.Position[2];
    Position.Mond := Item.Head.P_Mond;
    Time_u := DateTimeToUnix(TimeStampToDateTime(Item.Head.Time));
    Spieler := Item.Head.Spieler;
    Spionageabwehr := Item.Head.Spionageabwehr;
    Creator := Item.Head.Creator;
    {geraidet := Item.Head.Raid;
    von := Item.Head.Raid_Von; 14.04.2008: abgeschafft!, Neu: Activity}
    Activity := -1;
  end;

  for sg := low(sg) to high(sg) do           //Clear, weil der Scan unabh�ngig von der Datei (Array-L�ngen) sein muss!
  begin
    SetLength(Result.Bericht[sg],ScanFileCounts[sg]);
    for i := 0 to ScanFileCounts[sg]-1 do
    begin
      Result.Bericht[sg,i] := 0;
    end;
  end;

  for i := 1 to length(Item.g0_resources) do
    Result.Bericht[sg_Rohstoffe][i-1] := Item.g0_resources[i];
  for i := 1 to length(Item.g1_fleets) do
    Result.Bericht[sg_Flotten][i-1] := Item.g1_fleets[i];
  for i := 1 to length(Item.g2_defence) do
    Result.Bericht[sg_Verteidigung][i-1] := Item.g2_defence[i];
  for i := 1 to length(Item.g3_buildings) do
    Result.Bericht[sg_Gebaeude][i-1] := Item.g3_buildings[i];
  for i := 1 to length(Item.g4_research) do
    Result.Bericht[sg_Forschung][i-1] := Item.g4_research[i];
end;

function cSReportItem_38_to_Scan(const ItemBuf: pointer): TScanBericht;
var Item: TcSReportItem_38;
    i: integer;
    sg: TScanGroup;
begin
  Item := TcSReportItem_38(ItemBuf^);

  with Result.Head do
  begin
    Planet := Item.Head.Planet;
    Position.P[0] := Item.Head.Position[0];
    Position.P[1] := Item.Head.Position[1];
    Position.P[2] := Item.Head.Position[2];
    Position.Mond := Item.Head.P_Mond;
    Time_u := DateTimeToUnix(TimeStampToDateTime(Item.Head.Time));
    Spieler := Item.Head.Spieler;
    Spionageabwehr := Item.Head.Spionageabwehr;
    Creator := Item.Head.Creator;
    Activity := Item.Head.Activity;
  end;

  for sg := low(sg) to high(sg) do           //Clear, weil der Scan unabh�ngig von der Datei (Array-L�ngen) sein muss!
  begin
    SetLength(Result.Bericht[sg],ScanFileCounts[sg]);
    for i := 0 to ScanFileCounts[sg]-1 do
    begin
      Result.Bericht[sg,i] := 0;
    end;
  end;

  for i := 1 to length(Item.g0_resources) do
    Result.Bericht[sg_Rohstoffe][i-1] := Item.g0_resources[i];
  for i := 1 to length(Item.g1_fleets) do
    Result.Bericht[sg_Flotten][i-1] := Item.g1_fleets[i];
  for i := 1 to length(Item.g2_defence) do
    Result.Bericht[sg_Verteidigung][i-1] := Item.g2_defence[i];
  for i := 1 to length(Item.g3_buildings) do
    Result.Bericht[sg_Gebaeude][i-1] := Item.g3_buildings[i];
  for i := 1 to length(Item.g4_research) do
    Result.Bericht[sg_Forschung][i-1] := Item.g4_research[i];
end;

function cSReportItem_36_to_Scan(const ItemBuf: pointer): TScanBericht;
var Item: TcSReportItem_36;
    i: integer;
    sg: TScanGroup;
begin
  Item := TcSReportItem_36(ItemBuf^);

  with Result.Head do
  begin
    Planet := Item.Head.Planet;
    Position.P[0] := Item.Head.Position[0];
    Position.P[1] := Item.Head.Position[1];
    Position.P[2] := Item.Head.Position[2];
    Position.Mond := Item.Head.P_Mond;
    Time_u := DateTimeToUnix(TimeStampToDateTime(Item.Head.Time));
    Spieler := Item.Head.Spieler;
    Spionageabwehr := Item.Head.Spionageabwehr;
    Creator := Item.Head.Creator;
    {geraidet := Item.Head.Raid;
    von := Item.Head.Raid_Von; 14.04.2008: abgeschafft!, Neu: Activity}
    Activity := -1;
  end;

  for sg := low(sg) to high(sg) do           //Clear, weil der Scan unabh�ngig von der Datei (Array-L�ngen) sein muss!
  begin
    SetLength(Result.Bericht[sg],ScanFileCounts[sg]);
    for i := 0 to ScanFileCounts[sg]-1 do
    begin
      Result.Bericht[sg,i] := 0;
    end;
  end;

  for i := 1 to length(Item.g0_resources) do
    Result.Bericht[sg_Rohstoffe][i-1] := Item.g0_resources[i];
  for i := 1 to length(Item.g1_fleets) do
    Result.Bericht[sg_Flotten][i-1] := Item.g1_fleets[i];
  for i := 1 to length(Item.g2_defence) do
    Result.Bericht[sg_Verteidigung][i-1] := Item.g2_defence[i];
  for i := 1 to length(Item.g3_buildings) do
    Result.Bericht[sg_Gebaeude][i-1] := Item.g3_buildings[i];
  for i := 1 to length(Item.g4_research) do
  begin
    if (i-1 >= sb_Expeditionstechnik) then
      Result.Bericht[sg_Forschung][i] := Item.g4_research[i]
    else Result.Bericht[sg_Forschung][i-1] := Item.g4_research[i];
  end;
end;


procedure Scan_to_cSReportItem_37(const Scan: TScanBericht;
  const ItemBuf: pointer);
var Item: TcSReportItem_37;
    i: integer;
begin
  with Item.Head do
  begin
    Planet := Scan.Head.Planet;
    Position[0] := Scan.Head.Position.P[0];
    Position[1] := Scan.Head.Position.P[1];
    Position[2] := Scan.Head.Position.P[2];
    P_Mond := Scan.Head.Position.Mond;
    Time := DateTimeToTimeStamp(UnixToDateTime(Scan.Head.Time_u));
    Spieler := Scan.Head.Spieler;
    Spionageabwehr := Scan.Head.Spionageabwehr;
    Creator := Scan.Head.Creator;
    Raid := false;
    Raid_Von := '';
    { 14.04.2008: abgeschafft!, Neu: Activity }
  end;

  for i := 1 to length(Item.g0_resources) do
    Item.g0_resources[i] := Scan.Bericht[sg_Rohstoffe][i-1];
  for i := 1 to length(Item.g1_fleets) do
    Item.g1_fleets[i] := Scan.Bericht[sg_Flotten][i-1];
  for i := 1 to length(Item.g2_defence) do
    Item.g2_defence[i] := Scan.Bericht[sg_Verteidigung][i-1];
  for i := 1 to length(Item.g3_buildings) do
    Item.g3_buildings[i] := Scan.Bericht[sg_Gebaeude][i-1];
  for i := 1 to length(Item.g4_research) do
    Item.g4_research[i] := Scan.Bericht[sg_Forschung][i-1];

  TcSReportItem_37(ItemBuf^) := Item;
end;

procedure Scan_to_cSReportItem_38(const Scan: TScanBericht;
  const ItemBuf: pointer);
var Item: TcSReportItem_38;
    i: integer;
begin
  with Item.Head do
  begin
    Planet := Scan.Head.Planet;
    Position[0] := Scan.Head.Position.P[0];
    Position[1] := Scan.Head.Position.P[1];
    Position[2] := Scan.Head.Position.P[2];
    P_Mond := Scan.Head.Position.Mond;
    Time := DateTimeToTimeStamp(UnixToDateTime(Scan.Head.Time_u));
    Spieler := Scan.Head.Spieler;
    Spionageabwehr := Scan.Head.Spionageabwehr;
    Creator := Scan.Head.Creator;
    Activity := Scan.Head.Activity;
  end;

  for i := 1 to length(Item.g0_resources) do
    Item.g0_resources[i] := Scan.Bericht[sg_Rohstoffe][i-1];
  for i := 1 to length(Item.g1_fleets) do
    Item.g1_fleets[i] := Scan.Bericht[sg_Flotten][i-1];
  for i := 1 to length(Item.g2_defence) do
    Item.g2_defence[i] := Scan.Bericht[sg_Verteidigung][i-1];
  for i := 1 to length(Item.g3_buildings) do
    Item.g3_buildings[i] := Scan.Bericht[sg_Gebaeude][i-1];
  for i := 1 to length(Item.g4_research) do
    Item.g4_research[i] := Scan.Bericht[sg_Forschung][i-1];

  TcSReportItem_38(ItemBuf^) := Item;
end;

procedure Scan_to_cSReportItem_36(const Scan: TScanBericht;
  const ItemBuf: pointer);
var Item: TcSReportItem_36;
    i: integer;
begin
  with Item.Head do
  begin
    Planet := Scan.Head.Planet;
    Position[0] := Scan.Head.Position.P[0];
    Position[1] := Scan.Head.Position.P[1];
    Position[2] := Scan.Head.Position.P[2];
    P_Mond := Scan.Head.Position.Mond;
    Time := DateTimeToTimeStamp(UnixToDateTime(Scan.Head.Time_u));
    Spieler := Scan.Head.Spieler;
    Spionageabwehr := Scan.Head.Spionageabwehr;
    Creator := Scan.Head.Creator;
    Raid := false;
    Raid_Von := '';
    { 14.04.2008: abgeschafft!, Neu: Activity }
  end;

  for i := 1 to length(Item.g0_resources) do
    Item.g0_resources[i] := Scan.Bericht[sg_Rohstoffe][i-1];
  for i := 1 to length(Item.g1_fleets) do
    Item.g1_fleets[i] := Scan.Bericht[sg_Flotten][i-1];
  for i := 1 to length(Item.g2_defence) do
    Item.g2_defence[i] := Scan.Bericht[sg_Verteidigung][i-1];
  for i := 1 to length(Item.g3_buildings) do
    Item.g3_buildings[i] := Scan.Bericht[sg_Gebaeude][i-1];
  for i := 1 to length(Item.g4_research) do
  begin
    if (i-1 >= sb_Expeditionstechnik) then
      Item.g4_research[i] := Scan.Bericht[sg_Forschung][i]
    else Item.g4_research[i] := Scan.Bericht[sg_Forschung][i-1];
  end;

  TcSReportItem_36(ItemBuf^) := Item;
end;


function cSReportItem_25_to_Scan(const ItemBuf: pointer): TScanBericht;
var Item: TcSReportItem_25;
    i: integer;
    sg: TScanGroup;
begin
  Item := TcSReportItem_25(ItemBuf^);

  with Result.Head do
  begin
    Planet := Item.Head.Planet;
    Position.P[0] := Item.Head.Position[0];
    Position.P[1] := Item.Head.Position[1];
    Position.P[2] := Item.Head.Position[2];
    Position.Mond := Item.Head.P_Mond;
    Time_u := DateTimeToUnix(TimeStampToDateTime(Item.Head.Time));
    Spieler := Item.Head.Spieler;
    Spionageabwehr := Item.Head.Spionageabwehr;
    Creator := Item.Head.Creator;
    {geraidet := Item.Head.Raid;
    von := Item.Head.Raid_Von;  14.04.2008: abgeschafft!, Neu: Activity}
    Activity := -1;
  end;

  for sg := low(sg) to high(sg) do           //Clear, weil der Scan unabh�ngig von der Datei (Array-L�ngen) sein muss!
  begin
    SetLength(Result.Bericht[sg],ScanFileCounts[sg]);
    for i := 0 to ScanFileCounts[sg]-1 do
    begin
      Result.Bericht[sg,i] := 0;
    end;
  end;

  for i := 1 to length(Item.g0_resources) do
    Result.Bericht[sg_Rohstoffe][i-1] := Item.g0_resources[i];
  for i := 1 to length(Item.g1_fleets) do
    Result.Bericht[sg_Flotten][i-1] := Item.g1_fleets[i];
  for i := 1 to length(Item.g2_defence) do
    Result.Bericht[sg_Verteidigung][i-1] := Item.g2_defence[i];
  for i := 1 to length(Item.g3_buildings) do
    Result.Bericht[sg_Gebaeude][i-1] := Item.g3_buildings[i];
  for i := 1 to length(Item.g4_research) do
    Result.Bericht[sg_Forschung][i-1] := Item.g4_research[i];
end;

procedure Scan_to_cSReportItem_25(const Scan: TScanBericht;
  const ItemBuf: pointer);
var Item: TcSReportItem_25;
    i: integer;
begin
  with Item.Head do
  begin
    Planet := Scan.Head.Planet;
    Position[0] := Scan.Head.Position.P[0];
    Position[1] := Scan.Head.Position.P[1];
    Position[2] := Scan.Head.Position.P[2];
    P_Mond := Scan.Head.Position.Mond;
    Time := DateTimeToTimeStamp(UnixToDateTime(Scan.Head.Time_u));
    Spieler := Scan.Head.Spieler;
    Spionageabwehr := Scan.Head.Spionageabwehr;
    Creator := Scan.Head.Creator;
    Raid := false;
    Raid_Von := '';
    { 14.04.2008: abgeschafft!, Neu: Activity}
  end;

  for i := 1 to length(Item.g0_resources) do
    Item.g0_resources[i] := Scan.Bericht[sg_Rohstoffe][i-1];
  for i := 1 to length(Item.g1_fleets) do
    Item.g1_fleets[i] := Scan.Bericht[sg_Flotten][i-1];
  for i := 1 to length(Item.g2_defence) do
    Item.g2_defence[i] := Scan.Bericht[sg_Verteidigung][i-1];
  for i := 1 to length(Item.g3_buildings) do
    Item.g3_buildings[i] := Scan.Bericht[sg_Gebaeude][i-1];
  for i := 1 to length(Item.g4_research) do
    Item.g4_research[i] := Scan.Bericht[sg_Forschung][i-1];

  TcSReportItem_25(ItemBuf^) := Item;
end;



procedure TcSReportDBFile.DisposeItemPtr(const p: pointer);
begin
  Dispose(PScanBericht(p));
end;

function TcSReportDBFile.GetReport(nr: Cardinal): TScanBericht;
begin
  Result := TScanBericht(GetCachedItem(nr)^);
end;

function TcSReportDBFile.GetUni: string;
begin
  Result := FHeader.domain;
end;

procedure TcSReportDBFile.InitFormat;
var old_h_10: TcSReportHeader_10;
begin
  // import old header
  case FFormat of
    csr_25 .. csr_38:
    begin
      FHeaderSize := SizeOf(old_h_10);
      GetHeader(old_h_10); // low level stream read
      FHeader.domain := 'uni' + IntToStr(old_h_10.Uni);
    end;
  end;

  // set read/write function pointer
  case FFormat of
    csr_25:
    begin
      FItemSize := SizeOf(TcSReportItem_25);
      FScanToItem := Scan_to_cSReportItem_25;
      FItemToScan := cSReportItem_25_to_Scan;
    end;
    csr_36:
    begin
      FItemSize := SizeOf(TcSReportItem_36);
      FScanToItem := Scan_to_cSReportItem_36;
      FItemToScan := cSReportItem_36_to_Scan;
    end;
    csr_37:
    begin
      FItemSize := SizeOf(TcSReportItem_37);
      FScanToItem := Scan_to_cSReportItem_37;
      FItemToScan := cSReportItem_37_to_Scan;
    end;
    csr_38:
    begin
      FItemSize := SizeOf(TcSReportItem_38);
      FScanToItem := Scan_to_cSReportItem_38;
      FItemToScan := cSReportItem_38_to_Scan;
    end;
    csr_40:
    begin
      // FHeaderSize := SizeOf(TcSReportHeader_20); -> default value
      FItemSize := SizeOf(TcSReportItem_38);
      FScanToItem := Scan_to_cSReportItem_38;
      FItemToScan := cSReportItem_38_to_Scan;
    end;

    else
      raise Exception.Create('TcSReportDBFile.InitFormat: Es soll eine Datei mit einem nicht definierten Format ge�ffnet werden!');
  end;
end;

procedure TcSReportDBFile.ItemToPtr(var Buf; const p: pointer);
begin
  TScanBericht(p^) := FItemToScan(@Buf);
end;

function TcSReportDBFile.NewItemPtr: pointer;
begin
  New(PScanBericht(Result));
  PScanBericht(Result).Head.Time_u := 0;
end;

procedure TcSReportDBFile.PtrToItem(const p: pointer; var Buf);
begin
  FScanToItem(TScanBericht(p^),@Buf);
end;

procedure TcSReportDBFile.SetReport(nr: Cardinal; Report: TScanBericht);
begin
  SetItem(nr,@Report);
end;

procedure TcSReportDBFile.SetUni(Uni: string);
begin
  if FFormat < high(FFormat) then
    raise Exception.Create('TcSReportDBFile.SetUni: can''t change old fileformat');

  FHeader.domain := Uni;
  SetHeader(FHeader);
end;

function TcSReportDB_for_File.AddReport(Report: TScanBericht): Integer;
begin
  Result := DBFile.Count;
  DBFile.Count := Result + 1;
  DBFile.Reports[Result] := Report;
end;

constructor TcSReportDB_for_File.Create(aFilename: string;
  UniDomain: string);
var domain: string;
begin
  inherited Create;
  try
    DBFile := TcSReportDBFile.Create(aFilename);
  except
    on E: EcSDBUnknownReportFileFormat do
    begin
      DBFile.Free;
      ShowMessage(Format('The DBFile(%s) is in an unknown Format or broken' +
                         'and will be deleted now!' + #13 + #10 +
                         'If you want so save it, do this before you press OK!',
                         [aFilename]));
      DeleteFile(aFilename);
      DBFile := TcSReportDBFile.Create(aFilename);
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
    ShowMessage(Format('The DBFile(%s) belongs to an other universe(%s)' +
                       'and will be deleted now!' + #13 + #10 +
                       'If you want so save it, do this before you press OK!',
                       [aFilename, domain]));
    DeleteFile(aFilename);
    DBFile := TcSReportDBFile.Create(aFilename);
    DBFile.UniDomain := UniDomain;
  end;
end;

procedure TcSReportDB_for_File.DeleteLastScan;
begin
  DBFile.Count := DBFile.Count-1;
end;

destructor TcSReportDB_for_File.Destroy;
begin
  DBFile.Free;
  inherited;
end;

function TcSReportDB_for_File.GetCount: Integer;
begin
  Result := DBFile.Count;
end;

function TcSReportDB_for_File.GetReport(nr: cardinal): TScanBericht;
begin
  Result := DBFile.GetReport(nr);
end;

function TcSReportDB_for_File.IsOldFormat: Boolean;
begin
  Result := DBFile.FFormat <> high(DBFile.FFormat);
end;

procedure TcSReportDB_for_File.SetReport(nr: cardinal;
  Report: TScanBericht);
begin
  DBFile.SetReport(nr,Report);
end;

end.
