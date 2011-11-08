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
  (csr_none,
   csr_25,
   csr_36,
   csr_37,
   csr_38,
   csr_40,
   csr_41);
const
  cSRFFStarT_ = 'cscan_scan_'; // don't use for new versions
  cSReportFileFormatstr: array[TcSReportFileFormat] of shortstring =
  ('error',
   cSRFFStarT_+'2.5',
   cSRFFStarT_+'3.6',
   cSRFFStarT_+'3.7',
   cSRFFStarT_+'3.8',
   'creatureScan_ScanDB_4.0',
   'creatureScan_ScanDB_4.1');

   new_file_ident = 'new_file';
{

Formatversionen:

...
...
...

***25 auf 36:***

keine Formatänderungen! Nur der bcru(Schlachtkreutzer) wurde neu eingeführt! (kam auch glücklicherweise ans ende der liste dazu!)
deswegen ist auch die einelseroutine kopiert und es hat sich auser der struktur nix geändert!

36, deswegen weil ich mich vertippt hab und eigentlich 26 meinte, aber hab ich erst zu zuspät gemerkt!

***36 auf 37:***
-Neue Forschung: Expeditionstechnik (nach Intergalaktisches Forschungsnetzwerk, vor Gravitonforschung)

***37 auf 38:***
-Aktivitätsanzeige eigelesen!

***39 auf 40***
einfacherer DateiHeader

***40 auf 41***
PlayerID, Ress -> int64

}

type
  EcSDBUnknownReportFileFormat = class(Exception);
  EcSDBFFReportUniDiffers = class(Exception)
  public
    file_universe_name: string;
    constructor Create(const Msg: string; const uniname: string);
  end;

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
    Planet: TPlanetName_utf8;
    Position : packed array[0..2] of Word;
    P_Mond : Boolean;
    Time: TTimeStamp;
    Spieler: TPlayerName_utf8;
    Spionageabwehr: Smallint;
    Creator: TPlayerName_utf8;
    Raid: Boolean;
    Raid_Von: TPlayerName_utf8;
  end;
  TcSReportItem_38_Head = packed record
    Planet: TPlanetName_utf8;
    Position : packed array[0..2] of Word;
    P_Mond : Boolean;
    Time: TTimeStamp;
    Spieler: TPlayerName_utf8;
    Spionageabwehr: Smallint;
    Creator: TPlayerName_utf8;
    Activity: Smallint;
  end;
  TcSReportItem_41_Head = packed record
    Planet: TPlanetName_utf8;
    Position: packed array[0..2] of Word;
    P_Mond: Boolean;
    Time_u: Int64;
    Spieler: TPlayerName_utf8;
    SpielerId: Int64; // invalid: 0 or -1
    Spionageabwehr: Smallint;
    Creator: TPlayerName_utf8;
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
  TcSReportItem_41 = packed record
    Head: TcSReportItem_41_Head;
    g0_resources: packed array[1..4] of Int64;
    g1_fleets: packed array[1..14] of Integer;
    g2_defence: packed array[1..10] of Integer;
    g3_buildings: packed array[1..18] of Shortint;
    g4_research: packed array[1..16] of Shortint;
  end;

  TcSReportItemToScan = procedure(const ItemBuf: pointer; Result: TScanBericht);
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
    destructor Destroy; override;
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

uses cS_utf8_conv;

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
          aFilename  + '", Format: "' + String(FHeader.filetype) + '")');
  end;
  InitFormat;

  LoadList;
end;

procedure cSReportItem_37_to_Scan(const ItemBuf: pointer; Result: TScanBericht);
var Item: TcSReportItem_37;
    i: integer;
