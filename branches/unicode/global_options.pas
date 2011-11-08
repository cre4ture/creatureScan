unit global_options;

interface

function cS_getGlobalOption(section, name: string; default: string): string;
procedure cS_setGlobalOption(section, name: string; value: string);

implementation

uses IniFiles;

var
  options: TMemIniFile;

function cS_getGlobalOption(section, name: string; default: string): string;
begin
  Result := options.ReadString(section, name, default);
end;

procedure cS_setGlobalOption(section, name: string; value: string);
begin
  options.WriteString(section, name, value);
end;

initialization
  options := TMemIniFile.Create('');

finalization
  options.Free;


end.
