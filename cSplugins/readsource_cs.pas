unit readsource_cs;

interface

uses
  readsource, ReadReport_Text, OGame_Types;

type
  TReadSource_cS = class(TReadSource)
  private
  public
    readscanlist: TReadReportList;
    rsl_index: integer;
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
