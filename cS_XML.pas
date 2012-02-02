unit cS_XML;

interface

uses
  Ogame_Types, inifiles, Classes, SysUtils, XMLDoc, XMLIntf, DateUtils, Prog_Unit, dialogs,
  ImportProgress, LibXmlParser, LibXmlComps, languages, forms, fast_xml_writer, xml_parser_unicode;

const
  //Position_XML_idents:
  xpos_gala                        = 'gala';
  xpos_sys                         = 'sys';
  xpos_pos                         = 'pos';
  xpos_moon                        = 'moon';
  //Sys_XML_idents:
  xsys_group                       = 'solsys';
  xsys_group_time                  = 'time';
  xsys_planet                      = 'planet';
  xsys_planet_pos                  = 'pos';
  xsys_planet_activity             = 'activity';
  xsys_planet_moon                 = 'moon';
  xsys_planet_mtemp                = 'mtemp';
  xsys_planet_tfmet                = 'tfmet';
  xsys_planet_tfcrys               = 'tfcrys';
  xsys_planet_name                 = 'name';
  xsys_planet_player               = 'player';
  xsys_planet_player_id            = 'playerid';
  xsys_planet_alliance             = 'alliance';
  xsys_planet_alliance_id          = 'allianceid';
  xsys_planet_flags                = 'flags';
  //Scan_XML_idents:
  xspio_group                      = 'report';
  xspio_group_time                 = 'time';
  xspio_group_planet               = 'planet';
  xspio_group_player               = 'player';
  xspio_group_player_id            = 'playerid';
  xpsio_group_activity             = 'activ';
  xspio_group_cspio                = 'cspio';     //counterespionage , Spionageabwehr
  xspio_group_creator              = 'creator';
  //Statistic_XML_idents:
  xstat_group                      = 'stats';
  xstat_group_time                 = 'time';
  xstat_group_nametype             = 'ntype';
  xstat_group_nametype_idents      : array[TStatNameType] of string = (
                                     'player',
                                     'alliance');
  xstat_group_pointtype            = 'ptype';
  xstat_group_pointtype_idents     : array[TStatPointType] of string = (
                                     'points',
                                     'fleet',
                                     'research');
  xstat_group_first                = 'first';
  xstat_group_count                = 'count';
  xstat_rank                       = 'rank';
  xstat_rank_position              = 'pos';
  xstat_rank_name                  = 'name';
  xstat_rank_name_id               = 'nameid';
  xstat_rank_points                = 'points';
  xstat_rank_alliance              = 'alliance';
  xstat_rank_members               = 'members';
  xstat_rank_ships                 = 'ships';
  //Fleet_XML_idents:
  xflt_group                       = 'fleet';
  xflt_group_arrivaltime           = 'arrival';
  xflt_group_mission               = 'mission';
  xflt_group_mission_flags         = 'flags';
  xflt_group_player                = 'player';
  xflt_group_mission_flag_idents   : array[TFleetEventFlag] of string = (
                                     'return',
                                     'friendly',
                                     'neutral',
                                     'hostile'
                                   );
  xflt_group_mission_idents        : array[TFleetEventType] of string = (
                                     'none',
                                     'deploy',
                                     'transport',
                                     'attack',
                                     'spy',
                                     'recycle',
                                     'colonize',
                                     'expedition'
                                   );
  xflt_origintag                   = 'origin';
  xflt_targettag                   = 'target';

type
  Txdatatype = (txd_none,txd_xsys,txd_xspio,txd_stat);
  TcSXMLScanner = class(TEasyXmlScanner)
  private
    Sys: TSystemCopy;
    Scan: TScanBericht;
    xdtyp: Txdatatype;
    PROCEDURE ScannerProcessTag(Sender : TObject; TagName : STRING; Attributes : TAttrList; Empty: Boolean);
    PROCEDURE ScannerStartTag(Sender : TObject; TagName : STRING; Attributes : TAttrList);
    PROCEDURE ScannerEmptyTag(Sender : TObject; TagName : STRING; Attributes : TAttrList);
    PROCEDURE ScannerTagReady(Sender : TObject; TagName : STRING);
    procedure process_xsys_data(Sender: TObject; TagName: STRING;
      Attributes: TAttrList; Empty: Boolean);
    procedure process_xspio_data(Sender: TObject; TagName: STRING;
      Attributes: TAttrList; Empty: Boolean);
    procedure process_xspio_starttag(Sender: TObject; TagName: STRING;
      Attributes: TAttrList; Empty: Boolean);
    procedure process_xspio_endtag(Sender: TObject; TagName: STRING);
    procedure process_xsys_starttag(Sender: TObject; TagName: STRING;
      Attributes: TAttrList; Empty: Boolean);
    procedure process_xsys_endtag(Sender: TObject; TagName: STRING);
  public
    ODB: TOgameDataBase;
    ProcessForm: TFRM_ImportProgress;
    ende: Boolean;
    constructor Create(AOwner: TComponent; AODB: TOgameDataBase); reintroduce;
    destructor Destroy; override;
  end;

//procedure ScanToXML(Scan: TScanBericht; XMLFile: TXMLDocument);
//procedure SysToXML(Sys: TSystemCopy; XMLFile: TXMLDocument);
procedure ImportXMLODB_1_slow(Filename: String; ODB: TOgameDataBase);
function XMLToSys(node: IXMLNode): TSystemCopy;
procedure ImportXMLODB_wrong(Filename: String; ODB: TOgameDataBase);
function SysToXML_(sys: TSystemCopy; csvers: string): string;
procedure SysToXML_fxml(fxml: TFastXmlWriter; sys: TSystemCopy; csvers: string);
function parse_Sys(parser: TUnicodeXmlParser): Boolean; overload;
function parse_Sys(parser: TUnicodeXmlParser; var solsys: TSystemCopy): Boolean; overload;
procedure parse_error(parser: TUnicodeXmlParser; msg: string);
function parse_report(parser: TUnicodeXmlParser): boolean; overload;
function parse_report(parser: TUnicodeXmlParser; report: TScanBericht): boolean; overload;
function ScanToXML_(Scan: TScanBericht; csvers: string): String;
procedure ScanToXML_fxml(fxml: TFastXmlWriter; Scan: TScanBericht; csvers: string);
function parse_unknown(parser: TUnicodeXmlParser; parse_known: Boolean): boolean;
procedure ImportXMLODB_(Filename: String; ODB: TOgameDataBase);
procedure StatToXML_fxml(fxml: TFastXmlWriter; Stat: TStat; StatType: TStatTypeEx);
function StatToXML_(Stat: TStat; StatType: TStatTypeEx): String;
function parse_stat(parser: TUnicodeXmlParser; var Stat: TStat;
  var snt: TStatNameType; var spt: TStatPointType): boolean; overload;
