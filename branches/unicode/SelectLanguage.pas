unit SelectLanguage;
                                                                    
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Languages, inifiles;

const
  LangSection = 'generell';
  LangName = 'STR_Sprache';

type
  TFRM_SelectLanguage = class(TForm)
    LBL_SprachA1: TLabel;
    CB_SprachA: TComboBox;
    BTN_OK: TButton;
    BTN_Abbrechen: TButton;
    LBL_SprachA2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BTN_OKClick(Sender: TObject);
    procedure CB_SprachAChange(Sender: TObject);
    procedure FormPaint(Sender: TObject);
  private
    LanguageDir: String;
    LanguageFileList: TStringlist;
    { Private-Deklarationen }
  public
    LanguageFile: string;
    procedure LoadLanguage(Filename: String);
    { Public-Deklarationen }
  end;

implementation

{$R *.DFM}

procedure TFRM_SelectLanguage.FormCreate(Sender: TObject);
var f: TSearchRec;
    ini: TIniFile;
begin
  if SaveCaptions then SaveAllCaptions(Self,LangFile);
  if LoadCaptions then LoadAllCaptions(Self,LangFile);

  ChDir(ExtractFilePath(Application.ExeName));
  LanguageDir := 'lang\';
  LanguageFileList := TStringList.Create;
  try
    FindFirst(LanguageDir + '*.cSlgn',faanyfile,f);
    repeat
      if FileExists(LanguageDir + f.Name) then
      begin
        ini := TIniFile.Create(LanguageDir + f.Name);
        LanguageFileList.Add(LanguageDir + f.Name);
        CB_SprachA.Items.Add(ini.ReadString(LangSection,LangName,'--error--'));
        ini.free;
      end;
    until FindNext(f) <> 0;
    FindClose(f);
  except
    ShowMessage('Error loading awailable Languages');
  end;
end;

procedure TFRM_SelectLanguage.FormShow(Sender: TObject);
var i: integer;
begin
  i := LanguageFileList.Count-1;
  while (i >= 0)and(LanguageFileList[i] <> LangFile) do
  begin
    dec(i);
  end;
  CB_SprachA.ItemIndex := i;
end;

procedure TFRM_SelectLanguage.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  LanguageFileList.free;
end;

procedure TFRM_SelectLanguage.BTN_OKClick(Sender: TObject);
begin
  if CB_SprachA.ItemIndex >= 0 then
  begin
    LanguageFile := LanguageFileList[CB_SprachA.ItemIndex];
    ModalResult := mrOk;
  end;
end;

procedure TFRM_SelectLanguage.LoadLanguage(Filename: String);
begin
  LoadAllCaptions(Self,Filename);
  if SaveCaptions then SaveAllCaptions(Self,Filename);
end;

procedure TFRM_SelectLanguage.CB_SprachAChange(Sender: TObject);
begin
  if CB_SprachA.ItemIndex >= 0 then
  begin
    LanguageFile := LanguageFileList[CB_SprachA.ItemIndex];
    LoadLanguage(LanguageFile);
  end;
end;

procedure TFRM_SelectLanguage.FormPaint(Sender: TObject);
begin
  Application.BringToFront;
end;

end.
