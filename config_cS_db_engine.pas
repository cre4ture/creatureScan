unit config_cS_db_engine;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Spin, StdCtrls;

type
  Tfrm_config_cS_engine = class(TForm)
    txt_url: TEdit;
    Label1: TLabel;
    txt_username: TEdit;
    Label2: TLabel;
    txt_password: TEdit;
    Label3: TLabel;
    Button1: TButton;
    Button2: TButton;
    cb_auto: TCheckBox;
    se_min: TSpinEdit;
    Label4: TLabel;
    txt_name: TEdit;
    Label5: TLabel;
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  frm_config_cS_engine: Tfrm_config_cS_engine;

implementation

{$R *.dfm}

end.
