unit UnitTestDB;

interface

uses XMLDoc, Generics.Collections, Xml.XMLIntf, TIReadPlugin;

type
  TCSUnitTestClass = class of TCSUnitTest;
  TCSUnitTest = class
  public
    function runUnitTest(plugin: TLangPlugIn): string; virtual; abstract;
    class function constructTestFromXML(xml: IXMLNode): TCSUnitTest; virtual; abstract;
    procedure saveToXML(xml: IXMLNode); virtual; abstract;
    destructor Destroy; override;
  end;

  TCSUnitTestDB = class
  private
    my_filename: string;
    xmldoc: TXMLDocument;
    ftestlist: TList<TCSUnitTest>;
    function getTest(index: integer): TCSUnitTest;

  public
    property tests[index: integer]: TCSUnitTest read getTest;
    function count: integer;
    function addUnitTest(test: TCSUnitTest): integer; // no copy! (auto-destroy all items)
    procedure saveToFile();
    constructor Create(filename: string);
    destructor Destroy; override;
  end;

implementation

uses SysUtils;

{ TCSUnitTestDB }

function TCSUnitTestDB.addUnitTest(test: TCSUnitTest): integer;
begin
  Result := ftestlist.Add(test);
end;

function TCSUnitTestDB.count: integer;
begin
  Result := ftestlist.Count;
end;

constructor TCSUnitTestDB.Create(filename: string);
begin
  inherited Create;
  my_filename := filename;
  ftestlist := TList<TCSUnitTest>.Create;
  if FileExists(filename) then
    xmldoc := TXMLDocument.Create(filename)
  else
    xmldoc := TXMLDocument.Create(nil);

  xmldoc.Active := true;
  xmldoc.ChildNodes
end;

destructor TCSUnitTestDB.Destroy;
var
  i: Integer;
begin
  for i := 0 to ftestlist.Count-1 do
  begin
    ftestlist[i].Free;
  end;

  xmldoc.Free;
  ftestlist.Free;
  inherited;
end;

function TCSUnitTestDB.getTest(index: integer): TCSUnitTest;
begin
  Result := ftestlist[index];
end;

procedure TCSUnitTestDB.saveToFile;
var
  i: Integer;
  node: IXMLNode;
begin
  xmldoc.ChildNodes.Clear;
  for i := 0 to count-1 do
  begin
    node := xmldoc.AddChild('test');
    node.Attributes['class'] := tests[i].ClassName;
    tests[i].saveToXML(node);
  end;
  xmldoc.SaveToFile(my_filename);
end;

{ TCSUnitTest }

destructor TCSUnitTest.Destroy;
begin
  inherited;
end;

end.