function parse_stat(parser: TUnicodeXmlParser): boolean; overload;
function StatNameTypeToString(t: TStatNameType): string;
function StringToStatNameType(s: string): TStatNameType;
function StatPointTypeToString(t: TStatPointType): string;
function StringToStatPointType(s: string): TStatPointType;
function FleetToXML_(fleet: TFleetEvent): string;
function FleetJobFlagsToString(eflags: TFleetEventFlags): string;
function FleetJobToString(job: TFleetEventType): string;
function PlanetPositionToXML_attr(pos: TPlanetPosition): string;
procedure PlanetPositionToXML_attr_fxml(fxml: TFastXmlWriter; pos: TPlanetPosition);
function ScanPartToXML_(scan: TScanBericht; partnr: TScanGroup): string;
procedure ScanPartToXML_fxml(fxml: TFastXmlWriter; scan: TScanBericht; partnr: TScanGroup);
function parse_fleet(parser: TUnicodeXmlParser; var fleet: TFleetEvent): Boolean;
function StringToFleetJobFlags(s: string): TFleetEventFlags;
function StringToFleetJob(s: String): TFleetEventType;
function XML_attrToPlanetPosition(parser: TUnicodeXmlParser): TPlanetPosition;

implementation

uses Math, ComObj, cS_utf8_conv;

function PlanetPositionToXML_attr(pos: TPlanetPosition): string;
begin
  Result := ' '+xpos_gala+'="'+IntToStr(pos.P[0])+'"'+
            ' '+xpos_sys+ '="'+IntToStr(pos.P[1])+'"'+
            ' '+xpos_pos+ '="'+IntToStr(pos.P[2])+'"';
  if pos.Mond then
    Result := Result+' '+xpos_moon+'="true"';
end;

procedure PlanetPositionToXML_attr_fxml(fxml: TFastXmlWriter; pos: TPlanetPosition);
begin
  fxml.addAttribute(xpos_gala,pos.P[0]);
  fxml.addAttribute(xpos_sys, pos.P[1]);
  fxml.addAttribute(xpos_pos, pos.P[2]);
  if pos.Mond then
    fxml.addAttribute(xpos_moon, 'true');
end;

{procedure ScanToXML(Scan: TScanBericht; XMLFile: TXMLDocument);
var Node, gnode: IXMLNode;
    j: integer;
    //flags: Integer;
begin
  node := XMLFile.DocumentElement.AddChild(xspio_group);
  with Node do
  begin
    Attributes[xpos_gala] := Scan.Head.Position.P[0];
    Attributes[xpos_sys] := Scan.Head.Position.P[1];
    Attributes[xpos_pos] := Scan.Head.Position.P[2];
    if Scan.Head.Position.Mond then Attributes[xpos_moon] := 'true';
    Attributes[xspio_group_time] := IntToStr(Scan.Head.Time_u);
    Attributes[xspio_group_planet] := Scan.Head.Planet;
    //Attributes[xspio_group_player] := scan.Head.Spieler;
    Attributes[xspio_group_cspio] := Scan.Head.Spionageabwehr;
    Attributes[xspio_group_creator] := Scan.Head.Creator;

    //flags := 0;

    for i := 0 to length(Scan.Bericht)-1 do
    begin
      if Scan.Bericht[i][0] <> -1 then
      begin
        gnode := Node.AddChild(xspio_idents[i][0]);

        //flags := flags or trunc(IntPower(2,i));
        for j := 0 to ScanFileCounts[i]-1 do
        begin
          if Scan.Bericht[i][j] <> 0 then gnode.Attributes[xspio_idents[i][j+1]] := Scan.Bericht[i][j];
        end;
      end;
    end;
    //Attributes[xspio_group_blocks] := flags;
  end;
end; }

{procedure SysToXML(Sys: TSystemCopy; XMLFile: TXMLDocument);
var Node: IXMLNode;
    i: integer;
begin
  node := XMLFile.DocumentElement.AddChild(xsys_group);
  node.Attributes[xpos_gala] := IntToStr(Sys.System.P[0]);
  node.Attributes[xpos_sys] := IntToStr(Sys.System.P[1]);
  node.Attributes[xsys_group_time] := IntToStr(Sys.Time_u);
  for i := 1 to max_Planeten do
  if (sys.Planeten[i].Player <> '')or(Sys.Planeten[i].TF[0] + Sys.Planeten[i].TF[1] > 0) then
  with Sys.Planeten[i] do
  begin
    with Node.AddChild(xsys_planet) do
    begin
      Attributes[xsys_planet_pos] := i;

      if PlanetName <> '' then Attributes[xsys_planet_name] := PlanetName;
      if Player <> '' then Attributes[xsys_planet_player] := Player;
      if Ally <> '' then Attributes[xsys_planet_alliance] := Ally;
      if Status <> [] then Attributes[xsys_planet_flags] := WORD(Status);

      if (MondSize > 0) then
      begin
        Attributes[xsys_planet_moon] := MondSize;
        Attributes[xsys_planet_mtemp] := MondTemp;
      end;

      if TF[0] > 0 then Attributes[xsys_planet_tfmet] := TF[0];
      if TF[1] > 0 then Attributes[xsys_planet_tfcrys] := TF[1];
    end;
  end;
end; }

procedure ImportXMLODB_1_slow(Filename: String; ODB: TOgameDataBase);
var XML: TXMLDocument;
    node: IXMLNode;
    frm: TFRM_ImportProgress;
    e: boolean;
