library fullhtml_betauni;

uses
  SysUtils,
  Classes,
  IniFiles,
  Dialogs,
  OGame_Types,
  clipbrd,
  Windows,
  LibXmlParser,
  LibXmlComps,
  FireFoxOptions in '..\de_mozilla\FireFoxOptions.pas' {FRM_FireFoxOptions},
  DateUtils,
  StrUtils,
  ReadReport_Text in '..\..\..\creatureScan\ReadAndParse\ReadReport_Text.pas',
  ReadSolsysStats_fullhtml_betauni in '..\..\..\creatureScan\ReadAndParse\ReadSolsysStats_fullhtml_betauni.pas',
  ReadPhalanxScan_fullhtml_betauni in '..\..\..\creatureScan\ReadAndParse\ReadPhalanxScan_fullhtml_betauni.pas',
  regexpname in '..\regexpr\regexpname.pas',
  RegExpr in '..\..\..\lib\TRegExpr\Source\RegExpr.pas';

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
  iopluginVersion = 16;

  RA_KeyWord_Count = 5;
  ST_KeyWord_Count = 2;
  ST_HTML_KWord_Count = 11;

var
  UserIniFile: String;
  UserIniFileSection: String;
  Uni: Integer;
  UniServer: String;
  CheckUniKeyword: String;

  SB_tsep: string;  //tousands seperator
  RA_KWords: array [0..RA_KeyWord_Count-1] of string;

  StatusItems: string;


  Sys_Options: TSys_Read_Options;
  ReportRead: TReadReport_Text;
  StatRead: ThtmlStatRead;
  SysRead: ThtmlSysRead_betauni;
  PhalanxRead: ThtmlPhalanxRead_betauni;
  Phalanx_getIndex: integer;
  
  UniCheck_Options: TUniCheck_Options;
  DisableUniCheck: Boolean; //Damit die Meldung nur einmal kommt!
  STR_DisableUniCheck_MSG: String;
  Run_Options: TRun_Options;

  //---FireFoxOptions-----------------------------------------------------------
  FFO_FoxGame_active: Boolean;

function ReadPhalanxScan(text, html: PChar): integer;
begin
  PhalanxRead.Clear;
  Phalanx_getIndex := 0;
  Result := PhalanxRead.Read(text, html);
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

function StartDll(const inifile: PChar; var Version: integer; const AUni: Integer;
  AUserIniFile, AUserIniFileSection: PChar): Boolean;
var ini: TIniFile;
    i: Integer;
    s: string;
begin
  Version := iopluginVersion;

  Uni := AUni;  

  UserIniFile := AUserIniFile;
  UserIniFileSection := AUserIniFileSection;

  ini := TIniFile.Create(ExpandFileName(inifile));

  ot_tousandsseperator := ini.ReadString('dllOptions','tsep'
    ,ot_tousandsseperator);

  StatusItems := ini.ReadString('Solar system','StatusItems','igIuns');

  UniServer := ini.ReadString('UniServer','Uni'+IntToStr(Uni),'-');
  if UniServer = '-' then
  begin
    UniServer := ini.ReadString('UniCheck','Urlformat','-n/a-');
    UniServer := Format(UniServer,[Uni]);
  end;
  //ShowMessage(UniServer);
  CheckUniKeyword := ini.ReadString('UniCheck','Keyword',' ');

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

  StatRead := ThtmlStatRead.Create(ini);
  SysRead := ThtmlSysRead_betauni.Create(ini);
  ReportRead := TReadReport_Text.Create(ini);
  PhalanxRead := ThtmlPhalanxRead_betauni.Create(ini, ReportRead);

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

function ReadScan(str: PChar; SB: pointer; var UsedChars: Integer; var AskMond: Boolean): boolean;
var s: string;
    Scan: TScanBericht;
begin
  s := str;
  UsedChars := length(s);
  Result := ReportRead.Read(s,Scan,AskMond);
  UsedChars := UsedChars - length(s);
  WriteBufScan(Scan,SB);
end;

function _StrToAuftrag(s: string; var auftrag: TRaidAuftrag): boolean;
var p, p2: integer;
    TimePos: TPlanetPosition;
    y,m,day : word;
