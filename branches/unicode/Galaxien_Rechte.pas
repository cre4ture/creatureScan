unit Galaxien_Rechte;
                                                                          
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, OGame_Types, Prog_Unit, Languages, cS_networking;

type
  TRightTyp = (rt_ScanRaid,rt_Sonnensystem,rt_Suche);
  TFRM_Galaxy_Rights = class(TForm)
    GroupBox1: TGroupBox;
    Button1: TButton;
    Button2: TButton;
    ch_allnone: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ch_allnoneClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    ch_Boxes: array of TCheckBox;
    GRights: TGalaxyRights;
    typ: TRightTyp;
    { Public-Deklarationen }
  end;

implementation

{$R *.DFM}

procedure TFRM_Galaxy_Rights.FormCreate(Sender: TObject);
var i: integer;
    mx,my: integer;
begin
  if SaveCaptions then SaveAllCaptions(Self,LangFile);
  if LoadCaptions then LoadAllCaptions(Self,LangFile);

  SetLength(ch_Boxes, max_Galaxy+1); //nullte element wird nicht verwendet!
  mx := 0;
  my := 0;
  for i := 1 to max_Galaxy do
  begin
    ch_Boxes[i] := TCheckBox.Create(Self);
    ch_Boxes[i].Parent := GroupBox1;
    ch_Boxes[i].Name := 'CH_auto_' + inttostr(i);
    ch_Boxes[i].Top := ((i-1) div 10)*16 +16;
    ch_Boxes[i].Left := 8 + (35*(i-(trunc((i-1)/10)*10)-1));
    ch_Boxes[i].Width := 30;
    ch_Boxes[i].Caption := IntToStr(i);
    if ch_Boxes[i].Top+ch_Boxes[i].Height > my then my := ch_Boxes[i].Top+ch_Boxes[i].Height;
    if ch_Boxes[i].left+ch_Boxes[i].Width > mx then mx := ch_Boxes[i].Left+ch_Boxes[i].Width;
  end;
  GroupBox1.Width := mx + 8;
  GroupBox1.Height := my + 8;
  ClientWidth := GroupBox1.Width;
  ClientHeight := GroupBox1.Height + 40;
end;

procedure TFRM_Galaxy_Rights.Button1Click(Sender: TObject);
var i: integer;
begin
  GRights := [];
  for i := 1 to max_Galaxy do
    if ch_Boxes[i].Checked then Include(GRights,i);
  ModalResult := mrOK;
end;

procedure TFRM_Galaxy_Rights.FormDestroy(Sender: TObject);
var i: integer;
begin
  for i := 1 to max_Galaxy do
    ch_Boxes[i].free;
end;

procedure TFRM_Galaxy_Rights.FormShow(Sender: TObject);
var i: integer;
    all: boolean;
begin
  all := true;
  for i := 1 to max_Galaxy do
  begin
    ch_Boxes[i].Checked := (i in GRights);
    if not ch_Boxes[i].Checked then
      all := false;
  end;
  ch_allnone.Checked := all;

  case typ of
    rt_ScanRaid: GroupBox1.Caption := STR_Scan_Raid_Rechte;
    rt_Sonnensystem: GroupBox1.Caption := STR_Sonnensystem_Rechte;
    rt_Suche: GroupBox1.Caption := STR_Suche_Galaxien;
  end;
end;

procedure TFRM_Galaxy_Rights.ch_allnoneClick(Sender: TObject);
var i: Integer;
begin
  for i := 1 to max_Galaxy do //nullte element wird nicht verwendet!
    ch_Boxes[i].Checked := ch_allnone.Checked;
end;

end.