begin            //funzt soweit schon, dauert aber ewig,
                 // und brauch jedemenge ram!  ->   unbrauchbar
  XML := TXMLDocument.Create(Application);
  frm := TFRM_ImportProgress.Create(Application);

  frm.ende := @e;
  e := false;

  XML.Options := [];
  try
    XML.LoadFromFile(Filename);
    XML.DocumentElement.ReadOnly := True;

    frm.Gauge1.MinValue := 0;
    frm.Gauge1.Progress := 0;
    frm.Gauge1.MaxValue := XML.DocumentElement.Attributes['count'];
    frm.Show;

    node := xml.DocumentElement.ChildNodes.First;
    while (node <> nil)and(not e) do
    begin
      if node.NodeName = xsys_group then
      begin
        ODB.UniTree.AddNewSolSys(XMLToSys(node));
      end;
      node := node.NextSibling;

      frm.Gauge1.Progress := frm.Gauge1.Progress+1;
      //wird in keinem eigenen Thread ausgeführt!
      Application.ProcessMessages;
    end;
  except
    Application.HandleException(ODB);
  end;
  frm.Release;
  XML.Free;
end;

function XMLToSys(node: IXMLNode): TSystemCopy;
var i: integer;
    cnode: IXMLNode;
begin
  Result.System.P[0] := node.Attributes[xpos_gala];
  Result.System.P[1] := node.Attributes[xpos_sys];
  Result.System.P[2] := 1;
  Result.System.Mond := False;
  Result.Time_u := node.Attributes[xsys_group_time];   //Unix

  FillChar(Result.Planeten,sizeof(Result.Planeten),0);

  cnode := node.ChildNodes.First;
  while cnode <> nil do
  if cnode.NodeName = xsys_planet then
  begin
    i := cnode.Attributes[xsys_planet_pos];
    with Result.Planeten[i] do
    begin
      with cnode do
      begin
        PlanetName := Attributes[xsys_planet_name];
        Player := Attributes[xsys_planet_player];
        Ally := Attributes[xsys_planet_alliance];
        if Attributes[xsys_planet_flags] <> '' then Status := TStatus(word(Attributes[xsys_planet_flags]));

        if Attributes[xsys_planet_moon] <> '' then MondSize := Attributes[xsys_planet_moon];
        if Attributes[xsys_planet_mtemp] <> '' then MondTemp := Attributes[xsys_planet_mtemp];

        if Attributes[xsys_planet_tfmet] <> '' then TF[0] := Attributes[xsys_planet_tfmet];
        if Attributes[xsys_planet_tfcrys] <> '' then TF[1] := Attributes[xsys_planet_tfcrys];
      end;
    end;
    cnode := cnode.NextSibling;
  end;
end;

procedure ImportXMLODB_wrong(Filename: String; ODB: TOgameDataBase);
var scanner: TcSXMLScanner;
    frm: TFRM_ImportProgress;
begin      //Wrong idea!!! -> to complex, better use parser than scanner!!!!!!!!
  scanner := TcSXMLScanner.Create(Application,ODB);
  scanner.Filename := Filename;
  frm := TFRM_ImportProgress.Create(Application);
  frm.GroupBox1.Caption := STR_Import_XML;
  frm.ende := @scanner.ende;
  scanner.ProcessForm := frm;
  frm.Show;
  scanner.Execute;
  frm.ende := nil;
  frm.Release;
  scanner.Free;
end;

constructor TcSXMLScanner.Create(AOwner: TComponent; AODB: TOgameDataBase);
begin
  inherited Create(AOwner);
  xdtyp := txd_none;
  OnStartTag := ScannerStartTag;
  OnEmptyTag := ScannerEmptyTag;
  OnEndTag := ScannerTagReady;
  ODB := AODB;
  Scan := TScanBericht.Create();
end;

PROCEDURE TcSXMLScanner.ScannerStartTag(Sender : TObject; TagName : STRING; Attributes : TAttrList);
begin
  ScannerProcessTag(Sender,TagName,Attributes,False);
end;

PROCEDURE TcSXMLScanner.ScannerEmptyTag(Sender : TObject; TagName : STRING; Attributes : TAttrList);
begin
  ScannerProcessTag(Sender,TagName,Attributes,True);
end;

PROCEDURE TcSXMLScanner.ScannerProcessTag(Sender : TObject; TagName : STRING; Attributes : TAttrList; Empty: Boolean);
var s: string;
begin
  if ende then StopParser := True;

  case xdtyp of
  //----------------------------------none-------------none------------none--------------------------
  txd_none:

    if TagName = 'export' then  //-----------------------export-----------------
    begin
      s := atValStr(Attributes,'count');
      if (ProcessForm <> nil)and(s <> '') then
      begin
        ProcessForm.SetMax(StrToInt(s));
      end;
    end
    else

    if TagName = xsys_group then  //------------------sys------------sys--------
    begin
      xdtyp := txd_xsys;

      process_xsys_starttag(Sender,TagName,Attributes,Empty);

      if Empty then ScannerTagReady(Sender,TagName);  //extra ende aufrufen, wenn system leer!
    end

    else
    if TagName = xspio_group then  //--------------------spio---------spio------
    begin
      xdtyp := txd_xspio;

      process_xspio_starttag(Sender,TagName,Attributes,Empty);

      if Empty then ScannerTagReady(Sender,TagName);  //extra ende aufrufen, wenn scan leer! (sollte nicht vorkommen!)
    end;
  //-----------------------sys---------------sys-------------------sys-------------------------------
  txd_xsys: process_xsys_data(Sender,TagName,Attributes,Empty);
  txd_xspio: process_xspio_data(Sender,TagName,Attributes,Empty);
  end;
end;

PROCEDURE TcSXMLScanner.ScannerTagReady(Sender : TObject; TagName : STRING);
begin
  case xdtyp of
  txd_xsys:
    if TagName = xsys_group then
    begin
      process_xsys_endtag(Sender,TagName);

      xdtyp := txd_none;

      if ProcessForm <> nil then ProcessForm.Go;
      Application.ProcessMessages;
    end;
  txd_xspio:
    if TagName = xspio_group then
    begin
      process_xspio_endtag(Sender,TagName);

      xdtyp := txd_none;

      if ProcessForm <> nil then ProcessForm.Go;
      Application.ProcessMessages;
    end;
  end;
end;

