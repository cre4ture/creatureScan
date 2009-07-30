unit TIReadPlugin;

interface

uses
  Classes, OGame_Types, Windows, SysUtils, IniFiles, Dialogs, Languages;

const
  DLLVNumber = 22;

type
  // ------------------------ DLL Interface ------------------------------------

  TStartDllFunction = function(const inifile: PChar; var Version: integer; const AUni: Integer;
    AUserIniFile, AUserIniFileSection: PChar): Boolean;
  TEndDllFunction = function: boolean;
  TScanToStrFunction = function(SB: Pointer; AsTable: Boolean): THandle;
  TRunOptions = procedure();
  TStrToStatus = function(s: ShortString): TStatus;
  TStatusToStr = function(Status: TStatus): ShortString;
  TReadRaidAuftrag = function(s: PChar; var Auftrag: TRaidAuftrag): Boolean;

  TCheckUni = function(Handle: Integer): Boolean;
  TCallFleet = function (pos: TPlanetPosition; job: TFleetEventType): Boolean;
  //Scans
  TReadScansFunction = function(Handle: Integer): integer;
  TGetScanFunction = function(Handle: integer; Scan: Pointer; var AskMoon: Boolean): Boolean;
  //Sonnensystem
  TReadSystemFunction = function(Handle: integer; var Sys_X: TSystemCopy): Boolean;
  //Statistiken
  TReadStats = function(Handle: Integer; var Stats: TStat; var typ: TStatTypeEx): Boolean;
  //Phalanx-> Besserer Name: Ereignisse
  TReadPhalanxScan = function(Handle: integer): TFleetsInfoSource;
  TGetPhalaxScan = function(fleet: pointer): Boolean; //use Read/WriteBufScan for FleetData!

  TReadSource_NewFunction = function: integer;
  TReadSource_FreeFunction = procedure (Handle: Integer);
  TReadSource_SetTextFunction = function (Handle: Integer; text: PChar; server_time: int64): Boolean;
  TReadSource_SetHTMLFuncktion = function (Handle: Integer; html: PChar; server_time: int64): Boolean;

  // ------------------------ DLL Interface ende -------------------------------

  TLangPlugIn = class;
  TLangPlugin_AskMoon = procedure(Sender: TLangPlugIn; Report: TScanBericht;
    var isMoon: Boolean; var Handled: Boolean) of object;
  TLangPlugIn = class(TObject)
  private
    dllfile: string;
    SBItemfile: string;
    dllconfig: String;
  protected
    DllHandle: THandle;
    DllLoaded: boolean;
    
    //Dll-Funktionen:
    PScanToStr: TScanToStrFunction;
    PScanToStrTable: TScanToStrFunction;
    PStartDll: TStartDllFunction;
    PEndDll: TEndDllFunction;
    PReadScans: TReadScansFunction;
    PGetScan: TGetScanFunction;
    PReadSystem: TReadSystemFunction;
    PReadRaidAuftrag: TReadRaidAuftrag;
    PReadStats: TReadStats;
    PCheckUni: TCheckUni;
    PCallFleet: TCallFleet;
    PRunOptions: TRunOptions;
    PStrToStatus: TStrToStatus;
    PStatusToStr: TStatusToStr;
    PReadPhalanxScan: TReadPhalanxScan;
    PGetPhalaxScan: TGetPhalaxScan;
    PReadSource_New: TReadSource_NewFunction;
    PReadSource_Free: TReadSource_FreeFunction;
    PReadSource_SetText: TReadSource_SetTextFunction;
    PReadSource_SetHTML: TReadSource_SetHTMLFuncktion;

    SaveInf: string;
    rs_handle: integer;
    function OpenDll: Boolean;
    procedure CloseDll;
    procedure AssignProcedures;
    function LoadReportElements(inifile: string): boolean;
    procedure FillFakeElements;
  public
    PluginFilename: String;
    game_domain: string;
    Universe: integer;
    PlugInName: String;
    ValidFile: Boolean;
    SBItems: array[TScanGroup] of TStringList;
    OnAskMoon: TLangPlugin_AskMoon;
    procedure CallFleet(pos: TPlanetPosition; job: TFleetEventType);
    function GetReport(var Bericht: TScanBericht): Boolean;
    function ReadReports(): Integer;
    constructor Create;
    function LoadPluginFile(IniFile: String; AUni: Integer; ASaveInf: String): boolean;
    function ScanToStr(SB: TScanBericht; AsTable: Boolean): String;
    function ReadSystem(var Sys: TSystemCopy): Boolean;
    destructor Destroy; override;
    function ReadRaidAuftrag(s: string; var Auftrag: TRaidAuftrag): Boolean;
    function ReadStats(var Stat: TStat; var typ: TStatTypeEx): Boolean;
    function CheckClipboardUni(): Boolean;
    procedure RunOptions;
    function StrToStatus(s: string): TStatus;
    function StatusToStr(Status: TStatus): String;
    function ReadPhalanxScan(): TFleetsInfoSource;
    function ReadPhalanxScanGet(out fleet: TFleetEvent): Boolean;
    procedure SetReadSourceText(text: string; server_time: int64);
    procedure SetReadSourceHTML(html: string; server_time: int64);
  end;

