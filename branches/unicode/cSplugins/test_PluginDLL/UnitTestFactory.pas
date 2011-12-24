unit UnitTestFactory;

interface

uses UnitTestDB, Xml.XMLIntf, Generics.Collections;

type
  TUnitTestFactory = class
  public
    class function createFromXML(node: IXMLNode): TCSUnitTest;
  end;

procedure registerCSUnitTest(test: TCSUnitTestClass);

implementation

uses SysUtils;

var
  registeredUnitTestClasses: TList<TCSUnitTestClass>;

procedure registerCSUnitTest(test: TCSUnitTestClass);
begin
  if test.InheritsFrom(TCSUnitTest) then
  begin
    registeredUnitTestClasses.Add(test);
  end
  else
  begin
    raise Exception.Create('registerCSUnitTest(): Invalid Class!');
  end;
end;

{ TUnitTestFactory }

class function TUnitTestFactory.createFromXML(node: IXMLNode): TCSUnitTest;
var
  i: Integer;
  test: TCSUnitTest;
begin
  test := nil;
  for i := 0 to registeredUnitTestClasses.Count-1 do
  begin
    test := registeredUnitTestClasses[i].constructTestFromXML(node);
    if test <> nil then
    begin
      break;
    end;
  end;
  Result := test;
end;

initialization
  registeredUnitTestClasses := TList<TCSUnitTestClass>.Create();

finalization
  registeredUnitTestClasses.Free;

end.
