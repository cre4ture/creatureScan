unit Notizen;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, ComCtrls, ToolWin, StdCtrls, Buttons, ImgList, OGame_Types, Prog_Unit, IniFiles,
  VirtualTrees, Menus;

type
  TNotizTyp = (nPlanet, nPlayer, nAlly);
  TNotiz = record                                                            
    SNode: PVirtualNode; //pointer auf sich selber!
    Typ: TNotizTyp;
    Note: string;
    Image: Integer;
    Date: TDateTime;
    Pos: TPlanetPosition;
    PlayerOrAlly: string;
  end;
  TNoteImage = record
    Name: string;
    filename: string;
    BackgroundColor: TColor;
  end;
  TNotizArray = array of TNotiz;
  TFRM_Notizen = class(TForm)
    Panel2: TPanel;
    Label1: TLabel;
    CB_Image: TComboBox;
    ImageList1: TImageList;
    TXT_Notiz: TEdit;
    TXT_Spezifikation: TEdit;
    LBL_bezeichner: TLabel;
    VST_Notizen: TVirtualStringTree;
    PopupMenu1: TPopupMenu;
    Entfernen1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TXT_NotizKeyPress(Sender: TObject; var Key: Char);
    procedure CB_ImageDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure VST_NotizenGetNodeDataSize(Sender: TBaseVirtualTree;
      var NodeDataSize: Integer);
    procedure CB_ImageChange(Sender: TObject);
    procedure Entfernen1Click(Sender: TObject);
    procedure VST_NotizenGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: String);
    procedure VST_NotizenGetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: Integer);
    procedure VST_NotizenFocusChanged(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex);
    procedure VST_NotizenCompareNodes(Sender: TBaseVirtualTree; Node1,
      Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure VST_NotizenHeaderClickX(Sender: TVTHeader;
      Column: TColumnIndex; Button: TMouseButton; Shift: TShiftState; X,
      Y: Integer);
    procedure VST_NotizenHeaderClick(Sender: TVTHeader;
      HitInfo: TVTHeaderHitInfo);
  private
    Images: array of TNoteImage;
    IniFile: String;
    procedure LoadImages;
    procedure SaveImages;
    { Private-Deklarationen }
  public
    procedure Add(Notiz: TNotiz);
    function GetPlanetInfo(APos: TPlanetPosition): TNotizArray;
    procedure ShowAddDialog(Sender: TForm; Position: TPlanetPosition; NT: TNotizTyp = nPlanet);
    procedure AddPlanet(Notiz: string; Planet: TPLanetPosition; Image: integer);
    procedure AddPlayer(Notiz: string; Player: string; Image: integer);
    procedure AddAlly(Notiz: string; Ally: string; Image: integer);
    procedure ReplacePlayername(Name, InTo: string);
    function GetBackgroundColor(Typ: Integer): TColor;
    procedure EditImages;
    function GenerateNextImageFilename: string;
    procedure ClearAndLoadStandartImages;
    procedure Show;
    { Public-Deklarationen }
  end;

const
  NotizSection = 'Notizen';

var
  FRM_Notizen: TFRM_Notizen;


function IMGFilename(i: integer): string;

implementation

{$R *.DFM}

uses AddNotiz, Main, Languages, Notizen_Images_Einstellungen;

procedure TFRM_Notizen.Add(Notiz: TNotiz);
var node: PVirtualNode;
begin
  node := VST_Notizen.AddChild(nil);
  TNotiz(VST_Notizen.GetNodeData(node)^) := Notiz;
end;

function TFRM_Notizen.GetPlanetInfo(APos: TPlanetPosition): TNotizArray;
var node: PVirtualNode;
begin
  SetLength(result,0);
  if ValidPosition(APos) then
  begin
    node := VST_Notizen.GetFirst;
    with ODataBase do
    while node <> nil do
    with TNotiz(VST_Notizen.GetNodeData(node)^) do
    begin
      SNode := node; //nochmal, weil der pointer nur begrenzte zeit stimmt!
      case Typ of
      nPlanet: if SamePlanet(APos,Pos) then
        begin
          Setlength(result,length(result)+1);
          Result[length(result)-1] := TNotiz(VST_Notizen.GetNodeData(node)^)
        end;
      nPlayer: if (GetSystemCopyNR(APos) >= 0)and
           (Systeme[GetSystemCopyNR(APos)].Planeten[APos.P[2]].Player = PlayerOrAlly) then
        begin
          Setlength(result,length(result)+1);
          Result[length(result)-1] := TNotiz(VST_Notizen.GetNodeData(node)^);
        end;
      nAlly: if (GetSystemCopyNR(APos) >= 0)and
           (Systeme[GetSystemCopyNR(APos)].Planeten[APos.P[2]].Ally = PlayerOrAlly) then
        begin
          Setlength(result,length(result)+1);
          Result[length(result)-1] := TNotiz(VST_Notizen.GetNodeData(node)^);
        end;
      end;
      node := VST_Notizen.GetNext(node);
    end;
  end;
end;

procedure TFRM_Notizen.FormCreate(Sender: TObject);
var ini : TMemIniFile;
    c,i : integer;
    node : PVirtualNode;
    s: string;
begin
  IniFile := ODataBase.PlayerInf;
  LoadImages;
  ini := TMemIniFile.Create(IniFile);
  c := ini.ReadInteger(NotizSection,'NoteCount',0);
  for i := 0 to c-1 do
  begin
    node := VST_Notizen.AddChild(nil);
    with TNotiz(VST_Notizen.GetNodeData(Node)^) do
    begin
      s := ini.ReadString(NotizSection,'Notiz'+inttostr(i)+'_Bezeichner','');
      if ini.ReadString(NotizSection,'NotizTyp'+inttostr(i),'') = '' then   //wenn alte version, dann import!
      begin
        if ValidPosition(StrToPosition(s)) then Typ := nPlanet
        else if copy(s,1,1) = '[' then
        begin
          Typ := nAlly;
          s := copy(s,2,length(s)-2);
        end else Typ := nPlayer;
      end else Typ := TNotizTyp(ini.ReadInteger(NotizSection,'NotizTyp'+inttostr(i),0));
      case Typ of
      nPlanet: Pos := StrToPosition(s);
      nPlayer, nAlly: PlayerOrAlly := s;
      end;
      Note := ini.ReadString(NotizSection,'Notiz'+inttostr(i)+'_Notiz','');
      Date := ini.ReadDateTime(NotizSection,'Notiz'+inttostr(i)+'_Datum',now);
      Image := ini.ReadInteger(NotizSection,'Notiz'+inttostr(i)+'_Typ',0);
    end;
  end;
  ini.free;
  if SaveCaptions then SaveAllCaptions(Self,LangFile);
  if LoadCaptions then LoadAllCaptions(Self,LangFile);
end;

procedure TFRM_Notizen.FormDestroy(Sender: TObject);
var ini : TMemIniFile;
    i : integer;
    node: PVirtualNode;
begin
  ini := TMemIniFile.Create(IniFile);
  node := VST_Notizen.GetFirst;
  i := 0;
  while node <> nil do
  with TNotiz(VST_Notizen.GetNodeData(node)^) do
  begin
    ini.WriteInteger(NotizSection,'NotizTyp'+inttostr(i),integer(Typ));
    case Typ of
      nPlanet: ini.WriteString(NotizSection,'Notiz'+inttostr(i)+'_Bezeichner',PositionToStr_(Pos));
      nPlayer, nAlly: ini.WriteString(NotizSection,'Notiz'+inttostr(i)+'_Bezeichner',PlayerOrAlly);
    end;
    ini.WriteString(NotizSection,'Notiz'+inttostr(i)+'_Notiz',Note);
    ini.WriteDateTime(NotizSection,'Notiz'+inttostr(i)+'_Datum',Date);
    ini.WriteInteger(NotizSection,'Notiz'+inttostr(i)+'_Typ',Image);
    inc(i);
    node := VST_Notizen.GetNext(node);
  end;
  ini.WriteInteger(NotizSection,'NoteCount',i);
  ini.UpdateFile;
  ini.free;
end;

procedure TFRM_Notizen.TXT_NotizKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
  begin
    key := #0;
    CB_ImageChange(self);
  end;
end;

procedure TFRM_Notizen.CB_ImageDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
begin
  with Control as TComboBox do
  begin
    if odSelected in State then
    begin
      Canvas.Pen.Color := clBlack;
      Canvas.Pen.Style := psDot;
      Canvas.Brush.Color := clHighlight;
    end
    else
    begin
      Canvas.Pen.Color := clWindow;
      Canvas.Pen.Style := psSolid;
      Canvas.Brush.Color := clWindow;
    end;
    Canvas.Rectangle(rect);
    ImageList1.draw(Canvas,Rect.Left,Rect.Top,Index);
    Canvas.TextOut(Rect.Left + ImageList1.Width + 2,Rect.Top + 2,CB_Image.Items.Strings[index]);
  end;
end;

procedure TFRM_Notizen.ShowAddDialog(Sender: TForm; Position: TPlanetPosition; NT: TNotizTyp = nPlanet);
var FRM: TFRM_AddNotiz;
    i: integer;
    Player, Ally: string;
begin
  Position.Mond := False; //keine notizen für mond extra!!!!!!!!!!
  FRM := TFRM_AddNotiz.Create(Sender);
  FRM.LBL_PLanet.Caption := PositionToStr_(Position);
  Player := '';
  Ally := '';
  i := ODataBase.GetSystemCopyNR(Position);
  if i >= 0 then
  begin
    Player := ODataBase.Systeme[i].Planeten[Position.P[2]].Player;
    Ally := ODataBase.Systeme[i].Planeten[Position.P[2]].Ally;
  end;

  if Player = '' then FRM.RB_Spieler.Enabled := False
  else FRM.LBL_Spieler.Caption := Player;
  if Ally = '' then FRM.RB_Allianz.Enabled := False
  else FRM.LBL_Allianz.Caption := '['+Ally+']';

  FRM.RB_Spieler.Checked := (NT = nPlayer);
  FRM.RB_Allianz.Checked := (NT = nAlly);
  FRM.RB_Planet.Checked := not((FRM.RB_Spieler.Checked and FRM.RB_Spieler.Enabled)or(FRM.RB_Allianz.Checked and FRM.RB_Allianz.Enabled));

  if FRM.ShowModal = mrOK then
  begin
    if FRM.RB_Planet.Checked then
      AddPlanet(FRM.TXT_Notiz.Text,Position,FRM.CB_Icon.ItemIndex);
    if FRM.RB_Spieler.Checked then
      AddPlayer(FRM.TXT_Notiz.Text,Player,FRM.CB_Icon.ItemIndex);
    if FRM.RB_Allianz.Checked then
      AddAlly(FRM.TXT_Notiz.Text,Ally,FRM.CB_Icon.ItemIndex);
  end;
  FRM.Release;
end;

procedure TFRM_Notizen.VST_NotizenGetNodeDataSize(
  Sender: TBaseVirtualTree; var NodeDataSize: Integer);
begin
  NodeDataSize := sizeof(TNotiz);
end;

procedure TFRM_Notizen.AddPlanet(Notiz: string; Planet: TPLanetPosition; Image: integer);
var nt: TNotiz;
begin
  nt.Typ := nPlanet;
  nt.Note := Notiz;
  nt.Image := Image;
  nt.Pos := Planet;
  nt.Date := now;
  Add(nt);
end;

procedure TFRM_Notizen.AddPlayer(Notiz: string; Player: string; Image: integer);
var nt: TNotiz;
begin
  nt.Typ := nPlayer;
  nt.Note := Notiz;
  nt.Image := Image;
  nt.PlayerOrAlly := Player;
  nt.Date := now;
  Add(nt);
end;

procedure TFRM_Notizen.AddAlly(Notiz: string; Ally: string; Image: integer);
var nt: TNotiz;
begin
  nt.Typ := nAlly;
  nt.Note := Notiz;
  nt.Image := Image;
  nt.PlayerOrAlly := Ally;
  nt.Date := now;
  Add(nt);
end;

procedure TFRM_Notizen.CB_ImageChange(Sender: TObject);
var node: PVirtualNode;
begin
  Node := VST_Notizen.GetFirstSelected;
  if node <> nil then
  with TNotiz(VST_Notizen.GetNodeData(node)^) do
  begin
    Note := TXT_Notiz.Text;
    Date := now;
    Image := CB_Image.ItemIndex;
    case Typ of
      nPlanet: if ValidPosition(StrToPosition(TXT_Spezifikation.Text)) then Pos := StrToPosition(TXT_Spezifikation.Text);
      nPlayer, nAlly: PlayerOrAlly := TXT_Spezifikation.Text;
    end;
    VST_Notizen.RepaintNode(node);
  end;
end;

procedure TFRM_Notizen.Entfernen1Click(Sender: TObject);
begin
  VST_Notizen.DeleteSelectedNodes;
end;

procedure TFRM_Notizen.ReplacePlayername(Name, InTo: string);
var node: PVirtualNode;
begin
  node := VST_Notizen.GetFirst;
  while node <> nil do
  begin
    with TNotiz(VST_Notizen.GetNodeData(Node)^) do
    begin
      if (Typ = nPlayer)and(PlayerOrAlly = Name) then PlayerOrAlly := InTo;
    end;
    node := VST_Notizen.GetNext(node);
  end;
end;

function TFRM_Notizen.GetBackgroundColor(Typ: Integer): TColor;
begin
  Result := clBlack;
  if (typ >= 0)and(typ < length(Images)) then
    Result := Images[Typ].BackgroundColor;
end;

procedure TFRM_Notizen.VST_NotizenGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: String);
begin
  CellText := '';
  with TNotiz(VST_Notizen.GetNodeData(Node)^) do
  begin
    case Column of
    1: case Typ of
       nPlanet: CellText := PositionToStr_(Pos);
       nPlayer: CellText := PlayerOrAlly;
       nAlly: CellText := '[' + PlayerOrAlly + ']';
       end;
    2: CellText := Note;
    3: CellText := DateTimeToStr(Date);
    end;
  end;
