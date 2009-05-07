unit FavFilter;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, CoordinatesRanges, Languages, OGame_Types,
  iniFiles, prog_unit;

const
  FilterSection = 'FavFilter';

type
  TPlanetRange = TCoordinatesRangeList;
  TPlanetRangeList = class(TComponent)
  private
    FPRList: TList;
    function GetPlanetRange(Index: Integer): TPlanetRange;
    function GetCount: Integer;
  public
    Name: String;
    property PlanetRange[Index: Integer]: TPlanetRange
      read GetPlanetRange; default;
    property Count: Integer read GetCount;
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;
    procedure Clear;
    procedure ReadFromString(s: string);
    procedure Delete(Index: Integer);
    function AddPlanetRange(pr: TPlanetRange): Integer;
    function isElement(Pos: TPlanetPosition): Boolean;
    function GetAsString: String;
  end;
  TAltersFilter = record
    Alter: TDateTime;
    Aktiv: Boolean;
  end;
  TRessFilter = Record
    Aktive: Boolean;
    Value: Integer;
  end;
  TDefFleetFilter = record
    Aktive: Boolean;
    Value: integer;
    Multi: Smallint;  // Multi ist entweder -1 (kleiner) oder 1 (größer), siehe filter!
  end;
  TFilter = record
    Alter: TAltersFilter;
    Ress_Ges: TRessFilter;
    MKDE: array[0..3] of TRessFilter;
    Def: TDefFleetFilter;
    Fleet: TDefFleetFilter;
    Status_filter: TStatus;
    Status_negativ: Boolean;
  end;
  TRess = Record
    LBL: TLabel;
    TXT: TEdit;
    CH: TCheckBox;
  end;
  TFRM_Filter = class(TForm)
    Fav_Pages: TPageControl;
    TS_Alter: TTabSheet;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label2: TLabel;
    CH_AltersFilter_active: TCheckBox;
    TXT_AlterTage: TEdit;
    TXT_AlterStunden: TEdit;
    TXT_AlterMinuten: TEdit;
    TS_Ress: TTabSheet;
    LBL_Ges: TLabel;
    CH_ges: TCheckBox;
    TXT_ges: TEdit;
    TS_Def_Fleet_Stat: TTabSheet;
    CB_Def: TComboBox;
    CH_Def: TCheckBox;
    CH_Fleet: TCheckBox;
    CB_Fleet: TComboBox;
    TXT_Def: TEdit;
    TXT_Fleet: TEdit;
    TS_Koordinaten: TTabSheet;
    Label11: TLabel;
    Button1: TButton;
    Button2: TButton;
    GroupBox1: TGroupBox;
    Label6: TLabel;
    TXT_Status_mit: TEdit;
    Label8: TLabel;
    CB_KoordB: TComboBox;
    Button3: TButton;
    Button4: TButton;
    cb_stat_negativ: TCheckBox;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure TXT_Status_mitKeyPress(Sender: TObject; var Key: Char);
    procedure Button4Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    Ress: array[0..3] of TRess;
    procedure ReadFilter;
    procedure Refresh_CB_KoordB;
    { Private-Deklarationen }
  public
    Filter: TFilter;
    Areas: array of TPlanetRangeList;
    procedure SaveFilter(ini: TiniFile);
    procedure LoadFilter(ini: TInifile);
    function AddArea(s: string): integer;
    procedure DeleteArea(Index: Integer);
    { Public-Deklarationen }
  end;

var
  FRM_Filter: TFRM_Filter;

implementation

{$R *.dfm}

function TPlanetRangeList.isElement(Pos: TPlanetPosition): Boolean;
var x: TCoordinates;
    i: integer;
begin
  SetLength(x,3);
  for i := 0 to 2 do x[i] := Pos.P[i];

  Result := False;
  i := 0;
  while (not Result)and(i < Count) do
  begin
    Result := ElementOfRangeList(x, PlanetRange[i]);
    inc(i);
  end;
