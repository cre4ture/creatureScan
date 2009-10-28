unit Galaxy_Explorer;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, OGame_Types, Prog_Unit, Buttons, StdCtrls, Menus, ComCtrls, shellapi,
  ImgList, VirtualTrees, clipbrd, ToolWin, inifiles, VSTPopup,
  StringListEdit, VTHeaderPopup, DateUtils, UniTree, frm_pos_size_ini;

type
  TExplorerZeitFormat = (ezf_Datum, ezf_DatumUhrzeit);
  TExplorer = class(TForm)
    Panel1: TPanel;
    BTN_GalaLeft: TSpeedButton;
    BTN_SysRight: TSpeedButton;
    BTN_GalaRight: TSpeedButton;
    BTN_SysLeft: TSpeedButton;
    SB_PasteScan: TSpeedButton;
    TXT_Galaxy: TEdit;
    TXT_Sonnensystem: TEdit;
    PopupMenu1: TPopupMenu;
    ZuFavoriten1: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    Playernamenkopieren1: TMenuItem;
    PlayerbeinollexdeSuchen1: TMenuItem;
    Allybeinollexdesuchen1: TMenuItem;
    StatusBar1: TStatusBar;
    Suche1: TMenuItem;
    Notiz1: TMenuItem;
    IL_Explorer_symbols: TImageList;
    VST_System: TVirtualStringTree;
    Edit1: TEdit;
    LBL_SysHead: TLabel;
    PM_Notizen: TPopupMenu;
    musternotiz1: TMenuItem;
    PaintBox1: TPaintBox;
    SB_Links: TSpeedButton;
    pop_Links: TPopupMenu;
    N3: TMenuItem;
    Lesezeichenhinzufgen1: TMenuItem;
    Bearbeiten1: TMenuItem;
    VTHeaderPopupMenu1: TVTHeaderPopupMenu;
    Raid1: TMenuItem;
    IL_ScanSize: TImageList;
    SB_PasteSystem: TSpeedButton;
    folgeeingelesenenSystemen1: TMenuItem;
    N4: TMenuItem;
    procedure SB_PasteSystemClick(Sender: TObject);
    procedure folgeeingelesenenSystemen1Click(Sender: TObject);
    //procedure PaintBox1Paint(Sender: TObject);
    procedure TXT_GalaxyKeyPress(Sender: TObject; var Key: Char);
    procedure BTN_GalaLeftClick(Sender: TObject);
    procedure BTN_GalaRightClick(Sender: TObject);
    procedure BTN_SysLeftClick(Sender: TObject);
    procedure BTN_SysRightClick(Sender: TObject);
    procedure Panel1Resize(Sender: TObject);
    procedure SB_PasteScanClick(Sender: TObject);
    {procedure PaintBox1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);}
    procedure Playernamenkopieren1Click(Sender: TObject);
    procedure ZuFavoriten1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure PlayerbeinollexdeSuchen1Click(Sender: TObject);
    procedure Allybeinollexdesuchen1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Suche1Click(Sender: TObject);
    procedure Notiz1Click(Sender: TObject);
    procedure StatusBar1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure VST_SystemGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure VST_SystemPaintText(Sender: TBaseVirtualTree;
      const TargetCanvas: TCanvas; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType);
    procedure VST_SystemAfterCellPaint(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      CellRect: TRect);
    procedure TXT_SonnensystemKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure VST_SystemAfterItemErase(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect);
    procedure VST_SystemFocusChanged(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex);
    procedure VST_SystemDblClick(Sender: TObject);
    procedure VST_SystemGetPopupMenu(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; const P: TPoint;
      var AskParent: Boolean; var PopupMenu: TPopupMenu);
    procedure musternotiz1Click(Sender: TObject);
    procedure VST_SystemClick(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
    procedure PaintBox1DblClick(Sender: TObject);
    procedure PaintBox1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormDestroy(Sender: TObject);
    procedure VST_SystemMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure VST_SystemBeforeCellPaint_(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      CellRect: TRect);
    procedure Lesezeichenhinzufgen1Click(Sender: TObject);
    procedure SB_LinksClick(Sender: TObject);
    procedure N14841Click(Sender: TObject);
    procedure pop_LinksPopup(Sender: TObject);
    procedure Bearbeiten1Click(Sender: TObject);
    procedure Raid1Click(Sender: TObject);
    procedure VST_SystemBeforeCellPaint(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      CellPaintMode: TVTCellPaintMode; CellRect: TRect;
      var ContentRect: TRect);
  private
    tablewidth: integer;
    TopMost: boolean;
    FPosition: TPlanetPosition;
    SettingPos: Boolean;
    IniFile: String;
    FPhalanxList: TPlanetPosList;
    function GetSystem: TsystemCopy;
    procedure ShowMoonHint(Pos: TPlanetPosition);
    procedure SetPosition(pos: TPlanetPosition);
    { Private-Deklarationen }
  public
    Typ: Integer;
    SCol: Integer;
    haveSystem: Boolean;
    Phalax: Integer;
    procedure NewSysAtPos(syspos: TPlanetPosition);
    property Position: TPlanetPosition read FPosition write SetPosition;
    property System: TSystemCopy read GetSystem;
    constructor Create(AOwner: TComponent; ATyp: integer; AName: String);
    procedure Reload;
    procedure Initialise(Pos: TPlanetPosition);
    { Public-Deklarationen }
  protected
    PROCEDURE CreateParams(VAR Params: TCreateParams); OVERRIDE;
  end;


var
  explorer_Zeitformat: TExplorerZeitFormat;
  explorer_mouseover: Boolean;
  explorer_TF_Size: cardinal;

  explorer_links: TStringList;


procedure explorer_save(ini: TIniFile);
procedure explorer_load(ini: TIniFile);

implementation

uses Main, Notizen, Favoriten, Suche, Languages, Types;

const
  lineheigth = 20;
  IconWidth = 16;
const
  col_Pos = 0;
  col_Planet = 1;
  col_Mond = 2;
  col_TF = 3;
  col_Player = 4;
  col_Ally = 5;
  col_Notizen = 6;
  col_Punkte = 7;
  col_Platz = 8;
  col_Fleetpunkte = 9;
  col_Fleetplatz = 10;
  col_Allypunkte = 11;
  col_Allyplatz = 12;


{$R *.DFM}

PROCEDURE TExplorer.CreateParams;
begin
  INHERITED;
  if Typ = 0 then
  begin
    Params.ExStyle := Params.ExStyle OR WS_EX_APPWINDOW;
    Params.WndParent:= 0;//Application.Handle;
  end;
end;

procedure TExplorer.folgeeingelesenenSystemen1Click(Sender: TObject);
begin
  folgeeingelesenenSystemen1.Checked := not folgeeingelesenenSystemen1.Checked;
end;

constructor TExplorer.Create(AOwner: TComponent; ATyp: integer; AName: String);
begin
  Typ := ATyp;
  inherited Create(AOwner);
  Name := AName;
end;

procedure TExplorer.TXT_GalaxyKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Reload;
    TEdit(Sender).SelectAll;
  end;
  if not(key in ['0'..'9',#8]) then
  begin
    Key := #0;
  end;
end;

procedure TExplorer.Reload;
var s: string;
begin
  with Position do
  begin
    P[0] := StrToInt(TXT_Galaxy.Text);
    if P[0] < 1 then
    begin
      P[0] := 1;
      TXT_Galaxy.Text := '1';
      Beep;
    end;
    if P[0] > max_Galaxy then
    begin
      P[0] := max_Galaxy;
      TXT_Galaxy.Text := inttostr(max_Galaxy);
      Beep;
    end;
    P[1] := StrToInt(TXT_Sonnensystem.Text);
    if P[1] < 1 then
    begin
      P[1] := 1;
      TXT_Sonnensystem.Text := '1';
      Beep;
    end;
    if P[1] > max_Systems then
    begin
      P[1] := max_Systems;
      TXT_Sonnensystem.Text := inttostr(max_Systems);
      Beep;
    end;
  end;

  FPhalanxList := ODataBase.UniTree.GetPhalanxList(Position);

  Caption := '[' + IntToStr(position.P[0]) + ':' + IntToStr(position.P[1]) + ']';

  //---
  with System do
  begin
    s := STR_SonnenSystem + inttostr(position.P[0]) + ':' + inttostr(position.P[1]);
    if haveSystem then
    begin
      LBL_SysHead.Font.Color := AlterToColor_dt(
               ODataBase.FleetBoard.GameTime.Time -
               UnixToDateTime(Time_u),ODataBase.redHours[rh_Systems]);
      case explorer_Zeitformat of
      ezf_Datum:
        s := s + STR_Datum + DateToStr(UnixToDateTime(Time_u));
      ezf_DatumUhrzeit:
        s := s + STR_Datum + DateTimeToStr(UnixToDateTime(Time_u));
      end;
    end else LBL_SysHead.Font.Color := clWhite;
    LBL_SysHead.Caption := s;
  end;
  //---

  VST_System.Refresh;
  PaintBox1.Refresh;
end;

procedure TExplorer.BTN_GalaLeftClick(Sender: TObject);
begin
  if StrToInt(TXT_Galaxy.Text) <> 1 then
  TXT_Galaxy.Text := inttostr(StrToInt(TXT_Galaxy.Text)-1);
  Reload;
end;

procedure TExplorer.BTN_GalaRightClick(Sender: TObject);
begin
  if StrToInt(TXT_Galaxy.Text) <> max_Galaxy then
  TXT_Galaxy.Text := inttostr(StrToInt(TXT_Galaxy.Text)+1);
  Reload;
end;

procedure TExplorer.BTN_SysLeftClick(Sender: TObject);
begin
  if StrToInt(TXT_Sonnensystem.Text) <> 1 then
  TXT_Sonnensystem.Text := inttostr(StrToInt(TXT_Sonnensystem.Text)-1);
  Reload;
end;

procedure TExplorer.BTN_SysRightClick(Sender: TObject);
begin
  if StrToInt(TXT_Sonnensystem.Text) <> max_Systems then
  TXT_Sonnensystem.Text := inttostr(StrToInt(TXT_Sonnensystem.Text)+1);
  Reload;
end;

procedure TExplorer.Panel1Resize(Sender: TObject);
begin
  BTN_GalaRight.Left := (Panel1.ClientWidth div 2) - BTN_GalaRight.Width - 15;
  TXT_Galaxy.Left := BTN_GalaRight.Left - TXT_Galaxy.Width - 3;
  BTN_GalaLeft.Left := TXT_Galaxy.Left - BTN_GalaLeft.Width - 3;
  BTN_SysLeft.Left := (Panel1.ClientWidth div 2) + 15;
  TXT_Sonnensystem.Left := BTN_SysLeft.Left + BTN_SysLeft.Width + 3;
  BTN_SysRight.Left := TXT_Sonnensystem.Left + TXT_Sonnensystem.Width + 3;
  if BTN_GalaLeft.Left - 4 < 150 then
    SB_PasteScan.Width := BTN_GalaLeft.Left - 4
  else SB_PasteScan.Width := 150;
  SB_PasteSystem.Width := SB_PasteScan.Width;
  SB_PasteScan.Left := Panel1.ClientWidth - 4 - SB_PasteScan.Width;

  SB_Links.Left := (Panel1.ClientWidth - SB_Links.Width) div 2;
end;

procedure TExplorer.SB_PasteScanClick(Sender: TObject);
begin
  FRM_Main.ClipbrdReadScan;
end;                                                                                       

procedure TExplorer.SB_PasteSystemClick(Sender: TObject);
begin
  FRM_Main.ClipbrdReadSys;
end;

procedure TExplorer.Playernamenkopieren1Click(Sender: TObject);
begin
  with ODataBase do
  if uni[Position.P[0],Position.P[1]].systemcopy >= 0 then
  begin
    Edit1.Text := systeme[uni[Position.P[0],Position.P[1]].systemcopy].Planeten[Position.P[2]].Player;
    Edit1.SelectAll;
    Edit1.CopyToClipboard;
  end;
end;

procedure TExplorer.ZuFavoriten1Click(Sender: TObject);
begin
  FRM_Favoriten.Add(Position);
end;

procedure TExplorer.FormResize(Sender: TObject);
begin
  tablewidth := ClientWidth;
  ClientHeight := PaintBox1.Height + LBL_SysHead.Height +
                  Panel1.Height + StatusBar1.Height +
                  VST_System.Header.Height +
                  VST_System.DefaultNodeHeight*max_Planeten;
  //StatusBar1.Panels[0].Width := tablewidth div 3;
end;

procedure TExplorer.Initialise(Pos: TPlanetPosition);
begin
  Position := Pos;
  Reload;
end;

procedure TExplorer.PlayerbeinollexdeSuchen1Click(Sender: TObject);
var Ally, player: String;
begin
  with ODataBase do
  if uni[Position.P[0],Position.P[1]].systemcopy >= 0 then
  begin
    player := systeme[uni[Position.P[0],Position.P[1]].systemcopy].Planeten[Position.P[2]].Player;
    Ally := systeme[uni[Position.P[0],Position.P[1]].systemcopy].Planeten[Position.P[2]].Ally;
    FRM_Main.SucheImInet(sitPlayer,Ally,Player,ODataBase.UniDomain);
  end;
end;

procedure TExplorer.Allybeinollexdesuchen1Click(Sender: TObject);
var Ally, player: String;
begin
  with ODataBase do
  if uni[Position.P[0],Position.P[1]].systemcopy >= 0 then
  begin
    player := systeme[uni[Position.P[0],Position.P[1]].systemcopy].Planeten[Position.P[2]].Player;
    Ally := systeme[uni[Position.P[0],Position.P[1]].systemcopy].Planeten[Position.P[2]].Ally;
    FRM_Main.SucheImInet(sitAllanz,Ally,Player,ODataBase.UniDomain);
  end;
end;

procedure TExplorer.FormCreate(Sender: TObject);
var ini: TIniFile;
begin
  tablewidth := 500;
  with Position do
  begin
    P[0] := 1;
    P[1] := 1;
    P[2] := 1;
  end;
  if SaveCaptions then SaveAllCaptions(Self,LangFile);
  if LoadCaptions then LoadAllCaptions(Self,LangFile);

  if typ = 1 then StatusBar1.Panels[0].Width := 0; //wenn typ = 1 dann in hauptfenster -> nutzt garnix wenn topmost!

  TopMost := false;
  StatusBar1.Panels[0].Text := STR_topmost;
  VST_System.RootNodeCount := max_Planeten;

  DoubleBuffered := True;

  IniFile := ODataBase.PlayerInf;
  ini := TIniFile.Create(IniFile);
  LoadVSTHeaders(VST_System,ini,'explorerwindow_' + Self.Name);
  if typ <> 1 then
    LoadFormSizePos(ini,'explorerwindow_' + Self.Name,Self);

  folgeeingelesenenSystemen1.Checked :=
           ini.ReadBool('explorerwindow_' + Self.Name, 'followData', false);
  ini.Free;
end;

procedure TExplorer.Suche1Click(Sender: TObject);
var FRM: TFRM_Suche;
begin
  if haveSystem then
  with ODataBase do
  begin
    FRM := FRM_Main.NewSearch;
    FRM.TXT_Player.Text := Systeme[Uni[Position.P[0],Position.P[1]].systemcopy].Planeten[Position.P[2]].Player;
    FRM.TXT_ally.Text := Systeme[Uni[Position.P[0],Position.P[1]].systemcopy].Planeten[Position.P[2]].Ally;
    FRM.BTN_SucheClick(self);
  end;
end;

procedure TExplorer.Notiz1Click(Sender: TObject);
var NT: TNotizTyp;
begin
  case SCol of
  col_Player: NT := nPlayer;
  col_Ally: NT := nAlly;
  else NT := nPlanet;
  end;

  FRM_Notizen.ShowAddDialog(Position,NT,self); //Achtung: Mond wird mit einberechnet weitergegeben!
  VST_System.Refresh;
end;

function TExplorer.GetSystem: TSystemCopy;
begin
  if (ValidPosition(Position))and(ODataBase.Uni[Position.P[0],Position.P[1]].SystemCopy >= 0) then
  begin
    Result := ODataBase.Systeme[ODataBase.Uni[Position.P[0],Position.P[1]].SystemCopy];
    haveSystem := True;
  end
  else
  begin
    FillChar(Result,sizeof(Result),0);
    haveSystem := False;
  end;
  //SetMoons;
end;

procedure TExplorer.ShowMoonHint(Pos: TPlanetPosition);
var s: string;
begin
  {$IFNDEF spacepioneers}
  StatusBar1.Panels[1].Text := ODataBase.LanguagePlugIn.SBItems[sg_Gebaeude].Strings[sb_Sensorpalanx+1] + STR_auf + PositionToStrMond(Pos);
  if ODataBase.Uni[pos.p[0],pos.p[1]].Planeten[pos.P[2],pos.mond].ScanBericht >= 0 then
  with ODataBase.Berichte[ODataBase.Uni[pos.p[0],pos.p[1]].Planeten[pos.P[2],pos.mond].ScanBericht] do
  begin
    s := ' ( ' + Head.Spieler + ' )';
    StatusBar1.Panels[1].Text := StatusBar1.Panels[1].Text + s;
  end;
  {$ENDIF}
end;

procedure TExplorer.StatusBar1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if x < StatusBar1.Panels[0].Width then
  begin
    TopMost := not TopMost;
    if TopMost then StatusBar1.Panels[0].Text := STR_normal else StatusBar1.Panels[0].Text := STR_topmost;
    if TopMost
      then SetWindowPos(Handle,HWND_TOPMOST,0,0,0,0,SWP_NOMOVE OR SWP_NOSIZE)
      else SetWindowPos(Handle,HWND_NOTOPMOST,0,0,0,0,SWP_NOMOVE OR SWP_NOSIZE);
  end;
end;

procedure TExplorer.PopupMenu1Popup(Sender: TObject);
begin
  Allybeinollexdesuchen1.Caption := STR_Ally_Suchen + FRM_Main.PlayerOptions.SuchInet.Name;
  PlayerbeinollexdeSuchen1.Caption := STR_Player_Suchen + FRM_Main.PlayerOptions.SuchInet.Name;
end;

procedure explorer_save(ini: TiniFile);
const Section = 'explorer_options';
var i: integer;
begin
  ini.WriteInteger(Section,'TimeFormat',Integer(explorer_Zeitformat));
  ini.WriteBool(Section,'MouseOver',explorer_mouseover);
  ini.WriteInteger(Section,'TF_Size',explorer_TF_Size);

  ini.EraseSection('explorer_links');
  for i := 0 to explorer_links.Count-1 do
    ini.WriteString('explorer_links',explorer_links[i],'');
end;

procedure explorer_load(ini: TIniFile);
const Section = 'explorer_options';
begin
  explorer_Zeitformat := TExplorerZeitFormat(ini.ReadInteger(Section,'TimeFormat',Integer(ezf_Datum)));
  explorer_mouseover := ini.ReadBool(Section,'MouseOver',true);
  explorer_TF_Size := ini.ReadInteger(Section,'TF_Size',20000);

  explorer_links := TStringList.Create;
  ini.ReadSection('explorer_links',explorer_links);
end;

procedure TExplorer.VST_SystemGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var i: Integer;
    pos: TPlanetPosition;
    la_u: int64;
begin
  i := node^.Index+1;
  case Column of
    col_Pos: CellText := IntToStr(i);
    col_Planet:
      begin
        pos := Position;
        pos.P[2] := i;
        pos.Mond := Column = col_Mond;
        
        if System.Planeten[i].PlanetName <> '' then
        begin
          CellText := System.Planeten[i].PlanetName;
          //Letzte Aktivität?
          la_u := ODataBase.FleetBoard.GameTime.UnixTime - ODataBase.GetLastActivity(pos);
          if la_u < 60*60 then
            CellText := CellText + ' [' + IntToStr(la_u div 60) +
                                   ':' + IntToStr(la_u mod 60) + ']';
        end
        else
        begin
          if ODataBase.UniTree.UniReport(Pos) >= 0 then CellText := '[ .. ]'{ + PositionToStrAMond(pos) + '|' + IntToStr(ODataBase.GetPlanetScan(Pos))}
          else CellText := '';
        end;
      end;
    col_Mond: if System.Planeten[i].MondSize > 0 then CellText := 'S: ' + IntToStr(System.Planeten[i].MondSize) + ' T: ' + IntToStr(System.Planeten[i].MondTemp) else CellText := '';
    col_TF: CellText := IntToStrKP(System.Planeten[i].TF[0] + System.Planeten[i].TF[1]);
    col_Player: if System.Planeten[i].Status <> [] then
                  CellText := System.Planeten[i].Player + ' (' + ODataBase.LanguagePlugIn.StatusToStr(System.Planeten[i].Status) + ')'
                else CellText := System.Planeten[i].Player;
    col_Ally: CellText := System.Planeten[i].Ally;
    col_Notizen: CellText := '';
    col_Punkte: CellText := IntToStrKP(ODataBase.Stats.StatPoints(System.Planeten[i].Player));
    col_Platz: CellText := IntToStr(ODataBase.Stats.StatPlace(System.Planeten[i].Player));
    col_Fleetpunkte: CellText := IntToStrKP(ODataBase.FleetStats.StatPoints(System.Planeten[i].Player));
    col_Fleetplatz: CellText := IntToStr(ODataBase.FleetStats.StatPlace(System.Planeten[i].Player));
    col_Allypunkte: CellText := IntToStrKP(ODataBase.AllyStats.StatPoints(System.Planeten[i].Ally));
    col_Allyplatz: CellText := IntToStr(ODataBase.AllyStats.StatPlace(System.Planeten[i].Ally));
  end;
  case Column of
    col_TF,col_Punkte..col_Allyplatz: if CellText = '0' then CellText := '';
  end;
end;

procedure TExplorer.VST_SystemPaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
var p: TPlanetPosition;
    i: Integer;
    points: integer;  // ich brauch hier nen integer, weil ich auch negeative werte kriege!
begin
  if (Column = col_Mond)or(Column = col_Planet) then
  begin
    p := Position;
    p.P[2] := node.Index+1;
    p.Mond := Column = col_Mond;
    i := ODataBase.UniTree.UniReport(p);
    if i >= 0 then TargetCanvas.Font.Color := AlterToColor_dt(
           ODataBase.FleetBoard.GameTime.Time -
           UnixToDateTime(ODataBase.Berichte[i].Head.Time_u),ODataBase.redHours[rh_Scans])
      else TargetCanvas.Font.Color := VST_System.Font.Color;
  end
  else
  if Column = col_Player then
  begin
    i := Node^.Index+1;
    points := ODataBase.Stats.StatPoints(system.planeten[i].Player);
    if (points > 0) and (ODataBase.Stats_own > 0) then
      TargetCanvas.Font.Color := dPunkteToColor(points-ODataBase.Stats_own,ODataBase.RedHours[rh_Points])
    else TargetCanvas.Font.Color := VST_System.Font.Color;
  end;
end;

procedure TExplorer.VST_SystemAfterCellPaint(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  CellRect: TRect);
var items: TNotizArray;
    p: TPlanetPosition;
    i: integer;
begin
  p := Position;
  p.P[2] := node.Index+1;
  p.Mond := Column = col_Mond;

  case Column of
  col_Notizen:
    begin
      SetLength(items,0);
      items := FRM_Notizen.GetPlanetInfo(p);
      //TargetCanvas.Brush.Color := clBlack;
      //TargetCanvas.FillRect(CellRect);

      for i := 0 to length(items)-1 do
        begin
          FRM_Notizen.ImageList1.draw(TargetCanvas,
                                      CellRect.Left + 3 + i*IconWidth,
                                      CellRect.Top + (CellRect.Bottom-CellRect.Top-FRM_Notizen.ImageList1.Height)div 2,
                                      items[i].Image);
        end;
    end;
  col_Planet, col_Mond:
    begin
      i := ODataBase.UniTree.UniReport(p);
      if i >= 0 then
        IL_ScanSize.Draw(TargetCanvas,CellRect.Left+2,CellRect.Top+2,
                         GetScanGrpCount(ODataBase.Berichte[i]));
    end;
  end;
end;

procedure TExplorer.TXT_SonnensystemKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = VK_LEFT then BTN_SysLeftClick(self);
  if key = VK_RIGHT then BTN_SysRightClick(self);
  if key = VK_UP then BTN_GalaLeftClick(self);
  if key = VK_DOWN then BTN_GalaRightClick(self);
end;

procedure TExplorer.VST_SystemAfterItemErase(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect);
var items: TNotizArray;
    p: TPlanetPosition;
    i: integer;
begin
  p := System.System;
  p.P[2] := node.Index+1;
  items := FRM_Notizen.GetPlanetInfo(p);

  for i := 0 to length(items)-1 do
  begin
    if FRM_Notizen.GetBackgroundColor(items[i].Image) <> clBlack then
    begin
      TargetCanvas.Brush.Color := FRM_Notizen.GetBackgroundColor(items[i].Image);
      TargetCanvas.FillRect(ItemRect);
    end;
  end;
end;

procedure TExplorer.VST_SystemFocusChanged(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex);
  var i, j: integer;
begin
  if not SettingPos then
  with Position do
  begin
    {P[0] := System.System.P[0];
    P[1] := System.System.P[1];}
    P[2] := Node.Index+1;
    Mond := Column = col_Mond;
  end;
  SCol := Column;
  
  if haveSystem and (System.Planeten[Position.P[2]].Player <> '') then
  begin
    i := ODataBase.Stats.StatPlace(System.Planeten[Position.P[2]].Player);
    j := ODataBase.FleetStats.StatPlace(System.Planeten[Position.P[2]].Player);
    StatusBar1.Panels[1].Text := STR_Punkte + FloatToStrF(ODataBase.Stats.Statistik[i].Punkte,ffNumber,60000000,0) + ' (' + IntToStr(i) + ')'
                                 + STR_Fleet + FloatToStrF(ODataBase.FleetStats.Statistik[j].Punkte,ffNumber,60000000,0) + ' (' + IntToStr(j) + ')';
    i := ODataBase.AllyStats.StatPlace(System.Planeten[Position.P[2]].Ally);
    StatusBar1.Panels[1].Text := StatusBar1.Panels[1].Text + STR_Ally + FloatToStrF(ODataBase.AllyStats.Statistik[i].Punkte,ffNumber,60000000,0) + ' (' + IntToStr(i) + ')';
  end;
  
  if Typ = 1 then
    FRM_Main.ShowSmallScan(Position);

  case column of
    col_TF:
      begin
        i := (System.Planeten[Position.P[2]].TF[0] + System.Planeten[Position.P[2]].TF[1]);
        if i > 0 then i := trunc(i/20000)+1;
        StatusBar1.Panels[1].Text := Format(STR_Truemmerfeld_frmt_explorer,[System.Planeten[Position.P[2]].TF[0]/1,System.Planeten[Position.P[2]].TF[1]/1,i/1]);
      end;
    col_Mond:
      begin
        if System.Planeten[Position.P[2]].MondSize > 0 then
          StatusBar1.Panels[1].Text := 'S: ' + IntToStr(System.Planeten[Position.P[2]].MondSize) + ' T: ' + IntToStr(System.Planeten[Position.P[2]].MondTemp);
      end;
  end;
end;

procedure TExplorer.VST_SystemDblClick(Sender: TObject);
begin
  case SCol of
  col_Planet, col_Mond: FRM_Main.ShowScan(Position); //FRM_Main.ShowScan(ODataBase.UniTree.UniReport(Position));
  col_Player:
    if haveSystem then
    with ODataBase do
    begin
      FRM_Main.ShowSearchPlayer(Systeme[Uni[Position.P[0],Position.P[1]].systemcopy].Planeten[Position.P[2]].Player);
    end;
  col_Ally:
    if haveSystem then
    with ODataBase do
    begin
      FRM_Main.ShowSearchAlly(Systeme[Uni[Position.P[0],Position.P[1]].systemcopy].Planeten[Position.P[2]].Ally);
    end;
  end;
end;

procedure TExplorer.VST_SystemGetPopupMenu(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; const P: TPoint;
  var AskParent: Boolean; var PopupMenu: TPopupMenu);
var mi: TMenuItem;
    notes: TNotizArray;
    i: integer;
begin
  SetLength(Notes,0);
  if Column = col_Notizen then
  begin
    PopupMenu := PM_Notizen;
    PM_Notizen.Items.Clear;
    notes := FRM_Notizen.GetPlanetInfo(Position);
    for i := 0 to length(Notes)-1 do
    begin
      mi := TMenuItem.Create(Self);
      mi.Caption := notes[i].Note;
      mi.ImageIndex := notes[i].Image;
      mi.Tag := i;
      mi.OnClick := musternotiz1Click;
      PM_Notizen.Items.Add(mi);
    end;
  end
  else PopupMenu := PopupMenu1;
end;

procedure TExplorer.musternotiz1Click(Sender: TObject);
var notes: TNotizArray;
begin
  notes := FRM_Notizen.GetPlanetInfo(Position);

  FRM_Notizen.VST_Notizen.ClearSelection;
  with Sender as TMenuItem do
  begin
    FRM_Notizen.VST_Notizen.Selected[notes[Tag].SNode] := True;
    FRM_Notizen.VST_Notizen.ScrollIntoView(notes[Tag].SNode,True);
  end;
  
  FRM_Notizen.show;
end;

procedure TExplorer.VST_SystemClick(Sender: TObject);
var menu: TPopupMenu;
    b: Boolean;
begin
  if SCol = col_Notizen then
  begin
    VST_System.OnGetPopupMenu(VST_System,VST_System.GetFirstSelected,SCol,Mouse.CursorPos,B,menu);
    menu.Popup(Mouse.CursorPos.X,Mouse.CursorPos.Y);
  end;
  if ((SCol in [col_Planet,col_Mond])and(explorer_mouseover))or(Typ = 0) then
  begin
    FRM_Main.ShowScan(Position);
  end;
end;

procedure TExplorer.PaintBox1Paint(Sender: TObject);
var i: Integer;
    scan: Integer;
    alter: TDateTime;
begin
  //Phalanxsymbole
  with ODataBase do
  begin
    
    i := 0;
    while i < length(FPhalanxList) do
    begin
      scan := UniTree.UniReport(FPhalanxList[i]);
      if scan >= 0 then
      begin
        alter := ODataBase.FleetBoard.GameTime.Time -
                 UnixToDateTime(Berichte[scan].Head.Time_u);
        IL_Explorer_symbols.BkColor := AlterToColor_dt(alter,redHours[rh_Systems]);
        IL_Explorer_symbols.draw(PaintBox1.Canvas,1+i*18,1,0);
        inc(i);
      end;
    end;
  end;
end;

procedure TExplorer.PaintBox1DblClick(Sender: TObject);
begin
  with ODataBase do
  begin
    if (Phalax < length(FPhalanxList)) then
    begin
      Self.Initialise(FPhalanxList[Phalax]);
      if typ <> 1 then VST_SystemClick(VST_System);
    end;
  end;
end;

procedure TExplorer.PaintBox1MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var rect: TRect;
begin
  Phalax := (x-1) div 18;

  PaintBox1.Repaint;
  if Phalax < length(FPhalanxList) then
  begin
    rect.Left := Phalax*18;
    rect.Right := rect.Left + 18;
    rect.Top := 0;
    rect.Bottom := 18;

    PaintBox1.Canvas.Brush.Style := bsClear;
    PaintBox1.Canvas.Pen.Color := clBlue;
    PaintBox1.Canvas.Rectangle(rect);
    PaintBox1.Canvas.Brush.Style := bsSolid;

    ShowMoonHint(FPhalanxList[(x-2) div 18]);
    PaintBox1.Cursor := crHandPoint;
  end
  else
  begin
    StatusBar1.Panels[1].Text := '';
    PaintBox1.Cursor := crDefault;
  end;
end;

procedure TExplorer.SetPosition(pos: TPlanetPosition);
var node: PVirtualNode;
begin
  if ValidPosition(pos) then
  begin
    SettingPos := True;
    FPosition := pos;

    TXT_Galaxy.Text := inttostr(Pos.P[0]);
    TXT_Sonnensystem.Text := inttostr(Pos.P[1]);

    node := VST_System.GetFirst;
    while node <> nil do
    begin
      if node.Index+1 = Pos.P[2] then
      begin
        VST_System.Selected[node] := True;
        VST_System.FocusedNode := node;
        if Pos.Mond then VST_System.FocusedColumn := col_Mond else VST_System.FocusedColumn := col_Planet;
      end;
      node := VST_System.GetNext(node);
    end;

    SettingPos := False;
  end;
end;

procedure TExplorer.FormDestroy(Sender: TObject);
var ini: TIniFile;
begin
  ini := TIniFile.Create(IniFile);
  SaveVSTHeaders(VST_System,ini,'explorerwindow_' + Self.Name);
  if Typ <> 1 then
    SaveFormSizePos(ini,'explorerwindow_' + Self.Name,Self);

  ini.WriteBool('explorerwindow_' + Self.Name, 'followData', folgeeingelesenenSystemen1.Checked);
           
  ini.UpdateFile;
  ini.Free;
end;

procedure TExplorer.VST_SystemMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var p: TPlanetPosition;
    HitInfo: THitInfo;
begin
  if (explorer_mouseover)and(not (hsDragPending in VST_System.Header.States))and(VST_System.GetNodeAt(x,y) <> nil) then
  begin
    VST_System.GetHitTestInfoAt(x,y,True,HitInfo);
    if (HitInfo.HitNode <> nil)and
       (
       (HitInfo.HitNode <> VST_System.FocusedNode)or
       (HitInfo.HitColumn <> VST_System.FocusedColumn)
       ) then
    begin
      p := Position;
      p.P[2] := HitInfo.HitNode^.Index+1;
      p.Mond := col_Mond = HitInfo.HitColumn;
      Position := p;
      VST_System.FocusedColumn := HitInfo.HitColumn;
    end;
  end;
end;

procedure TExplorer.VST_SystemBeforeCellPaint_(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  CellRect: TRect);
begin
  if (Column = col_Player)and(sys_playerstat_urlaub in System.Planeten[Node.Index+1].Status) then
  begin
    TargetCanvas.Brush.Color := clnavy;
    TargetCanvas.FillRect(CellRect);
  end;
  if (Column = col_Player)and(sys_playerstat_noob in System.Planeten[Node.Index+1].Status) then
  begin
    TargetCanvas.Brush.Color := rgb(0,45,0);
    TargetCanvas.FillRect(CellRect);
  end;
  if (Column = col_TF)and(haveSystem)and(System.Planeten[Node.Index+1].TF[0] + System.Planeten[Node.Index+1].TF[1] > explorer_TF_Size) then
  begin
    TargetCanvas.Brush.Color := clred;
    TargetCanvas.FillRect(CellRect);
  end;
  if (Column = col_Mond)and(haveSystem)and(System.Planeten[Node.Index+1].MondSize > 0) then
  begin
    TargetCanvas.Brush.Color := clgray;
    TargetCanvas.FillRect(CellRect);
  end;

  if (vsSelected in Node.States)and((not(Column in [col_Planet,col_Mond,col_TF]))or((Column = col_Planet)and (not Position.Mond))) then
  begin
    TargetCanvas.Brush.Color := VST_System.Colors.FocusedSelectionColor;
    TargetCanvas.FillRect(CellRect);
  end;
end;

procedure TExplorer.Lesezeichenhinzufgen1Click(Sender: TObject);
var s: string;
begin
  s := 'name';
  if InputQuery('Neuer Link', 'Gib den Namen für diesen Link an:', s) then
  begin
    explorer_links.Add(
        IntToStr(Position.P[0]) + ':' + IntToStr(Position.P[1]) + ' ' + s);
  end;
end;

procedure TExplorer.SB_LinksClick(Sender: TObject);
begin
  pop_Links.Popup(Mouse.CursorPos.x,Mouse.CursorPos.y);
end;

procedure TExplorer.N14841Click(Sender: TObject);
var s: string;
    pos: TPlanetPosition;
begin
  with Sender as TMenuItem do
  begin
    s := explorer_links[tag];
    pos := StrToPosition(s);
    TXT_Galaxy.Text := IntToStr(pos.P[0]);
    TXT_Sonnensystem.Text := IntToStr(pos.P[1]);
    Reload;
  end;
end;

procedure TExplorer.NewSysAtPos(syspos: TPlanetPosition);
begin
  if folgeeingelesenenSystemen1.Checked and (syspos.P[0] <> 0) then
  begin
    Initialise(syspos);
  end
  else
  if ((Position.P[0] = syspos.P[0])and
     (Position.P[1] = syspos.P[1]))or(syspos.P[0] = 0) then
    Reload;
end;

procedure TExplorer.pop_LinksPopup(Sender: TObject);
var i: integer;
    item: TMenuItem;
begin
  i := 0;
  while i < pop_Links.Items.Count do
  begin
    if (pop_Links.Items[i].Name = '') then
    begin
      pop_Links.Items.Delete(i);
    end else inc(i);
  end;

  for i := 0 to explorer_links.Count-1 do
  begin
    item := TMenuItem.Create(self);
    item.Caption := explorer_links[i];
    item.OnClick := N14841Click;
    item.Tag := i;
    pop_Links.Items.Add(item);
  end;
end;

procedure TExplorer.Bearbeiten1Click(Sender: TObject);
var frm: TFRM_StringlistEdit;
begin
  frm := TFRM_StringlistEdit.Create(self);
  frm.Memo1.Text := explorer_links.Text;
  if frm.ShowModal = mrOK then
  begin
    explorer_links.Text := frm.Memo1.Text;
  end;
end;

procedure TExplorer.Raid1Click(Sender: TObject);
begin
  FRM_Main.RaidDialog(Position);
end;

procedure TExplorer.VST_SystemBeforeCellPaint(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  CellPaintMode: TVTCellPaintMode; CellRect: TRect;
  var ContentRect: TRect);
begin
  VST_SystemBeforeCellPaint_(Sender, TargetCanvas, Node, Column, CellRect);
end;

end.