begin
  Item := TcSReportItem_37(ItemBuf^);
  Result.clear;

  with Result.Head do
  begin
    Planet := trnslShortStr(Item.Head.Planet);
    Position.P[0] := Item.Head.Position[0];
    Position.P[1] := Item.Head.Position[1];
    Position.P[2] := Item.Head.Position[2];
    Position.Mond := Item.Head.P_Mond;
    Time_u := DateTimeToUnix(TimeStampToDateTime(Item.Head.Time));
    Spieler := trnslShortStr(Item.Head.Spieler);
    Spionageabwehr := Item.Head.Spionageabwehr;
    Creator := trnslShortStr(Item.Head.Creator);
    {geraidet := Item.Head.Raid;
    von := Item.Head.Raid_Von; 14.04.2008: abgeschafft!, Neu: Activity}
    Activity := -1;
  end;

  for i := 1 to length(Item.g0_resources) do
    Result.Bericht[sg_Rohstoffe,i-1] := Item.g0_resources[i];
  for i := 1 to length(Item.g1_fleets) do
    Result.Bericht[sg_Flotten,i-1] := Item.g1_fleets[i];
  for i := 1 to length(Item.g2_defence) do
    Result.Bericht[sg_Verteidigung,i-1] := Item.g2_defence[i];
  for i := 1 to length(Item.g3_buildings) do
    Result.Bericht[sg_Gebaeude,i-1] := Item.g3_buildings[i];
  for i := 1 to length(Item.g4_research) do
    Result.Bericht[sg_Forschung,i-1] := Item.g4_research[i];
end;

procedure cSReportItem_38_to_Scan(const ItemBuf: pointer; Result: TScanBericht);
var Item: TcSReportItem_38;
    i: integer;
begin
  Item := TcSReportItem_38(ItemBuf^);
  Result.clear;

  with Result.Head do
  begin
    Planet := trnslShortStr(Item.Head.Planet);
    Position.P[0] := Item.Head.Position[0];
    Position.P[1] := Item.Head.Position[1];
    Position.P[2] := Item.Head.Position[2];
    Position.Mond := Item.Head.P_Mond;
    Time_u := DateTimeToUnix(TimeStampToDateTime(Item.Head.Time));
    Spieler := trnslShortStr(Item.Head.Spieler);
    Spionageabwehr := Item.Head.Spionageabwehr;
    Creator := trnslShortStr(Item.Head.Creator);
    Activity := Item.Head.Activity;
  end;

  for i := 1 to length(Item.g0_resources) do
    Result.Bericht[sg_Rohstoffe,i-1] := Item.g0_resources[i];
  for i := 1 to length(Item.g1_fleets) do
    Result.Bericht[sg_Flotten,i-1] := Item.g1_fleets[i];
  for i := 1 to length(Item.g2_defence) do
    Result.Bericht[sg_Verteidigung,i-1] := Item.g2_defence[i];
  for i := 1 to length(Item.g3_buildings) do
    Result.Bericht[sg_Gebaeude,i-1] := Item.g3_buildings[i];
  for i := 1 to length(Item.g4_research) do
    Result.Bericht[sg_Forschung,i-1] := Item.g4_research[i];
end;

procedure cSReportItem_36_to_Scan(const ItemBuf: pointer; Result: TScanBericht);
var Item: TcSReportItem_36;
    i: integer;
begin
  Item := TcSReportItem_36(ItemBuf^);
  Result.clear;
  
  with Result.Head do
  begin
    Planet := trnslShortStr(Item.Head.Planet);
    Position.P[0] := Item.Head.Position[0];
    Position.P[1] := Item.Head.Position[1];
    Position.P[2] := Item.Head.Position[2];
    Position.Mond := Item.Head.P_Mond;
    Time_u := DateTimeToUnix(TimeStampToDateTime(Item.Head.Time));
    Spieler := trnslShortStr(Item.Head.Spieler);
    Spionageabwehr := Item.Head.Spionageabwehr;
    Creator := trnslShortStr(Item.Head.Creator);
    {geraidet := Item.Head.Raid;
    von := Item.Head.Raid_Von; 14.04.2008: abgeschafft!, Neu: Activity}
    Activity := -1;
  end;

  for i := 1 to length(Item.g0_resources) do
    Result.Bericht[sg_Rohstoffe,i-1] := Item.g0_resources[i];
  for i := 1 to length(Item.g1_fleets) do
    Result.Bericht[sg_Flotten,i-1] := Item.g1_fleets[i];
  for i := 1 to length(Item.g2_defence) do
    Result.Bericht[sg_Verteidigung,i-1] := Item.g2_defence[i];
  for i := 1 to length(Item.g3_buildings) do
    Result.Bericht[sg_Gebaeude,i-1] := Item.g3_buildings[i];
  for i := 1 to length(Item.g4_research) do
  begin
    if (i-1 >= sb_Expeditionstechnik) then
      Result.Bericht[sg_Forschung,i] := Item.g4_research[i]
    else Result.Bericht[sg_Forschung,i-1] := Item.g4_research[i];
  end;
