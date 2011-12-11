unit ReadClassFactory;

interface

uses readsource_cs, readsource, OGame_Types, inifiles;

type
  TStatsReadClassInterface = class
  public
    function ReadFromRS(rs: TReadSource; var Stats: TStat;
      var Typ: TStatTypeEx): Boolean; virtual; abstract;
  end;

  TReadClassFactory = class
  private
    fStatsRead: TStatsReadClassInterface;
    fStatsReadVersion: TOGameVersion;

    fini: TIniFile;

  public
    function getStatsReadClass(version: TOGameVersion): TStatsReadClassInterface;
    constructor Create(ini: TIniFile);
    destructor Destroy;
  end;

implementation

uses ReadSolsysStats_fullhtml_2x, ReadStats_fullhtml_trunc, SysUtils;

{ TReadClassFactory }

constructor TReadClassFactory.Create(ini: TIniFile);
begin
  inherited Create;
  fini := ini;
  fStatsRead := nil;
  fStatsReadVersion := ogv_not_initialised;
end;

destructor TReadClassFactory.Destroy;
begin
  if fStatsReadVersion <> ogv_not_initialised then
  begin
    fStatsRead.Free;
  end;
  inherited;
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

end.
