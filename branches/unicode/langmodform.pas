unit langmodform;

/// Die Form läd/speichert auch werte die in einer TValueListEditor-Komponente
/// Eingetragen sind, allerdings nur wenn diese Komponente den Tag-Wert 123 hat!

interface

uses Classes, Forms, languagemodul, StdCtrls, Buttons, Menus, ComCtrls,
  SysUtils, VirtualTrees, ValEdit;

type
  TLangModForm = class(TForm)
  protected
    langstr_groupid: string;
    procedure LoadAllCaptions;
    procedure SaveAllCaptions;
    procedure SetName(const NewName: TComponentName); override;
    function SaveComponentCaption(comp: TComponent): Boolean;
  private
    procedure Setlangstr(aid, a_s: string);
    function Getlangstr(aid: string): string;
  public
    property langstr[id: string]: string read Getlangstr write Setlangstr;
    function langstrdef(id: string; default: string): string;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

uses Grids;

function Entf_X(S: String): string; //Siehe SaveAllCaptions/LoadAllCaptions
var i: integer;
begin
  Result := S;
  for i := length(S) downto 0 do
  begin
    if not(AnsiChar(s[i]) in ['0'..'9','_']) then
      Break;
    if s[i] = '_' then
    begin
      Result := copy(s,1,i-1);
      Break;
    end;
  end;
end;

constructor TLangModForm.Create(AOwner: TComponent);
begin
  GlobalLangMod_Init('');

  inherited;
  // bei meheren formen der gleichen klasse (zb. beim explorer) wird immer ein "_1" dazugebaut (zb. "FRM_explorer_1") das muss entfernt werden!
  langstr_groupid := Entf_X(Name);
  //siehe setname
end;

destructor TLangModForm.Destroy;
begin
  inherited;
  GlobalLangMod_Free;
end;

function TLangModForm.Getlangstr(aid: string): string;
begin
  Result := g_langmod.s[langstr_groupid, aid];
end;

procedure TLangModForm.Setlangstr(aid, a_s: string);
begin
  g_langmod.s[langstr_groupid, aid] := a_s;
end;

procedure TLangModForm.SaveAllCaptions;
var i: integer;
begin
  langstr[langstr_groupid+'.Caption'] := Caption;
  for i := 0 to ComponentCount-1 do
  begin
    try
      SaveComponentCaption(Components[i]);
    except
    end;
  end;
end;

function TLangModForm.SaveComponentCaption(comp: TComponent): Boolean;
var j: integer;
    key: string;
begin
  Result := True;  // Rückgabewert besagt ob Klasse bekannt und Komponente gespeichert wurde

  if (comp is TLabel) then
    with comp as TLabel do
    begin
      langstr[Name+'.Caption'] := Caption;
      langstr[Name+'.Hint'] := Hint;
    end else
  if (comp is TSpeedButton) then
    with comp as TSpeedButton do
    begin
      langstr[Name+'.Caption'] := Caption;
      langstr[Name+'.Hint'] := Hint;
    end else
  if (comp is TButton) then
    with comp as TButton do
    begin
      langstr[Name+'.Caption'] := Caption;
      langstr[Name+'.Hint'] := Hint;
    end else
  if (comp is TCheckBox) then
    with comp as TCheckBox do
    begin
      langstr[Name+'.Caption'] := Caption;
      langstr[Name+'.Hint'] := Hint;
    end else
  if (comp is TMenuItem) then
    with comp as TMenuItem do
    begin
      langstr[Name+'.Caption'] := Caption;
      langstr[Name+'.Hint'] := Hint;
    end else
  if (comp is TStatusBar) then
    with comp as TStatusBar do
    begin
      for j := 0 to Panels.Count-1 do
        langstr[Name+'.['+inttostr(j)+']Text'] := Panels[j].Text;
    end else
  if (comp is TListView) then
    with comp as TListView do
    begin
      for j := 0 to Columns.Count-1 do
        langstr[Name+'.['+inttostr(j)+']Caption'] := Columns[j].Caption;
    end else
  if (comp is TGroupBox) then
    with comp as TGroupBox do
    begin
      langstr[Name+'.Caption'] := Caption;
      langstr[Name+'.Hint'] := Hint;
    end else
  if (comp is TTabSheet) then
    with comp as TTabSheet do
    begin
      langstr[Name+'.Caption'] := Caption;
      langstr[Name+'.Hint'] := Hint;
    end else
  if (comp is TRadioButton) then
    with comp as TRadioButton do
    begin
      langstr[Name+'.Caption'] := Caption;
      langstr[Name+'.Hint'] := Hint;
    end else
  if (comp is TVirtualStringTree) then
    with comp as TVirtualStringTree do
    begin
      for j := 0 to Header.Columns.Count-1 do
        langstr[Name + '.[' + IntToStr(j) + ']Caption'] := Header.Columns[j].Text;
    end else
  if (comp is TComboBox) then
    with comp as TComboBox do
    begin
      langstr[Name+'.Hint'] := Hint;
    end else
  if (comp is TValueListEditor)and(comp.Tag = 123) then
    with comp as TValueListEditor do
    begin
      langstr[Name+'.Count'] := IntToStr(RowCount-1);
      // j = 1 weil Keys[0] immer der Header ist ("Schlüssel")
      for j := 1 to RowCount-1 do     // RowCount-1 VORSICHT!!!
      begin
        key := Keys[j];
        langstr[Name+'['+IntToStr(j-1)+'].Keyname'] := key;
        langstr[key] := Values[key];
      end;

      langstr[Name+'.Hint'] := Hint;
    end else
          Result := False;