procedure TcSXMLScanner.process_xsys_data(Sender: TObject; TagName: STRING;
  Attributes: TAttrList; Empty: Boolean);
var p: integer;
    s: string;
begin
  if TagName = xsys_planet then
  begin
    try
      p := StrToInt(atValStr(Attributes,xsys_planet_pos));
      with sys.Planeten[p] do
      begin
        PlanetName := atValStr(Attributes,xsys_planet_name);
        Player := atValStr(Attributes,xsys_planet_player);
        Ally := atValStr(Attributes,xsys_planet_alliance);

        s := atValStr(Attributes,xsys_planet_flags);
        if s <> '' then Status := TStatus(word(StrToInt(s)));

        s := atValStr(Attributes,xsys_planet_moon);
        if s <> '' then MondSize := StrToInt(s);

        s := atValStr(Attributes,xsys_planet_mtemp);
        if s <> '' then MondTemp := StrToInt(s);

        s := atValStr(Attributes,xsys_planet_tfmet);
        if s <> '' then TF[0] := StrToInt(s);

        s := atValStr(Attributes,xsys_planet_tfcrys);
        if s <> '' then TF[1] := StrToInt(s);
      end;
    except
      //Ungültiges System durch ungültige Position Markieren!
      FillChar(Sys.System,SizeOf(Sys.System),0);
    end;
  end
end;

procedure TcSXMLScanner.process_xspio_data(Sender: TObject;
  TagName: STRING; Attributes: TAttrList; Empty: Boolean);
var j: integer;
    s: string;
    sg: TScanGroup;
begin
  for sg := low(sg) to high(sg) do
    if TagName = xspio_idents[sg][0] then    //bericht wird in process_xspio_starttag überall mit -1 vorbelegt!
    begin
      try
        for j := 0 to ScanFileCounts[sg]-1 do
        begin
          s := atValStr(Attributes,xspio_idents[sg][j+1]);
          if s <> '' then
            Scan.Bericht[sg,j] := StrToInt(s)
          else Scan.Bericht[sg,j] := 0;
        end;
      except
        //Fehlerhafter Scan!
        FillChar(Scan.Head,SizeOf(Scan.Head),0);
      end;
    end;
end;

procedure TcSXMLScanner.process_xspio_starttag(Sender: TObject;
  TagName: STRING; Attributes: TAttrList; Empty: Boolean);
var s: string;
begin
  //Scan Leeren!
  Scan.clear;

  try
    Scan.Head.Position.P[0] := StrToInt(atValStr(Attributes,xpos_gala));
    Scan.Head.Position.P[1] := StrToInt(atValStr(Attributes,xpos_sys));
    Scan.Head.Position.P[2] := StrToInt(atValStr(Attributes,xpos_pos));
    Scan.Head.Position.Mond := atValStr(Attributes,xpos_moon) = 'true';

    Scan.Head.Time_u := StrToInt64(atValStr(Attributes,xspio_group_time)); //Unix
  except
    FillChar(Scan.Head.Position,SizeOf(Scan.Head.Position),0);
  end;

  Scan.Head.Planet := atValStr(Attributes,xspio_group_planet);
  //Attributes[xspio_group_player] := scan.Head.Spieler;

  s := atValStr(Attributes,xspio_group_cspio);
  if s <> '' then Scan.Head.Spionageabwehr := StrToInt(s);

  Scan.Head.Creator := atValStr(Attributes,xspio_group_creator);
end;

procedure TcSXMLScanner.process_xspio_endtag(Sender: TObject; TagName: STRING);
begin
  ODB.UniTree.AddNewReport(Scan);
  Scan := TScanBericht.Create(); // begin new scan
end;

procedure TcSXMLScanner.process_xsys_starttag(Sender: TObject;
  TagName: STRING; Attributes: TAttrList; Empty: Boolean);
begin
  FillChar(Sys,SizeOf(Sys),0);   //Sys leeren (Standartwehrte setzen!)

  try                            //HeadDaten einlesen
    sys.System.P[0] := StrToInt(atValStr(Attributes,xpos_gala));
    sys.System.P[1] := StrToInt(atValStr(Attributes,xpos_sys));
    Sys.System.P[2] := 1;

    Sys.Time_u := StrToInt64(atValStr(Attributes,xsys_group_time));
  except
    FillChar(sys.System,SizeOf(Sys.System),0);
  end;
end;

procedure TcSXMLScanner.process_xsys_endtag(Sender: TObject; TagName: STRING);
begin
  ODB.UniTree.AddNewSolSys(sys);
end;

function SysToXML_(sys: TSystemCopy; csvers: string): string;
var fxml: TFastXmlWriter;
begin
  fxml := TFastXmlWriter.Create('');
  try
    SysToXML_fxml(fxml, sys, csvers);
    Result := fxml.getXML();
  finally
    fxml.Free;
  end;
end;

procedure SysToXML_fxml(fxml: TFastXmlWriter; sys: TSystemCopy; csvers: string);
var i: integer;
begin
  fxml.beginTag(xsys_group);
  fxml.addAttribute(xpos_gala,       sys.System.P[0]);
  fxml.addAttribute(xpos_sys,        sys.System.P[1]);
  fxml.addAttribute(xsys_group_time, sys.Time_u);

  for i := 1 to max_Planeten do
    if (sys.Planeten[i].Player <> '')or
       (sys.Planeten[i].PlanetName <> '')or  // Zerstörter Planet...
       (Sys.Planeten[i].TF[0] + Sys.Planeten[i].TF[1] > 0) then
      with Sys.Planeten[i] do
      begin
        fxml.beginTag(xsys_planet);
        fxml.addAttribute(xsys_planet_pos, i);
        
        if ( csvers >= '0.7' ) and
           ( Activity > 0 ) then fxml.addAttribute(xsys_planet_activity, Activity);

        if PlanetName <> '' then fxml.addAttribute(xsys_planet_name, PlanetName);
        if Player     <> '' then fxml.addAttribute(xsys_planet_player, Player);
        
        if ( csvers >= '0.7' ) and
           ( PlayerId > 0 ) then fxml.addAttribute(xsys_planet_player_id, PlayerId);

        if Ally <> '' then fxml.addAttribute(xsys_planet_alliance, Ally);

        if ( csvers >= '0.7' ) and
           ( AllyId > 0 ) then fxml.addAttribute(xsys_planet_alliance_id, AllyId);
           
        if Status <> [] then fxml.addAttribute(xsys_planet_flags, WORD(Status));

        if (MondSize > 0) then
        begin
          fxml.addAttribute(xsys_planet_moon, MondSize);
          fxml.addAttribute(xsys_planet_mtemp, MondTemp);
        end;

        if TF[0] > 0 then fxml.addAttribute(xsys_planet_tfmet, TF[0]);
        if TF[1] > 0 then fxml.addAttribute(xsys_planet_tfcrys, TF[1]);

        fxml.endTag(xsys_planet);
      end;
      
  fxml.endTag(xsys_group);
