unit cS_XML;

interface

uses
  Ogame_Types, inifiles, Classes, SysUtils, XMLDoc, XMLIntf, DateUtils, Prog_Unit, dialogs,
  ImportProgress, LibXmlParser, LibXmlComps, languages, forms;

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
  xsys_planet_moon                 = 'moon';
  xsys_planet_mtemp                = 'mtemp';
  xsys_planet_tfmet                = 'tfmet';
  xsys_planet_tfcrys               = 'tfcrys';
  xsys_planet_name                 = 'name';
  xsys_planet_player               = 'player';
  xsys_planet_alliance             = 'alliance';
  xsys_planet_flags                = 'flags';
  //Scan_XML_idents:
  xspio_group                      = 'report';
  xspio_group_time                 = 'time';
  xspio_group_planet               = 'planet';
  xspio_group_player               = 'player';
  xpsio_group_activity             = 'activ';
  xspio_group_cspio                = 'cspio';     //counterespionage , Spionageabwehr
  xspio_group_creator              = 'creator';
  //Statistic_XML_idents:
  xstat_group                      = 'stats';
  xstat_group_time                 = 'time';
  xstat_group_nametype             = 'ntyp';
  xstat_group_nametype_idents      : array[TStatNameType] of string = (
                                     'player',
                                     'alliance');
  xstat_group_pointtype            = 'ptyp';
  xstat_group_pointtype_idents     : array[TStatPointType] of string = (
                                     'points',
                                     'fleet',
                                     'research');
  xstat_rank                       = 'rank';
  xstat_rank_position              = 'pos';
  xstat_rank_name                  = 'name';
  xstat_rank_points                = 'points';
  xstat_rank_alliance              = 'alliance';
  xstat_rank_members               = 'members';
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
                                     'colonize'
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
    constructor Create(AOwner: TComponent; AODB: TOgameDataBase);
  end;

//procedure ScanToXML(Scan: TScanBericht; XMLFile: TXMLDocument);
//procedure SysToXML(Sys: TSystemCopy; XMLFile: TXMLDocument);
procedure ImportXMLODB_1_slow(Filename: String; ODB: TOgameDataBase);
function XMLToSys(node: IXMLNode): TSystemCopy;
procedure ImportXMLODB_wrong(Filename: String; ODB: TOgameDataBase);
function SysToXML_(sys: TSystemCopy): string;
function parse_Sys(parser: TXmlParser): Boolean; overload;
function parse_Sys(parser: TXmlParser; var solsys: TSystemCopy): Boolean; overload;
procedure parse_error(parser: TXMLParser; msg: string);
function parse_report(parser: TXMLParser): boolean; overload;
function parse_report(parser: TXMLParser; var report: TScanBericht): boolean; overload;
function ScanToXML_(Scan: TScanBericht): String;
function parse_unknown(parser: TXMLParser; parse_known: Boolean): boolean;
procedure ImportXMLODB_(Filename: String; ODB: TOgameDataBase);
function StatToXML_(Stat: TStat; StatType: TStatTypeEx): String;
function parse_stat(parser: TXMLParser; var Stat: TStat;
  var snt: TStatNameType; var spt: TStatPointType): boolean; overload;
function parse_stat(parser: TXMLParser): boolean; overload;
function StatNameTypeToString(t: TStatNameType): string;
function StringToStatNameType(s: string): TStatNameType;
function StatPointTypeToString(t: TStatPointType): string;
function StringToStatPointType(s: string): TStatPointType;
function FleetToXML_(fleet: TFleetEvent): string;
function FleetJobFlagsToString(eflags: TFleetEventFlags): string;
function FleetJobToString(job: TFleetEventType): string;
function PlanetPositionToXML_attr(pos: TPlanetPosition): string;
function ScanPartToXML_(part: TInfoArray; partnr: TScanGroup): string;
function parse_fleet(parser: TXMLParser; var fleet: TFleetEvent): Boolean;
function StringToFleetJobFlags(s: string): TFleetEventFlags;
function StringToFleetJob(s: String): TFleetEventType;
function XML_attrToPlanetPosition(parser: TXMLParser): TPlanetPosition;

implementation

uses Math, ComObj;