begin
  Result := false;
  p := pos(RA_KWords[0],s);
  if p <= 0 then Exit;
  Delete(s,1,p-1);
  p := pos(RA_KWords[1],s);
  if p <= 0 then Exit;
  Delete(s,p+length(RA_KWords[1]),length(s));
  //----- eingegrezt -----------------------------------------------------------
  //----- Start ----------------------------------------------------------------
  p := pos(RA_KWords[2],s);
  if p <= 0 then Exit;
  delete(s,1,p);
  p := pos('[',s);
  if p <= 0 then Exit;
  ReadPosOrTime(s,p+1,TimePos);
  auftrag.Start := TimePos;
  auftrag.Start.Mond := False;
  //----- Start fertig ---------------------------------------------------------
  //----- Ziel -----------------------------------------------------------------
  p := pos(RA_KWords[3],s);
  if p <= 0 then Exit;
  delete(s,1,p);
  p := pos('[',s);
  if p <= 0 then Exit;
  ReadPosOrTime(s,p+1,TimePos);
  auftrag.Ziel := TimePos;
  auftrag.Ziel.Mond := False;
  //----- Ziel fertig ----------------------------------------------------------
  //----- Zeit -----------------------------------------------------------------
  p := pos(RA_KWords[4],s);
  if p <= 0 then Exit;
  p2 := p;
  repeat
    inc(p2);
  until (p2 > length(s))or(s[p2] = #13)or(s[p2] in ['0'..'9']);
  if (s[p2] in ['0'..'9']) then
  begin
    DecodeDate(now,y,m,day);
    day := ReadInt(s,p2);
    delete(s,1,p2);
    p := pos(' ',s);
    if p <= 0 then Exit;
    ReadPosOrTime(s,p+1,TimePos);
    auftrag.Zeit := EncodeDate(y,m,day) + EncodeTime(Timepos.p[0],Timepos.p[1],Timepos.p[2],0);
    Result := True;
  end;
  //----- Zeit fertig ----------------------------------------------------------
end;

function ReadRaidAuftrag(s: PChar;var Auftrag: TRaidAuftrag): Boolean;
begin
  Result := _StrToAuftrag(s,Auftrag);
end;

function DeleteHTML(S: String): String;
var p,p2: integer;
begin
  Result := '';
  repeat
    p := pos('<',S);
    if p > 0 then
    begin
      Result := Result + copy(S,1,p-1);
      repeat
        p := pos('>',S);
        p2 := pos('"',S);
        if (p2 > 0)and(p2 < p) then
        begin
          delete(S,1,p2);
          p2 := pos('"',S);
          delete(S,1,p2);
        end;
      until (p2 <= 0)or(p < p2);
      delete(S,1,p);
    end
  until (p <= 0);
  Result := Result + S;
end;

function ReadStats(const Text, Html: PChar; var Stats: TStat; var typ: TStatTypeEx): Boolean;
begin
  Result := StatRead.Read(Text,Html,Stats,typ);
end;

function _CheckUni_HTML(html: string): Boolean;
begin
  Result := (pos(CheckUniKeyword+UniServer,html) > 0);
end;

function ReadSystem(const Text, Html: PChar; var Sys_X: TSystemCopy): Boolean;
begin
  Result := SysRead.Read(text,html,Sys_X);
  {Result := False;
  SysRead.Test(text,html,Sys_X);}
end;

function CheckUni(Text, Html: PChar): Boolean;
begin
  case UniCheck_Options.CheckType of
    UnictHtml: Result := _CheckUni_HTML(Html);
    else
      //UnictNone:
      begin
        Result := False;
        If not DisableUniCheck then
        begin
          ShowMessage(STR_DisableUniCheck_MSG);
          DisableUniCheck := True;
        end;
      end;
  end;
end;

procedure _RunFireFoxOptions(ini: TIniFile; section: String);
var FRM: TFRM_FireFoxOptions;
begin
  FRM := TFRM_FireFoxOptions.Create(nil);
  FRM.CH_FoxGame.Checked := FFO_FoxGame_active;
  if FRM.ShowModal = idOK then
  begin
    FFO_FoxGame_active := FRM.CH_FoxGame.Checked;

    ini.WriteBool(section,'FFO_FoxGame_active',FFO_FoxGame_active);
    ini.UpdateFile;
  end;
  FRM.Free;
end;

procedure RunOptions;
var ini: TIniFile;
begin
  ini := TIniFile.Create(UserIniFile);
  case Run_Options.Typ of
  ro_FireFoxOptions: _RunFireFoxOptions(ini,UserIniFileSection);
  else
    ShowMessage('No options available!');
  end;
  ini.Free;
end;

exports
  StartDll,
  EndDll,
  ScanToStr,
  ReadScan,
  ReadSystem,
  ReadRaidAuftrag,
  ReadStats,
  CheckUni,
  RunOptions,
  StatusToStr,
  StrToStatus,
  ReadPhalanxScan,
  GetPhalaxScan;

begin

end.