end;

function parse_Sys(parser: TUnicodeXmlParser): Boolean;
var solsys: TSystemCopy;
begin
  Result := parse_Sys(parser,solsys);
  if Result then
    ODataBase.UniTree.AddNewSolSys(solsys); 
end;

function parse_Sys(parser: TUnicodeXmlParser; var solsys: TSystemCopy): Boolean;

  function parse_xsys_planet: boolean;
  var p: integer;
      s: string;
  begin
    Result := (parser.CurName = xsys_planet);
    if Result then
    begin
      p := -1;
      try
        p := parser.attrAsInt(xsys_planet_pos);
        with solsys.Planeten[p] do
        begin
          PlanetName := parser.attrAsString(xsys_planet_name);
          Player := parser.attrAsString(xsys_planet_player);
          Ally := parser.attrAsString(xsys_planet_alliance);

          s := parser.attrAsString(xsys_planet_player_id);
          PlayerId := StrToInt64Def(s, 0);
          s := parser.attrAsString(xsys_planet_alliance_id);
          AllyId := StrToInt64Def(s, 0);

          s := parser.attrAsString(xsys_planet_flags);
          if s <> '' then Status := TStatus(word(StrToInt(s)));

          s := parser.attrAsString(xsys_planet_moon);
          if s <> '' then MondSize := StrToInt(s);

          s := parser.attrAsString(xsys_planet_mtemp);
          if s <> '' then MondTemp := StrToInt(s);

          s := parser.attrAsString(xsys_planet_tfmet);
          if s <> '' then TF[0] := StrToInt(s);

          s := parser.attrAsString(xsys_planet_tfcrys);
          if s <> '' then TF[1] := StrToInt(s);

          s := parser.attrAsString(xsys_planet_activity);
          if s <> '' then Activity := StrToInt(s);
        end;
      except
        //Ungültiges System durch ungültige Position Markieren!
        parse_error(parser,Format(
          'Planet %d from solsys %d:%d is broken! Can''t use this solsys!',
          [p, solsys.System.P[0], solsys.System.P[1]]));
        FillChar(solsys.System,SizeOf(solsys.System),0);
      end;

      if parser.CurPartType <> ptEmptyTag then
      while (parser.Scan)and(parser.CurPartType <> ptEndTag) do
      begin
        case parser.CurPartType of
          ptStartTag, ptEmptyTag: parse_unknown(parser,False);
        end;
      end;

    end;
  end;

begin
  Result := (parser.CurName = xsys_group);
  if Result then
  begin
    FillChar(solsys,SizeOf(solsys),0);   //Sys leeren (Standartwehrte setzen!)
    try                            //HeadDaten einlesen
      solsys.System.P[0] := StrToInt(parser.attrAsString(xpos_gala));
      solsys.System.P[1] := StrToInt(parser.attrAsString(xpos_sys));
      solsys.System.P[2] := 1;

      solsys.Time_u := StrToInt64(parser.attrAsString(xsys_group_time));
    except
      parse_error(parser,Format('Solsys %d:%d is broken! Can''t use it!',
        [solsys.System.P[0], solsys.System.P[1]]));
      FillChar(solsys.System,SizeOf(solsys.System),0);
    end;

    if parser.CurPartType <> ptEmptyTag then
    while (parser.Scan)and(parser.CurPartType <> ptEndTag) do
    begin
      case parser.CurPartType of
        ptStartTag, ptEmptyTag:
          begin
            if not parse_xsys_planet then
              parse_unknown(parser,False);
          end;
      end;
    end;
  end;
end;

procedure parse_error(parser: TUnicodeXmlParser; msg: string);
begin
  raise Exception.Create(msg);
end;

function parse_report(parser: TUnicodeXmlParser): boolean;
var report: TScanBericht;
begin
  report := TScanBericht.Create;
  try
    Result := parse_report(parser, report);
    if Result then
      ODataBase.UniTree.AddNewReport(report);
  finally
    report.Free;
  end;
end;

function parse_report_group(parser: TUnicodeXmlParser; sg: TScanGroup;
  scan: TScanBericht): boolean;
var j: integer;
    s: string;
begin
  Result := (parser.CurName = AnsiString(xspio_idents[sg][0]));
  if Result then
  begin
    try
      for j := 0 to ScanFileCounts[sg]-1 do
      begin
        s := parser.attrAsString(xspio_idents[sg][j+1]);
        if s <> '' then
          scan.Bericht[sg,j] := StrToInt(s)
        else scan.Bericht[sg,j] := 0;
      end;
    except
      parse_error(parser,'parse_report_group: Error reading reportgroup: ' + xspio_idents[sg][0]);
    end;

    if parser.CurPartType <> ptEmptyTag then
    while (parser.Scan)and(parser.CurPartType <> ptEndTag) do
    begin
      case parser.CurPartType of
        ptStartTag, ptEmptyTag: parse_unknown(parser,False);
      end;
    end;

  end;
end;

function parse_report_group_AI(parser: TUnicodeXmlParser; sg: TScanGroup;
  part: TInfoArray): boolean;
var j: integer;
    s: string;
