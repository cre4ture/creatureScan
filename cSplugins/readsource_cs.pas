unit readsource_cs;

interface

uses
  readsource, ReadReport_Text;

type
  TReadSource_cS = class(TReadSource)
  public
    readscanlist: TReportList;
    rsl_index: integer;
  end;

implementation

end.