end;

procedure TFRM_Notizen.VST_NotizenGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);
begin
  if (Column = 0)and(Kind in [ikSelected,ikNormal]) then
  with TNotiz(VST_Notizen.GetNodeData(Node)^) do
  begin
    ImageIndex := Image;
  end;
end;

procedure TFRM_Notizen.VST_NotizenFocusChanged(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex);
begin
  if (node <> nil) then
  with TNotiz(Sender.GetNodeData(Node)^) do
  begin
    TXT_Notiz.Text := Note;
    case typ of
    nPlanet: begin TXT_Spezifikation.Text := PositionToStr_(Pos); LBL_bezeichner.Caption := STR_Planet; end;
    nPlayer: begin TXT_Spezifikation.Text := PlayerOrAlly; LBL_bezeichner.Caption := STR_Spieler; end;
    nAlly: begin TXT_Spezifikation.Text := PlayerOrAlly; LBL_bezeichner.Caption := STR_Allianz; end;
    end;
    CB_Image.ItemIndex := Image;
  end;
end;

procedure TFRM_Notizen.VST_NotizenCompareNodes(Sender: TBaseVirtualTree;
  Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var n1,n2: TNotiz;
    s1,s2: string;
begin
  n1 := TNotiz(Sender.GetNodeData(node1)^);
  n2 := TNotiz(Sender.GetNodeData(node2)^);
  case n1.Typ of
  nPlanet: s1 := PositionToStrAMond(n1.Pos);
  nPlayer: s1 := n1.PlayerOrAlly;
  nAlly: s1 := '[' + n1.PlayerOrAlly + ']';
  end;
  case n2.Typ of
  nPlanet: s2 := PositionToStrAMond(n2.Pos);
  nPlayer: s2 := n2.PlayerOrAlly;
  nAlly: s2 := '[' + n2.PlayerOrAlly + ']';
  end;
  case Column of
  0: if n1.Image > n2.Image then Result := 1 else Result := -1;
  1: if s1 > s2 then Result := 1 else Result := -1;
  2: if n1.Note > n2.Note then Result := 1 else Result := -1;
  3: if n1.Date > n2.Date then Result := 1 else Result := -1;
  end;
end;

procedure TFRM_Notizen.VST_NotizenHeaderClickX(Sender: TVTHeader;
  Column: TColumnIndex; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  with Sender do
  begin
    SortColumn := Column;
    if SortDirection = High(SortDirection) then
      SortDirection := low(SortDirection)
    else SortDirection := High(SortDirection);
  end;
end;

procedure TFRM_Notizen.LoadImages;
var ini: TIniFile;
    i,c: integer;
    bmp: TBitmap;
begin
  ini := TIniFile.Create(inifile);
  bmp := TBitmap.Create;
  bmp.Height := ImageList1.Height;
  bmp.Width := ImageList1.Width;
  c := ini.ReadInteger(NotizSection,'ITP_Count',0);
  SetLength(images,c);
  for i := 0 to c-1 do
  with Images[i] do
  begin
    Name := ini.ReadString(NotizSection,'ITP'+IntToStr(i)+'_na','');
    filename := ini.ReadString(NotizSection,'ITP'+IntToStr(i)+'_file','');
    BackgroundColor := ini.ReadInteger(NotizSection,'ITP'+IntToStr(i)+'_co',clBlack);
    ChDir(ExtractFilePath(Application.ExeName));
    if FileExists(filename) then
      bmp.LoadFromFile(filename);
    ImageList1.AddMasked(bmp,bmp.Canvas.Pixels[0,0]);
    CB_Image.Items.Add(Name);
  end;
  bmp.free;
  ini.free;
  if length(Images) = 0 then ClearAndLoadStandartImages;
end;

procedure TFRM_Notizen.SaveImages;
var ini: TIniFile;
    i,c: integer;
begin
  ini := TIniFile.Create(inifile);
  c := length(images);
  ini.WriteInteger(NotizSection,'ITP_Count',c);
  for i := 0 to c-1 do
  with Images[i] do
  begin
    ini.WriteString(NotizSection,'ITP'+IntToStr(i)+'_na',Name);
    ini.WriteString(NotizSection,'ITP'+IntToStr(i)+'_file',filename);
    ini.WriteInteger(NotizSection,'ITP'+IntToStr(i)+'_co',BackgroundColor);
  end;
  ini.free;
end;

procedure TFRM_Notizen.EditImages;
var frm: TFRM_Notizen_Images_einstellungen;
    i: integer;
begin
  frm := TFRM_Notizen_Images_einstellungen.Create(self);
  frm.ImageList1.AddImages(ImageList1);
  for i := 0 to length(Images)-1 do
  with frm.ListView1.Items.Add do
  begin
    Caption := '';
    SubItems.Add(images[i].Name);
    SubItems.Add(Images[i].filename);
    SubItems.Add(IntToStr(Images[i].BackgroundColor));
    ImageIndex := i;
  end;
  if frm.ShowModal = mrOK then
  begin
    ImageList1.Clear;
    ImageList1.AddImages(frm.ImageList1);
    CB_Image.Items.Clear;
    SetLength(images,frm.ListView1.Items.Count);
    for i := 0 to length(Images)-1 do
    with frm.ListView1.Items[i] do
    begin
      images[i].Name := SubItems[0];
      if pos(copy(GenerateNextImageFilename,1,10),SubItems[1]) <= 0 then
      begin
        images[i].filename := GenerateNextImageFilename;
        CopyFileA(PAnsiChar(AnsiString(SubItems[1])),PAnsiChar(AnsiString(images[i].filename)),false);
      end else images[i].filename := SubItems[1];
      images[i].BackgroundColor := StrToInt(SubItems[2]);
      CB_Image.Items.Add(SubItems[0]);
    end;
    SaveImages;
  end;
  frm.free;
end;

function IMGFilename(i: integer): string;
begin
  Result := 'images/img' + IntToStr(i) + '.bmp';
end;

function TFRM_Notizen.GenerateNextImageFilename: string;
var i: integer;
begin
  chdir(ExtractFilePath(Application.ExeName));
  i := 0;
  Result := IMGFilename(i);
  while FileExists(Result) do
  begin
    Result := IMGFilename(i);
    inc(i);
  end;
end;

procedure TFRM_Notizen.ClearAndLoadStandartImages;
var i: integer;
    bmp: TBitmap;
begin
  SetLength(Images,7);
  ChDir(ExtractFilePath(Application.ExeName));
  bmp := TBitmap.Create;
  CB_Image.Items.Clear;
  ImageList1.Clear;
  for i := 0 to length(Images)-1 do
  begin
    bmp.LoadFromFile(IMGFilename(i));
    ImageList1.AddMasked(bmp,bmp.Canvas.Pixels[0,0]);
    with Images[i] do
    begin
      filename := IMGFilename(i);
      BackgroundColor := clBlack;
      case i of
      0: Name := STR_Images_Name0;
      1: Name := STR_Images_Name1;
      2: begin Name := STR_Images_Name2; BackgroundColor := clGreen; end;
      3: begin Name := STR_Images_Name3; BackgroundColor := clMaroon; end;
      4: Name := STR_Images_Name4;
      5: Name := STR_Images_Name5;
      6: begin Name := STR_Images_Name6; BackgroundColor := $000080FF; end;
      end;
      CB_Image.Items.Add(Name);
    end;
  end;
  SaveImages;
  bmp.free;
end;

procedure TFRM_Notizen.Show;
begin
  if WindowState = wsMinimized then
    WindowState := wsNormal;
  inherited Show;
end;

procedure TFRM_Notizen.VST_NotizenHeaderClick(Sender: TVTHeader;
  HitInfo: TVTHeaderHitInfo);
begin
  VST_NotizenHeaderClickX(Sender, HitInfo.Column, HitInfo.Button,
    HitInfo.Shift, HitInfo.X, HitInfo.Y);
end;

end.
