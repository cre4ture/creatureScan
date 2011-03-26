unit call_fleet;

interface

uses
  OGame_Types, IniFiles, SysUtils, StrUtils, ShellApi, Dialogs, Windows;

type
  TUniCheck = class
  private
    UniServer: String;
    CheckUniKeyword: String;

    // CallFleet
    CallFleetLinkTemplate: string;
    SendSpioLinkTemplate: string;
    OpenSolSysLinkTemplate: string;
    JobNrs: array[TFleetEventType] of string;
    typ_planet, typ_mond, typ_TF: string;

    msg_daten_einlesen: string;

    fsession_id: string;
    procedure get_parse_session_ID_html(html: string);
    function fillVarsInLink(url: string;
      pos: TPlanetPosition; job: TFleetEventType): string;
  public
    property session_id: string read fsession_id write fsession_id;
    constructor Create(ini: TIniFile; serverURL: String);
    function _CheckUni_HTML(html: string): Boolean;
    function CallFleet(pos: TPlanetPosition; job: TFleetEventType): Boolean;
    function CallFleetEx(fleet: TFleetEvent): Boolean;
    function SendSpio(pos: TPlanetPosition): Boolean;
    function OpenSolSys(spos: TSystemPosition): Boolean;
  end;

implementation

constructor TUniCheck.Create(ini: TIniFile; serverURL: String);
var job: TFleetEventType;
begin
  inherited Create();
  
  //UniServer := ini.ReadString('UniServer','Uni'+IntToStr(Uni),'-');
  UniServer := 'http://' + serverURL;

  {if UniServer = '-' then
  begin
    UniServer := ini.ReadString('UniCheck','Urlformat','-n/a-');
    UniServer := Format(UniServer,[Uni]);
  end;    }
  //ShowMessage(UniServer);

  CallFleetLinkTemplate := ini.ReadString('UniCheck','callfleet','');
  SendSpioLinkTemplate := ini.ReadString('UniCheck','sendspio','');
  OpenSolSysLinkTemplate := ini.ReadString('UniCheck','opensolsys','');
  CheckUniKeyword := ini.ReadString('UniCheck','Keyword','<<<empty>>>');
  msg_daten_einlesen := ini.ReadString('UniCheck', 'msg_read_data', 'First, turn >>uni check<< on. Second, read data.');
  typ_planet := ini.ReadString('UniCheck','typ_planet','');
  typ_mond := ini.ReadString('UniCheck','typ_mond','');
  typ_TF := ini.ReadString('UniCheck','typ_TF','');

  for job := low(job) to high(job) do
  begin
    JobNrs[job] := ini.ReadString('UniCheck', 'job_' + FleetEventTypeToNameStr(job), '');
  end;
end;

function TUniCheck._CheckUni_HTML(html: string): Boolean;
begin
  Result := (pos(CheckUniKeyword+UniServer,html) > 0);

  if Result then
  begin
    get_parse_session_ID_html(html);
  end;
end;

procedure TUniCheck.get_parse_session_ID_html(html: string);
var p,p2,p3,pe,pet,i: integer;
const url_session_id = 'session=';
      term_chars: string = '& #'; // alle zeichen die der ID folgen können
begin
  p := pos(CheckUniKeyword+UniServer,html);
  p2 := PosEx(url_session_id, html, p);
  p3 := PosEx(#$A, html, p); // new line
  if (p2 > 0)and(p3 > p2) then
  begin
    pe := p3; // ende

    for i := 1 to length(term_chars) do // string!!! 1 start index
    begin
      pet := PosEx(term_chars[i], html, p2);
      if (pet > 0)and(pet < pe) then pe := pet;
    end;

    if pe > 0 then
    begin
      p2 := p2+length(url_session_id);
      session_id := Trim(copy(html,p2,pe-p2));
    end;
  end;
end;

function TUniCheck.CallFleet(pos: TPlanetPosition; job: TFleetEventType): Boolean;
var url: string;
begin
  Result := False;
  if session_id = '' then
  begin
    ShowMessage(msg_daten_einlesen);
    Exit;
  end;

  url := fillVarsInLink(CallFleetLinkTemplate,pos,job);
  ShellExecute(0,'open',PChar(url),'','',0);

  Result := True;
end;

function TUniCheck.fillVarsInLink(url: string;
  pos: TPlanetPosition; job: TFleetEventType): string;
begin
  url := StringReplace(url, '{server}', UniServer, [rfReplaceAll, rfIgnoreCase]);

  url := StringReplace(url, '{galaxy}', IntToStr(pos.P[0]), [rfReplaceAll, rfIgnoreCase]);
  url := StringReplace(url, '{system}', IntToStr(pos.P[1]), [rfReplaceAll, rfIgnoreCase]);
  url := StringReplace(url, '{position}', IntToStr(pos.P[2]), [rfReplaceAll, rfIgnoreCase]);
  if pos.Mond then
    url := StringReplace(url, '{type}', typ_mond, [rfReplaceAll, rfIgnoreCase])
  else
    url := StringReplace(url, '{type}', typ_planet, [rfReplaceAll, rfIgnoreCase]);

  url := StringReplace(url, '{session}', session_id, [rfReplaceAll, rfIgnoreCase]);

  url := StringReplace(url, '{mission}', JobNrs[job], [rfReplaceAll, rfIgnoreCase]);

  Result := url;
end;

function TUniCheck.SendSpio(pos: TPlanetPosition): Boolean;
var url: string;
begin
  Result := False;
  if session_id = '' then
  begin
    ShowMessage(msg_daten_einlesen);
    Exit;
  end;

  url := fillVarsInLink(SendSpioLinkTemplate,pos,fet_espionage);
  ShellExecute(0,'open',PChar(url),'','',SW_SHOWNA);

  Result := True;
end;

function TUniCheck.OpenSolSys(spos: TSystemPosition): Boolean;
var pos: TPlanetPosition;
    url: string;
begin
  Result := false;
  if session_id = '' then
  begin
    ShowMessage(msg_daten_einlesen);
    Exit;
  end;

  pos.P[0] := spos[0];
  pos.P[1] := spos[1];
  pos.P[2] := 1;
  pos.Mond := false;

  url := fillVarsInLink(OpenSolSysLinkTemplate,pos,fet_espionage);
  ShellExecute(0,'open',PChar(url),'','',0);

  Result := true;
end;

function TUniCheck.CallFleetEx(fleet: TFleetEvent): Boolean;
var url: string;

  procedure param(pname, pvalue: string); overload;
  begin
    url := url + '&' + pname + '=' + pvalue;
  end;

  procedure param(pname: string; pvalue: int64); overload;
  begin
    if pvalue = -1 then
      param(pname, 'undefined')
    else
      param(pname, IntToStr(pvalue));
  end;

var i: integer;
begin
  Result := False;
  if session_id = '' then
  begin
    ShowMessage(msg_daten_einlesen);
    Exit;
  end;

  url := fillVarsInLink(CallFleetLinkTemplate,fleet.head.target,
    fleet.head.eventtype);

  for i := 0 to fsc_1_Flotten-1 do
  begin
    param('am' + IntToStr(202+i),
      fleet.ships[i]);
  end;

  ShellExecute(0,'open',PChar(url),'','',0);

  Result := True;
end;

end.
