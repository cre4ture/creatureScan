unit TIReadPlugin;

interface

uses
  Classes, OGame_Types, Windows, SysUtils, IniFiles, Dialogs, Languages,
  cS_memstream;

const
  DLLVNumber = 29;

{
  V29: isCommander in UniCheck

  V28: Count in TStats
  
  V27: stats & sys + playerID + scan_size

  V26: new CallFleetEx

  V25: new directCallFleet

{ V24:
   Added OpenSolSys  21.10.2010

   }

// RELEASE 1.8d 16.11.2009

type
  // ------------------------ DLL Interface ------------------------------------

  TStartDllFunction = function(const inifile: PAnsiChar;
    var Version: integer;
    const uniDomain: PAnsiChar;
    const AUserIniFile: PAnsiChar;
    const AUserIniFileSection: PAnsiChar): Boolean;
  TEndDllFunction = function: boolean;
  TScanToStrFunction = function(scan_buf: pointer; scan_size: cardinal;
    AsTable: Boolean): THandle;
  TRunOptions = procedure();
  TStrToStatus = function(s: ShortString): TStatus;
  TStatusToStr = function(Status: TStatus): ShortString;
  TReadRaidAuftrag = function(s: PAnsiChar; var Auftrag: TRaidAuftrag): Boolean;

  TCheckUni = function(Handle: Integer; var isCommander: Boolean): Boolean;
  TCallFleet = function(pos: TPlanetPosition; job: TFleetEventType): Boolean;
  TCallFleetEx = function(fleet: pointer): Boolean;
  TOpenSolSys = function(pos: TSolSysPosition): Boolean;
  //Scans
  TReadScansFunction = function(Handle: Integer): integer;
  TGetScanFunction = function(Handle: integer; Scan: Pointer; scan_size: cardinal;
    var AskMoon: Boolean): Boolean;
  //Sonnensystem
  TReadSystemFunction = function(Handle: integer; var Sys_X: TSystemCopy_utf8): Boolean;
  //Statistiken
  TReadStats = function(Handle: Integer; var Stats: TStat_utf8; var typ: TStatTypeEx): Boolean;
  //Phalanx-> Besserer Name: Ereignisse
  TReadPhalanxScan = function(Handle: integer): TFleetsInfoSource;
  TGetPhalaxScan = function(fleet: pointer): Boolean; //use Read/WriteBufScan for FleetData!

  TReadSource_NewFunction = function: integer;
  TReadSource_FreeFunction = procedure (Handle: Integer);
  TReadSource_SetTextFunction = function (Handle: Integer; text: PAnsiChar; server_time: int64): Boolean;
  TReadSource_SetHTMLFuncktion = function (Handle: Integer; html: PAnsiChar; server_time: int64): Boolean;

  // ------------------------ DLL Interface ende -------------------------------

  TLangPluginNoPluginException = class(Exception);
  TLangPlugIn = class;
  TLangPlugIn = class(TObject)
  private
    dllfile: AnsiString;
    SBItemfile: AnsiString;
    dllconfig: AnsiString;
    isCommander: boolean;

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
    PCallFleetEx: TCallFleetEx;
    PdirectCallFleet: TCallFleet;
    POpenSolSys: TOpenSolSys;
    PRunOptions: TRunOptions;
    PStrToStatus: TStrToStatus;
    PStatusToStr: TStatusToStr;
    PReadPhalanxScan: TReadPhalanxScan;
    PGetPhalaxScan: TGetPhalaxScan;
    PReadSource_New: TReadSource_NewFunction;
    PReadSource_Free: TReadSource_FreeFunction;
    PReadSource_SetText: TReadSource_SetTextFunction;
    PReadSource_SetHTML: TReadSource_SetHTMLFuncktion;

    SaveInf: AnsiString;
    function OpenDll: Boolean;
    procedure CloseDll;
    procedure AssignProcedures;
    function LoadReportElements(inifile: string): boolean;
    procedure FillFakeElements;
  public
    PluginFilename: string;
    configGameDomain: string;
    ServerURL: string;
    PlugInName: string;
    ValidFile: Boolean;
    SBItems: array[TScanGroup] of TStringList;
    property has_commander: boolean read isCommander;
    function ReadSource_New: integer;
    procedure ReadSource_Free(handle: integer);
    function CallFleet_(pos: TPlanetPosition; job: TFleetEventType): Boolean;
    function CallFleetEx(fleet: TFleetEvent): Boolean;
    function directCallFleet(pos: TPlanetPosition; job: TFleetEventType): Boolean;
    function OpenSolSys(pos: TSolSysPosition): Boolean;
    function GetReport(handle: integer; Bericht: TScanBericht;
      out moon_unknown: Boolean): Boolean;
    function ReadReports(handle: integer): Integer;
    constructor Create;
    function LoadPluginFile(const IniFile: string;
      const ServerURL: string; const ASaveInf: string): boolean;
    function ScanToStr(SB: TScanBericht; AsTable: Boolean): string;
    function ReadSystem(handle: integer;
      var Sys: TSystemCopy; creator: string): Boolean;
    destructor Destroy; override;
    function ReadRaidAuftrag(s: AnsiString; var Auftrag: TRaidAuftrag): Boolean;
    function ReadStats(handle: integer;
      var Stat: TStat; var typ: TStatTypeEx): Boolean;
    function CheckClipboardUni(handle: integer): Boolean;
    procedure RunOptions;
    function StrToStatus(s: string): TStatus;
    function StatusToStr(Status: TStatus): string;
    function ReadPhalanxScan(handle: integer): TFleetsInfoSource;
    function ReadPhalanxScanGet(out fleet: TFleetEvent): Boolean;
    procedure SetReadSourceText(handle: integer;
      text_utf8: AnsiString; server_time: int64);
    procedure SetReadSourceHTML(handle: integer;
      html_utf8: AnsiString; server_time: int64);
  end;

implementation

uses global_options, cS_utf8_conv;

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
  @PCallFleetEx := GetProcAddress(DllHandle, 'CallFleetEx');
  @PdirectCallFleet := GetProcAddress(DllHandle, 'directCallFleet');
  @POpenSolSys := GetProcAddress(DllHandle, 'OpenSolSys');
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

function TLangPlugIn.CallFleet_(pos: TPlanetPosition; job: TFleetEventType): Boolean;
begin
  if Assigned(PCallFleet) then
    Result := PCallFleet(pos, job)
  else
    raise Exception.Create('TLangPlugIn.CallFleet(): dll does not support this feature');
end;

function TLangPlugIn.directCallFleet(pos: TPlanetPosition; job: TFleetEventType): Boolean;
var cs_light: boolean;
begin
  if Assigned(PdirectCallFleet) then
  begin
    cs_light := StrToBool(cS_getGlobalOption('main', 'cs_light', BoolToStr(true)));
    if (cs_light) and (pos.Mond) and (not isCommander) then
    begin
      // im cs_light-Modus dürfen Monde nur dann ausspioniert werden, wenn
      // man einen commander hat.
      Result := False;
      exit;
    end;

    Result := PdirectCallFleet(pos, job)
  end
  else
    raise Exception.Create('TLangPlugIn.directCallFleet(): dll does not support this feature');
end;

function TLangPlugIn.CheckClipboardUni(handle: integer): Boolean;
begin
  Result := Assigned(PCheckUni) and
            PCheckUni(handle, isCommander);
end;

procedure TLangPlugIn.CloseDll;
begin
  if DllHandle <> 0 then
  begin
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

  configGameDomain := '--n/a--';
  ServerURL := '--n/a--';
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

function TLangPlugIn.LoadPluginFile(const IniFile: string;
  const ServerURL: string; const ASaveInf: string): boolean;
const
  section = 'ioplugin';
var ini: TIniFile;
begin
  if DllLoaded then
    CloseDll;

  self.ServerURL := ServerURL;
  SaveInf := AnsiString(ASaveInf);
  Result := FileExists(IniFile);
  if Result then
  begin
    ini := TIniFile.Create(IniFile);
    configGameDomain := ini.ReadString(section,'game_domain','--n/a--');
    PluginFilename := IniFile;
    dllfile := AnsiString(ini.ReadString(section,'dllfile',''));
    dllconfig := AnsiString(ini.ReadString(section,'configfile',''));
    SBItemfile := AnsiString(ini.ReadString(section,'elements',''));
    PlugInName := ini.ReadString(section,'name','');
    ChDir(ExtractFilePath(IniFile));
    Result := (configGameDomain <> '--n/a--')
              and FileExists(WideString(dllconfig))
              and FileExists(WideString(dllfile))
              and (PlugInName <> '')
              and FileExists(WideString(SBItemfile))
              and LoadReportElements(WideString(SBItemfile));
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
  DllHandle := LoadLibrary(PChar(WideString(dllfile)));
  DllLoaded := DllHandle <> 0;
  if DllLoaded then
  begin
    AssignProcedures;
    if not(Assigned(PStartDll)and
       PStartDll(PAnsiChar(dllconfig),V,PAnsiChar(trnsltoUTF8(ServerURL)),
                 PAnsiChar(SaveInf),PAnsiChar(trnsltoUTF8(PlugInName)))) then
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

    end;
  end;
  if not DllLoaded then
  begin
    AssignProcedures; //setzte sie wieder nil
    PlugInName := 'None/Error';
  end;
  Result := DllLoaded;
end;

function TLangPlugIn.ReadRaidAuftrag(s: AnsiString; var Auftrag: TRaidAuftrag): Boolean;
begin
  if Assigned(PReadRaidAuftrag) then
    Result := PReadRaidAuftrag(PAnsiChar(s),Auftrag)
  else Result := False;
end;

function TLangPlugIn.GetReport(handle: integer; Bericht: TScanBericht;
  out moon_unknown: Boolean): Boolean;
var stream: TFixedMemoryStream_out;
begin
  //Speicher reservieren
  stream := TFixedMemoryStream_out.Create(Bericht.serialize_size());
  try
    //DLL aufrufen:
    if Assigned(PGetScan) then
      Result := PGetScan(handle, stream.p, stream.size, moon_unknown)
    else Result := False;

    Bericht.deserialize(stream);
  finally
    stream.Free;
  end;
end;

function TLangPlugIn.ReadReports(handle: integer): Integer;
begin
  Result := 0;
  //Dll aufrufen:
  if Assigned(PReadScans) then
  begin
    Result := PReadScans(handle);
  end;
end;

procedure TLangPlugIn.ReadSource_Free(handle: integer);
begin
  if Assigned(PReadSource_Free) then
    PReadSource_Free(handle);
end;

function TLangPlugIn.ReadSource_New: integer;
begin
  if Assigned(PReadSource_New) then
    Result := PReadSource_New()
  else
    Result := -1;
end;

function TLangPlugIn.ReadStats(handle: integer;
  var Stat: TStat; var typ: TStatTypeEx): Boolean;
var stat_utf8: TStat_utf8;
begin
  if Assigned(PReadStats) then
  begin
    Result := PReadStats(handle, stat_utf8, typ);
    decodeStatUTF8(stat_utf8, Stat);
  end
  else Result := False;
end;

function TLangPlugIn.ReadSystem(handle: integer;
  var Sys: TSystemCopy; creator: string): Boolean;
var sys_utf8: TSystemCopy_utf8;
begin
  if Assigned(PReadSystem) then
  begin
    Result := PReadSystem(handle, sys_utf8);
    decodeSysUTF8(sys_utf8, Sys);
    Sys.Creator := creator;
  end
  else Result := False;
end;

procedure TLangPlugIn.RunOptions;
begin
  if Assigned(PRunOptions) then PRunOptions
  else ShowMessage('No options available');
end;

function TLangPlugIn.ScanToStr(SB: TScanBericht; AsTable: Boolean): String;
var stream: TFixedMemoryStream_out;
    gh: THandle; //GlobalMemory
begin
  stream := TFixedMemoryStream_out.Create(SB.serialize_size());
  SB.serialize(stream);
  try
    if Assigned(PScanToStr) then
    begin
      gh := PScanToStr(stream.p, stream.size, AsTable);
      Result := trnslShortStr(PAnsiChar(GlobalLock(gh)));
      GlobalUnlock(gh);
      GlobalFree(gh);
    end
    else Result := '';
  finally
    stream.Free;
  end;
end;

procedure TLangPlugIn.SetReadSourceHTML(handle: integer;
  html_utf8: AnsiString; server_time: int64);
begin
  if Assigned(PReadSource_SetHTML) then
  begin
    PReadSource_SetHTML(handle, PAnsiChar(html_utf8), server_time);
  end
  else
    raise TLangPluginNoPluginException.Create(
      'TLangPlugIn.SetReadSourceHTML: Plugin fehlerhaft, oder kein Plugin geladen!');
end;

procedure TLangPlugIn.SetReadSourceText(handle: integer;
  text_utf8: AnsiString; server_time: int64);
begin
  if Assigned(PReadSource_SetText) then
  begin
    PReadSource_SetText(handle, PAnsiChar(text_utf8), server_time);
  end
  else
    raise TLangPluginNoPluginException.Create(
      'TLangPlugIn.SetReadSourceText: Plugin fehlerhaft, oder kein Plugin geladen!');
end;

function TLangPlugIn.StatusToStr(Status: TStatus): string;
begin
  if Assigned(PStatusToStr) then
  begin
    Result := trnslShortStr(PStatusToStr(Status));
  end
  else Result := '';
end;

function TLangPlugIn.StrToStatus(s: string): TStatus;
begin
  if Assigned(PStrToStatus) then
  begin
    Result := PStrToStatus(trnslToUtf8(s));
  end
  else Result := [];
end;

function TLangPlugIn.ReadPhalanxScan(handle: integer): TFleetsInfoSource;
begin
  if Assigned(PReadPhalanxScan) then
    Result := PReadPhalanxScan(handle)
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
    try
      Result := PGetPhalaxScan(buf);
      fleet := ReadBufFleet(buf);
    finally
      FreeMem(buf);
    end;
  end
  else Result := false;
end;

function TLangPlugIn.OpenSolSys(pos: TSolSysPosition): Boolean;
begin
  if Assigned(POpenSolSys) then
    Result := POpenSolSys(pos)
  else
    raise Exception.Create(
      'TLangPlugIn.OpenSolSys(): dll does not support this feature');
end;

function TLangPlugIn.CallFleetEx(fleet: TFleetEvent): Boolean;
var buf: pointer;
begin
  if Assigned(PCallFleetEx) then
  begin
    GetMem(buf, BufFleetSize());
    try
      WriteBufFleet(fleet, buf);
      Result := PCallFleetEx(buf);
    finally
      FreeMem(buf);
    end;
  end
  else
    raise Exception.Create(
      'TLangPlugIn.CallFleetEx(): dll does not support this feature');
end;

end.
