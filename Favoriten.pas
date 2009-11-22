unit Favoriten;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, ExtCtrls, Menus, Galaxy_Explorer, OGame_Types, Prog_Unit, IniFiles, Buttons,
  StdCtrls, ImgList, VirtualTrees, VSTPopup, VTHeaderPopup, FavFilter,
  topmost_uh, frm_pos_size_ini, Notizen, PlanetListInterface;

const filetype = 'cS favlist 1.0';
const filetypelength = 14;

type
  PPlanetItem = ^TPlanetItem;
  PFav = ^TFav;
  TFav = record
    InitPointer: PPlanetItem;
    Position : TPlanetPosition;
    ScanGrpCount: Integer;
    LastUpdate: TDateTime;
    Raid_dt: TDateTime;
    Last24h: Integer;
    RaidCount: Integer;
    ScanTime: TDateTime;
    Fleet, Def: integer;
    Stars: Integer;
    Platz, FleetPlatz, Allyplatz: word;
    PlayerPunkte, FleetPunkte, Allypunkte: Cardinal;
    Ress: Array[0..4] of Integer;
    Ress_div_Def: integer;
    MProduction: Array[TRessType] of Integer;
    v_Ress: array[TRessType] of Integer;
    v_Ress_all: Integer;
    v_Ress_div_Def: integer;
    needed_energy: Integer;
    prod_faktor: single;
    MProductionAll: Integer;
    TF: TResources;
    notes: TNotizArray;
  end;
  TPlanetItem = record
    Pos: TPlanetPosition;
    Sterne: Integer;
    shown_node: PVirtualNode;  //Gibt den Eintrag in der VST-Liste an, (nil wenn rausgefiltert)
  end;
  //Fav-List: programmiert, aber dann dochnicht fertiggestellt und verwendet!
  TFavList = class
  private
    FList: TList;
  public
    constructor Create;
    destructor Destroy; override;
    function Add(planet: TPlanetPosition): Integer;
    procedure Delete(index: Integer);
  end;

  TFavFileEntry_10_Pos = packed record
    Position: packed array[0..2] of Word;
    P_Mond: Boolean;
  end;
  TFavFileEntry_10 = packed record
    Position: TFavFileEntry_10_Pos;
    Stars: Byte;
  end;

  TFRM_Fav_PlanetListInterface = class;
  TFavListType = (flt_list, flt_all_auto_list);
  TFRM_Favoriten = class(TForm)
    PopupMenu1: TPopupMenu;
    Galaxyansicht1: TMenuItem;
    P_Top: TPanel;
    StatusBar1: TStatusBar;
    lbl_text_adsad: TLabel;
    Notiz1: TMenuItem;
    BTN_Refresh: TSpeedButton;
    BTN_Add: TSpeedButton;
    VST_ScanList: TVirtualStringTree;
    Raid1: TMenuItem;
    ImageList1: TImageList;
    ImageList2: TImageList;
    N1: TMenuItem;
    Kopieren1: TMenuItem;
    Lschen1: TMenuItem;
    VTHeaderPopupMenu1: TVTHeaderPopupMenu;
    BTN_Filter: TButton;
    CB_Koords: TComboBox;
    Label2: TLabel;
    BTN_FilterArea_Anzeigen: TButton;
    tim_startsort: TTimer;
    IL_ScanSize: TImageList;
    PM_Notizen: TPopupMenu;
    musternotiz1: TMenuItem;
    procedure musternotiz1Click(Sender: TObject);
    procedure VST_ScanListGetPopupMenu(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; const P: TPoint;
      var AskParent: Boolean; var PopupMenu: TPopupMenu);
    procedure VST_ScanListClick(Sender: TObject);
    procedure Galaxyansicht1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BTN_AddClick(Sender: TObject);
    procedure Notiz1Click(Sender: TObject);
    procedure BTN_RefreshClick(Sender: TObject);
    procedure VST_ScanListGetNodeDataSize(Sender: TBaseVirtualTree;
      var NodeDataSize: Integer);
    procedure VST_ScanListHeaderClick(Sender: TVTHeader;
      Column: TColumnIndex; Button: TMouseButton; Shift: TShiftState; X,
      Y: Integer);
    procedure VST_ScanListFocusChanged(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex);
    procedure FormShow(Sender: TObject);
    procedure VST_ScanListGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure VST_ScanListCompareNodes(Sender: TBaseVirtualTree; Node1,
      Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure VST_ScanListPaintText(Sender: TBaseVirtualTree;
      const TargetCanvas: TCanvas; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType);
    procedure VST_ScanListBeforeCellPaint_(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      CellRect: TRect);
    procedure Raid1Click(Sender: TObject);
    procedure VST_ScanListDblClick(Sender: TObject);
    procedure VST_ScanListGetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: Integer);
    procedure VST_ScanListKeyPress(Sender: TObject; var Key: Char);
    procedure VST_ScanListAfterCellPaint(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      CellRect: TRect);
    procedure Kopieren1Click(Sender: TObject);
    procedure Lschen1Click(Sender: TObject);
    procedure BTN_FilterClick(Sender: TObject);
    procedure CB_KoordsChange(Sender: TObject);
    procedure BTN_FilterArea_AnzeigenClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure StatusBar1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure VST_ScanListInitNode(Sender: TBaseVirtualTree; ParentNode,
      Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure VST_ScanListFreeNode(Sender: TBaseVirtualTree;
      Node: PVirtualNode);
    procedure tim_startsortTimer(Sender: TObject);
    procedure VST_ScanListBeforeCellPaint(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      CellPaintMode: TVTCellPaintMode; CellRect: TRect;
      var ContentRect: TRect);
    procedure VST_ScanListMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure VST_ScanListMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
  published
  private
    mListInterface: TFRM_Fav_PlanetListInterface;
    //Direction: TSortDirection;
    //SColumn: Integer;
    IniFile: String;
    collecting: TMemIniFile;
    topmost: boolean;
    scanlist_file: TFileStream;
    VST_clickpos: TPoint;
    fListType: TFavListType;
    procedure LoadOptions;
    procedure SaveOptions;
    function Filter(Scan: TScanbericht): Boolean;
    function FleetPoints(Scan: TScanbericht): integer;
    function DefPoints(Scan: TScanbericht): integer;
    procedure updateNode(nd: PVirtualNode);
    procedure AddToVSTList_forceupdate(item: PPlanetItem);
    procedure SavePosition_Count(const i: Integer); overload;
    procedure SavePosition_Count(const item: PPlanetItem); overload;
    function getfilterinfo: string;
    procedure Set_CB_Koords(cb_k: TComboBox = nil);
    function getIntValColumn(Column: TColumnIndex; fav: TFav): Integer;
    procedure RemoveFromVSTList(item: PPlanetItem);
    procedure InitFavListFile(filename: string);
    procedure FreeFavListFile;
    function scanfile_getentrypos(index: integer): Int64;
    procedure LoadFavFileData;
    procedure LoadOldFromIni;
    procedure Refresh_and_delMissing;
    function getColumnAt(x: integer): integer;
    procedure SetListType(atyp: TFavListType);
    { Private-Deklarationen }
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation);
      override;
    PROCEDURE CreateParams(VAR Params: TCreateParams); OVERRIDE;
    function GameNow(): TDateTime;
  public
    FilterOptions: TFilter;
    FilterArea: TPlanetRangeList;
    ScanList: TList;
    FleetDefRessValues: array of Integer;  //KA, hat wohl keinen Nutzen?? -> vllt damals wegen TF berechnung !?
    FleetDefValues: array of integer;
    property ListType: TFavListType read fListType write SetListType;
    procedure AddByTime(alter: TDateTime);
    function Add(pos: TPlanetPosition; Sterne: integer = -1; load: boolean = False): integer;
    function Find(Pos: TPlanetPosition): integer;
    procedure Show;
    function getSelectedPlanet(): TPlanetPosition;
    { Public-Deklarationen }
  end;
  TFRM_Fav_PlanetListInterface = class(TPlanetListInterface)
  private
    mFRM_Fav: TFRM_Favoriten;
  public
    constructor Create(fav_frm: TFRM_Favoriten);
    function selectNextPlanet(out pos: TPlanetPosition): Boolean; override;
    function getPlanet(): TPlanetPosition; override;
    function selectPreviousPlanet(out pos: TPlanetPosition): Boolean; override;
  end;


