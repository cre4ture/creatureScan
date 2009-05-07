unit SelectUser;

interface
                                                                      
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TFRM_SelectUser = class(TForm)
    ComboBox1: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    CheckBox1: TCheckBox;
    Button1: TButton;
    Button2: TButton;
    procedure ComboBox1Change(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

implementation

uses Prog_Unit;

{$R *.DFM}

procedure TFRM_SelectUser.ComboBox1Change(Sender: TObject);
begin
  Button1.Enabled := ComboBox1.Text <> '';
end;

procedure TFRM_SelectUser.FormShow(Sender: TObject);
begin
  ComboBox1Change(Self);
end;

end.