begin
  Result := (parser.CurName = AnsiString(xspio_idents[sg][0]));
  if Result then
  begin
    try
      for j := 0 to ScanFileCounts[sg]-1 do
      begin
        s := parser.attrAsString(xspio_idents[sg][j+1]);
        if s <> '' then
          part[j] := StrToInt(s)
        else part[j] := 0;
      end;
    except
      parse_error(parser,'parse_report_group: Error reading reportgroup: ' + xspio_idents[sg][0]);
    end;

    if parser.CurPartType <> ptEmptyTag then
    while (parser.Scan)and(parser.CurPartType <> ptEndTag) do
    begin
      case parser.CurPartType of
        ptStartTag, ptEmptyTag: parse_unknown(parser,False);
      end;
    end;

  end;
end;

function XML_attrToPlanetPosition(parser: TUnicodeXmlParser): TPlanetPosition;
begin
  Result.P[0] := StrToInt(parser.attrAsString(xpos_gala));
  Result.P[1] := StrToInt(parser.attrAsString(xpos_sys));
  Result.P[2] := StrToInt(parser.attrAsString(xpos_pos));
  Result.Mond := parser.attrAsString(xpos_moon) = 'true';
end;

function parse_report(parser: TUnicodeXmlParser; report: TScanBericht): boolean;
var s: string;

  function parse_xspio_idents: Boolean;
  var sg: TScanGroup;
  begin
    for sg := low(sg) to high(sg) do
    begin
      Result := parse_report_group(parser,sg,report);
      if Result then
        break;
    end;
  end;

begin
  Result := (parser.CurName = xspio_group);
  if Result then
  begin
    report.clear;

    try
      report.Head.Position := XML_attrToPlanetPosition(parser);
      
      report.Head.Time_u := StrToInt64(parser.attrAsString(xspio_group_time)); //Unix
      report.Head.Planet := parser.attrAsString(xspio_group_planet);
      report.Head.Spieler := parser.attrAsString(xspio_group_player);

      s := parser.attrAsString(xspio_group_player_id);
      if s <> '' then report.Head.SpielerId := StrToInt64(s);

      s := parser.attrAsString(xpsio_group_activity);
      if s <> '' then report.Head.Activity := StrToInt(s);
      
      s := parser.attrAsString(xspio_group_cspio);
      if s <> '' then report.Head.Spionageabwehr := StrToInt(s);

      report.Head.Creator := parser.attrAsString(xspio_group_creator);
    except
      parse_error(parser,Format('Report %d:&d:&d is broken!',
        [report.Head.Position.P[0],report.Head.Position.P[1],
         report.Head.Position.P[2]]));
      FillChar(report.Head.Position,SizeOf(report.Head.Position),0);
    end;

    if parser.CurPartType <> ptEmptyTag then
    while (parser.Scan)and(parser.CurPartType <> ptEndTag) do
    begin
      case parser.CurPartType of
        ptStartTag, ptEmptyTag:
          begin
            if not parse_xspio_idents then
              parse_unknown(parser,False);
          end;
      end;
    end;
  end;
end;

function ScanPartToXML_(scan: TScanBericht; partnr: TScanGroup): string;
var fxml: TFastXmlWriter;
begin
  fxml := TFastXmlWriter.Create('');
  try
    ScanPartToXML_fxml(fxml, scan, partnr);
    Result := fxml.getXML();
  finally
    fxml.Free;
  end;
end;

procedure ScanPartToXML_fxml(fxml: TFastXmlWriter; scan: TScanBericht; partnr: TScanGroup);
var j, val: integer;
begin
  fxml.beginTag(xspio_idents[partnr][0]);

  for j := 0 to ScanFileCounts[partnr]-1 do
  begin
    val := scan.Bericht[partnr, j];
    if val <> 0 then
      fxml.addAttribute(xspio_idents[partnr][j+1],val);
  end;

  fxml.endTag(xspio_idents[partnr][0]);
end;

function ScanPartToXML_IA(part: TInfoArray; partnr: TScanGroup): string;

  procedure attrAdd(attrName, attrValue: string);
  begin
    Result := Result + ' ' + attrName + '="' + attrValue + '"';
  end;

var j, val: integer;
begin
  Result := '<'+xspio_idents[partnr][0];

  for j := 0 to ScanFileCounts[partnr]-1 do
  begin
    val := part[j];
    if val <> 0 then
      attrAdd(xspio_idents[partnr][j+1],IntToStr(val));
  end;

  Result := Result+'/>';
end;

function ScanToXML_(Scan: TScanBericht; csvers: string): String;
var fxml: TFastXmlWriter;
begin
  fxml := TFastXmlWriter.Create('');
  try
    ScanToXML_fxml(fxml, Scan, csvers);
    Result := fxml.getXML;
  finally
    fxml.Free;
  end;
end;

procedure ScanToXML_fxml(fxml: TFastXmlWriter; Scan: TScanBericht; csvers: string);
var sg: TScanGroup;
begin
  fxml.beginTag(xspio_group);
  PlanetPositionToXML_attr_fxml(fxml, Scan.Head.Position);

  fxml.addAttribute(xspio_group_time,Scan.Head.Time_u);
  fxml.addAttribute(xspio_group_planet,Scan.Head.Planet);
  fxml.addAttribute(xspio_group_player,Scan.Head.Spieler);

  if (csvers >= '0.7') and
     (Scan.Head.SpielerId > 0) then
    fxml.addAttribute(xspio_group_player_id,Scan.Head.SpielerId);
    
  fxml.addAttribute(xpsio_group_activity,Scan.Head.Activity);
  fxml.addAttribute(xspio_group_cspio,Scan.Head.Spionageabwehr);
  fxml.addAttribute(xspio_group_creator,Scan.Head.Creator);

  for sg := low(sg) to high(sg) do
  begin
    if Scan.Bericht[sg,0] <> -1 then
    begin
      ScanPartToXML_fxml(fxml, Scan, sg);
    end;
  end;
  fxml.endTag(xspio_group);
end;

function parse_unknown(parser: TUnicodeXmlParser; parse_known: Boolean): boolean;
begin
  Result := True;
  if parser.CurPartType <> ptEmptyTag then
  while (parser.Scan)and(parser.CurPartType <> ptEndTag) do
  begin
    case parser.CurPartType of
      ptStartTag, ptEmptyTag:
        begin
          if parse_known then
          begin
            if not parse_report(parser) then
            if not parse_Sys(parser) then
            if not parse_stat(parser) then
              parse_unknown(parser,parse_known);
          end
          else parse_unknown(parser,parse_known);
        end;
    end;
  end;