const
  FavSection = 'Favoriten';

var
  FRM_Favoriten: TFRM_Favoriten;

implementation

uses Main, Languages, KB_List, DateUtils, Math, Stat_Points,
  UniTree, uebersicht, RaidBoard;

const
  fcol_Notizen = 30;

{$R *.DFM}

function TFRM_Favoriten.GameNow(): TDateTime;
begin
  Result := ODataBase.FleetBoard.GameTime.Time;
end;

procedure TFRM_Favoriten.SetListType(atyp: TFavListType);
begin
  fListType := atyp;
  
  BTN_Add.Visible := not (ListType = flt_all_auto_list);
  Lschen1.Enabled := BTN_Add.Visible;
end;

PROCEDURE TFRM_Favoriten.CreateParams;
begin
  INHERITED;
  //if Typ = 0 then
  begin
    Params.ExStyle := Params.ExStyle OR WS_EX_APPWINDOW;
    Params.WndParent:= 0;//Application.Handle;
  end;
end;

procedure TFRM_Favoriten.Galaxyansicht1Click(Sender: TObject);
begin
  if VST_ScanList.GetFirstSelected <> nil then
  with TFav(VST_ScanList.GetNodeData(VST_ScanList.GetFirstSelected)^) do
    FRM_Main.ShowGalaxie(position);
end;

procedure TFRM_Favoriten.FormDestroy(Sender: TObject);
begin
  mListInterface.Free;
  SaveOptions;
  SaveFormSizePos(IniFile,self);
  ScanList.Free;
  FreeFavListFile;
end;

