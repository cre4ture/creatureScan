unit sync_cS_db_engine;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, config_cS_db_engine, IniFiles, OGame_Types,
  Spin, ExtCtrls, XPMan;

type
  Tfrm_sync_cS_db_engine = class(TForm)
    XPManifest1: TXPManifest;
  published
    cb_servers: TComboBox;
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    mem_log: TMemo;
    ProgressBar1: TProgressBar;
    btn_sync: TButton;
    Label2: TLabel;
    cb_default: TCheckBox;
    se_time: TSpinEdit;
    tim_start_autosync: TTimer;
    Label3: TLabel;
    lbl_countdown: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure btn_syncClick(Sender: TObject);
    procedure tim_start_autosyncTimer(Sender: TObject);
    procedure cb_defaultClick(Sender: TObject);
    procedure cb_serversChange(Sender: TObject);
  private
    function getAutoSync: Boolean;
    procedure setAutoSync(const Value: Boolean);
    function getAutoTime: integer;
    procedure setAutoTime(const Value: integer);

    function DoSync(profile: string): boolean;
  private
    mini: TMemIniFile;

    last_sync: TDateTime;
    auto_sync_profile: string;
    function t_minus: TDateTime;
    property auto_sync_time: integer read getAutoTime write setAutoTime;
    property auto_sync: Boolean read getAutoSync write setAutoSync;
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  published
    procedure ReloadList;
  end;

var
  frm_sync_cS_db_engine: Tfrm_sync_cS_db_engine;

implementation

{$R *.dfm}

uses Prog_Unit, _test_POST;

procedure Tfrm_sync_cS_db_engine.Button1Click(Sender: TObject);
var frm: Tfrm_config_cS_engine;
    sname: string;
begin
  frm := Tfrm_config_cS_engine.Create(self);

  if frm.ShowModal = mrOk then
  begin
    sname := frm.txt_name.text;
    mini.WriteString ('cS_db_server', sname+'_url', frm.txt_url.text);
    mini.WriteString ('cS_db_server', sname+'_user', frm.txt_username.text);
    mini.WriteString ('cS_db_server', sname+'_pass', frm.txt_password.text);

    mini.WriteInteger('cS_db_server', sname+'_max_days', frm.se_max_days_age.Value);
    mini.WriteBool   ('cS_db_server', sname+'_dont_sync_del_planets', frm.cb_dont_sync_deletet_planets.Checked);

    mini.UpdateFile;
    ReloadList();
  end;

  frm.Free;
end;

procedure Tfrm_sync_cS_db_engine.Button2Click(Sender: TObject);
var frm: Tfrm_config_cS_engine;
    sname: string;
begin
  frm := Tfrm_config_cS_engine.Create(self);

  sname := cb_servers.Text;
  frm.txt_name.text := sname;
  frm.txt_name.Enabled := False;
  frm.txt_url.text := mini.ReadString('cS_db_server', sname+'_url', frm.txt_url.text);
  frm.txt_username.text := mini.ReadString('cS_db_server', sname+'_user', frm.txt_username.text);
  frm.txt_password.text := mini.ReadString('cS_db_server', sname+'_pass', frm.txt_password.text);
  frm.se_max_days_age.Value := mini.ReadInteger('cS_db_server', sname+'_max_days', frm.se_max_days_age.Value);
  frm.cb_dont_sync_deletet_planets.Checked := mini.ReadBool('cS_db_server', sname+'_dont_sync_del_planets', frm.cb_dont_sync_deletet_planets.Checked);

  if frm.ShowModal = mrOk then
  begin
    mini.WriteString('cS_db_server', sname+'_url', frm.txt_url.text);
    mini.WriteString('cS_db_server', sname+'_user', frm.txt_username.text);
    mini.WriteString('cS_db_server', sname+'_pass', frm.txt_password.text);

    mini.WriteInteger('cS_db_server', sname+'_max_days', frm.se_max_days_age.Value);
    mini.WriteBool   ('cS_db_server', sname+'_dont_sync_del_planets', frm.cb_dont_sync_deletet_planets.Checked);

    mini.UpdateFile;
    ReloadList();
  end;

  frm.Free;
end;

procedure Tfrm_sync_cS_db_engine.btn_syncClick(Sender: TObject);
begin
  if btn_sync.Caption <> 'STOP' then
  begin
    if cb_servers.Text = '' then
    begin
      ShowMessage('Select a server!');
      Exit;
    end;

    DoSync(cb_servers.Text);
  end
  else
  begin
    // Stop
    FRM_POST_TEST.Button1Click(Sender);
  end;
end;

procedure Tfrm_sync_cS_db_engine.FormCreate(Sender: TObject);
begin
  mini := TMemIniFile.Create(ODataBase.SaveDir+'cS_db_server.ini');
  last_sync := 0;

  auto_sync_profile :=
    mini.ReadString(
      'cS_db_server', 'auto_sync_profile', '');
  auto_sync :=
    mini.ReadBool(
      'cS_db_server', 'auto_sync_active', auto_sync);
  auto_sync_time :=
    mini.ReadInteger(
      'cS_db_server', 'auto_sync_time', auto_sync_time);

  cb_servers.Text := auto_sync_profile;
  cb_serversChange(Sender);

  ReloadList();
end;

procedure Tfrm_sync_cS_db_engine.FormDestroy(Sender: TObject);
begin
  mini.WriteString(
    'cS_db_server', 'auto_sync_profile', auto_sync_profile);
  mini.WriteBool(
    'cS_db_server', 'auto_sync_active', auto_sync);
  mini.WriteInteger(
    'cS_db_server', 'auto_sync_time', auto_sync_time);
  mini.UpdateFile;
  mini.Free;
