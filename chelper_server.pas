unit chelper_server;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TCPSocket, IdBaseComponent, IdThreadComponent;

type
  TOnTriggerReadFunction = procedure(const text, html: string) of object;
  Tfrm_cshelper_ctrl = class(TForm)
    CheckBox1: TCheckBox;
    Memo1: TMemo;
    Label1: TLabel;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cThreadRun(Sender: TSimpleClientThread;
      socket: TTCPSocket);
    procedure CheckBox1Click(Sender: TObject);
  private
    { Private-Deklarationen }
    server: TSimpleServer;
    c: TSimpleClientThread;
    port: integer;
    count: integer;
    procedure newClient(Sender: TObject; newSocket: TSocket);
    procedure triggerRead(Sender: TSimpleClientThread;
      Data: pointer);
  public
    OnTriggerRead: TOnTriggerReadFunction;
    procedure update(aPort: integer; active: boolean); reintroduce;
    { Public-Deklarationen }
  end;

var
  frm_cshelper_ctrl: Tfrm_cshelper_ctrl;

implementation

uses Math;

{$R *.dfm}

procedure Tfrm_cshelper_ctrl.FormCreate(Sender: TObject);
begin
  OnTriggerRead := nil;
  server := TSimpleServer.Create;
  server.OnClientConnect := newClient;
  count := 0;
  c := nil;
  port := 32432;
  Label2.Caption := Label2.Caption + IntToStr(port);
end;

procedure Tfrm_cshelper_ctrl.FormDestroy(Sender: TObject);
begin
  if (c <> nil) then
  begin
    c.Free;    
  end;
  server.Free;
end;

procedure Tfrm_cshelper_ctrl.newClient(Sender: TObject;
  newSocket: TSocket);
begin
  if (c <> nil) then
  begin
    c.Free;
  end;
  c := TSimpleClientThread.Create(newSocket);
  c.OnThreadRun := cThreadRun;
  c.OnSyncronise := triggerRead;
end;

procedure Tfrm_cshelper_ctrl.triggerRead(Sender: TSimpleClientThread;
    Data: pointer);
begin
  if Assigned(OnTriggerRead) then
    OnTriggerRead('', TStringList(Data).Text);
    
  //Memo1.Lines.Text := TStringList(Data).Text;
  inc(count);
  Label1.Caption := IntToStr(count);
end;

procedure Tfrm_cshelper_ctrl.update(aPort: integer; active: boolean);
begin
  if (server.ServerActive) then
  begin
    server.Stop;
    if c <> nil then
    begin
      c.Free;
      c := nil;
    end;
  end;

  port := aPort;

  if active then
  begin
    server.Start(port);
  end;

  CheckBox1.Checked := server.ServerActive;
end;

procedure Tfrm_cshelper_ctrl.cThreadRun(Sender: TSimpleClientThread;
  socket: TTCPSocket);
var buf: array[0..1023] of AnsiChar;
    line_utf8: AnsiString;
    line: string;
    rcv_length, i: integer;
    strList: TStringList;
begin
  strList := TStringList.Create;
  try
    line_utf8 := '';
    while (not Sender.Terminated) and socket.Connected do
    begin
      rcv_length := socket.ReceiveLength;
      if (rcv_length <= 0) then
        rcv_length := 1;
      if (rcv_length > 1024) then
        rcv_length := 1024;

      socket.ReceiveBuf(buf, rcv_length);

      for i := 0 to rcv_length-1 do
      begin
        line_utf8 := line_utf8 + buf[i];

        if (buf[i] = #13) then
        begin
          line := Utf8ToAnsi(line_utf8);
          strList.Add(line);
          if (trim(line) = 'CS:HELPER:END:OF:TRANSMISSION') then
          begin
            Sender.triggerSyncEvent(strList);
            strList.Clear;
          end;
          line_utf8 := '';
        end;
      end;
    end;
  except
  end;
  strList.Free;
end;

procedure Tfrm_cshelper_ctrl.CheckBox1Click(Sender: TObject);
begin
  if CheckBox1.Checked <> server.ServerActive then
    update(port, CheckBox1.Checked);
end;

end.
