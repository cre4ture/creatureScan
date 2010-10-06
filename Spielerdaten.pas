unit Spielerdaten;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Spin, IniFiles, OGame_Types, languages, OGameData, quickupdate;

type
  TFRM_Spielerdaten = class(TForm)
    LBL_PlayerI1: TLabel;
    ed: TGroupBox;
    LBL_PlayerI2: TLabel;
    CB_OGame_Site: TComboBox;
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
    cb_redesign: TCheckBox;
    CB_OGame_Universename: TComboBox;
    btn_update: TButton;
    procedure CB_OGame_SiteChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure E_GalaKeyPress(Sender: TObject; var Key: Char);
    procedure BTN_OKClick(Sender: TObject);
    procedure E_UniChange(Sender: TObject);
    procedure btn_updateClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    ODB: TObject;
    procedure updateGameSites;
    { Private-Deklarationen }
  public
    game_domain: string;
    urlName: string;
    UniverseName: String;
    DefInTF: Boolean;
    GalaCount, SysCount: Integer;
    IngameName: String;
    HomePlanet: TPlanetPosition;
    SpeedFaktor: Single;
    TF_factor: Double;
    redesign: Boolean;
    function Execute: boolean;
    constructor Create(AOwner: TComponent; odb: TObject); reintroduce;
    { Public-Deklarationen }
  end;

implementation

uses Prog_Unit;

{$R *.DFM}

procedure TFRM_Spielerdaten.CB_OGame_SiteChange(Sender: TObject);
var i: integer;
    site: TGameSite;
begin
  CB_OGame_Universename.Items.Clear;
  CB_OGame_Universename.Text := '';
  if CB_OGame_Site.ItemIndex <> -1 then
  begin
    site := TOgameDataBase(ODB).game_data.GameSites[CB_OGame_Site.ItemIndex];
    for i := 0 to site.Count -1 do
      CB_OGame_Universename.Items.Add(site.UniverseList[i].name);
  end;
end;

constructor TFRM_Spielerdaten.Create(AOwner: TComponent; odb: TObject);
begin
  inherited Create(AOwner);
  Self.ODB := odb; 
end;

function TFRM_Spielerdaten.Execute: boolean;
var i: integer;
begin
  CB_OGame_Site.Text := game_domain;
  CB_OGame_Universename.Text := UniverseName;
  CH_DefInTF.Checked := DefInTF;
  txt_speedfaktor.Text := FloatToStr(SpeedFaktor);
  RB_GalaCount9.Checked := True;
  RB_GalaCount19.Checked := (GalaCount = 19);
  RB_GalaCount50.Checked := (GalaCount = 50);
  E_Spielername.Text := IngameName;
  E_Gala.Text := IntToStr(homeplanet.P[0]);
  E_System.Text := IntToStr(homeplanet.P[1]);
  E_Planet.Text := IntToStr(homeplanet.P[2]);
  cb_redesign.Checked := redesign;

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
    game_domain := CB_OGame_Site.Text;
    UniverseName := CB_OGame_Universename.Text;
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

    redesign := cb_redesign.Checked;
  end;
end;

procedure TFRM_Spielerdaten.FormCreate(Sender: TObject);
begin
  if SaveCaptions then SaveAllCaptions(Self,LangFile);
  if LoadCaptions then LoadAllCaptions(Self,LangFile);
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
     (CB_OGame_Universename.Text <> '')and
     (StrToFloat(txt_speedfaktor.Text) > 0)and
     (i > 0)and(i <= 100) then
    ModalResult := mrOk;
end;

procedure TFRM_Spielerdaten.E_UniChange(Sender: TObject);
var site, uni: integer;
    universe: TGameUniverse;
begin
  site := CB_OGame_Site.ItemIndex;
  if site >= 0 then
  begin
    uni := CB_OGame_Universename.ItemIndex;
    if uni >= 0 then
    begin
      universe := TOgameDataBase(ODB).
                    game_data.GameSites[site].UniverseList[uni];
      urlName := universe.urlName;
      case universe.galaxyCount of
        19: RB_GalaCount19.Checked := true;
        50: RB_GalaCount50.Checked := true;
        else RB_GalaCount9.Checked := true;
      end;
      txt_speedfaktor.Text := FloatToStr(universe.gameSpeedFactor);
      cb_TF_calc.Text := IntToStr(round(universe.tfFleetFactor*100));
      CH_DefInTF.Checked := (universe.tfDefFactor > 0);
      cb_redesign.Checked := universe.redesign_rules;
    end
    else
    begin
      urlName := CB_OGame_Universename.Text;
    end;
  end; 
end;

procedure TFRM_Spielerdaten.btn_updateClick(Sender: TObject);
var frm_quickupdate: Tfrm_quickupdate;
begin
  frm_quickupdate := Tfrm_quickupdate.Create(Self, ODB, false);
  try
    if frm_quickupdate.ShowModal = mrOk then
    begin
      TOgameDataBase(ODB).updateGameData;
      updateGameSites;
    end;
  finally
    frm_quickupdate.Free;
  end;
end;

procedure TFRM_Spielerdaten.FormShow(Sender: TObject);
begin
  updateGameSites;
end;

procedure TFRM_Spielerdaten.updateGameSites;
var i: integer;
begin
  CB_OGame_Site.Items.Clear;
  for i := 0 to TOgameDataBase(ODB).game_data.Count -1 do
    CB_OGame_Site.Items.Add(TOgameDataBase(ODB).game_data.GameSites[i].name);

  CB_OGame_Site.ItemIndex := 0;
  CB_OGame_SiteChange(Self);
end;

end.
