unit Mond_Abfrage;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Bericht_Frame, OGame_Types, languages, prog_unit, TIReadPlugin;

type
  TFRM_Mond = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Frame_Bericht1: TFrame_Bericht;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    procedure Button3Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    Bericht : TScanBericht;
    plugin: TLangPlugIn;
    function Open(Ber: TScanBericht): Boolean;
    { Public-Deklarationen }
  published
    constructor Create(AOwner: TComponent; aPlugin: TLangPlugIn); reintroduce;
  end;

implementation

{$R *.DFM}

procedure TFRM_Mond.Button3Click(Sender: TObject);
begin
  clientWidth := Frame_Bericht1.Left + Frame_Bericht1.Width + Frame_Bericht1.Left;
  clientHeight := Frame_Bericht1.Top + Frame_Bericht1.Height + Frame_Bericht1.Left;
  Frame_Bericht1.Visible := true;
  Button3.Enabled := false;
  Frame_Bericht1.SetBericht(Bericht);
  Frame_Bericht1.Report_Refresh;
end;

procedure TFRM_Mond.FormShow(Sender: TObject);
begin
  Label2.Caption := '[' + PositionToStr_(Bericht.Head.Position) + ']';
  SetForegroundWindow(Handle);
end;

function TFRM_Mond.Open(Ber: TScanBericht): Boolean;
begin
  Bericht := Ber;
  Result := ShowModal = mrYes;
end;

constructor TFRM_Mond.Create(AOwner: TComponent; aPlugin: TLangPlugIn);
begin
  plugin := aPlugin;
  inherited Create(AOwner);
end;

procedure TFRM_Mond.FormCreate(Sender: TObject);
begin
  Frame_Bericht1.DontShowRaids := True;
  TOBject(Frame_Bericht1.plugin) :=  plugin;

  if SaveCaptions then SaveAllCaptions(Self,LangFile);
  if LoadCaptions then LoadAllCaptions(Self,LangFile);
end;

end.
