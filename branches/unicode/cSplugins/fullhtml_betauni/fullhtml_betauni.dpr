library fullhtml_betauni;

uses
  SysUtils,
  Classes,
  IniFiles,
  Dialogs,
  OGame_Types in '..\..\OGame_Types.pas',
  clipbrd,
  Windows,
  LibXmlParser,
  LibXmlComps,
  DateUtils,
  StrUtils,
  ReadPhalanxScan_fullhtml_betauni in '..\ReadAndParse\ReadPhalanxScan_fullhtml_betauni.pas',
  ReadReport_Text in '..\ReadAndParse\ReadReport_Text.pas',
  ReadSolsysStats_fullhtml_betauni in '..\ReadAndParse\ReadSolsysStats_fullhtml_betauni.pas',
  readsource in '..\readsource.pas',
  call_fleet in '..\ReadAndParse\call_fleet.pas',
  readsource_cs in '..\readsource_cs.pas',
  creaturesStrUtils in '..\..\..\lib\uli\creaturesStrUtils.pas',
  cS_memstream in '..\..\cS_memstream.pas',
  creax_html in '..\..\..\lib\uli\htmllib\creax_html.pas',
  cpp_dll_interface in '..\..\..\lib\uli\htmllib\cpp_dll_interface.pas',
  TIReadPlugin_Types in '..\..\ReadPlugins\TIReadPlugin_Types.pas',
  TIReadPlugin_Types_conv in '..\..\ReadPlugins\TIReadPlugin_Types_conv.pas';

type
  TScanReadOptions = record
    
  end;
  TSys_Read_Options = record
    ReadType: (sysrtTabs, sysrtTltip, sysrtHtml);
  end;
  TUniCheck_Options = record
    CheckType: (UnictNone, UnictHtml);
  end;
  TRun_Options = record
    Typ: (ro_None, ro_FireFoxOptions);
  end;


const
  iopluginVersion = 100;

  RA_KeyWord_Count = 5;
  ST_KeyWord_Count = 2;
  ST_HTML_KWord_Count = 11;

var
  UserIniFile: String;
  UserIniFileSection: String;
  serverURL: String;

  SB_tsep: string;  //tousands seperator
  RA_KWords: array [0..RA_KeyWord_Count-1] of string;

  StatusItems: string;

  Sys_Options: TSys_Read_Options;
  ReportRead: TReadReport_Text;
  StatRead: ThtmlStatRead_betauni;
  SysRead: ThtmlSysRead_betauni;
  PhalanxRead: ThtmlPhalanxRead_betauni;

  UniCheck: TUniCheck;

  UniCheck_Options: TUniCheck_Options;
  DisableUniCheck: Boolean; //Damit die Meldung nur einmal kommt!
  STR_DisableUniCheck_MSG: String;
  Run_Options: TRun_Options;

  //---FireFoxOptions-----------------------------------------------------------
  FFO_FoxGame_active: Boolean;

function _get_RS(const Handle: integer; var rs: TReadSource_cS): Boolean;
begin
  rs := TReadSource_cS(GetReadSource(Handle));
  Result := rs <> nil;
end;

function dll_readFleetEventList(rs_handle: integer;
  info: PPPortableFleetsInfoSource): Boolean; stdcall;
var rs: TReadSource_cS;
    internal: TFleetsInfoSource;
begin
  Result := false;
  if not _get_RS(rs_handle, rs) then Exit;

  PhalanxRead.Clear;
  internal := PhalanxRead.ReadFromRS(rs);

  Result := (internal.count > 0);
  if (Result) then
  begin
    createPortable_FleetInfoSource(internal, rs.portableFleetInfoSource);
    info^ := @rs.portableFleetInfoSource;
  end;
end;

function dll_getFleetEvent(rs_handle: integer;
  index: integer; fleet: pointer): Boolean; stdcall;
var rs: TReadSource_cS;
    tmp: TFleetEvent;
begin
  Result := false;
  if not _get_RS(rs_handle, rs) then Exit;
  
  Result := (index < PhalanxRead.Count);
  if Result then
  begin
    tmp := PhalanxRead.FleetList[index];
    WriteBufFleet(tmp, fleet);
  end;
end;

function dll_doStatusToStr(rs_handle: integer; Status: TStatus): PAnsiChar; stdcall;
var rs: TReadSource_cS;
    st: TStati;
