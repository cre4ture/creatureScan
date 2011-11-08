unit Connect;
                                            
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Prog_Unit, inifiles, Menus, html;

type
  TFRM_Connect = class(TForm)
    txt_adress: TEdit;
    Label1: TLabel;
    txt_port: TEdit;
    Label2: TLabel;
    ListBox1: TListBox;
    Label3: TLabel;
    btn_ok: TButton;
    btn_cancel: TButton;
    PopupMenu1: TPopupMenu;
    Entf1: TMenuItem;
    Verbinden1: TMenuItem;
    txt_loginname: TEdit;
    Label4: TLabel;
    txt_pw: TEdit;
    Label5: TLabel;
    cb_save_pw: TCheckBox;
    procedure ListBox1DblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure Entf1Click(Sender: TObject);
    procedure Verbinden1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    inifile: string;
    history: THTMLElement;
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

implementation

uses languages;

{$R *.DFM}

procedure TFRM_Connect.FormCreate(Sender: TObject);
var ini: TIniFile;
    c, i: integer;
    child: THTMLElement;
begin
  if SaveCaptions then SaveAllCaptions(Self,LangFile);
  if LoadCaptions then LoadAllCaptions(Self,LangFile);

  history := THTMLElement.Create(nil,'root');
  inifile := ODataBase.PlayerInf;
  ini := TIniFile.Create(inifile);
  try
    c := ini.ReadInteger('Connections','HostCount',0);
    for i := 0 to c-1 do
    begin
      child := THTMLElement.Create(history,'server');
      child.AttributeValue['host'] :=
                   ini.ReadString('Connections','Host'+inttostr(i),'0.0.0.0:0');
      child.AttributeValue['login'] :=
                   ini.ReadString('Connections','login'+inttostr(i),'');
      child.AttributeValue['pass'] :=
                   ini.ReadString('Connections','pass'+inttostr(i),'');
      ListBox1.Items.Add(child.AttributeValue['host']);
    end;
  finally
    ini.Free;
  end;
end;

procedure TFRM_Connect.btn_okClick(Sender: TObject);
var ini: TIniFile;
    i: integer;
    child: THTMLElement;
begin
  if txt_port.Text = '' then
    ShowMessage(STR_MSG_kein_port_eingegeben)
  else
  begin
    child := nil;
    for i := 0 to ListBox1.Items.Count-1 do
      if history.ChildElements[i].AttributeValue['host'] =
                              txt_adress.Text + ':' + txt_port.Text then
      begin
        child := history.ChildElements[i];
        break;
      end;
      
    if child = nil then
    begin
      child := THTMLElement.Create(history, 'server');
      child.AttributeValue['host'] := txt_adress.Text + ':' + txt_port.Text;
    end;

    child.AttributeValue['login'] := txt_loginname.Text;
    if cb_save_pw.Checked then
      child.AttributeValue['pass'] := txt_pw.Text
    else
      child.AttributeValue['pass'] := '';

    inifile := ODataBase.PlayerInf;
    ini := TIniFile.Create(inifile);
    ini.EraseSection('Connections');
    ini.WriteInteger('Connections','HostCount', history.ChildCount);
    for i := 0 to history.ChildCount-1 do
    begin
      ini.WriteString('Connections','Host'+inttostr(i),
                    history.ChildElements[i].AttributeValue['host']);
      ini.WriteString('Connections','login'+inttostr(i),
                    history.ChildElements[i].AttributeValue['login']);
      ini.WriteString('Connections','pass'+inttostr(i),
                    history.ChildElements[i].AttributeValue['pass']);
    end;
    ModalResult := mrOK;
  end;
end;

procedure TFRM_Connect.ListBox1Click(Sender: TObject);
var s: string;
    p: integer;
begin
  if ListBox1.ItemIndex <> -1 then
  begin
    s := history.ChildElements[ListBox1.itemindex].AttributeValue['host'];
    p := pos(':',S);
    txt_adress.Text := copy(s,1,p-1);
    txt_port.Text := copy(s,p+1,999);
    txt_loginname.Text :=
         history.ChildElements[ListBox1.itemindex].AttributeValue['login'];
    txt_pw.Text :=
         history.ChildElements[ListBox1.itemindex].AttributeValue['pass'];
    cb_save_pw.Checked := txt_pw.Text <> '';
  end;
end;

procedure TFRM_Connect.ListBox1DblClick(Sender: TObject);
begin
  if ListBox1.ItemIndex >= 0 then
  begin
    Verbinden1Click(Sender);
  end;
end;

procedure TFRM_Connect.Entf1Click(Sender: TObject);
begin
  if ListBox1.ItemIndex <> -1 then
  begin
    history.DeleteChildElement(ListBox1.itemindex);
    ListBox1.Items.Delete(ListBox1.itemindex);
  end;
end;

procedure TFRM_Connect.Verbinden1Click(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TFRM_Connect.FormDestroy(Sender: TObject);
begin
  history.Free;
end;

end.
