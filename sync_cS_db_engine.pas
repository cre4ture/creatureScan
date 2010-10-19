unit sync_cS_db_engine;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, config_cS_db_engine, IniFiles, OGame_Types;

type
  Tfrm_sync_cS_db_engine = class(TForm)
    cb_servers: TComboBox;
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    mem_log: TMemo;
    ProgressBar1: TProgressBar;
    btn_sync: TButton;
    Label2: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure btn_syncClick(Sender: TObject);
  private
    mini: TMemIniFile;
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
    mini.WriteString('cS_db_server', sname+'_url', frm.txt_url.text);
    mini.WriteString('cS_db_server', sname+'_user', frm.txt_username.text);
    mini.WriteString('cS_db_server', sname+'_pass', frm.txt_password.text);
    mini.WriteBool('cS_db_server', sname+'_auto', frm.cb_auto.checked);
    mini.WriteInteger('cS_db_server', sname+'_min', frm.se_min.value);

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
  frm.cb_auto.checked := mini.ReadBool('cS_db_server', sname+'_auto', frm.cb_auto.checked);
  frm.se_min.value := mini.ReadInteger('cS_db_server', sname+'_min', frm.se_min.value);

  if frm.ShowModal = mrOk then
  begin
    mini.WriteString('cS_db_server', sname+'_url', frm.txt_url.text);
    mini.WriteString('cS_db_server', sname+'_user', frm.txt_username.text);
    mini.WriteString('cS_db_server', sname+'_pass', frm.txt_password.text);
    mini.WriteBool('cS_db_server', sname+'_auto', frm.cb_auto.checked);
    mini.WriteInteger('cS_db_server', sname+'_min', frm.se_min.value);

    mini.UpdateFile;
    ReloadList();
  end;

  frm.Free;
end;

procedure Tfrm_sync_cS_db_engine.btn_syncClick(Sender: TObject);
var sname: string;
    tmp: TProgressBar;
    tmp_mem: TMemo;
    i: integer;
begin
  if btn_sync.Caption <> 'STOP' then
  begin

    sname := cb_servers.Text;
    if sname = '' then
    begin
      ShowMessage('Select a server!');
      Exit;
    end;

    mem_log.Clear;
    btn_sync.Caption := 'STOP';
    tmp := FRM_POST_TEST.pb_main;
    tmp_mem := FRM_POST_TEST.mem_log;
    FRM_POST_TEST.pb_main := ProgressBar1;
    FRM_POST_TEST.mem_log := mem_log;

    try

      FRM_POST_TEST.txt_url.Text := mini.ReadString('cS_db_server', sname+'_url', '');
      if not FRM_POST_TEST.do_login(mini.ReadString('cS_db_server', sname+'_user', ''),
                             mini.ReadString('cS_db_server', sname+'_pass', ''))
      then
      begin
        ShowMessage('Login Fehlgeschlagen. Evtl. stimmt der Username oder das Passwort nicht.');
        exit;
      end;

      //FRM_POST_TEST.Button4Click(Self);
      //FRM_POST_TEST.Button9Click(Self);

      FRM_POST_TEST.log('Start Sync...',10);

      FRM_POST_TEST.Stop := False;
      FRM_POST_TEST.Sync_Systems(self);
      for i := 1 to max_Galaxy do
        if not FRM_POST_TEST.Stop then
          FRM_POST_TEST.Sync_Report(i);

      FRM_POST_TEST.log('ready!!',10);

    finally

      FRM_POST_TEST.pb_main := tmp;
      FRM_POST_TEST.mem_log := tmp_mem;
      btn_sync.Caption := 'SYNC';

    end;
  end
  else
  begin

    FRM_POST_TEST.Button1Click(Self);

  end;
end;

procedure Tfrm_sync_cS_db_engine.FormCreate(Sender: TObject);
begin
  mini := TMemIniFile.Create(ODataBase.SaveDir+'cS_db_server.ini');
  ReloadList();
end;

procedure Tfrm_sync_cS_db_engine.FormDestroy(Sender: TObject);
begin
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

end.