begin
  Result := nil;
  if not _get_RS(rs_handle, rs) then Exit;

  rs.status_buffer := '';
  for st := low(st) to high(st) do
    if (st in Status)and(word(st) < length(StatusItems)) then
      rs.status_buffer := rs.status_buffer + StatusItems[word(st)+1];

  Result := PAnsiChar(rs.status_buffer);
end;

function dll_doStrToStatus(input_s: PAnsiChar): TStatus; stdcall;
var i, p: integer;
    s: AnsiString;
begin
  s := input_s;
  Result := [];
  for i := 1 to length(s) do
  begin
    p := pos(s[i],StatusItems)-1;
    if (p >= low(TStati))and(p <= high(TStati)) then
      Result := Result + [p];
  end;
end;


procedure _LoadFireFoxOptions(ini: TInifile; section: String);
begin
  FFO_FoxGame_active := ini.ReadBool(section,'FFO_FoxGame_active',False);
end;

procedure _LoadOptions;
var ini: TIniFile;
begin
  ini := TIniFile.Create(UserIniFile);
  case Run_Options.Typ of
  ro_FireFoxOptions: _LoadFireFoxOptions(ini,UserIniFileSection);
  end;
  ini.Free;
end;

function dll_startDll(const inifile: PAnsiChar;
  pVersion: PInteger;
  const uniDomain: PAnsiChar;
  const AUserIniFile: PAnsiChar;
  const AUserIniFileSection: PAnsiChar): Boolean; stdcall;
var ini: TIniFile;
    i: Integer;
    s: string;
begin
  pVersion^ := iopluginVersion;

  serverURL := uniDomain;

  UserIniFile := AUserIniFile;
  UserIniFileSection := AUserIniFileSection;

  ini := TIniFile.Create(ExpandFileName(inifile));

  ot_tousandsseperator := ini.ReadString('dllOptions','tsep'
    ,ot_tousandsseperator);

  StatusItems := ini.ReadString('Solar system','StatusItems','igIuns');

//---Sys_Options----------------------------------------------------------------
  s := ini.ReadString('dllOptions','Sys_Read_Options_ReadType','Tabs');
  if s = 'Tltip' then Sys_Options.ReadType := sysrtTltip
  else if s = 'Html' then Sys_Options.ReadType := sysrtHtml else Sys_Options.ReadType := sysrtTabs;
//---UniCheck_Options-----------------------------------------------------------
  DisableUniCheck := False;
  STR_DisableUniCheck_MSG := ini.ReadString('UniCheck','DisableMSG','Disable UniCheck!');
  s := ini.ReadString('dllOptions','UniCheck_options_CheckType','None');
  if s = 'Html' then UniCheck_Options.CheckType := UnictHtml else UniCheck_Options.CheckType := UnictNone;
//---Run_Options----------------------------------------------------------------
  Run_Options.Typ := ro_None;
  s := ini.ReadString('dllOptions','Run_Options','None');
  if s = 'FireFoxOptions' Then Run_Options.Typ := ro_FireFoxOptions;

  _LoadOptions;

  SB_tsep := ini.ReadString('Espionage report','tsep','');

  StatRead := ThtmlStatRead_betauni.Create(ini);
  SysRead := ThtmlSysRead_betauni.Create(ini);
  ReportRead := TReadReport_Text.Create(ini);
  PhalanxRead := ThtmlPhalanxRead_betauni.Create(ini, ReportRead);
  UniCheck := TUniCheck.Create(ini, serverURL);

  for i := 1 to RA_KeyWord_Count do
  begin
    RA_KWords[i-1] := {TrimStringChar(}ini.ReadString('Raidstart','Z'+inttostr(i),'---n/a---'){,'"')};
  end;

  ini.free;
  Result := True;
end;

function dll_endDll: boolean; stdcall;
begin
  StatRead.Free;
  SysRead.Free;
  ReportRead.Free;
  PhalanxRead.Free;
  UniCheck.Free;

  Result := True;
end;

function dll_doScanToStr(rs_handle: integer;
  asTable: Boolean;
  p_scan_head: PPortableScanHead;
  p_scan_body: PPortableScanBody): PAnsiChar; stdcall;
  
