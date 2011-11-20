unit FetchStats;

interface

uses IdHTTP, creax_html, IdURI;

type
  TStatRecord = record
    value_points: integer;
    value_fleets: integer;
    time_u: Int64;
  end;
  TStatsArray = array of TStatRecord;
  TFetchStats = class
  private
    list: TStatsArray;
    http: TIdHTTP;
    procedure parseContent(content: string);
    procedure parseLink(link: string);
    procedure parseData(data: string);
    function readCommaSeperatedList(const list: string;
      var pos: integer; out item: string): boolean; 
  public
    function getLastStats(player: string): TStatsArray;
    constructor Create;
    destructor Destroy; override;
  end;

implementation

uses SysUtils, StrUtils;

{ TFetchStats }

constructor TFetchStats.Create;
begin
  inherited;
  http := TIdHTTP.Create(nil);
end;

destructor TFetchStats.Destroy;
begin
  http.Free;
  inherited;
end;

function TFetchStats.getLastStats(player: string): TStatsArray;
var url, content: string;
    p: integer;
begin


  // fix error in name:
  p := pos('...', player);
  if (p > 0) and (p = length(player)-3+1) then
    player := copy(player, 1, length(player)-3);

  url := 'http://www.war-riders.de/de/109/details/player/' + player;
  url := TIdURI.URLEncode(url);
  content := http.Get(url);
  parseContent(content);
  Result := list;
end;

procedure TFetchStats.parseContent(content: string);
var root, chartnode, paramnode: THTMLElement;
    link: string;
begin
  root := THTMLElement.Create(nil, 'root');
  try
    root.ParseHTMLCode(content);
    chartnode := HTMLFindRoutine_NameAttribute(root, 'object', 'classid', 'clsid:d27cdb6e-ae6d-11cf-96b8-444553540000');
    if chartnode <> nil then
    begin
      paramnode := HTMLFindRoutine_NameAttribute(chartnode, 'param', 'name', 'movie');
      if paramnode <> nil then
      begin
        link := paramnode.AttributeValue['value'];
        parseLink(link);
      end;
    end;
  finally
    root.Free;
  end;
end;

procedure TFetchStats.parseData(data: string);
var p, i: integer;
    item, kw: string;
begin
  kw := '&values=';
  p := pos(kw, data);
  if p > 0 then
  begin
    p := p + length(kw);
    i := 0;
    while readCommaSeperatedList(data, p, item) do
    begin
      SetLength(list, i+1);
      list[i].value_points := StrToIntDef(item, -1);
      inc(i);
    end;
  end;
  p := pos('&values_2=', data);
  if p > 0 then
  begin

  end;
  p := pos('&x_labels=', data);
  if p > 0 then
  begin

  end;
end;

procedure TFetchStats.parseLink(link: string);
var p: integer;
    datalink: string;
begin
  p := pos('data=/data/', link);
  if p > 0 then
  begin
    datalink := copy(link, p+6, 99999);
    parseData(
      http.Get('http://www.war-riders.de/' + datalink));
  end;
end;

function TFetchStats.readCommaSeperatedList(const list: string;
  var pos: integer; out item: string): boolean;
var e, n: integer;
begin
  Result := list[pos] <> '&';
  if Result then
  begin

    e := PosEx('&', list, pos);
    n := PosEx(',', list, pos);

    if n > e then n := e;

    item := copy(list, pos, (n-pos));

    if n <> e then inc(n);  // am ende bleiben wir auf dem '&' stehen!

    pos := n;

  end;
end;

end.