function PlanetPositionToXML_attr(pos: TPlanetPosition): string;
begin
  Result := ' '+xpos_gala+'="'+IntToStr(pos.P[0])+'"'+
            ' '+xpos_sys+ '="'+IntToStr(pos.P[1])+'"'+
            ' '+xpos_pos+ '="'+IntToStr(pos.P[2])+'"';
  if pos.Mond then
    Result := Result+' '+xpos_moon+'="true"';
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
      s := Attributes.Value('count');
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
      p := StrToInt(Attributes.Value(xsys_planet_pos));
      with sys.Planeten[p] do
      begin
        PlanetName := Attributes.Value(xsys_planet_name);
        Player := Attributes.Value(xsys_planet_player);
        Ally := Attributes.Value(xsys_planet_alliance);

        s := Attributes.Value(xsys_planet_flags);
        if s <> '' then Status := TStatus(word(StrToInt(s)));

        s := Attributes.Value(xsys_planet_moon);
        if s <> '' then MondSize := StrToInt(s);

        s := Attributes.Value(xsys_planet_mtemp);
        if s <> '' then MondTemp := StrToInt(s);

        s := Attributes.Value(xsys_planet_tfmet);
        if s <> '' then TF[0] := StrToInt(s);

        s := Attributes.Value(xsys_planet_tfcrys);
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
          s := Attributes.Value(xspio_idents[sg][j+1]);
          if s <> '' then
            Scan.Bericht[sg][j] := StrToInt(s)
          else Scan.Bericht[sg][j] := 0;
        end;
      except
        //Fehlerhafter Scan!
        FillChar(Scan.Head,SizeOf(Scan.Head),0);
      end;
    end;
end;

procedure TcSXMLScanner.process_xspio_starttag(Sender: TObject;
  TagName: STRING; Attributes: TAttrList; Empty: Boolean);
var j: integer;
    s: string;
    sg: TScanGroup;
begin
  //Scan Leeren!
  FillChar(Scan.Head,SizeOf(Scan.Head),0);
  for sg := low(sg) to high(sg) do
  begin
    SetLength(Scan.Bericht[sg],ScanFileCounts[sg]);
    for j := 0 to ScanFileCounts[sg]-1 do
      Scan.Bericht[sg][j] := -1;
  end;

  try
    Scan.Head.Position.P[0] := StrToInt(Attributes.Value(xpos_gala));
    Scan.Head.Position.P[1] := StrToInt(Attributes.Value(xpos_sys));
    Scan.Head.Position.P[2] := StrToInt(Attributes.Value(xpos_pos));
    Scan.Head.Position.Mond := Attributes.Value(xpos_moon) = 'true';

    Scan.Head.Time_u := StrToInt64(Attributes.Value(xspio_group_time)); //Unix
  except
    FillChar(Scan.Head.Position,SizeOf(Scan.Head.Position),0);
  end;

  Scan.Head.Planet := Attributes.Value(xspio_group_planet);
  //Attributes[xspio_group_player] := scan.Head.Spieler;

  s := Attributes.Value(xspio_group_cspio);
  if s <> '' then Scan.Head.Spionageabwehr := StrToInt(s);

  Scan.Head.Creator := Attributes.Value(xspio_group_creator);
end;

procedure TcSXMLScanner.process_xspio_endtag(Sender: TObject; TagName: STRING);
begin
  ODB.UniTree.AddNewReport(Scan);
end;

procedure TcSXMLScanner.process_xsys_starttag(Sender: TObject;
  TagName: STRING; Attributes: TAttrList; Empty: Boolean);
begin
  FillChar(Sys,SizeOf(Sys),0);   //Sys leeren (Standartwehrte setzen!)

  try                            //HeadDaten einlesen
    sys.System.P[0] := StrToInt(Attributes.Value(xpos_gala));
    sys.System.P[1] := StrToInt(Attributes.Value(xpos_sys));
    Sys.System.P[2] := 1;

    Sys.Time_u := StrToInt64(Attributes.Value(xsys_group_time));
  except
    FillChar(sys.System,SizeOf(Sys.System),0);
  end;
end;

procedure TcSXMLScanner.process_xsys_endtag(Sender: TObject; TagName: STRING);
begin
  ODB.UniTree.AddNewSolSys(sys);
end;

function SysToXML_(sys: TSystemCopy): string;

procedure attrAdd(var xml: string; attrName, attrValue: string);
begin
  xml := xml + ' ' + attrName + '="' + attrValue + '"';
end;

var i: integer;
    empty: Boolean;