implementation

uses Mond_Abfrage;

procedure TLangPlugIn.AssignProcedures;
begin
  @PStartDll := GetProcAddress(DllHandle, 'StartDll');
  @PEndDll := GetProcAddress(DllHandle, 'EndDll');
  @PScanToStr := GetProcAddress(DllHandle, 'ScanToStr');
  @PScanToStrTable := GetProcAddress(DllHandle, 'ScanToStrTable');
  @PReadScans := GetProcAddress(DllHandle, 'ReadScans');
  @PGetScan := GetProcAddress(DllHandle, 'GetScan');
  @PReadSystem := GetProcAddress(DllHandle, 'ReadSystem');
  @PReadRaidAuftrag := GetProcAddress(DllHandle, 'ReadRaidAuftrag');
  @PReadStats := GetProcAddress(DllHandle, 'ReadStats');
  @PCheckUni := GetProcAddress(DllHandle, 'CheckUni');
  @PCallFleet := GetProcAddress(DllHandle, 'CallFleet');
  @PRunOptions := GetProcAddress(DllHandle, 'RunOptions');
  @PStrToStatus := GetProcAddress(DllHandle, 'StrToStatus');
  @PStatusToStr := GetProcAddress(DllHandle, 'StatusToStr');
  @PReadPhalanxScan := GetProcAddress(DllHandle, 'ReadPhalanxScan');
  @PGetPhalaxScan := GetProcAddress(DllHandle, 'GetPhalaxScan');

  @PReadSource_New := GetProcAddress(DllHandle, 'ReadSource_New');
  @PReadSource_Free := GetProcAddress(DllHandle, 'ReadSource_Free');
  @PReadSource_SetText := GetProcAddress(DllHandle, 'ReadSource_SetText');
  @PReadSource_SetHTML := GetProcAddress(DllHandle, 'ReadSource_SetHTML');

end;

procedure TLangPlugIn.CallFleet(pos: TPlanetPosition; job: TFleetEventType);
var ret: boolean;
begin
  if Assigned(PCallFleet) then
    ret := PCallFleet(pos, job)
  else
    raise Exception.Create('TLangPlugIn.CallFleet(): dll does not support this feature');
end;

function TLangPlugIn.CheckClipboardUni(): Boolean;
begin
  Result := Assigned(PCheckUni) and
            PCheckUni(rs_handle);
end;

procedure TLangPlugIn.CloseDll;
begin
  if DllHandle <> 0 then
  begin
    //ReadSource Handle löschen
    if Assigned(PReadSource_Free) then
      PReadSource_Free(rs_handle);

    if Assigned(PEndDll) then PEndDll;
    FreeLibrary(DllHandle);
    DllHandle := 0;
  end;
  AssignProcedures; //setzte nil!
  DllLoaded := False;
  PlugInName := 'None/Error';
end;

constructor TLangPlugIn.Create;
begin
  inherited Create;
  DllLoaded := False;
  DllHandle := 0;

  Universe := 0;
  SaveInf := '';

  FillFakeElements;  //Leere Namen laden!

  AssignProcedures;  //nil setzten!
