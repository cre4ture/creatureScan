unit CSUnitTest_httpOnly;

interface

uses UnitTestDB, Xml.XMLIntf;

type
  TCSUnitTest_httpOnly = class(TCSUnitTest)
  protected
    http: UTF8String;
    constructor Create(root: IXMLNode); override;

  public
    class function constructTestFromXML(xml: IXMLNode): TCSUnitTest; override;
    destructor Destroy; override;
  end;

implementation

uses UnitTestFactory;

{ TCSUnitTest_httpOnly }

class function TCSUnitTest_httpOnly.constructTestFromXML(
  xml: IXMLNode): TCSUnitTest;
begin
  Result := TCSUnitTest_httpOnly.Create(xml);
end;

constructor TCSUnitTest_httpOnly.Create(root: IXMLNode);
begin
  inherited;
  http := UTF8Encode(xmldoc.Text);
end;

destructor TCSUnitTest_httpOnly.Destroy;
begin
  inherited;
end;

initialization
  UnitTestFactory.registerCSUnitTest(TCSUnitTest_httpOnly);

end.