end;

procedure TFRM_Filter.ReadFilter;
var i: integer;
begin
  with Filter do
  begin
    Alter.Aktiv := CH_AltersFilter_active.Checked;
    Alter.Alter := StrToInt(TXT_AlterTage.Text) +
                  (StrToInt(TXT_AlterStunden.Text)/24) +
                  (StrToInt(TXT_AlterMinuten.Text)/1440);

    Ress_Ges.Aktive := CH_ges.Checked;
    Ress_Ges.Value := StrToInt(TXT_ges.Text);
    for i := 0 to 3 do
    with MKDE[i] do
    begin
      Aktive := Ress[i].CH.Checked;
      Value := StrToInt(Ress[i].TXT.Text);
    end;

    Def.Aktive := CH_Def.Checked;
    Def.Value := StrToInt(TXT_Def.Text);
    Def.Multi := CB_Def.ItemIndex;
    if Def.Multi = 0 then
      Def.Multi := -1;
    Fleet.Aktive := CH_Fleet.Checked;
    Fleet.Value := StrToInt(TXT_Fleet.Text);
    Fleet.Multi := CB_Fleet.ItemIndex;
    if Fleet.Multi = 0 then
      Fleet.Multi := -1;

    Status_filter := ODataBase.LanguagePlugIn.StrToStatus(TXT_Status_mit.Text);
    Status_negativ := cb_stat_negativ.Checked;
  end;
end;

procedure TFRM_Filter.FormCreate(Sender: TObject);
var x,y,w,h, i: integer;
    s: TStatus;
begin
  if SaveCaptions then SaveAllCaptions(Self,LangFile);
  if LoadCaptions then LoadAllCaptions(Self,LangFile);

  w := TXT_ges.Left + TXT_ges.Width + 16;
  h := TXT_ges.Top + TXT_ges.Height;

  x := 0;
  y := 1;

  for i := 0 to 3 do
  with Ress[i] do
  begin
    LBL := TLabel.Create(Self);
    LBL.Parent := CH_ges.Parent;

    TXT := TEdit.Create(Self);
    TXT.Parent := CH_ges.Parent;

    CH := TCheckBox.Create(Self);
    CH.Parent := CH_ges.Parent;

    LBL.Top := LBL_Ges.Top + h*y;
    LBL.Width := LBL_Ges.Width;

    LBL.Left := LBL_Ges.Left + w*x;

    LBL.Caption := LBL_Ges.Caption;

    TXT.Top := TXT_ges.Top + h*y;
    TXT.Width := TXT_ges.Width;

    TXT.Left := TXT_Ges.Left + w*x;
    TXT.Text := TXT_ges.Text;
    
    CH.Top := CH_ges.Top + h*y;
    CH.Width := CH_ges.Width;
    CH.Left := CH_Ges.Left + w*x;

    inc(x);
    if x > 1 then
    begin
      x := 0;
      inc(y);
    end;
  end;

  Ress[0].CH.Caption := STR_Metall;
  Ress[1].CH.Caption := STR_Kristall;
  Ress[2].CH.Caption := STR_Deuterium;
  Ress[3].CH.Caption := STR_Energie;

  FillChar(s,sizeof(s),-1);
  Label8.Caption := '( ' + ODataBase.LanguagePlugIn.StatusToStr(s) + ' )';
end;

procedure TFRM_Filter.Button1Click(Sender: TObject);
begin
  ReadFilter;
  ModalResult := mrOK;
end;