end;


procedure Scan_to_cSReportItem_37(const Scan: TScanBericht;
  const ItemBuf: pointer);
var Item: TcSReportItem_37;
    i: integer;
begin
  with Item.Head do
  begin
    Planet := trnsltoUTF8(Scan.Head.Planet);
    Position[0] := Scan.Head.Position.P[0];
    Position[1] := Scan.Head.Position.P[1];
    Position[2] := Scan.Head.Position.P[2];
    P_Mond := Scan.Head.Position.Mond;
    Time := DateTimeToTimeStamp(UnixToDateTime(Scan.Head.Time_u));
    Spieler := trnsltoUTF8(Scan.Head.Spieler);
    Spionageabwehr := Scan.Head.Spionageabwehr;
    Creator := trnsltoUTF8(Scan.Head.Creator);
    Raid := false;
    Raid_Von := '';
    { 14.04.2008: abgeschafft!, Neu: Activity }
  end;

  for i := 1 to length(Item.g0_resources) do
    Item.g0_resources[i] := Scan.Bericht[sg_Rohstoffe,i-1];
  for i := 1 to length(Item.g1_fleets) do
    Item.g1_fleets[i] := Scan.Bericht[sg_Flotten,i-1];
  for i := 1 to length(Item.g2_defence) do
    Item.g2_defence[i] := Scan.Bericht[sg_Verteidigung,i-1];
  for i := 1 to length(Item.g3_buildings) do
    Item.g3_buildings[i] := Scan.Bericht[sg_Gebaeude,i-1];
  for i := 1 to length(Item.g4_research) do
    Item.g4_research[i] := Scan.Bericht[sg_Forschung,i-1];

  TcSReportItem_37(ItemBuf^) := Item;
end;

procedure Scan_to_cSReportItem_38(const Scan: TScanBericht;
  const ItemBuf: pointer);
var Item: TcSReportItem_38;
    i: integer;
begin
  with Item.Head do
  begin
    Planet := trnsltoUTF8(Scan.Head.Planet);
    Position[0] := Scan.Head.Position.P[0];
    Position[1] := Scan.Head.Position.P[1];
    Position[2] := Scan.Head.Position.P[2];
    P_Mond := Scan.Head.Position.Mond;
    Time := DateTimeToTimeStamp(UnixToDateTime(Scan.Head.Time_u));
    Spieler := trnsltoUTF8(Scan.Head.Spieler);
    Spionageabwehr := Scan.Head.Spionageabwehr;
    Creator := trnsltoUTF8(Scan.Head.Creator);
    Activity := Scan.Head.Activity;
  end;

  for i := 1 to length(Item.g0_resources) do
    Item.g0_resources[i] := Scan.Bericht[sg_Rohstoffe,i-1];
  for i := 1 to length(Item.g1_fleets) do
    Item.g1_fleets[i] := Scan.Bericht[sg_Flotten,i-1];
  for i := 1 to length(Item.g2_defence) do
    Item.g2_defence[i] := Scan.Bericht[sg_Verteidigung,i-1];
  for i := 1 to length(Item.g3_buildings) do
    Item.g3_buildings[i] := Scan.Bericht[sg_Gebaeude,i-1];
  for i := 1 to length(Item.g4_research) do
    Item.g4_research[i] := Scan.Bericht[sg_Forschung,i-1];

  TcSReportItem_38(ItemBuf^) := Item;