end;

procedure ImportXMLODB_(Filename: String; ODB: TOgameDataBase);
var parser: TUnicodeXmlParser;
begin
  parser := TUnicodeXmlParser.Create;
  parser.LoadFromFile(Filename);
  parser.StartScan;
  while parser.Scan do
    parse_unknown(parser,True);
  parser.Free;
end;

function StingToType(s: String; tb: array of string): Integer;
begin
  Result := 0;
  while Result < length(tb) do
  begin
    if s = tb[Result] then
      break;
    inc(Result);
  end;
  if Result > length(tb)-1 then
    Result := -1;
end;
function StatNameTypeToString(t: TStatNameType): string;
begin
  Result := xstat_group_nametype_idents[t];
end;
function StringToStatNameType(s: string): TStatNameType;
begin
  Result := TStatNameType(StingToType(s,xstat_group_nametype_idents));
end;
function StatPointTypeToString(t: TStatPointType): string;
begin
  Result := xstat_group_pointtype_idents[t];
end;
function StringToStatPointType(s: string): TStatPointType;
begin
  Result := TStatPointType(StingToType(s,xstat_group_pointtype_idents));
end;

function StatToXML_(Stat: TStat; StatType: TStatTypeEx): String;
var fxml: TFastXmlWriter;
begin
  fxml := TFastXmlWriter.Create('');
  try
    StatToXML_fxml(fxml, Stat, StatType);
    Result := fxml.getXML();
  finally
    fxml.Free;
  end;
end;

procedure StatToXML_fxml(fxml: TFastXmlWriter; Stat: TStat; StatType: TStatTypeEx);
var i: integer;
begin
  fxml.beginTag(xstat_group);
  fxml.addAttribute(xstat_group_time, Stat.Time_u);
  fxml.addAttribute(xstat_group_nametype, StatNameTypeToString(StatType.NameType));
  fxml.addAttribute(xstat_group_pointtype, StatPointTypeToString(StatType.PointType));
  fxml.addAttribute(xstat_group_first, Stat.first);
  fxml.addAttribute(xstat_group_count, Stat.count);

  if stat.count > length(Stat.Stats) then
    raise Exception.Create('StatToXML_fxml(): Count has an invalid value!');

  for i := 0 to Stat.count-1 do
  begin
    fxml.beginTag(xstat_rank);
    fxml.addAttribute(xstat_rank_position, Stat.first+i);
    fxml.addAttribute(xstat_rank_name, Stat.Stats[i].Name);
    fxml.addAttribute(xstat_rank_points, Stat.Stats[i].Punkte);

    if (Stat.Stats[i].NameId > 0) then
      fxml.addAttribute(xstat_rank_name_id, Stat.Stats[i].NameId);

    case StatType.NameType of
      sntPlayer:
        begin
          if Stat.Stats[i].Ally <> '' then
            fxml.addAttribute(xstat_rank_alliance, Stat.Stats[i].Ally);
          if StatType.PointType = sptFleet then
            fxml.addAttribute(xstat_rank_ships, Stat.Stats[i].Elemente);
        end;
      sntAlliance:
        fxml.addAttribute(xstat_rank_members, Stat.Stats[i].Elemente);
    end;
    fxml.endTag(xstat_rank);
  end;
  fxml.endTag(xstat_group);
end;

function parse_stat(parser: TUnicodeXmlParser; var Stat: TStat;
  var snt: TStatNameType; var spt: TStatPointType): boolean;
var i: integer;

  function parse_xstat_rank: boolean;
  var r: integer;
  begin
    Result := (parser.CurName = xstat_rank);
    if Result then
    begin
      try
        r := StrToInt(parser.attrAsString(xstat_rank_position)) - Stat.first;
        if (r <> i) then raise Exception.Create('invalid!');

        Stat.Stats[r].Name := parser.attrAsString(xstat_rank_name);
        Stat.Stats[r].NameId := StrToInt64Def(parser.attrAsString(xstat_rank_name_id), -1);
        Stat.Stats[r].Punkte := StrToInt64Def(parser.attrAsString(xstat_rank_points), 0);
        case snt of
          sntPlayer:
            begin
              Stat.Stats[r].Ally := parser.attrAsString(xstat_rank_alliance);
              if spt = sptFleet then
                Stat.Stats[r].Elemente := StrToInt64Def(parser.attrAsString(xstat_rank_ships), 0);
            end;
          sntAlliance:
            Stat.Stats[r].Elemente := StrToInt(parser.attrAsString(xstat_rank_members))
        end;
        inc(i);
      except
        parse_error(parser,Format('Rank %d from Stat %d-%d from %s is broken!' +
        ' (%s/%s) Can''t use this stat!',
        [i+Stat.first,Stat.first,Stat.first+99,DateTimeToStr(UnixToDateTime(Stat.Time_u)),
        StatNameTypeToString(snt),StatPointTypeToString(spt)]));
        //Komplette Stat entwerten!!!
        FillChar(Stat,SizeOf(Stat),0);
      end;

      if parser.CurPartType <> ptEmptyTag then
      while (parser.Scan)and(parser.CurPartType <> ptEndTag) do
      begin
        case parser.CurPartType of
          ptStartTag, ptEmptyTag: parse_unknown(parser,False);
        end;
      end;
      
    end;
  end;

