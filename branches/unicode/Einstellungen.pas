unit Einstellungen;

interface                                                             

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, Tabnotbk, Prog_Unit, OGame_Types, Spin, ExtCtrls,
  {$ifdef CS_USE_NET_COMPS}cS_networking,{$endif} inifiles,
  Mask;
                                                                   
type
  TFRM_Einstellungen = class(TForm)
    Button1: TButton;
    Button2: TButton;
    PageControl1: TPageControl;
    TS_allgemein: TTabSheet;
    CH_AutoUpdate: TCheckBox;
    TS_FleetDef: TTabSheet;
    LBL_FD: TLabel;
    LB_FD: TListBox;
    TXT_FD: TEdit;
    TS_Angriffsberechnung: TTabSheet;
    GroupBox3: TGroupBox;
    RB_Dragologic: TRadioButton;
    RB_PlanDBlogic: TRadioButton;
    GroupBox4: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    TXT_Schlachter_Laderaum: TEdit;
    TXT_Transporter_Laderaum: TEdit;
    TXT_Schlachter_Treibstoff: TEdit;
    TXT_Transporter_Treibstoff: TEdit;
    TXT_RaidStart: TEdit;
    TS_Farben: TTabSheet;
    TS_Direktverbindung: TTabSheet;
    GroupBox5: TGroupBox;
    sync_scans: TCheckBox;
    sync_systems: TCheckBox;
    GroupBox6: TGroupBox;
    ch_startupServer: TCheckBox;
    Button3: TButton;
    CH_Chat: TCheckBox;
    BTN_ScanGalaxy_Rights: TButton;
    TXT_ServerStartPort: TEdit;
    Label16: TLabel;
    sync_Raids: TCheckBox;
    TS_Notizen: TTabSheet;
    Button4: TButton;
    Button5: TButton;
    TS_ScansSysteme: TTabSheet;
    GroupBox1: TGroupBox;
    Label13: TLabel;
    Label14: TLabel;
    CH_AddNewScan: TCheckBox;
    CH_ShowCountScan: TCheckBox;
    CH_AutoDelete: TCheckBox;
    TXT_maxhourstoadd: TEdit;
    BTN_ChangeSpielerdaten: TButton;
    BTN_LangPlugin: TButton;
    BTN_Sprachdatei: TButton;
    Label17: TLabel;
    LBL_Plugin: TLabel;
    Label18: TLabel;
    LBL_Sprachdatei: TLabel;
    TS_SuchLink: TTabSheet;
    Label19: TLabel;
    TXT_Spielersuche: TEdit;
    Label20: TLabel;
    Label21: TLabel;
    TXT_SuchenName: TEdit;
    TXT_Allysuche: TEdit;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    TC_Farben: TTabControl;
    PB_ColorsScan: TPaintBox;
    ALabel6: TLabel;
    LBL_Scan_Start: TLabel;
    ALabel9: TLabel;
    LBL_Scan_End: TLabel;
    TXT_ColorMax: TEdit;
    LBL_Scan_half: TLabel;
    Label15: TLabel;
    BTN_SystemGalaxie_rights: TButton;
    sync_Stats: TCheckBox;
    GroupBox8: TGroupBox;
    CH_MiniSysTray: TCheckBox;
    Label7: TLabel;
    TXT_SS: TEdit;
    TXT_gT: TEdit;
    btn_plugin_options: TButton;
    TS_GalaxieExplorer: TTabSheet;
    GroupBox7: TGroupBox;
    Label6: TLabel;
    RB_Explorer_genaueZeitangabe: TRadioButton;
    RB_Explorer_nurDatum: TRadioButton;
    GroupBox9: TGroupBox;
    CH_explorer_MouseOver: TCheckBox;
    GroupBox10: TGroupBox;
    LBL_TF1: TLabel;
    TXT_TF_markierung_groesse: TEdit;
    Label1: TLabel;
    TXT_Flugzeit: TEdit;
    cb_start_systray: TCheckBox;
    Label8: TLabel;
    ts_Flotten: TTabSheet;
    cb_fleet_popup_enabled: TCheckBox;
    txts_fleet_popup_time_s: TSpinEdit;
    Label9: TLabel;
    cb_fleet_alert_sound: TCheckBox;
    txt_fleet_alert_sound: TEdit;
    Button6: TButton;
    od_sound: TOpenDialog;
    Button7: TButton;
    TabSheet1: TTabSheet;
    GroupBox2: TGroupBox;
    CH_Clipboard: TCheckBox;
    CH_Unicheck: TCheckBox;
    GroupBox11: TGroupBox;
    Label2: TLabel;
    CB_FakeClipbrdViewer: TCheckBox;
    TXT_FakeCVIntervall: TEdit;
    GroupBox12: TGroupBox;
    cb_auto_fav_list: TCheckBox;
    GroupBox13: TGroupBox;
    cb_auto_serverzeit: TCheckBox;
    cb_check_solsys_data_for_moon: TCheckBox;
    ColorDialog1: TColorDialog;
    GroupBox14: TGroupBox;
    lbl_vacation: TLabel;
    lbl_noob: TLabel;
    lbl_inactive: TLabel;
    sh_lbl_vacation: TShape;
    sh_lbl_noob: TShape;
    sh_lbl_inactive: TShape;
    Shape4: TShape;
    txt_UniCheckName: TEdit;
    Label11: TLabel;
    cb_no_moon: TCheckBox;
    TS_Websim: TTabSheet;
    GroupBox15: TGroupBox;
    Label12: TLabel;
    se_tech_0: TSpinEdit;
    Label25: TLabel;
    se_tech_1: TSpinEdit;
    Label26: TLabel;
    se_tech_2: TSpinEdit;
    Label27: TLabel;
    se_engine_0: TSpinEdit;
    Label28: TLabel;
    se_engine_1: TSpinEdit;
    Label29: TLabel;
    se_engine_2: TSpinEdit;
    Label30: TLabel;
    Label10: TLabel;
    GroupBox16: TGroupBox;
    Label31: TLabel;
    cb_cshelper_listener: TCheckBox;
    txt_cshelper_listener_port: TEdit;
    CH_Beep: TCheckBox;
    txt_beep_sound_file: TEdit;
    btn_play1: TButton;
    btn_select1: TButton;
    cb_fleet_msg_auto_close: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure LB_FDClick(Sender: TObject);
    procedure KeyPress_OnlyNumbers(Sender: TObject; var Key: Char);
    procedure TXT_FDChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TXT_ColorMaxChange(Sender: TObject);
    procedure TXT_RaidStartKeyPress(Sender: TObject; var Key: Char);
    procedure BTN_ScanGalaxy_RightsClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure BTN_SprachdateiClick(Sender: TObject);
    procedure BTN_LangPluginClick(Sender: TObject);
    procedure BTN_ChangeSpielerdatenClick(Sender: TObject);
    procedure TC_FarbenChanging(Sender: TObject; var AllowChange: Boolean);
    procedure TC_FarbenChange(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure btn_plugin_optionsClick(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure btn_play1Click(Sender: TObject);
    procedure btn_select1Click(Sender: TObject);
    procedure lbl_vacationClick(Sender: TObject);
    procedure CH_UnicheckClick(Sender: TObject);
  private
    procedure RefreshPluginSprachdatei;
    { Private-Deklarationen }
  public
    FDRessValues: array of Integer;
    FDValues: array of integer;
{$ifdef CS_USE_NET_COMPS}
    ClientGroup: TGroup;
    Groups: array of TGroup;
{$endif}
    RedHours: TRedHours;
    { Public-Deklarationen }
  end;

implementation

uses {$ifdef CS_USE_NET_COMPS}Galaxien_Rechte, Group_Rights,{$endif} Languages, Notizen, Uebersicht, Main;

{$R *.DFM}

procedure TFRM_Einstellungen.FormCreate(Sender: TObject);
var i: integer;
    sg: TScanGroup;
begin
  for sg := sg_Flotten to sg_Verteidigung do
    for i := 1 to ScanFileCounts[sg] do
      LB_FD.Items.Add(ODataBase.LanguagePlugIn.SBItems[sg][i]);

  SetLength(FDRessValues,LB_FD.Items.Count);
  SetLength(FDValues,LB_FD.Items.Count);

  if SaveCaptions then SaveAllCaptions(Self,LangFile);
  if LoadCaptions then LoadAllCaptions(Self,LangFile);
  
  PageControl1.ActivePageIndex := 0;
  RefreshPluginSprachdatei;
end;

procedure TFRM_Einstellungen.LB_FDClick(Sender: TObject);
begin
  LBL_FD.Caption := '1 ' + LB_FD.Items[LB_FD.Itemindex] + STR_gibt_Basispunkte;
  TXT_FD.Text := IntToStr(FDValues[LB_FD.ItemIndex]);
end;

procedure TFRM_Einstellungen.KeyPress_OnlyNumbers(Sender: TObject;
  var Key: Char);
begin
  if not(AnsiChar(Key) in ['0'..'9',#8]) then
    Key := #0;
end;

procedure TFRM_Einstellungen.TXT_FDChange(Sender: TObject);
begin
  if TXT_FD.Text <> '' then
    FDValues[LB_FD.ItemIndex] := StrToInt(TXT_FD.Text);
end;

procedure TFRM_Einstellungen.FormShow(Sender: TObject);
begin
  LB_FD.ItemIndex := 0;
  LB_FDClick(self);
  TC_Farben.OnChange(self);
{$ifdef CS_USE_NET_COMPS}
  sync_scans.Checked := (gr_Scan in ClientGroup.Rights);
  sync_systems.Checked := (gr_System in ClientGroup.Rights);
  sync_Raids.Checked := (gr_Raids in ClientGroup.Rights);
  CH_Chat.Checked := (gr_Chat in ClientGroup.Rights);
  sync_Stats.Checked := (gr_Stats in ClientGroup.Rights);
{$else}
  TS_Direktverbindung.Visible := false;
{$endif}
  CH_UnicheckClick(CH_Unicheck);
end;

procedure TFRM_Einstellungen.TXT_ColorMaxChange(Sender: TObject);
var x: integer;
    step: single;
    maxhours: integer;
begin
  if (TXT_ColorMax.Text <> '')and(StrToInt(TXT_ColorMax.Text) <> 0) then
  begin
    case TC_Farben.TabIndex of
    0..2:
    begin
      maxhours := StrToInt(TXT_ColorMax.Text);
      step := (maxhours/24) / PB_ColorsScan.Width;
      for x := 0 to PB_ColorsScan.Width do
      begin
        PB_ColorsScan.Canvas.Pen.Color := AlterToColor_dt(step*x,maxhours);
        PB_ColorsScan.Canvas.MoveTo(x,0);
        PB_ColorsScan.Canvas.LineTo(x,PB_ColorsScan.Height);
      end;

      ALabel6.Caption := STR_Farben_Aelter_als;
      ALabel9.Caption := STR_Farben_Stunden_rot;

      LBL_Scan_half.Caption := IntToStr(maxhours div 2);
      LBL_Scan_End.Caption := IntToStr(maxhours);
      LBL_Scan_Start.Caption := '0';
    end;
    3:
    begin
      maxhours := StrToInt(TXT_ColorMax.Text);
      step := maxhours / (PB_ColorsScan.Width/2);

      ALabel6.Caption := STR_Farben_mehr_als;
      ALabel9.Caption := STR_Farben_punkte_unterschied_rotgruen;

      LBL_Scan_half.Caption := STR_Farben_eigene_Punkte;
      LBL_Scan_End.Caption := '+' + IntToStrKP(maxhours);
      LBL_Scan_Start.Caption := '-' + IntToStrKP(maxhours);

      for x := 0 to PB_ColorsScan.Width do
      begin
        PB_ColorsScan.Canvas.Pen.Color := dPunkteToColor(trunc(step*(x - (PB_ColorsScan.Width/2))),maxhours);
        PB_ColorsScan.Canvas.MoveTo(x,0);
        PB_ColorsScan.Canvas.LineTo(x,PB_ColorsScan.Height);
      end;
    end;
    end;
  end;
end;

procedure TFRM_Einstellungen.TXT_RaidStartKeyPress(Sender: TObject;
  var Key: Char);
begin
  if not(AnsiChar(Key) in ['0'..'9',#8,':',' ','M']) then
    Key := #0;
end;

procedure TFRM_Einstellungen.BTN_ScanGalaxy_RightsClick(Sender: TObject);
{$ifdef CS_USE_NET_COMPS}
var form: TFRM_Galaxy_Rights;
begin
  form := TFRM_Galaxy_Rights.Create(self);
  if Sender = BTN_ScanGalaxy_Rights then
  begin
    form.GRights := ClientGroup.ScanGalaxys;
    form.typ := rt_ScanRaid;
  end
  else if Sender = BTN_SystemGalaxie_rights then
  begin
    form.GRights := ClientGroup.SystemGalaxys;
    form.typ := rt_Sonnensystem;
  end;
  if form.ShowModal = mrOK then
  begin
    if Sender = BTN_ScanGalaxy_Rights then
      ClientGroup.ScanGalaxys := form.GRights
    else if Sender = BTN_SystemGalaxie_rights then
      ClientGroup.SystemGalaxys := form.GRights;
  end;
  form.Release;
{$else}
begin
{$endif}
end;

procedure TFRM_Einstellungen.Button3Click(Sender: TObject);
{$ifdef CS_USE_NET_COMPS}
var form: TFRM_Group_Rights;
    i: integer;
begin
  form := TFRM_Group_Rights.Create(self);
  setlength(form.Groups,length(Groups));
  for i := 0 to length(Groups)-1 do
    form.Groups[i] := Groups[i];
  if form.ShowModal = mrOK then
  begin
    setlength(Groups,length(form.Groups));
    for i := 0 to length(Groups)-1 do
      Groups[i] := form.Groups[i];
  end;
  form.Release;
{$else}
begin
{$endif}
end;

procedure TFRM_Einstellungen.Button4Click(Sender: TObject);
begin
  frm_notizen.EditImages;
end;

procedure TFRM_Einstellungen.Button5Click(Sender: TObject);
begin
  if Application.MessageBox(PChar(STR_MSG_Standart_Images),'standart',MB_YESNO or MB_ICONQUESTION) = idYes then
  begin
    FRM_Notizen.ClearAndLoadStandartImages;
  end;
end;

procedure TFRM_Einstellungen.BTN_SprachdateiClick(Sender: TObject);
var ini: TIniFile;
begin
  if SelectLanguageDialog then
  begin
    ini := TIniFile.Create(ODataBase.PlayerInf);
    ini.WriteString('Language','LanguageFile',LangFile);
    ini.UpdateFile;
    ini.free;
    LanguageFile(LangFile);
    ShowMessage(STR_Erst_Nach_neustart_Wirksam);
  end;
  RefreshPluginSprachdatei;
end;

procedure TFRM_Einstellungen.BTN_LangPluginClick(Sender: TObject);
begin
  if ODataBase.SelectPlugIn(True) then
  begin
    ODataBase.SaveUserOptions;
  end;
  RefreshPluginSprachdatei;
end;

procedure TFRM_Einstellungen.RefreshPluginSprachdatei;
begin
  LBL_Plugin.Caption := string(ODataBase.LanguagePlugIn.PlugInName);
  LBL_Sprachdatei.Caption := STR_Sprache;
end;

procedure TFRM_Einstellungen.BTN_ChangeSpielerdatenClick(Sender: TObject);
var P: TPlanetPosition;
begin
  if ODataBase.CheckUserOptions(True) then
  begin
    ODataBase.SaveUserOptions;
    FRM_Uebersicht.OnCreate(self);
    FillChar(P,sizeof(P),0);
    FRM_Main.RefreshExplorers(P);
  end;
end;

procedure TFRM_Einstellungen.TC_FarbenChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
  AllowChange := TXT_ColorMax.Text <> '';
  if AllowChange then
    redHours[TredHoursTypes(TC_Farben.TabIndex)] := StrToInt(TXT_ColorMax.Text);
end;

procedure TFRM_Einstellungen.TC_FarbenChange(Sender: TObject);
begin
  TXT_ColorMax.Text := IntToStr(redHours[TredHoursTypes(TC_Farben.TabIndex)]);
end;

procedure TFRM_Einstellungen.FormHide(Sender: TObject);
var b: boolean;
begin
  TC_Farben.OnChanging(Self,b);
{$ifdef CS_USE_NET_COMPS}
  ClientGroup.Rights := [];
  if sync_scans.Checked then include(ClientGroup.Rights,gr_Scan);
  if sync_systems.Checked then include(ClientGroup.Rights,gr_System);
  if CH_Chat.Checked then include(ClientGroup.Rights,gr_Chat);
  if sync_Raids.Checked then include(ClientGroup.Rights,gr_Raids);
  if sync_Stats.Checked then include(ClientGroup.Rights,gr_Stats);
{$endif}
end;

procedure TFRM_Einstellungen.btn_plugin_optionsClick(Sender: TObject);
begin
  ODataBase.LanguagePlugIn.RunOptions;
end;

procedure TFRM_Einstellungen.Button6Click(Sender: TObject);
begin
  od_sound.FileName := txt_fleet_alert_sound.Text;
  if od_sound.Execute then
  begin
    txt_fleet_alert_sound.Text := od_sound.FileName;
  end;
end;

procedure TFRM_Einstellungen.Button7Click(Sender: TObject);
begin
  FRM_Main.Play_Alert_Sound(txt_fleet_alert_sound.Text);

  if FileExists(txt_fleet_alert_sound.Text) then
    txt_fleet_alert_sound.Color := cllime
  else
    txt_fleet_alert_sound.Color := clRed;
end;

procedure TFRM_Einstellungen.btn_play1Click(Sender: TObject);
begin
  FRM_Main.Play_Alert_Sound(txt_beep_sound_file.Text);

  if FileExists(txt_beep_sound_file.Text) then
    txt_beep_sound_file.Color := cllime
  else
    txt_beep_sound_file.Color := clRed;

end;

procedure TFRM_Einstellungen.btn_select1Click(Sender: TObject);
begin
  od_sound.FileName := txt_beep_sound_file.Text;
  if od_sound.Execute then
  begin
    txt_beep_sound_file.Text := od_sound.FileName;
  end;

end;

procedure TFRM_Einstellungen.lbl_vacationClick(Sender: TObject);
var sh: TShape;
    comp: TComponent;
    lbl: TLabel;
begin
  lbl := Sender as TLabel;
  comp := FindComponent('sh_'+lbl.Name);
  if comp = nil then exit;
  sh := comp as TShape;

  ColorDialog1.Color := sh.Brush.Color;
  if ColorDialog1.Execute then
  begin
    sh.Brush.Color := ColorDialog1.Color;
  end;
end;

procedure TFRM_Einstellungen.CH_UnicheckClick(Sender: TObject);
begin
  txt_UniCheckName.Enabled := CH_Unicheck.Checked;
end;

end.


