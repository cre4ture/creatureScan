unit cS_utf8_conv;

interface

uses inifiles;

type
  TIniFileUTF8 = class(TIniFile)
  public
    function ReadString(const Section, Ident: string; Default: AnsiString): AnsiString; reintroduce;
  end;

function trnslShortStr(input: AnsiString): string;
function trnsltoUTF8(input: string): AnsiString;

implementation

function trnslShortStr(input: AnsiString): string;
begin
{$ifdef UNICODE}
  result := UTF8ToWideString(input);
{$else}
  result := Utf8ToAnsi(input);
{$endif}
end;

function trnsltoUTF8(input: string): AnsiString;
begin
{$ifdef UNICODE}
  result := UTF8Encode(input);
{$else}
  result := AnsiToUtf8(input);
{$endif}
end;

{ TIniFileUTF8 }

function TIniFileUTF8.ReadString(const Section, Ident: string;
  Default: AnsiString): AnsiString;
begin
  result := AnsiString(inherited ReadString(Section, Ident, string(Default)));
end;

end.