procedure TFRM_Filter.SaveFilter(ini: TiniFile);
var i,j: integer;
begin
  ini.WriteBool(FilterSection,'Age_active',CH_AltersFilter_active.Checked);
  ini.WriteString(FilterSection,'Age_d',TXT_AlterTage.Text);
  ini.WriteString(FilterSection,'Age_h',TXT_AlterStunden.Text);
  ini.WriteString(FilterSection,'Age_m',TXT_AlterMinuten.Text);

  ini.WriteBool(FilterSection,'res_all_active',CH_ges.Checked);
  ini.WriteString(FilterSection,'res_all_val',TXT_ges.Text);
  for i := 0 to length(Ress)-1 do
  begin
    ini.WriteBool(FilterSection,Format('ress_%d_active',[i]),Ress[i].CH.Checked);
    ini.WriteString(FilterSection,Format('ress_%d_val',[i]),Ress[i].TXT.Text);
  end;

  //def
  ini.WriteBool(FilterSection,'def_active',CH_Def.Checked);
  ini.WriteInteger(FilterSection,'def_<>',CB_Def.ItemIndex);
  ini.WriteString(FilterSection,'def_val',TXT_Def.Text);
  //fleet
  ini.WriteBool(FilterSection,'fleet_active',CH_Fleet.Checked);
  ini.WriteInteger(FilterSection,'fleet_<>',CB_Fleet.ItemIndex);
  ini.WriteString(FilterSection,'fleet_val',TXT_Fleet.Text);
  //Stati
  ini.WriteString(FilterSection,'stati_mit',TXT_Status_mit.Text);
  ini.WriteBool(FilterSection,'stati_not',cb_stat_negativ.Checked);


  ini.WriteInteger(FilterSection,'area_count',length(Areas));
  for j := 0 to length(Areas)-1 do
  begin
    ini.WriteString(FilterSection,'area_'+inttostr(j)+'_name',Areas[j].name);
    ini.WriteString(FilterSection,'area_'+inttostr(j),Areas[j].GetAsString);
  end;
end;

procedure TPlanetRangeList.ReadFromString(s: string);
var p: integer;
    pr: TPlanetRange;
begin
  p := pos(';',s);
  while (p > 0) do
  begin
    pr := TPlanetRange.Create;
    pr.ReadFromString(copy(s,1,p-1));
    AddPlanetRange(pr);
    System.delete(s,1,p);
    p := pos(';',s);
  end;
end;

procedure TFRM_Filter.LoadFilter(ini: TInifile);
var i,j, c: integer;
begin
  CH_AltersFilter_active.Checked := ini.ReadBool(FilterSection,'Age_active',CH_AltersFilter_active.Checked);
  TXT_AlterTage.Text := ini.ReadString(FilterSection,'Age_d',TXT_AlterTage.Text);
  TXT_AlterStunden.Text := ini.ReadString(FilterSection,'Age_h',TXT_AlterStunden.Text);
  TXT_AlterMinuten.Text := ini.ReadString(FilterSection,'Age_m',TXT_AlterMinuten.Text);

  CH_ges.Checked := ini.ReadBool(FilterSection,'res_all_active',CH_ges.Checked);
  TXT_ges.Text := ini.ReadString(FilterSection,'res_all_val',TXT_ges.Text);
  for i := 0 to length(Ress)-1 do
  begin
    Ress[i].CH.Checked := ini.ReadBool(FilterSection,Format('ress_%d_active',[i]),Ress[i].CH.Checked);
    Ress[i].TXT.Text := ini.ReadString(FilterSection,Format('ress_%d_val',[i]),Ress[i].TXT.Text);
  end;

  //Def
  CH_Def.Checked := ini.ReadBool(FilterSection,'def_active',CH_Def.Checked);
  CB_Def.ItemIndex := ini.ReadInteger(FilterSection,'def_<>',CB_Def.ItemIndex);
  TXT_Def.Text := ini.ReadString(FilterSection,'def_val',TXT_Def.Text);
  //Fleet
  CH_Fleet.Checked := ini.ReadBool(FilterSection,'fleet_active',CH_Fleet.Checked);
  CB_Fleet.ItemIndex := ini.ReadInteger(FilterSection,'fleet_<>',CB_Fleet.ItemIndex);
  TXT_Fleet.Text := ini.ReadString(FilterSection,'fleet_val',TXT_Fleet.Text);
  //Stati
  TXT_Status_mit.Text := ini.ReadString(FilterSection,'stati_mit',TXT_Status_mit.Text);
  cb_stat_negativ.Checked := ini.ReadBool(FilterSection,'stati_not',cb_stat_negativ.Checked);

  c := ini.ReadInteger(FilterSection,'area_count',0);
  setlength(Areas,c);
  CB_KoordB.Clear;
  for j := 0 to c-1 do
  begin
    Areas[j] := TPlanetRangeList.Create(Self);
    Areas[j].name := ini.ReadString(FilterSection,'area_'+inttostr(j)+'_name','');
    Areas[j].ReadFromString(ini.ReadString(FilterSection,'area_'+inttostr(j),''));
  end;

  ReadFilter;
