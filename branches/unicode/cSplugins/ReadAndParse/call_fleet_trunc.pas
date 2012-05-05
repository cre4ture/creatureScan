unit call_fleet_trunc;

interface

uses
  OGame_Types, IniFiles, SysUtils, StrUtils, ShellApi, Dialogs, Windows,
  creax_html, ReadClassFactory;

type
  TUniCheck = class(TUniCheckClassInterface)
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

    function fillVarsInLink(url: string;
      pos: TPlanetPosition; job: TFleetEventType): string;
  public
    constructor Create(ini: TIniFile; serverURL: String);
    function _CheckUni_HTML(html: string;
      html_tree: THTMLElement; var isCommander: Boolean): Boolean; override;
    function CallFleet(pos: TPlanetPosition; job: TFleetEventType): Boolean; override;
    function CallFleetEx(fleet: TFleetEvent): Boolean; override;
    function SendSpio(pos: TPlanetPosition): Boolean; override;
    function OpenSolSys(spos: TSystemPosition): Boolean; override;
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

  CallFleetLinkTemplate := ini.ReadString('UniCheck','callfleet_2','');
  SendSpioLinkTemplate := ini.ReadString('UniCheck','sendspio_2','');
  OpenSolSysLinkTemplate := ini.ReadString('UniCheck','opensolsys_2','');
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

function TUniCheck._CheckUni_HTML(html: string;
      html_tree: THTMLElement; var isCommander: Boolean): Boolean;
var menuTable, imperium: THTMLElement;
begin
  isCommander := false;
  Result := (pos(CheckUniKeyword+UniServer,html) > 0);

  if Result then
  begin
    // check for commander
    // search for menue
    menuTable := HTMLFindRoutine_NameAttribute(html_tree, 'ul', 'id', 'menuTable');
    if (menuTable <> nil) then
    begin
      // search for imperium entry
      imperium := HTMLFindRoutine_NameAttribute_Value_Within(
            html_tree, 'a', 'href', '/game/index.php?page=empire&amp');
      if imperium <> nil then
      begin
        // check for additional attribute to be sure: (may be optional)
        isCommander := pos('menubutton', imperium.AttributeValue['class']) > 0;
      end;
    end;
  end;
end;

function TUniCheck.CallFleet(pos: TPlanetPosition; job: TFleetEventType): Boolean;
var url: string;
begin
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

  url := StringReplace(url, '{mission}', JobNrs[job], [rfReplaceAll, rfIgnoreCase]);

  Result := url;
end;

function TUniCheck.SendSpio(pos: TPlanetPosition): Boolean;
var url: string;
begin

  url := fillVarsInLink(SendSpioLinkTemplate,pos,fet_espionage);
  ShellExecute(0,'open',PChar(url),'','',SW_SHOWNA);

  Result := True;
end;

function TUniCheck.OpenSolSys(spos: TSystemPosition): Boolean;
var pos: TPlanetPosition;
    url: string;
begin

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
