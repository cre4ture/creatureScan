unit languagemodul;

interface

uses classes, IniFiles;

type
  TLangStrNotify = record
    id: TObject;
    event: TNotifyEvent;
  end;
  TLangStringStore = class
  private
    floaded: Boolean;
    store: TMemIniFile;
    notifylist: array of TNotifyEvent;
    function getstring(agid, aid: string): string;
    procedure setstring(agid, aid, a_s: string);
    procedure clearnotifylist;
  public
    property s[gid, id: string]: string read getstring write setstring; default;
    /// Says if a languagefile is loaded
    property loaded: Boolean read floaded;
    constructor Create;
    destructor Destroy; override;
    procedure clear;
    procedure LoadFromFile(filename: string);
    procedure SaveToFile(filename: string);
    function GetStringDef(gid, id, defval: string): string;

    ///nachfolgendes klappt nochnet so wirklich!!!
    procedure RegisterNotify(event: TNotifyEvent);
    procedure RegisterNotify_remove(event: TNotifyEvent);
  end;

var g_langmod: TLangStringStore;
    g_langmod_ref: integer;

procedure GlobalLangMod_Init(filename: string);
procedure GlobalLangMod_Free;

implementation

uses StrUtils;

function EncodeStr(const s: string): string;
var p: integer;
begin
  Result := s;
  p := PosEx(#13#10,Result);
  while p > 0 do
  begin
    Result := copy(Result,1,p-1) + '/n' + copy(Result,p+2,high(integer));
    p := PosEx(#13#10,Result,p+1);
  end;

  Result := '"'+Result+'"';
end;

function DecodeSTR(const s: string): string;
var p: integer;
begin
  Result := s;
  p := pos('/n',Result);
  while p > 0 do
  begin
    Result := copy(Result,1,p-1) + #13#10 + copy(Result,p+2,high(integer));
    p := pos('/n',Result);
  end;

  p := length(Result);
  if (p > 0)and(Result[1] = '"')and(Result[p] = '"') then
    Result := copy(Result,2,p-2);
end;

procedure TLangStringStore.clear;
begin
  store.Clear;
  floaded := false;
end;

procedure TLangStringStore.clearnotifylist;
begin
  SetLength(notifylist,0);
end;

constructor TLangStringStore.Create;
begin
  inherited;
  store := TMemIniFile.Create('');
  clearnotifylist();
  floaded := false;
end;

destructor TLangStringStore.Destroy;
begin
  store.Free;
  inherited;
end;

function TLangStringStore.getstring(agid, aid: string): string;
begin
  Result := DecodeSTR(store.ReadString(agid, aid, ''));
end;

function TLangStringStore.GetStringDef(gid, id, defval: string): string;
begin
  Result := s[gid, id];
  if Result = '' then
    Result := defval;
end;

procedure TLangStringStore.LoadFromFile(filename: string);
var adding: TIniFile;
    sec, it: TStringList;
    seci, iti: integer;
    secs, its: string;
begin
  //Add Langfile to existing translationlist
  sec := TStringList.Create;
  it := TStringList.Create;
  try
    adding := TIniFile.Create(filename);
    adding.ReadSections(sec);
    for seci := 0 to sec.Count-1 do
    begin
      secs := sec[seci];
      adding.ReadSection(secs, it);
      for iti := 0 to it.Count-1 do
      begin
        // here you must not use setstring cause "EncodeStr"
        its := it[iti];
        store.WriteString(secs, its, adding.ReadString(secs, its, ''));
      end;
    end;
    adding.free;
    floaded := true;
  finally
    sec.Free;
    it.Free;
  end;
end;

procedure TLangStringStore.RegisterNotify(event: TNotifyEvent);
var i: integer;
begin
  i := length(notifylist);
  SetLength(notifylist, i+1);
  notifylist[i] := event;
end;

procedure TLangStringStore.RegisterNotify_remove(event: TNotifyEvent);
var i: integer;
begin
  for i := 0 to length(notifylist)-1 do
  begin
    if @notifylist[i] = @event then
    begin
     // notifylist.Delete(i);
      Break;
    end;
  end;
end;

procedure TLangStringStore.SaveToFile(filename: string);
begin
  store.Rename(filename, false);
  store.UpdateFile;
end;

procedure TLangStringStore.setstring(agid, aid, a_s: string);
begin
  store.WriteString(agid, aid, EncodeStr(a_s));
end;

procedure GlobalLangMod_Init(filename: string);
begin
  g_langmod_ref := g_langmod_ref +1;

  if g_langmod = nil then
    g_langmod := TLangStringStore.Create;

  g_langmod.clear;
  if filename <> '' then
  begin
    g_langmod.LoadFromFile(filename);
  end;
end;

procedure GlobalLangMod_Free;
begin
  g_langmod_ref := g_langmod_ref-1;
  if g_langmod_ref = 0 then
  begin
    g_langmod.Free;
    g_langmod := nil;
  end;
end;

initialization
  g_langmod := nil;
  g_langmod_ref := 0;

finalization

end.