end;

destructor TLangPlugIn.Destroy;
var sg: TScanGroup;
begin
  if DllLoaded then CloseDll;
  for sg := low(sg) to high(sg) do
    SBItems[sg].Free;
  Inherited Destroy;
end;

procedure TLangPlugIn.FillFakeElements;
var j: integer;
    sg: TScanGroup;
begin
  for sg := low(sg) to high(sg) do               
  begin
    SBItems[sg] := TStringList.Create;
    for j := 0 to ScanFileCounts[sg] do
      SBItems[sg].Add(IntToStr(Integer(sg)) + '|' + IntToStr(j));
  end;
end;

function TLangPlugIn.LoadReportElements(inifile: string): boolean;
var ini: TIniFile;
    sg: TScanGroup;
begin
  Result := True;
  ini := TIniFile.Create(ExpandFileName(inifile));
  for sg := low(sg) to high(sg) do
  begin
    SBItems[sg].Clear;
    ini.ReadSection('SB'+inttostr(Integer(sg)), SBItems[sg]);
    if SBItems[sg].Count-1 <> ScanFileCounts[sg] then
    begin
      ShowMessage(STR_MSG_ScanBerichtObjekte_Fehlen_IniDatei);
      Result := False;
      Break;
    end;
  end;
  ini.free;
end;

function TLangPlugIn.LoadPluginFile(IniFile: String; AUni: Integer; ASaveInf: String): boolean;
const
  section = 'ioplugin';
var ini: TIniFile;
begin
  if DllLoaded then
    CloseDll;

  Universe := AUni;
  SaveInf := ASaveInf;
  Result := FileExists(IniFile);
  if Result then
  begin
    ini := TIniFile.Create(IniFile);
    game_domain := ini.ReadString(section,'game_domain','--n/a--');
    PluginFilename := IniFile;
    dllfile := ini.ReadString(section,'dllfile','');
    dllconfig := ini.ReadString(section,'configfile','');
    SBItemfile := ini.ReadString(section,'elements','');
    PlugInName := ini.ReadString(section,'name','');
    ChDir(ExtractFilePath(IniFile));
    Result := (game_domain <> '--n/a--')
              and FileExists(dllconfig)
              and FileExists(dllfile)
              and (PlugInName <> '')
              and FileExists(SBItemfile)
              and LoadReportElements(SBItemfile);
    if Result then
      OpenDll
    else
    begin
      PlugInName := 'None/Error';
      FillFakeElements;
    end;
    ini.free;
  end;
  ValidFile := Result;
end;

function TLangPlugIn.OpenDll: Boolean;
var V: integer;
begin
  DllHandle := LoadLibrary(PChar(dllfile));
  DllLoaded := DllHandle <> 0;
  if DllLoaded then
  begin
    AssignProcedures;
    if not(Assigned(PStartDll)and
       PStartDll(PChar(dllconfig),V,Universe,PChar(SaveInf),PChar(PlugInName))) then
    begin
      //Irgend ein Fehler
      FreeLibrary(DllHandle);
      DllHandle := 0;
      DllLoaded := False;
    end
    else
    begin
      //Erfolgreich geladen
      if V <> DllVNumber then
        ShowMessage(STR_MSG_Old_Dll);

      // ReadSource Handle besorgen
      rs_handle := PReadSource_New();
    end;
  end;
  if not DllLoaded then
  begin
    AssignProcedures; //setzte sie wieder nil
    PlugInName := 'None/Error';
  end;
  Result := DllLoaded;
end;

function TLangPlugIn.ReadRaidAuftrag(s: string; var Auftrag: TRaidAuftrag): Boolean;
begin
  if Assigned(PReadRaidAuftrag) then
    Result := PReadRaidAuftrag(PChar(s),Auftrag)
  else Result := False;
end;

function TLangPlugIn.GetReport(var Bericht: TScanBericht): Boolean;
var buf: pointer;
    FRM_Mond: TFRM_Mond;
    AskMond, handled, isMoon: Boolean;