begin
  Result := '<' + xsys_group + ' ' + xpos_gala + '="' + IntToStr(sys.System.P[0]) + '" '
                                   + xpos_sys +  '="' + IntToStr(sys.System.P[1]) + '" '
                             + xsys_group_time + '="' + IntToStr(sys.Time_u) + '"';
  empty := True;
  for i := 1 to max_Planeten do
    if (sys.Planeten[i].Player <> '')or
       (sys.Planeten[i].PlanetName <> '')or  // Zerstörter Planet...
       (Sys.Planeten[i].TF[0] + Sys.Planeten[i].TF[1] > 0) then
      with Sys.Planeten[i] do
      begin
        if empty then //beim ersten planeten, der hinzugefügt wird, solsys-tag schließen!
        begin
          Result := Result + '>';
          empty := False;
        end;
        
        Result := Result + '<' + xsys_planet + ' ' + xsys_planet_pos + '="' + IntToStr(i) + '"';

        if PlanetName <> '' then attrAdd(Result, xsys_planet_name, PlanetName);
        if Player <> '' then attrAdd(Result, xsys_planet_player, Player);
        if Ally <> '' then attrAdd(Result, xsys_planet_alliance, Ally);
        if Status <> [] then attrAdd(Result, xsys_planet_flags, IntToStr(WORD(Status)));

        if (MondSize > 0) then
        begin
          attrAdd(Result, xsys_planet_moon, IntToStr(MondSize));
          attrAdd(Result, xsys_planet_mtemp, FloatToStr(MondTemp));
        end;

        if TF[0] > 0 then attrAdd(Result, xsys_planet_tfmet, IntToStr(TF[0]));
        if TF[1] > 0 then attrAdd(Result, xsys_planet_tfcrys, IntToStr(TF[1]));

        Result := Result + '/>';
      end;

  if empty then Result := Result + '/>' else Result := Result + '</' + xsys_group + '>';
end;

function parse_Sys(parser: TXmlParser): Boolean;
var solsys: TSystemCopy;
begin
  Result := parse_Sys(parser,solsys);
  if Result then
    ODataBase.UniTree.AddNewSolSys(solsys); 
end;

function parse_Sys(parser: TXmlParser; var solsys: TSystemCopy): Boolean;

  function parse_xsys_planet: boolean;
  var p: integer;
      s: string;
  begin
    Result := (parser.CurName = xsys_planet);
    if Result then
    begin
      p := -1;
      try
        p := StrToInt(parser.CurAttr.Value(xsys_planet_pos));
        with solsys.Planeten[p] do
        begin
          PlanetName := parser.CurAttr.Value(xsys_planet_name);
          Player := parser.CurAttr.Value(xsys_planet_player);
          Ally := parser.CurAttr.Value(xsys_planet_alliance);

          s := parser.CurAttr.Value(xsys_planet_flags);
          if s <> '' then Status := TStatus(word(StrToInt(s)));

          s := parser.CurAttr.Value(xsys_planet_moon);
          if s <> '' then MondSize := StrToInt(s);

          s := parser.CurAttr.Value(xsys_planet_mtemp);
          if s <> '' then MondTemp := StrToInt(s);

          s := parser.CurAttr.Value(xsys_planet_tfmet);
          if s <> '' then TF[0] := StrToInt(s);

          s := parser.CurAttr.Value(xsys_planet_tfcrys);
          if s <> '' then TF[1] := StrToInt(s);
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
      solsys.System.P[0] := StrToInt(parser.CurAttr.Value(xpos_gala));
      solsys.System.P[1] := StrToInt(parser.CurAttr.Value(xpos_sys));
      solsys.System.P[2] := 1;

      solsys.Time_u := StrToInt64(parser.CurAttr.Value(xsys_group_time));
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

procedure parse_error(parser: TXMLParser; msg: string);
begin
  raise Exception.Create(msg);
end;

function parse_report(parser: TXMLParser): boolean;
var report: TScanBericht;
begin
  Result := parse_report(parser,report);
  if Result then
    ODataBase.UniTree.AddNewReport(report);
end;

function parse_report_group(parser: TXMLParser; sg: TScanGroup;
  var InfArr: TInfoArray): boolean;
var j: integer;
    s: string;
begin
  Result := parser.CurName = xspio_idents[sg][0];
  if Result then
  begin
    try
      SetLength(InfArr,ScanFileCounts[sg]);
      for j := 0 to ScanFileCounts[sg]-1 do
      begin
        s := parser.CurAttr.Value(xspio_idents[sg][j+1]);
        if s <> '' then
          InfArr[j] := StrToInt(s)
        else InfArr[j] := 0;
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

