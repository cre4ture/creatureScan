unit Add_KB;
                                         
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask, OGame_Types, ExtCtrls, clipbrd, Languages,
  DateUtils, OtherTime;

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
    txt_stunde: TEdit;
    TXT_min: TEdit;
    TXT_Sec: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Timer1: TTimer;
    txt_arrival: TEdit;
    Label7: TLabel;
    Label11: TLabel;
    lbl_time_diff: TLabel;
    procedure cb_ankunftumClick(Sender: TObject);
    procedure txt_stundeChange(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure BTN_OKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    GameTime: TDeltaSystemTime;
    
    function GetFleet: TFleetEvent;
    procedure SetFleet(fleet: TFleetEvent);
  public
    property Fleet: TFleetEvent read GetFleet write SetFleet;
    procedure ResetTime(time_u: Int64);
    constructor Create(AParent: TForm; aServerTime: TDeltaSystemTime);
    { Public-Deklarationen }
  end;

implementation

{$R *.DFM}

procedure TFRM_Add_Raid.cb_ankunftumClick(Sender: TObject);
begin
  Timer1.Enabled := not cb_ankunftum.Checked;
  if cb_ankunftum.Checked then
    txt_arrival.Text := DateTimeToStr(GameTime.Time+1/24);
  txt_stunde.Enabled := not cb_ankunftum.Checked;
  TXT_min.Enabled := not cb_ankunftum.Checked;
  TXT_Sec.Enabled := not cb_ankunftum.Checked;
  txt_arrival.Enabled := cb_ankunftum.Checked;
end;

procedure TFRM_Add_Raid.txt_stundeChange(Sender: TObject);
begin
  if (txt_stunde.Text <> '')and
     (TXT_min.Text <> '')and
     (TXT_Sec.Text <> '') then
  begin
    try
      txt_arrival.Text := DateTimeToStr(GameTime.Time + StrToInt(txt_stunde.Text)/24 + StrToInt(TXT_min.Text)/24/60 + StrToInt(TXT_sec.Text)/24/60/60);
    except
      txt_arrival.Text := '00.00.0000 00:00:00';
    end;
  end
  else
    txt_arrival.Text := '00.00.0000 00:00:00';
end;

procedure TFRM_Add_Raid.Timer1Timer(Sender: TObject);
begin
  if not cb_ankunftum.Checked then
    txt_stundeChange(self);

  lbl_time_diff.Caption := GameTime.delayToStr;
end;

function TFRM_Add_Raid.GetFleet: TFleetEvent;
begin
  with result do
  begin
    head.origin := StrToPosition(TXT_Start.Text);
    head.target := StrToPosition(TXT_Ziel.Text);

    if cb_ankunftum.Checked then  //art der Zeitangabe
      head.arrival_time_u := DateTimeToUnix(StrToDateTime(txt_arrival.text))
    else
      head.arrival_time_u := DateTimeToUnix(GameTime.Time + StrToInt(txt_stunde.Text)/24 +
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
  txt_arrival.Text := DateTimeToStr(UnixToDateTime(fleet.head.arrival_time_u));
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
  txt_stunde.Text := IntToStr(h);
  TXT_min.Text := IntToStr(m);
  TXT_Sec.Text := IntToStr(s);
end;

procedure TFRM_Add_Raid.BTN_OKClick(Sender: TObject);
begin
  GetFleet; //Zum testen ob auch alle Daten richtig eigegeben wurden
  ModalResult := mrOK;
end;

procedure TFRM_Add_Raid.FormShow(Sender: TObject);
begin
  cb_ankunftumClick(self);
  txt_stundeChange(Self);
  Timer1Timer(Self);
end;

constructor TFRM_Add_Raid.Create(AParent: TForm; aServerTime: TDeltaSystemTime);
begin
  inherited Create(AParent);
  GameTime := aServerTime;
end;

end.
