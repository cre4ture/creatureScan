unit Suche;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Gauges, StdCtrls, ExtCtrls, ComCtrls, Mask, Tabnotbk, OGame_Types, Prog_Unit, ImgList,
  Menus, Galaxy_Explorer, VirtualTrees, Galaxien_Rechte, VSTPopup, inifiles,
  clipbrd, VTHeaderPopup, Math, FavFilter, langmodform, frm_pos_size_ini,
  PlanetListInterface;

const
  SearchiniSection = 'SearchWindow';

type
  TSearch_ND = record
    Player, Allianz, Planet: string;
    Status: TStatus;
    Koord: TPlanetPosition;
    Platz, FleetPlatz, AllyPlatz: Cardinal;
    Punkte, FleetPunkte, AllyPunkte: Cardinal;
    Datum: TDateTime;
    TF: array[0..1] of Cardinal;
    scantime_u: Int64;
  end;
  TFRM_SuchePlanetListInterface = class;
  TFRM_Suche = class(TLangModForm)
    ImageList1: TImageList;
    PopupMenu1: TPopupMenu;
    StatusBar1: TStatusBar;
    Lschen: TMenuItem;
    P_Top: TPanel;
    BTN_Suche: TButton;
    CH_Del_Result: TCheckBox;
    BTN_Schliesen: TButton;
    PageControl1: TPageControl;
    Search_Normal: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    Label8: TLabel;
    TXT_Player: TEdit;
    TXT_Planet: TEdit;
    TXT_ally: TEdit;
    Search_Status: TTabSheet;
    VST_Result: TVirtualStringTree;
    Kopieren1: TMenuItem;
    LscheallenichtMonde1: TMenuItem;
    N1: TMenuItem;
    AllybeinolleXdesuchen1: TMenuItem;
    PlayerbeinolleXdesuchen1: TMenuItem;
    GroupBox1: TGroupBox;
    TXT_Status: TEdit;
    CH_Status_Genau: TCheckBox;
    GroupBox2: TGroupBox;
    Label3: TLabel;
    TXT_TF: TEdit;
    KoordinatenKopieren1: TMenuItem;
    VTHeaderPopupMenu1: TVTHeaderPopupMenu;
    GroupBox3: TGroupBox;
    Label4: TLabel;
    cb_punkte_gk: TComboBox;
    cb_flotte_gk: TComboBox;
    Label5: TLabel;
    cb_punkte_pp: TComboBox;
    cb_flotte_pp: TComboBox;
    txt_punkte: TEdit;
    txt_flotte: TEdit;
    lbl_statusinfo: TLabel;
    GroupBox4: TGroupBox;
    cb_koords: TComboBox;
    cb_negativearea: TCheckBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BTN_SucheClick(Sender: TObject);
    procedure BTN_SchliesenClick(Sender: TObject);
    procedure StatusBar1DrawPanel(StatusBar: TStatusBar;
      Panel: TStatusPanel; const Rect: TRect);
    procedure FormCreate(Sender: TObject);
    procedure VST_ResultGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure VST_ResultDblClick(Sender: TObject);
    procedure VST_ResultFocusChanged(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex);
    procedure VST_ResultGetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: Integer);
    procedure VST_ResultCompareNodes(Sender: TBaseVirtualTree; Node1,
      Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure VST_ResultHeaderClick(Sender: TVTHeader;
      Column: TColumnIndex; Button: TMouseButton; Shift: TShiftState; X,
      Y: Integer);
    procedure Kopieren1Click(Sender: TObject);
    procedure LschenClick(Sender: TObject);
    procedure LscheallenichtMonde1Click(Sender: TObject);
    procedure StatusBar1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure AllybeinolleXdesuchen1Click(Sender: TObject);
    procedure PlayerbeinolleXdesuchen1Click(Sender: TObject);
    procedure Search_NormalShow(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure KoordinatenKopieren1Click(Sender: TObject);
    procedure VST_ResultPaintText(Sender: TBaseVirtualTree;
      const TargetCanvas: TCanvas; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType);
    procedure TXT_StatusKeyPress(Sender: TObject; var Key: Char);
    procedure cb_koordsEnter(Sender: TObject);
    procedure cb_koordsChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure VST_ResultBeforeItemPaint(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect;
      var CustomDraw: Boolean);
  private
    mPosListInterface: TPlanetListInterface;
    e, Topmost : boolean;
    Direction : TSortDirection;
    FilterArea: TPlanetRangeList;
    procedure Refresh_cb_koords;
    function get_ScanTime_u(pos: TPlanetPosition): int64;
    { Private-Deklarationen }
  public
    procedure Clear;
    function SucheSysteme: integer;
    procedure DeleteEmptyCharEdit(Edit: TEdit);
    function getFocusedPlanet(): TPlanetPosition;
    { Public-Deklarationen }
  protected
    inifile: String;
    PROCEDURE CreateParams(VAR Params: TCreateParams); OVERRIDE;
    procedure Notification(AComponent: TComponent; Operation: TOperation);
      override;
  end;
  TFRM_SuchePlanetListInterface = class(TPlanetListInterface)
  private
    mFRM_Suche: TFRM_Suche;
  public
    constructor Create(frm_suche: TFRM_Suche); reintroduce;
    function selectNextPlanet(out pos: TPlanetPosition): Boolean; override;
    function getPlanet(): TPlanetPosition; override;
    function selectPreviousPlanet(out pos: TPlanetPosition): Boolean; override;
  end;

const
  STAT_Laden = 1;
  STAT_Summary = 2;
  STAT_Topmost = 0;

function trim_X(s: string): string;

implementation

uses Main, Languages, DateUtils, Stat_Points, Favoriten;

{$R *.DFM}

procedure TFRM_Suche.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  if Operation = opRemove then
  begin
    if AComponent = FilterArea then
    begin
      FilterArea := nil;
      Refresh_cb_koords;
    end;
  end;
  inherited;
end;

PROCEDURE TFRM_Suche.CreateParams;
begin
  INHERITED;

  begin
    Params.ExStyle := Params.ExStyle OR WS_EX_APPWINDOW;
    Params.WndParent:= 0;//Application.Handle;
  end;
end;

procedure TFRM_Suche.Clear;
begin
  TXT_Player.Text := '';
  TXT_Planet.Text := '';
  TXT_ally.Text := '';
  VST_Result.Clear;
end;

function TFRM_Suche.SucheSysteme: integer;
var s_punkte, s_flotte: Integer;

  function FilterStats(place, points, fleetplace, fleetpoints: integer): Boolean;
  begin
    Result := True;
    case cb_punkte_gk.ItemIndex of
    0:; //nix
    1:  //gr��er
       case cb_punkte_pp.ItemIndex of
       0: //platz
         Result := (place = 0)or(place > s_punkte);
       1: //punkte
         Result := (points > s_punkte);
       end;
    2:  //kleiner
       case cb_punkte_pp.ItemIndex of
       0: //platz
         Result := (place <> 0)and(place < s_punkte);
       1: //punkte
         Result := (points < s_punkte);
       end;
    end;

    if Result then
    begin
      case cb_flotte_gk.ItemIndex of
      0:; //nix
      1:  //gr��er
         case cb_flotte_pp.ItemIndex of
         0: //platz
           Result := (fleetplace = 0)or(fleetplace > s_flotte);
         1: //punkte
           Result := (fleetpoints > s_flotte);
         end;
      2:  //kleiner
         case cb_flotte_pp.ItemIndex of
         0: //platz
           Result := (fleetplace <> 0)and(fleetplace < s_flotte);
         1: //punkte
           Result := (fleetpoints < s_flotte);
         end;
      end;
    end;
  end;

  function SearchSystem(Sys : Integer): integer;
  var Planet : integer;
      TF: cardinal;
      Mond: Boolean;
      ItemData: ^TSearch_ND;
      P: TPlanetPosition;
      flags: TStatus;
      statsplace, statpoints, fleetplace, fleetpoints: Integer;
      areaf: boolean;
  begin
    Result := 0;
    TF := StrToInt(TXT_TF.Text);
    flags := ODataBase.LanguagePlugIn.StrToStatus(TXT_Status.Text);
    s_punkte := StrToInt(txt_punkte.Text);
    s_flotte := StrToInt(txt_flotte.Text);

    with ODataBase.Systeme[Sys] do
     with ODataBase do
     begin
      for Planet := 1 to max_Planeten do
      for Mond := false to True do
      begin
        P := System;
        P.P[2] := Planet;
        P.Mond := Mond;


          areaf := (FilterArea = nil)or
                   (not (FilterArea.isElement(p) xor cb_negativearea.Checked));

        if (areaf)and
           ((not p.Mond)or(Planeten[p.P[2]].MondSize > 0))and
          (((TXT_Player.Text = '')or(pos(UpperCase(TXT_Player.Text),UpperCase(Planeten[P.P[2]].Player)) > 0))and
           ((TXT_ally.Text = '')or(pos(UpperCase(TXT_ally.Text),UpperCase(Planeten[P.P[2]].Ally)) > 0))and
           ((TXT_Planet.Text = '')or(p.Mond and (UpperCase(TXT_Planet.Text) = UpperCase(STR_Mond)))or(pos(UpperCase(TXT_Planet.Text),UpperCase(Planeten[P.P[2]].PlanetName)) > 0)))and
           ((TXT_Status.Text = '')or(((not CH_Status_Genau.Checked)and(flags <= Planeten[Planet].Status)))or(CH_Status_Genau.Checked and (flags = Planeten[Planet].Status)))and
           (Planeten[Planet].TF[0] + Planeten[Planet].TF[1] >= TF)  then
        begin
          statsplace := ODataBase.Stats.StatPlace(Planeten[Planet].Player);
          statpoints := ODataBase.Stats.Statistik[statsplace].Punkte;

          fleetplace := ODataBase.FleetStats.StatPlace(Planeten[Planet].Player);
          fleetpoints := ODataBase.FleetStats.Statistik[fleetplace].Punkte;

          if FilterStats(statsplace, statpoints, fleetplace, fleetpoints) then
          begin
             ItemData := VST_Result.GetNodeData(VST_Result.AddChild(nil));
             inc(Result);
             ItemData^.Player := Planeten[Planet].Player;
             ItemData^.Status := Planeten[Planet].Status;
             ItemData^.Koord := P;
             ItemData^.Allianz := Planeten[Planet].Ally;
             ItemData^.Platz := statsplace;
             ItemData^.FleetPlatz := ODataBase.FleetStats.StatPlace(Planeten[Planet].Player);
             ItemData^.AllyPlatz := ODataBase.AllyStats.StatPlace(Planeten[Planet].Ally);
             ItemData^.Punkte := statpoints;
             ItemData^.FleetPunkte := ODataBase.FleetStats.Statistik[ItemData^.FleetPlatz].Punkte;
             ItemData^.AllyPunkte := ODataBase.AllyStats.Statistik[ItemData^.AllyPlatz].Punkte;
             ItemData^.TF[0] := Planeten[Planet].TF[0];
             ItemData^.TF[1] := Planeten[Planet].TF[1];
             ItemData^.Datum := UnixToDateTime(Time_u);
             if p.Mond then
               ItemData^.Planet := STR_Mond
             else ItemData^.Planet := Planeten[Planet].PlanetName;

             //UHO: 11.08.2008: Auf neue Zugriffstechnik "umger�stet"
             //UHO: 26.12.2008: Scantime wird jetzt live nachgeschaut
             {scannr := ODataBase.UniTree.UniReport(P);
             if scannr <> -1 then
             //if (ODataBase.Uni[P.P[0],P.P[1]].Planeten[P.P[2],P.Mond].ScanBericht <> -1) then
             //  ItemData^.ScanTime := UnixToDateTime(ODataBase.Berichte[ODataBase.Uni[P.P[0],P.P[1]].Planeten[P.P[2],P.Mond].ScanBericht].Head.Time_u)
               ItemData^.ScanTime := UnixToDateTime(ODataBase.Berichte[scannr].Head.Time_u)
             else ItemData^.ScanTime := -1;}
          end;
        end;
      end;
    end;
  end;

var i,max : integer;
begin
  VST_Result.BeginUpdate;
  if CH_Del_Result.Checked then VST_Result.Clear;
  e := false;
  max := ODataBase.Systeme.Count;
  StatusBar1.Panels[STAT_Laden].Text := inttostr(0);
  Application.ProcessMessages;
  Result := 0;
  for i := 0 to ODataBase.Systeme.Count-1 do
  begin
    inc(Result,SearchSystem(i));
    StatusBar1.Panels[STAT_Laden].Text := IntToStr(trunc((i/max)*100));
    Application.ProcessMessages;
    if e then
      break;
  end;
  VST_Result.EndUpdate;
end;

procedure TFRM_Suche.BTN_SucheClick(Sender: TObject);
//var i: integer;
begin
  if not e then
    e := true
  else
  if (TXT_Player.Text <> '')or
     (TXT_Planet.Text <> '')or
     (TXT_ally.Text <> '')or
     (TXT_Status.Text <> '')or
     (TXT_TF.Text <> '0')or
     (cb_punkte_gk.ItemIndex > 0)or
     (cb_flotte_gk.ItemIndex > 0) then
  begin
    BTN_Suche.Caption := STR_Stopp;
    DeleteEmptyCharEdit(TXT_Player);
    DeleteEmptyCharEdit(TXT_Planet);
    DeleteEmptyCharEdit(TXT_ally);
    StatusBar1.Panels[STAT_Summary].Text := STR_Ergebnisse + IntToStr(SucheSysteme);
    BTN_Suche.Caption := STR_Suchen;
    e := true;
    StatusBar1.Panels[STAT_Laden].Text := '100';
  end
  else
    StatusBar1.Panels[STAT_Summary].Text := STR_MSG_keine_Suchkriterien;
end;

procedure TFRM_Suche.BTN_SchliesenClick(Sender: TObject);
begin
  Close;
end;

procedure TFRM_Suche.StatusBar1DrawPanel(StatusBar: TStatusBar;
  Panel: TStatusPanel; const Rect: TRect);
var re : TRect;
begin
  with StatusBar.Canvas do
  begin
    re := Rect;
    re.Right := trunc((Rect.Right-Rect.Left) * (StrToInt(Panel.Text) / 100)) + Rect.Left;
    Brush.Color := StatusBar.Color;
    FillRect(Rect);
    Brush.Color := clBlue;
    FillRect(re);
  end;
end;

procedure TFRM_Suche.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Release;
end;

procedure TFRM_Suche.FormCreate(Sender: TObject);
var ini: TIniFile;
    s: TStatus;
begin
  e := true;
  VST_Result.NodeDataSize := Sizeof(TSearch_ND);

  inifile := ODataBase.PlayerInf;
  ini := TIniFile.Create(inifile);
  LoadVSTHeaders(VST_Result,ini,SearchiniSection);
  LoadFormSizePos(ini, {trim_X}(Name), Self);
  ini.Free;

  FillChar(s,sizeof(s),-1);
  lbl_statusinfo.Caption := '( ' + ODataBase.LanguagePlugIn.StatusToStr(s) + ' )';

  Refresh_cb_koords;
  StatusBar1.Panels[0].Text := STR_topmost;

  mPosListInterface := TFRM_SuchePlanetListInterface.Create(self);
end;

procedure TFRM_Suche.DeleteEmptyCharEdit(Edit: TEdit);
var s: string;
begin
  s := Edit.Text;
  DeleteEmptyChar(s);
  Edit.Text := s;
end;

procedure TFRM_Suche.VST_ResultGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
begin
  CellText := '-';
  with TSearch_ND(Sender.GetNodeData(node)^) do
  begin
    case Column of
      0: CellText := Player;
      1: CellText := PositionToStrMond(Koord);
      2: CellText := Allianz;
      3: CellText := Planet;
      4: begin
           if scantime_u <> -1 then
             CellText := ODataBase.Time_To_AgeStr(UnixToDateTime(scantime_u))
           else CellText := '';
         end;
      5: CellText := IntToStr(Platz);
      6: CellText := FloatToStrF(Punkte,ffNumber,60000000,0);
      7: CellText := IntToStr(FleetPlatz);
      8: CellText := FloatToStrF(FleetPunkte,ffNumber,60000000,0);
      9: CellText := IntToStr(AllyPlatz);
     10: CellText := FloatToStrF(AllyPunkte,ffNumber,60000000,0);
     11: CellText := IntToStrKP(TF[0]+TF[1]);
     12: CellText := ODataBase.LanguagePlugIn.StatusToStr(Status);
     13: CellText := ODataBase.Time_To_AgeStr(Datum);
    end;
  end;
end;

procedure TFRM_Suche.VST_ResultDblClick(Sender: TObject);
begin
  if VST_Result.FocusedNode <> nil then
  with TSearch_ND(VST_Result.GetNodeData(VST_Result.FocusedNode)^) do
  begin
    FRM_Main.ShowGalaxie(Koord);
  end;
end;

procedure TFRM_Suche.VST_ResultFocusChanged(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex);
begin
  if (node <> nil) then
  with TSearch_ND(VST_Result.GetNodeData(Node)^) do
  begin
    Caption := 'S [' + PositionToStrMond(Koord) + '] ' + 'Suche in dem Universumsabbild nach...';

    FRM_Main.ShowScan(Koord, mPosListInterface);     
  end;
end;

procedure TFRM_Suche.VST_ResultGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);
begin
  if Column = 0 then
  with TSearch_ND(VST_Result.GetNodeData(Node)^) do
  begin
    if Koord.Mond then ImageIndex := 1 else ImageIndex := 0;
    if scantime_u <> -1 then ImageIndex := ImageIndex + 2;
  end;
end;

procedure TFRM_Suche.VST_ResultCompareNodes(Sender: TBaseVirtualTree;
  Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var S1, S2: WideString;
    nd1, nd2: TSearch_ND;
begin
  nd1 := TSearch_ND(Sender.GetNodeData(node1)^);
  nd2 := TSearch_ND(Sender.GetNodeData(node2)^);
  case Column of
  1: if PosBigger(nd1.Koord,nd2.Koord) then Result := 1 else Result := -1;
  4: Result := CompareValue(get_ScanTime_u(nd1.Koord),get_ScanTime_u(nd2.Koord));
  5, 6: if(nd1.Punkte > nd2.Punkte) then Result := 1 else Result := -1;
  7, 8: if(nd1.FleetPunkte > nd2.FleetPunkte) then Result := 1 else Result := -1;
  9, 10: if(nd1.AllyPunkte > nd2.AllyPunkte) then Result := 1 else Result := -1;
  11: if (nd1.TF[0]+nd1.TF[1] > nd2.TF[0]+nd2.Tf[1]) then Result := 1 else Result := -1;
  13: Result := CompareValue(nd1.Datum, nd2.Datum);
  else
    VST_ResultGetText(Sender,Node1,Column,ttNormal,S1);
    VST_ResultGetText(Sender,Node2,Column,ttNormal,S2);
    if LowerCase(S1) > LowerCase(S2) then Result := 1 else Result := -1;
  end;
end;

procedure TFRM_Suche.VST_ResultHeaderClick(Sender: TVTHeader;
  Column: TColumnIndex; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  if Button = mbLeft then
  begin
    if Direction = sdDescending then Direction := sdAscending else inc(Direction);
    Sender.Treeview.SortTree(Column,Direction);
  end;
end;

procedure TFRM_Suche.Kopieren1Click(Sender: TObject);
begin
  VST_Result.CopyToClipBoard
end;

procedure TFRM_Suche.LschenClick(Sender: TObject);
begin
  VST_Result.DeleteSelectedNodes;
end;

procedure TFRM_Suche.LscheallenichtMonde1Click(Sender: TObject);
var node, n: PVirtualNode;
    ND: ^TSearch_ND;
begin
  node := VST_Result.GetFirst;
  while node <> nil do
  begin
    n := node;
    node := VST_Result.GetNext(Node);
    ND := VST_Result.GetNodeData(n);
    if not ND^.Koord.Mond then VST_Result.DeleteNode(n);
  end;
end;

procedure TFRM_Suche.StatusBar1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if x < StatusBar1.Panels[STAT_Topmost].Width then
  begin
    Topmost := not Topmost;
    if Topmost
      then begin SetWindowPos(Handle,HWND_TOPMOST,0,0,0,0,SWP_NOMOVE OR SWP_NOSIZE); StatusBar1.Panels[STAT_Topmost].Text := STR_normal; end
      else begin SetWindowPos(Handle,HWND_NOTOPMOST,0,0,0,0,SWP_NOMOVE OR SWP_NOSIZE); StatusBar1.Panels[STAT_Topmost].Text := STR_topmost; end;
  end;
end;

procedure TFRM_Suche.PopupMenu1Popup(Sender: TObject);
begin
  Allybeinollexdesuchen1.Caption := STR_Ally_Suchen + FRM_Main.PlayerOptions.SuchInet.Name;
  PlayerbeinollexdeSuchen1.Caption := STR_Player_Suchen + FRM_Main.PlayerOptions.SuchInet.Name;
  AllybeinolleXdesuchen1.Visible := (VST_Result.GetFirstSelected <> nil)and(TSearch_ND(VST_Result.GetNodeData(VST_Result.GetFirstSelected)^).Allianz <> '');
end;

procedure TFRM_Suche.AllybeinolleXdesuchen1Click(Sender: TObject);
var nd: TSearch_ND;
begin
  if VST_Result.GetFirstSelected <> nil then
  begin
    nd := TSearch_ND(VST_Result.GetNodeData(VST_Result.GetFirstSelected)^);
    FRM_Main.SucheImInet(sitAllanz,nd.Allianz,nd.Player,ODataBase.UniDomain);
  end;
end;

procedure TFRM_Suche.PlayerbeinolleXdesuchen1Click(Sender: TObject);
var nd: TSearch_ND;
begin
  if VST_Result.GetFirstSelected <> nil then
  begin
    nd := TSearch_ND(VST_Result.GetNodeData(VST_Result.GetFirstSelected)^);
    FRM_Main.SucheImInet(sitPlayer,nd.Allianz,nd.Player,ODataBase.UniDomain);
  end;
end;

procedure TFRM_Suche.Search_NormalShow(Sender: TObject);
begin
  TXT_Player.SetFocus;
end;

procedure TFRM_Suche.FormShow(Sender: TObject);
begin
  PageControl1.ActivePage := Search_Normal;
  TXT_Player.SetFocus;
end;

procedure TFRM_Suche.KoordinatenKopieren1Click(Sender: TObject);
var node: PVirtualNode;
    s: string;
begin
  s := '';
  node := VST_Result.GetFirstSelected;
  while node <> nil do
  begin
    s := s + PositionToStrMond(TSearch_ND(VST_Result.GetNodeData(node)^).Koord);// + #13 + #10;

    node := VST_Result.GetNextSelected(node);
    if node <> nil then s := s + ', ';
  end;

  if s <> '' then
    Clipboard.AsText := s;
end;

procedure TFRM_Suche.VST_ResultPaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
begin
  with TSearch_ND(Sender.GetNodeData(node)^) do
  begin
    case Column of
       4: TargetCanvas.Font.Color := AlterToColor_dt(now - UnixToDateTime(scantime_u),ODataBase.redHours[rh_Scans]);
      13: TargetCanvas.Font.Color := AlterToColor_dt(now - Datum,ODataBase.redHours[rh_Systems]);
    end;
  end;
end;

procedure TFRM_Suche.TXT_StatusKeyPress(Sender: TObject; var Key: Char);
begin
  if (ODataBase.LanguagePlugIn.StrToStatus(key) = [])and(key <> #8) then
  begin
    Key := #0;
  end;
end;

procedure TFRM_Suche.Refresh_cb_koords;
var i: integer;
begin
  cb_koords.Items := FRM_Favoriten.CB_Koords.Items;
  for i := 0 to length(FRM_Filter.Areas)-1 do
  begin
    if FRM_Filter.Areas[i] = FilterArea then
    begin
      cb_koords.ItemIndex := i;
      exit;
    end;
  end;
  cb_koords.ItemIndex := 0;
end;

procedure TFRM_Suche.cb_koordsEnter(Sender: TObject);
begin
  Refresh_cb_koords;
end;

procedure TFRM_Suche.cb_koordsChange(Sender: TObject);
begin
  if (FilterArea <> nil) then
  begin
    FilterArea.RemoveFreeNotification(self);
    FilterArea := nil;
  end;

  if (cb_koords.ItemIndex-1 >= 0)and
     (cb_koords.ItemIndex-1 < length(FRM_Filter.Areas)) then
  begin
    FilterArea := FRM_Filter.Areas[cb_koords.ItemIndex-1];
    FilterArea.FreeNotification(self);
  end;
end;

function trim_X(s: string): string;
var p: integer;
begin
  p := Pos('_', s);
  if p > 0 then
    Result := copy(s,1,p-1)
  else
    Result := s;
end;

procedure TFRM_Suche.FormDestroy(Sender: TObject);
var ini: TIniFile;
begin
  mPosListInterface.Free;
  ini := TIniFile.Create(inifile);
  SaveVSTHeaders(VST_Result,ini,SearchiniSection);
  SaveFormSizePos(ini, {trim_X}(Name), Self);
  ini.UpdateFile;
  ini.Free;
end;

function TFRM_Suche.getFocusedPlanet: TPlanetPosition;
var node: PVirtualNode;
begin
  Result.P[0] := 0;
  node := VST_Result.FocusedNode;
  with TSearch_ND(VST_Result.GetNodeData(node)^) do
  begin
    Result := Koord;
  end;
end;

function TFRM_Suche.get_ScanTime_u(pos: TPlanetPosition): int64;
var scan: integer;
begin
  Result := -1;
  scan := ODataBase.UniTree.UniReport(pos);
  if scan >= 0 then
    Result := ODataBase.Berichte[scan].Head.Time_u;
end;

procedure TFRM_Suche.VST_ResultBeforeItemPaint(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect;
  var CustomDraw: Boolean);
begin
  with TSearch_ND(Sender.GetNodeData(node)^) do
  begin
    scantime_u := get_ScanTime_u(Koord);
  end;
end;

{ TFRM_SuchePlanetListInterface }

constructor TFRM_SuchePlanetListInterface.Create(frm_suche: TFRM_Suche);
begin
  inherited Create(frm_suche);
  mFRM_Suche := frm_suche;
end;

function TFRM_SuchePlanetListInterface.getPlanet: TPlanetPosition;
begin
  Result := mFRM_Suche.getFocusedPlanet();
end;

function TFRM_SuchePlanetListInterface.selectNextPlanet(
  out pos: TPlanetPosition): Boolean;
var node: PVirtualNode;
begin
  node := mFRM_Suche.VST_Result.FocusedNode;
  node := mFRM_Suche.VST_Result.GetNext(node);
  Result := node <> nil;
  if Result then
  begin
    mFRM_Suche.VST_Result.FocusedNode := node;
    mFRM_Suche.VST_Result.ClearSelection;
    mFRM_Suche.VST_Result.Selected[node] := true;
    pos := mFRM_Suche.getFocusedPlanet();
  end;
end;

function TFRM_SuchePlanetListInterface.selectPreviousPlanet(
  out pos: TPlanetPosition): Boolean;
var node: PVirtualNode;
begin
  node := mFRM_Suche.VST_Result.FocusedNode;
  node := mFRM_Suche.VST_Result.GetPrevious(node);
  Result := node <> nil;
  if Result then
  begin
    mFRM_Suche.VST_Result.FocusedNode := node;
    mFRM_Suche.VST_Result.ClearSelection;
    mFRM_Suche.VST_Result.Selected[node] := true;
    pos := mFRM_Suche.getFocusedPlanet();
  end;
end;

end.

