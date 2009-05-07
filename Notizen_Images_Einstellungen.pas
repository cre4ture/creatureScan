unit Notizen_Images_Einstellungen;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, Menus, StdCtrls, Languages, ImgList, Prog_Unit;

type
  TFRM_Notizen_Images_einstellungen = class(TForm)
    ListView1: TListView;                                                
    Button1: TButton;
    Button2: TButton;
    PopupMenu1: TPopupMenu;
    Lschen1: TMenuItem;
    OpenDialog1: TOpenDialog;
    ImageList1: TImageList;
    Edit1: TEdit;
    Label1: TLabel;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    ColorDialog1: TColorDialog;
    procedure Edit1Change(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure ListView1AdvancedCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; Stage: TCustomDrawStage;
      var DefaultDraw: Boolean);
    procedure Button2Click(Sender: TObject);
    procedure ListView1SelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure FormCreate(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    procedure OpenAndAdd;
    { Public-Deklarationen }
  end;

implementation

uses Notizen;

{$R *.DFM}

procedure TFRM_Notizen_Images_einstellungen.OpenAndAdd;
var bmp: TBitmap;
begin
  if OpenDialog1.Execute then
  begin
    bmp := TBitmap.Create;
    bmp.LoadFromFile(OpenDialog1.FileName);
    if (bmp.Height = FRM_Notizen.ImageList1.Height)and
       (bmp.Width = FRM_Notizen.ImageList1.Width) then
    begin
      ImageList1.AddMasked(bmp,bmp.Canvas.Pixels[0,0]);
      with ListView1.Items.Add do
      begin
        SubItems.Add('New');
        SubItems.Add(OpenDialog1.FileName);
        SubItems.Add(IntToStr(clBlack));
        Caption := '';
        ImageIndex := ImageList1.Count-1;
      end;
    end else ShowMessage(STR_Bild_mit_Falscher_groesse + '(' + IntToStr(FRM_Notizen.ImageList1.Height) + 'x' + IntToStr(FRM_Notizen.ImageList1.Width) + ')');
    bmp.free;
  end;
end;

procedure TFRM_Notizen_Images_einstellungen.Edit1Change(Sender: TObject);
begin
  if ListView1.Selected <> nil then
  begin
    ListView1.Selected.SubItems[0] := Edit1.Text;
  end;
end;

procedure TFRM_Notizen_Images_einstellungen.Button1Click(Sender: TObject);
begin
  OpenAndAdd;
end;

procedure TFRM_Notizen_Images_einstellungen.Button5Click(Sender: TObject);
begin
  if ListView1.Selected <> nil then
  if ColorDialog1.Execute then
  begin
    ListView1.Selected.SubItems[2] := IntToStr(ColorDialog1.Color);
  end;
end;

procedure TFRM_Notizen_Images_einstellungen.ListView1AdvancedCustomDrawItem(
  Sender: TCustomListView; Item: TListItem; State: TCustomDrawState;
  Stage: TCustomDrawStage; var DefaultDraw: Boolean);
begin
  Sender.Canvas.Brush.Color := StrToInt(Item.SubItems[2]);
end;

procedure TFRM_Notizen_Images_einstellungen.Button2Click(Sender: TObject);
begin
  if Application.MessageBox(PChar(STR_MSG_Alle_Bilder_Del),'clear',MB_YESNO or MB_ICONQUESTION) = idYes then
  begin
    ListView1.Items.Clear;
    ImageList1.Clear;
  end;
end;

procedure TFRM_Notizen_Images_einstellungen.ListView1SelectItem(
  Sender: TObject; Item: TListItem; Selected: Boolean);
begin
  if Item.Selected then
    Edit1.Text := Item.SubItems[0];
end;

procedure TFRM_Notizen_Images_einstellungen.FormCreate(Sender: TObject);
begin
  if SaveCaptions then SaveAllCaptions(Self,LangFile);
  if LoadCaptions then LoadAllCaptions(Self,LangFile);
end;

end.