var Scan: TScanBericht;
    rs: TReadSource_cS;
begin
  Result := nil;
  if not _get_RS(rs_handle, rs) then Exit;
  
  Scan := TScanBericht.Create;
  try
    makeFromPortable_Scan(p_scan_head^, p_scan_body^, Scan);
    rs.scanstr_buffer := ReportRead.ReportToString(Scan, AsTable);
    Result := PAnsiChar(rs.scanstr_buffer);
  except
    Result := nil;
  end;
  scan.Free;
end;

function dll_readScans(rs_handle: Integer): integer; stdcall;
var rs: TReadSource_cS;
begin
  Result := -1;
  if not _get_RS(rs_handle, rs) then Exit;

  rs.readscanlist.clear;
  if (rs.GetHTMLString <> '') then
    Result := ReportRead.ReadHTML(rs.GetHTMLRoot, rs.readscanlist)
  else
    Result := ReportRead.Read(rs.GetText(), rs.readscanlist);
end;

function dll_getScan(
  rs_handle: integer;
  scan_index: integer;
  p_scan_head: PPPortableScanHead;
  p_scan_body: PPPortableScanBody;
  askMoon: PBoolean): Boolean; stdcall;

var rs: TReadSource_cS;
begin
  Result := false;
  if not _get_RS(rs_handle, rs) then Exit;
  try
    Result := (scan_index >= 0) and (scan_index < rs.readscanlist.Count);
    if Result then
    begin
      createPortable_Scan(rs.readscanlist.reports[scan_index],
                          rs.portableScanHead, rs.portableScanBody);

      p_scan_head^ := @rs.portableScanHead;
      p_scan_body^ := @rs.portableScanBody;
      askMoon^ := rs.readscanlist.reports[scan_index].AskMoon;
    end;
  except
    result := false;
  end;
end;

function dll_readStatistics(rs_handle: Integer;
  p_stats: PPPortableStatisticPageHead): Boolean; stdcall;
var rs: TReadSource_cS;
    typ: TStatTypeEx;
begin
  Result := False;
  if not _get_RS(rs_handle, rs) then Exit;

  Result := StatRead.ReadFromRS(rs,rs.stats,typ);

  if Result then
  begin
    createPortable_StatisticPageHead(rs.stats, typ, rs.portableStatsHead);
    p_stats^ := @(rs.portableStatsHead);
  end;
end;

function dll_getStatisticEntry(rs_handle: Integer;
  index: integer;
  p_stat_entry: PPPortableStatisticEntry): Boolean; stdcall;
var rs: TReadSource_cS;
begin
  Result := False;
  if not _get_RS(rs_handle, rs) then Exit;

  Result := (index >= 0) and (index < rs.stats.count);
  if Result then
  begin
    createPortable_StatisticEntry(rs.stats.Stats[index], rs.portableStatsEntry);
    p_stat_entry^ := @(rs.portableStatsEntry);
  end;
end;

function dll_readSolarSystem(rs_handle: integer;
  p_sys_head: PPPortableSolarSystemHead): Boolean; stdcall;
var rs: TReadSource_cS;
begin
  Result := False;
  if not _get_RS(rs_handle, rs) then Exit;

  Result := SysRead.ReadFromRS(rs, rs.solsys);
  if (Result) then
  begin
    createPortable_SolarSystemHead(rs.solsys, rs.portableSolSysHead);
    p_sys_head^ := @(rs.portableSolSysHead);
  end;
end;

function dll_getSolarSystemPlanet(rs_handle: integer;
  index: integer;
  p_sys_planet: PPPortableSolarSystemPlanet): Boolean; stdcall;

var rs: TReadSource_cS;
begin
  Result := False;
  if not _get_RS(rs_handle, rs) then Exit;

  Result := (index >= 1) and (index <= max_Planeten);
  if (Result) then
  begin
    createPortable_SolarSystemPlanet(
          rs.solsys.Planeten[index], rs.portableSolSysPlanet);
    p_sys_planet^ := @(rs.portableSolSysPlanet);
  end;
end;

function dll_checkUni(rs_handle: Integer;
  isCommander: PBoolean): Boolean; stdcall;
