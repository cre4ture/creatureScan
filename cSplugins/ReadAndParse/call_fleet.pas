unit call_fleet;

interface

uses
  OGame_Types, IniFiles, SysUtils, StrUtils, ShellApi, Dialogs;

type
  TUniCheck = class
  private
    Uni: integer;
    UniServer: String;
    CheckUniKeyword: String;

    // CallFleet
    CallFleetLinkTemplate: string;
    JobNrs: array[TFleetEventType] of string;
    typ_planet, typ_mond, typ_TF: string;

    msg_daten_einlesen: string;

    fsession_id: string;
    procedure get_parse_session_ID_html(html: string);
    function getFleetLink(pos: TPlanetPosition; job: TFleetEventType): string;
  public
    property session_id: string read fsession_id write fsession_id;
    constructor Create(ini: TIniFile; aUni: integer);
    function _CheckUni_HTML(html: string): Boolean;
    function CallFleet(pos: TPlanetPosition; job: TFleetEventType): Boolean;
  end;

implementation

constructor TUniCheck.Create(ini: TIniFile; aUni: integer);
var job: TFleetEventType;
begin
  inherited Create();

  Uni := aUni;

  UniServer := ini.ReadString('UniServer','Uni'+IntToStr(Uni),'-');

  if UniServer = '-' then
  begin
    UniServer := ini.ReadString('UniCheck','Urlformat','-n/a-');
    UniServer := Format(UniServer,[Uni]);
  end;
  //ShowMessage(UniServer);

  CallFleetLinkTemplate := ini.ReadString('UniCheck','callfleet','');
  CheckUniKeyword := ini.ReadString('UniCheck','Keyword',' ');
  msg_daten_einlesen := ini.ReadString('UniCheck', 'msg_read_data', 'First, turn >>uni check<< on. Second, read data.');
  typ_planet := ini.ReadString('UniCheck','typ_planet','');
  typ_mond := ini.ReadString('UniCheck','typ_mond','');
  typ_TF := ini.ReadString('UniCheck','typ_TF','');

  for job := low(job) to high(job) do
  begin
    JobNrs[job] := ini.ReadString('UniCheck', 'job_' + FleetEventTypeToStr(job), '');
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
var p,p2,p3,pe,pet: integer;
const url_session_id = 'session=';
begin
  p := pos(CheckUniKeyword+UniServer,html);
  p2 := PosEx(url_session_id, html, p);
  p3 := PosEx(#$A, html, p);
  if (p2 > 0)and(p3 > p2) then
  begin
    pe := high(pe);
    pet := PosEx('&', html, p2);
    if (pet > 0)and(pet < pe) then pe := pet;
    pet := PosEx(' ', html, p2);
    if (pet > 0)and(pet < pe) then pe := pet;
    pet := PosEx(#$A, html, p2);
    if (pet > 0)and(pet < pe) then pe := pet;

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

  url := getFleetLink(pos,job);
  ShellExecute(0,'open',PChar(url),'','',0);
  
  Result := True;
end;

function TUniCheck.getFleetLink(pos: TPlanetPosition; job: TFleetEventType): string;
var url: string;
begin
  url := CallFleetLinkTemplate;
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

end.