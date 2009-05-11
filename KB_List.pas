unit KB_List;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, ComCtrls, Grids, VirtualTrees, OGame_Types, Prog_Unit, StdCtrls,
  Menus, Add_KB, TThreadSocketSplitter, syncobjs, MergeSocket, cS_networking,
  SplitSocket, RaidBoard, cS_DB, notifywindow, notify_fleet_arrival,
  ImgList, zeit_sync;

type
  TFRM_KB_List = class(TForm)
    PageControl1: TPageControl;
    TS_KB_laufend: TTabSheet;
    TS_KB_fertig: TTabSheet;
    VST_RAID: TVirtualStringTree;
    ListRefresh: TTimer;
    PopupMenu1: TPopupMenu;
    entf1: TMenuItem;
    Kopieren1: TMenuItem;
    StatusBar1: TStatusBar;
    VST_HISTORY: TVirtualStringTree;
    Bearbeiten1: TMenuItem;
    N1: TMenuItem;
    paste1: TMenuItem;
    Timer1: TTimer;
    Panel1: TPanel;
    lbl_flotte: TLabel;
    Panel2: TPanel;
    btn_pasteEvents: TButton;
    IL_mission: TImageList;
    Panel3: TPanel;
    lbl_servertime: TLabel;
    Label2: TLabel;
    btn_time_sync: TButton;
    ProgressBar1: TProgressBar;
    tim_time_sync_auto: TTimer;
    procedure tim_time_sync_autoTimer(Sender: TObject);
    procedure btn_time_syncClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure VST_RAIDGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure ListRefreshTimer(Sender: TObject);
    procedure entf1Click(Sender: TObject);
    procedure Kopieren1Click(Sender: TObject);
    procedure VST_RAIDCompareNodes(Sender: TBaseVirtualTree; Node1,
      Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure VST_RAIDHeaderClick(Sender: TVTHeader; Column: TColumnIndex;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure VST_RAIDChange(Sender: TBaseVirtualTree;
      Node: PVirtualNode);
    procedure VST_RAIDKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure StatusBar1Resize(Sender: TObject);
    procedure VST_RAIDClick(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure VST_RAIDDblClick(Sender: TObject);
    procedure Bearbeiten1Click(Sender: TObject);
    procedure paste1Click(Sender: TObject);
    procedure VST_RAIDInitNode(Sender: TBaseVirtualTree; ParentNode,
      Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure VST_RAIDInitChildren(Sender: TBaseVirtualTree;
      Node: PVirtualNode; var ChildCount: Cardinal);
    procedure Timer1Timer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure VST_RAIDGetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: Integer);
    procedure VST_RAIDBeforeCellPaint(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      CellPaintMode: TVTCellPaintMode; CellRect: TRect;
      var ContentRect: TRect);
  private
    { Private-Deklarationen }
    SortDirection_Raids: TSortDirection;
    SortColumn_Raids: Integer;
    notify_grp: TNotify_frm_grp;
    function Node_Find(rd: Integer; VST: TVirtualStringTree): PVirtualNode;
    function findFleet_notify_window(fleet: TFleetEvent): Tfrm_fleet_arrival;
    procedure RefreshNotifyWindows(Sender: TObject);
  public
    function gameNow_u: int64;
    function gameNow: TDateTime;
    procedure ShowRaid(Pos: TPlanetPosition);
    procedure ShowHistoryRaid(Pos: TPlanetPosition);
    procedure Show;
    { Public-Deklarationen }
  end;

var
  FRM_KB_List: TFRM_KB_List;


implementation

uses Main, Languages, Connections, Math, DateUtils, OtherTime;

{$R *.DFM}

procedure TFRM_KB_List.FormCreate(Sender: TObject);
begin
  notify_grp := TNotify_frm_grp.Create;

  VST_RAID.NodeDataSize := SizeOf(Integer);
  VST_HISTORY.NodeDataSize := SizeOf(Integer);

  if SaveCaptions then SaveAllCaptions(Self,LangFile);
  if LoadCaptions then LoadAllCaptions(Self,LangFile);

  // SYNC Time
  // NO! Click(Sender);

  Panel3.DoubleBuffered := true;
end;

procedure TFRM_KB_List.VST_RAIDGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);

  procedure Text(rd: TFleetEvent);
  var dt: TDateTime;
      i, c: integer;
  begin
    with rd do
    begin
      if Node.Parent = Sender.RootNode then
      begin
        case Column of
          0: begin
               dt := UnixToDateTime(head.arrival_time_u);
               CellText := DateTimeToStr(dt);
               if dt > gameNow then CellText := CellText +
                                  ' (' + CountdownTimeToStr(dt - gameNow) + ')';
             end;
          1: CellText := PositionToStrMond(head.origin);
          2: CellText := ODataBase.GetPlayerAtPos(head.origin);
          3: CellText := PositionToStrMond(head.target);
          4: CellText := ODataBase.GetPlayerAtPos(head.target);
          5: begin
               CellText := FleetEventTypeToStrEx(rd);
             end;
          6: if Sender = VST_RAID then
             begin
               {if head.player <> ODataBase.Username then
               begin
                 if cSServer.FindUsername(head.player) >= 0 then    -> Geht nicht, da kein zentrale stelle mit nutzernamen vorhanden!
                   CellText := head.player + ' (on)'
                 else
                   CellText := head.player + ' (off)';
               end
               else }
                 CellText := head.player;
             end;
        end;
      end
      else
      begin
        c := -1;
        i := 0;
        while (i < length(ships)) do
        begin
          if (ships[i] > 0) then
          begin
            inc(c);
            if c = Node.Index then
              break;
          end;
          inc(i);
        end;

        if c > -1 then
          case Column of
            2: CellText := ODataBase.LanguagePlugIn.SBItems[sg_Flotten][i+1]; //+1 -> da In SBItems immernoch der gruppenname anfangs steht!
            3: CellText := IntToStrKP(ships[i]);
          else
            CellText := '';
          end;
      end;
    end;
  end;

begin
  if Sender = VST_RAID then Text(ODataBase.FleetBoard.Fleets[Integer(VST_RAID.GetNodeData(Node)^)]);
  if Sender = VST_HISTORY then Text(ODataBase.FleetBoard.History[Integer(VST_HISTORY.GetNodeData(Node)^)]);
end;

procedure TFRM_KB_List.ListRefreshTimer(Sender: TObject);
begin
  while (VST_RAID.RootNodeCount > ODataBase.FleetBoard.Fleets.Count) do
    VST_RAID.DeleteNode(Node_Find(VST_RAID.RootNodeCount-1,VST_RAID));

  while (VST_HISTORY.RootNodeCount > ODataBase.FleetBoard.History.Count) do
    VST_HISTORY.DeleteNode(Node_Find(VST_HISTORY.RootNodeCount-1,VST_HISTORY));

  while (VST_RAID.RootNodeCount < ODataBase.FleetBoard.Fleets.Count) do
    Integer(VST_RAID.GetNodeData(VST_RAID.AddChild(nil))^) := VST_RAID.RootNodeCount-1;

  while (VST_HISTORY.RootNodeCount < ODataBase.FleetBoard.History.Count) do
    Integer(VST_HISTORY.GetNodeData(VST_HISTORY.AddChild(nil))^) := VST_HISTORY.RootNodeCount-1;

  VST_RAID.Refresh;
  VST_HISTORY.Refresh;

  VST_RAID.SortTree(SortColumn_Raids,SortDirection_Raids);
  VST_HISTORY.SortTree(SortColumn_Raids,SortDirection_Raids);

  RefreshNotifyWindows(Sender);
end;

procedure TFRM_KB_List.btn_time_syncClick(Sender: TObject);
var server_time: TDateTime;
    url: string;
    i: integer;
    last_delta_1, last_delta_2, last_delta_3, delta: TDateTime;
begin
  btn_time_sync.Enabled := false;


  url := 'http://uni' + IntToStr(ODataBase.UserUni) +
                          '.' + game_sites[ODataBase.langindex] +
                          '/robots.txt';

  ProgressBar1.Position := 0;
  ProgressBar1.Max := 10;
  ProgressBar1.Visible := true;
  try
    i := 0;
    last_delta_1 := 100;
    last_delta_2 := 100;
    last_delta_3 := 100;
    delta := 50;
    while (abs(last_delta_1 - delta) > 1/24/60/60) or
          (abs(last_delta_2 - delta) > 1/24/60/60) or
          (abs(last_delta_3 - delta) > 1/24/60/60) do
    begin
      if not get_server_time_http(url, server_time) then raise Exception.Create('error getting time from server');
      ODataBase.FleetBoard.GameTime.setTime(server_time);

      last_delta_3 := last_delta_2;
      last_delta_2 := last_delta_1;
      last_delta_1 := delta;
      delta := ODataBase.FleetBoard.GameTime.TimeDelta;

      inc(i);
      ProgressBar1.Position := i;
      if i > 10 then
        raise Exception.Create('unable to sync!');

      sleep(200);
    end;

    ODataBase.FleetBoard.GameTime.TimeDelta := (delta + last_delta_1 + last_delta_2 + last_delta_3) / 4;

    lbl_servertime.Color := clLime;
  except
    lbl_servertime.Color := clRed;
  end;

  ProgressBar1.Visible := False;
  delta := ODataBase.FleetBoard.GameTime.TimeDelta;
  if delta > 0 then
    lbl_servertime.Hint := '+ ' + TimeToStr(delta)
  else
    lbl_servertime.Hint := '- ' + TimeToStr(delta);

  lbl_servertime.ShowHint := True;

  btn_time_sync.Enabled := true;
end;

procedure TFRM_KB_List.entf1Click(Sender: TObject);
begin
  case PageControl1.ActivePageIndex of
    0: if VST_RAID.GetFirstSelected <> nil then
         ODataBase.FleetBoard.DeleteFleet(
           Integer(VST_RAID.GetNodeData(VST_RAID.GetFirstSelected)^));
    1: if VST_HISTORY.GetFirstSelected <> nil then
         ODataBase.FleetBoard.DeleteHistoryFleet(
           Integer(VST_HISTORY.GetNodeData(VST_HISTORY.GetFirstSelected)^));
  end;
  ListRefreshTimer(Sender);
end;

procedure TFRM_KB_List.Kopieren1Click(Sender: TObject);
begin
  case PageControl1.ActivePageIndex of
    0: VST_RAID.CopyToClipBoard;
    1: VST_HISTORY.CopyToClipBoard;
  end;
end;

procedure TFRM_KB_List.VST_RAIDCompareNodes(Sender: TBaseVirtualTree;
  Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var rd1, rd2: TFleetEvent;
    RList: TcSFleetDB;
begin
  if Sender = VST_RAID then RList := ODataBase.FleetBoard.Fleets
  else RList := ODataBase.FleetBoard.History;

  rd1 := RList[Integer(Sender.GetNodeData(Node1)^)];
  rd2 := RList[Integer(Sender.GetNodeData(Node2)^)];

  case Column of
    0: if rd1.head.arrival_time_u > rd2.head.arrival_time_u then Result := 1 else Result := -1;
    1: if PositionToStrAMond(rd1.head.origin) > PositionToStrAMond(rd2.head.origin) then Result := 1 else Result := -1;
    2: if rd1.head.player > rd2.head.player then Result := 1 else Result := -1;
    3: if PositionToStrAMond(rd1.head.target) > PositionToStrAMond(rd2.head.target) then Result := 1 else Result := -1;
  end;

  //In der History ist die Sotierung der "Zeit" immer andersrum!
  if (Column = 0)and(Sender = VST_HISTORY) then
    Result := -Result;
end;

procedure TFRM_KB_List.VST_RAIDHeaderClick(Sender: TVTHeader;
  Column: TColumnIndex; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  if SortDirection_Raids = sdDescending then
    SortDirection_Raids := sdAscending
  else inc(SortDirection_Raids);

  SortColumn_Raids := Column;
  ListRefreshTimer(Sender);
end;

procedure TFRM_KB_List.VST_RAIDChange(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var n: PVirtualNode;
    Met,Kris,Deut: Integer;
    RList: TcSFleetDB;
    s: string;
    i: integer;
begin
  if Sender = VST_RAID then
    RList := ODataBase.FleetBoard.Fleets
  else RList := ODataBase.FleetBoard.History;

  if (node <> nil)and(Integer(Sender.GetNodeData(Node)^) >= RList.Count) then
    exit;

  if (node <> nil) then
  with RList.Fleets[Integer(Sender.GetNodeData(Node)^)] do
  begin
    FRM_Main.ShowScan(head.target);
    s := '';
    for i := 0 to length(ships)-1 do
    if ships[i] > 0 then
    begin
      s := s + ODataBase.LanguagePlugIn.SBItems[sg_Flotten][i+1] + ': ' + IntToStrKP(ships[i]) + ' ';
    end;
    lbl_flotte.Caption := s;
  end;


  Met := 0;
  Kris := 0;
  Deut := 0;
  n := Sender.GetFirstSelected;
  while n <> nil do
  with RList.Fleets[Integer(Sender.GetNodeData(n)^)] do
  begin
    inc(Met,ress[0]);
    inc(Kris,ress[1]);
    inc(Deut,ress[2]);
    n := Sender.GetNextSelected(n);
  end;
  StatusBar1.Panels[1].Text := STR_Metall + ': ' + FloatToStrF(Met,ffNumber,60000000,0);
  StatusBar1.Panels[2].Text := STR_Kristall + ': ' + FloatToStrF(Kris,ffNumber,60000000,0);
  StatusBar1.Panels[3].Text := STR_Deuterium + ': ' + FloatToStrF(Deut,ffNumber,60000000,0);

end;

procedure TFRM_KB_List.ShowRaid(Pos: TPlanetPosition);
var n: PVirtualNode;
begin
  n := VST_RAID.GetFirst;
  while (n <> nil) do
  begin
    if SamePlanet(
       ODataBase.FleetBoard.Fleets[Integer(VST_RAID.GetNodeData(n)^)].head.target,Pos) then
      include(n^.States,vsSelected)
    else exclude(n^.States,vsSelected);

    n := VST_RAID.GetNextSibling(n);
  end;
  
  PageControl1.ActivePageIndex := 0;
  show;
end;

procedure TFRM_KB_List.VST_RAIDKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  //TVirtualStringTree(Sender).OnFocusChanged(TVirtualStringTree(Sender),nil,0);
end;

procedure TFRM_KB_List.StatusBar1Resize(Sender: TObject);
begin
  StatusBar1.Panels[1].Width := (StatusBar1.Width - StatusBar1.Panels[0].Width - 10) div 3;
  StatusBar1.Panels[2].Width := StatusBar1.Panels[1].Width;
end;

procedure TFRM_KB_List.ShowHistoryRaid(Pos: TPlanetPosition);
var n: PVirtualNode;
begin
  n := VST_HISTORY.GetFirst;
  while (n <> nil)and(not SamePlanet(ODataBase.FleetBoard.History[Integer(VST_HISTORY.GetNodeData(n)^)].head.target,Pos)) do
    n := VST_HISTORY.GetNextSibling(n);

  if n <> nil then
  begin
    include(n^.States,vsSelected);
  end;

  PageControl1.ActivePageIndex := 1;
  show;
end;

function TFRM_KB_List.Node_Find(rd: Integer; VST: TVirtualStringTree): PVirtualNode;
var node: PVirtualNode;
begin
  Result := nil;
  node := VST.GetFirst;
  while (node <> nil) do
  begin
    if rd = Integer(VST.GetNodeData(node)^) then
    begin
      Result := node;
    end;
    node := VST.GetNext(node);
  end;
end;

function TFRM_KB_List.gameNow: TDateTime;
begin
  Result := ODataBase.FleetBoard.GameTime.Time;
end;

function TFRM_KB_List.gameNow_u: int64;
begin
  Result := ODataBase.FleetBoard.GameTime.UnixTime;
end;

procedure TFRM_KB_List.VST_RAIDClick(Sender: TObject);
begin
  {if TVirtualStringTree(Sender).GetFirstSelected <> nil then
    TVirtualStringTree(Sender).OnFocusChanged(TVirtualStringTree(Sender),TVirtualStringTree(Sender).GetFirstSelected,0);}
end;

procedure TFRM_KB_List.PageControl1Change(Sender: TObject);
begin
  if PageControl1.ActivePageIndex = 0 then VST_RAIDChange(VST_RAID,VST_RAID.FocusedNode)
  else VST_RAIDChange(VST_HISTORY,VST_HISTORY.FocusedNode);
end;

procedure TFRM_KB_List.VST_RAIDDblClick(Sender: TObject);
var rd: TFleetEvent;
    RList: TcSFleetDB;
    node: PVirtualNode;
    i: integer;
begin
  if Sender = VST_RAID then
  begin
    RList := ODataBase.FleetBoard.Fleets;
    node := VST_RAID.GetFirstSelected;
    if node = nil then exit;
    rd := RList[Integer(VST_RAID.GetNodeData(node)^)];
  end
  else
  begin
    RList := ODataBase.FleetBoard.History;
    node := VST_HISTORY.GetFirstSelected;
    if node = nil then exit;
    rd := RList[Integer(VST_HISTORY.GetNodeData(node)^)];
  end;

  i := ODataBase.UniTree.UniReport(rd.head.Target);
  if (i >= 0) then
  begin
    FRM_Main.ShowScan(i);
  end
  else
  begin
    FRM_Main.ShowGalaxie(rd.head.Target);
  end;
end;

procedure TFRM_KB_List.Bearbeiten1Click(Sender: TObject);
var fleet: TFleetEvent;
    i: integer;
begin
  case PageControl1.ActivePageIndex of
    0: if VST_RAID.GetFirstSelected <> nil then
       begin
         i := Integer(VST_RAID.GetNodeData(VST_RAID.GetFirstSelected)^);
         fleet := ODataBase.FleetBoard.Fleets[i];
         ODataBase.FleetBoard.DeleteFleet(i);
         ListRefreshTimer(Sender); //Liste Aktualisieren
         FRM_Main.RaidDialog(fleet);
         ODataBase.FleetBoard.AddFleet(fleet);
         ListRefreshTimer(Sender); //Liste Aktualisieren
       end;
    1: if VST_HISTORY.GetFirstSelected <> nil then
       begin
         i := Integer(VST_HISTORY.GetNodeData(VST_HISTORY.GetFirstSelected)^);
         fleet := ODataBase.FleetBoard.History[i];
         ODataBase.FleetBoard.DeleteHistoryFleet(i);
         ListRefreshTimer(Sender); //Liste Aktualisieren
         FRM_Main.RaidDialog(fleet);
         ODataBase.FleetBoard.AddHistoryFleet(fleet);
         ListRefreshTimer(Sender); //Liste Aktualisieren
       end;
    else Exit;
  end;


end;

procedure TFRM_KB_List.paste1Click(Sender: TObject);
begin
  ODataBase.LanguagePlugIn.SetReadSourceText(FRM_Main.GetClipboardText);
  ODataBase.LanguagePlugIn.SetReadSourceHTML(FRM_Main.GetClipboardHtml);
  ODataBase.LeseFleets();
end;

procedure TFRM_KB_List.VST_RAIDInitNode(Sender: TBaseVirtualTree;
  ParentNode, Node: PVirtualNode;
  var InitialStates: TVirtualNodeInitStates);

  procedure Text(rd: TFleetEvent);
  begin
    if ParentNode = nil then
    begin
      Include(InitialStates, ivsHasChildren);
    end;
  end;

begin
  exit;
  
  if Sender = VST_RAID then Text(ODataBase.FleetBoard.Fleets[Integer(VST_RAID.GetNodeData(Node)^)]);
  if Sender = VST_HISTORY then Text(ODataBase.FleetBoard.History[Integer(VST_HISTORY.GetNodeData(Node)^)]);
end;

procedure TFRM_KB_List.VST_RAIDInitChildren(Sender: TBaseVirtualTree;
  Node: PVirtualNode; var ChildCount: Cardinal);

  procedure Text(rd: TFleetEvent);
  var c, i: integer;
  begin
    c := 0;
    for i := 0 to length(rd.ships)-1 do
    begin
      if rd.ships[i] > 0 then
        inc(c);
    end;
    ChildCount := c;
  end;

begin
  ChildCount := 0;
  Exit;
  
  if Sender = VST_RAID then Text(ODataBase.FleetBoard.Fleets[Integer(VST_RAID.GetNodeData(Node)^)]);
  if Sender = VST_HISTORY then Text(ODataBase.FleetBoard.History[Integer(VST_HISTORY.GetNodeData(Node)^)]);
end;

procedure TFRM_KB_List.Timer1Timer(Sender: TObject);
var i, frm_index, next_f: integer;
    fleet: TFleetEvent;
    zeit: int64;
    frm: Tfrm_fleet_arrival;
    flt: TFleetEvent;
begin
  // Zeige Serverzeit:
  lbl_servertime.Caption := DateTimeToStr(ODataBase.FleetBoard.GameTime.Time);

  frm_index := 0;
  next_f := -1;

  if FRM_Main.PlayerOptions.Fleet_ShowArivalMessage then
  begin

    for i := 0 to ODataBase.FleetBoard.Fleets.Count-1 do
    begin
      fleet := ODataBase.FleetBoard.Fleets[i];

      //Finde n�chste Flotte:
      if (next_f = -1)or
         (fleet.head.arrival_time_u <
          ODataBase.FleetBoard.Fleets[next_f].head.arrival_time_u) then
      begin
        next_f := i;
      end;

      //Zeige Fenster an:
      zeit := fleet.head.arrival_time_u - gameNow_u;
      if (zeit < FRM_Main.PlayerOptions.Fleet_AMSG_Time_s)or
         (fef_hostile in fleet.head.eventflags) then
      begin

        frm := findFleet_notify_window(fleet);
        if frm = nil then
        begin
          frm := Tfrm_fleet_arrival(notify_grp.NewNotifyWindow(Tfrm_fleet_arrival));
          frm.info_fleet := fleet;
          frm.Visible := True;

          if FRM_Main.PlayerOptions.Fleet_alert then
            FRM_Main.Play_Alert_Sound(FRM_Main.PlayerOptions.Fleet_Soundfile);
        end;

        frm.time_to_live := 1 + (Timer1.Interval div ListRefresh.Interval);
      end;
    end;

  end;

  if next_f >= 0 then //Wenn eine Flotte gefunden wurde:
  begin
    flt := ODataBase.FleetBoard.Fleets[next_f];
    FRM_Main.StatusBar1.Panels[4].Text := CountdownTimeToStr(
      UnixToDateTime(flt.head.arrival_time_u)-gameNow) + ' ' +
         FleetEventTypeToStrEx(flt) +
         ' (' + ODataBase.GetPlayerAtPos(flt.head.target) + ')';
  end
  else
    FRM_Main.StatusBar1.Panels[4].Text := 'no fleets';

  {if notify_grp.Count > 0 then
    Timer1.Interval := 1000
  else
    Timer1.Interval := 5000; }
end;

procedure TFRM_KB_List.tim_time_sync_autoTimer(Sender: TObject);
begin
  tim_time_sync_auto.Enabled := False;

  btn_time_syncClick(Sender);
end;

procedure TFRM_KB_List.FormDestroy(Sender: TObject);
begin
  notify_grp.Free;
end;

function TFRM_KB_List.findFleet_notify_window(fleet: TFleetEvent): Tfrm_fleet_arrival;
var i: integer;
    frm: Tfrm_fleet_arrival;
begin
  Result := nil;
  for i := 0 to notify_grp.Count-1 do
  begin
    frm := Tfrm_fleet_arrival(notify_grp.window(i));
    with frm do
    begin
      if SameFleetEvent(fleet, info_fleet) then
      begin
        Result := frm;
        break;
      end;
    end;
  end;
end;

procedure TFRM_KB_List.RefreshNotifyWindows(Sender: TObject);
var i: integer;
begin
  for i := 0 to notify_grp.Count-1 do
  begin
    Tfrm_fleet_arrival(notify_grp.window(i)).Timer1Timer(Sender);
  end;
end;

procedure TFRM_KB_List.Show;
begin
  if WindowState = wsMinimized then
    WindowState := wsNormal;
  inherited Show;
end;

procedure TFRM_KB_List.VST_RAIDGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);

  procedure Text(rd: TFleetEvent);
  begin
    with rd do
    begin
      if Column = 0 then
        ImageIndex := Byte(head.eventtype);
    end;
  end;

begin
  if Sender = VST_RAID then Text(ODataBase.FleetBoard.Fleets[Integer(VST_RAID.GetNodeData(Node)^)]);
  if Sender = VST_HISTORY then Text(ODataBase.FleetBoard.History[Integer(VST_HISTORY.GetNodeData(Node)^)]);
end;


procedure TFRM_KB_List.VST_RAIDBeforeCellPaint(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  CellPaintMode: TVTCellPaintMode; CellRect: TRect;
  var ContentRect: TRect);

  procedure Text(rd: TFleetEvent);
  begin
    with rd.head do
    begin

      if fef_friendly in eventflags then
        TargetCanvas.Brush.Color := $00ADF1C4;
      if fef_hostile in eventflags then
        TargetCanvas.Brush.Color := $007799FD;

      TargetCanvas.FillRect(CellRect);
    end;
  end;

begin
  if Sender = VST_RAID then Text(ODataBase.FleetBoard.Fleets[Integer(VST_RAID.GetNodeData(Node)^)]);
  if Sender = VST_HISTORY then Text(ODataBase.FleetBoard.History[Integer(VST_HISTORY.GetNodeData(Node)^)]);
end;

end.
