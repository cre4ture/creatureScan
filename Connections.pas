unit Connections;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,              
  ComCtrls, ExtCtrls, Ogame_Types, StdCtrls, Buttons, Shellapi, Spin,
  Prog_Unit, SplitSocket, Inifiles, TThreadSocketSplitter, cS_networking,
  UniTree;

const
  Server_Client_Section = 'ServerClientOptions';
  crOVersionName = 'creatureScan';
  crOVersionID = 5;

type
  TFRM_Connections = class(TForm)
    Timer1: TTimer;
    LV_Connections: TListView;
    Button3: TButton;
    GroupBox1: TGroupBox;
    Button2: TButton;
    BTN_Close: TButton;
    GroupBox2: TGroupBox;
    Label2: TLabel;
    Label9: TLabel;
    CheckBox1: TCheckBox;
    SpinEdit1: TSpinEdit;
    GroupBox3: TGroupBox;
    BTN_Verbinden: TButton;
    GroupBox5: TGroupBox;
    Label1: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    LBL_SendScans: TLabel;
    LBL_RecvScans: TLabel;
    Label6: TLabel;
    LBL_SendSys: TLabel;
    LBL_RecvSys: TLabel;
    Label3: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    GroupBox6: TGroupBox;
    LBL_Rights: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure LV_ConnectionsData(Sender: TObject; Item: TListItem);
    procedure CheckBox1Click(Sender: TObject);
    procedure BTN_CloseClick(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure BTN_VerbindenClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure LV_ConnectionsSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure FormHide(Sender: TObject);
  published
  private
    iniFile: string;
    //function ClHostOnDoLogin(Sender: TThread; ClientThread: TClientThread; ServerSite: Boolean): integer;
    { Private-Deklarationen }
  public

    { Public-Deklarationen }
  end;

var
  FRM_Connections: TFRM_Connections;

function ViewRights(rechte: TGroup): String;

implementation

uses Languages, Connect, KB_List, Chat;

{$R *.DFM}

procedure TFRM_Connections.FormCreate(Sender: TObject);
begin
  SendNotes := False;

  iniFile := ODataBase.PlayerInf;
  //SpeedButton1Click(self);
  if SaveCaptions then SaveAllCaptions(Self,LangFile);
  if LoadCaptions then LoadAllCaptions(Self,LangFile);
end;

procedure TFRM_Connections.LV_ConnectionsData(Sender: TObject;
  Item: TListItem);
begin
  if (Item.Index < cSServer.ConnectionCount) then
  with cSServer.Connections[Item.Index] do
  begin
    Item.Caption := IP + ':' + IntToStr(Port);
    Item.SubItems.Add(RemoteUser);
    Item.SubItems.Add(PositionToStrMond(AbsPlanetNrToPlanetPosition(UniSyncPos)));
    Item.SubItems.Add(IntToStr(SendBuffer));
  end;
end;

procedure TFRM_Connections.CheckBox1Click(Sender: TObject);
begin
  SpinEdit1.Enabled := not CheckBox1.Checked;
  if CheckBox1.Checked then
    cSServer.StartListen(SpinEdit1.Value)
  else cSServer.StopListen;
end;

procedure TFRM_Connections.BTN_CloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFRM_Connections.SpeedButton2Click(Sender: TObject);
begin
  ShellExecute(Self.Handle,'open','http://www.creax.de/myip.php?ref=cS','','',0);
end;

procedure TFRM_Connections.SpeedButton1Click(Sender: TObject);
begin
  FRM_Chat.Show;
end;

procedure TFRM_Connections.BTN_VerbindenClick(Sender: TObject);
var frm: TFRM_Connect;
    gr: TGroup;
begin
  frm := TFRM_Connect.Create(Self);
  try
    if frm.ShowModal = mrok then
    with cSServer.Users do
    begin
      LockUsers;
      try
        gr := Users[0];
      finally
        UnlockUsers;
      end;
      gr.Name := frm.txt_loginname.Text;
      gr.Pass := frm.txt_pw.Text;
      cSServer.ConnectTo(frm.txt_adress.Text, StrToInt(frm.txt_port.text), gr);
    end;
  finally
    frm.Free;
  end;
end;

procedure TFRM_Connections.Timer1Timer(Sender: TObject);
begin
  LV_Connections.Items.Count := cSServer.ConnectionCount;
  LV_Connections.Refresh;
  LV_ConnectionsSelectItem(self,LV_Connections.Selected,LV_Connections.Selected <> nil);
end;

procedure TFRM_Connections.Button3Click(Sender: TObject);
begin
  if LV_Connections.Selected <> nil then
    cSServer.Disconnect(LV_Connections.Selected.Index); 
end;

{function TFRM_Connections.ClHostOnDoLogin(Sender: TThread; ClientThread: TClientThread; ServerSite: Boolean): integer;
const ProcID = pi_TMain;
var VInf: TLoginData;
    NdLogin: Boolean;
    RemoteRights: TGroup;
    s: String[17];
begin
  {with ClientThread do
  with TClientThreadData(Data^) do
  begin
    //Senden der Versionsdaten zur Kontrolle!
    Result := -1;
    FillChar(VInf,Sizeof(VInf),0);
    VInf.ProgName := crOVersionName;
    VInf.protVersion := crOVersionID;
    VInf.Master := Server;
    VInf.Uni := ODataBase.UserUni;
    VInf.GalaxyCount := max_Galaxy;
    VInf.LangIndex := ODataBase.LangIndex;
    ClientThread.Status := '#1';
    SendBuf(VInf,Sizeof(VInf),ProcID, 'programinformation');
    FillChar(VInf,Sizeof(VInf),0);
    ClientThread.Status := '#2';
    RecvBuf(VInf,Sizeof(VInf),ProcID);
    if (VInf.ProgName = crOVersionName)and(VInf.protVersion = crOVersionID)and(VInf.Master = not Server)and
       (VInf.Uni = ODataBase.UserUni)and(VInf.LangIndex = ODataBase.LangIndex)and(VInf.GalaxyCount = max_Galaxy) then //Überprüfung auf Version + Uni + Sprache!
    begin
      //1.Schritt
      if Server then
      begin
        NdLogin := UseLogin;
        ClientThread.Status := '#3';
        SendBuf(NdLogin,sizeof(NdLogin),ProcID, 'ob Login erwartet (y/n)');
      end
      else
      begin
        ClientThread.Status := '#4';
        RecvBuf(NdLogin,Sizeof(NdLogin),ProcID);
      end;
      //2.Schritt
      ClientThread.Status := '#5';
      SendBuf(ODataBase.Username,Sizeof(ODataBase.Username),ProcID, 'Spielername');
      ClientThread.Status := '#6';
      RecvBuf(RemoteUser,Sizeof(RemoteUser),ProcID);
      //3.Schritt
      UserRights.Pass := '';
      UserRights.Name := '';
      ClientThread.Status := '#7';
      if NdLogin then Protocol.AddEntry('ID: ' + IntToHex(ClientThread.Handle,6),'Name: ' + RemoteUser + ' (Login required)')
                 else Protocol.AddEntry('ID: ' + IntToHex(ClientThread.Handle,6),'Name: ' + RemoteUser + ' (no Login required)');
      begin
        if Server then
        begin
          FillChar(RemoteRights,Sizeof(RemoteRights),0);
          ClientThread.Status := '#8';
          RecvBuf(RemoteRights,Sizeof(RemoteRights),ProcID);
          if NdLogin then UserRights := GetRights(RemoteRights) else UserRights := GeneralRights;
          ClientThread.Status := '#8.5';
          Protocol.AddEntry('ID: ' + IntToHex(ClientThread.Handle,6),'(Server)Rights: (' + UserRights.Name + ') ' + RightsToStr(UserRights));
          FusionRights(UserRights,RemoteRights);
          ClientThread.Status := '#9';
          SendBuf(UserRights,Sizeof(UserRights),ProcID, 'akzepierte Rechte');
        end
        else
        begin
          UserRights := GeneralRights;
          if NdLogin then SynchronizeNotifyEvent(ClientNeedLogin,ClientThread);
          RemoteRights := UserRights; //pass und login in Userrights gespeichert
          ClientThread.Status := '#10';
          SendBuf(RemoteRights,Sizeof(RemoteRights),ProcID, 'clientvorlage der Rechte');
          FillChar(RemoteRights,Sizeof(RemoteRights),0);
          ClientThread.Status := '#11';
          RecvBuf(RemoteRights,Sizeof(RemoteRights),ProcID);
          FusionRights(UserRights,RemoteRights);
          ClientThread.Status := '#12';
          Protocol.AddEntry('ID: ' + IntToHex(ClientThread.Handle,6),'(Client)Rights: ' + RightsToStr(UserRights));
        end;
      end;
      //4.Schritt
      s := 'READY-READY-READY';
      ClientThread.Status := '#13';
      SendBuf(s,Sizeof(s),ProcID, 'loginfertig-signal');
      ClientThread.Status := '#14';
      RecvBuf(s,Sizeof(s),ProcID);
      if s <> 'READY-READY-READY' then Exit;
      Result := 0; //Fertig!
    end else
    begin
      //Versionen Stimmen nicht! (Oder Server und Server bzw Client und Client!)
      Status := 'ERROR: different konfiguration!';
      Protocol.AddEntry('ID: ' + IntToHex(ClientThread.Handle,6),'Fehler beim Login: Versionsunterschied!');
    end;
    if Result <> 0 then
      Protocol.AddEntry('ID: ' + IntToHex(ClientThread.Handle,6),'Fehler im Login! -> Disconnect!');
  end; 
end; }

procedure TFRM_Connections.FormShow(Sender: TObject);
begin
  Timer1.Enabled := True;
end;

procedure TFRM_Connections.LV_ConnectionsSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
begin
  if Selected then
  with cSServer.Connections[Item.Index] do
  begin
    LBL_SendScans.Caption := IntToStr(SendScanCount);
    LBL_SendSys.Caption := IntToStr(SendSystemCount);
    LBL_RecvScans.Caption := IntToStr(RecvScanCount);
    LBL_RecvSys.Caption := IntToStr(RecvSystemCount);
    LBL_Rights.Lines.Text := ViewRights(UserRights);
  end
  else
  begin
    LBL_SendScans.Caption := '0';
    LBL_SendSys.Caption := '0';
    LBL_RecvScans.Caption := '0';
    LBL_RecvSys.Caption := '0';
    LBL_Rights.Lines.Text := '<Wähle eine Verbindung>';
  end;
end;

procedure TFRM_Connections.FormHide(Sender: TObject);
begin
  Timer1.Enabled := False;
end;

function ViewRights(rechte: TGroup): String;

  function grstostr(grs: TGalaxyRights): string;
  var ls: Integer;
      gr: TGalaxyRight;
  begin
    ls := -1;
    for gr := low(gr) to high(gr) do
    begin
      if (ls >= 0) and (gr in grs) then
        ;//nothing

      if (ls < 0)and(gr in grs) then
      begin
        Result := Result + IntToStr(gr);
        ls := gr;
      end;

      if (ls >= 0)and not(gr in grs) then
      begin
        if (ls = gr-1) then
          Result := Result + ', '
        else
          Result := Result + '..' + IntToStr(gr-1) + ', ';

        ls := -1;
      end;

      if (gr = high(gr)) then
      begin
        if (ls >= 0) then
          Result := Result + '..' + IntToStr(gr)
        else Result := Result + '-';
      end;
    end;
  end;

begin
  Result := '';
  if (gr_Scan in rechte.Rights) then
    Result := Result + 'report, ';
  if (gr_System in rechte.Rights) then
    Result := Result + 'solsys, ';
  if (gr_Raids in rechte.Rights) then
    Result := Result + 'fleet, ';
  if (gr_Chat in rechte.Rights) then
    Result := Result + 'chat, ';
  if (gr_Stats in rechte.Rights) then
    Result := Result + 'stats, ';

  Result := Result + 'galaxies: report(' + grstostr(rechte.ScanGalaxys) + ')';
  Result := Result + ' solsys(' + grstostr(rechte.SystemGalaxys) + ')';
end;

end.