end;

procedure Tfrm_sync_cS_db_engine.ReloadList;
var list: TStringList;
    i: integer;
    sname: string;
    last: string;
begin
  last := cb_servers.Text;
  
  cb_servers.Clear;
  list := TStringList.Create;
  mini.ReadSection('cS_db_server',list);
  for i := 0 to list.Count - 1 do
  begin
    if copy(list[i],length(list[i])-3,4) = '_url' then
    begin
      sname := copy(list[i],1,length(list[i])-4);
      cb_servers.Items.Add(sname);
      cb_servers.ItemIndex := 0;
    end;
  end;
  list.Free;

  cb_servers.ItemIndex := cb_servers.Items.IndexOf(last);
end;

procedure Tfrm_sync_cS_db_engine.tim_start_autosyncTimer(Sender: TObject);
begin
  tim_start_autosync.Enabled := false;
  try
    lbl_countdown.Caption := CountdownTimeToStr(t_minus) +
      ' (' + auto_sync_profile + ')';
    if t_minus <= 0 then
    begin
      if btn_sync.Caption <> 'STOP' then
      begin
        if not DoSync(auto_sync_profile) then
          auto_sync := false;
      end;
    end;
  finally
    tim_start_autosync.Enabled := true;
  end;
end;

procedure Tfrm_sync_cS_db_engine.cb_defaultClick(Sender: TObject);
begin
  se_time.Enabled := cb_default.Checked;
  if cb_default.Checked then
  begin
    auto_sync_profile := cb_servers.Text;
    auto_sync := true;
  end
  else
  if cb_servers.Text = auto_sync_profile then
    auto_sync := false;
end;

procedure Tfrm_sync_cS_db_engine.cb_serversChange(Sender: TObject);
begin
  cb_default.Enabled := (cb_servers.Text <> '');
  if cb_servers.Text = auto_sync_profile then
  begin
    cb_default.Checked := auto_sync;
  end
  else
    cb_default.Checked := false;
end;

function Tfrm_sync_cS_db_engine.getAutoSync: Boolean;
begin
  Result := tim_start_autosync.Enabled;
end;

procedure Tfrm_sync_cS_db_engine.setAutoSync(const Value: Boolean);
begin
  tim_start_autosync.Enabled := Value;
  if Value then
  begin

  end
  else
  begin
    lbl_countdown.Caption := '<aus>';
  end; 
end;

function Tfrm_sync_cS_db_engine.getAutoTime: integer;
begin
  if se_time.Text = '' then
    Result := 15
  else
    Result := se_time.Value;
end;

procedure Tfrm_sync_cS_db_engine.setAutoTime(const Value: integer);
begin
  se_time.Value := Value;
end;

function Tfrm_sync_cS_db_engine.t_minus: TDateTime;
begin
  Result :=
    // max_age
    (auto_sync_time * (1/24/60)) // minuten
    -
    // actual age
    (now - last_sync);
end;

function Tfrm_sync_cS_db_engine.DoSync(profile: string): boolean;
var tmp: TProgressBar;
    tmp_mem: TMemo;
    i: integer;
    uname: string;
    typ: TStatTypeEx;
    ntyp: TStatNameType;
    ptyp: TStatPointType;
begin
  Result := false;
  
  if btn_sync.Caption <> 'STOP' then
  begin

    if profile = auto_sync_profile then
      last_sync := Now;

    mem_log.Clear;
    btn_sync.Caption := 'STOP';
    tmp := FRM_POST_TEST.pb_main;
    tmp_mem := FRM_POST_TEST.mem_log;
    FRM_POST_TEST.pb_main := ProgressBar1;
    FRM_POST_TEST.mem_log := mem_log;
    FRM_POST_TEST.se_max_days_age.Value :=
      mini.ReadInteger('cS_db_server', profile+'_max_days', 90);
    FRM_POST_TEST.cb_filter_no_planet.Checked :=
      mini.ReadBool('cS_db_server', profile+'_dont_sync_del_planets', false);

    try

      FRM_POST_TEST.log('start sync with server: ' + profile,10);

      uname := mini.ReadString('cS_db_server', profile+'_user', '');
      FRM_POST_TEST.txt_url.Text := mini.ReadString('cS_db_server', profile+'_url', '');
      FRM_POST_TEST.log('try login with username: ' + uname,10);
      if not FRM_POST_TEST.do_login(uname,
                             mini.ReadString('cS_db_server', profile+'_pass', ''))
      then
      begin
        FRM_POST_TEST.log
          ('Login Fehlgeschlagen. Evtl. stimmt der Username oder das Passwort nicht.', 10);
        exit;
      end;

      FRM_POST_TEST.log('login success!',10);

      //FRM_POST_TEST.Button4Click(Self);
      //FRM_POST_TEST.Button9Click(Self);

      FRM_POST_TEST.Stop := False;
      FRM_POST_TEST.Sync_Systems(self);
      for i := 1 to max_Galaxy do
        if not FRM_POST_TEST.Stop then
          FRM_POST_TEST.Sync_Report(i);

      for ntyp := low(ntyp) to high(ntyp) do
      if not FRM_POST_TEST.Stop then
      begin
        for ptyp := low(ptyp) to high(ptyp) do
        if not FRM_POST_TEST.Stop then
        begin
          typ.NameType := ntyp;
          typ.PointType := ptyp;
          FRM_POST_TEST.Sync_Stats(typ);
        end;
      end;

      FRM_POST_TEST.log('ready!!',10);

    finally

      FRM_POST_TEST.pb_main := tmp;
      FRM_POST_TEST.mem_log := tmp_mem;
      btn_sync.Caption := 'SYNC';

    end;
  end;
  Result := true;
end;

end.