end;

procedure Scan_to_cSReportItem_36(const Scan: TScanBericht;
  const ItemBuf: pointer);
var Item: TcSReportItem_36;
    i: integer;
begin
  with Item.Head do
  begin
    Planet := trnsltoUTF8(Scan.Head.Planet);
    Position[0] := Scan.Head.Position.P[0];
    Position[1] := Scan.Head.Position.P[1];
    Position[2] := Scan.Head.Position.P[2];
    P_Mond := Scan.Head.Position.Mond;
    Time := DateTimeToTimeStamp(UnixToDateTime(Scan.Head.Time_u));
    Spieler := trnsltoUTF8(Scan.Head.Spieler);
    Spionageabwehr := Scan.Head.Spionageabwehr;
    Creator := trnsltoUTF8(Scan.Head.Creator);
    Raid := false;
    Raid_Von := '';
    { 14.04.2008: abgeschafft!, Neu: Activity }
  end;

  for i := 1 to length(Item.g0_resources) do
    Item.g0_resources[i] := Scan.Bericht[sg_Rohstoffe,i-1];
  for i := 1 to length(Item.g1_fleets) do
    Item.g1_fleets[i] := Scan.Bericht[sg_Flotten,i-1];
  for i := 1 to length(Item.g2_defence) do
    Item.g2_defence[i] := Scan.Bericht[sg_Verteidigung,i-1];
  for i := 1 to length(Item.g3_buildings) do
    Item.g3_buildings[i] := Scan.Bericht[sg_Gebaeude,i-1];
  for i := 1 to length(Item.g4_research) do
  begin
    if (i-1 >= sb_Expeditionstechnik) then
      Item.g4_research[i] := Scan.Bericht[sg_Forschung,i]
    else Item.g4_research[i] := Scan.Bericht[sg_Forschung,i-1];
  end;

  TcSReportItem_36(ItemBuf^) := Item;
end;


procedure cSReportItem_25_to_Scan(const ItemBuf: pointer; Result: TScanBericht);
var Item: TcSReportItem_25;
    i: integer;
begin
  Item := TcSReportItem_25(ItemBuf^);
  Result.clear;

  with Result.Head do
  begin
    Planet := trnslShortStr(Item.Head.Planet);
    Position.P[0] := Item.Head.Position[0];
    Position.P[1] := Item.Head.Position[1];
    Position.P[2] := Item.Head.Position[2];
    Position.Mond := Item.Head.P_Mond;
    Time_u := DateTimeToUnix(TimeStampToDateTime(Item.Head.Time));
    Spieler := trnslShortStr(Item.Head.Spieler);
    Spionageabwehr := Item.Head.Spionageabwehr;
    Creator := trnslShortStr(Item.Head.Creator);
    {geraidet := Item.Head.Raid;
    von := Item.Head.Raid_Von;  14.04.2008: abgeschafft!, Neu: Activity}
    Activity := -1;
  end;

  for i := 1 to length(Item.g0_resources) do
    Result.Bericht[sg_Rohstoffe,i-1] := Item.g0_resources[i];
  for i := 1 to length(Item.g1_fleets) do
    Result.Bericht[sg_Flotten,i-1] := Item.g1_fleets[i];
  for i := 1 to length(Item.g2_defence) do
    Result.Bericht[sg_Verteidigung,i-1] := Item.g2_defence[i];
  for i := 1 to length(Item.g3_buildings) do
    Result.Bericht[sg_Gebaeude,i-1] := Item.g3_buildings[i];
  for i := 1 to length(Item.g4_research) do
    Result.Bericht[sg_Forschung,i-1] := Item.g4_research[i];
