unit readsource_cs;

interface

uses
  readsource, ReadReport_Text, OGame_Types, TIReadPlugin_Types;

type
  TReadSource_cS = class(TReadSource)
  private
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

    constructor Create; override;
    destructor Destroy; override;
  end;

implementation

{ TReadSource_cS }

constructor TReadSource_cS.Create;
begin
  inherited;
  readscanlist := TReadReportList.Create;
end;

destructor TReadSource_cS.Destroy;
begin
  readscanlist.Free;
  inherited;
end;

end.
