unit fast_xml_writer;

interface

uses
  SysUtils, XMLDoc, XMLIntf;

type
  TFastXmlWriter = class
  private
    tag_stack: array of string; // aktueller tag-stack
    has_childs: boolean; // hat der tag kind-tags?
    can_attr: boolean; // können noch attribute gesetzt werden?
    xml: string;

    procedure doAddAttribute(name: string; value: string);

  public

    procedure beginTag(name: string);
    procedure addAttribute(name: string; value: string); overload;
    procedure addAttribute(name: string; value: int64); overload;
    procedure addAttribute(name: string; value: integer); overload;
    procedure addAttribute(name: string; value: Extended); overload;
    procedure endTag(name: string);

    function getXML: string;

    constructor Create(starttext: string = '<?xml version="1.0" encoding="UTF-8"?>');
    destructor Destroy; override;

  end;

function escapeXML_attr(text: string): string;
function unescapeXML_attr(text: string): string;

implementation

uses Math;

function escapeXML_attr(text: string): string;
var xmldoc: TXMLDocument;
    node: IXMLNode;
    i: integer;
    c: char;
begin
  for i := 1 to length(text) do
  begin
    c := text[i];
    if ((c < #$20) and
       (not (AnsiChar(c) in [#$9, #$A, #$D]))) or
       (AnsiChar(c) in ['"', '<', '>', '\']) then // stupid stuff don't work!!
    begin
      text[i] := '?';
    end;
  end;

  xmldoc := TXMLDocument.Create(nil); // don't need to be free()
  xmldoc.Active := True; // create empty document

  node := xmldoc.AddChild('test');
  node.Attributes['data'] := text;

  Result := xmldoc.XML.Text;
  // <test data="xxx"/>
  Result := copy(Result, 13, length(Result)-13-3-1);
end;

function unescapeXML_attr(text: string): string;
var xmldoc: IXMLDocument;
    node: IXMLNode;
begin
  text := '<test data="' + text + '"/>';
  xmldoc := LoadXMLData(text);
  xmldoc.LoadFromXML(text);
  xmldoc.Active := True;

  node := xmldoc.ChildNodes['test'];
  Result := node.Attributes['data'];
end;

{ TFastXmlWriter }

procedure TFastXmlWriter.addAttribute(name: string; value: integer);
begin
  doAddAttribute(name, IntToStr(value));
end;

procedure TFastXmlWriter.addAttribute(name: string; value: int64);
begin
  doAddAttribute(name, IntToStr(value));
end;

procedure TFastXmlWriter.addAttribute(name, value: string);
begin
  doAddAttribute(name, escapeXML_attr(value));
end;

procedure TFastXmlWriter.addAttribute(name: string; value: Extended);
begin
  doAddAttribute(name, FloatToStr(value));
end;

procedure TFastXmlWriter.beginTag(name: string);
var i: integer;
begin
  if can_attr then
    xml := xml + '><' + name // first close old tag
  else
    xml := xml + '<' + name; // old tag was already closed!
    
  has_childs := false;  // new tag is empty!
  can_attr := true;     // new tag can get attributes

  // push tag on stack
  i := length(tag_stack);
  SetLength(tag_stack, i+1);
  tag_stack[i] := name;
end;

constructor TFastXmlWriter.Create(starttext: string);
begin
  inherited Create;
  has_childs := false;
  can_attr := false;
  xml := starttext;
end;

destructor TFastXmlWriter.Destroy;
begin

  inherited;
end;

procedure TFastXmlWriter.doAddAttribute(name, value: string);
begin
  if not can_attr then
    raise Exception.Create('TFastXmlWriter.doAddAttribute(): Not allowed at this time!');

  xml := xml + ' ' + name + '="' + value + '"';
end;

procedure TFastXmlWriter.endTag(name: string);
var i: integer;
begin
  // pop stack
  i := length(tag_stack)-1;
  if name <> tag_stack[i] then
    raise Exception.Create('TFastXmlWriter.endTag(): Tagname missmatch!');
  SetLength(tag_stack, i);

  if (not has_childs) then
  begin
    xml := xml + '/>'; // close empty tag
  end
  else
  begin
    xml := xml + '</' + name + '>';  // end normal tag
  end;

  has_childs := true;  // parent tag has now at least one child-tag!
  can_attr := false;   // parent tag can't append attributes!
end;

function TFastXmlWriter.getXML: string;
begin
  if (Length(tag_stack) <> 0) then
    raise Exception.Create('TFastXmlWriter.getXML(): XML not completed!');

  Result := xml;
end;

end.
 