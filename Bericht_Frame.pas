unit Bericht_Frame;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, OGame_Types, Prog_Unit, Menus, StdCtrls, Buttons, RaidBoard, Clipbrd,
  IniFiles, DateUtils, TIReadPlugin, UniTree, html;

type
  TFrame_Bericht = class(TFrame)
    PopupMenu1: TPopupMenu;
    Copy1: TMenuItem;
    N1: TMenuItem;
    KopiereinTabellenform1: TMenuItem;
    N2: TMenuItem;
    Ansicht1: TMenuItem;
    Normal1: TMenuItem;
    Raidansicht1: TMenuItem;
    Kurzansicht1: TMenuItem;
    Panel1: TPanel;
    LBL_Raid_Info: TLabel;
    BTN_nextRaid: TSpeedButton;
    tim_next_fleet: TTimer;
    LBL_Raid24_Info: TLabel;
    BTN_Last24: TSpeedButton;
    ZeigeProduktion1: TMenuItem;
    Leerstellenweglassen1: TMenuItem;
    BerechneRohstoffe1: TMenuItem;
    Timer2: TTimer;
    ZeigeSpeicherkapazitt1: TMenuItem;
    PB_B: TPaintBox;
    procedure PB_BPaint(Sender: TObject);
    procedure Copy1Click(Sender: TObject);
    procedure KopiereinTabellenform1Click(Sender: TObject);
    procedure Normal1Click(Sender: TObject);
    procedure FrameMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure tim_next_fleetTimer(Sender: TObject);
    procedure ScrollBoxResize(Sender: TObject);
    procedure BTN_Last24Click(Sender: TObject);
    procedure BTN_nextRaidClick(Sender: TObject);
    procedure ZeigeProduktion1Click(Sender: TObject);
    procedure Leerstellenweglassen1Click(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure BerechneRohstoffe1Click(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure ZeigeSpeicherkapazitt1Click(Sender: TObject);
  private
    FStyle: Integer;
    Raid: TFleetEvent;
    f_HideEmptySpace: Boolean;
    tst_rep: TScanBericht;
    Bericht_orig: TScanBericht;
    Bericht_calc: TScanBericht;
    player_info: TPlayerInformation;
    f_calc_resources: Boolean;
    f_use_player_info: Boolean;
    dt_forschungsdate: TDateTime;
    fshowplanetinfo: Boolean;
    fplanetInfo: TSystemPlanet;
    function Time_To_AgeStr(time: TDateTime): string;
    function getEnergyField: THTMLElement;
    procedure _DrawXMLText(tag: THTMLElement; left, top: integer);
    procedure _DrawXMLGroup(xml_root: THTMLElement; left: integer; var top: integer;
      width: integer);
    procedure DrawNormalStyle;
    procedure _DrawItem_(Left,Top,Right: integer; scan: TScanBericht;
      grp: TScanGroup; item: integer; text_color: TColor);
    procedure _DrawLine_(Left,Top,Right: integer; s1, s2: string);
    procedure _DrawPart_(Left,Right: integer; var line: integer;
      Zeile,ya: integer; Part: TScanGroup; textfarbe: TColor);
    procedure DrawRaidStyle;
    procedure SetStyle(Sty: Integer);
    procedure DrawShortStyle;
    function GetShowProduction: Boolean;
    procedure SetShowProduction(const B: Boolean);
    procedure calcMineProductionAndEnergy;
    procedure _DrawNormal_Group(sg: TScangroup;
      header, show_zero_items: boolean; cols: integer; var y: integer; rowheight: integer;
      ya: integer; scan: TScanBericht; text_color: TColor);
    procedure SetBericht(aBericht: TScanBericht);
    function GetBericht: TScanBericht;
    procedure Set_calc_resources(ab: Boolean);
    procedure ResetValues;
    procedure SetShowStorage(const B: Boolean);
    function GetShowStorage: Boolean;
    function countShips(scan: TScanbericht): Integer;
    procedure DrawPlanetInfo;
    procedure calc_loot;
    procedure LastActivity_Out(var x: integer; y: integer);
    procedure _DrawProduktion_(var line: integer; Zeile, ya: integer);
    { Private-Deklarationen }
  public
    plugin: TLangPlugIn;
    DontShowRaids: Boolean;
    mineprod_h: array[TRessType] of Integer;
    energy_consumption: Integer;
    produktionsfaktor: single;
    solsatenergy: integer;
    planettemp: single;
    planettemp_str: string;
    //Beute durch Raids, die in der History verzeichnet sind
    loot_since_scan: array[TRessType] of Integer;

    speedfactor: single;
    cl_bg_color, cl_text_color, cl_header_color,
    cl_calc_ress_color, cl_disabled_text_color,
    cl_not_available_text_color: TColor;
    property show_storage: Boolean read GetShowStorage write SetShowStorage;
    property calc_resources: Boolean read f_calc_resources write Set_calc_resources;
    property Bericht: TScanBericht read GetBericht write SetBericht;
    property Style: integer read FStyle write SetStyle;
    property ShowProduction: Boolean read GetShowProduction Write SetShowProduction;
    procedure ShowPlanetInfo(Pos: TPlanetPosition; info: TSystemPlanet);
    procedure Report_Refresh;
    constructor Create(AOwner: TComponent); override;
    procedure SaveOptions(ini: TIniFile);
    procedure LoadOptions(ini: TIniFile);
    procedure Clear;
    procedure Add_PlayerInfo(const info: TPlayerInformation);
    { Public-Deklarationen }
  end;

implementation

uses Main, Languages, KB_List, cS_DB, Math;

{$R *.DFM}

procedure TFrame_Bericht.Report_Refresh;
var i: integer;
    alter_h: single;
    m: TRessType;
begin
  if ODataBase <> nil then
  begin
    speedfactor := ODataBase.SpeedFactor;
  end
  else
  begin
    speedfactor := 1;
  end;

  //copy original
  Bericht_calc := NewScanBericht(Bericht_orig);

  calcMineProductionAndEnergy;

  //calculate production:
  if calc_resources then
  begin
    alter_h := (ODataBase.FleetBoard.GameTime.UnixTime - (Bericht.Head.time_u)) / 60 / 60;

    for m := rtMetal to rtDeuterium do
    begin
      Bericht_calc.Bericht[sg_Rohstoffe][sb_Ress_array[m]] :=
        CalcScanRess_Now(Bericht_orig, m, alter_h, mineprod_h[m]);
    end;
  end;

  //Set Forschung:
  if f_use_player_info then
  begin
    for i := 0 to ScanFileCounts[sg_Forschung]-1 do
    begin
      Bericht_calc.Bericht[sg_Forschung][i] := player_info.Research[i];
    end;
    dt_forschungsdate := UnixToDateTime(player_info.ResearchTime_u);
  end;

  Refresh;
end;

procedure TFrame_Bericht.PB_BPaint(Sender: TObject);
begin
  //Minenproduktion aktualisieren:
  //calcMineProduktion;

  if not ValidPosition(Bericht.Head.Position) then Exit;

  if fshowplanetinfo then
    DrawPlanetInfo
  else
  begin
    case FStyle of
      0: DrawNormalStyle;
      1: DrawRaidStyle;
      2: DrawShortStyle;
    end;
  end;
end;

procedure TFrame_Bericht.Copy1Click(Sender: TObject);
var S: string;
begin
  s := PlugIn.ScanToStr(Bericht,False);
  if FRM_Main <> nil then
    FRM_Main.LastClipBoard := s;
  Clipboard.AsText := s;
end;

procedure TFrame_Bericht.KopiereinTabellenform1Click(Sender: TObject);
var s: string;
begin
  s := PlugIn.ScanToStr(Bericht,True);
  if FRM_Main <> nil then
    FRM_Main.LastClipBoard := s;
  Clipboard.AsText := s;
end;

procedure TFrame_Bericht.Normal1Click(Sender: TObject);
begin
  with Sender as TMenuItem do
  begin
    Style := Tag;
    Report_Refresh;
    Checked := true;
  end;
end;

procedure TFrame_Bericht.DrawNormalStyle;
const
  Zeile = 15;
var s : string;
    ye,m,d : Word;
    x, y, xa, ya, atop : integer;
    sg: TScanGroup;
    xml: THTMLElement;
    xml_root: THTMLElement;
    a_color: TColor;
    energy_consumption, sheight: integer;
begin
 with PB_B.Canvas do
 begin
   Font.Size := 8;
   Font.Color := clWhite;
   Brush.Style := bsSolid;
   Brush.Color := clblack;
   Pen.Color := clBlack;
   Rectangle(ClipRect);

   Brush.Color := clBlue;
   Rectangle(0,0,PB_B.Width,Zeile*2);
   DecodeDate(UnixToDateTime(Bericht.Head.Time_u),ye,m,d);
   s := {STR_Z0 + }Bericht.Head.Planet + ' [' + PositionToStrMond(Bericht.Head.Position) + '] ' +
        Bericht.Head.Spieler;
   if ODataBase <> nil then
     s := s + ' (' + ODataBase.GetPlayerStatusAtPos(Bericht.Head.Position) + ') ';
   s := s + STR_Z1 + inttostr(m) + '-' + IntToStr(d) + ' ' + TimeToStr(UnixToDateTime(Bericht.Head.Time_u));

   ya := (Zeile - TextHeight(s))div 2;
   xa := 5;
   TextOut(xa,ya+Zeile,s);
   s := STR_Scanner + ' ' + Bericht.Head.Creator + ' ' + STR_Spionageabwehr_kurz + inttostr(Bericht.Head.Spionageabwehr) + '%';
   TextOut(xa,ya,s);
   x := xa + TextWidth(s) + xa;

   //Letzte Aktivität:
   LastActivity_Out(x,ya);
   //Scanalter:
   x := x + xa;
   s := ' ' + STR_Alter + Time_To_AgeStr(UnixToDateTime(Bericht.Head.Time_u)) + ' ';
   if ODataBase <> nil then
     Font.Color := AlterToColor_dt(now - UnixToDateTime(Bericht.Head.Time_u), ODataBase.redHours[rh_Scans])
   else
     Font.Color := clWhite;
   TextOut(x,ya,s);


   Font.Color := clWhite;
   y := 1;
   x := 0;
   for sg := low(sg) to high(sg) do
   if (length(Bericht.Bericht[sg]) > 0)and(Bericht.Bericht[sg][0] <> -1) then
   begin
     x := 0;
     if sg <> sg_Rohstoffe then
       _DrawNormal_Group(sg, not(sg = sg_Rohstoffe),
            (sg = sg_Rohstoffe)or(not f_HideEmptySpace), 2, y, Zeile, ya,
            Bericht, cl_text_color)
     else
     begin
       {if calc_resources then
         _DrawNormal_Group(sg, not(sg = sg_Rohstoffe),
            (sg = sg_Rohstoffe)or(not f_HideEmptySpace), 2, y, Zeile, ya,
            Bericht, cl_calc_ress_color)
       else
         _DrawNormal_Group(sg, not(sg = sg_Rohstoffe),
            (sg = sg_Rohstoffe)or(not f_HideEmptySpace), 2, y, Zeile, ya,
            Bericht, cl_text_color)}

       if calc_resources then
         a_color := cl_calc_ress_color
       else
         a_color := cl_text_color;

       xml_root := THTMLElement.Create(nil, 'root');
       xml_root.AttributeValue['colcount'] := '2';
       xml_root.AttributeValue['text_dist_x'] := IntToStr(xa);

       {xml := THTMLElement.Create(xml_root, 'header');
       xml.Content := plugIn.SBItems[sg_Rohstoffe][0];}
       xml := THTMLElement.Create(xml_root, 'item');
       xml.AttributeValue['left'] := plugin.SBItems[sg_Rohstoffe][sb_Metall+1];
       xml.AttributeValue['right'] := IntToStrKP(Bericht.Bericht[sg_Rohstoffe][sb_Metall]);
       xml.AttributeValue['color'] := IntToStr(a_color);
       xml := THTMLElement.Create(xml_root, 'item');
       xml.AttributeValue['left'] := plugIn.SBItems[sg_Rohstoffe][sb_Kristall+1];
       xml.AttributeValue['right'] := IntToStrKP(Bericht.Bericht[sg_Rohstoffe][sb_Kristall]);
       xml.AttributeValue['color'] := IntToStr(a_color);
       xml := THTMLElement.Create(xml_root, 'item');
       xml.AttributeValue['left'] := plugIn.SBItems[sg_Rohstoffe][sb_Deuterium+1];
       xml.AttributeValue['right'] := IntToStrKP(Bericht.Bericht[sg_Rohstoffe][sb_Deuterium]);
       xml.AttributeValue['color'] := IntToStr(a_color);

       xml := getEnergyField();
       xml_root.AddChildElement(xml);


       inc(y);
       atop := y*Zeile;
       _DrawXMLGroup(xml_root,0,atop,PB_B.Width-ya);
       y := ceil(atop / Zeile);

       xml_root.Free;
     end;
   end;

   _DrawProduktion_(y,Zeile,ya);
//   inc(y);

   //Am Ende: Höhe von PB_B anpassen:

   sheight := y*Zeile + Zeile;
   if PB_B.Height <> sheight then
     PB_B.Height := sheight;
 end;
end;

procedure TFrame_Bericht._DrawPart_(Left,Right: integer; var line: integer;
  Zeile,ya: integer; Part: TScanGroup; textfarbe: TColor);
var i: integer;
    s: string;
begin
  with PB_B.Canvas do
  begin
   Brush.Color := cl_header_color;
   Font.Color := textfarbe;
   Rectangle(Left,(line*Zeile),Right,(line*Zeile)+Zeile);
   s := PlugIn.SBItems[Part][0];
   if (Part = sg_Flotten)and(Bericht.Bericht[part][0] >= 0) then
     s := s + ' (' + IntToStr(countShips(Bericht)) + ')';
   TextOut(Left+5,(line*Zeile)+ya, s);
   inc(line);
   Brush.Color := cl_bg_color;
   for i := 0 to ScanFileCounts[part]-1 do
   begin
     //Setze farbe
     if Bericht.Bericht[Part][i] = 0 then
       Font.Color := cl_disabled_text_color
     else
     if Bericht.Bericht[Part][i] < 0 then
       Font.Color := cl_not_available_text_color
     else
       Font.Color := textfarbe;

     if Bericht.Bericht[Part][i] >= 0 then
       s := FloatToStrF(Bericht.Bericht[Part][i],ffNumber,60000000,0)
     else s := STR_Not_Awailable;

       
     _DrawLine_(Left+5,(line*Zeile)+ya,Right-5,PlugIn.SBItems[Part][i+1],s);
     inc(line);
   end;
  end;
end;

procedure TFrame_Bericht._DrawItem_(Left,Top,Right: integer; scan: TScanBericht;
  grp: TScanGroup; item: integer; text_color: TColor);
var s: string;
begin
  if scan.Bericht[grp][item] = 0 then
    PB_B.Canvas.Font.Color := cl_disabled_text_color
  else
  if scan.Bericht[grp][item] < 0 then
    PB_B.Canvas.Font.Color := cl_not_available_text_color
  else
    PB_B.Canvas.Font.Color := text_color;

  if scan.Bericht[grp][item] >= 0 then
    s := FloatToStrF(scan.Bericht[grp][item],ffNumber,60000000,0)
  else
    s := STR_Not_Awailable;

  _DrawLine_(Left,Top,Right,plugin.SBItems[grp][item+1], s);
end;

procedure TFrame_Bericht._DrawLine_(Left,Top,Right: integer; s1, s2: string);
begin
  with PB_B.Canvas do
  begin
    //schreibe name, kürze vorher auf maximale länge:
    while (TextWidth(s1) > Right - Left) do
      SetLength(s1,length(s1)-1);

    TextOut(left,top,s1);
    //Schreibe Anzahl:
    s2 := '  ' + s2;
    TextOut(Right - TextWidth(s2),top,s2);
  end;
end;



procedure TFrame_Bericht.DrawRaidStyle;
const
  Zeile = 15;
var alter_d: TDateTime;
    s: string;
    ya, xthird, line: integer;
    pos: TPlanetPosition;
var bint: Int64;
    TF: TResources;
    j,x: integer;
    max_line: integer;
    xml_ress: THTMLElement;
    atop: integer;

   function getRaidRessources_xml(): THTMLElement;
   var xml_root, xml: THTMLElement;
   begin
     xml_root := THTMLElement.Create(nil, 'root');
     xml_root.AttributeValue['colcount'] := '1';
     xml_root.AttributeValue['text_dist_x'] := IntToStr(5);

     // Header
     xml := THTMLElement.Create(xml_root, 'header');
     xml.Content := plugIn.SBItems[sg_Rohstoffe][0];
     xml.AttributeValue['bgcolor'] := IntToStr(clBlue);

     if calc_resources then  // Berechnete Rohstoffe:
     begin
       xml := THTMLElement.Create(xml_root, 'item');
       xml.AttributeValue['left'] := plugIn.SBItems[sg_Rohstoffe][sb_Metall+1];
       xml.AttributeValue['right'] := IntToStrKP(Bericht_calc.Bericht[sg_Rohstoffe][sb_Metall]);
       xml.AttributeValue['color'] := IntToStr(cl_calc_ress_color);
       xml := THTMLElement.Create(xml_root, 'item');
       xml.AttributeValue['left'] := plugin.SBItems[sg_Rohstoffe][sb_Kristall+1];
       xml.AttributeValue['right'] := IntToStrKP(Bericht_calc.Bericht[sg_Rohstoffe][sb_Kristall]);
       xml.AttributeValue['color'] := IntToStr(cl_calc_ress_color);
       xml := THTMLElement.Create(xml_root, 'item');
       xml.AttributeValue['left'] := plugin.SBItems[sg_Rohstoffe][sb_Deuterium+1];
       xml.AttributeValue['right'] := IntToStrKP(Bericht_calc.Bericht[sg_Rohstoffe][sb_Deuterium]);
       xml.AttributeValue['color'] := IntToStr(cl_calc_ress_color);
     end;
     // Normale Rohstoffe:

     xml := THTMLElement.Create(xml_root, 'item');
     xml.AttributeValue['left'] := plugin.SBItems[sg_Rohstoffe][sb_Metall+1];
     xml.AttributeValue['right'] := IntToStrKP(Bericht_orig.Bericht[sg_Rohstoffe][sb_Metall]);
     xml.AttributeValue['color'] := IntToStr(cl_text_color);
     xml := THTMLElement.Create(xml_root, 'item');
     xml.AttributeValue['left'] := plugin.SBItems[sg_Rohstoffe][sb_Kristall+1];
     xml.AttributeValue['right'] := IntToStrKP(Bericht_orig.Bericht[sg_Rohstoffe][sb_Kristall]);
     xml.AttributeValue['color'] := IntToStr(cl_text_color);
     xml := THTMLElement.Create(xml_root, 'item');
     xml.AttributeValue['left'] := plugin.SBItems[sg_Rohstoffe][sb_Deuterium+1];
     xml.AttributeValue['right'] := IntToStrKP(Bericht_orig.Bericht[sg_Rohstoffe][sb_Deuterium]);
     xml.AttributeValue['color'] := IntToStr(cl_text_color);

     // Energie
     xml := getEnergyField();
     xml_root.AddChildElement(xml);

     Result := xml_root;
   end;

begin
  max_line := 0;
  if ValidPosition(Bericht.Head.Position) then
  with PB_B.Canvas do
  begin
    Font.Size := 8;
    Font.Color := cl_text_color;
    Brush.Color := clblack;
    Pen.Color := clblack;
    Rectangle(ClipRect);
    Brush.Color := clBlue;
    Rectangle(0,0,PB_B.Width,Zeile);
    xthird := PB_B.Width div 3;
    ya := (Zeile - TextHeight('TEST'))div 2;

    //Letzte Aktivität:
    x := 0;
    LastActivity_Out(x,ya);
    Font.Color := cl_text_color;
    Brush.Color := clBlue;

    //Header:
    pos := Bericht.Head.Position;
    alter_d := (ODataBase.FleetBoard.GameTime.UnixTime - Bericht.Head.Time_u){sekunden}
             / 60 / 60 / 24 {tage};

    s := IntToStr(Bericht.Head.Spionageabwehr) + '% ';
    s := s + '"' + Bericht.Head.Planet + '" ['
       + PositionToStrMond(pos) + '] '+
         Bericht.Head.Spieler;
    if ODataBase <> nil then
    begin
      s := s + ' (' + ODataBase.GetPlayerStatusAtPos(pos) + ')';
    end;

    //Ally:
    if (ODataBase.Uni[pos.P[0],pos.P[1]].SystemCopy >= 0) then
    begin
      if (ODataBase.Systeme[ODataBase.Uni[pos.P[0],pos.P[1]].SystemCopy].Planeten[pos.P[2]].Ally <> '') then
        s := s + ' ['+ ODataBase.Systeme[ODataBase.Uni[pos.P[0],pos.P[1]].SystemCopy].Planeten[pos.P[2]].Ally +'] ';
    end;

    s := s + ' ' + STR_Scanner + ' ' + Bericht.Head.Creator + ' ';
    TextOut(x+5,ya,s);


    //Alter:
    {if alter_d < 1 then
      s := TimeToStr(alter_d)
    else s := inttostr(trunc(alter_d)) + STR_Tage + TimeToStr(alter_d);}
    s := Time_To_AgeStr(UnixToDateTime(Bericht.Head.Time_u)); 
    Line := 1;
    Brush.Color := clblack;
    Font.Color := AlterToColor_dt(alter_d,ODataBase.redHours[rh_Scans]);
    s := STR_Alter + s;
    TextOut(5,(line*Zeile)+ya,s);

    //TF
    if (ODataBase <> nil) then
    begin
      x := 5+TextWidth(s)+5;
      Font.Color := cl_text_color;
      try
        TF := CalcTF(Bericht,ODataBase.DefInTF);
        bint := (TF[0] + TF[1]);
        if bint > 0 then
        begin
          j := trunc(bint/20000)+1;
          s := Format(STR_Truemmerfeld_frmt,[(TF[0])/1,TF[1]/1,j/1]);
          TextOut(x,(line*Zeile)+ya,s);
        end;
      except
        s := '[TF: ERR -> to big]';
        TextOut(x,(line*Zeile)+ya,s);
      end;
    end;
    inc(line);

    //Rohstoffe:
    {Font.Color := clWhite;
    Brush.Color := clBlue;
    Rectangle(0,(line*Zeile),xthird,(line*Zeile)+Zeile);
    s := PlugIn.SBItems[sg_Rohstoffe][0];
    TextOut(5,(line*Zeile)+ya,s);
    inc(line);

    Brush.Color := clBlack;
    if calc_resources then
    begin
      _DrawItem_(5,(line*Zeile)+ya,xthird,Bericht_calc,sg_Rohstoffe,sb_Metall,cl_calc_ress_color);
      inc(line);
      _DrawItem_(5,(line*Zeile)+ya,xthird,Bericht_calc,sg_Rohstoffe,sb_Kristall,cl_calc_ress_color);
      inc(line);
      _DrawItem_(5,(line*Zeile)+ya,xthird,Bericht_calc,sg_Rohstoffe,sb_Deuterium,cl_calc_ress_color);
      inc(line);
    end;
    _DrawItem_(5,(line*Zeile)+ya,xthird,Bericht_orig,sg_Rohstoffe,sb_Metall,cl_text_color);
    inc(line);
    _DrawItem_(5,(line*Zeile)+ya,xthird,Bericht_orig,sg_Rohstoffe,sb_Kristall,cl_text_color);
    inc(line);
    _DrawItem_(5,(line*Zeile)+ya,xthird,Bericht_orig,sg_Rohstoffe,sb_Deuterium,cl_text_color);
    inc(line);
    _DrawItem_(5,(line*Zeile)+ya,xthird,Bericht,sg_Rohstoffe,sb_Energie,cl_text_color);
    inc(line); }


{    if calc_resources then
      _DrawPart_(0, xthird,line,Zeile,ya, sg_Rohstoffe, cl_calc_ress_color)
    else _DrawPart_(0, xthird,line,Zeile,ya, sg_Rohstoffe, cl_text_color);}

    // Neu: XML (bis jetzt nur ressourcen)
    atop := (line*Zeile);
    xml_ress := getRaidRessources_xml();
    _DrawXMLGroup(xml_ress,0,atop,xthird);
    line := ceil(atop / Zeile);


    _DrawPart_(0, xthird,line,Zeile,ya, sg_Verteidigung, cl_text_color);

    if line > max_line then max_line := line;
    Line := 2;

    //Flotten:
    _DrawPart_(xthird,2*xthird,line,Zeile,ya,sg_Flotten, cl_text_color);


    //Forschungen (Klein)
    Brush.Color := clBlue;
    Rectangle(xthird,(line*Zeile),xthird*2,(line*Zeile)+Zeile);
    if f_use_player_info then
      Font.Color := AlterToColor_dt(now - dt_forschungsdate,
                                    ODataBase.redHours[rh_systems])
    else Font.Color := clWhite;

    s := PlugIn.SBItems[sg_Forschung][0];
    if f_use_player_info then
      s := s + ' (' +PositionToStrMond(player_info.ResearchPlanet)+ ')';
    TextOut(xthird+5,(line*Zeile)+ya,s);
    inc(line);
    Font.Color := clWhite;
    Brush.Color := clBlack;
    _DrawItem_(xthird+5,(line*Zeile)+ya, 2*xthird-5, Bericht, sg_Forschung, sb_Waffentechnik, clWhite);
    inc(line);
    _DrawItem_(xthird+5,(line*Zeile)+ya, 2*xthird-5, Bericht, sg_Forschung, sb_Schildtechnik, clWhite);
    inc(line);
    _DrawItem_(xthird+5,(line*Zeile)+ya, 2*xthird-5, Bericht, sg_Forschung, sb_Raumschiffpanzerung, clWhite);
    inc(line);
    Brush.Color := clBlack;

    if line > max_line then max_line := line;
    Line := 2;

    //Gebäude:
    _DrawPart_(2*xthird,3*xthird,line,Zeile,ya,sg_Gebaeude, cl_text_color);
    x := 0;

    line := max_line;
    _DrawNormal_Group(sg_Forschung,true,true,3,line,Zeile,ya,Bericht,clWhite);

    inc(line);
    _DrawProduktion_(line,Zeile,ya);

    PB_B.Height := line*Zeile;
  end;
end;

procedure TFrame_Bericht.SetStyle(Sty: Integer);
begin
  FStyle := Sty;
  PB_B.Refresh;
  case sty of
    0: Normal1.Checked := true;
    1: Raidansicht1.Checked := true;
    2: Kurzansicht1.Checked := True;
  end;
end;

procedure TFrame_Bericht.DrawShortStyle;
const
  Zeile = 15;
var ya: integer;
    pos: TPlanetPosition;
    s: string;
    alter_d: TDateTime;
    line,j,x: integer;
    xteil: integer;
    maxx: integer;
    sg: TScanGroup;
procedure DrawLine(Left,Right,i: integer; Part: TScanGroup);
var txtRect: TRect;
    c: Tcolor;
begin
  with PB_B.Canvas do
  begin
    s := PlugIn.SBItems[Part][i+1];
    {if length(s) > 12 then
      SetLength(s,12); }
    txtRect.Left := left+5;
    txtRect.Top := (line*Zeile)+ya;
    txtRect.Right := Right-5;
    txtRect.Bottom := txtRect.Top + Zeile;
    c := Brush.Color;
    Brush.Style := bsclear;
    TextRect(txtRect,txtRect.Left,txtRect.Top,s);
    Brush.Style := bsSolid;
    Brush.Color := c;

    if Bericht.Bericht[Part][i] >= 0 then
      s := FloatToStrF(Bericht.Bericht[Part][i],ffNumber,60000000,0)
    else s := STR_Not_Awailable;
    s := '  ' + s;
    TextOut(Right - TextWidth(s)-5,(line*Zeile)+ya,s);
    Brush.Color := cl_bg_color;
    inc(line);
  end;
end;
begin
  with PB_B.Canvas do
  begin
    if Panel1.Visible then
      maxx := (ClientHeight-Panel1.Height) div Zeile
    else maxx := ClientHeight div Zeile;

    Font.Size := 8;
    Font.Color := cl_text_color;
    Brush.Color := cl_bg_color;
    Pen.Color := cl_bg_color;
    Rectangle(ClipRect);
    Brush.Color := cl_header_color;
    Rectangle(0,0,PB_B.Width,Zeile);
  end;
  if ValidPosition(Bericht.Head.Position) then
  with PB_B.Canvas do
  begin
    pos := Bericht.Head.Position;
    alter_d := (ODataBase.FleetBoard.GameTime.UnixTime - Bericht.Head.Time_u) /60/60/24;
    s := '[' + PositionToStrMond(Pos) + '] ' + STR_Alter;
    if alter_d < 1 then
      s := s + TimeToStr(alter_d)
    else s := s + inttostr(trunc(alter_d)) + STR_Tage + TimeToStr(alter_d);
    s := s + STR_Spionageabwehr_kurz + IntToStr(Bericht.Head.Spionageabwehr) + '%';
    ya := (Zeile - TextHeight(s))div 2;
    TextOut(5,ya,s);
    line := 1;
    //xteil := PB_B.Width div 4;
    xteil := 120;
    Brush.Color := cl_bg_color;
    x := 0;
    for sg := low(sg) to high(sg) do
    begin
      Brush.Color := cl_header_color;
      if (sg = sg_Rohstoffe)and(calc_resources) then
        Font.Color := cl_calc_ress_color
      else Font.Color := cl_text_color;

      Rectangle(x,line*Zeile,x+xteil,line*zeile+zeile);
      for j := 0 to ScanFileCounts[sg]-1 do
      begin
        if Bericht.Bericht[sg][j] > 0 then
          DrawLine(x,x+xteil,j,sg);
        if Bericht.Bericht[sg][j] = -1 then
        begin
          DrawLine(x,x+xteil,j,sg);
          break;
        end;
        if Line >= maxx then
        begin
          line := 1;
          x := x + xteil;
        end;
      end;
      line := 1;
      x := x + xteil;
    end;
    inc(line);
    PB_B.Height := maxx * Zeile;
  end;
end;

procedure TFrame_Bericht.FrameMouseWheel(Sender: TObject;
  Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
  var Handled: Boolean);
begin
  VertScrollBar.Position := VertScrollBar.Position - (WheelDelta div 2);
end;

procedure TFrame_Bericht.tim_next_fleetTimer(Sender: TObject);
var RC24: Integer;
    i: integer;
begin
  if DontShowRaids or (ODataBase = nil) then Exit;

  i := ODataBase.FleetBoard.FindNextArrivingFleet(Bericht.Head.Position, fet_attack);

  if i < 0 then
    Raid.head.arrival_time_u := -1
  else
    Raid := ODataBase.FleetBoard.Fleets[i];

  RC24 := ODataBase.FleetBoard.GetLast24HoursRaidCount(Bericht.Head.Position);
  Panel1.Visible := (RC24 > 0)or(i >= 0);
  if Panel1.Visible then
  begin
    BTN_nextRaid.Visible := i >= 0;
    BTN_Last24.Visible := RC24 > 0;
    if not (raid.head.arrival_time_u = -1) then
      LBL_Raid_Info.Caption := STR_NextRaid +
         CountdownTimeToStr((raid.head.arrival_time_u - ODataBase.FleetBoard.GameTime.UnixTime)/60/60/24)
         + STR_ByPlayer + Raid.head.player
    else LBL_Raid_Info.Caption := '';
    if RC24 > 0 then LBL_Raid24_Info.Caption := STR_Last24Hours + IntToStr(RC24)
    else begin
      BTN_Last24.Visible := False;
      LBL_Raid24_Info.Caption := '';
    end;
  end;
end;

procedure TFrame_Bericht.ScrollBoxResize(Sender: TObject);
begin
  Refresh;
end;

procedure TFrame_Bericht.BTN_Last24Click(Sender: TObject);
begin
  FRM_KB_List.ShowHistoryRaid(Bericht.Head.Position);
end;

constructor TFrame_Bericht.Create(AOwner: TComponent);
begin
  inherited;
  fshowplanetinfo := False;
  DontShowRaids := False;
  ShowProduction := True;
  F_HideEmptySpace := True;
  if ODataBase <> nil then
  begin
    Plugin := ODataBase.LanguagePlugIn;
  end;

  cl_bg_color := clBlack;
  cl_text_color := clWhite;
  cl_disabled_text_color := RGB(50,50,50);
  cl_not_available_text_color := RGB(150,40,40);
  cl_header_color := clBlue;
  cl_calc_ress_color := clYellow;
  f_calc_resources := BerechneRohstoffe1.Checked;

  Panel1.DoubleBuffered := true;
  DoubleBuffered := true;
  Clear;

  BTN_Last24.Left := ClientWidth - BTN_Last24.Width;
  LBL_Raid24_Info.Left := ClientWidth - BTN_Last24.Width - LBL_Raid24_Info.Width;
end;

procedure TFrame_Bericht.BTN_nextRaidClick(Sender: TObject);
begin
  FRM_KB_List.ShowRaid(Bericht.Head.Position);
end;

procedure TFrame_Bericht.ZeigeProduktion1Click(Sender: TObject);
begin
  ShowProduction := not ShowProduction; //Property regelt rest alleine!
end;

procedure TFrame_Bericht.SaveOptions(ini: TIniFile);
begin
  ini.WriteInteger(Self.Name,'Style',Style);
  ini.WriteBool(Self.Name,'ShProd',ShowProduction);
  ini.WriteBool(Self.Name,'HideEmptySpace', F_HideEmptySpace);
  ini.WriteBool(Self.Name,'calc_resources', calc_resources);
  ini.WriteBool(Self.Name,'show_storrage', show_storage);
end;

procedure TFrame_Bericht.LoadOptions(ini: TIniFile);
begin
  Style := ini.ReadInteger(Self.Name,'Style',Style);    //Syle ist Property! Setzt sich also selber!
  ShowProduction := ini.ReadBool(Self.Name,'ShProd',ShowProduction);  //ShowProduction ist Property! Setzt sich also selber!
  F_HideEmptySpace := ini.ReadBool(Self.Name,'HideEmptySpace',True);
  Leerstellenweglassen1.Checked := F_HideEmptySpace;
  calc_resources := ini.ReadBool(Self.Name,'calc_resources',calc_resources); //property!
  show_storage := ini.ReadBool(Self.Name,'show_storrage',show_storage); //property
end;

function TFrame_Bericht.GetShowProduction: Boolean;
begin
  Result := ZeigeProduktion1.Checked;
end;

procedure TFrame_Bericht.SetShowProduction(const B: Boolean);
begin
  if ZeigeProduktion1.Checked <> B then
  begin
    ZeigeProduktion1.Checked := B;
    PB_B.Refresh;
  end;
end;

procedure TFrame_Bericht.Leerstellenweglassen1Click(Sender: TObject);
begin
  F_HideEmptySpace := not F_HideEmptySpace;
end;

procedure TFrame_Bericht.PopupMenu1Popup(Sender: TObject);
begin
  Leerstellenweglassen1.Checked := not F_HideEmptySpace;
end;

procedure TFrame_Bericht.calcMineProductionAndEnergy;
var m: TRessType;
begin
  solsatenergy := calcSolSatEnergy(Bericht);
  if solsatenergy <> -1 then
  begin
    planettemp := calcPlanetTemp(solsatenergy);
    planettemp_str := '~ ' + FloatToStr(planettemp) + ' °C';
  end
  else
  begin
    planettemp := -99999;
    planettemp_str := 'n/a';
  end;

  produktionsfaktor := calcProduktionsFaktor(Bericht, energy_consumption);
  if Length(Bericht.Bericht[sg_Gebaeude]) > 0 then
  for m := low(m) to high(m) do
  begin
    mineprod_h[m] := trunc(
                         GetMineProduction_(Bericht, speedfactor, m, produktionsfaktor)
                         );
  end;
end;

procedure TFrame_Bericht._DrawNormal_Group(sg: TScangroup;
  header, show_zero_items: boolean; cols: integer; var y: integer; rowheight: integer;
  ya: integer; scan: TScanBericht; text_color: TColor);
var s: string;
    TF: TResources;
    bint: Int64;
    j, colwidth, x: Integer;
begin
  //Header:
  with PB_B.Canvas do
  begin
    x := 0;
    colwidth := PB_B.Width div cols;

    if header then
    begin
      s := PlugIn.SBItems[sg][0];

      //Trümmerfeld:
      if (sg = sg_Flotten)and(ODataBase <> nil) then
      begin
       s := s + ' (' + IntToStr(countShips(scan)) + ')';
       try
         TF := CalcTF(scan,ODataBase.DefInTF);
         bint := (TF[0] + TF[1]);
         if bint > 0 then
         begin
           j := trunc(bint/20000)+1;
           s := s + Format(STR_Truemmerfeld_frmt,[(TF[0])/1,TF[1]/1,j/1]);
         end;
       except
         s := s+' [TF: n/a -> to big]';
       end;
      end;

      //Blauer Hintergrund:
      Brush.Color := cl_header_color;
      Rectangle(0,y*rowheight,PB_B.Width,y*rowheight+rowheight);

      //Forschungsalter:
      if (f_use_player_info)and(sg = sg_Forschung) then
      begin
        Font.Color := AlterToColor_dt(now - dt_forschungsdate, ODataBase.redHours[rh_systems]);
        s := s + ' (' + PositionToStrMond(player_info.ResearchPlanet)+ ') '
               + DateTimeToStr(dt_forschungsdate);
      end
      else Font.Color := text_color;
      TextOut(x*colwidth+5,y*rowheight+ya,s);
    end;
    inc(y);

    //Gruppen-Items:
    Brush.Color := cl_bg_color;
    Font.Color := text_color;
    for j := 0 to length(scan.Bericht[sg])-1 do
    begin
      //Nur Items anzeigen deren Anzahl <> 0! (Ausnahme: Rohstoffe)
      if (scan.Bericht[sg][j] <> 0)or(show_zero_items) then  //rohstoffe auch anzeigen wenn 0!
      begin
        {s := PlugIn.SBItems[sg][j+1];
        TextOut(x*colwidth+5,y*rowheight+ya,s);
        if scan.Bericht[sg][j] < 0 then
          s := STR_Not_Awailable
        else
          s := FloatToStrF(scan.Bericht[sg][j],ffNumber,60000000,0);
        TextOut(x*colwidth-5 + (colwidth-TextWidth(s)),y*rowheight+ya,s);  }

        _DrawItem_(x*colwidth+5,y*rowheight+ya,x*colwidth+colwidth-5,scan,
                   sg,j,text_color);
      end;

      //Neue Zeile, wenn Zeilenende erreicht:
      if (scan.Bericht[sg][j] <> 0)or(show_zero_items) then
      begin
        inc(x);
        if x >= cols then
        begin
          x := 0;
          inc(y);
        end;
      end;
    end;

    if x > 0 then  //neue zeile, wenn unfertig
      inc(y);
  end;
end;

procedure TFrame_Bericht.SetBericht(aBericht: TScanBericht);
begin
  fshowplanetinfo := false;
  ResetValues;
  Bericht_orig := aBericht;
  VertScrollBar.Position := 0;
  Report_Refresh;
  tim_next_fleetTimer(tim_next_fleet);
end;

function TFrame_Bericht.GetBericht: TScanBericht;
begin
  Result := Bericht_calc;
end;

function TFrame_Bericht.getEnergyField: THTMLElement;
var eleft, efull: string;
begin
  Result := THTMLElement.Create(nil, 'item');
  //Beschriftung:
  Result.AttributeValue['left'] := plugIn.SBItems[sg_Rohstoffe][sb_Energie+1];
  if energy_consumption < 0 then
    eleft := 'n.a.'
  else
    eleft := IntToStrKP(Bericht.Bericht[sg_Rohstoffe][sb_Energie] -
                                                       energy_consumption);

  Result.AttributeValue['right'] := eleft + ' / ' +
                      IntToStrKP(Bericht.Bericht[sg_Rohstoffe][sb_Energie]);
end;

procedure TFrame_Bericht.Clear;
begin
  ResetValues;

  Report_Refresh;
end;

procedure TFrame_Bericht.BerechneRohstoffe1Click(Sender: TObject);
begin
  BerechneRohstoffe1.Checked := not BerechneRohstoffe1.Checked;
  calc_resources := BerechneRohstoffe1.Checked;
  //property!
end;

procedure TFrame_Bericht.Timer2Timer(Sender: TObject);
begin
  if not fshowplanetinfo then
  begin
    Report_Refresh;
  end;
end;

function TFrame_Bericht.Time_To_AgeStr(time: TDateTime): string;
begin
  if ODataBase <> nil then
    Result := ODataBase.Time_To_AgeStr(time)
  else
    Result := Time_To_AgeStr_Ex(Now(), time);
end;

procedure TFrame_Bericht.Set_calc_resources(ab: Boolean);
begin
  f_calc_resources := ab;
  BerechneRohstoffe1.Checked := ab;
  Report_Refresh;
end;

procedure TFrame_Bericht.Add_PlayerInfo(const info: TPlayerInformation);
begin
  player_info := info;
  f_use_player_info := true;
end;

procedure TFrame_Bericht.ResetValues;
begin
  ClearScanBericht(Bericht_orig);
  ClearScanBericht(Bericht_calc);
  f_use_player_info := false;
  dt_forschungsdate := 0;
  Bericht_orig.Head.Position.P[0] := 0;
//  Bericht_orig.Head.Time_u := DateTimeToUnix(now());   //Damit die Berechnung von Rohstoffen nicht spinnt.
  Bericht_orig.Head.Position.Mond := true; //Mode haben keinerlei Produktion!
  Bericht_calc.Head.Position.P[0] := 0;
//  Bericht_calc.Head.Time_u := DateTimeToUnix(now());
  Bericht_calc.Head.Position.Mond := true; //Mode haben keinerlei Produktion!
end;

procedure TFrame_Bericht.ZeigeSpeicherkapazitt1Click(Sender: TObject);
begin
  show_storage := not ZeigeSpeicherkapazitt1.Checked;
end;

procedure TFrame_Bericht.SetShowStorage(const B: Boolean);
begin
  ZeigeSpeicherkapazitt1.Checked := b;
  Refresh;
end;

function TFrame_Bericht.GetShowStorage: Boolean;
begin
  Result := ZeigeSpeicherkapazitt1.Checked;
end;

function TFrame_Bericht.countShips(scan: TScanbericht): Integer;
var i: integer;
begin
  Result := 0;
  for i := 0 to length(scan.Bericht[sg_Flotten])-1 do
  begin
    Result := Result + scan.Bericht[sg_Flotten][i];
  end;
end;

procedure TFrame_Bericht.DrawPlanetInfo;
var y, dy: integer;
begin
  with PB_B do
  begin
    y := 0;
    Canvas.Font.Size := 20;
    Canvas.Font.Color := clWhite;
    Canvas.Brush.Color := clBlue;
    dy := Canvas.TextHeight('[]')+6;
    Canvas.Rectangle(0,y,Width,y+dy);
    if not Bericht.Head.Position.Mond then
      Canvas.TextOut(3,y+3,'[' + PositionToStrMond(Bericht.Head.Position) + ']'
                       + fplanetInfo.PlanetName + ' (' + fplanetInfo.Player + ')')
    else
      Canvas.TextOut(3,y+3,'[' + PositionToStrMond(Bericht.Head.Position) + ']'
                       + STR_Mond + ' (' + fplanetInfo.Player + ')');

    inc(y,dy);
    PB_B.Height := y;
  end;
end;

procedure TFrame_Bericht.ShowPlanetInfo(Pos: TPlanetPosition; info: TSystemPlanet);
begin
  fshowplanetinfo := True;
  Bericht_calc.Head.Position := Pos;
  fplanetInfo := info;
  PB_B.Refresh;
end;

procedure TFrame_Bericht.calc_loot;
var i: integer;
    m: TRessType;
    flt: TFleetEvent;
begin
  //Clear
  for m := low(m) to high(m) do
    loot_since_scan[m] := 0;

  //Search
  for i := 0 to ODataBase.FleetBoard.History.Count -1 do
  begin
    flt := ODataBase.FleetBoard.History[i];
    // Das Geht so nicht.... ICH BRAUCHE EINE STARTZEIT!!! if (flt.head.arrival_time_u 
  end;
end;

procedure TFrame_Bericht.LastActivity_Out(var x: integer; y: integer);
var s: string;
begin
  with PB_B.Canvas do
  begin
    //Letze Aktivität:
    Brush.Color := clBlack;
    if Bericht.Head.Activity > 0 then
    begin
      s := ' l.a. ' + IntToStr(Bericht.Head.Activity div 60) + ' min ';
      Font.Color := clred;
      TextOut(x,y,s);
    end
    else
    if Bericht.Head.Activity = 0 then
    begin
      s := ' l.a. > 1h ';
      Font.Color := clgreen;
      TextOut(x,y,s);
    end;
    inc(x, TextWidth(s));
   end;
end;

procedure TFrame_Bericht._DrawProduktion_(var line: integer; Zeile, ya: integer);
var x: integer;
    s: string;
begin
  with PB_B.Canvas do
  begin
   //Produktion / Stunde anzeigen:
   if ShowProduction and (length(Bericht.Bericht[sg_Gebaeude]) > 0) then
   begin
     inc(line);
     Brush.Color := clgreen;
     Rectangle(0,line*Zeile,PB_B.Width,line*Zeile+Zeile);
     x := 0; //erste spalte
     TextOut(5,line*Zeile+ya,STR_Produktion);
     Brush.Color := clblack;
     //inc(y); //nächste zeile

     //Minenproduktion:
     Setlength(tst_rep.Bericht[sg_Rohstoffe], ScanFileCounts[sg_Rohstoffe]);
     tst_rep.Bericht[sg_Rohstoffe][0] := mineprod_h[rtMetal];
     tst_rep.Bericht[sg_Rohstoffe][1] := mineprod_h[rtKristal];
     tst_rep.Bericht[sg_Rohstoffe][2] := mineprod_h[rtDeuterium];
     tst_rep.Bericht[sg_Rohstoffe][3] := 0;
     _DrawNormal_Group(sg_Rohstoffe, false, false, 2, line, Zeile, ya, tst_rep, cl_text_color);

     if produktionsfaktor = -1 then
       s := 'n/a'
     else
       s := IntToStr(round(produktionsfaktor*100)) + '%';
       
     _DrawLine_(5,line*Zeile+ya, (PB_B.Width div 2) -5,
        'Produktionsfaktor:', s);

     if solsatenergy = -1 then
       s := 'n/a'
     else
       s := IntToStr(solsatenergy);
       
     _DrawLine_((PB_B.Width div 2)+5,line*Zeile+ya, PB_B.Width-5,
        'Energie/Solarsatellit:', s);
     inc(line);
     _DrawLine_(5,line*Zeile+ya, (PB_B.Width div 2) -5,
        'Temperatur:', planettemp_str);
//     _DrawLine_((PB_B.Width div 2)+5,line*Zeile+ya, PB_B.Width-5,
//        'Solarsatelit:', IntToStr(solsatenergy));

     //Zeit Rohstoffproduktion
     inc(line);
     Brush.Color := clgreen;
     Rectangle(0,line*Zeile,PB_B.Width,line*Zeile+Zeile);
     x := 0; //erste spalte
     TextOut(5,line*Zeile+ya, plugin.SBItems[sg_Rohstoffe][0] + '/(' + STR_Produktion + ')');
     Brush.Color := clblack;

     Setlength(tst_rep.Bericht[sg_Rohstoffe], ScanFileCounts[sg_Rohstoffe]);
     if tst_rep.Bericht[sg_Rohstoffe][0] <> 0 then
       tst_rep.Bericht[sg_Rohstoffe][0] := trunc(Bericht_orig.Bericht[sg_Rohstoffe][0] / tst_rep.Bericht[sg_Rohstoffe][0]);

     if tst_rep.Bericht[sg_Rohstoffe][1] <> 0 then
       tst_rep.Bericht[sg_Rohstoffe][1] := trunc(Bericht_orig.Bericht[sg_Rohstoffe][1] / tst_rep.Bericht[sg_Rohstoffe][1]);
     if tst_rep.Bericht[sg_Rohstoffe][2] <> 0 then
       tst_rep.Bericht[sg_Rohstoffe][2] := trunc(Bericht_orig.Bericht[sg_Rohstoffe][2] / tst_rep.Bericht[sg_Rohstoffe][2]);
     tst_rep.Bericht[sg_Rohstoffe][3] := 0;
     _DrawNormal_Group(sg_Rohstoffe, false, false, 2, line, Zeile, ya, tst_rep, cl_text_color);



     {s := STR_Metall;
     TextOut(x*w+5,y*Zeile+ya,s);
     s := FloatToStrF(,ffNumber,60000000,0);
     TextOut(x*w-5 + (w-TextWidth(s)),y*Zeile+ya,s);
     x := 1; //zweite spalte
     s := STR_Kristall;
     TextOut(x*w+5,y*Zeile+ya,s);
     s := FloatToStrF(GetMineProduction(Bericht, speedfactor, omKristal),ffNumber,60000000,0);
     TextOut(x*w-5 + (w-TextWidth(s)),y*Zeile+ya,s);
     x := 0; //erste spalte
     inc(y); //nächste zeile
     s := STR_Deuterium;
     TextOut(x*w+5,y*Zeile+ya,s);
     s := FloatToStrF(GetMineProduction(Bericht, speedfactor, omDeuterium),ffNumber,60000000,0);
     TextOut(x*w-5 + (w-TextWidth(s)),y*Zeile+ya,s); }
   end;


   //Lagerkapazität:
   if show_storage and (length(Bericht.Bericht[sg_Gebaeude]) > 0) then
   begin
     Brush.Color := clgreen;
     Rectangle(0,line*Zeile,PB_B.Width,line*Zeile+Zeile);
     x := 0; //erste spalte
     TextOut(5,line*Zeile+ya, 'Lagerkapazität');
     Brush.Color := clblack;
     //inc(y); //nächste zeile

     //Minenproduktion:
     Setlength(tst_rep.Bericht[sg_Rohstoffe], ScanFileCounts[sg_Rohstoffe]);
     tst_rep.Bericht[sg_Rohstoffe][0] := GetStorageSize(Bericht, rtMetal);
     tst_rep.Bericht[sg_Rohstoffe][1] := GetStorageSize(Bericht, rtKristal);
     tst_rep.Bericht[sg_Rohstoffe][2] := GetStorageSize(Bericht, rtDeuterium);
     tst_rep.Bericht[sg_Rohstoffe][3] := 0;
     _DrawNormal_Group(sg_Rohstoffe, false, false, 2, line, Zeile, ya, tst_rep, cl_text_color);
   end;
  end;
end;

procedure TFrame_Bericht._DrawXMLGroup(xml_root: THTMLElement; left: integer;
  var top: integer; width: integer);
var colcount, linehight, text_dist_y, text_dist_x: integer;
    col, i, colwidth: integer;
    tag: THTMLElement;
    s: string;
    swidth: integer;
begin
  colcount := StrToIntDef(xml_root.AttributeValue['colcount'], 1);
  colwidth := width div colcount;
  linehight := StrToIntDef(xml_root.AttributeValue['linehight'], 15);
  text_dist_y := StrToIntDef(xml_root.AttributeValue['text_dist_y'], 1);
  text_dist_x := StrToIntDef(xml_root.AttributeValue['text_dist_x'], 1);
  if colcount < 1 then colcount := 1;

  col := 0;
  for i := 0 to xml_root.ChildCount - 1 do
  begin
    tag := xml_root.ChildElements[i];
    PB_B.Canvas.Brush.Color := StrToIntDef(tag.AttributeValue['bgcolor'], clBlack);
    PB_B.Canvas.Pen.Color := clBlack;

    PB_B.Canvas.Font.Color := StrToIntDef(tag.AttributeValue['color'], clWhite);
    if tag.TagName = 'header' then
    begin
      PB_B.Canvas.Rectangle(left, top, left+width, top+linehight);
      PB_B.Canvas.TextOut(left + text_dist_x, top + text_dist_y, tag.FullTagContent);
      top := top + linehight;
    end
    else
    if tag.TagName = 'item' then
    begin
      PB_B.Canvas.TextOut(col*colwidth + left + text_dist_x, top + text_dist_y,
                          tag.AttributeValue['left']);
      s := '  ' + tag.AttributeValue['right'];
      swidth := PB_B.Canvas.TextWidth(s);
      PB_B.Canvas.TextOut(col*colwidth + colwidth + left - text_dist_x - swidth,
                          top + text_dist_y,
                          s + '  ');



      col := col + 1;
      if col >= colcount then
      begin
        top := top + linehight;
        col := 0;
      end;
    end;
  end;
end;

procedure TFrame_Bericht._DrawXMLText(tag: THTMLElement; left, top: integer);
begin

end;

end.
