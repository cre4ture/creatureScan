unit ClientLogin;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TFRM_ClientLogin = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    TXT_Username: TEdit;
    Label4: TLabel;
    TXT_Pass: TEdit;
    Button1: TButton;
    LBL_Servername: TLabel;
    LBL_IP_Port: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

implementation

uses Languages;

{$R *.DFM}

procedure TFRM_ClientLogin.FormCreate(Sender: TObject);
begin
  if SaveCaptions then SaveAllCaptions(Self,LangFile);
  if LoadCaptions then LoadAllCaptions(Self,LangFile);
end;

end.