begin
  //Speicher reservieren
  GetMem(buf,ScanSize);
  try
    //DLL aufrufen:
    if Assigned(PGetScan) then
      Result := PGetScan(rs_handle, buf, AskMond)
    else Result := False;

    Bericht := ReadBufScan(buf);
  finally
    FreeMem(buf);
  end;

  if Result then
  begin
    //Benutzer nach Mond fragen (nur wenn nicht eindeutig -> AskMond)
    if AskMond then
    begin
      //Ereignissbehandlungroutine
      handled := false;
      if Assigned(OnAskMoon) then
        OnAskMoon(Self,Bericht,isMoon,handled);
      //TODO: enferne abfrage hier komplett
      if handled then
        Bericht.Head.Position.Mond := isMoon
      else
      begin
        FRM_Mond := TFRM_Mond.Create(nil, Self);
        Beep;
        Bericht.Head.Position.Mond := (FRM_Mond.Open(Bericht));
        FRM_Mond.free;
      end;
    end;
  end;
end;

function TLangPlugIn.ReadReports(): Integer;
begin
  //Dll aufrufen:
  if Assigned(PReadScans) then
    Result := PReadScans(rs_handle)
  else Result := 0;
end;

function TLangPlugIn.ReadStats(var Stat: TStat; var typ: TStatTypeEx): Boolean;
begin
  if Assigned(PReadStats) then
    Result := PReadStats(rs_handle, Stat, typ)
  else Result := False;
end;

function TLangPlugIn.ReadSystem(var Sys: TSystemCopy): Boolean;
begin
  if Assigned(PReadSystem) then
  begin
    Result := PReadSystem(rs_handle, Sys);
  end
  else Result := False;
end;

procedure TLangPlugIn.RunOptions;
begin
  if Assigned(PRunOptions) then PRunOptions
  else ShowMessage('No options available');
end;

function TLangPlugIn.ScanToStr(SB: TScanBericht; AsTable: Boolean): String;
var buf: pointer;
    gh: THandle; //GlobalMemory
begin
  GetMem(buf,ScanSize);
  WriteBufScan(SB,buf);
  try
    if Assigned(PScanToStr) then
    begin
      gh := PScanToStr(buf, AsTable);
      Result := PChar(GlobalLock(gh));
      GlobalUnlock(gh);
      GlobalFree(gh);
    end
    else Result := '';
  finally
    FreeMem(buf);
  end;
end;

procedure TLangPlugIn.SetReadSourceHTML(html: string; server_time: int64);
begin
  if Assigned(PReadSource_SetHTML) then
  begin
    PReadSource_SetHTML(rs_handle, PChar(html), server_time);
  end
  else
    raise Exception.Create(
      'TLangPlugIn.SetReadSourceHTML: Plugin fehlerhaft, oder kein Plugin geladen!');
end;

procedure TLangPlugIn.SetReadSourceText(text: string; server_time: int64);
begin
  if Assigned(PReadSource_SetText) then
  begin
    PReadSource_SetText(rs_handle, PChar(text), server_time);
  end
  else
    raise Exception.Create(
      'TLangPlugIn.SetReadSourceText: Plugin fehlerhaft, oder kein Plugin geladen!');
end;

function TLangPlugIn.StatusToStr(Status: TStatus): String;
begin
  if Assigned(PStatusToStr) then
    Result := PStatusToStr(Status)
  else Result := '';
end;

function TLangPlugIn.StrToStatus(s: string): TStatus;
begin
  if Assigned(PStrToStatus) then
    Result := PStrToStatus(s)
  else Result := [];
end;

function TLangPlugIn.ReadPhalanxScan(): TFleetsInfoSource;
begin
  if Assigned(PReadPhalanxScan) then
    Result := PReadPhalanxScan(rs_handle)
  else
  begin
    Result.Count := 0;
    Result.typ := fist_none;
  end;
end;

function TLangPlugIn.ReadPhalanxScanGet(out fleet: TFleetEvent): Boolean;
var buf: pointer;
begin
  if Assigned(PGetPhalaxScan) then
  begin
    GetMem(buf, BufFleetSize());
    Result := PGetPhalaxScan(buf);
    fleet := ReadBufFleet(buf);
  end
  else Result := false;
end;

end.
