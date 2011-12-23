unit cshelper_tag_reader;

interface

uses creax_html;

function get_cshelper_info(xmldoc: THTMLElement;
  var player_name: string; var player_id: int64): Boolean;

implementation

uses SysUtils;

function get_cshelper_info(xmldoc: THTMLElement;
  var player_name: string; var player_id: int64): Boolean;
var node: THTMLElement;
begin
  node := xmldoc.FindChildTag('cshelper_playerinfo');
  Result := node <> nil;
  if (Result) then
  begin
    player_name := node.AttributeValue['name'];
    player_id := StrToInt64Def(node.AttributeValue['id'], 0);
  end
  else
  begin
    player_name := '';
    player_id := 0;
  end;
end;

end.
