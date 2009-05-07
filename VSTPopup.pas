unit VSTPopup;

interface

uses
  Menus, VirtualTrees, Classes, iniFiles, SysUtils;

{type
  TVSTPopUpMenu = class(TPopUpMenu)
  private
    procedure MenuPopup(Sender: TObject);
    procedure MenuItemClick(Sender: TObject);
  public
    VST: TVirtualStringTree;
    constructor Create(AOwner: TComponent);
  end;}


procedure LoadVSTHeaders(VST: TVirtualStringTree; ini: TIniFile;
  Section: String);
procedure SaveVSTHeaders(VST: TVirtualStringTree; ini: TIniFile;
  Section: String);

implementation

{constructor TVSTPopUpMenu.Create(AOwner: TComponent);
begin
  inherited;
  OnPopup := MenuPopup;
end;

procedure TVSTPopUpMenu.MenuPopup(Sender: TObject);
var i: integer;
    item: TMenuItem;
begin
  Items.Clear;
  //--- erstelle popup für headers ---------------------------------------------
  for i := 1 to VST.Header.Columns.Count-1 do  //weil erste spalte weglassen!
  begin
    item := TMenuItem.Create(Self);
    item.Caption := VST.Header.Columns[i].Text;
    item.Tag := i;
    item.Checked := (coVisible in VST.Header.Columns[i].Options);
    item.OnClick := MenuItemClick;

    Items.Add(item);
  end;
  //--- erstelle popup für headers - fertig ------------------------------------
end;

procedure TVSTPopUpMenu.MenuItemClick(Sender: TObject);
var opt: TVTColumnOptions;
begin
  with Sender as TMenuItem do
  begin
    Checked := not Checked;
    opt := VST.Header.Columns[tag].Options;
    if Checked then Include(opt,coVisible)
    else Exclude(opt,coVisible);
    VST.Header.Columns[tag].Options := opt;
  end;
end;  }

procedure LoadVSTHeaders(VST: TVirtualStringTree; ini: TIniFile;
  Section: String);
var i: Integer;
    opt: TVTColumnOptions;
    b: Boolean;
begin
  for i := 0 to VST.Header.Columns.Count-1 do
  with VST.Header.Columns[i] do
  begin
    Width := ini.ReadInteger(Section,'SpW_'+IntToStr(i),Width);
    Position := ini.ReadInteger(Section,'SpP_'+IntToStr(i),Position);
    opt := Options;
    b := ini.ReadBool(Section,'SpV_'+IntToStr(i),coVisible in Options);
    if b then Include(opt,coVisible) else Exclude(opt,coVisible);
    Options := Opt;
  end;
end;

procedure SaveVSTHeaders(VST: TVirtualStringTree; ini: TIniFile;
  Section: String);
var i: Integer;
begin
  for i := 0 to VST.Header.Columns.Count-1 do
  with VST.Header.Columns[i] do
  begin
    ini.WriteInteger(Section,'SpW_'+IntToStr(i),Width);
    ini.WriteInteger(Section,'SpP_'+IntToStr(i),Position);
    ini.WriteBool(Section,'SpV_'+IntToStr(i),coVisible in Options);
  end;
end;

end.
