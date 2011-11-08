unit cS_utf8_conv;

interface

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

end.
