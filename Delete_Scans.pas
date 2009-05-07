unit Delete_Scans;
                                                                                          
interface

uses
  Windows, Messages, Forms, Sysutils, ComCtrls, StdCtrls, ExtCtrls,
  Controls, Classes, Ogame_Types, Prog_unit, Languages;

type
  TFRM_Delete_Scans = class(TForm)
    GroupBox1: TGroupBox;
    TXT_maxAnzahl: TEdit;                                         
    DTP_minAlter: TDateTimePicker;
    Button1: TButton;
    ProgressBar1: TProgressBar;
    CH_minAnzahl: TCheckBox;
    TXT_minAnzahl: TEdit;
    RB_minAlter: TRadioButton;
    RB_maxAnzahl: TRadioButton;
    Label1: TLabel;
    Label2: TLabel;
    CB_ScanBereiche: TComboBox;
    Label4: TLabel;
    CH_ScanBereiche: TCheckBox;
    procedure RB_minAlterClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    procedure DelByPlanet(Pos: TPlanetPosition);
    { Private-Deklarationen }
  public
    procedure Del;
    { Public-Deklarationen }
  end;

var
  FRM_Delete_Scans: TFRM_Delete_Scans;

implementation

uses Main, UniTree, DateUtils;

{$R *.DFM}

procedure TFRM_Delete_Scans.Del;
var G,S,P: integer;
    M: Boolean;
    Pos: TPlanetPosition;
begin
  ProgressBar1.Max := max_Galaxy * max_Systems * max_Planeten * 2;
  ProgressBar1.Position := 0;
  for G := 1 to max_Galaxy do
  begin
    for S := 1 to max_Systems do
    begin
      for P := 1 to max_Planeten do
      begin
        for M := false to true do
        begin
          pos.P[0] := G;
          pos.P[1] := S;
          pos.P[2] := P;
          pos.Mond := M;
          DelByPlanet(Pos);
          ProgressBar1.Position := ProgressBar1.Position +1;
        end;
      end;
    end;
  end;
end;

procedure TFRM_Delete_Scans.RB_minAlterClick(Sender: TObject);
begin
  DTP_minAlter.Enabled := RB_minAlter.Checked;
  CH_minAnzahl.Enabled := RB_minAlter.Checked;
  TXT_minAnzahl.Enabled := RB_minAlter.Checked;
  TXT_maxAnzahl.Enabled := RB_maxAnzahl.Checked;
end;

procedure TFRM_Delete_Scans.FormCreate(Sender: TObject);
var sg: TScanGroup;
begin
  RB_minAlterClick(self);
  DTP_minAlter.DateTime := now - 90;
  
  if SaveCaptions then SaveAllCaptions(Self,LangFile);
  if LoadCaptions then LoadAllCaptions(Self,LangFile);

  CB_ScanBereiche.Items.Clear;
  for sg := low(sg) to high(sg) do
    CB_ScanBereiche.Items.Add(ODataBase.LanguagePlugIn.SBItems[sg][0]);
  CB_ScanBereiche.ItemIndex := 3;
end;

procedure TFRM_Delete_Scans.Button1Click(Sender: TObject);
begin
  if Application.MessageBox(PChar(STR_MSG_Del_Text),PChar(STR_MSG_Del_Caption),MB_OKCANCEL or MB_ICONQUESTION) = idok then
  begin
    Del;
    FRM_Main.lst_others.Items.Clear;
  end;
end;

procedure TFRM_Delete_Scans.DelByPlanet(Pos: TPlanetPosition);

procedure DelScan(NR: Integer);
begin
  if (not CH_ScanBereiche.Checked)or
     (ODataBase.Berichte[NR].Bericht[TScanGroup(CB_ScanBereiche.ItemIndex+1)][0] < 0) then
    ODataBase.UniTree.DeleteReport(NR);
end;

var Liste: TReportTimeList;
    i, max, min: integer;
begin
  Liste := ODataBase.UniTree.GetPlanetReportList(pos);
  if length(Liste) = 0 then Exit;

  SortPlanetScanList(Liste,pslst_Alter);
  max := StrToInt(TXT_maxAnzahl.Text);

  if RB_maxAnzahl.Checked and (length(Liste) > max) then
  begin
    SetLength(Liste,length(Liste)-max); //alle die dableiben sollen, rauslöschen!
    SortPlanetScanList(Liste,pslst_Nummer);
    for i := length(Liste)-1 downto 0 do
    //von hoch nach tief, weil, wenn du einen niederen index löscht,
    // es sein kann, das die höheren nichtmehr stimmen, wohl aber die drunnter!
      DelScan(Liste[i].ID);

    Exit;
  end;

  if CH_minAnzahl.Checked then
    min := StrToInt(TXT_minAnzahl.Text)
  else min := 0;

  if RB_minAlter.Checked and (length(Liste) > min) then
  begin
    SetLength(Liste,length(Liste)-min); //alle die absolut dableiben sollen, rauslöschen!

    for i := 0 to length(Liste)-1 do
      if Liste[i].Time_u > DateTimeToUnix(DTP_minAlter.DateTime) then
        Liste[i].ID := -1; //die, die dableiben sollen markieren mit unmöglichem index!

    SortPlanetScanList(Liste,pslst_Nummer);
    for i := length(Liste)-1 downto 0 do
    //von hoch nach tief, weil, wenn du einen niederen index löscht,
    // es sein kann, das die höheren nichtmehr stimmen, wohl aber die drunnter!
      if (Liste[i].ID >= 0) then DelScan(Liste[i].ID);
  end;
end;

end.
