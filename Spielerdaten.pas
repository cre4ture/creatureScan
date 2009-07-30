unit Spielerdaten;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Spin, IniFiles, OGame_Types, languages;

type
  TFRM_Spielerdaten = class(TForm)
    LBL_PlayerI1: TLabel;
    GB_PlayerI1: TGroupBox;
    LBL_PlayerI2: TLabel;
    E_Uni: TSpinEdit;
    CB_OGame_Language: TComboBox;
    BTN_OK: TButton;
    BTN_Abbrechen: TButton;
    LBL_PlayerI3: TLabel;
    RB_GalaCount9: TRadioButton;
    RB_GalaCount19: TRadioButton;
    RB_GalaCount50: TRadioButton;
    CH_DefInTF: TCheckBox;
    lbl_Speedfaktor: TLabel;
    txt_speedfaktor: TEdit;
    GroupBox1: TGroupBox;
    LBL_PlayerI4: TLabel;
    LBL_PlayerI5: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    E_Spielername: TEdit;
    E_Gala: TEdit;
    E_System: TEdit;
    E_Planet: TEdit;
    Label1: TLabel;
    cb_TF_calc: TComboBox;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure E_GalaKeyPress(Sender: TObject; var Key: Char);
    procedure BTN_OKClick(Sender: TObject);
    procedure E_UniChange(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    game_domain: string;
    Universe: Integer;
    DefInTF: Boolean;
    GalaCount, SysCount: Integer;
    IngameName: String;
    HomePlanet: TPlanetPosition;
    SpeedFaktor: Single;
    TF_factor: Double;
    function Execute: boolean;
    { Public-Deklarationen }
  end;

implementation

uses Prog_Unit;

{$R *.DFM}

function TFRM_Spielerdaten.Execute: boolean;
var i: integer;
begin
  CB_OGame_Language.Text := game_domain;
  E_Uni.Value := Universe;
  CH_DefInTF.Checked := DefInTF;
  txt_speedfaktor.Text := FloatToStr(SpeedFaktor);
  RB_GalaCount9.Checked := True;
  RB_GalaCount19.Checked := (GalaCount = 19);
  RB_GalaCount50.Checked := (GalaCount = 50);
  E_Spielername.Text := IngameName;
  E_Gala.Text := IntToStr(homeplanet.P[0]);
  E_System.Text := IntToStr(homeplanet.P[1]);
  E_Planet.Text := IntToStr(homeplanet.P[2]);

  i := round(TF_factor*100);
  if (i = 30)or(i = 0) then
    cb_TF_calc.ItemIndex := 0
  else
  if (i = 70) then
    cb_TF_calc.ItemIndex := 1
  else
    cb_TF_calc.Text := IntToStr(i);

  Result := (ShowModal = mrOk);
  if Result then
  begin
    game_domain := CB_OGame_Language.Text;
    Universe := E_Uni.Value;
    DefInTF := CH_DefInTF.Checked;
    SpeedFaktor := StrToFloat(txt_speedfaktor.Text);
    i := ReadInt(cb_TF_calc.Text,1,false);
    TF_factor := i /100;
    IngameName := E_Spielername.Text;
    
    GalaCount := 9;
    SysCount := 499;
    if RB_GalaCount19.Checked then
      GalaCount := 19; //und standart syscount = 499!

    if RB_GalaCount50.Checked then
    begin
      SysCount := 100;
      GalaCount := 50;
    end;

    try
      HomePlanet.P[0] := StrToInt(E_Gala.Text);
      HomePlanet.P[1] := StrToInt(E_System.Text);
      HomePlanet.P[2] := StrToInt(E_Planet.Text);
      HomePlanet.mond := False;
    except
      FillChar(HomePlanet,sizeof(HomePlanet),0);
    end;
  end;
end;

procedure TFRM_Spielerdaten.FormCreate(Sender: TObject);
var i: integer;
begin
  if SaveCaptions then SaveAllCaptions(Self,LangFile);
  if LoadCaptions then LoadAllCaptions(Self,LangFile);
  CB_OGame_Language.Items.Clear;
  for i := 0 to length(game_sites)-1 do
    CB_OGame_Language.Items.Add(game_sites[i]);
end;

procedure TFRM_Spielerdaten.FormPaint(Sender: TObject);
begin
  Application.BringToFront;
end;

procedure TFRM_Spielerdaten.E_GalaKeyPress(Sender: TObject; var Key: Char);
begin
  if not (key in ['0'..'9',#8]) then
    Key := #0;
end;

procedure TFRM_Spielerdaten.BTN_OKClick(Sender: TObject);
var i: integer;
begin
  i := ReadInt(cb_TF_calc.Text, 1, false);
  if (E_Spielername.Text <> '')and
     (E_Gala.Text <> '')and
     (E_System.Text <> '')and
     (E_Planet.Text <> '')and
     (E_Uni.Value > 0)and
     (StrToFloat(txt_speedfaktor.Text) > 0)and
     (i > 0)and(i <= 100) then
    ModalResult := mrOk;
end;

procedure TFRM_Spielerdaten.E_UniChange(Sender: TObject);
var U: Integer;
begin
  try
    U := E_Uni.Value;
  except
    U := -1;
  end;
  if (CB_OGame_Language.ItemIndex = 0) then //wenn ogame.de
  begin
    case U of
      18: RB_GalaCount19.Checked := True;
      50: RB_GalaCount50.Checked := True;
    else
      RB_GalaCount9.Checked := True;
    end;
  end;
end;

end.
