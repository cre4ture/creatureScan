unit lib_read_html;

interface

const
   HTMLTrimChars = [' ',#$D, #$A, #9, 'Â'];

function ReadInt(s: string; p: integer; tsep: Boolean = True): integer;
procedure FindAndReplace(substring: string; var s: string; replace: string);
function trim_html(s: String): String;

implementation

uses OGame_Types, sysutils;

function ReadInt(s: string; p: integer; tsep: Boolean = True): integer;
//Spezial for HTML!
begin
  if tsep then
    Result := ReadIntEx(s,p,ot_tousandsseperator, HTMLTrimChars)
  else Result := ReadIntEx(s,p,'', HTMLTrimChars);
end;

procedure FindAndReplace(substring: string; var s: string; replace: string);
var p: integer;
begin
  p := pos(substring, s);
  while (p > 0) do
  begin
    s := copy(s, 1, p-1) + replace + copy(s, p+length(substring), high(integer));
    p := Pos(substring, s);
  end;
end;

function trim_html(s: String): String;
//Spezial for HTML!
var p: integer;
begin
  FindAndReplace(#$D#$A, s, '');
  FindAndReplace('&nbsp;', s, ' ');
  FindAndReplace('Â ', s, ' ');

  p := pos(#160, s);
  while (p > 0) do
  begin
    s[p] := ' ';
    p := pos(#160, s);
  end;
  Result := sysutils.Trim(s);
end;

end.
