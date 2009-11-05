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
  readsource_cs in '..\readsource_cs.pas';

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
  iopluginVersion = 23;

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
  Phalanx_getIndex: integer;

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

function ReadPhalanxScan(Handle: integer): TFleetsInfoSource;
var rs: TReadSource_cS;
begin
  Result.count := 0;
  Result.typ := fist_none;
  if not _get_RS(Handle, rs) then Exit;

  PhalanxRead.Clear;
  Phalanx_getIndex := 0;
  Result := PhalanxRead.ReadFromRS(rs);
end;

function GetPhalaxScan(fleet: Pointer): Boolean;
var tmp: TFleetEvent;
begin
  Result := (Phalanx_getIndex < PhalanxRead.Count);
  if Result then
  begin
    tmp := PhalanxRead.FleetList[Phalanx_getIndex];
    WriteBufFleet(tmp, fleet);
    inc(Phalanx_getIndex);
  end;
end;

function StatusToStr(Status: TStatus): ShortString;
var st: TStati;
begin
  Result := '';
  for st := low(st) to high(st) do
    if (st in Status)and(word(st) < length(StatusItems)) then
      Result := Result + StatusItems[word(st)+1];
end;

function StrToStatus(s: ShortString): TStatus;
var i, p: integer;
begin
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

procedure LoadOptions;
var ini: TIniFile;
begin
  ini := TIniFile.Create(UserIniFile);
  case Run_Options.Typ of
  ro_FireFoxOptions: _LoadFireFoxOptions(ini,UserIniFileSection);
  end;
  ini.Free;
end;

function StartDll(const inifile: PChar;
  var Version: integer;
  const uniDomain: PChar;
  const AUserIniFile: PChar;
  const AUserIniFileSection: PChar): Boolean;
var ini: TIniFile;
    i: Integer;
    s: string;
begin
  Version := iopluginVersion;

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

  LoadOptions;

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

function EndDll: boolean;
begin
  StatRead.Free;
  SysRead.Free;
  ReportRead.Free;
  PhalanxRead.Free;
  UniCheck.Free;

  Result := True;
end;

function ScanToStr(SB: Pointer; AsTable: Boolean): THandle;
var Scan: TScanBericht;
    s: string;
begin
  Scan := ReadBufScan(SB);

  s := ReportRead.ReportToString(Scan, AsTable) + #0;

  Result := GlobalAlloc(GMEM_MOVEABLE,length(s));
  CopyMemory(GlobalLock(Result),PChar(s),length(s));
  GlobalUnlock(Result);
end;

function ReadScans(Handle: Integer): integer;
var rs: TReadSource_cS;
begin
  Result := -1;
  if not _get_RS(Handle, rs) then Exit;

  rs.readscanlist := ReportRead.Read(rs.GetText());
  rs.rsl_index := 0;
  Result := Length(rs.readscanlist);
end;

function GetScan(Handle: integer; Scan: Pointer; var AskMoon: Boolean): Boolean;
var rs: TReadSource_cS;
begin
  Result := false;
  if not _get_RS(Handle, rs) then Exit;

  with rs do
  begin
    Result := rsl_index < length(readscanlist);
    if Result then
    begin
      WriteBufScan(readscanlist[rsl_index].Report, Scan);
      AskMoon := readscanlist[rsl_index].AskMoon;
    end;

    inc(rsl_index);
  end;
end;

function ReadRaidAuftrag(s: PChar;var Auftrag: TRaidAuftrag): Boolean;
begin
  Result := false;
end;

function ReadStats(Handle: Integer; var Stats: TStat; var typ: TStatTypeEx): Boolean;
var rs: TReadSource_cS;
begin
  Result := False;
  if not _get_RS(Handle, rs) then Exit;

  Result := StatRead.ReadFromRS(rs,Stats,typ);
end;

function ReadSystem(Handle: integer; var Sys_X: TSystemCopy): Boolean;
var rs: TReadSource_cS;
begin
  Result := False;
  if not _get_RS(Handle, rs) then Exit;

  Result := SysRead.ReadFromRS(rs, Sys_X);
end;

function CheckUni(Handle: Integer): Boolean;
var rs: TReadSource_cS;
begin
  Result := False;
  if not _get_RS(Handle,rs) then Exit;

  case UniCheck_Options.CheckType of
    UnictHtml: Result := UniCheck._CheckUni_HTML(rs.GetHTMLString);

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

function CallFleet(pos: TPlanetPosition; job: TFleetEventType): Boolean;
begin
  Result := UniCheck.CallFleet(pos, job);
end;

procedure RunOptions;
var ini: TIniFile;
begin
  ini := TIniFile.Create(UserIniFile);

    ShowMessage('No options available!');

  ini.Free;
end;

function ReadSource_New: integer;
begin
  Result := CreateAReadSource(TReadSource_cS);
end;

procedure ReadSource_Free(Handle: Integer);
begin
  FreeAReadSource(Handle);
end;

function ReadSource_SetText(Handle: Integer; text: PChar; server_time_u: int64): Boolean;
var rs: TReadSource;
begin
  rs := GetReadSource(Handle);
  Result := rs <> nil;
  if Result then
  begin
    rs.SetTextSource(text);
    rs.SetServerTime(server_time_u);
  end;
end;

function ReadSource_SetHTML(Handle: Integer; html: PChar; server_time_u: int64): Boolean;
var rs: TReadSource;
begin
  rs := GetReadSource(Handle);
  Result := rs <> nil;
  if Result then
  begin
    rs.SetHTMLSource(html);
    rs.SetServerTime(server_time_u);
  end;
end;

exports
  StartDll,
  EndDll,
  ScanToStr,
  ReadScans,
  GetScan,
  ReadSystem,
  ReadRaidAuftrag,
  ReadStats,
  CheckUni,
  RunOptions,
  StatusToStr,
  StrToStatus,
  ReadPhalanxScan,
  GetPhalaxScan,
  CallFleet,

  ReadSource_New,
  ReadSource_Free,
  ReadSource_SetText,
  ReadSource_SetHTML;

begin

end.