function XML_attrToPlanetPosition(parser: TXMLParser): TPlanetPosition;
begin
  Result.P[0] := StrToInt(parser.CurAttr.Value(xpos_gala));
  Result.P[1] := StrToInt(parser.CurAttr.Value(xpos_sys));
  Result.P[2] := StrToInt(parser.CurAttr.Value(xpos_pos));
  Result.Mond := parser.CurAttr.Value(xpos_moon) = 'true';
end;

function parse_report(parser: TXMLParser; var report: TScanBericht): boolean;
var j: integer;
    s: string;
    sg: TScanGroup;

  function parse_xspio_idents: Boolean;
  var sg: TScanGroup;
  begin
    for sg := low(sg) to high(sg) do
    begin
      Result := parse_report_group(parser,sg,report.Bericht[sg]);
      if Result then
        break;
    end;
  end;

begin
  Result := (parser.CurName = xspio_group);
  if Result then
  begin
    FillChar(report.Head,SizeOf(report.Head),0);
    
    for sg := low(sg) to high(sg) do
    begin
      SetLength(report.Bericht[sg],ScanFileCounts[sg]);
      for j := 0 to ScanFileCounts[sg]-1 do
        report.Bericht[sg][j] := -1;
    end;

    try
      report.Head.Position := XML_attrToPlanetPosition(parser);
      
      report.Head.Time_u := StrToInt64(parser.CurAttr.Value(xspio_group_time)); //Unix
      report.Head.Planet := parser.CurAttr.Value(xspio_group_planet);
      report.Head.Spieler := parser.CurAttr.Value(xspio_group_player);

      s := parser.CurAttr.Value(xpsio_group_activity);
      if s <> '' then report.Head.Activity := StrToInt(s);
      
      s := parser.CurAttr.Value(xspio_group_cspio);
      if s <> '' then report.Head.Spionageabwehr := StrToInt(s);

      report.Head.Creator := parser.CurAttr.Value(xspio_group_creator);
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

function ScanPartToXML_(part: TInfoArray; partnr: TScanGroup): string;

  procedure attrAdd(attrName, attrValue: string);
  begin
    Result := Result + ' ' + attrName + '="' + attrValue + '"';
  end;

var j: integer;
begin
  Result := '<'+xspio_idents[partnr][0];

  for j := 0 to ScanFileCounts[partnr]-1 do
  begin
    if part[j] <> 0 then
      attrAdd(xspio_idents[partnr][j+1],IntToStr(part[j]));
  end;

  Result := Result+'/>';
end;

function ScanToXML_(Scan: TScanBericht): String;

  procedure attrAdd(attrName, attrValue: string);
  begin
    Result := Result + ' ' + attrName + '="' + attrValue + '"';
  end;

var empty: Boolean;
    sg: TScanGroup;
begin
  Result := '<'+xspio_group+
            PlanetPositionToXML_attr(Scan.Head.Position);

  attrAdd(xspio_group_time,IntToStr(Scan.Head.Time_u)); //Unix
  attrAdd(xspio_group_planet,Scan.Head.Planet);
  attrAdd(xspio_group_player,Scan.Head.Spieler);
  attrAdd(xpsio_group_activity,IntToStr(Scan.Head.Activity));
  attrAdd(xspio_group_cspio,IntToStr(Scan.Head.Spionageabwehr));
  attrAdd(xspio_group_creator,Scan.Head.Creator);

  empty := true;
  for sg := low(sg) to high(sg) do
  begin
    if Scan.Bericht[sg][0] <> -1 then
    begin
      if empty then //beim ersten Bereich, der hinzugefügt wird, report-tag schließen!
      begin
        Result := Result + '>';
        empty := False;
      end;

      Result := Result + ScanPartToXML_(Scan.Bericht[sg],sg);
    end;
  end;
  if empty then Result := Result + '/>' else Result := Result + '</' + xspio_group + '>';
end;

function parse_unknown(parser: TXMLParser; parse_known: Boolean): boolean;
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
var parser: TXmlParser;
begin
  parser := TXmlParser.Create;
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

  procedure attrAdd(var xml: string; attrName, attrValue: string);
  begin
    xml := xml + ' ' + attrName + '="' + attrValue + '"';
  end;

var empty: Boolean;
    i: integer;