end;

procedure Scan_to_cSReportItem_25(const Scan: TScanBericht;
  const ItemBuf: pointer);
var Item: TcSReportItem_25;
    i: integer;
begin
  with Item.Head do
  begin
    Planet := trnsltoUTF8(Scan.Head.Planet);
    Position[0] := Scan.Head.Position.P[0];
    Position[1] := Scan.Head.Position.P[1];
    Position[2] := Scan.Head.Position.P[2];
    P_Mond := Scan.Head.Position.Mond;
    Time := DateTimeToTimeStamp(UnixToDateTime(Scan.Head.Time_u));
    Spieler := trnsltoUTF8(Scan.Head.Spieler);
    Spionageabwehr := Scan.Head.Spionageabwehr;
    Creator := trnsltoUTF8(Scan.Head.Creator);
    Raid := false;
    Raid_Von := '';
    { 14.04.2008: abgeschafft!, Neu: Activity}
  end;

  for i := 1 to length(Item.g0_resources) do
    Item.g0_resources[i] := Scan.Bericht[sg_Rohstoffe,i-1];
  for i := 1 to length(Item.g1_fleets) do
    Item.g1_fleets[i] := Scan.Bericht[sg_Flotten,i-1];
  for i := 1 to length(Item.g2_defence) do
    Item.g2_defence[i] := Scan.Bericht[sg_Verteidigung,i-1];
  for i := 1 to length(Item.g3_buildings) do
    Item.g3_buildings[i] := Scan.Bericht[sg_Gebaeude,i-1];
  for i := 1 to length(Item.g4_research) do
    Item.g4_research[i] := Scan.Bericht[sg_Forschung,i-1];

  TcSReportItem_25(ItemBuf^) := Item;
end;

procedure cSReportItem_41_to_Scan(const ItemBuf: pointer; Result: TScanBericht);
var Item: TcSReportItem_41;
    i: integer;
begin
  Item := TcSReportItem_41(ItemBuf^);
  Result.clear;

  with Result.Head do
  begin
    Planet := trnslShortStr(Item.Head.Planet);
    Position.P[0] := Item.Head.Position[0];
    Position.P[1] := Item.Head.Position[1];
    Position.P[2] := Item.Head.Position[2];
    Position.Mond := Item.Head.P_Mond;
    Time_u := Item.Head.Time_u;
    Spieler := trnslShortStr(Item.Head.Spieler);
    SpielerId := Item.Head.SpielerId;
    Spionageabwehr := Item.Head.Spionageabwehr;
    Creator := trnslShortStr(Item.Head.Creator);
    Activity := Item.Head.Activity;
  end;

  for i := 1 to length(Item.g0_resources) do
    Result.Bericht[sg_Rohstoffe,i-1] := Item.g0_resources[i];
  for i := 1 to length(Item.g1_fleets) do
    Result.Bericht[sg_Flotten,i-1] := Item.g1_fleets[i];
  for i := 1 to length(Item.g2_defence) do
    Result.Bericht[sg_Verteidigung,i-1] := Item.g2_defence[i];
  for i := 1 to length(Item.g3_buildings) do
    Result.Bericht[sg_Gebaeude,i-1] := Item.g3_buildings[i];
  for i := 1 to length(Item.g4_research) do
    Result.Bericht[sg_Forschung,i-1] := Item.g4_research[i];
end;

procedure Scan_to_cSReportItem_41(const Scan: TScanBericht;
  const ItemBuf: pointer);
var Item: TcSReportItem_41;
    i: integer;
