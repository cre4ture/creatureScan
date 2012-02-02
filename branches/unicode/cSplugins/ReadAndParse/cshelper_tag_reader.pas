unit cshelper_tag_reader;

interface

uses creax_html;

type
  TOGameMetaInfo = record
    playername, allyname: string;
    playerid, allyid: Int64;
  end;

function getOGameMeta(xmldoc: THTMLElement): TOGameMetaInfo;

(*function get_cshelper_info(xmldoc: THTMLElement;
  var player_name: string; var player_id: int64): Boolean;*)

implementation

uses SysUtils;

(*  old -> use getOGameMeta instead!
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
*)

function getOGameMeta(xmldoc: THTMLElement): TOGameMetaInfo;

  function readMetaInfo(name: string; default: string): string;
  var tag: THTMLElement;
  begin
    Result := default;
    tag := HTMLFindRoutine_NameAttribute(xmldoc, 'meta', 'name', name);
    if (tag <> nil) then
    begin
      Result := tag.AttributeValue['content'];
    end;
  end;

begin
  Result.playername := readMetaInfo('ogame-player-name', '');
  Result.allyname := readMetaInfo('ogame-alliance-tag', '');
  Result.playerid := StrToInt64Def(readMetaInfo('ogame-player-id', ''), 0);
  Result.allyid := StrToInt64Def(readMetaInfo('ogame-alliance-id', ''), 0);
end;

end.