end;

procedure TFRM_Filter.TXT_Status_mitKeyPress(Sender: TObject; var Key: Char);
begin
  if (ODataBase.LanguagePlugIn.StrToStatus(key) = [])and(key <> #8) then
  begin
    Key := #0;
  end;
end;

function TFRM_Filter.AddArea(s: string): integer;
begin
  Result := length(Areas);
  SetLength(Areas,Result+1);
  Areas[Result] := TPlanetRangeList.Create(Self);
  Areas[Result].Name := s;

  Refresh_CB_KoordB;
end;

procedure TFRM_Filter.Button4Click(Sender: TObject);
var s: string;
begin
  s := 'neu';
  if InputQuery('Neuer Raumfilter','Name:', s) then
  begin
    AddArea(s);
  end;
end;

procedure TFRM_Filter.Refresh_CB_KoordB;
var i: Integer;
begin
  CB_KoordB.Clear;
  for i := 0 to length(Areas)-1 do
  begin
    CB_KoordB.AddItem(Areas[i].Name,nil);
  end;
end;

procedure TFRM_Filter.FormShow(Sender: TObject);
begin
  Refresh_CB_KoordB;
  Fav_Pages.ActivePageIndex := 0;
end;

function TPlanetRangeList.AddPlanetRange(pr: TPlanetRange): Integer;
begin
  Result := FPRList.Add(pr);
end;

procedure TPlanetRangeList.Clear;
var i: Integer;
begin
  for i := 0 to FPRList.Count-1 do
    TPlanetRange(FPRList[i]).Free;

  FPRList.Clear;
end;

constructor TPlanetRangeList.Create(AOwner: TComponent);
begin
  inherited;
  FPRList := TList.Create;
end;

destructor TPlanetRangeList.Destroy;
begin
  Clear;
  FPRList.Free;

  inherited;
end;

function TPlanetRangeList.GetCount: Integer;
begin
  Result := FPRList.Count;
end;

function TPlanetRangeList.GetPlanetRange(Index: Integer): TPlanetRange;
begin
  Result := TPlanetRange(FPRList[Index]);
end;

procedure TPlanetRangeList.Delete(Index: Integer);
begin
  TPlanetRange(FPRList[Index]).Free;
  FPRList.Delete(Index);
end;

function TPlanetRangeList.GetAsString: String;
var i: integer;
begin
  Result := '';
  for i := 0 to Count-1 do
  begin
    Result := Result + PlanetRange[i].GetAsString + ';';
  end;
end;

procedure TFRM_Filter.DeleteArea(Index: Integer);
var i: integer;
begin
  if (Index < 0)or(Index >= length(Areas)) then
    raise Exception.Create('TFRM_Filter.DeleteArea: Index out of range!');

  Areas[Index].Free;
  for i := Index to length(Areas)-2 do
    Areas[i] := Areas[i+1];
  SetLength(Areas,length(Areas)-1);

  Refresh_CB_KoordB;
end;

procedure TFRM_Filter.Button3Click(Sender: TObject);
begin
  DeleteArea(CB_KoordB.ItemIndex);
end;

end.
