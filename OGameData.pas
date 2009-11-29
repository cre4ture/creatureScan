unit OGameData;

interface

uses
  html, parser, classes, sysutils;

type
  TGameUniverse = class
  public
    name: string;
    galaxyCount: integer;
    solsysCount: integer;
    gameSpeedFactor: Single;
    tfFleetFactor: Single;
    tfDefFactor: Single;
    redesign_rules: boolean;


    constructor Create(const name: string; const xml: THTMLElement);
    destructor Destroy; override;
  end;

  TGameSite = class
  private
    fGameUniverseList: TList;

    procedure doGameUniverseTag(const xml: THTMLElement);
    function getUniverse(index: integer): TGameUniverse;
  public
    name: string;
    index: integer;  // deprecated, needed only for backward compatibility
    property UniverseList[index: integer]: TGameUniverse read getUniverse;
    function Count(): integer;
    constructor Create(xml: THTMLElement);
    destructor Destroy; override;
  end;

  TGameData = class
  private
    fGameSitesList: TList;

    procedure loadfromXML(xmlroot: THTMLElement);
    function getGameSite(index: integer): TGameSite;
  public

    property GameSites[index: integer]: TGameSite read getGameSite;
    function Count(): integer;
    constructor Create(filename: string);
    destructor Destroy; override;
  end;

implementation

function TGameData.Count: integer;
begin
  Result := fGameSitesList.Count;
end;

constructor TGameData.Create(filename: string);
var xmlroot: THTMLElement;
    text: TStringList;
begin
  fGameSitesList := TList.Create;

  text := TStringList.Create();
  xmlroot := THTMLElement.Create(nil, 'root');
  try
    text.LoadFromFile(filename);
    xmlroot.ParseHTMLCode(text.Text);
    loadfromXML(xmlroot);
  finally
    xmlroot.Free;
    text.Free;
  end;

end;

destructor TGameData.Destroy;
begin
  while Count > 0 do
  begin
    GameSites[0].Free;
    fGameSitesList.Delete(0);
  end;
  fGameSitesList.Free;
  inherited;
end;

function TGameData.getGameSite(index: integer): TGameSite;
begin
  Result := TGameSite(fGameSitesList[index]);
end;

procedure TGameData.loadfromXML(xmlroot: THTMLElement);
var xmlgames: THTMLElement;
    i, count: integer;
    newGS: TGameSite;
begin
  xmlgames := xmlroot.FindChildTagPath_e('?xml/data/game');

  count := xmlgames.ChildNameCount('site');
  for i := 0 to count - 1 do
  begin
    newGS := TGameSite.Create(xmlgames.FindChildTag('site', i));
    fGameSitesList.Add(newGS);
  end;
end;

{ TGameSite }

function TGameSite.Count: integer;
begin
  Result := fGameUniverseList.Count;
end;

constructor TGameSite.Create(xml: THTMLElement);
var i, count: integer;
begin
  fGameUniverseList := TList.Create;

  name := xml.AttributeValue['name'];
  index := StrToInt(xml.AttributeValue['index']);

  count := xml.ChildNameCount('uni');
  for i := 0 to count - 1 do
  begin
    doGameUniverseTag(xml.FindChildTag('uni', i));
  end;
end;

destructor TGameSite.Destroy;
begin
  while Count > 0 do
  begin
    UniverseList[0].Free;
    fGameUniverseList.Delete(0);
  end;
  fGameUniverseList.Free;
  inherited;
end;

procedure TGameSite.doGameUniverseTag(const xml: THTMLElement);
var uname, symbol: string;
    start, ende, i: integer;
    newU: TGameUniverse;
begin
  uname := xml.AttributeValue['name'];
  symbol := xml.AttributeValue['symbol'];

  start := xml.AttributesByName['index'].AsInteger(1);
  ende := xml.AttributesByName['to'].AsInteger(1);

  for i := start to ende do
  begin
    newU := TGameUniverse.Create(
                             StringReplace(uname, symbol,
                                           inttostr(i), [rfReplaceAll]),
                             xml);
    fGameUniverseList.Add(newU);
  end;
end;

function TGameSite.getUniverse(index: integer): TGameUniverse;
begin
  Result := TGameUniverse(fGameUniverseList[index]);
end;

{ TGameUniverse }

constructor TGameUniverse.Create(const name: string; const xml: THTMLElement);
begin
  self.name := name;
  // now load universe data:
  galaxyCount         := StrToIntDef  (xml.AttributeValue['galaxycount']    , 9);
  solsysCount         := StrToIntDef  (xml.AttributeValue['solsyscount']    , 499);
  gameSpeedFactor     := StrToFloatDef(xml.AttributeValue['gamespeedfactor'], 1.0);
  tfFleetFactor       := StrToFloatDef(xml.AttributeValue['tffleetfactor']  , 0.3);
  tfDefFactor         := StrToFloatDef(xml.AttributeValue['tfdeffactor']    , 0.0);
  redesign_rules      := StrToBoolDef (xml.AttributeValue['redesign']       , true);
end;

destructor TGameUniverse.Destroy;
begin
  inherited;
end;

end.
