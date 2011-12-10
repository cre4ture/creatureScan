unit Chat;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, VirtualTrees, ComCtrls, Prog_Unit, TThreadSocketSplitter,
  Connections, OGame_Types, Menus, languages, MergeSocket, StatusThread,
  SplitSocket, cS_Networking;

type
  TMessageType = (mtChat, mtStatus, mtReloadStatus);
  TChatMSG = record
    Owner: TPlayerName_utf8;
    Chat: string[255];
    ID: Cardinal;
    MessageType: TMessageType;
  end;
  TChatMemberStatus = (cmsConnected, cmsInChat);
  TChatMember = record
    Name: TPlayerName_utf8;
    Status: TChatMemberStatus;
  end;
  TFRM_Chat = class(TForm)
    Panel1: TPanel;
    Edit1: TEdit;
    Splitter1: TSplitter;
    Memo1: TMemo;
    Panel2: TPanel;
    VST_Member: TVirtualStringTree;
    Panel3: TPanel;
    Button1: TButton;
    Panel4: TPanel;
    Panel5: TPanel;
    MainMenu1: TMainMenu;
    Fenster1: TMenuItem;
    immerimVordergrund1: TMenuItem;
    ChatMerge: TMergeSocketComponent;
    Timer1: TTimer;
    Panel6: TPanel;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure Button1Click(Sender: TObject);
    procedure VST_MemberGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: String);
    procedure VST_MemberPaintText(Sender: TBaseVirtualTree;
      const TargetCanvas: TCanvas; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType);
    procedure VST_MemberGetNodeDataSize(Sender: TBaseVirtualTree;
      var NodeDataSize: Integer);
    procedure FormHide(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure immerimVordergrund1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    LastCHATIDs: array[0..999] of Cardinal;
    LastCHATIDIndex: integer;
    function NewChatID(ID: Cardinal): Boolean;
    procedure AddChatID(ID: Cardinal);
    procedure NewPacket_nothread(Sender: TObject; var Data; Size: Word);
    procedure SetStatus(msg: TChatMSG);
    procedure SendStatus();
    procedure SendMSG_makeID(Chat: TChatMSG);
  protected
    PROCEDURE CreateParams(VAR Params: TCreateParams); OVERRIDE;
  public
    procedure Chat(S: string);
  end;

var
  FRM_Chat: TFRM_Chat;

implementation

{$R *.dfm}

procedure TFRM_Chat.AddChatID(ID: Cardinal);
begin
  LastCHATIDs[LastCHATIDIndex] := ID;
  inc(LastCHATIDIndex);
  if LastCHATIDIndex >= length(LastCHATIDs) then LastCHATIDIndex := 0;
end;

function TFRM_Chat.NewChatID(ID: Cardinal): Boolean;  //Überprüft, ob diese ID neu ist!
var i: integer;
begin
  for i := 0 to length(LastCHATIDs)-1 do
  begin
    Result := (ID = LastCHATIDs[i]);    //Wird nachher noch umgedreht!
    if Result then break;
  end;
  Result := not Result;
end;

procedure TFRM_Chat.NewPacket_nothread(Sender: TObject; var Data; Size: Word);
begin
  if (Size = Sizeof(TChatMSG))and(NewChatID(TChatMSG(Data).ID)) then
  with TChatMSG(Data) do
  begin
    case MessageType of
      mtChat: Memo1.Lines.Add('[' + TimeToStr(now) + '] <' + Owner + '> ' + Chat);
      mtStatus: SetStatus(TChatMSG(Data));
      mtReloadStatus: SendStatus();
    end;

    AddChatID(ID);
    if ID > 0 then
      ChatMerge.MergeSocket.SendPacket(Data,Size); //weiterleiten, auch an sender wieder zurück!
  end;
end;

procedure TFRM_Chat.Chat(S: string);
var Chat: TChatMSG;
begin
  Chat.Owner := ODataBase.Username;
  Chat.MessageType := mtChat;
  
  while (length(s) > 0) do
  begin
    Chat.Chat := copy(s,1,255);
    delete(s,1,255);

    SendMSG_makeID(Chat);
  end;
end;

procedure TFRM_Chat.FormCreate(Sender: TObject);
begin
  FillChar(LastCHATIDs,Sizeof(LastCHATIDs),0);
  LastCHATIDIndex := 0;
  Randomize;

  if SaveCaptions then SaveAllCaptions(Self,LangFile);
  if LoadCaptions then LoadAllCaptions(Self,LangFile);

{$ifdef CS_USE_NET_COMPS}
  cSServer.FChatMerge := ChatMerge.MergeSocket;
{$endif}
end;

procedure TFRM_Chat.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if (key = #13)and(Edit1.Text <> '') then
  begin
    Key := #0;
    Chat(Edit1.Text);
    Edit1.Text := '';
  end;
end;

procedure TFRM_Chat.SetStatus(msg: TChatMSG);
var node: PVirtualNode;
begin
  node := VST_Member.GetFirst;
  while (node <> nil) do
  begin
    with TChatMember(VST_Member.GetNodeData(node)^) do
    begin
      if (msg.Owner = Name) then
      begin
        break;
      end
      else node := VST_Member.GetNext(node);
    end;
  end;

  if node = nil then
  begin
    node := VST_Member.AddChild(nil);
  end;

  with TChatMember(VST_Member.GetNodeData(node)^) do
  begin
    Name := msg.Owner;
    if msg.Chat = 'conn' then Status := cmsConnected;
    if msg.Chat = 'chat' then Status := cmsInChat;
    VST_Member.Repaint;
  end;
end;

procedure TFRM_Chat.SendStatus();
var msg: TChatMSG;
begin
  msg.Owner := ODataBase.Username;
  msg.MessageType := mtStatus;

  if Visible then msg.Chat := 'chat'
  else msg.Chat := 'conn';

  SendMSG_makeID(msg);
end;

procedure TFRM_Chat.SendMSG_makeID(Chat: TChatMSG);
begin
  repeat Chat.ID := Cardinal(Random(high(Cardinal) div 2)) +
    Cardinal(Random(high(Cardinal) div 2)) + 3;
  until NewChatID(Chat.ID);

  ChatMerge.MergeSocket.SendPacket(Chat,sizeof(Chat));
end;

procedure TFRM_Chat.Button1Click(Sender: TObject);
var msg: TChatMSG;
begin
  VST_Member.Clear;

  msg.Owner := ODataBase.Username;
  msg.MessageType := mtReloadStatus;

  SendMSG_makeID(msg);
end;

procedure TFRM_Chat.VST_MemberGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: String);
begin
  with Tchatmember(VST_Member.GetNodeData(node)^) do
  begin
    CellText := Name;
  end;
end;

procedure TFRM_Chat.VST_MemberPaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
begin
  with Tchatmember(VST_Member.GetNodeData(node)^) do
  begin
    case Status of
      cmsConnected: TargetCanvas.Font.Color := VST_Member.Colors.DisabledColor;
      cmsInChat: TargetCanvas.Font.Color := VST_Member.Colors.HotColor;
    end;
  end;
end;

procedure TFRM_Chat.VST_MemberGetNodeDataSize(Sender: TBaseVirtualTree;
  var NodeDataSize: Integer);
begin
  NodeDataSize := Sizeof(TChatMember);
end;

procedure TFRM_Chat.FormHide(Sender: TObject);
begin
  SendStatus;
end;

procedure TFRM_Chat.FormShow(Sender: TObject);
begin
  SendStatus;
  Caption := Format(STR_ChatFenster_Caption,[ODataBase.Username,ODataBase.UniDomain]);
end;

procedure TFRM_Chat.immerimVordergrund1Click(Sender: TObject);
begin
  immerimVordergrund1.Checked := not immerimVordergrund1.Checked;
  if immerimVordergrund1.Checked
    then SetWindowPos(Handle,HWND_TOPMOST,0,0,0,0,SWP_NOMOVE OR SWP_NOSIZE)
    else SetWindowPos(Handle,HWND_NOTOPMOST,0,0,0,0,SWP_NOMOVE OR SWP_NOSIZE);
end;

PROCEDURE TFRM_Chat.CreateParams(VAR Params: TCreateParams);
begin
  INHERITED;
  Params.ExStyle := Params.ExStyle OR WS_EX_APPWINDOW;
  Params.WndParent:= 0;//Application.Handle;
end;

procedure TFRM_Chat.Timer1Timer(Sender: TObject);
var Data: pointer;
    Size: Word;
    Socket: TSplitSocket;
    e: Boolean;
    c: integer;
begin
  e := false;
  c := 10;
  while (not e)and(c > 0) do
  begin
    e := true;
    try
      ChatMerge.MergeSocket.RecvPacket(Data,Size,Socket,0);
      NewPacket_nothread(Socket,Data^,Size);
      FreeMem(Data);
      e := false;
    except
      on E: ETimeOut do ;
    end;
    dec(c);
  end;
end;

procedure TFRM_Chat.FormDestroy(Sender: TObject);
begin
{$ifdef CS_USE_NET_COMPS}
  cSServer.FChatMerge := nil;
{$endif}
end;

procedure TFRM_Chat.Button2Click(Sender: TObject);
var i: integer;
begin
  for i := 0 to 98 do
  begin
    Chat('AUTO#'+IntToStr(i));
  end;
end;

end.
