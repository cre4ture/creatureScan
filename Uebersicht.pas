unit Uebersicht;

interface
                                                                                           
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, OGame_Types, galaxy_explorer, notizen, UeberSichtOptions,
  Menus, Prog_Unit, DateUtils, CoordinatesRanges, math, FavFilter,
  Favoriten;

type
  TUPlanet = record
    Pos: TPlanetPosition;
    Color: TColor;
  end;
  TATyp = (at_ogame,at_spacepioneers);
  TFRM_Uebersicht = class(TForm)
    Timer1: TTimer;
    PB_Lupe: TPaintBox;
    PopupMenu1: TPopupMenu;
    Zeitfaktor1: TMenuItem;
    N11: TMenuItem;
    N121: TMenuItem;
    N12: TMenuItem;
    N141: TMenuItem;
    N151: TMenuItem;
    N161: TMenuItem;
    N171: TMenuItem;
    Panel1: TPanel;
    Label2: TLabel;
    Button2: TButton;
    CH_Planeten: TCheckBox;
    CH_Systeme: TCheckBox;
    CH_Scans: TCheckBox;
    ScrollBox1: TScrollBox;
    PB_Uni: TPaintBox;
    Label4: TLabel;
    LBL_Koords: TLabel;
    Splitter1: TSplitter;
    cb_filter: TCheckBox;
    lb_ranges: TListBox;
    PopupMenu2: TPopupMenu;
    delete1: TMenuItem;
    new1: TMenuItem;
    editr1: TMenuItem;
    cb_point_stats: TCheckBox;
    procedure PB_ogame_UniPaint(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure PB_UniMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CH_PlanetenClick(Sender: TObject);
    procedure PB_UniDblClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure N11Click(Sender: TObject);
    procedure PB_UniPaint(Sender: TObject);
    procedure PB_SP_UniPaint(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure PB_UniMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PB_UniMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure delete1Click(Sender: TObject);
    procedure lb_rangesClick(Sender: TObject);
    procedure new1Click(Sender: TObject);
    procedure editr1Click(Sender: TObject);
  private
    zf: single;
    mspos: TPlanetPosition;
    selpos: TPoint;
    dx,dy: integer;
    MouseDown: Boolean;
    MouseDownPos: TPoint;
    MouseSelectionPlanetRange: TPlanetRange;
    procedure DrawFilterRanges;
    function CursorPosToKoord(x, y: Integer): TPlanetPosition;
    procedure Refresh_lb_ranges;
    { Private-Deklarationen }
  public
    Selected: TPlanetRangeList;
    UUni: array of TUPlanet;
    AnzeigeTyp: TATyp;
    procedure DeleteItem(Index: Integer);
    procedure SetSelected(sel: TPlanetRangeList);
    { Public-Deklarationen }
  end;
const x = -1;
      y = -1;

var
  FRM_Uebersicht: TFRM_Uebersicht;

implementation

uses Main, Languages, Stat_Points;

{$R *.DFM}

procedure TFRM_Uebersicht.DeleteItem(Index: Integer);
begin
  if (Index < 0)or(Index >= Selected.Count) then
    raise Exception.Create
      ('TForm1.DeleteItem: Index Auserhalb des gültigen Bereichs!!!');

  Selected.Delete(Index);
  Refresh_lb_ranges;
end;

procedure DrawPlanetRange(Canvas: TCanvas; Range: TPlanetRange);
var g1,g2: integer;
    s1,s2: integer;
    p1,p2: integer;
    j, w1,w2, h: integer;
begin
  g1 := Range[0].start;
  g2 := Range[0].ende;
  s1 := Range[1].start;
  s2 := Range[1].ende;
  p1 := Range[2].start;
  p2 := Range[2].ende;

  for j := g1 to g2 do
  begin
    Canvas.Rectangle(s1-1,(j-1)*20+p1+1,s2,(j-1)*20+p2+2);

    w1 := Canvas.TextWidth(IntToStr(s1));
    h := (20-Canvas.TextHeight(IntToStr(s1))) div 2;
    w2 := Canvas.TextWidth(IntToStr(s2));
    if (w1+w2+4 > s2-s1) then
    begin
      Canvas.TextOut(s1-2-w1,(j-1)*20+h,IntToStr(s1));
      Canvas.TextOut(s2+1,(j-1)*20+h,IntToStr(s2));
    end else
    begin
      Canvas.TextOut(s1+1,(j-1)*20+h,IntToStr(s1));
      Canvas.TextOut(s2-3-w2,(j-1)*20+h,IntToStr(s2));
    end;
  end;
end;

procedure PlanetPositionsToRange(p1,p2: TPlanetPosition;
  Range: TPlanetRange);
var i: integer;
    r: TCoordinatesRange;
begin
  Range.Clear;
  for i := 0 to 1 do
  begin
    r.start := Min(p1.p[i],p2.p[i]);
    r.ende := Max(p1.p[i],p2.p[i]);
    Range.AddRange(r);
  end;

  //Bei den PlanetenPositionen macht es meiner meinung keinen Sinn
  //einen Filter anzulegen!
  r.start := 1;
  r.ende := max_Planeten;
  Range.AddRange(r);

  RangeListIntersection(Range, OGameRangeList);
end;

procedure TFRM_Uebersicht.PB_ogame_UniPaint(Sender: TObject);
var g,s,p,scn,i : integer;
    c : Tcolor;
    ShowPlanets: Boolean;
    ShowSystems: Boolean;
    ShowScans, ShowStats, b: Boolean;
    t: Int64;
    sys: TSystemCopy;
    sts: integer;
begin
  ShowPlanets := CH_Planeten.Checked;
  ShowSystems := CH_Systeme.Checked;
  ShowScans := CH_Scans.Checked;
  ShowStats := cb_point_stats.Checked;

  PB_Uni.Canvas.Brush.Color := clBlack;
  PB_Uni.Canvas.Pen.Color := clBlack;
  PB_Uni.Canvas.Rectangle(0,0,PB_Uni.Width,PB_Uni.Height);
  for g := 1 to max_Galaxy do
  begin
    for s := 1 to max_Systems do
    with PB_Uni.Canvas do
    begin
      scn := ODataBase.GetSystemCopyNR(g,s);
      if (scn >= 0) then
        sys := ODataBase.Systeme[scn];

      if ShowSystems and (scn >= 0) then
        c := AlterToColor_dt(
          ((ODataBase.FleetBoard.GameTime.Time - UnixToDateTime(sys.Time_u))*zf),
                          ODataBase.redHours[rh_systems])
      else
        c := clBlack;
      Pen.Color := c;
      MoveTo(x+s,y + dy*g);
      LineTo(x+s,y + dy*(g-1));


      if (scn >= 0) then
      begin
        if ShowPlanets then
        begin
          for p := 1 to max_Planeten do
          begin
            if sys.Planeten[p].Player <> '' then
            begin
              Pixels[x+s,y + dy*(g-1) + 2 + p] := clblue;
            end;
          end;
        end;

        if ShowStats then
        begin
          for p := 1 to max_Planeten do for b := False to true do
          if sys.Planeten[p].Player <> '' then
          begin
            sts := ODataBase.Statistic.StatisticPoints[sntPlayer,sptPoints,
                    sys.Planeten[p].Player,sys.Planeten[p].PlayerId];
            if sts > 0 then
            begin
              Pixels[x+s,y + dy*(g-1) + 2 + p] :=
                dPunkteToColor((sts - ODataBase.Stats_own),
                  ODataBase.redHours[rh_Points]);
            end
            else
              Pixels[x+s,y + dy*(g-1) + 2 + p] := clWhite;
          end;
        end;
      end;

      if ShowScans then
      begin
        for p := 1 to max_Planeten do for b := False to true do
        begin
          i := ODataBase.UniTree.UniReport(g,s,p,b);
          if i >= 0 then
          begin
            t := ODataBase.Berichte[i].Head.Time_u;

            Pixels[x+s,y + dy*(g-1) + 2 + p] :=
              AlterToColor_dt((Now - UnixToDateTime(t))*zf,
                ODataBase.redHours[rh_Scans]);
          end;
        end;
      end;
    end;

    //Graue Linien Zeichen
    PB_Uni.Canvas.Pen.Color := clGray;
    PB_Uni.Canvas.MoveTo(x+1,y + dy*(g-1) + 2);
    PB_Uni.Canvas.LineTo(x+1+max_Systems,y + dy*(g-1) + 2);
    PB_Uni.Canvas.MoveTo(x+1,y + dy*(g-1) + 3 + max_planeten);
    PB_Uni.Canvas.LineTo(x+1+max_Systems,y + dy*(g-1) + 3 + max_planeten);
  end;

  //Markierungen einzeichen
  for i := 0 to length(UUni)-1 do
  begin
    PB_Uni.Canvas.Pixels[x+UUni[i].Pos.p[1],y + dy*(UUni[i].Pos.p[0]-1) + 2 + UUni[i].Pos.p[2]] := UUni[i].Color;
  end;

  //Filter einzeichen
  if cb_filter.Checked then
  begin
    DrawFilterRanges;
  end;
end;

procedure TFRM_Uebersicht.Button1Click(Sender: TObject);
begin
  close;
end;

procedure TFRM_Uebersicht.PB_UniMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var p: Tpoint;
    zoomrect: Tpoint;
    pixelsize_x: single;
    pixelsize_y: single;
const
  zoom = 4;
begin
  if MouseDown and cb_filter.Checked then
  begin
    PlanetPositionsToRange(
        CursorPosToKoord(MouseDownPos.X,MouseDownPos.Y),
        CursorPosToKoord(X,Y),
        MouseSelectionPlanetRange);

    PB_Uni.Refresh;

    PB_Uni.Canvas.Brush.Color := clblue;
    DrawPlanetRange(PB_Uni.Canvas, MouseSelectionPlanetRange);
  end;



  case Anzeigetyp of
  at_ogame:
    begin
      mspos := CursorPosToKoord(x,y);
    end;
  at_spacepioneers:
    begin
      mspos.P[1] := (Y div dy)+1;
      mspos.P[0] := (x div dx)+1;
    end;
  end;


  if Anzeigetyp = at_spacepioneers then
  begin
    PB_Uni.Canvas.Brush.Style := bsClear;
    PB_Uni.Canvas.Pen.Color := clblack;
    PB_Uni.Canvas.Rectangle(selpos.x*dx,selpos.y*dy,(selpos.x +1)*dx+1,(selpos.y +1)*dy+1);
    selpos.x := (x div dx);
    selpos.y := (y div dy);
    PB_Uni.Canvas.Pen.Color := clRed;
    PB_Uni.Canvas.Rectangle(selpos.x*dx,selpos.y*dy,(selpos.x +1)*dx+1,(selpos.y +1)*dy+1);
  end;


  LBL_Koords.Caption := PositionToStr_(mspos);

  zoomrect.x := PB_Lupe.Width div zoom;
  zoomrect.y := PB_Lupe.Height div zoom;
  p := point(x - (zoomrect.x div 2),y - (zoomrect.y div 2));
  if p.x < 0 then
   p.x := 0;
  if p.y < 0 then
   p.y := 0;
  if p.x > PB_Uni.Width - zoomrect.x then
   p.x := PB_Uni.Width - zoomrect.x;
  if p.y > PB_Uni.Height - zoomrect.y then
   p.y := PB_Uni.Height - zoomrect.y;

  PB_Lupe.Canvas.CopyRect(rect(0,0,PB_Lupe.Width,PB_Lupe.Height),PB_Uni.Canvas,Rect(p.x,p.y,p.x + zoomrect.x,p.y + zoomrect.y));

  if Anzeigetyp = at_ogame then
  with PB_Lupe do
  begin
    Canvas.Pen.Mode := pmNot;
    pixelsize_x := PB_Lupe.Width / zoomrect.x;
    pixelsize_y := PB_Lupe.Height / zoomrect.y;
    p.x := round((x - p.x + 0.5)*pixelsize_x);
    p.y := round((y - p.y + 0.5)*pixelsize_y);
    Canvas.MoveTo(0,p.y);
    Canvas.LineTo(Width,p.y);
    Canvas.MoveTo(p.x,0);
    Canvas.LineTo(p.x,Height);
  end;
end;

procedure TFRM_Uebersicht.Timer1Timer(Sender: TObject);
begin
  PB_Uni.Repaint;
end;

procedure TFRM_Uebersicht.FormCreate(Sender: TObject);
begin                     //Achtung! diese Procedure wird auch nach ändern der spielereinstellungen, über die einstellungen aufgerufen!
  ScrollBox1.DoubleBuffered := true;
  DoubleBuffered := true;
  SetLength(UUni,0);
  zf := 1;

  AnzeigeTyp := at_ogame;


  case AnzeigeTyp of
  at_ogame:
    begin
      dy := 19;
      dx := 1;
      PB_Uni.Height := max_Galaxy * dy;
      PB_Uni.Width := max_Systems * dx;
    end;
  at_spacepioneers:
    begin
      dy := 6;
      dx := 6;
      PB_Uni.Width := max_Galaxy * dx;
      PB_Uni.Height := max_Systems * dy;
    end;
  end;

  ClientHeight := PB_Uni.Height + ScrollBox1.Top + 12;
  ClientWidth := PB_Uni.Width + ScrollBox1.Left + PB_Lupe.Width + 12;
  if (Height > Screen.Height-30) then
  begin
    Height := Screen.Height-30;
    ScrollBox1.Height := ClientHeight - ScrollBox1.Top - 12;
  end;

  if SaveCaptions then SaveAllCaptions(Self,LangFile);
  if LoadCaptions then LoadAllCaptions(Self,LangFile);

  Selected := nil;
end;

procedure TFRM_Uebersicht.CH_PlanetenClick(Sender: TObject);
begin
  if (cb_filter.Checked = true)and
     (Selected = nil) then
  begin
    cb_filter.Checked := False;
  end;

  PB_Uni.Repaint;
  lb_ranges.Visible := cb_filter.Checked;
  FormResize(Self);
end;

procedure TFRM_Uebersicht.PB_UniDblClick(Sender: TObject);
begin
  FRM_Main.ShowGalaxie(mspos);
end;

procedure TFRM_Uebersicht.FormShow(Sender: TObject);
begin
  Timer1.Enabled := true;
end;

procedure TFRM_Uebersicht.FormHide(Sender: TObject);
begin
  Timer1.Enabled := false;
end;

procedure TFRM_Uebersicht.Button2Click(Sender: TObject);
begin
  FRM_Marker.show;
end;

procedure TFRM_Uebersicht.N11Click(Sender: TObject);
begin
  with Sender as TMenuItem do
  begin
    zf := 1/Tag;
    Checked := true;
  end;
  PB_Uni.Repaint;
end;

procedure TFRM_Uebersicht.PB_UniPaint(Sender: TObject);
begin
  case Anzeigetyp of
    at_ogame: PB_ogame_UniPaint(sender);
    at_spacepioneers: PB_SP_UniPaint(sender);
  end;
end;


procedure TFRM_Uebersicht.PB_SP_UniPaint(Sender: TObject);
const
    positions: array[1..max_Planeten] of array[0..1] of integer = ((2,2),(4,2),(2,4),(4,4),(1,2),(5,2),(1,4),(5,4),(2,1),(4,1),(2,5),(4,5),(1,1),(5,1),(1,5){$IFDEF spacepioneers},(5,5){$ENDIF});
var x,y,p,i: integer;
    sx,sy,ex,ey: integer;
begin
  PB_Uni.Canvas.Brush.Color := clBlack;
  PB_Uni.Canvas.Brush.Style := bsSolid;
  PB_Uni.Canvas.FillRect(PB_Uni.Canvas.ClipRect);
  PB_Uni.Canvas.Brush.Color := rgb(30,30,30);

  for x := 1 to max_Galaxy do
  begin
    for y := 1 to max_Systems do
    if ODataBase.Uni[x,y].SystemCopy >= 0 then
    with ODataBase.Systeme[ODataBase.Uni[x,y].SystemCopy] do
    begin
      sx := (x-1)*6;
      sy := (y-1)*6;
      ex := (x*6);
      ey := (y*6);

      if CH_Systeme.Checked then
        PB_Uni.Canvas.Brush.Color := AlterToColor_dt(((Now - UnixToDateTime(Time_u))*zf),ODataBase.redHours[rh_systems]);

      PB_Uni.Canvas.FillRect(rect(sx+1,sy+1,ex,ey));

      if CH_Planeten.Checked then
      for p := 1 to max_planeten do
      begin
        if Planeten[p].Player <> '' then
          PB_Uni.Canvas.Pixels[sx + positions[p][0],sy + positions[p][1]] := clwhite;
      end;
    end;
  end;
  for i := 0 to length(UUni)-1 do
  begin
    PB_Uni.Canvas.Pixels[(UUni[i].Pos.p[0]-1)*6 + positions[UUni[i].Pos.p[2]][0],
                         (UUni[i].Pos.p[1]-1)*6 + positions[UUni[i].Pos.p[2]][1]] := UUni[i].Color;
  end;
end;

procedure TFRM_Uebersicht.FormResize(Sender: TObject);
begin
  if ScrollBox1.ClientWidth >= PB_Uni.Width then
  begin
    PB_Lupe.Width := ClientWidth - PB_Uni.Width - Splitter1.Width;
  end
  else
  begin
    if PB_Lupe.Width >= 200 then
      PB_Lupe.Width := ClientWidth - PB_Uni.Width - Splitter1.Width;
  end;

  if lb_ranges.Visible then
    PB_Lupe.Width := PB_Lupe.Width - lb_ranges.Width;

  if ClientHeight > Panel1.Height + PB_Uni.Height then
    ClientHeight := Panel1.Height + PB_Uni.Height;
end;

procedure TFRM_Uebersicht.DrawFilterRanges;
var i: integer;
begin
  PB_Uni.Canvas.Brush.Color := clGray;
  {PB_Uni.Canvas.Pen.Color := clBlack;
  for i := 1 to max_Galaxy do
  begin
    PB_Uni.Canvas.Rectangle(0,(i-1)*20,PB_Uni.Width,i*20);
  end;   }

  PB_Uni.Canvas.Brush.Color := clBlack;
  PB_Uni.Canvas.Font.Color := clWhite;
  for i := 0 to Selected.Count-1 do
      DrawPlanetRange(PB_Uni.Canvas,Selected[i]);

  if lb_ranges.ItemIndex >= 0 then
  begin
    PB_Uni.Canvas.Brush.Color := clnavy;
    DrawPlanetRange(PB_Uni.Canvas,Selected[lb_ranges.ItemIndex]);
  end;
end;

procedure TFRM_Uebersicht.PB_UniMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    MouseDown := True;
    MouseSelectionPlanetRange := TPlanetRange.Create;
    MouseDownPos.x := x;
    MouseDownPos.y := y;
  end;

  Timer1.Enabled := False;
end;

procedure TFRM_Uebersicht.PB_UniMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if MouseDown and cb_filter.Checked then
  begin
    PlanetPositionsToRange(
      CursorPosToKoord(MouseDownPos.X,MouseDownPos.Y),
      CursorPosToKoord(X,Y),
      MouseSelectionPlanetRange);

    if Button = mbLeft then
      Selected.AddPlanetRange(MouseSelectionPlanetRange);

    Refresh_lb_ranges;
  end;
  MouseDown := False;
  Timer1.Enabled := True;
end;

function TFRM_Uebersicht.CursorPosToKoord(x, y: Integer): TPlanetPosition;
var i: integer;
begin
  if x < 0 then
   x := 0;
  if y < 0 then
   y := 0;

  result.P[0] := (y div dy)+1;
  result.P[1] := (x div dx)+1;

  i := y mod dy -1;
  If (i < 1)or(i > max_Planeten) then i := 1;
  result.P[2] := i;

  result.Mond := False;
end;

procedure TFRM_Uebersicht.Refresh_lb_ranges;
var i: integer;
begin
  lb_ranges.Clear;

  if Selected <> nil then
    for i := 0 to Selected.Count-1 do
      lb_ranges.Items.Add(Selected[i].GetAsString);

  PB_Uni.Refresh;
end;

procedure TFRM_Uebersicht.delete1Click(Sender: TObject);
begin
  if lb_ranges.ItemIndex >= 0 then
    DeleteItem(lb_ranges.ItemIndex);
end;

procedure TFRM_Uebersicht.lb_rangesClick(Sender: TObject);
begin
  PB_Uni.Refresh;
end;

procedure TFRM_Uebersicht.SetSelected(sel: TPlanetRangeList);
begin
  Selected := sel;
  if Selected = nil then
    cb_filter.Checked := False;

  Refresh_lb_ranges;
end;

procedure TFRM_Uebersicht.new1Click(Sender: TObject);
var s: string;
    rl: TCoordinatesRangeList;
begin
  s := '1:1-499:1-15';
  if InputQuery('Add new Area','Bereichsdefinition:', s) then
  begin
    rl := TCoordinatesRangeList.Create;
    rl.ReadFromString(s);
    RangeListIntersection(rl,OGameRangeList);
    Selected.AddPlanetRange(rl);
    Refresh_lb_ranges;
  end;
end;

procedure TFRM_Uebersicht.editr1Click(Sender: TObject);
var s: string;
    rl: TCoordinatesRangeList;
begin
  if lb_ranges.ItemIndex < 0 then Exit;
  
  rl := Selected.PlanetRange[lb_ranges.ItemIndex];
  s := rl.GetAsString;
  if InputQuery('Edit Area','Bereichsdefinition:', s) then
  begin
    rl.ReadFromString(s);
    RangeListIntersection(rl,OGameRangeList);
    PB_Uni.Repaint;
  end;
end;

end.
