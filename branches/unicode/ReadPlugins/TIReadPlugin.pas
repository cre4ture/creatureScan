unit TIReadPlugin;

interface

uses
  Classes, OGame_Types, Windows, SysUtils, IniFiles, Dialogs, Languages,
  cS_memstream, TIReadPlugin_Types, TIReadPlugin_Types_conv_UNICODE;

const
  DLLVNumber = 100;

{
  V100: completly renewed!
        independent string lengths...
        utf8!
        compatible with c-language ( by theory )

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

  //Phalanx-> Besserer Name: Ereignisse
  Tdll_readFleetEventList = function(rs_handle: integer;
        info: PPPortableFleetsInfoSource): Boolean; stdcall;
  Tdll_getFleetEvent = function(rs_handle: integer;
        index: integer; fleet: pointer): Boolean; stdcall;

  Tdll_doStrToStatus = function(input_s: PAnsiChar): TStatus; stdcall;
  Tdll_doStatusToStr = function(rs_handle: integer; Status: TStatus): PAnsiChar; stdcall;

  Tdll_startDll = function(const inifile: PAnsiChar;
        pVersion: PInteger;
        const uniDomain: PAnsiChar;
        const AUserIniFile: PAnsiChar;
        const AUserIniFileSection: PAnsiChar): Boolean; stdcall;
  Tdll_endDll = function: boolean; stdcall;

  Tdll_doScanToStr = function(rs_handle: integer;
        asTable: Boolean;
        p_scan_head: PPortableScanHead;
        p_scan_body: PPortableScanBody): PAnsiChar; stdcall;
  //Scans
  Tdll_readScans = function(rs_handle: Integer): integer; stdcall;
  Tdll_getScan = function(
        rs_handle: integer;
        scan_index: integer;
        p_scan_head: PPortableScanHead;
        p_scan_body: PPortableScanBody;
        askMoon: PBoolean): Boolean; stdcall;

  Tdll_runOptions = procedure; stdcall;
  Tdll_checkUni = function(rs_handle: Integer;
        isCommander: PBoolean): Boolean; stdcall;

  Tdll_callFleet = function(pos: PPortablePlanetPosition;
        job: Integer): Boolean; stdcall;
  Tdll_callFleetExtended = function(fleet: pointer): Boolean; stdcall;
  Tdll_directCallFleet = function(pos: PPortablePlanetPosition;
        job: Integer): Boolean; stdcall;

  Tdll_openSolSys = function(pos: PPortablePlanetPosition): Boolean; stdcall;


  //Sonnensystem
  Tdll_readSolarSystem = function(rs_handle: integer;
        p_sys_head: PPPortableSolarSystemHead): Boolean; stdcall;
  Tdll_getSolarSystemPlanet = function(rs_handle: integer;
        index: integer;
        p_sys_planet: PPPortableSolarSystemPlanet): Boolean; stdcall;


  //Statistiken
  Tdll_readStatistics = function(rs_handle: Integer;
        p_stats: PPPortableStatisticPageHead): Boolean; stdcall;
  Tdll_getStatisticEntry = function(rs_handle: Integer;
        index: integer;
        p_stat_entry: PPPortableStatisticEntry): Boolean; stdcall;

  Tdll_ReadSource_New = function: integer; stdcall;
  Tdll_ReadSource_Free = procedure(rs_handle: Integer); stdcall;
  Tdll_ReadSource_SetText = function(rs_handle: Integer;
        text: PAnsiChar; server_time_u: int64): Boolean; stdcall;
  Tdll_ReadSource_SetHTML = function(rs_handle: Integer;
        html: PAnsiChar; server_time_u: int64): Boolean; stdcall;

  Tdll_testReadSource = procedure(rs_handle: Integer); stdcall;

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
    pdll_readFleetEventList: Tdll_readFleetEventList;
    pdll_getFleetEvent: Tdll_getFleetEvent;

    pdll_doStrToStatus: Tdll_doStrToStatus;
    pdll_doStatusToStr: Tdll_doStatusToStr;

    pdll_startDll: Tdll_startDll;
    pdll_endDll: Tdll_endDll;

    pdll_doScanToStr: Tdll_doScanToStr;

    pdll_readScans: Tdll_readScans;
    pdll_getScan: Tdll_getScan;

    pdll_runOptions: Tdll_runOptions;

    pdll_checkUni: Tdll_checkUni;

    pdll_callFleet: Tdll_callFleet;
    pdll_callFleetExtended: Tdll_callFleetExtended;
    pdll_directCallFleet: Tdll_directCallFleet;
    pdll_openSolSys : Tdll_openSolSys;

    pdll_readSolarSystem: Tdll_readSolarSystem;
    pdll_getSolarSystemPlanet: Tdll_getSolarSystemPlanet;

    pdll_readStatistics: Tdll_readStatistics;
    pdll_getStatisticEntry: Tdll_getStatisticEntry;

    pdll_ReadSource_New: Tdll_ReadSource_New;
    pdll_ReadSource_Free: Tdll_ReadSource_Free;
    pdll_ReadSource_SetText: Tdll_ReadSource_SetText;
    pdll_ReadSource_SetHTML: Tdll_ReadSource_SetHTML;

    pdll_testReadSource: Tdll_testReadSource;

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
    procedure test_ShowReadSourceContent(handle: integer);
    procedure ReadSource_Free(handle: integer);
    function CallFleet_(pos: TPlanetPosition; job: TFleetEventType): Boolean;
    function CallFleetEx(fleet: TFleetEvent): Boolean;
    function directCallFleet(pos: TPlanetPosition; job: TFleetEventType): Boolean;
    function OpenSolSys(pos: TSolSysPosition): Boolean;
    function GetReport(handle: integer; index: integer; Bericht: TScanBericht;
      out moon_unknown: Boolean): Boolean;
    function ReadReports(handle: integer): Integer;
    constructor Create;
    function LoadPluginFile(const IniFile: string;
      const ServerURL: string; const ASaveInf: string): boolean;
    function ScanToStr(SB: TScanBericht; AsTable: Boolean): string;
    function ReadSystem(handle: integer;
      var Sys: TSystemCopy; creator: string): Boolean;
    destructor Destroy; override;
    function ReadStats(handle: integer;
      var Stat: TStat; var typ: TStatTypeEx): Boolean;
    function CheckClipboardUni(handle: integer): Boolean;
    procedure RunOptions;
    function StrToStatus(s: string): TStatus;
    function StatusToStr(Status: TStatus): string;
    function ReadPhalanxScan(handle: integer): TFleetsInfoSource;
    function ReadPhalanxScanGet(const handle: integer;
      const index: integer;
      out fleet: TFleetEvent): Boolean;
    procedure SetReadSourceText(handle: integer;
      text_utf8: AnsiString; server_time: int64);
    procedure SetReadSourceHTML(handle: integer;
      html_utf8: AnsiString; server_time: int64);
  end;

implementation

uses global_options, cS_utf8_conv;

procedure TLangPlugIn.AssignProcedures;
begin
  @pdll_readFleetEventList := GetProcAddress(DllHandle, 'dll_readFleetEventList');
  @pdll_getFleetEvent      := GetProcAddress(DllHandle, 'dll_getFleetEvent');

  @pdll_doStrToStatus := GetProcAddress(DllHandle, 'dll_doStrToStatus');
  @pdll_doStatusToStr := GetProcAddress(DllHandle, 'dll_doStatusToStr');

  @pdll_startDll := GetProcAddress(DllHandle, 'dll_startDll');
  @pdll_endDll   := GetProcAddress(DllHandle, 'dll_endDll');

  @pdll_doScanToStr := GetProcAddress(DllHandle, 'dll_doScanToStr');

  @pdll_readScans := GetProcAddress(DllHandle, 'dll_readScans');
  @pdll_getScan   := GetProcAddress(DllHandle, 'dll_getScan');

  @pdll_runOptions := GetProcAddress(DllHandle, 'dll_runOptions');

  @pdll_checkUni   := GetProcAddress(DllHandle, 'dll_checkUni');

  @pdll_callFleet          := GetProcAddress(DllHandle, 'dll_callFleet');
  @pdll_callFleetExtended  := GetProcAddress(DllHandle, 'dll_callFleetExtended');
  @pdll_directCallFleet    := GetProcAddress(DllHandle, 'dll_directCallFleet');
  @pdll_openSolSys         := GetProcAddress(DllHandle, 'dll_openSolSys');

  @pdll_readSolarSystem      := GetProcAddress(DllHandle, 'dll_readSolarSystem');
  @pdll_getSolarSystemPlanet := GetProcAddress(DllHandle, 'dll_getSolarSystemPlanet');

  @pdll_readStatistics     := GetProcAddress(DllHandle, 'dll_readStatistics');
  @pdll_getStatisticEntry  := GetProcAddress(DllHandle, 'dll_getStatisticEntry');

  @pdll_ReadSource_New     := GetProcAddress(DllHandle, 'dll_ReadSource_New');
  @pdll_ReadSource_Free    := GetProcAddress(DllHandle, 'dll_ReadSource_Free');
  @pdll_ReadSource_SetText := GetProcAddress(DllHandle, 'dll_ReadSource_SetText');
  @pdll_ReadSource_SetHTML := GetProcAddress(DllHandle, 'dll_ReadSource_SetHTML');

  @pdll_testReadSource     := GetProcAddress(DllHandle, 'dll_testReadSource');
end;

function TLangPlugIn.CallFleet_(pos: TPlanetPosition; job: TFleetEventType): Boolean;
var p_pos: TPortablePlanetPosition;
begin
  if Assigned(pdll_callFleet) then
  begin
    createPortable_PlanetPosition(pos, p_pos);
    Result := pdll_callFleet(@p_pos, Integer(job))
  end
  else
    raise Exception.Create('TLangPlugIn.CallFleet(): dll does not support this feature');
end;

function TLangPlugIn.directCallFleet(pos: TPlanetPosition; job: TFleetEventType): Boolean;
var cs_light: boolean;
    p_pos: TPortablePlanetPosition;
begin
  if Assigned(pdll_directCallFleet) then
  begin
    cs_light := StrToBool(cS_getGlobalOption('main', 'cs_light', BoolToStr(true)));
    if (cs_light) and (pos.Mond) and (not isCommander) then
    begin
      // im cs_light-Modus dürfen Monde nur dann ausspioniert werden, wenn
      // man einen commander hat.
      Result := False;
      exit;
    end;

    createPortable_PlanetPosition(pos, p_pos);
    Result := pdll_directCallFleet(@p_pos, Integer(job))
  end
  else
    raise Exception.Create('TLangPlugIn.directCallFleet(): dll does not support this feature');
end;

function TLangPlugIn.CheckClipboardUni(handle: integer): Boolean;
begin
  Result := Assigned(pdll_checkUni) and
            pdll_checkUni(handle, @isCommander);
end;

procedure TLangPlugIn.CloseDll;
begin
  if DllHandle <> 0 then
  begin
    if Assigned(pdll_endDll) then pdll_endDll();
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
    utf8: boolean;

  function translate_utf8(list: TStringList): string;
  var i: integer;
  begin
    for i := 0 to list.Count-1 do
    begin
      list[i] := trnslShortStr(AnsiString(list[i]));
    end;
  end;

begin
  Result := True;
  ini := TIniFile.Create(ExpandFileName(inifile));
  utf8 := ini.ReadBool('this','utf8',false);
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
    if utf8 then
      translate_utf8(SBItems[sg]);
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
    if not(Assigned(pdll_startDll)and
       pdll_startDll(PAnsiChar(dllconfig),@V,PAnsiChar(trnsltoUTF8(ServerURL)),
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

function TLangPlugIn.GetReport(handle: integer; index: integer;
  Bericht: TScanBericht; out moon_unknown: Boolean): Boolean;
var p_scan_head: PPortableScanHead;
    p_scan_body: PPortableScanBody;
begin
  //DLL aufrufen:
  if Assigned(pdll_getScan) then
    Result := pdll_getScan(handle, index,
                  @p_scan_head,
                  @p_scan_body,
                  @moon_unknown)
  else Result := False;

  if Result then
  begin
    makeFromPortable_Scan(p_scan_head^, p_scan_body^, Bericht);
  end;
end;

function TLangPlugIn.ReadReports(handle: integer): Integer;
begin
  Result := 0;
  //Dll aufrufen:
  if Assigned(pdll_readScans) then
  begin
    Result := pdll_readScans(handle);
  end;
end;

procedure TLangPlugIn.ReadSource_Free(handle: integer);
begin
  if Assigned(pdll_ReadSource_Free) then
    pdll_ReadSource_Free(handle);
end;

function TLangPlugIn.ReadSource_New: integer;
begin
  if Assigned(pdll_ReadSource_New) then
    Result := pdll_ReadSource_New()
  else
    Result := -1;
end;

function TLangPlugIn.ReadStats(handle: integer;
  var Stat: TStat; var typ: TStatTypeEx): Boolean;
var p_stat: PPortableStatisticPageHead;
    p_entry: PPortableStatisticEntry;
    i: Integer;
begin
  if Assigned(pdll_readStatistics) and
     Assigned(pdll_getStatisticEntry) then
  begin
    Result := pdll_readStatistics(handle, @p_stat);
    if Result then
    begin
      makeFromPortable_StatisticPageHead(p_stat^, Stat, typ);

      for i := 0 to 99 do
      begin
        if (pdll_getStatisticEntry(handle, i, @p_entry)) then
        begin
          makeFromPortable_StatisticEntry(p_entry^, stat.Stats[i]);
        end;
      end;
    end;
  end
  else Result := False;
end;

function TLangPlugIn.ReadSystem(handle: integer;
  var Sys: TSystemCopy; creator: string): Boolean;
var p_solsys_head: PPortableSolarSystemHead;
    p_solsys_planet: PPortableSolarSystemPlanet;
    i: integer;
begin
  if Assigned(pdll_readSolarSystem) and
     Assigned(pdll_getSolarSystemPlanet) then
  begin
    Result := pdll_readSolarSystem(handle, @p_solsys_head);
    if Result then
    begin
      makeFromPortable_SolarSystemHead(p_solsys_head^, Sys);
      for i := 1 to length(Sys.Planeten) do
      begin
        pdll_getSolarSystemPlanet(handle, i, @p_solsys_planet);
        makeFromPortable_SolarSystemPlanet(p_solsys_planet^, sys.Planeten[i]);
      end;
      Sys.Creator := creator;
    end;
  end
  else Result := False;
end;

procedure TLangPlugIn.RunOptions;
begin
  if Assigned(pdll_runOptions) then pdll_runOptions()
  else ShowMessage('No options available');
end;

function TLangPlugIn.ScanToStr(SB: TScanBericht; AsTable: Boolean): String;
var rs_handle: Integer;
    pc: PAnsiChar;
    p_scan_head: TPortableScanHead;
    p_scan_body: TPortableScanBody;
    container: TUtf8StringContainer;
begin
  container := TUtf8StringContainer.Create;
  rs_handle := Self.ReadSource_New();
  try
    if Assigned(pdll_doScanToStr) then
    begin
      createPortable_Scan(SB, p_scan_head, p_scan_body, container);
      pc := pdll_doScanToStr(rs_handle, AsTable, @p_scan_head, @p_scan_body);
      Result := trnslShortStr(pc);
    end
    else Result := '';
  finally
    ReadSource_Free(rs_handle);
    container.Free;
  end;
end;

procedure TLangPlugIn.SetReadSourceHTML(handle: integer;
  html_utf8: AnsiString; server_time: int64);
begin
  if Assigned(pdll_ReadSource_SetHTML) then
  begin
    pdll_ReadSource_SetHTML(handle, PAnsiChar(html_utf8), server_time);
  end
  else
    raise TLangPluginNoPluginException.Create(
      'TLangPlugIn.SetReadSourceHTML: Plugin fehlerhaft, oder kein Plugin geladen!');
end;

procedure TLangPlugIn.test_ShowReadSourceContent(handle: integer);
begin
  if Assigned(pdll_testReadSource) then
  begin
    pdll_testReadSource(handle);
  end
  else
    raise TLangPluginNoPluginException.Create(
      'TLangPlugIn.test_ShowReadSourceContent: Plugin fehlerhaft, oder kein Plugin geladen!');
end;

procedure TLangPlugIn.SetReadSourceText(handle: integer;
  text_utf8: AnsiString; server_time: int64);
begin
  if Assigned(pdll_ReadSource_SetText) then
  begin
    pdll_ReadSource_SetText(handle, PAnsiChar(text_utf8), server_time);
  end
  else
    raise TLangPluginNoPluginException.Create(
      'TLangPlugIn.SetReadSourceText: Plugin fehlerhaft, oder kein Plugin geladen!');
end;

function TLangPlugIn.StatusToStr(Status: TStatus): string;
var rs_handle: Integer;
begin
  if Assigned(pdll_doStatusToStr) then
  begin
    rs_handle := Self.ReadSource_New;
    try
      Result := trnslShortStr(pdll_doStatusToStr(rs_handle, Status));
    finally
      Self.ReadSource_Free(rs_handle);
    end;
  end
  else Result := '';
end;

function TLangPlugIn.StrToStatus(s: string): TStatus;
begin
  if Assigned(pdll_doStrToStatus) then
  begin
    Result := pdll_doStrToStatus(PAnsiChar(trnslToUtf8(s)));
  end
  else Result := [];
end;

function TLangPlugIn.ReadPhalanxScan(handle: integer): TFleetsInfoSource;
var info: PPortableFleetsInfoSource;
    success: boolean;
begin
  if Assigned(pdll_readFleetEventList) then
  begin
    success := pdll_readFleetEventList(handle, @info);
    if success then
    begin
      makeFromPortable_FleetInfoSource(info^, Result);
      // if success: exit here
      Exit();
    end
  end;

  // if failed: clear result
  Result.Count := 0;
  Result.typ := fist_none;
end;

function TLangPlugIn.ReadPhalanxScanGet(const handle: integer;
  const index: integer;
  out fleet: TFleetEvent): Boolean;
var buf: pointer;
begin
  if Assigned(pdll_getFleetEvent) then
  begin
    GetMem(buf, BufFleetSize());
    try
      Result := pdll_getFleetEvent(handle, index, buf);
      fleet := ReadBufFleet(buf);
    finally
      FreeMem(buf);
    end;
  end
  else Result := false;
end;

function TLangPlugIn.OpenSolSys(pos: TSolSysPosition): Boolean;
var p_pos: TPortablePlanetPosition;
begin
  if Assigned(pdll_openSolSys) then
  begin
    p_pos[0] := pos[0];
    p_pos[1] := pos[1];
    p_pos[2] := 1;
    p_pos[3] := 0;
    Result := pdll_openSolSys(@p_pos);
  end
  else
    raise Exception.Create(
      'TLangPlugIn.OpenSolSys(): dll does not support this feature');
end;

function TLangPlugIn.CallFleetEx(fleet: TFleetEvent): Boolean;
var buf: pointer;
begin
  if Assigned(pdll_callFleetExtended) then
  begin
    GetMem(buf, BufFleetSize());
    try
      WriteBufFleet(fleet, buf);
      Result := pdll_callFleetExtended(buf);
    finally
      FreeMem(buf);
    end;
  end
  else
    raise Exception.Create(
      'TLangPlugIn.CallFleetEx(): dll does not support this feature');
end;

end.
