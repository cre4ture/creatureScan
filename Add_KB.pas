unit Add_KB;
                                         
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask, OGame_Types, ExtCtrls, clipbrd, Languages, Prog_Unit,
  DateUtils;

type
  TFRM_Add_Raid = class(TForm)
    BTN_OK: TButton;
    BTN_Cancel: TButton;
    GroupBox1: TGroupBox;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    TXT_Metall: TEdit;
    TXT_Kristall: TEdit;
    TXT_Deuterium: TEdit;
    GroupBox2: TGroupBox;
    Label3: TLabel;
    Label2: TLabel;
    Label1: TLabel;
    TXT_Start: TEdit;
    TXT_Ziel: TEdit;
    cb_ankunftum: TCheckBox;
    TXT_AnkunfUm: TMaskEdit;
    TXT_h: TEdit;
    TXT_min: TEdit;
    TXT_Sec: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    BTN_Paste: TButton;
    Timer1: TTimer;
    procedure cb_ankunftumClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BTN_PasteClick(Sender: TObject);
    procedure TXT_hChange(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure BTN_OKClick(Sender: TObject);
  private
    { Private-Deklarationen }
    function GetFleet: TFleetEvent;
    procedure SetFleet(fleet: TFleetEvent);
  public
    property Fleet: TFleetEvent read GetFleet write SetFleet;
    procedure ResetTime(time_u: Int64);
    { Public-Deklarationen }
  end;

implementation

{$R *.DFM}

procedure TFRM_Add_Raid.cb_ankunftumClick(Sender: TObject);
begin
  Timer1.Enabled := not cb_ankunftum.Checked;
  if cb_ankunftum.Checked then
    TXT_AnkunfUm.Text := DateTimeToStr(Now+1/24);
  TXT_h.Enabled := not cb_ankunftum.Checked;
  TXT_min.Enabled := not cb_ankunftum.Checked;
  TXT_Sec.Enabled := not cb_ankunftum.Checked;
  TXT_AnkunfUm.Enabled := cb_ankunftum.Checked;
end;

procedure TFRM_Add_Raid.FormCreate(Sender: TObject);
begin
  cb_ankunftumClick(self);
  if SaveCaptions then SaveAllCaptions(Self,LangFile);
  if LoadCaptions then LoadAllCaptions(Self,LangFile);
end;

procedure TFRM_Add_Raid.BTN_PasteClick(Sender: TObject);
var auftrag: TRaidAuftrag;
    s: string;
begin
  s := Clipboard.AsText;
  if ODataBase.LanguagePlugIn.ReadRaidAuftrag(s,auftrag) then
  begin
    TXT_Start.Text := PositionToStrMond(auftrag.Start);
    TXT_Ziel.Text := PositionToStrMond(auftrag.Ziel);
    cb_ankunftum.Checked := true;
    TXT_AnkunfUm.Text := DateTimeToStr(auftrag.Zeit);
  end;
end;

procedure TFRM_Add_Raid.TXT_hChange(Sender: TObject);
begin
  if (TXT_h.Text <> '')and
     (TXT_min.Text <> '')and
     (TXT_Sec.Text <> '') then
  begin
  try
    TXT_AnkunfUm.Text := DateTimeToStr(now + StrToInt(TXT_h.Text)/24 + StrToInt(TXT_min.Text)/24/60 + StrToInt(TXT_sec.Text)/24/60/60);
  except
    TXT_AnkunfUm.Text := '00.00.00 00:00:00';
  end;
  end
  else TXT_AnkunfUm.Text := '00.00.00 00:00:00';
end;

procedure TFRM_Add_Raid.Timer1Timer(Sender: TObject);
begin
  if not cb_ankunftum.Checked then
    TXT_hChange(self);
end;

function TFRM_Add_Raid.GetFleet: TFleetEvent;
begin
  with result do
  begin
    head.origin := StrToPosition(TXT_Start.Text);
    head.target := StrToPosition(TXT_Ziel.Text);
    head.player := ODataBase.Username;

    if cb_ankunftum.Checked then  //art der Zeitangabe
      head.arrival_time_u := DateTimeToUnix(StrToDateTime(TXT_AnkunfUm.text))
    else
      head.arrival_time_u := DateTimeToUnix(now + StrToInt(TXT_h.Text)/24 +
                                      StrToInt(TXT_min.Text)/24/60 +
                                      StrToInt(TXT_sec.Text)/24/60/60);

    SetLength(ress,fsc_0_Rohstoffe);
    ress[0] := StrToInt(TXT_Metall.Text);
    ress[1] := StrToInt(TXT_Kristall.Text);
    ress[2] := StrToInt(TXT_Deuterium.Text);
    ress[3] := 0;

    head.eventtype := fet_attack;
    SetLength(ships,fsc_1_Flotten);
  end;
end;

procedure TFRM_Add_Raid.SetFleet(fleet: TFleetEvent);

begin
  TXT_Start.Text := PositionToStrMond(fleet.head.origin);

  cb_ankunftum.Checked := True;
  TXT_AnkunfUm.Text := DateTimeToStr(UnixToDateTime(fleet.head.arrival_time_u));
  TXT_Ziel.Text := PositionToStrMond(fleet.head.target);
  
  TXT_Metall.Text := IntToStr(fleet.ress[0]);
  TXT_Kristall.Text := IntToStr(fleet.ress[1]);
  TXT_Deuterium.Text := IntToStr(fleet.ress[2]);
end;

procedure TFRM_Add_Raid.ResetTime(time_u: Int64);
var h,m,s,ms: word;
begin
  cb_ankunftum.Checked := false;

  DecodeTime(UnixToDateTime(time_u),h,m,s,ms);
  TXT_h.Text := IntToStr(h);
  TXT_min.Text := IntToStr(m);
  TXT_Sec.Text := IntToStr(s);
end;

procedure TFRM_Add_Raid.BTN_OKClick(Sender: TObject);
begin
  GetFleet; //Zum testen ob auch alle Daten richtig eigegeben wurden
  ModalResult := mrOK;
end;

end.
