unit Info;

interface                                                                        

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, jpeg, ExtCtrls, Languages, ShellApi, Prog_Unit;

type
  TFRM_Info = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label3: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClick(Sender: TObject);
    procedure Label5Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  FRM_Info: TFRM_Info;

implementation

{$R *.DFM}

procedure TFRM_Info.FormCreate(Sender: TObject);
begin
  if SaveCaptions then SaveAllCaptions(Self,LangFile);
  if LoadCaptions then LoadAllCaptions(Self,LangFile);
  Label1.Caption := Label1.Caption + VNumber;
end;

procedure TFRM_Info.FormClick(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TFRM_Info.Label5Click(Sender: TObject);
begin
  ShellExecute(Self.Handle,'open',PChar('http://www.creatureScan.de.vu'),'','',0);
end;

end.
