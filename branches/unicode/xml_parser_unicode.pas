unit xml_parser_unicode;

interface

uses SysUtils, LibXmlParser;

type
  TUnicodeXmlParser = class(TXmlParser)
  protected
  public
    FUNCTION TranslateEncoding(CONST Source : AnsiString): AnsiString; override;
    function attrAsInt(attr: String): integer;
    function attrAsInt64(attr: String): Int64;
    function attrAsString(attr: String): string;
  end;

function atValStr(Attributes: TAttrList; attr: string): string;

implementation

function atValStr(Attributes: TAttrList; attr: string): string;
begin
{$ifdef UNICODE}
  result := UTF8ToWideString(Attributes.Value(AnsiString(attr)));
{$else}
  result := Utf8ToAnsi(Attributes.Value(attr));
{$endif}
end;

{ TUnicodeXmlParser }

function TUnicodeXmlParser.attrAsInt(attr: string): integer;
begin
  // we do not need to translate UTF8 since we only accept [0-9]
{$ifdef UNICODE}
  result := StrToInt(WideString(CurAttr.Value(AnsiString(attr))));
{$else}
  result := StrToInt(CurAttr.Value(attr));
{$endif}
end;

function TUnicodeXmlParser.attrAsInt64(attr: string): Int64;
begin
  // we do not need to translate UTF8 since we only accept [0-9]
{$ifdef UNICODE}
  result := StrToInt64(WideString(CurAttr.Value(AnsiString(attr))));
{$else}
  result := StrToInt64(CurAttr.Value(attr));
{$endif}
end;

function TUnicodeXmlParser.attrAsString(attr: String): string;
begin
{$ifdef UNICODE}
  result := UTF8ToWideString(CurAttr.Value(AnsiString(attr)));
{$else}
  result := Utf8ToAnsi(CurAttr.Value(attr));
{$endif}
end;

function TUnicodeXmlParser.TranslateEncoding(
  const Source: AnsiString): AnsiString;
begin
  Result := Source; // just return UTF8!
end;

end.