begin
  Result := (parser.CurName = xstat_group);
  if Result then
  begin
    FillChar(Stat,SizeOf(Stat),0);
    try
      Stat.Time_u := StrToInt64(parser.attrAsString(xstat_group_time));
      snt := StringToStatNameType(parser.attrAsString(xstat_group_nametype));
      spt := StringToStatpointType(parser.attrAsString(xstat_group_pointtype));
      Stat.first := StrToInt(parser.attrAsString(xstat_group_first));
      Stat.count := StrToIntDef(parser.attrAsString(xstat_group_count), 0);

      if (Stat.first mod 100) <> 1 then raise Exception.Create('Invalid!');
      if Stat.count > 100 then raise Exception.Create('Invalid!');
    except
      parse_error(parser,Format('Stat %d-%d from %s is broken! (%s/%s)',
        [Stat.first,Stat.first+99,DateTimeToStr(UnixToDateTime(Stat.Time_u)),
        StatNameTypeToString(snt),StatPointTypeToString(spt)]));
      FillChar(Stat,SizeOf(Stat),0);
    end;

    i := 0;
    if parser.CurPartType <> ptEmptyTag then
    while (parser.Scan)and(parser.CurPartType <> ptEndTag) do
    begin
      case parser.CurPartType of
        ptStartTag, ptEmptyTag:
          begin
            if not parse_xstat_rank then
              parse_unknown(parser,False);
          end;
      end;
    end;

    if (i <> Stat.count) then
    begin
      parse_error(parser,Format('Stat %d-%d from %s is broken! (%s/%s)',
        [Stat.first,Stat.first+99,DateTimeToStr(UnixToDateTime(Stat.Time_u)),
        StatNameTypeToString(snt),StatPointTypeToString(spt)]));
      FillChar(Stat,SizeOf(Stat),0);
    end;
  end;
end;

function parse_stat(parser: TUnicodeXmlParser): boolean;
var Stat: TStat;
    snt: TStatNameType;
    spt: TStatPointType;
begin
  Result := parse_stat(parser, Stat, snt, spt);
  if Result then
    ODataBase.Statistic.AddStats(snt,spt,Stat);
end;

function FleetJobToString(job: TFleetEventType): string;
begin
  Result := xflt_group_mission_idents[job];
end;

function FleetJobFlagsToString(eflags: TFleetEventFlags): string;
var flag: TFleetEventFlag;
    l: integer;
begin
  Result := '';
  for flag := low(flag) to high(flag) do
    if flag in eflags then
      Result := Result + xflt_group_mission_flag_idents[flag] + ' ';

  l := length(Result);
  if l > 0 then
    SetLength(Result,l-1);
end;

function StringToFleetJobFlags(s: string): TFleetEventFlags;
var flag: TFleetEventFlag;
begin
  Result := [];
  s := s + ' ';
  for flag := low(flag) to high(flag) do
    if pos(xflt_group_mission_flag_idents[flag]+' ',s) > 0 then
      Result := Result + [flag];
end;

function StringToFleetJob(s: String): TFleetEventType;
var fj: TFleetEventType;
    found: Boolean;
begin
  found := false;
  Result := fet_none;
  for fj := low(fj) to high(fj) do
  begin
    if (xflt_group_mission_idents[fj] = s) then
    begin
      Result := fj;
      found := true;
      break;
    end;
  end;
  if (not found) then
    raise Exception.Create('StringToFleetJob: "'+s+'" ist kein gültiger ' +
      'Bezeichner für den Flottenauftrag!');
end;

function FleetToXML_(fleet: TFleetEvent): string;
var ress: TInfoArray;
    i: integer;

    procedure AddAttribute(name, value: string);
    begin
      Result := Result + ' ' + name + '="' + value + '"';
    end;

begin
  Result := '<'+xflt_group;
  AddAttribute(xflt_group_arrivaltime,IntToStr(Fleet.head.arrival_time_u));
  AddAttribute(xflt_group_mission,FleetJobToString(Fleet.head.eventtype));
  AddAttribute(xflt_group_mission_flags,
               FleetJobFlagsToString(Fleet.head.eventflags));
  AddAttribute(xflt_group_player, Fleet.head.player);
  Result := Result + '>';

  Result := Result +
     '<'+xflt_origintag+PlanetPositionToXML_attr(Fleet.head.origin)+'/>'+
     '<'+xflt_targettag+PlanetPositionToXML_attr(Fleet.head.target)+'/>';

  SetLength(ress,ScanFileCounts[sg_rohstoffe]);
  ress[0] := Fleet.ress[0];
  ress[1] := Fleet.ress[1];
  ress[2] := Fleet.ress[2];
  for i := 3 to high(ress) do
    ress[i] := 0;
  Result := Result+ScanPartToXML_IA(ress,sg_Rohstoffe);

  Result := Result+ScanPartToXML_IA(fleet.ships,sg_Flotten);

  Result := Result + '</'+xflt_group+'>';
end;

function parse_fleet(parser: TUnicodeXmlParser; var fleet: TFleetEvent): Boolean;

  function parse_fleet_info: boolean;
  begin
    Result := True;
    if (parser.CurName = xflt_origintag) then
    begin
      Fleet.head.origin := XML_attrToPlanetPosition(parser);
    end
    else
    if (parser.CurName = xflt_targettag) then
    begin
      Fleet.head.target := XML_attrToPlanetPosition(parser);
    end
    else
    if (parse_report_group_AI(parser,sg_Flotten,fleet.ships)) then
    begin
      //weiter nichts zu tun!
    end
    else
    if (parse_report_group_AI(parser,sg_Rohstoffe,Fleet.ress)) then
    begin
      //weiter nichts zu tun!
    end
    else Result := False;


    if Result then
    begin

      if parser.CurPartType <> ptEmptyTag then
      while (parser.Scan)and(parser.CurPartType <> ptEndTag) do
      begin
        case parser.CurPartType of
          ptStartTag, ptEmptyTag: parse_unknown(parser,False);
        end;
      end;

    end;
  end;

begin
  Result := (parser.CurName = xflt_group);
  if Result then
  begin
    FillChar(fleet,SizeOf(fleet),0);   //fleet leeren (Standartwehrte setzen!)
                               //HeadDaten einlesen
    fleet.head.eventflags := StringToFleetJobFlags(
                   parser.attrAsString(xflt_group_mission_flags));
    Fleet.head.eventtype := StringToFleetJob(parser.attrAsString(xflt_group_mission));
    Fleet.head.arrival_time_u := StrToInt64(parser.attrAsString(xflt_group_arrivaltime));
    Fleet.head.player := parser.attrAsString(xflt_group_player);

    if parser.CurPartType <> ptEmptyTag then
    while (parser.Scan)and(parser.CurPartType <> ptEndTag) do
    begin
      case parser.CurPartType of
        ptStartTag, ptEmptyTag:
          begin
            if not parse_fleet_info then
              parse_unknown(parser,False);
          end;
      end;
    end;
  end;
end;

destructor TcSXMLScanner.Destroy;
begin
  Scan.Free;
  inherited;
end;

end.