var rs: TReadSource_cS;
begin
  Result := False;
  if not _get_RS(rs_handle,rs) then Exit;

  case UniCheck_Options.CheckType of
    UnictHtml: Result := UniCheck._CheckUni_HTML(rs.GetHTMLString,
                            rs.GetHTMLRoot, isCommander^);

    else
      //UnictNone:
      begin
        If not DisableUniCheck then
        begin
          ShowMessage(STR_DisableUniCheck_MSG);
          DisableUniCheck := True;
        end;
      end;
  end;
end;

function dll_callFleet(pos: PPortablePlanetPosition;
  job: Integer): Boolean; stdcall;
var i_pos: TPlanetPosition;
    i_job: TFleetEventType;
begin
  i_job := TFleetEventType(job);
  makeFromPortable_PlanetPosition(pos^, i_pos);
  Result := UniCheck.CallFleet(i_pos, i_job);
end;

function dll_callFleetExtended(fleet: pointer): Boolean; stdcall;
var afleet: TFleetEvent;
begin
  if (fleet <> nil) then
  begin
    afleet := ReadBufFleet(fleet);
    Result := UniCheck.CallFleetEx(afleet);
  end
  else
    Result := False;
end;

function dll_directCallFleet(pos: PPortablePlanetPosition;
  job: Integer): Boolean; stdcall;
var i_pos: TPlanetPosition;
    i_job: TFleetEventType;
begin
  i_job := TFleetEventType(job);
  makeFromPortable_PlanetPosition(pos^, i_pos);
  if i_job = fet_espionage then
    Result := UniCheck.SendSpio(i_pos)
  else
    Result := false;
end;

function dll_openSolSys(pos: PPortablePlanetPosition): Boolean; stdcall;
var i_pos: TPlanetPosition;
    spos: TSolSysPosition;
begin
  makeFromPortable_PlanetPosition(pos^, i_pos);
  spos[0] := i_pos.P[0];
  spos[1] := i_pos.P[1];
  Result := UniCheck.OpenSolSys(spos);
end;

procedure dll_runOptions; stdcall;
var ini: TIniFile;
begin
  ini := TIniFile.Create(UserIniFile);
  ShowMessage('No options available!');
  ini.Free;
end;

function dll_ReadSource_New: integer; stdcall;
begin
  Result := CreateAReadSource(TReadSource_cS);
end;

procedure dll_ReadSource_Free(rs_handle: Integer); stdcall;
begin
  FreeAReadSource(rs_handle);
end;

function dll_ReadSource_SetText(rs_handle: Integer;
  text: PAnsiChar; server_time_u: int64): Boolean; stdcall;
var rs: TReadSource;
begin
  rs := GetReadSource(rs_handle);
  Result := rs <> nil;
  if Result then
  begin
    rs.SetTextSource(text);
    rs.SetServerTime(server_time_u);
  end;
end;

function dll_ReadSource_SetHTML(rs_handle: Integer;
  html: PAnsiChar; server_time_u: int64): Boolean; stdcall;
var rs: TReadSource;
begin
  rs := GetReadSource(rs_handle);
  Result := rs <> nil;
  if Result then
  begin
    rs.SetHTMLSource(html);
    rs.SetServerTime(server_time_u);
  end;
end;

procedure dll_testReadSource(rs_handle: Integer); stdcall;
var rs: TReadSource_cS;
begin
  rs := TReadSource_cS(GetReadSource(rs_handle));
  if (rs <> nil) then
  begin
    ShowMessage('Text: ' + rs.GetText);
    ShowMessage('HTML: ' + rs.GetHTMLString);
  end
  else
  begin
    ShowMessage('Error: Handle invalid!');
  end;
end;

exports
  dll_startDll,
  dll_endDll,

  dll_doScanToStr,

  dll_readScans,
  dll_getScan,

  dll_readSolarSystem,
  dll_getSolarSystemPlanet,

  dll_readStatistics,
  dll_getStatisticEntry,
  
  dll_checkUni,
  dll_runOptions,
  dll_doStatusToStr,
  dll_doStrToStatus,
  dll_readFleetEventList,
  dll_getFleetEvent,
  dll_callFleet,
  dll_callFleetExtended,
  dll_directCallFleet,
  dll_openSolSys,

  dll_ReadSource_New,
  dll_ReadSource_Free,
  dll_ReadSource_SetText,
  dll_ReadSource_SetHTML,

  dll_testReadSource;

begin

end.