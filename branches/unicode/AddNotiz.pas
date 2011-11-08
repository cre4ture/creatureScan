unit AddNotiz;
                                    
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TFRM_AddNotiz = class(TForm)
    Label2: TLabel;
    TXT_Notiz: TEdit;
    Label3: TLabel;
    CB_Icon: TComboBox;
    Button1: TButton;
    Button2: TButton;
    RB_Planet: TRadioButton;
    RB_Spieler: TRadioButton;
    RB_Allianz: TRadioButton;
    LBL_PLanet: TLabel;
    LBL_Spieler: TLabel;
    LBL_Allianz: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

implementation

uses Notizen, Languages;

{$R *.DFM}

procedure TFRM_AddNotiz.FormCreate(Sender: TObject);
begin
  CB_Icon.OnDrawItem := FRM_Notizen.CB_ImageDrawItem;
  CB_Icon.Items := FRM_Notizen.CB_Image.Items;
  CB_Icon.ItemIndex := 0;
  if SaveCaptions then SaveAllCaptions(Self,LangFile);
  if LoadCaptions then LoadAllCaptions(Self,LangFile);
end;

end.
