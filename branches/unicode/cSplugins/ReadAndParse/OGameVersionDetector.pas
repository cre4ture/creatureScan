unit OGameVersionDetector;

interface

uses ReadSource_cS, creax_HTML, regexpname;

type
  TOGameVersionDetector = class
  private
  public
    function detectOGameVersion(html: THTMLElement): TOGameVersion;
  end;

implementation

uses SysUtils;

{ TOGameVersionDetector }

function TOGameVersionDetector.detectOGameVersion(
  html: THTMLElement): TOGameVersion;
var versionNode, footerNode, tag: THTMLElement;
    regex: Tregexpn;
    s: string;
    majorV: integer;
begin
  Result := ogv_unknown;
  footerNode := HTMLFindRoutine_NameAttribute(html, 'div', 'id', 'siteFooter');
  if footerNode <> nil then
  begin
    tag := HTMLFindRoutine_NameAttribute(footerNode, 'div', 'class', 'fleft textLeft');
    if tag <> nil then
    begin
      versionNode := tag.FindChildTagPath('a:0');
      if versionNode <> nil then
      begin
        s := versionNode.FullTagContent;
        regex := Tregexpn.Create;
        try
          regex.setexpression('(?<major>[0-9]+).(?<minor1>[0-9]+).(?<minor2>[0-9]+)');
          if (regex.match(s)) then
          begin
            majorV := StrToIntDef(regex.getsubexpr('major'), 0);
            case majorV of
              2: Result := ogv_2xx;
              3: Result := ogv_3xx;
              4..99: Result := ogv_latest;
            else
              Result := ogv_unknown;
            end;
          end;
        finally
          regex.Free;
        end;
      end;
    end;
  end;
end;

end.
