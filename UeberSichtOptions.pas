unit UeberSichtOptions;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, Gauges, Notizen, Ogame_Types, Menus, ImgList, Inifiles,
  ExtCtrls, VirtualTrees, Prog_Unit, Languages;

type
  TMarkerTyp = (mtNotiz,mtPlayer,mtAlly);
  TMarker = record
    Typ: TMarkerTyp;
    Color: TColor;
    Bezeichner: string;
    NotizIndex: integer;
    Aktive: Boolean;
  end;
  TFRM_Marker = class(TForm)
    Label1: TLabel;
    PopupMenu1: TPopupMenu;
    Markierunghinzufgen1: TMenuItem;
    Lschen1: TMenuItem;
    ImageList1: TImageList;
    Panel1: TPanel;
    Button1: TButton;
    Button3: TButton;
    Button4: TButton;
    Button2: TButton;
    Panel2: TPanel;
    Label2: TLabel;
    CB_Typ: TComboBox;
    Label3: TLabel;
    CB_Notizen: TComboBox;
    TXT_Bezeichner: TEdit;
    P_Color: TPanel;
    Label4: TLabel;
    ColorDialog1: TColorDialog;
    LV_Options: TVirtualStringTree;
    ProgressBar1: TProgressBar;
    procedure Button1Click(Sender: TObject);
    procedure Markierunghinzufgen1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Lschen1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure CB_TypChange(Sender: TObject);
    procedure P_ColorClick(Sender: TObject);
    procedure LV_OptionsGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: string);
    procedure LV_OptionsChecked(Sender: TBaseVirtualTree;
      Node: PVirtualNode);
    procedure LV_OptionsPaintText(Sender: TBaseVirtualTree;
      const TargetCanvas: TCanvas; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType);
    procedure LV_OptionsInitNode(Sender: TBaseVirtualTree; ParentNode,
      Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure LV_OptionsBeforeItemPaint(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect;
      var CustomDraw: Boolean);
    procedure LV_OptionsFocusChanged(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex);
    procedure CB_NotizenKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    IniFile: String;
    SetVal: Boolean;
    { Private-Deklarationen }
  public
    procedure Generate;
    procedure Load;
    procedure Save;
    { Public-Deklarationen }
  end;

var
  FRM_Marker: TFRM_Marker;

implementation

uses Uebersicht;

{$R *.DFM}

procedure TFRM_Marker.Generate;
var g, s, p, j, k: integer;
    List: TNotizArray;
    pos: TPlanetPosition;
    notizen: Boolean;
    node: PVirtualNode;
    nodeData: ^TMarker;
begin
  SetLength(List,0);
  SetLength(frm_Uebersicht.UUni,0);
  notizen := false;
  node := LV_Options.GetFirst;
  while node <> nil do
  begin
    nodeData := LV_Options.GetNodeData(Node);
    if nodeData^.Aktive and(nodeData^.Typ = mtNotiz) then notizen := true;
    node := LV_Options.GetNext(node);
  end;
  ProgressBar1.Max := max_Galaxy*max_Systems;
  ProgressBar1.Position := 0;
  for g := 1 to max_Galaxy do
    for s := 1 to max_Systems do
    begin
      for p := 1 to max_Planeten do
      begin
        if notizen then
        begin
          pos.P[0] := g;
          pos.P[1] := s;
          pos.P[2] := p;
          pos.Mond := false;
          List := FRM_Notizen.GetPlanetInfo(pos);
        end;
        node := LV_Options.GetFirst;
        while node <> nil do
        begin
          nodeData := LV_Options.GetNodeData(Node);
          //-------------------------------------------------------------------
          if nodeData^.Aktive then
          with nodeData^ do
          begin
            j := length(FRM_Uebersicht.UUni);
            case Typ of
            mtNotiz:
              for k := 0 to length(List)-1 do
              if (List[k].Image = NotizIndex) then
              begin
                SetLength(FRM_Uebersicht.UUni,j+1);
                FRM_Uebersicht.UUni[j].Color := Color;
                FRM_Uebersicht.UUni[j].Pos.p[0] := g;
                FRM_Uebersicht.UUni[j].Pos.p[1] := s;
                FRM_Uebersicht.UUni[j].Pos.p[2] := p;
             end;
            mtPlayer:
              if (ODataBase.Uni[g,s].SystemCopy >= 0)and(UpperCase(ODataBase.Systeme[ODataBase.Uni[g,s].SystemCopy].Planeten[p].Player) = UpperCase(Bezeichner)) then
              begin
                SetLength(FRM_Uebersicht.UUni,j+1);
                FRM_Uebersicht.UUni[j].Color := Color;
                FRM_Uebersicht.UUni[j].Pos.p[0] := g;
                FRM_Uebersicht.UUni[j].Pos.p[1] := s;
                FRM_Uebersicht.UUni[j].Pos.p[2] := p;
              end;
            mtAlly:
            if (ODataBase.Uni[g,s].SystemCopy >= 0)and(UpperCase(ODataBase.Systeme[ODataBase.Uni[g,s].SystemCopy].Planeten[p].Ally) = UpperCase(Bezeichner)) then
              begin
                SetLength(FRM_Uebersicht.UUni,j+1);
                FRM_Uebersicht.UUni[j].Color := Color;
                FRM_Uebersicht.UUni[j].Pos.p[0] := g;
                FRM_Uebersicht.UUni[j].Pos.p[1] := s;
                FRM_Uebersicht.UUni[j].Pos.p[2] := p;
              end;
            end;
          end;
          //-------------------------------------------------------------------
          node := LV_Options.GetNext(node);
        end;
      end;
      ProgressBar1.Position := (g-1)*max_Systems + s;
      Application.ProcessMessages;
    end;
  FRM_Uebersicht.PB_Uni.Refresh;
end;

procedure TFRM_Marker.Button1Click(Sender: TObject);
begin
  Generate;
end;

procedure TFRM_Marker.Markierunghinzufgen1Click(Sender: TObject);
var node: PVirtualNode;
begin
  node := LV_Options.AddChild(nil);
  with TMarker(LV_Options.GetNodeData(node)^) do
  begin
    Color := clYellow;
    Aktive := True;
  end;
  Node.CheckState := csCheckedNormal;
end;

procedure TFRM_Marker.Button2Click(Sender: TObject);
begin
  close;
end;

procedure TFRM_Marker.Lschen1Click(Sender: TObject);
var node: PVirtualNode;
begin
  node := LV_Options.GetFirstSelected;
  LV_Options.Selected[LV_Options.GetNext(node)] := True; //prüft anscheinend selber ob node da oder nicht!
  LV_Options.DeleteNode(node);
end;

procedure TFRM_Marker.Load;
var ini: TMemIniFile;
    node: PVirtualNode;
    nodeData: ^TMarker;
begin
  ini := TMemIniFile.Create(IniFile);
  LV_Options.RootNodeCount := ini.ReadInteger('OverviewMarker','Count',0);
  node := LV_Options.GetFirst;
  while node <> nil do
  begin
    nodeData := LV_Options.GetNodeData(node);
    with nodeData^ do
    begin
      Typ := TMarkerTyp(ini.ReadInteger('OverviewMarker','MTyp'+inttostr(node.Index),0));
      Color := ini.ReadInteger('OverviewMarker','MColor'+inttostr(node.Index),clred);
      Bezeichner := ini.ReadString('OverviewMarker','MBezeichner'+inttostr(node.Index),'');
      NotizIndex := ini.ReadInteger('OverviewMarker','MNotizIndex'+inttostr(node.Index),0);
      Aktive := ini.ReadBool('OverviewMarker','MChecked'+inttostr(node.Index),False);
    end;
    node := LV_Options.GetNext(node);
  end;
end;

procedure TFRM_Marker.Save;
var ini: TMemIniFile;
    node: PVirtualNode;
    nodeData: ^TMarker;
begin
  ini := TMemIniFile.Create(IniFile);
  ini.WriteInteger('OverviewMarker','Count',LV_Options.RootNodeCount);
  node := LV_Options.GetFirst;
  while node <> nil do
  begin
    nodeData := LV_Options.GetNodeData(node);
    with nodeData^ do
    begin
      ini.WriteInteger('OverviewMarker','MTyp'+inttostr(node.Index),integer(Typ));
      ini.WriteInteger('OverviewMarker','MColor'+inttostr(node.Index),Color);
      ini.WriteString('OverviewMarker','MBezeichner'+inttostr(node.Index),Bezeichner);
      ini.WriteInteger('OverviewMarker','MNotizIndex'+inttostr(node.Index),NotizIndex);
      ini.WriteBool('OverviewMarker','MChecked'+inttostr(node.Index),Aktive);
    end;
    node := LV_Options.GetNext(node);
  end;
  ini.UpdateFile;
  ini.free;
end;

procedure TFRM_Marker.FormCreate(Sender: TObject);
begin
  LV_Options.NodeDataSize := sizeof(TMarker);
  IniFile := ODataBase.PlayerInf;
  Load;
  CB_Typ.ItemIndex := 0;
  CB_TypChange(self);
  CB_Notizen.OnDrawItem := FRM_Notizen.CB_Image.OnDrawItem;
  CB_Notizen.Items := FRM_Notizen.CB_Image.Items;
  CB_Notizen.ItemIndex := 0;
  if SaveCaptions then SaveAllCaptions(Self,LangFile);
  if LoadCaptions then LoadAllCaptions(Self,LangFile);
end;

procedure TFRM_Marker.FormDestroy(Sender: TObject);
begin
  Save;
end;

procedure TFRM_Marker.CB_TypChange(Sender: TObject);
begin
  TXT_Bezeichner.Visible := not (CB_Typ.ItemIndex = 0);
  CB_Notizen.Visible := (CB_Typ.ItemIndex = 0);
  if (LV_Options.FocusedNode <> nil)and(not SetVal) then
  with TMarker(LV_Options.GetNodeData(LV_Options.FocusedNode)^) do
  begin
    Typ := TMarkerTyp(CB_Typ.ItemIndex);
    Color := P_Color.Color;
    Bezeichner := TXT_Bezeichner.Text;
    NotizIndex := CB_Notizen.ItemIndex;
    LV_Options.Refresh;
  end;
end;

procedure TFRM_Marker.P_ColorClick(Sender: TObject);
begin
  if (LV_Options.FocusedNode <> nil) then
  begin
    if (ColorDialog1.Execute) then
    begin
      P_Color.Color := ColorDialog1.Color;
      CB_TypChange(self);
    end;
  end else ShowMessage(STR_Marker_Eintrag_markieren);
end;

procedure TFRM_Marker.LV_OptionsGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var nodeData: ^TMarker;
begin
  nodeData := LV_Options.GetNodeData(Node);
  case Column of
  0: if nodeData^.Typ = mtNotiz then CellText := CB_Notizen.Items[nodeData^.NotizIndex] else CellText := nodeData^.Bezeichner;
  1: CellText := CB_Typ.Items[integer(nodeData^.Typ)];
  end;
end;

procedure TFRM_Marker.LV_OptionsChecked(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
begin
  TMarker(LV_Options.GetNodeData(node)^).Aktive := Node.CheckState = csCheckedNormal;
end;

procedure TFRM_Marker.LV_OptionsPaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
var
  data: ^TMarker;
begin
  data := LV_Options.GetNodeData(node);
  TargetCanvas.Font.Color := data^.Color;
end;

procedure TFRM_Marker.LV_OptionsInitNode(Sender: TBaseVirtualTree;
  ParentNode, Node: PVirtualNode;
  var InitialStates: TVirtualNodeInitStates);
begin
  node.CheckType := ctCheckBox;
end;

procedure TFRM_Marker.LV_OptionsBeforeItemPaint(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect;
  var CustomDraw: Boolean);
begin
 if TMarker(LV_Options.GetNodeData(Node)^).Aktive then
   Node^.CheckState := csCheckedNormal else Node^.CheckState := csUncheckedNormal;
end;

procedure TFRM_Marker.LV_OptionsFocusChanged(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex);
begin
  if (node <> nil)and(vsSelected in Node^.States) then
  with TMarker(LV_Options.GetNodeData(Node)^) do
  begin
    SetVal := true;
    CB_Typ.ItemIndex := integer(Typ);
    CB_TypChange(Self);
    TXT_Bezeichner.Text := Bezeichner;
    P_Color.Color := Color;
    CB_Notizen.ItemIndex := NotizIndex;
    SetVal := false;
  end;
end;

procedure TFRM_Marker.CB_NotizenKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  CB_Notizen.Items := FRM_Notizen.CB_Image.Items;
end;

end.
