unit PostErrorReport;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdHTTP, IdMultipartFormData, clipbrdfunctions,
  Prog_Unit;

type
  Tfrm_postErrorReport = class(TForm)
    Timer1: TTimer;
    Memo1: TMemo;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    ComboBox1: TComboBox;
    Label4: TLabel;
    Label5: TLabel;
    mem_desc: TMemo;
    Label6: TLabel;
    txt_browser: TEdit;
    Button1: TButton;
    ProgressBar1: TProgressBar;
    Button2: TButton;
    HTTP: TIdHTTP;
    Label7: TLabel;
    txt_email: TEdit;
    procedure Timer1Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure HTTPWorkBegin(Sender: TObject; AWorkMode: TWorkMode;
      const AWorkCountMax: Integer);
    procedure HTTPWork(Sender: TObject; AWorkMode: TWorkMode;
      const AWorkCount: Integer);
    procedure HTTPWorkEnd(Sender: TObject; AWorkMode: TWorkMode);
    procedure Button1Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  frm_postErrorReport: Tfrm_postErrorReport;

implementation

{$R *.dfm}

uses main, DateUtils;

procedure Tfrm_postErrorReport.Timer1Timer(Sender: TObject);
var s: string;
begin
  s := FRM_Main.GetClipboardText();
  if s <> Memo1.Text then
    Memo1.Text := s;
end;

procedure Tfrm_postErrorReport.FormShow(Sender: TObject);
begin
  Timer1.Enabled := true;
end;

procedure Tfrm_postErrorReport.FormHide(Sender: TObject);
begin
  Timer1.Enabled := false;
end;

procedure Tfrm_postErrorReport.HTTPWorkBegin(Sender: TObject;
  AWorkMode: TWorkMode; const AWorkCountMax: Integer);
begin
  ProgressBar1.Position := 0;
  ProgressBar1.Max := AWorkCountMax;
end;

procedure Tfrm_postErrorReport.HTTPWork(Sender: TObject;
  AWorkMode: TWorkMode; const AWorkCount: Integer);
begin
  ProgressBar1.Position := AWorkCount;
  Application.ProcessMessages;
end;

procedure Tfrm_postErrorReport.HTTPWorkEnd(Sender: TObject;
  AWorkMode: TWorkMode);
begin
  ModalResult := mrOk;
end;

procedure Tfrm_postErrorReport.Button1Click(Sender: TObject);
var
  Stream: TStringStream;
  Params: TIdMultipartFormDataStream;
  filename: string;
begin
  mem_desc.Lines.Add('------------------');
  mem_desc.Lines.Add('content-type:' + ComboBox1.Text);
  mem_desc.Lines.Add('browser:' + txt_browser.Text);
  mem_desc.Lines.Add('email:' + txt_email.Text);

  filename := ExtractFilePath(Application.ExeName) +
    'postreport_' + IntToStr(DateTimeToUnix(now)) + '.bin';

  clipbrdfunctions.SaveClipboardtoFile(filename,
      mem_desc.Text,
      ODataBase.LanguagePlugIn.PlugInName,
      ODataBase.game_domain,
      ODataBase.UniDomain);

  try
    Stream := TStringStream.Create('');
    try
      Params := TIdMultipartFormDataStream.Create;
      try
        Params.AddFile('File1', filename, 'application/octet-stream');
        try
          HTTP.Post('http://www.creaturescan.creax.de/upload/post.php',
            Params, Stream);
          mem_desc.Clear;
          ShowMessage('Send ErrorReport Completed!');
        except
          on E: Exception do
            ShowMessage('Error encountered during POST: ' + E.Message);
        end;
        if length(Stream.DataString) > 0 then
        begin
          ShowMessage(Stream.DataString);
          mem_desc.Lines.Add('Last Response: ' + Stream.DataString);
        end;
      finally
        Params.Free;
      end;
    finally
      Stream.Free;
    end;
  except
  end;
  DeleteFile(filename);
end;

end.
