unit readsource;

{ ###############################################################

Author: Ulrich Hornung
Date: 2009.02.21

Verwendung:

  Neue ReadSource Erzeugen: "CreateAReadSource"
  Auf ReadSource zugreifen: "GetReadSource"
  Vorhandene ReadSource L�schen: "FreeAReadSourche"

Beschreibung:

Diese Unit dient zur ReadSource-Verwaltung.

Damit diese DLL nicht nur jeweils eine "Quelle" als ReadBuffer
verwenden kann, wird eine Liste verwendet, in der Objekte der Klasse
"TReadSource" verwaltet werden.

################################################################ }

interface

uses
  html;

type
  TReadSource = class;
  TReadSourceClass = class of TReadSource;
  TReadSource = class
  private
    html: String;
    text: String;
    html_root: THTMLElement;
  public
    procedure SetHTMLSource(ahtml: String);
    procedure SetTextSource(atext: String);
    constructor Create;
    destructor Destroy; override;
    function GetHTMLRoot: THTMLElement;
    function GetText: String;
    function GetHTMLString: string;
  end;

function GetReadSource(Handle: Integer): TReadSource;
function CreateAReadSource(AClass: TReadSourceClass): integer;
procedure FreeAReadSource(Handle: integer);

implementation

uses Classes;

var
  readsourcelist: TList;

constructor TReadSource.Create;
begin
  inherited;
end;

destructor TReadSource.Destroy;
begin
  if html_root <> nil then
    html_root.Free;

  inherited;
end;

function TReadSource.GetHTMLRoot: THTMLElement;
begin
  if html_root = nil then
  begin
    html_root := THTMLElement.Create(nil, 'html_root');
    html_root.ParseHTMLCode(html);
  end;

  Result := html_root;
end;

function TReadSource.GetHTMLString: string;
begin
  Result := html;
end;

function TReadSource.GetText: String;
begin
  Result := text;
end;

procedure TReadSource.SetHTMLSource(ahtml: String);
begin
  html := ahtml;
  if html_root <> nil then
  begin
    html_root.Free;
    html_root := nil;
  end;
end;

procedure TReadSource.SetTextSource(atext: String);
begin
  text := atext;
end;

function GetReadSource(Handle: Integer): TReadSource;
begin
  if Handle < readsourcelist.Count then
  begin
    Result := readsourcelist[Handle];
  end
  else
    Result := nil;
end;

function CreateAReadSource(AClass: TReadSourceClass): integer;
begin
  Result := readsourcelist.IndexOf(nil); //Freien Platz suchen
  if Result = -1 then  //wenn kein freier Platz vorhanden:
    Result := readsourcelist.Add(AClass.Create())  //neuer Eintrag
  else                 //wenn freier Platz gefunden:
    readsourcelist[Result] := AClass.Create();     //eintrag �berschreiben
end;

procedure FreeAReadSource(Handle: integer);
begin
  TReadSource(readsourcelist[Handle]).Free;
  readsourcelist[Handle] := nil;  // Hier darf nicht aus der Liste gel�scht
                                  // werden da sonst die anderen Handles
                                  // nichtmehr stimmen!
end;

initialization

  readsourcelist := TList.Create();

finalization

  while readsourcelist.Count > 0 do
  begin
    if readsourcelist[0] <> nil then
      TReadSource(readsourcelist[0]).Free;

    readsourcelist.Delete(0);
  end;

  readsourcelist.Free;

end.