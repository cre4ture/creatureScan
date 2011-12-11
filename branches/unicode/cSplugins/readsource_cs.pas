unit readsource_cs;

interface

uses
  readsource, ReadReport_Text, OGame_Types, TIReadPlugin_Types;

type
  TOGameVersion = (ogv_not_initialised, ogv_unknown, ogv_2xx, ogv_3xx);

  TReadSource_cS = class(TReadSource)
  private
    fOGameVersion: TOGameVersion;
    
  public
    status_buffer: AnsiString;
    scanstr_buffer: AnsiString;

    readscanlist: TReadReportList;
    portableScanHead: TPortableScanHead;
    portableScanBody: TPortableScanBody;

    portableFleetInfoSource: TPortableFleetsInfoSource;

    stats: TStat;
    portableStatsHead: TPortableStatisticPageHead;
    portableStatsEntry: TPortableStatisticEntry;

    solsys: TSystemCopy;
    portableSolSysHead: TPortableSolarSystemHead;
    portableSolSysPlanet: TPortableSolarSystemPlanet;

    function getOGameVersion: TOGameVersion;

    constructor Create; override;
    destructor Destroy; override;
  end;

implementation

uses OGameVersionDetector;

{ TReadSource_cS }

constructor TReadSource_cS.Create;
begin
  inherited;
  readscanlist := TReadReportList.Create;
  fOGameVersion := ogv_not_initialised;
end;

destructor TReadSource_cS.Destroy;
begin
  readscanlist.Free;
  inherited;
end;

function TReadSource_cS.getOGameVersion: TOGameVersion;
var detector: TOGameVersionDetector;
begin
  if fOGameVersion = ogv_not_initialised then
  begin
    detector := TOGameVersionDetector.Create;
    try
      fOGameVersion := detector.detectOGameVersion(GetHTMLRoot);
    finally
      detector.Free;
    end;
  end;
  Result := fOGameVersion;
end;

end.