begin
  with Item.Head do
  begin
    Planet := trnsltoUTF8(Scan.Head.Planet);
    Position[0] := Scan.Head.Position.P[0];
    Position[1] := Scan.Head.Position.P[1];
    Position[2] := Scan.Head.Position.P[2];
    P_Mond := Scan.Head.Position.Mond;
    Time_u := Scan.Head.Time_u;
    Spieler := trnsltoUTF8(Scan.Head.Spieler);
    SpielerId := Scan.Head.SpielerId;
    Spionageabwehr := Scan.Head.Spionageabwehr;
    Creator := trnsltoUTF8(Scan.Head.Creator);
    Activity := Scan.Head.Activity;
  end;

  for i := 1 to length(Item.g0_resources) do
    Item.g0_resources[i] := Scan.Bericht[sg_Rohstoffe,i-1];
  for i := 1 to length(Item.g1_fleets) do
    Item.g1_fleets[i] := Scan.Bericht[sg_Flotten,i-1];
  for i := 1 to length(Item.g2_defence) do
    Item.g2_defence[i] := Scan.Bericht[sg_Verteidigung,i-1];
  for i := 1 to length(Item.g3_buildings) do
    Item.g3_buildings[i] := Scan.Bericht[sg_Gebaeude,i-1];
  for i := 1 to length(Item.g4_research) do
    Item.g4_research[i] := Scan.Bericht[sg_Forschung,i-1];

  TcSReportItem_41(ItemBuf^) := Item;
end;

destructor TcSReportDBFile.Destroy;
begin
  inherited;
end;

procedure TcSReportDBFile.DisposeItemPtr(const p: pointer);
begin
  TScanBericht(p).unlock;
  TScanBericht(p).Free;
end;

function TcSReportDBFile.GetReport(nr: Cardinal): TScanBericht;
begin
  Result := TScanBericht(GetCachedItem(nr));
end;

function TcSReportDBFile.GetUni: string;
begin
  Result := trnslShortStr(FHeader.domain);
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
      FHeader.domain := trnslToUtf8('uni' + IntToStr(old_h_10.Uni));
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
    csr_41:
    begin
      // FHeaderSize := SizeOf(TcSReportHeader_20); -> default value
      FItemSize := SizeOf(TcSReportItem_41);
      FScanToItem := Scan_to_cSReportItem_41;
      FItemToScan := cSReportItem_41_to_Scan;
    end;

    else
      raise Exception.Create('TcSReportDBFile.InitFormat: Es soll eine Datei mit einem nicht definierten Format geöffnet werden!');
  end;
end;

procedure TcSReportDBFile.ItemToPtr(var Buf; const p: pointer);
begin
  TScanBericht(p).unlock;
  FItemToScan(@Buf, TScanBericht(p));
  TScanBericht(p).lock;
end;

function TcSReportDBFile.NewItemPtr: pointer;
begin
  TScanBericht(Result) := TScanBericht.Create;
  TScanBericht(Result).clear;
  TScanBericht(Result).lock;
end;

procedure TcSReportDBFile.PtrToItem(const p: pointer; var Buf);
begin
  FScanToItem(TScanBericht(p),@Buf);
end;

procedure TcSReportDBFile.SetReport(nr: Cardinal; Report: TScanBericht);
begin
  SetItem(nr,Report);
end;

procedure TcSReportDBFile.SetUni(Uni: string);
begin
  if FFormat < high(FFormat) then
    raise Exception.Create('TcSReportDBFile.SetUni: can''t change old fileformat');

  FHeader.domain := trnslToUtf8(Uni);
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
begin
  inherited Create;
  DBFile := TcSReportDBFile.Create(aFilename);

  // wenn die datei gerade neu angelegt wurde,
  // muss noch die domain gesetzt werden!
  if (DBFile.UniDomain = new_file_ident) then
  begin
    DBFile.UniDomain := UniDomain;
  end;

  if (UniDomain <> DBFile.UniDomain) then
  begin
    raise EcSDBFFReportUniDiffers.Create('TcSReportDB_for_File.Create():' +
      'the file is for an other universe!', DBFile.UniDomain);
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

{ EcSDBFFSysUniDiffers }

constructor EcSDBFFReportUniDiffers.Create(const Msg, uniname: string);
begin
  inherited Create(Msg);
  file_universe_name := uniname;
end;

end.
