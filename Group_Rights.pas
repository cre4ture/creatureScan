unit Group_Rights;

interface                                                                 

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Prog_Unit, cS_networking, ComCtrls;

type
  TFRM_Group_Rights = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    TXT_Name: TEdit;
    Label2: TLabel;
    TXT_pass: TEdit;
    Label3: TLabel;
    CH_Systeme: TCheckBox;
    CH_Scans: TCheckBox;
    CH_Chat: TCheckBox;
    BTN_SystemGalaxien: TButton;
    BTN_Add: TButton;
    BTN_Entf: TButton;
    BTN_OK: TButton;
    BTN_Abbrechen: TButton;
    ListView1: TListView;
    CH_Raids: TCheckBox;
    BTN_ScanGalaxien: TButton;
    CH_Stats: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure BTN_SystemGalaxienClick(Sender: TObject);
    procedure BTN_AddClick(Sender: TObject);
    procedure BTN_EntfClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ListView1Data(Sender: TObject; Item: TListItem);
    procedure TXT_NameChange(Sender: TObject);
    procedure ListView1SelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure CH_SystemeKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure CH_SystemeMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private-Deklarationen }
  public
    Groups: array of TGroup;
    { Public-Deklarationen }
  end;

implementation

uses Galaxien_Rechte, Languages;

{$R *.DFM}

procedure TFRM_Group_Rights.FormCreate(Sender: TObject);
begin
  if SaveCaptions then SaveAllCaptions(Self,LangFile);
  if LoadCaptions then LoadAllCaptions(Self,LangFile);
end;

procedure TFRM_Group_Rights.BTN_SystemGalaxienClick(Sender: TObject);
var form: TFRM_Galaxy_Rights;
begin
  if ListView1.Selected <> nil then
  begin
    form := TFRM_Galaxy_Rights.Create(self);
    if Sender = BTN_ScanGalaxien then
    begin
      form.GRights := Groups[ListView1.Selected.Index].ScanGalaxys;
      form.typ := rt_ScanRaid;
    end
    else if Sender = BTN_SystemGalaxien then
    begin
      form.GRights := Groups[ListView1.Selected.Index].SystemGalaxys;
      form.typ := rt_Sonnensystem;
    end;
    if form.ShowModal = mrOK then
    begin
      if Sender = BTN_ScanGalaxien then
        Groups[ListView1.Selected.Index].ScanGalaxys := form.GRights
      else if Sender = BTN_SystemGalaxien then
        Groups[ListView1.Selected.Index].SystemGalaxys := form.GRights;
    end;
    form.Release;
  end;
end;

procedure TFRM_Group_Rights.BTN_AddClick(Sender: TObject);
var i: integer;
begin
  i := length(groups);
  SetLength(groups,i+1);
  FillChar(Groups[i],sizeof(Groups[i]),not(0));
  Groups[i].Name := STR_neu;
  Groups[i].Pass := '';
  ListView1.Items.Count := length(Groups);
  if ListView1.Selected <> nil then ListView1.Selected.Selected := false;
  ListView1.Items[i].Selected := True;
  ListView1.Selected.MakeVisible(False);
end;

procedure TFRM_Group_Rights.BTN_EntfClick(Sender: TObject);
var i: integer;
begin
 if ListView1.Selected <> nil then
 begin
  for i := ListView1.Selected.Index to Length(Groups)-2 do
  begin
    Groups[i] := Groups[i+1];
  end;
  Setlength(Groups,length(Groups)-1);
  ListView1.Items.Count := length(Groups);
  ListView1.Refresh;
 end;
end;

procedure TFRM_Group_Rights.FormShow(Sender: TObject);
begin
  ListView1.Items.Count := length(Groups);
  if length(Groups) = 0 then BTN_AddClick(Self);
end;

procedure TFRM_Group_Rights.ListView1Data(Sender: TObject;
  Item: TListItem);
begin
  if Item.Index < length(Groups) then
    Item.Caption := Groups[Item.Index].Name
  else Item.Caption := STR_Fehler;
end;

procedure TFRM_Group_Rights.TXT_NameChange(Sender: TObject);
begin  //Wichtig: diese Procedure darf !Nicht! als Ereignisbehandlungsroutine für onChange stehen!
  if ListView1.Selected <> nil then
  with Groups[ListView1.Selected.Index] do
  begin
    Name := TXT_Name.Text;
    Pass := TXT_pass.Text;
    Rights := [];
    if CH_Systeme.Checked then include(Rights,gr_System);
    if CH_Scans.Checked then include(Rights,gr_Scan);
    if CH_Chat.Checked then include(Rights,gr_Chat);
    if CH_Raids.Checked then include(Rights,gr_Raids);
    if CH_Stats.Checked then include(Rights,gr_Stats);
    ListView1.Selected.Update;
  end;
end;

procedure TFRM_Group_Rights.ListView1SelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
begin
  if Selected then
  with Groups[item.Index] do
  begin
    TXT_Name.Text := Name;
    TXT_pass.Text := Pass;
    CH_Systeme.Checked := gr_System in Rights;
    CH_Scans.Checked := gr_Scan in Rights;
    CH_Chat.Checked := gr_Chat in Rights;
    CH_Raids.Checked := gr_Raids in Rights;
    CH_Stats.Checked := gr_Stats in Rights;
  end;
end;

procedure TFRM_Group_Rights.CH_SystemeKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  TXT_NameChange(self);
end;

procedure TFRM_Group_Rights.CH_SystemeMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  TXT_NameChange(self);
end;

end.
