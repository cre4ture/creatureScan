unit SelectPlugin;
                                                                           
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, inifiles, languages;

const
  PluginSection = 'ioplugin';
  PluginName = 'name';
  PluginLangIndex = 'langindex';

type
  TFRM_SelectPlugin = class(TForm)
    CB_PluginA: TComboBox;
    LBL_PluginA1: TLabel;
    LBL_PluginA2: TLabel;
    BTN_OK: TButton;
    BTN_Abbrechen: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BTN_OKClick(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    PluginFileList: TStringList;
    PlugInDir: String;
    { Private-Deklarationen }
  public
    LanguageIndex: integer;
    PluginFile: String;
    constructor Create(AOwner: TComponent; LangIndex: Integer);
    { Public-Deklarationen }
  end;

implementation

uses Prog_Unit;

{$R *.DFM}

procedure TFRM_SelectPlugin.FormCreate(Sender: TObject);
var f: TSearchRec;
    ini: TIniFile;
begin
  if SaveCaptions then SaveAllCaptions(Self,LangFile);
  if LoadCaptions then LoadAllCaptions(Self,LangFile);
  
  ChDir(ExtractFilePath(Application.ExeName));
  PlugInDir := 'ioplugins\';
  PluginFileList := TStringList.Create;
  PluginFileList.Clear;
  try
    FindFirst(PlugInDir + '*.ini',faanyfile,f);
    repeat
      if FileExists(PlugInDir + f.Name) then
      begin
        ini := TIniFile.Create(PlugInDir + f.Name);
        if ini.ReadInteger(PluginSection,PluginLangIndex,-1) = LanguageIndex then
        begin
          PluginFileList.Add(PlugInDir + f.Name);
          CB_PluginA.Items.Add(ini.ReadString(PluginSection,PluginName,'--error--'));
        end;
        ini.free;
      end;
    until FindNext(f) <> 0;
    FindClose(f);
  except
    ShowMessage('Fehler beim Laden der LangPlugins!');
  end;
end;

procedure TFRM_SelectPlugin.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  PluginFileList.Free;
end;

constructor TFRM_SelectPlugin.Create(AOwner: TComponent; LangIndex: Integer);
begin
  LanguageIndex := LangIndex;
  inherited Create(AOwner);
end;

procedure TFRM_SelectPlugin.BTN_OKClick(Sender: TObject);
begin
  if (CB_PluginA.ItemIndex <> -1) and FileExists(PluginFileList[CB_PluginA.ItemIndex]) then
  begin
    PluginFile := PluginFileList[CB_PluginA.ItemIndex];
    ModalResult := mrOk;
  end;
end;

procedure TFRM_SelectPlugin.FormPaint(Sender: TObject);
begin
  Application.BringToFront;
end;

procedure TFRM_SelectPlugin.FormShow(Sender: TObject);
var i: integer;
begin
  i := PluginFileList.Count-1;
  while (i >= 0)and(PluginFileList[i] <> PluginFile) do
  begin
    dec(i);
  end;
  CB_PluginA.ItemIndex := i;
end;

end.
