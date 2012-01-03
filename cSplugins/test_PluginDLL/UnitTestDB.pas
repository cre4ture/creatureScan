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
    xmldoc: IXMLDocument;
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

uses SysUtils, UnitTestFactory, xmldom;

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
var
  i: Integer;
  factory: TUnitTestFactory;
  test: TCSUnitTest;
begin
  inherited Create;
  my_filename := filename;
  ftestlist := TList<TCSUnitTest>.Create;
  xmldoc := NewXMLDocument();
  if FileExists(filename) then
    xmldoc.LoadFromFile(filename);

  xmldoc.Active := true;
  factory := TUnitTestFactory.Create;
  try
    for i := 0 to xmldoc.DocumentElement.ChildNodes.Count-1 do
    begin
      test := factory.createFromXML(xmldoc.DocumentElement.ChildNodes[i]);
      if test <> nil then
      begin
        addUnitTest(test);
      end;
    end;
  finally
    factory.Free;
  end;
end;

destructor TCSUnitTestDB.Destroy;
var
  i: Integer;
begin
  for i := 0 to ftestlist.Count-1 do
  begin
    ftestlist[i].Free;
  end;
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
  node, root: IXMLNode;
begin
  xmldoc.ChildNodes.Clear;
  root := xmldoc.AddChild('root');
  for i := 0 to count-1 do
  begin
    node := root.AddChild('test');
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