begin
  empty := True;
  Result := '<' + xstat_group + ' ' +
    xstat_group_time + '="' + IntToStr(Stat.Time_u) + '" ' +
    xstat_group_nametype + '="' +
    StatNameTypeToString(StatType.NameType) + '" ' +
    xstat_group_pointtype + '="' +
    StatPointTypeToString(StatType.PointType) + '"';
  for i := 0 to length(Stat.Stats)-1 do
    if Stat.Stats[i].Name <> '' then
    begin
      if empty then
      begin
        empty := False;
        Result := Result + '>';
      end;

      Result := Result + '<' + xstat_rank + ' ' + xstat_rank_position + '="' +
        IntToStr(Stat.first+i) + '" ' + xstat_rank_name + '="' +
        Stat.Stats[i].Name + '" ' + xstat_rank_points + '="' +
        IntToStr(Stat.Stats[i].Punkte) + '"';

      case StatType.NameType of
      sntPlayer:
        if Stat.Stats[i].Ally <> '' then
          attrAdd(Result, xstat_rank_alliance, Stat.Stats[i].Ally);
      sntAlliance:
        attrAdd(Result,xstat_rank_members,IntToStr(Stat.Stats[i].Mitglieder));
      end;
      Result := Result + '/>';
    end;

  if empty then
    Result := Result + '/>'
  else Result := Result + '</stats>';
end;

function parse_stat(parser: TXMLParser; var Stat: TStat;
  var snt: TStatNameType; var spt: TStatPointType): boolean;

  function parse_xstat_rank: boolean;
  var r: integer;
  begin
    Result := (parser.CurName = xstat_rank);
    if Result then
    begin
      r := -1;
      try
        r := StrToInt(parser.CurAttr.Value(xstat_rank_position)) - Stat.first;

        if Stat.first = 0 then
        begin
          Stat.first := r;
          r := 0;
        end;

        Stat.Stats[r].Name := parser.CurAttr.Value(xstat_rank_name);
        Stat.Stats[r].Punkte := StrToInt64(parser.CurAttr.Value(xstat_rank_points));
        case snt of
          sntPlayer:
            Stat.Stats[r].Ally := parser.CurAttr.Value(xstat_rank_alliance);
          sntAlliance:
            Stat.Stats[r].Mitglieder := StrToInt(parser.CurAttr.Value(xstat_rank_members))
        end;
      except
        parse_error(parser,Format('Rank %d from Stat %d-%d from %s is broken!' +
        ' (%s/%s) Can''t use this stat!',
        [r+Stat.first,Stat.first,Stat.first+99,DateTimeToStr(UnixToDateTime(Stat.Time_u)),
        StatNameTypeToString(snt),StatPointTypeToString(spt)]));
        //Komplette Stat entwehrten!!!
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
  //!!!!!!!!!!!!!!!!!!!!!!!!!! not tested jet !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  Result := (parser.CurName = xstat_group);
  if Result then
  begin
    FillChar(Stat,SizeOf(Stat),0);
    try
      Stat.Time_u := StrToInt64(parser.CurAttr.Value(xstat_group_time));
      snt := StringToStatNameType(parser.CurAttr.Value(xstat_group_nametype));
      spt := StringToStatpointType(parser.CurAttr.Value(xstat_group_pointtype));
    except
      parse_error(parser,Format('Stat %d-%d from %s is broken! (%s/%s)',
        [Stat.first,Stat.first+99,DateTimeToStr(UnixToDateTime(Stat.Time_u)),
        StatNameTypeToString(snt),StatPointTypeToString(spt)]));
      FillChar(Stat,SizeOf(Stat),0);
    end;

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
  end;
end;

function parse_stat(parser: TXMLParser): boolean;
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
  AddAttribute(xflt_group_player,Fleet.head.player);
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
  Result := Result+ScanPartToXML_(ress,sg_Rohstoffe);
  
  Result := Result+ScanPartToXML_(fleet.ships,sg_Flotten);

  Result := Result + '</'+xflt_group+'>';
end;

function parse_fleet(parser: TXMLParser; var fleet: TFleetEvent): Boolean;

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
    if (parse_report_group(parser,sg_Flotten,fleet.ships)) then
    begin
      //weiter nichts zu tun!
    end
    else
    if (parse_report_group(parser,sg_Rohstoffe,Fleet.ress)) then
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
                   parser.CurAttr.Value(xflt_group_mission_flags));
    Fleet.head.eventtype := StringToFleetJob(parser.CurAttr.Value(xflt_group_mission));
    Fleet.head.arrival_time_u := StrToInt64(parser.CurAttr.Value(xflt_group_arrivaltime));
    Fleet.head.player := parser.CurAttr.Value(xflt_group_player);

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

end.
