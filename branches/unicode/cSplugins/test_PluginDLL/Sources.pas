unit Sources;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ClipboardViewerForm, clipbrdfunctions, DLL_plugin_TEST,
  Inifiles, dateutils;

type
  TFRM_Sources = class(TClipboardViewer)
    m_Text: TMemo;
    Label1: TLabel;
    m_Html: TMemo;
    Label2: TLabel;
    CB_Clipboard: TCheckBox;
    Button1: TButton;
    OpenDialog1: TOpenDialog;
    m_fileinfo: TMemo;
    Label3: TLabel;
    Button2: TButton;
    SaveDialog1: TSaveDialog;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    procedure Button5Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ClipbrdChanged(Sender: TObject);
    procedure CB_ClipboardClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure m_TextChange(Sender: TObject);
    procedure m_HtmlChange(Sender: TObject);
  private
    clpCopy: TClipbrdCopy;
    procedure cshelper_trigger(const text, html: string);
    { Private-Deklarationen }
  public
    plugin_handle: Integer;
    lastsourcefile: string;
    last_change_time: Int64;
    procedure OnPluginRefresh;
    procedure LoadFromFile(filename: string);
    procedure SaveToFile(filename: string);
    procedure LoadOptions(ini: TInifile);
    { Public-Deklarationen }
  end;

var
  FRM_Sources: TFRM_Sources;

implementation

uses chelper_server, cS_utf8_conv;

{$R *.dfm}

procedure TFRM_Sources.LoadOptions(ini: TInifile);
begin
  lastsourcefile := ini.ReadString('dir','stdclipboarddir',GetCurrentDir);
end;

procedure TFRM_Sources.m_HtmlChange(Sender: TObject);
begin
  try
    last_change_time := DateTimeToUnix(Now);
    plugin.SetReadSourceHTML(plugin_handle, trnsltoUTF8(m_Html.Text), last_change_time);
    Color := clGreen;
  except
    Color := clRed;
  end;
end;

procedure TFRM_Sources.m_TextChange(Sender: TObject);
begin
  try
    plugin.SetReadSourceText(plugin_handle, trnsltoUTF8(m_Text.Text), last_change_time);
    Color := clGreen;
  except
    Color := clRed;
  end;
end;

procedure TFRM_Sources.OnPluginRefresh;
begin
  if plugin_handle <> -1 then
  begin
    plugin.ReadSource_Free(plugin_handle);
  end;
  plugin_handle := plugin.ReadSource_New();

  FRM_Sources.m_Text.OnChange(Self);
  FRM_Sources.m_HTML.OnChange(Self);
end;

procedure TFRM_Sources.FormCreate(Sender: TObject);
begin
  clpCopy := TClipbrdCopy.Create;
  OnClipboardContentChanged := ClipbrdChanged;
  plugin_handle := -1;

  CB_ClipboardClick(CB_Clipboard);

  frm_cshelper_ctrl.OnTriggerRead := cshelper_trigger;
end;

procedure TFRM_Sources.ClipbrdChanged(Sender: TObject);
var i: integer;
begin
  i := 0;
  while (not OpenClipboard)and(i < 10) do inc(i);
  if i >= 10 then Exit;

  m_Text.Text := trnslShortStr(GetClipboardText_utf8); // this double-convertion is intended!
  m_Html.Text := trnslShortStr(GetClipboardHtml_utf8); // so we have exactly same behaviour like in cS

  CloseClipboard;
end;

procedure TFRM_Sources.CB_ClipboardClick(Sender: TObject);
begin
  if CB_Clipboard.Checked then
  begin
    Start;
    m_Text.ReadOnly := True;
    m_Text.Color := clBtnFace;
  end
  else
  begin
    Stopp;
    m_Text.ReadOnly := False;
    m_Text.Color := clWindow;
  end;
  m_Html.ReadOnly := m_Text.ReadOnly;
  m_Html.Color := m_Text.Color;

  Button2.Enabled := CB_Clipboard.Checked;
