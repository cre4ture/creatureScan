unit ReadClassFactory;

interface

uses readsource_cs, readsource, OGame_Types, inifiles, creax_html;

type
  TStatsReadClassInterface = class
  public
    function ReadFromRS(rs: TReadSource; var Stats: TStat;
      var Typ: TStatTypeEx): Boolean; virtual; abstract;
  end;

  TSolsysReadClassInterface = class
  public
    function ReadFromRS(rs: TReadSource;
      var solsys: TSystemCopy): Boolean; virtual; abstract;
  end;

  TUniCheckClassInterface = class
  private
  public
    function _CheckUni_HTML(html: string;
      html_tree: THTMLElement; var isCommander: Boolean): Boolean; virtual; abstract;
    function CallFleet(pos: TPlanetPosition; job: TFleetEventType): Boolean; virtual; abstract;
    function CallFleetEx(fleet: TFleetEvent): Boolean; virtual; abstract;
    function SendSpio(pos: TPlanetPosition): Boolean; virtual; abstract;
    function OpenSolSys(spos: TSystemPosition): Boolean; virtual; abstract;
  end;

  TReadClassFactory = class
  private
    fStatsRead: TStatsReadClassInterface;
    fStatsReadVersion: TOGameVersion;

    fSolsysRead: TSolsysReadClassInterface;
    fSolsysReadVersion: TOGameVersion;

    fUniCheck: TUniCheckClassInterface;
    fUniCheckVersion: TOGameVersion;

    fini: TIniFile;

  public
    function getStatsReadClass(version: TOGameVersion): TStatsReadClassInterface;
    function getSolsysReadClass(version: TOGameVersion): TSolsysReadClassInterface;
    function getUniCheckClass(version: TOGameVersion; serverURL: string): TUniCheckClassInterface;
    constructor Create(ini: TIniFile);
    destructor Destroy; override;
  end;

implementation

uses ReadSolsysStats_fullhtml_2x, ReadStats_fullhtml_trunc,
     ReadSolsys_fullhtml_trunc, ReadSolsys_fullhtml_3x, 
     SysUtils,
     call_fleet_2x, call_fleet_trunc;

{ TReadClassFactory }

constructor TReadClassFactory.Create(ini: TIniFile);
begin
  inherited Create;
  fini := ini;
  fStatsRead := nil;
  fUniCheck := nil;
  fStatsReadVersion := ogv_not_initialised;
  fUniCheckVersion := ogv_not_initialised;
end;

destructor TReadClassFactory.Destroy;
begin
  if fStatsReadVersion <> ogv_not_initialised then
  begin
    fStatsRead.Free;
  end;
  inherited;
end;

function TReadClassFactory.getSolsysReadClass(
  version: TOGameVersion): TSolsysReadClassInterface;
begin
  // select version
  case version of
  ogv_2xx: version := ogv_3xx;
  ogv_3xx: version := ogv_3xx;
  ogv_4xx: version := ogv_4xx;
  else
    version := high(TOGameVersion);
  end;

  // check version
  if version <> fSolsysReadVersion then
  begin
    // delete old instance
    if fSolsysReadVersion <> ogv_not_initialised then
      fSolsysRead.Free;

    // create new instance for selected version
    case version of
    ogv_3xx: fSolsysRead := ReadSolsys_fullhtml_3x.ThtmlSysRead_3x.Create(fini);
    ogv_4xx: fSolsysRead := ReadSolsys_fullhtml_trunc.ThtmlSysRead.Create(fini);
    else
      raise Exception.Create('TReadClassFactory.getSolsysReadClass: internal error');
    end;
    // rember which version was created
    fSolsysReadVersion := version;
  end;

  // return stats read instance
  Result := fSolsysRead;
end;

function TReadClassFactory.getStatsReadClass(
  version: TOGameVersion): TStatsReadClassInterface;
begin
  // select version
  case version of
  ogv_2xx: version := ogv_2xx;
  ogv_3xx: version := ogv_3xx;
  else
    version := high(TOGameVersion);
  end;

  // check version
  if version <> fStatsReadVersion then
  begin
    // delete old instance
    if fStatsReadVersion <> ogv_not_initialised then
      fStatsRead.Free;

    // create new instance for selected version
    case version of
    ogv_2xx: fStatsRead := ReadSolsysStats_fullhtml_2x.ThtmlStatRead_betauni.Create(fini);
    ogv_3xx: fStatsRead := ReadStats_fullhtml_trunc.ThtmlStatRead.Create(fini);
    else
      raise Exception.Create('TReadClassFactory.getStatsReadClass: internal error');
    end;
    // rember which version was created
    fStatsReadVersion := version;
  end;

  // return stats read instance
  Result := fStatsRead;
end;

function TReadClassFactory.getUniCheckClass(
  version: TOGameVersion; serverURL: string): TUniCheckClassInterface;
begin
  // select version
  case version of
  ogv_2xx: version := ogv_2xx;
  ogv_3xx: version := ogv_3xx;
  else
    // per default we use the latest detected version!
    if (fUniCheckVersion = ogv_not_initialised) then
      version := high(version)
    else
      version := fUniCheckVersion;
  end;

  // check version
  if version <> fUniCheckVersion then
  begin
    // delete old instance
    if fUniCheckVersion <> ogv_not_initialised then
      fUniCheck.Free;

    // create new instance for selected version
    case version of
    ogv_2xx: fUniCheck := call_fleet_2x.TUniCheck.Create(fini, serverURL);
    ogv_3xx: fUniCheck := call_fleet_trunc.TUniCheck.Create(fini, serverURL);
    else
      raise Exception.Create('TReadClassFactory.getUniCheckClass: internal error');
    end;
    // rember which version was created
    fUniCheckVersion := version;
  end;

  // return stats read instance
  Result := fUniCheck;
end;

end.