procedure TFRM_Favoriten.FormCreate(Sender: TObject);
begin
  IniFile := ODataBase.PlayerInf;
  InitFavListFile(ODataBase.SaveDir + 'favlist.csdat');

  ScanList := TList.Create;
  if SaveCaptions then SaveAllCaptions(Self,LangFile);
  if LoadCaptions then LoadAllCaptions(Self,LangFile);
  topmost := false;
  StatusBar1.Panels[0].Text := STR_topmost;

  collecting := nil;
  LoadFormSizePos(IniFile,self);
  {//--- erstelle popup für headers ---------------------------------------------
  Menu := TVSTPopUpMenu.Create(Self);
  menu.VST := VST_ScanList;
  VST_ScanList.Header.PopupMenu := menu;
  //--- erstelle popup für headers - fertig ------------------------------------}
  FilterArea := nil;
  LoadOptions;       //erst filter laden
  LoadFavFileData;   //dann liste auffüllen
  LoadOldFromIni;    //alte laden und löschen

  mListInterface := TFRM_Fav_PlanetListInterface.Create(self);
end;

procedure TFRM_Favoriten.AddToVSTList_forceupdate(item: PPlanetItem);
//30.09.08 UHO OK
begin
  if not ValidPosition(item^.Pos) then
    Exit;

  if (item^.shown_node = nil)   //wenn nicht schon in der liste vorhanden
      then
  begin
    //item^.shown_node := VST_ScanList.AddChild(nil, item); -> wird in OnInitNode übernommen
    VST_ScanList.AddChild(nil, item);

    //Anzahl aktualisieren:
    StatusBar1.Panels[1].Text := STR_Anzahl + IntToStr(VST_ScanList.RootNodeCount);
  end
  else
  begin
    TFav(VST_ScanList.GetNodeData(item^.shown_node)^).LastUpdate := -1; //update erzwingen
  end;
end;

procedure TFRM_Favoriten.RemoveFromVSTList(item: PPlanetItem);
begin
  if (item^.shown_node <> nil) then //ist es überhaubt in der Liste vorhanden?
  begin
    VST_ScanList.DeleteNode(item^.shown_node);
    //item^.shown_node := nil; -> wird in OnFreeNode übernommen  (wird auch bei "Clear" ausgeführt)

    //Anzahl aktualisieren:
    StatusBar1.Panels[1].Text := STR_Anzahl + IntToStr(VST_ScanList.RootNodeCount);
    StatusBar1.Refresh;
  end;
end;

procedure TFRM_Favoriten.BTN_AddClick(Sender: TObject);
var s: string;
    m: integer;
    ma: TDateTime;
begin
  if InputQuery(STR_Hinzufuegen,STR_Maximales_Alter,s) then
  begin
    try
      m := ReadInt(s,1);
    except
      m := high(m);
    end;
    ma := m/(24*60);
    AddByTime(ma);
  end;
end;

procedure TFRM_Favoriten.AddByTime(alter: TDateTime);
var g,s,p,i: integer;
    m: Boolean;
    pl: TPlanetPosition;
    pos: single;
begin
  VST_ScanList.BeginUpdate;
  try
    for g := 1 to max_Galaxy do
      for s := 1 to max_Systems do
      begin
        for p := 1 to max_Planeten do
          for m := false to true do
          begin
            i := ODataBase.UniTree.UniReport(g,s,p,m);
            if (i >= 0)and
               (GameNow - UnixToDateTime(ODataBase.Berichte[i].Head.Time_u) <= alter) then
            begin
              pl.P[0] := g;
              pl.P[1] := s;
              pl.P[2] := p;
              pl.Mond := m;
              Add(pl);
            end;
          end;
        pos := (((g-1)*max_Systems) + s)/(max_Galaxy*max_Systems);
        StatusBar1.Panels[2].Text := IntToStr(trunc(pos*100)) + '%';
        StatusBar1.Refresh;
      end;
  finally
    VST_ScanList.EndUpdate;
  end;
end;

procedure TFRM_Favoriten.LoadOptions;
var c,i,j, default: integer;
    sg: TScanGroup;
    ini: TIniFile;
begin
  //-längenberechnung
  c := 0;
  for sg := sg_Flotten to sg_Verteidigung do
    inc(c, ScanFileCounts[sg]);
  SetLength(FleetDefRessValues,c);
  SetLength(FleetDefValues,c);

  //laden
  ini := TIniFile.Create(IniFile);
  for i := 0 to length(FleetDefRessValues)-1 do
    FleetDefRessValues[i] := ini.ReadInteger(FavSection,'FleetDefRessValue'+inttostr(i),10000);
  for i := 0 to length(FleetDefValues)-1 do
  begin
    if i < ScanFileCounts[sg_Flotten] then
    begin
      // (Metall+Kristall)/100
      default := (fleet_resources[i][0] + fleet_resources[i][1]) div 100;
    end
    else
    begin
      j := i-ScanFileCounts[sg_Flotten];
      // (Metall+Kristall)/100
      if not def_ignoreFight[j] then
        default := (def_resources[j][0] + def_resources[j][1]) div 100
      else
        default := 0;
    end;

    if default < 0 then
      default := 1;

    FleetDefValues[i] := ini.ReadInteger(FavSection,'FleetDefValue'+inttostr(i),default);
  end;

  //Filter:
  FRM_Filter.LoadFilter(ini);
  Set_CB_Koords;
  FilterOptions := FRM_Filter.Filter;

  // Liste:
  if ini.ReadString(FavSection, 'list_type', 'auto') = 'auto' then
  begin
    ListType := flt_all_auto_list;
  end
  else
  begin
    ListType := flt_list;
  end;
  // Header
  LoadVSTHeaders(VST_ScanList,ini,FavSection);

  VST_ScanList.Header.SortColumn := ini.ReadInteger(FavSection, 'sort_column', VST_ScanList.Header.SortColumn);
  VST_ScanList.Header.SortDirection := TSortDirection(ini.ReadInteger(FavSection, 'sort_direction', Integer(VST_ScanList.Header.SortDirection)));

  ini.free;
end;

procedure TFRM_Favoriten.SaveOptions;
var i: integer;
    ini: TIniFile;
begin
  ini := TIniFile.Create(IniFile);
  
  for i := 0 to length(FleetDefRessValues)-1 do
    ini.WriteInteger(FavSection,'FleetDefRessValue'+inttostr(i),FleetDefRessValues[i]);
  for i := 0 to length(FleetDefValues)-1 do
    ini.WriteInteger(FavSection,'FleetDefValue'+inttostr(i),FleetDefValues[i]);


  // Liste:
  if ListType = flt_all_auto_list then
  begin
    ini.WriteString(FavSection, 'list_type', 'auto');
  end
  else
  begin
    ini.WriteString(FavSection, 'list_type', 'custom');
  end;

  SaveVSTHeaders(VST_ScanList,ini,FavSection);

  FRM_Filter.SaveFilter(ini);

  ini.WriteInteger(FavSection, 'sort_column', VST_ScanList.Header.SortColumn);
  ini.WriteInteger(FavSection, 'sort_direction', Integer(VST_ScanList.Header.SortDirection));

  ini.UpdateFile;
  ini.free;
end;

procedure TFRM_Favoriten.Notiz1Click(Sender: TObject);
var node: PVirtualNode;
begin
  node := VST_ScanList.GetFirstSelected;
  if node <> nil then
    FRM_Notizen.ShowAddDialog(TFav(VST_ScanList.GetNodeData(node)^).Position,nPlanet,Self);
end;

procedure TFRM_Favoriten.BTN_RefreshClick(Sender: TObject);
begin
  if ListType = flt_all_auto_list then
    AddByTime(9999999999999999);
  //lbl_filterinfo.Caption := 'aktive Filter: "' + getfilterinfo() + '"';
  Refresh_and_delMissing;
  //Belegung anzeigen:
  StatusBar1.Panels[1].Text := IntToStr(VST_ScanList.RootNodeCount) + ' / ' +
                               IntToStr(ScanList.Count) + ' Filter: ' + getfilterinfo();
end;

function TFRM_Favoriten.Add(pos: TPlanetPosition; Sterne: integer = -1; load: boolean = False): integer;
var i: integer;
//30.09.08 UHO OK, add wird auch von load verwendet
    item: PPlanetItem;
begin
  Result := -2;
  item := nil;
  if ValidPosition(Pos) then                                                         
  begin
    //Suche nach vorhandenem Eintrag: TODO: suchbaum!?  (oder einfach ein array[1..9,1..499,1..15] of pointer)
    Result := -1;
    for i := 0 to ScanList.Count-1 do
    begin
      item := ScanList[i];
      if SamePlanet(item^.Pos,Pos) then
      begin
        Result := i;
        if Sterne >= 0 then
          item^.Sterne := Sterne;
        break;
      end;
    end;

    //Wenn kein Eintrag gefunden -> neuen erstellen:
    if Result = -1 then
    begin
      New(item);
      item^.Pos := Pos;
      item^.shown_node := nil; //init

      if Sterne >= 0 then
        item^.Sterne := Sterne
      else item^.Sterne := 0;

      Result := ScanList.Add(item);
    end;

    //Auf Filter testen und aus der VST-Liste entfernen/hinzufügen
    i := ODataBase.UniTree.UniReport(pos);
    if (item <> nil) and
       (i >= 0) and
       Filter(ODataBase.Berichte[i]) then
    begin
      //hinzufügen: (nur wenn nicht schon vorhanden)
      AddToVSTList_forceupdate(item);

      //start sort timer (so wird nicht ständig sortiert, wenn mehrere Scans hinzukommen:
      tim_startsort.Enabled := True;
    end
    else
    begin
      //entfernen:
      RemoveFromVSTList(item);
    end;

    if not load then SavePosition_Count(Result); //sofort speichern!
  end;
end;

function TFRM_Favoriten.getfilterinfo: string;
var res: string;
    rc, i: integer;

  procedure add(s: string);
  begin
    if (rc > 0) then
      res := res + ', ';
    res := res + s;
    inc(rc);
  end;

begin
  rc := 0;
  res := '';
  if FilterArea <> nil then
    add('Koordinaten');

  with FilterOptions do
  begin
    if Alter.Aktiv then
      add('Alter/Datum');
    if Ress_Ges.Aktive then
      add('Ressourcen');

    for i := 0 to 3 do
    begin
      if MKDE[i].Aktive then
        add('ress_' + IntToStr(i));
    end;

    if Fleet.Aktive then
      add('Flotte');
    if Def.Aktive then
      add('Verteidigung');

    if Status_filter <> [] then
    begin
      if Status_negativ then
        add('!Status')
      else
        add('Status');
    end;
  end;
  if res = '' then
    res := 'n/a';
  result := res;
end;

function TFRM_Favoriten.Filter(Scan: TScanbericht): Boolean;
var GRess,i : integer;
//30.09.08 UHO OK
begin
  Result := True;

  if FilterArea <> nil then
  begin
    Result := Result and (not FilterArea.isElement(Scan.Head.Position));
  end;

  if Result then
    with FilterOptions do
    begin
      //Alter:
      Result := (not Alter.Aktiv)or(GameNow - UnixToDateTime(Scan.Head.Time_u) < FilterOptions.Alter.Alter);

      //Gesammt Resourcen:
      GRess := 0;
      for i := 0 to 2 do
        GRess := GRess + Scan.Bericht[sg_Rohstoffe][i];
      Result := Result and ((not Ress_Ges.Aktive)or(GRess > Ress_Ges.Value));

      //einzelne Resourcen:
      for i := 0 to 3 do
      begin
        Result := Result and ((not MKDE[i].Aktive)or(Scan.Bericht[sg_Rohstoffe][i] > MKDE[i].Value));
      end;

      //Flotten/Defence Punkte: Multi == 1 wenn größer, Multi = -1 wenn kleiner
      Result := Result and ((not Fleet.Aktive)or(FleetPoints(Scan)*Fleet.Multi > Fleet.Value*Fleet.Multi));
      Result := Result and ((not Def.Aktive)or(DefPoints(Scan)*Def.Multi > Def.Value*Def.Multi));

      //StatusFilter:
      i := ODataBase.GetSystemCopyNR(Scan.Head.Position);
      if i >= 0 then
      with ODataBase.Systeme[i], Planeten[Scan.Head.Position.P[2]] do
      begin
        if Status_negativ then
          Result := Result and ((Status * Status_filter) <> [])
        else
          Result := Result and ((Status * Status_filter) = []);
      end;
    end;
end;

function TFRM_Favoriten.FleetPoints(Scan: TScanbericht): integer;
var j: integer;
//27.12.08 UHO OK
begin
  if Scan.Bericht[sg_Flotten][0] < 0 then
    Result := -1
  else
  begin
    Result := 0;
    for j := 0 to ScanFileCounts[sg_Flotten]-1 do
    begin
      Result := Result + (Scan.Bericht[sg_Flotten][j]*FleetDefValues[j]);
    end;
  end;
end;

function TFRM_Favoriten.DefPoints(Scan: TScanbericht): integer;
var j: integer;
//27.12.08 UHO OK
begin
  if Scan.Bericht[sg_Verteidigung][0] < 0 then
    Result := -1
  else
  begin
    Result := 0;
    for j := 0 to ScanFileCounts[sg_Verteidigung]-1 do
    begin
      Result := Result + (Scan.Bericht[sg_Verteidigung][j]*
        FleetDefValues[ScanFileCounts[sg_Flotten]+j]);
    end;
  end;
end;

procedure TFRM_Favoriten.VST_ScanListGetNodeDataSize(
  Sender: TBaseVirtualTree; var NodeDataSize: Integer);
begin
  NodeDataSize := sizeof(TFav);
end;

procedure TFRM_Favoriten.VST_ScanListGetPopupMenu(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; const P: TPoint;
  var AskParent: Boolean; var PopupMenu: TPopupMenu);
var mi: TMenuItem;
    notes: TNotizArray;
    i: integer;
begin
  SetLength(Notes,0);
  if Column = fcol_Notizen then
  begin
    PopupMenu := PM_Notizen;
    PM_Notizen.Items.Clear;
    PM_Notizen.Images := FRM_Notizen.ImageList1;
    notes := TFav(VST_ScanList.GetNodeData(Node)^).notes;
    for i := 0 to length(Notes)-1 do
    begin
      mi := TMenuItem.Create(Self);
      mi.Caption := notes[i].Note;
      mi.ImageIndex := notes[i].Image;
      mi.Tag := Integer(notes[i].SNode);
      mi.OnClick := musternotiz1Click;
      PM_Notizen.Items.Add(mi);
    end;
  end
  else PopupMenu := PopupMenu1;
end;

procedure TFRM_Favoriten.VST_ScanListHeaderClick(Sender: TVTHeader;
  Column: TColumnIndex; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  if Button = mbLeft then
  begin
    if Sender.SortColumn = Column then
    begin
      if Sender.SortDirection = sdDescending then
        Sender.SortDirection := sdAscending
      else Sender.SortDirection := sdDescending;
    end
    else
      Sender.SortColumn := Column;
  end
  else
  begin

  end;
end;

procedure TFRM_Favoriten.VST_ScanListFocusChanged(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex);
begin
  if node <> nil then
  with TFav(VST_ScanList.GetNodeData(node)^) do
  begin
    FRM_Main.ShowScan(Position, mListInterface);
  end;
end;

procedure TFRM_Favoriten.FormShow(Sender: TObject);
begin
  BTN_RefreshClick(self);
end;

procedure TFRM_Favoriten.VST_ScanListGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var i: Integer;
    scan: TScanBericht;
    fav: TFav;
begin
  // WARNING: When adding here a new Column, don't forget adding it to
  // VST_ScanListCompareNodes as well!

  CellText := '-';
  updateNode(node);
  fav := TFav(VST_ScanList.GetNodeData(Node)^);
  with fav do
  begin
    //Immer:
    case Column of
      0: CellText := PositionToStrMond(Position);
      6: if Raid_dt > 0 then CellText := CountdownTimeToStr(Raid_dt - GameNow);
      7: if Last24h > 0 then CellText := IntToStr(Last24h);
    end;

    //Solsys:
    if ODataBase.GetSystemCopyNR(Position) >= 0 then
    with ODataBase.Systeme[ODataBase.GetSystemCopyNR(Position)], Planeten[Position.P[2]] do
    case Column of
      1: if not Position.Mond then CellText := PlanetName else CellText := STR_Mond;
      2: CellText := Player;
      3: CellText := ODataBase.LanguagePlugIn.StatusToStr(Status);
      4: CellText := Ally;

      15: if PlayerPunkte > 0 then CellText := FloatToStrF(PlayerPunkte,ffNumber,60000000,0);
      16: if FleetPunkte > 0 then CellText := FloatToStrF(FleetPunkte,ffNumber,60000000,0);
      17: if Stars > 0 then CellText := '';
      19: if Platz > 0 then CellText := IntToStr(Platz);
      20: if FleetPlatz > 0 then CellText := IntToStr(FleetPlatz);
      21: if Allyplatz > 0 then CellText := IntToStr(Allyplatz);
      22: if Allypunkte > 0 then CellText := FloatToStrF(Allypunkte,ffNumber,60000000,0);
    end;

    //Scan:
    i := ODataBase.UniTree.UniReport(Position);
    if i >= 0 then
    begin
      Scan := ODataBase.Berichte[i];
      with Scan do
      case Column of
        5: CellText := ODataBase.Time_To_AgeStr(ScanTime);
        8..12: CellText := FloatToStrF(Ress[Column-8],ffNumber,60000000,0);
        13: CellText := FloatToStrF(Fleet,ffNumber,60000000,0);
        14: CellText := FloatToStrF(Def,ffNumber,60000000,0);
        18: CellText := IntToStrKP(Ress_div_Def);
              
        23: CellText := FloatToStrF(MProductionAll,ffNumber,60000000,0);
        //TF (Flotte)
        24: CellText := IntToStrKP(tf[0] + tf[1] + tf[2]);
        //Berechnete Rohstoffe (Produktion mit einberechnet!)
        25..29,31: CellText := IntToStrKP(getIntValColumn(Column, fav));
      end;
    end;
  end;
end;

procedure TFRM_Favoriten.VST_ScanListClick(Sender: TObject);
var menu: TPopupMenu;
    b: Boolean;
    HitInfo: THitInfo;
begin
  VST_ScanList.GetHitTestInfoAt(VST_clickpos.X, VST_clickpos.Y, true, HitInfo);
  if (HitInfo.HitColumn = fcol_Notizen) and
     (HitInfo.HitNode <> nil) then
  begin
    VST_ScanList.OnGetPopupMenu(VST_ScanList,HitInfo.HitNode,
                        fcol_Notizen,Mouse.CursorPos,B,menu);
    menu.Popup(Mouse.CursorPos.X,Mouse.CursorPos.Y);
  end;
end;

procedure TFRM_Favoriten.VST_ScanListCompareNodes(Sender: TBaseVirtualTree;
  Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var Fav1, Fav2: TFav;
    s1,s2: WideString;
begin
  // WARNING: When adding here a new Column, don't forget adding it to
  // VST_ScanListGetText as well!

  updateNode(node1);
  updateNode(node2);
  Fav1 := TFav(Sender.GetNodeData(node1)^);
  Fav2 := TFav(Sender.GetNodeData(node2)^);
  case Column of
    0: if PosBigger(Fav1.Position,Fav2.Position) then Result := 1 else Result := -1;
    5: if Fav1.ScanTime > Fav2.ScanTime then Result := 1 else Result := -1;
    8..12: if Fav1.Ress[Column-8] > Fav2.Ress[Column-8] then Result := 1 else Result := -1;
    13: if Fav1.Fleet > Fav2.Fleet then Result := 1 else Result := -1;
    15, 19: if Fav1.PlayerPunkte > Fav2.PlayerPunkte then Result := 1 else Result := -1;
    16, 20: if Fav1.FleetPunkte > Fav2.FleetPunkte then Result := 1 else Result := -1;
    14: if Fav1.Def > Fav2.Def then Result := 1 else Result := -1;
    17: if Fav1.Stars > Fav2.Stars then Result := 1 else Result := -1;
    18: if Fav1.Ress_div_Def > Fav2.Ress_div_Def then
          Result := 1 else Result := -1;
    21, 22: if Fav1.Allypunkte > Fav2.Allypunkte then Result := 1 else Result := -1;
    23: if Fav1.MProductionAll > Fav2.MProductionAll then Result := 1 else Result := -1;
    24: Result := IfThen(
      Fav1.TF[0]+Fav1.TF[1]+Fav1.TF[2] > Fav2.TF[0]+Fav2.TF[1]+Fav2.TF[2],
      1,-1);
    //Berechnete Rohstoffe (Produktion mit einberechnet!)
    25..29,31: if getIntValColumn(Column, Fav1) > getIntValColumn(Column, Fav2) then
              Result := 1 else Result := -1;
//    30: if Fav1.notes then, ka wie des genau mit den notizen klappen soll (nach welcher regel?)
        
  else
    VST_ScanListGetText(Sender,Node1,Column,ttNormal,s1);
    VST_ScanListGetText(Sender,Node2,Column,ttNormal,s2);
    if LowerCase(s1) > LowerCase(s2) then Result := 1 else Result := -1;
  end;
end;

procedure TFRM_Favoriten.updateNode(nd: PVirtualNode);
var p: TPlanetPosition;
    fav: ^TFav;
    i, sb: integer;
    report: TScanBericht;
    m: TRessType;
    alter_h: single;
    item: PPlanetItem;
begin
  if nd <> nil then
  begin
    fav := VST_ScanList.GetNodeData(nd);
    with fav^ do
    if (Now - LastUpdate > 1/24/60/20) then // Hier wird die Systemzeit Verwendet!!
    begin

      item := InitPointer;
      p := Position;
      FillChar(fav^,sizeof(fav^),0);
      InitPointer := item;
      Position := p;

      LastUpdate := Now; // Hier wird die Systemzeit Verwendet!!

      Stars := item.Sterne;

      notes := FRM_Notizen.GetPlanetInfo(p);

      i := ODataBase.FleetBoard.FindNextArrivingFleet(Position, fet_attack);
      if i >= 0 then Raid_dt := UnixToDateTime(ODataBase.FleetBoard.Fleets.Fleets[i].head.arrival_time_u)
        else Raid_dt := -1;

      Last24h := ODataBase.FleetBoard.GetLast24HoursRaidCount(Position);
      RaidCount := ODataBase.FleetBoard.GetRaidCount(Position);

      // Sind scans vorhanden?
      sb := ODataBase.UniTree.UniReport(Position);
      if sb >= 0 then
      begin
        // aktuellen Scan holen
        report := ODataBase.Berichte[sb];
        // ScanGroupCount trotzdem vom letzten scan holen
        ScanGrpCount := GetScanGrpCount(report);

        // UHO: 17.04.09 jetzt verwenden wir den generic Scan
        ODataBase.UniTree.genericReport(Position, report);

        ScanTime := UnixToDateTime(report.Head.Time_u);
        Fleet := FleetPoints(report);
        Def := DefPoints(report);

        for i := 0 to 3 do
          Ress[i] := report.Bericht[sg_Rohstoffe,i];
        Ress[4] := report.Bericht[sg_Rohstoffe,0]+
                   report.Bericht[sg_Rohstoffe,1]+
                   report.Bericht[sg_Rohstoffe,2]; // m+k+d!


        prod_faktor := calcProduktionsFaktor(report, needed_energy);
        MProductionAll := 0;
        for m := low(m) to high(m) do
        begin
          MProduction[m] := GetMineProduction_(report, ODataBase.SpeedFactor,
                                 m, prod_faktor);
          MProductionAll := MProductionAll + MProduction[m];
        end;

        //Berechne v_* 
        alter_h := (GameNow - ScanTime)*24;
        v_Ress_all := 0;
        for m := rtMetal to rtDeuterium do
        begin
          v_Ress[m] := CalcScanRess_Now(report, m, alter_h, MProduction[m]);
          v_Ress_all := v_Ress_all + v_Ress[m];
        end;

        if Def >= 0 then
        begin
          Ress_div_Def := trunc(Ress[4]/(1+(Def/1000)));
          v_Ress_div_Def := trunc(v_Ress_all/(1+(Def/1000)));
        end
        else
        begin
          Ress_div_Def := -1;
          v_Ress_div_Def := -1;
        end;

        TF := CalcTF(report,ODataBase.DefInTF);
      end;

      if ODataBase.GetSystemCopyNR(Position) >= 0 then
      with ODataBase.Systeme[ODataBase.GetSystemCopyNR(Position)], Planeten[Position.P[2]] do
      begin
        with ODataBase.Stats do
        begin
          if Statistik[Platz].Name <> Player then  // zur rechenersparnis! (weil platz ändert sich ja eher selten, sodass sich das nicht alle paar sekunden ändert!)
            Platz := StatPlace(Player);
          PlayerPunkte := Statistik[Platz].Punkte;
        end;

        with ODataBase.FleetStats do
        begin
          if Statistik[FleetPlatz].Name <> Player then
            FleetPlatz := StatPlace(Player);
          FleetPunkte := Statistik[FleetPlatz].Punkte;
        end;

        with ODataBase.AllyStats do
        begin
          if Statistik[AllyPlatz].Name <> Ally then
            AllyPlatz := StatPlace(Ally);
          AllyPunkte := Statistik[Allyplatz].Punkte;
        end;

      end;
    end;
  end;
end;

procedure TFRM_Favoriten.VST_ScanListPaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
begin
  with TFav(Sender.GetNodeData(Node)^) do
  begin
    case Column of
      5: begin
           TargetCanvas.Font.Color := AlterToColor_dt(GameNow - ScanTime,
                                                   ODataBase.redHours[rh_Scans]);
           TargetCanvas.Brush.Color := clBlack;
           TargetCanvas.Brush.Style := bsSolid;
         end;
      2: //Playername
         begin
           if (PlayerPunkte > 0) and (ODataBase.Stats_own > 0) then
             TargetCanvas.Font.Color := dPunkteToColor(integer(PlayerPunkte)-ODataBase.Stats_own,ODataBase.RedHours[rh_Points])
           else TargetCanvas.Font.Color := Sender.Font.Color;

           TargetCanvas.Font.Style := TargetCanvas.Font.Style + [fsUnderline];
         end;
      4: //Ally
         begin
           TargetCanvas.Font.Style := TargetCanvas.Font.Style + [fsUnderline];
         end;

    else
      if (TFav(Sender.GetNodeData(Node)^).Raid_dt> 0) then
      begin
        TargetCanvas.Font.Color := clred;
      end;
      // TargetCanvas.Font.Style
    end;
  end;
end;

procedure TFRM_Favoriten.VST_ScanListBeforeCellPaint_(
  Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode;
  Column: TColumnIndex; CellRect: TRect);
begin
  if Column = VST_ScanList.Header.SortColumn then  //sortierung
  begin
    TargetCanvas.Brush.Color := rgb(220,220,220);
    TargetCanvas.FillRect(CellRect);
  end;

  if (TFav(Sender.GetNodeData(Node)^).Last24h > 0) then
  begin
    TargetCanvas.Brush.Color := $00ADF1C4;
    if (TFav(Sender.GetNodeData(Node)^).Last24h >= maxraids24h) then
      TargetCanvas.Brush.Color := $007799FD;
    TargetCanvas.FillRect(CellRect);
  end;
end;

procedure TFRM_Favoriten.Raid1Click(Sender: TObject);
begin
  if VST_ScanList.GetFirstSelected <> nil then
  with TFav(VST_ScanList.GetNodeData(VST_ScanList.GetFirstSelected)^) do
    FRM_Main.RaidDialog(Position);
end;

procedure TFRM_Favoriten.VST_ScanListDblClick(Sender: TObject);
var Column: Integer;
    s: widestring;
begin
  //Berechen Spalte:
  Column := getColumnAt(VST_clickpos.X);

  case Column of
    2: //Spieler
      begin
        if VST_ScanList.FocusedNode <> nil then
        with TFav(VST_ScanList.GetNodeData(VST_ScanList.FocusedNode)^) do
        begin
          FRM_Main.ShowSearchPlayer(ODataBase.GetPlayerAtPos(Position, false));
        end;
      end;
    4: //Ally
      begin
        if VST_ScanList.FocusedNode <> nil then
        begin
          s := '';
          VST_ScanListGetText(VST_ScanList,VST_ScanList.FocusedNode,Column,
                              ttNormal,s);
          FRM_Main.ShowSearchAlly(s);
        end;
      end;
  else
    Raid1Click(Self);
  end;
end;

procedure TFRM_Favoriten.VST_ScanListGetImageIndex(
  Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind;
  Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: Integer);
begin
  if Column = 0 then
  with TFav(Sender.GetNodeData(Node)^) do
  begin
    if Position.Mond then ImageIndex := 1 else ImageIndex := 0;
  end;
end;

procedure TFRM_Favoriten.VST_ScanListKeyPress(Sender: TObject;
  var Key: Char);
var node : PVirtualNode;
begin
  if Key in ['0'..'9'] then
  begin
    node := VST_ScanList.GetFirstSelected;
    if node <> nil then
    begin
      //SetSterne(TFav(VST_ScanList.GetNodeData(node)^).Position,StrToInt(Key));
      with TFav(VST_ScanList.GetNodeData(node)^) do
      begin
        LastUpdate := -1;
        InitPointer^.Sterne := StrToInt(Key);
        SavePosition_Count(InitPointer);
      end;
      updateNode(node);
      VST_ScanList.RepaintNode(node);
    end;
  end;
end;

procedure TFRM_Favoriten.VST_ScanListAfterCellPaint(
  Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode;
  Column: TColumnIndex; CellRect: TRect);
var I,im,y: integer;
    items: TNotizArray;
begin
  if Column = 17 then   //Sterne (Bwwertung)
  begin
    im := TFav(Sender.GetNodeData(Node)^).Stars;
    y := ((CellRect.Bottom - CellRect.Top) - ImageList2.Height)div 2;
    for i := 0 to im-1 do
    begin
      ImageList2.draw(TargetCanvas,CellRect.Left+i*(ImageList2.Width),CellRect.Top+y,0);
    end;
  end;
  if Column = 5 {Scanalter} then
  begin
    im := TFav(Sender.GetNodeData(Node)^).ScanGrpCount;
    IL_ScanSize.Draw(TargetCanvas,CellRect.Left+2,CellRect.Top+2,im);
  end;
  if Column = fcol_Notizen then
  begin
    items := TFav(Sender.GetNodeData(Node)^).notes;
    for i := 0 to length(items)-1 do
    begin
      FRM_Notizen.ImageList1.draw(TargetCanvas,
                                  CellRect.Left + 3 + i*FRM_Notizen.ImageList1.Width,
                                  CellRect.Top + (CellRect.Bottom-CellRect.Top-FRM_Notizen.ImageList1.Height)div 2,
                                  items[i].Image);
    end;
  end;
end;

function TFRM_Favoriten.Find(Pos: TPlanetPosition): integer;
var i: integer;
//30.09.08 UHO OK
begin
  Result := -1;
  for i := 0 to ScanList.Count-1 do
    if SamePlanet(TPlanetItem(ScanList[i]^).Pos,pos) then
    begin
      Result := i;
      break;
    end;
end;

procedure TFRM_Favoriten.Kopieren1Click(Sender: TObject);
begin
  VST_ScanList.CopyToClipBoard;
end;

procedure TFRM_Favoriten.Lschen1Click(Sender: TObject);
var //node, del : PVirtualNode;
    i: integer;
    item: PPlanetItem;
begin
  VST_ScanList.BeginUpdate;
  try
    i := 0;
    while i < ScanList.Count do
    begin
      item := ScanList[i];
      if (
           (item^.shown_node <> nil) and
           (vsSelected in item^.shown_node^.States)
         ) then
      begin
        RemoveFromVSTList(item);

        ScanList[i] := ScanList[ScanList.Count-1];

        ScanList.Delete(ScanList.Count-1);
        Dispose(item);

        SavePosition_Count(i);
      end
      else
        inc(i);
    end;
    {node := VST_ScanList.GetFirstSelected;
    while node <> nil do
    begin
      DeleteOutArray(TFav(VST_ScanList.GetNodeData(node)^).Position);
      del := node;
      node := VST_ScanList.GetNextSelected(node);
      VST_ScanList.DeleteNode(del);
      inc(i);
      if (i mod 10) = 0 then
      begin
        StatusBar1.Panels[1].Text := STR_Anzahl + IntToStr(VST_ScanList.RootNodeCount);
        StatusBar1.Refresh;
      end;
    end;  }
  finally
    VST_ScanList.EndUpdate;
  end;
  StatusBar1.Panels[1].Text := STR_Anzahl + IntToStr(VST_ScanList.RootNodeCount);
end;

procedure TFRM_Favoriten.musternotiz1Click(Sender: TObject);
begin
  FRM_Notizen.VST_Notizen.ClearSelection;
  with Sender as TMenuItem do
  begin
    FRM_Notizen.VST_Notizen.Selected[PVirtualNode(Tag)] := True;
    FRM_Notizen.VST_Notizen.ScrollIntoView(PVirtualNode(Tag),True);
  end;
  FRM_Notizen.show;
end;

procedure TFRM_Favoriten.SavePosition_Count(const item: PPlanetItem);
var i: integer;
begin
  i := ScanList.IndexOf(item);
  if i >= 0 then
  begin
    SavePosition_Count(i);
  end;
end;

procedure TFRM_Favoriten.SavePosition_Count(const i: Integer);
var c: integer;
    item: PPlanetItem;
    fileentry: TFavFileEntry_10;
begin
  c := ScanList.Count;
  //neue Größe:
  scanlist_file.Size := scanfile_getentrypos(c);  //länge = adresse vom eintrag nach dem letzten eintrag!

  if (i < 0) then raise Exception.Create('TFRM_Favoriten.SavePosition: i<0!');
  if (i < c){and(i >= 0)} then
  begin
    item := ScanList[i];
    fileentry.Position.Position[0] := item^.Pos.P[0];
    fileentry.Position.Position[1] := item^.Pos.P[1];
    fileentry.Position.Position[2] := item^.Pos.P[2];
    fileentry.Position.P_Mond := item^.Pos.Mond;
    fileentry.Stars := item^.Sterne;

    scanlist_file.Position := scanfile_getentrypos(i);
    scanlist_file.WriteBuffer(fileentry, sizeof(fileentry));
  end;
end;

procedure TFRM_Favoriten.BTN_FilterClick(Sender: TObject);
var ini: TIniFile;
begin
  ini := TIniFile.Create(IniFile);
  SetTopMost(false, self);
  try
    if FRM_Filter.ShowModal = mrOk then
    begin
      FilterOptions := FRM_Filter.Filter;
      FRM_Filter.SaveFilter(ini);
      Set_CB_Koords;

      BTN_RefreshClick(Sender);
    end;
  finally
    ini.Free;
    SetTopMost(topmost, self);
  end;
end;

procedure TFRM_Favoriten.Set_CB_Koords(cb_k: TComboBox = nil);
var i: integer;
begin
  if (cb_k = nil) then
    cb_k := CB_Koords;

  cb_k.Clear;
  cb_k.Items.Add(STR_KEINFILTER);
  cb_k.ItemIndex := 0;
  for i := 0 to length(FRM_Filter.Areas)-1 do
  begin
    cb_k.Items.Add(FRM_Filter.Areas[i].Name);
  end;
end;

procedure TFRM_Favoriten.CB_KoordsChange(Sender: TObject);
begin
  if FilterArea <> nil then
    FilterArea.RemoveFreeNotification(Self);

  if CB_Koords.ItemIndex > 0 then
  begin
    FilterArea := FRM_Filter.Areas[CB_Koords.ItemIndex-1];
    FilterArea.FreeNotification(Self);
  end
  else
    FilterArea := nil;

  FRM_Uebersicht.SetSelected(FilterArea);
  BTN_RefreshClick(Sender);
end;

procedure TFRM_Favoriten.BTN_FilterArea_AnzeigenClick(Sender: TObject);
begin
  FRM_Uebersicht.Show;
  FRM_Uebersicht.cb_filter.Checked := True;
end;

procedure TFRM_Favoriten.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  if Operation = opRemove then
  begin
    if AComponent = FilterArea then
    begin
      FilterArea := nil;
      FRM_Uebersicht.SetSelected(nil);
      Set_CB_Koords;
    end;
  end;
  inherited;
end;

procedure TFRM_Favoriten.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F5 then
    BTN_RefreshClick(Self);
end;

function TFavList.Add(planet: TPlanetPosition): Integer;
begin
  Result := 0; //Don't use TFavList!!
end;

constructor TFavList.Create;
begin
  inherited;
  FList := TList.Create;
end;

procedure TFavList.Delete(index: Integer);
begin

end;

destructor TFavList.Destroy;
begin
  FList.Free;
  inherited;
end;



procedure TFRM_Favoriten.StatusBar1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if x < StatusBar1.Panels[0].Width then
  begin
    TopMost := not TopMost;
    if TopMost then StatusBar1.Panels[0].Text := STR_normal else StatusBar1.Panels[0].Text := STR_topmost;
    SetTopMost(topmost, Self);
  end;
end;

function TFRM_Favoriten.getIntValColumn(Column: TColumnIndex;
  fav: TFav): Integer;
  //30.09.08 UHO OK
  // Diese Funktion wurde extra für Integer-Spalten in der VST-Liste gedacht, so
  // können diese Spalten Automatisch auch mit dieser Funktion sortiert werden. 
begin
  with fav do
  begin
    case Column of
      25: Result := v_Ress[rtMetal];
      26: Result := v_Ress[rtKristal];
      27: Result := v_Ress[rtDeuterium];
      28: Result := v_Ress_all;
      29: Result := v_Ress_div_Def;
      31: Result := RaidCount;
    else
      Result := -1;
    end;
  end;
end;

function TFRM_Favoriten.getSelectedPlanet: TPlanetPosition;
var node: PVirtualNode;
begin
  FillChar(Result,sizeof(Result),0);
  node := VST_ScanList.FocusedNode;
  if node <> nil then
  begin
    with TFav(VST_ScanList.GetNodeData(node)^) do
    begin
      Result := Position;
    end;
  end;
end;

procedure TFRM_Favoriten.VST_ScanListInitNode(Sender: TBaseVirtualTree;
  ParentNode, Node: PVirtualNode;
  var InitialStates: TVirtualNodeInitStates);
var fav: PFav;
begin
  fav := Sender.GetNodeData(Node);
  with fav^ do
  begin
    Position := InitPointer^.Pos;
    LastUpdate := -1;

    //Als "angezeigt" markieren
    InitPointer^.shown_node := Node;
  end;
end;

procedure TFRM_Favoriten.VST_ScanListFreeNode(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var fav: PFav;
begin
  fav := Sender.GetNodeData(Node);
  with fav^ do
  begin
    //Markierung "angezeigt" entfernen
    InitPointer^.shown_node := nil;
  end;
end;

procedure TFRM_Favoriten.tim_startsortTimer(Sender: TObject);
begin
  tim_startsort.Enabled := false;
  if VST_ScanList.Header.SortColumn >= 0 then
    VST_ScanList.SortTree(VST_ScanList.Header.SortColumn,
                          VST_ScanList.Header.SortDirection);
end;

procedure TFRM_Favoriten.InitFavListFile(filename: string);
var s: string;
begin
  if FileExists(filename) then
  begin
    scanlist_file := TFileStream.Create(filename, fmOpenReadWrite);
    setlength(s, filetypelength);
    scanlist_file.ReadBuffer(PChar(s)^, filetypelength);

    if s <> filetype then
    begin
      scanlist_file.Free;
      if FileExists(filename + '.unknown') then
        DeleteFile(filename + '.unknown');
        
      RenameFile(filename, filename + '.unknown');
    end;
  end;

  if not FileExists(filename) then
  begin
    scanlist_file := TFileStream.Create(filename, fmCreate);
    scanlist_file.Write(filetype, filetypelength);
  end;
end;

procedure TFRM_Favoriten.FreeFavListFile;
begin
  scanlist_file.Free;
end;

function TFRM_Favoriten.scanfile_getentrypos(index: integer): Int64;
begin
  Result := filetypelength + index * sizeof(TFavFileEntry_10);
end;

procedure TFRM_Favoriten.LoadFavFileData;
var item: TPlanetItem;
    entry: TFavFileEntry_10;

    // TODO: wenns grad passt: add() -> aufteilen in 2 teile,
    // hier nur den teil verwenden der in ScanList schreibt,
    // der Teil der in die VST liste schreibt, den brauche wir nicht!
begin
  VST_ScanList.BeginUpdate;
  try
    ScanList.Clear; //sicherstellen, das die indizes der scanliste auch
                    //die indizes der datei sind!
    scanlist_file.Position := scanfile_getentrypos(0); //erster eintrag!
    while scanlist_file.Position < scanlist_file.Size do
    begin
      scanlist_file.Read(entry, sizeof(entry));

      item.Pos.P[0] := entry.Position.Position[0];
      item.Pos.P[1] := entry.Position.Position[1];
      item.Pos.P[2] := entry.Position.Position[2];
      item.Pos.Mond := entry.Position.P_Mond;
      item.Sterne := entry.Stars;

      Add(item.Pos, item.Sterne, True {don't save});
    end;
  finally
    VST_ScanList.EndUpdate;
  end;
end;

procedure TFRM_Favoriten.LoadOldFromIni;
var ini: TIniFile;
    c, i: integer;
    p: TPlanetPosition;
begin
  ini := TIniFile.Create(IniFile);
  try
    //ALT:
    //Nurnoch für den Umstieg:
    VST_ScanList.BeginUpdate;
    try
      c := ini.ReadInteger(FavSection,'FarmsCount',0);
      for i := 0 to c-1 do
      begin
        ReadPosOrTime(ini.ReadString(FavSection,'Farm'+inttostr(i)+'_Position','1:1:1') + ' ',1,p);
        p.Mond := ini.ReadBool(FavSection,'Farm'+inttostr(i)+'_PositionMond',False);
        //ALT: Add(p,ini.ReadInteger(FavSection,'F_'+IntToStr(i)+'_Sts',0),True);
        Add(p,ini.ReadInteger(FavSection,'F_'+IntToStr(i)+'_Sts',0),false { -> soll gespeichert werden! });
      end;
    finally
      VST_ScanList.EndUpdate;
    end;

    //ALT -> darum setze FarmsCount := 0!
    ini.WriteInteger(FavSection,'FarmsCount',0);
    ini.UpdateFile;
  finally
    ini.Free;
  end;
end;

procedure TFRM_Favoriten.Refresh_and_delMissing;
var i,nr: integer;
    pos: TPlanetPosition;
    item: PPlanetItem;
begin
  {for i := 0 to LV_Favoriten.Items.Count-1 do
    GetScan(LV_Favoriten.Items[i]);}

  VST_ScanList.BeginUpdate;
  VST_ScanList.Clear;  //shown_node wird automatisch auf nil gesetzt (OnFreeNode)
  i := 0;
  while (i < ScanList.Count) do
  begin
    item := ScanList[i];
    pos := item^.Pos;
    nr := ODataBase.UniTree.UniReport(pos);
    if (nr >= 0) then
    begin
      if Filter(ODataBase.Berichte[nr]) then
      begin
        AddToVSTList_forceupdate(item);
      end;

      inc(i); //nur weiterzählen wenn eintrag nicht gelöscht!
    end
    else
    begin
      ScanList.Delete(i);
    end;

    if ScanList.Count > 0 then
    begin
      StatusBar1.Panels[2].Text := Inttostr(Trunc((i+1)/ScanList.Count)*100) + '%';
      StatusBar1.Refresh;
    end;
  end;
  VST_ScanList.EndUpdate;
end;

procedure TFRM_Favoriten.VST_ScanListBeforeCellPaint(
  Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode;
  Column: TColumnIndex; CellPaintMode: TVTCellPaintMode; CellRect: TRect;
  var ContentRect: TRect);
begin
  VST_ScanListBeforeCellPaint_(Sender, TargetCanvas, Node, Column, CellRect);
end;

procedure TFRM_Favoriten.VST_ScanListMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  VST_clickpos.X := X;
  VST_clickpos.Y := Y;
end;

procedure TFRM_Favoriten.Show;
begin
  if WindowState = wsMinimized then
    WindowState := wsNormal;
  inherited Show;
end;

procedure TFRM_Favoriten.VST_ScanListMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  {case (getColumnAt(X)) of
  2,4: //Spieler, Ally
    VST_ScanList.Cursor := crHandPoint;
  else
    VST_ScanList.Cursor := crDefault;
  end; }
end;

function TFRM_Favoriten.getColumnAt(x: integer): integer;
var d: integer;
begin
  Result := 0;
  d := x - VST_ScanList.Header.Columns[Result].Left;
  while (Result < VST_ScanList.Header.Columns.Count)and
        (
          (not (coVisible in VST_ScanList.Header.Columns[Result].Options))or
          (d < 0)or
          (d > VST_ScanList.Header.Columns[Result].Width)
        ) do
  begin
    inc(Result);
    d := x - VST_ScanList.Header.Columns[Result].Left;
  end;
end;

{ TFRM_Fav_ScanListInterface }

constructor TFRM_Fav_PlanetListInterface.Create(fav_frm: TFRM_Favoriten);
begin
  inherited Create(fav_frm);
  mFRM_Fav := fav_frm;
end;

function TFRM_Fav_PlanetListInterface.getPlanet: TPlanetPosition;
begin
  Result := mFRM_Fav.getSelectedPlanet();
end;

function TFRM_Fav_PlanetListInterface.selectPreviousPlanet(
  out pos: TPlanetPosition): Boolean;
var node: PVirtualNode;
begin
  node := mFRM_Fav.VST_ScanList.FocusedNode;
  node := mFRM_Fav.VST_ScanList.GetPrevious(node);
  Result := node <> nil;
  if Result then
  begin
    mFRM_Fav.VST_ScanList.FocusedNode := node;
    mFRM_Fav.VST_ScanList.ClearSelection;
    mFRM_Fav.VST_ScanList.Selected[node] := true;
    pos := mFRM_Fav.getSelectedPlanet();
  end;
end;

function TFRM_Fav_PlanetListInterface.selectNextPlanet(
  out pos: TPlanetPosition): Boolean;
var node: PVirtualNode;
begin
  node := mFRM_Fav.VST_ScanList.FocusedNode;
  node := mFRM_Fav.VST_ScanList.GetNext(node);
  Result := node <> nil;
  if Result then
  begin
    mFRM_Fav.VST_ScanList.FocusedNode := node;
    mFRM_Fav.VST_ScanList.ClearSelection;
    mFRM_Fav.VST_ScanList.Selected[node] := true;
    pos := mFRM_Fav.getSelectedPlanet();
  end;
end;

end.