end;

function TLangModForm.langstrdef(id: string; default: string): string;
begin
  Result := g_langmod.GetStringDef(langstr_groupid, id, default);
end;

procedure TLangModForm.LoadAllCaptions;
var i,j, count: integer;
    key: string;
begin
  Caption := langstrdef(langstr_groupid+'.Caption',Caption);
  for i := 0 to ComponentCount-1 do
  begin
    try
      if (Components[i] is TLabel) then
        with Components[i] as TLabel do
        begin
          Caption := langstrdef(Name+'.Caption',Caption);
          Hint := langstrdef(Name+'.Hint',Hint);
          ShowHint := Hint <> '';
        end else
      if (Components[i] is TSpeedButton) then
        with Components[i] as TSpeedButton do
        begin
          Caption := langstrdef(Name+'.Caption',Caption);
          Hint := langstrdef(Name+'.Hint',Hint);
          ShowHint := Hint <> '';
        end else
      if (Components[i] is TButton) then
        with Components[i] as TButton do
        begin
          Caption := langstrdef(Name+'.Caption',Caption);
          Hint := langstrdef(Name+'.Hint',Hint);
          ShowHint := Hint <> '';
        end else
      if (Components[i] is TCheckBox) then
        with Components[i] as TCheckBox do
        begin
          Caption := langstrdef(Name+'.Caption',Caption);
          Hint := langstrdef(Name+'.Hint',Hint);
          ShowHint := Hint <> '';
        end else
      if (Components[i] is TMenuItem) then
        with Components[i] as TMenuItem do
        begin
          Caption := langstrdef(Name+'.Caption',Caption);
          Hint := langstrdef(Name+'.Hint',Hint);
          ShowHint := Hint <> '';
        end else
      if (Components[i] is TStatusBar) then
        with Components[i] as TStatusBar do
        begin
          for j := 0 to Panels.Count-1 do
            Panels[j].Text := langstrdef(Name+'.['+inttostr(j)+']Text',Panels[j].Text);
        end else
      if (Components[i] is TListView) then
        with Components[i] as TListView do
        begin
          for j := 0 to Columns.Count-1 do
            Columns[j].Caption := langstrdef(Name+'.['+inttostr(j)+']Caption',Columns[j].Caption);
        end else
      if (Components[i] is TGroupBox) then
        with Components[i] as TGroupBox do
        begin
          Caption := langstrdef(Name+'.Caption',Caption);
          Hint := langstrdef(Name+'.Hint',Hint);
          ShowHint := Hint <> '';
        end else
      if (Components[i] is TTabSheet) then
        with Components[i] as TTabSheet do
        begin
          Caption := langstrdef(Name+'.Caption',Caption);
          Hint := langstrdef(Name+'.Hint',Hint);
          ShowHint := Hint <> '';
        end else
      if (Components[i] is TRadioButton) then
        with Components[i] as TRadioButton do
        begin
          Caption := langstrdef(Name+'.Caption',Caption);
          Hint := langstrdef(Name+'.Hint',Hint);
          ShowHint := Hint <> '';
        end else
      if (Components[i] is TVirtualStringTree) then
        with Components[i] as TVirtualStringTree do
        begin
          for j := 0 to Header.Columns.Count-1 do
            Header.Columns[j].Text := langstrdef(Name + '.[' + IntToStr(j) + ']Caption',Header.Columns[j].Text);
        end else
      if (Components[i] is TComboBox) then
        with Components[i] as TComboBox do
        begin
          Hint := langstrdef(Name+'.Hint',Hint);
          ShowHint := Hint <> '';
        end else
      if (Components[i] is TValueListEditor)and(Components[i].Tag = 123) then
        with Components[i] as TValueListEditor do
        begin
          count := StrToIntDef(langstr[Name+'.Count'], RowCount);
          for j := 0 to count-1 do
          begin
            key := langstr[Name+'['+IntToStr(j)+'].Keyname'];
            Values[key] := langstrdef(key, Values[key]);
          end;

          Hint := langstrdef(Name+'.Hint',Hint);
          ShowHint := Hint <> '';
        end else
    except
    end;
  end;
end;

procedure TLangModForm.SetName(const NewName: TComponentName);
begin
  inherited;
  // bei meheren formen der gleichen klasse (zb. beim explorer) wird immer ein "_1" dazugebaut (zb. "FRM_explorer_1") das muss entfernt werden!
  langstr_groupid := Entf_X(Name);
  //siehe Create()
end;

end.
