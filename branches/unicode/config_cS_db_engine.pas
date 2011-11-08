unit config_cS_db_engine;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Spin, StdCtrls;

type
  Tfrm_config_cS_engine = class(TForm)
    Button1: TButton;
    Button2: TButton;
    gb_config: TGroupBox;
    gb_login: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    txt_url: TEdit;
    txt_username: TEdit;
    txt_password: TEdit;
    txt_name: TEdit;
    Label6: TLabel;
    se_max_days_age: TSpinEdit;
    Label7: TLabel;
    Label8: TLabel;
    cb_dont_sync_deletet_planets: TCheckBox;
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