end;

procedure TFRM_Sources.Button1Click(Sender: TObject);
begin
  OpenDialog1.InitialDir := lastsourcefile;
  if OpenDialog1.Execute then
  begin
    lastsourcefile := OpenDialog1.FileName;
    LoadFromFile(OpenDialog1.FileName);
  end;
end;

procedure TFRM_Sources.LoadFromFile(filename: string);

  function ReadStringFromStream(stream: TStream): AnsiString;
  var i: integer;
  begin
    stream.ReadBuffer(i,SizeOf(i));
    SetLength(Result,i);
    stream.ReadBuffer(PAnsiChar(Result)^,i);
  end;

var stream: TFileStream;
    s: string;
begin
  stream := TFileStream.Create(filename,fmopenread);
  try
    s := trnslShortStr(ReadStringFromStream(stream));
    if s = 'cS - clipbrdfile' then
    begin
      m_Text.Text := trnslShortStr(ReadStringFromStream(stream));
      m_Html.Text := trnslShortStr(ReadStringFromStream(stream));

      m_fileinfo.Clear;
      s := trnslShortStr(ReadStringFromStream(stream));
      m_fileinfo.lines.Add('PluginfFile: ' + s);
      s := trnslShortStr(ReadStringFromStream(stream));
      m_fileinfo.lines.Add('PluginName: ' + s);
      s := trnslShortStr(ReadStringFromStream(stream));
      m_fileinfo.lines.Add('LangIndex: ' + s);
      s := trnslShortStr(ReadStringFromStream(stream));
      m_fileinfo.lines.Add('UserUni: ' + s);

      s := trnslShortStr(ReadStringFromStream(stream));
      if s = 'ClipbrdCopy' then  //Bei Alten geht das nich!!
        clpCopy.LoadFromStream(stream);

    end else ShowMessage('no valid file!');
  finally
    stream.Free
  end;
end;

procedure TFRM_Sources.SaveToFile(filename: string);
begin
  if CB_Clipboard.Checked then
    SaveClipboardtoFile(filename,
      plugin.PluginFilename,plugin.PlugInName,
      plugin.configGameDomain,plugin.ServerURL)
  else
    CopyFile(PChar(lastsourcefile),PChar(filename),False);
end;

procedure TFRM_Sources.Button2Click(Sender: TObject);
begin
  if SaveDialog1.Execute then
  begin
    SaveToFile(SaveDialog1.FileName);
  end;
end;

procedure TFRM_Sources.FormDestroy(Sender: TObject);
begin
  clpCopy.Free;
  if plugin_handle <> -1 then
    plugin.ReadSource_Free(plugin_handle);
end;

procedure TFRM_Sources.Button3Click(Sender: TObject);
begin
  clpCopy.WriteClipbrd;
end;

procedure TFRM_Sources.Button4Click(Sender: TObject);
begin
  m_Text.Text := m_Html.Text;
end;

procedure TFRM_Sources.Button5Click(Sender: TObject);
begin
  m_Html.Text := m_Text.Text;
end;

procedure TFRM_Sources.FormResize(Sender: TObject);
begin
  m_Text.Height := (m_Text.Height + (m_fileinfo.Top - m_Html.Height - 12 - m_Text.Top - Label2.Height))div 2;
  if m_Text.Height < 30 then m_Text.Height := 30;
  m_Html.Height := m_fileinfo.Top - (m_Text.Top + m_Text.Height + Label2.Height + 8) - 4;
  m_Html.Top := (m_Text.Top + m_Text.Height + Label2.Height + 8);
  Label2.Top := (m_Text.Top + m_Text.Height + 4);
  Button4.Top := Label2.Top;
  Button5.Top := Button4.Top;
end;

procedure TFRM_Sources.cshelper_trigger(const text, html: string);
begin
  m_Text.Text := text;
  m_Html.Text := html;
  // force update of text even is not changed:
  m_TextChange(Self);
end;

end.
