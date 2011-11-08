unit _test_POST;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, OGame_Types, StdCtrls, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdHTTP, IdURI, DateUtils, cS_XML, XMLDoc, xmldom,
  XMLIntf, msxmldom, shellapi, ExtCtrls, clientlogin, IdAuthentication,
  ComCtrls, xml_parser_unicode, Prog_unit, Spin, Inifiles, html, Stat_Points;

type
  TStatsPartTime = class
  public
    time: Int64;
  end;
  TStatsPartTimes = class
  private
    fTimes: TList;
    function getTimes(i: integer): Int64;
    procedure setTimes(i: integer; const Value: Int64);
  public
    property times[i: integer]: Int64 read getTimes write setTimes; default;
    function Count: integer;
    constructor Create;
    destructor Destroy; override;
  end;
  TTimeID = record
    time_u: int64;
    id: int64;
  end;
  TFRM_POST_TEST = class(TForm)
    txt_url: TEdit;
    Button4: TButton;
    TXT_ges: TEdit;
    Label2: TLabel;
    TXT_post: TEdit;
    Label3: TLabel;
    Button9: TButton;
    mem_log_all: TMemo;
    pb_pos: TProgressBar;
    Label1: TLabel;
    Label5: TLabel;
    pb_main: TProgressBar;
    Button1: TButton;
    Button2: TButton;
    Panel1: TPanel;
    LBL_sys: TLabel;
    Label4: TLabel;
    LBL_scan: TLabel;
    mem_send: TMemo;
    BTN_genSys: TButton;
    BTN_POST_: TButton;
    mem_recv: TMemo;
    Button3: TButton;
    CH_Auto: TCheckBox;
    CH_Pause: TCheckBox;
    SpinEdit1: TSpinEdit;
    Button5: TButton;
    Button6: TButton;
    BTN_genScan: TButton;
    Button8: TButton;
    IdHTTP1: TIdHTTP;
    Timer1: TTimer;
    CheckBox1: TCheckBox;
    mem_log: TMemo;
    Button7: TButton;
    Button10: TButton;
    se_max_days_age: TSpinEdit;
    Label6: TLabel;
    cb_filter_no_planet: TCheckBox;
    Button11: TButton;
    Button12: TButton;
    procedure BTN_genSysClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure IdHTTP1Authorization(Sender: TObject;
      Authentication: TIdAuthentication; var Handled: Boolean);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure BTN_genScanClick(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BTN_POST_Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
  private
    FServerUni: array of array of TTimeID;
    more: Boolean;
    sessionid: string;
    procedure parseError(parser: TUnicodeXmlParser);
    function ReadServerUni(p1, p2: word): TTimeID;
    procedure WriteServerUni(p1, p2: word; value: TTimeID);
    procedure PostAndParseAnswer(read, write: string);
    { Private-Deklarationen }
  public
    System: TSystemCopy;
    Scan: TScanbericht;
    Stop: Boolean;
    main_pc_start, main_pc_end: integer;
    procedure log(msg: string; priority: integer);
    procedure SetProgress(pc: integer);
    procedure SetMainProgress(pc_start, pc_end: integer);
    property ServerUni[p1,p2 : word]: TTimeID read ReadServerUni write WriteServerUni;
    function do_login(user, pass: string): Boolean;
    function SysToXMLString(sys: TSystemCopy; csvers: string): string;
    function ScanToXMLString(Scan: TScanBericht; csvers: string): string;
    function entflines(s: string): String;
    procedure SetServerUniSize(gala: integer; solsys: integer);
    function ParseAnswer(xml_utf8: AnsiString): boolean;
    procedure Sync_Report(gala: Integer);
    procedure Sync_Systems(Sender: TObject);
    procedure POST(param: string = '');
    procedure Sync_Stats(typ: TStatTypeEx);
  end;

var
  FRM_POST_TEST: TFRM_POST_TEST;

function GetPlanetReportList(Pos: TPlanetPosition; since_u: int64): TReportTimeList;

implementation

uses main, Math, RTLConsts, LibXmlParser, cS_utf8_conv;

{$R *.dfm}

procedure TFRM_POST_TEST.BTN_genSysClick(Sender: TObject);
begin
  mem_send.Clear;
  mem_send.Lines.Add('<write>' + entflines(SysToXMLString(System, '9.9')) + '</write>');
end;

function TFRM_POST_TEST.SysToXMLString(sys: TSystemCopy; csvers: string): string;
begin
  Result := {AnsiToUtf8}(SysToXML_(sys, csvers));
//  Result := StringReplace(Result,'&','', [rfReplaceAll]);
end;

function TFRM_POST_TEST.ScanToXMLString(Scan: TScanBericht; csvers: string): string;
begin
  Result := {AnsiToUtf8}(ScanToXML_(Scan, csvers));
//  Result := StringReplace(Result,'&','', [rfReplaceAll]);
end;

function TFRM_POST_TEST.entflines(s: string): String;
var p: integer;
begin
  p := pos(#13,s);
  while p > 0 do
  begin
    s[p] := #32;
    p := pos(#13,s);
  end;
  Result := s;
end;

procedure TFRM_POST_TEST.Button3Click(Sender: TObject);
begin
  mem_recv.Lines.SaveToFile('Response.html');
  ShellExecute(Handle,'Open','Response.html','','',0)
end;

procedure TFRM_POST_TEST.Timer1Timer(Sender: TObject);
begin
  if (System.System.P[0] <> FRM_Main.DockExplorer.System.System.P[0]) or
     (System.System.P[1] <> FRM_Main.DockExplorer.System.System.P[1]) then
  begin
    System := FRM_Main.DockExplorer.System;
    LBL_sys.Caption := PositionToStr_(System.System);
    if CH_Auto.Checked then
    begin
      BTN_genSysClick(self);
      POST;
    end;
  end;
  if (not SamePlanet(Scan.Head.Position,FRM_Main.Frame_Bericht1.Bericht.Head.Position))or
     (Scan.Head.Time_u <> FRM_Main.Frame_Bericht1.Bericht.Head.Time_u) then
  begin
    Scan.copyFrom(FRM_Main.Frame_Bericht1.Bericht);
    LBL_scan.Caption := PositionToStrMond(Scan.Head.Position);
    if CH_Auto.Checked then
    begin
      BTN_genScanClick(self);
      POST;
    end;
  end;
end;

procedure TFRM_POST_TEST.IdHTTP1Authorization(Sender: TObject;
  Authentication: TIdAuthentication; var Handled: Boolean);
var frm: TFRM_ClientLogin;
begin
  frm := TFRM_ClientLogin.Create(self);
  frm.LBL_Servername.Caption := txt_url.Text;
  frm.LBL_IP_Port.Caption := 'http_POST';
  if frm.ShowModal = mrOK then
  begin
    Authentication.Username := frm.TXT_Username.Text;
    Authentication.Password := frm.TXT_Pass.Text;
    Handled := True;
  end;
  frm.free;
end;

procedure TFRM_POST_TEST.log(msg: string; priority: integer);
begin
  if priority >= 10 then
  begin
    mem_log.lines.add(DateTimeToStr(now()) + ': ' + msg);
  end;
  mem_log_all.lines.add(DateTimeToStr(now()) +
                 '(prio: '+IntToStr(priority)+'): ' + msg);
end;

procedure TFRM_POST_TEST.Sync_Systems(Sender: TObject);
var parser: TUnicodeXmlParser;
    DocSize: Integer;
//    snow: int64;
    pos: array[0..2] of word;
    p1, p2, i: integer;
    read, write: string;
    start: Tdatetime;
    tid: TTimeID;

    gotServerInfo: Boolean;
    csvers: string;
begin
  csvers := '0.6';
  start := now;
  gotServerInfo := false;

  log('sync solar systems...',10);

  mem_send.Clear;
  mem_send.Lines.Add('<read><serverinfo/><solsystimes_timestamp/></read>');

  POST;
  DocSize := length(mem_recv.Lines.Text);

  log('got times, parse...',10);

  SetMainProgress(0,10);

  parser := TUnicodeXmlParser.Create;
  try
    parser.LoadFromBuffer(PAnsiChar(UTF8Encode(mem_recv.Lines.Text)));
    parser.StartScan;
    while parser.Scan and (not stop) do
    begin
      SetProgress(trunc((parser.CurFinal - parser.DocBuffer) / DocSize * 100.0));

      case parser.CurPartType of
        ptStartTag, ptEmptyTag:
          begin

            if parser.CurName = 'serverinfo' then
            begin
              csvers := parser.attrAsString('csvers');
              pos[0] := parser.attrAsInt('galacount');
              pos[1] := parser.attrAsInt('syscount');
              pos[2] := parser.attrAsInt('planetcount');
              if (pos[0] <> max_Galaxy)or(pos[1] <> max_Systems)or(pos[2] <> max_Planeten) then
                raise Exception.Create('Server pos_count definitions are not compatible!')
              else SetServerUniSize(max_Galaxy, max_Systems);

              gotServerInfo := true;
            end;

            if parser.CurName = 'solsystime' then
            begin
              pos[0] := parser.attrAsInt('gala');
              pos[1] := parser.attrAsInt('sys');
              tid.time_u := parser.attrAsInt64('time');
              ServerUni[pos[0],pos[1]] := tid;
            end;

            if parser.CurName = 'error' then
            begin
              parseError(parser);
            end;

          end;
      end;
    end;
  finally
    parser.Free;
  end;

  if not gotServerInfo then
  begin
    raise Exception.Create('SyncSystems: Error: Expected "ServerInfo" tag!');
  end;

  if stop then exit;

  SetMainProgress(10,40);

  log('do sync...',10);

  read := '';
  write := '';
  i := 0;
  pb_pos.Max := 100;
  for p1 := 1 to max_Galaxy do
  begin
    for p2 := 1 to max_Systems do
    begin

      if ServerUni[p1,p2].time_u > ODataBase.GetSystemTime_u(p1,p2) then
      begin
        read := read + Format('<solsys_pos gala="%d" sys="%d"/>', [p1,p2]);
        log(Format('get solsys [%d:%d]',[p1, p2]),10);
      end else
      if ServerUni[p1,p2].time_u < ODataBase.GetSystemTime_u(p1,p2) then
      begin
        if (ODataBase.Uni[p1,p2].SystemCopy >= 0) then
        begin
          write := write + SysToXMLString(
            ODataBase.Systeme[ODataBase.Uni[p1,p2].SystemCopy], csvers);
          log(Format('send solsys [%d:%d]',[p1, p2]),10);
        end;
      end;

      inc(i);
      if (i > SpinEdit1.Value)or(p2 = max_systems) then
      begin
        PostAndParseAnswer(read,write);

        i := 0;
        read := '';
        write := '';
      end;

      SetProgress(trunc((((p1-1)*max_Systems + p2)/(max_Galaxy*max_Systems))*100));

      if stop then break;
    end;
    if stop then break;
  end;

  SetServerUniSize(0,0);

  log('solar systems ready!',10);

  TXT_ges.Text := TimeToStr(Now-start);
end;

procedure TFRM_POST_TEST.Sync_Stats(typ: TStatTypeEx);
var parser: TUnicodeXmlParser;
    partnr, partcount, i, mpc_start: integer;
    read, write: string;
    start: Tdatetime;
    pos: array[0..2] of integer;

    gotServerInfo: Boolean;
    csvers: string;

    servertimes: TStatsPartTimes;
    clienttimes: TStatPoints;
    clientpart_time: Int64;
begin
  clienttimes := ODataBase.Statistic.StatisticType[typ.NameType, typ.PointType];
  log('sync statistics: ' + xstat_group_nametype_idents[typ.NameType] + '/' +
    xstat_group_pointtype_idents[typ.PointType],10);
  csvers := '0.6';
  start := now;
  gotServerInfo := false;
  servertimes := TStatsPartTimes.Create;
  try
    mem_send.Clear;
    mem_send.Lines.Add('<read><serverinfo/><statstimes_type ntype="' +
      xstat_group_nametype_idents[typ.NameType] + '" ptype="' +
      xstat_group_pointtype_idents[typ.PointType] + '"/></read>');

    POST;

    log('got times, parse...',10);

    case typ.NameType of
    sntPlayer: mpc_start := 80;
    sntAlliance: mpc_start := 90;
    else
    mpc_start := 0;
    end;

    case typ.PointType of
    sptPoints: SetMainProgress(mpc_start,mpc_start+3);
    sptFleet: SetMainProgress(mpc_start+3,mpc_start+7);
    sptResearch: SetMainProgress(mpc_start+7,mpc_start+10);
    end;

    SetProgress(0);

    parser := TUnicodeXmlParser.Create;
    try
    parser.LoadFromBuffer(PAnsiChar(UTF8Encode(mem_recv.Lines.Text)));
      parser.StartScan;
      while parser.Scan and (not stop) do
      begin
        case parser.CurPartType of
          ptStartTag, ptEmptyTag:
            begin

              if parser.CurName = 'serverinfo' then
              begin
                csvers := parser.attrAsString('csvers');
                pos[0] := parser.attrAsInt('galacount');
                pos[1] := parser.attrAsInt('syscount');
                pos[2] := parser.attrAsInt('planetcount');
                if (pos[0] <> max_Galaxy)or(pos[1] <> max_Systems)or(pos[2] <> max_Planeten) then
                  raise Exception.Create('Server pos_count definitions are not compatible!')
                else SetServerUniSize(max_Galaxy, max_Systems);

                gotServerInfo := true;
              end;

              if parser.CurName = 'statstimes_type' then
              begin
                if (parser.attrAsString('ntype') <> xstat_group_nametype_idents[typ.NameType]) or
                   (parser.attrAsString('ntype') <> xstat_group_nametype_idents[typ.NameType]) then
                  raise Exception.Create('SyncStats: protokoll error, answer types doesn''t match!');
              end;

              if parser.CurName = 'statstime' then
              begin
                partnr := parser.attrAsInt('partnr');
                servertimes[partnr] := parser.attrAsInt('time');
              end;

              if parser.CurName = 'error' then
              begin
                parseError(parser);
              end;

            end;
        end;
      end;
    finally
      parser.Free;
    end;

    if not gotServerInfo then
    begin
      raise Exception.Create('SyncStats: Error: Expected "ServerInfo" tag!');
    end;

    if csvers < '0.7' then
    begin
      log('statistics not supported by server!', 10);
      exit;
    end;

    if stop then exit;

    log('do sync...',10);

    read := '';
    write := '';
    partcount := servertimes.Count;
    if partcount < clienttimes.Count then
      partcount := clienttimes.Count;

    pb_pos.Max := 100;
    i := 0;
    for partnr := 0 to partcount-1 do
    begin
      clientpart_time := clienttimes.PartTime_u(partnr);
      if servertimes[partnr] > clientpart_time then
      begin
        read := read + Format('<stats_type partnr="%d" ntype="%s" ptype="%s"/>',
           [partnr,
           xstat_group_nametype_idents[typ.NameType],
           xstat_group_pointtype_idents[typ.PointType]]);
        log(Format('get stats [%d,%s,%s]',[partnr,
           xstat_group_nametype_idents[typ.NameType],
           xstat_group_pointtype_idents[typ.PointType]]),10);
      end else
      if servertimes[partnr] < clientpart_time then
      begin
        if (clientpart_time > 0) then
        begin
          write := write + StatToXML_(clienttimes.Stats[partnr], typ);
          log(Format('send stats [%d,%s,%s]',[partnr,
             xstat_group_nametype_idents[typ.NameType],
             xstat_group_pointtype_idents[typ.PointType]]),10);
        end;
      end;

      inc(i);
      if (i > 2)or // genug gesammelt?
         (partnr = partcount-1) then // oder ende erreicht?
      begin
        PostAndParseAnswer(read,write);

        i := 0;
        read := '';
        write := '';
      end;

      SetProgress(trunc(((partnr+1)/(partcount))*100));

      if stop then break;
    end;

    SetProgress(100);
    log('stats sync ready!',10);

    TXT_ges.Text := TimeToStr(Now-start);
  finally
    servertimes.Free;
  end;
end;

function TFRM_POST_TEST.ReadServerUni(p1, p2: word): TTimeID;
begin
  if (p1 >= 1)and(p1 <= max_Galaxy)and(p2 >= 1)and(p2 <= max_Systems) then
    Result := FServerUni[p1-1,p2-1]
  else raise Exception.Create(Format('API: ReadServerUni. coordinates(%d:%d) out of valid range(%d:%d)!',[p1,p2,max_Galaxy,max_Systems]));
end;

procedure TFRM_POST_TEST.WriteServerUni(p1, p2: word; value: TTimeID);
begin
  if (p1 >= 1)and(p1 <= max_Galaxy)and(p2 >= 1)and(p2 <= max_Systems) then
    FServerUni[p1-1,p2-1] := value
  else raise Exception.Create(Format('API: ReadServerUni. coordinates(%d:%d) out of valid range(%d:%d)!',[p1,p2,max_Galaxy,max_Systems]));
end;

procedure TFRM_POST_TEST.SetMainProgress(pc_start, pc_end: integer);
begin
  main_pc_start := pc_start;
  main_pc_end := pc_end;
  pb_main.Position := pc_start;
end;

procedure TFRM_POST_TEST.SetProgress(pc: integer);
var new: integer;
begin
  if pc <> pb_pos.Position then
    pb_pos.Position := pc;

  new := main_pc_start + ((main_pc_end - main_pc_start)*pc div 100);
  if new <> pb_main.Position then
    pb_main.Position := new;
end;

procedure TFRM_POST_TEST.SetServerUniSize(gala: integer; solsys: integer);
var i,j: integer;
begin
  SetLength(FServerUni,gala);
  for i := 0 to gala-1 do
  begin
    SetLength(FServerUni[i], solsys);
    for j := 0 to solsys-1 do
    begin
      FServerUni[i,j].time_u := -1; //  n/a
      FServerUni[i,j].id := -1;
    end;
  end;
end;

procedure TFRM_POST_TEST.Button5Click(Sender: TObject);
var j: integer;
    s: string;
    sg: TScanGroup;
const n = #13 + #10;
begin
  s :=
'CREATE TABLE `'+xsys_group+'` (' + n +
'  `ID` bigint(20) unsigned NOT NULL auto_increment,' + n +
'  `'+xpos_gala+'` smallint(6) unsigned NOT NULL,' + n +
'  `'+xpos_sys+'` smallint(6) unsigned NOT NULL,' + n +
'  `'+xsys_group_time+'` bigint(20) unsigned NOT NULL default ''0'',' + n +
'  `timestamp` bigint(20) unsigned NOT NULL default ''0'',' + n +
'  PRIMARY KEY  (`ID`)' + n +
') ENGINE=MyISAM;' + n + n +

'CREATE TABLE `'+xsys_planet+'` (' + n +
'  `'+xsys_planet_pos+'` smallint(5) unsigned NOT NULL,' + n +
'  `'+xsys_planet_moon+'` smallint(5) unsigned NOT NULL default ''0'',' + n +
'  `'+xsys_planet_mtemp+'` float NOT NULL default ''0'',' + n +
'  `'+xsys_planet_tfmet+'` int(10) unsigned NOT NULL default ''0'',' + n +
'  `'+xsys_planet_tfcrys+'` int(10) unsigned NOT NULL default ''0'',' + n +
'  `'+xsys_planet_name+'` varchar(25) NOT NULL,' + n +
'  `'+xsys_planet_player+'` varchar(25) NOT NULL,' + n +
'  `'+xsys_planet_alliance+'` varchar(10) NOT NULL,' + n +
'  `'+xsys_planet_flags+'` smallint(5) unsigned NOT NULL default ''0'',' + n +
'  `'+xsys_group+'ID` bigint(20) unsigned NOT NULL,' + n +
'  PRIMARY KEY  (`'+xsys_planet_pos+'`,`'+xsys_group+'ID`)' + n +
') ENGINE=MyISAM;' + n + n +

'CREATE TABLE `'+xspio_group+'` (' + n +
'  `ID` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY ,' + n +
'  `'+xpos_gala+'` SMALLINT UNSIGNED NOT NULL ,' + n +
'  `'+xpos_sys+'` SMALLINT UNSIGNED NOT NULL ,' + n +
'  `'+xpos_pos+'` SMALLINT UNSIGNED NOT NULL ,' + n +
'  `'+xpos_moon+'` BOOL NOT NULL DEFAULT ''0'',' + n +
'  `'+xspio_group_time+'` BIGINT UNSIGNED NOT NULL ,' + n +
'  `'+xspio_group_planet+'` VARCHAR( 25 ) NOT NULL ,' + n +
'  `'+xspio_group_cspio+'` TINYINT NOT NULL DEFAULT ''0'',' + n +
'  `'+xspio_group_creator+'` VARCHAR( 25 ) NOT NULL' + n +
') TYPE = MYISAM;' + n + n;
  for sg := low(sg) to high(sg) do
  begin
    s := s + 'CREATE TABLE `' + xspio_idents[sg][0] + '` (' +  n +
             '`'+xspio_group+'ID` BIGINT UNSIGNED,' + n;
    for j := 1 to length(xspio_idents[sg])-1 do
    begin
      s := s + '`' + xspio_idents[sg][j] + '` INT UNSIGNED DEFAULT ''0'',' + n;
    end;
    s := s + 'PRIMARY KEY ( `'+xspio_group+'ID` )' + n +
             ') TYPE = MYISAM;' + n + n;
  end;
  mem_send.Lines.Text := s;
end;

function TFRM_POST_TEST.ParseAnswer(xml_utf8: AnsiString): boolean;
var parser: TUnicodeXmlParser;
begin
  Result := true;
  parser := TUnicodeXmlParser.Create;
  parser.LoadFromBuffer(PAnsiChar(xml_utf8));
  parser.StartScan;
  if Parser.Scan then
  repeat
    case Parser.CurPartType of
      ptStartTag, ptEmptyTag:
        begin
          if parser.CurName = 'read' then
          begin
            parse_unknown(parser, true);
          end;
          if parser.CurName = 'error' then
          begin
            parseError(parser);
          end;
        end;
    end;
  until (not Parser.Scan);
  parser.Free;
end;

procedure TFRM_POST_TEST.Button6Click(Sender: TObject);
begin
  ParseAnswer(trnsltoUTF8(mem_recv.Lines.Text));
end;

procedure TFRM_POST_TEST.BTN_genScanClick(Sender: TObject);
begin
  mem_send.Clear;
  mem_send.Lines.Add('<write>' + entflines(ScanToXMLString(Scan, '9.9')) + '</write>');
end;

procedure TFRM_POST_TEST.Button8Click(Sender: TObject);
var parser: TUnicodeXmlParser;
begin
  parser := TUnicodeXmlParser.Create;
  parser.LoadFromBuffer(PAnsiChar(UTF8Encode(mem_recv.Lines.Text)));
  parser.StartScan;
  while parser.Scan do
    case parser.CurPartType of
      ptStartTag, ptEmptyTag: parse_unknown(parser,False);
    end;
  parser.Free;
end;

procedure TFRM_POST_TEST.Sync_Report(gala: Integer);
var read, write: string;
    p_count: Integer;
    pos: TPlanetPosition;
    since_u: int64;
    csvers: string;

  procedure SetPositionProgress(sys: integer);
  var next: integer;
  begin
    next := (sys*100) div max_Systems;
    SetProgress(next);
  end;

  type TSendIDTyp = (sit_none, sit_get, sit_send);
  procedure SendID(typ: TSendIDTyp; id: integer);
  var scan: TScanBericht;
  begin
    if Stop then
      raise Exception.Create('User STOP');

    case typ of
      sit_none:;  //nix!
      sit_get:
        begin  //anfragen! id bezieht sich auf die serverseitige db

          log('get report id(S' + IntToStr(id) + ') [' +
               PositionToStrMond(pos) + ']', 10);

          read := read + '<report_id id="' + IntToStr(id) + '"/>';
        end;
      sit_send:
        begin  //senden! id bezieht sich auf die lokale db
          scan := ODataBase.Berichte[id]; // this assignment is ok!

          log('send report id(C' + IntToStr(id) + ') [' +
               PositionToStrMond(scan.Head.Position) + ']', 10);

          write := write + ScanToXMLString(scan, csvers);
        end;
    end;
    if typ <> sit_none then inc(p_count);
    if p_count >= SpinEdit1.Value then
    begin
      PostAndParseAnswer(read, write);
      read := '';
      write := '';
      p_count := 0;
    end;
  end;

  procedure SendReports_between(begin_at, end_before: integer);
  var list: TReportTimeList;
      ap, li: integer;
      pos: TPlanetPosition;
  begin
    list := nil; // suppress warning
    
    if begin_at > end_before then
      raise Exception.Create('SendReports_between(pos1 > pos2)');

    for ap := begin_at to end_before - 1 do
    begin
      pos := AbsPlanetNrToPlanetPosition(ap);
      SetPositionProgress(pos.P[1]);

      list := GetPlanetReportList(pos, since_u);
      for li := 0 to length(list)-1 do
      begin
        SendID(sit_send, list[li].ID);
      end;
    end;
  end;

var root, sinfo, times, planet, rtime: THTMLElement;
    abspos, labspos: Integer;
//    snow: int64;
    uni_pos: array[0..2] of word;
    i, j, sl: integer;
    start: Tdatetime;

    time_u: Int64;
    ScanList: TReportTimeList;
    solsys: TSystemCopy;
    solsysindex: integer;
    s: string;
begin
  csvers := '0.6';
  ScanList := nil; // suppress warning
  solsysindex := -1; // suppress warning

  solsys.System.P[1] := 0; // mark invalid!
  
  log('start sync reports, gala ' + IntToStr(gala),10);

  read := '';
  write := '';

  SetMainProgress(40 + (((gala-1) * 40) div max_Galaxy),
                  40 + ((gala * 40) div max_Galaxy));
  SetProgress(0);

  start := now;
  since_u := DateTimeToUnix(now - se_max_days_age.Value);

  mem_send.Clear;
  s := '<read><serverinfo/><reporttimes_gala' +
       ' gala="' + inttostr(gala) + '"' +
       ' since="' + inttostr(since_u) + '"' +
       '/></read>';

  mem_send.Lines.Add(s);
  log('send request: ' + s,0);
  POST;
  log('request ready, start sync...',0);

  root := THTMLElement.Create(nil, 'root');
  try
    root.ParseHTMLCode(mem_recv.Lines.Text);

    sinfo := root.FindChildTagPath_e('read/serverinfo');
    if sinfo = nil then
      raise Exception.Create('Sync_Reports(): answer to serverinfo is missing!');
      
//    snow := StrToInt64(sinfo.AttributeValue['time']);
    Uni_pos[0] := StrToInt(sinfo.AttributeValue['galacount']);
    Uni_pos[1] := StrToInt(sinfo.AttributeValue['syscount']);
    Uni_pos[2] := StrToInt(sinfo.AttributeValue['planetcount']);

    csvers := sinfo.AttributeValue['csvers'];

    if (Uni_pos[0] <> max_Galaxy)or
       (Uni_pos[1] <> max_Systems)or
       (Uni_pos[2] <> max_Planeten) then
      raise Exception.Create('Sync_Reports(): Server definitions for universe dimension sizes are not compatible!');

    log('check serverinfo completed',0);

    times := root.FindChildTagPath_e('read/reporttimes');
    if times = nil then
      raise Exception.Create('Sync_Reports(): answer to reporttimes is missing!');

    if times.AttributeValue['gala'] <> inttostr(gala) then
      raise Exception.Create('Sync_Reports(): Error: wrong galaxy in response!');

    pos.P[0] := gala;
    pos.P[1] := 1;
    pos.P[2] := 1;
    pos.Mond := false;

    // Start Sync:

    abspos := PlanetPositionToAbsPlanetNr(pos);

    for i := 0 to times.ChildCount - 1 do
    begin
      planet := times.ChildElements[i];

      labspos := abspos;
      pos.P[1] := StrToInt(planet.AttributeValue['sys']);
      pos.P[2] := StrToInt(planet.AttributeValue['pos']);
      pos.Mond := (planet.AttributeValue['moon'] = 'true');
      abspos := PlanetPositionToAbsPlanetNr(pos);

      SendReports_between(labspos, abspos);
      ScanList := GetPlanetReportList(Pos, since_u);
      if (solsys.System.P[0] <> pos.P[0])or // hole neues sonnensystem nur wenn nötig
         (solsys.System.P[1] <> pos.P[1]) then
      begin
        solsysindex := ODataBase.UniTree.UniSys(pos.p[0], pos.P[1]);
        if (solsysindex >= 0) then
        begin
          solsys := ODataBase.Systeme[solsysindex];
        end
        else
        begin
          solsys.System.P[0] := pos.P[0];
          solsys.System.P[1] := pos.P[1];
        end;
      end;

      if (not cb_filter_no_planet.Checked)or // wenn nicht filter aktiv
         (solsysindex < 0)or // oder solsys nicht vorhanden
         (solsys.Planeten[pos.P[2]].Player <> '') then  // oder filter greift nicht, dann sync!
      begin
      
        sl := 0;
        j := 0;
        while (j < planet.ChildCount)and(sl < length(ScanList)) do
        begin
          rtime := planet.ChildElements[j];
          time_u := StrToInt64(rtime.AttributeValue['time']);

          if ScanList[sl].Time_u > time_u then
          begin  //Wenn lokal neuer als remote
            SendID(sit_send, ScanList[sl].ID);
            inc(sl);  //nächster lokaler
          end
          else
          if ScanList[sl].Time_u < time_u then
          begin  //Wenn remote neuer als lokal
            SendID(sit_get, StrToInt(rtime.AttributeValue['id']));
            inc(j);  //nächster remote
          end
          else
          begin  //Wenn beide Zeiten gleich sind
            inc(sl);  //Zähle beide weiter (sonst ist nix zu tun!)
            inc(j);
          end;
        end;

        // an dieser Stelle ist eine der beiden Listen durchgearbeitet
        // jetzt muss der verbleibende Rest in der anderen Liste noch gesendet werden

        while (j < planet.ChildCount) do  // remote Liste
        begin
          rtime := planet.ChildElements[j];
          SendID(sit_get, StrToInt(rtime.AttributeValue['id']));
          inc(j);
        end;

        while (sl < length(ScanList)) do  // lokale Liste
        begin
          SendID(sit_send, ScanList[sl].ID);
          inc(sl);
        end;

      end;

      SetPositionProgress(pos.P[1]);
      inc(abspos);
    end;

    // an dieser Stelle sind alle remote-Scans abgearbeitet,
    // jetzt müssen noch verbleibende lokale scan gesendet werden

    labspos := abspos;
    pos.P[1] := max_Systems;
    pos.P[2] := max_Planeten;
    pos.Mond := true;
    abspos := PlanetPositionToAbsPlanetNr(pos)
              +1;  // siehe SendReports_between()

    SendReports_between(labspos, abspos);

    if (read <> '')or(write <> '') then
      PostAndParseAnswer(read,write);
      
  finally
    root.Free;
  end;

  log('reports ready, gala ' + IntToStr(gala),10);
  
  TXT_ges.Text := TimeToStr(Now-start);
end;

procedure TFRM_POST_TEST.PostAndParseAnswer(read, write: string);
begin
  mem_send.Clear;
  mem_send.Lines.Add('<maintag><read>' + read + '</read><write>' + write + '</write></maintag>');
  Application.ProcessMessages;
  while CH_Pause.Checked do Application.ProcessMessages;
  CH_Pause.Checked := CheckBox1.Checked;
  if (read <> '')or(write <> '') then
  begin
    POST; //POST!
    ParseAnswer(trnsltoUTF8(mem_recv.Text));
  end;
end;

procedure TFRM_POST_TEST.Button9Click(Sender: TObject);
var i: integer;
begin
  stop := False;
  for i := 1 to max_Galaxy do
    Sync_Report(i);
end;

procedure TFRM_POST_TEST.FormCreate(Sender: TObject);
begin
  Scan := TScanBericht.Create;

  Stop := False;
  more := True;
  Button2Click(self); //more := not more;
  txt_url.Text := FRM_Main.PlayerOptions.phpPost;
end;

procedure TFRM_POST_TEST.POST(param: string = '');
var startpost: Tdatetime;
    url: string;
    s: AnsiString;
    request, response: TMemoryStream;
    terminator: integer;
begin
  if pos('?', txt_url.Text) > 0 then
    param := '&' + param
  else
    param := '?' + param;

  if sessionid <> '' then
  begin
    param := param+'cSsid='+sessionid+'&';
  end;

  url := txt_url.Text + param;

  s := trnsltoUTF8(mem_send.Text);
  request := TMemoryStream.Create;
  response := TMemoryStream.Create;
  try
    request.Write(PAnsiChar(s)^, length(s));
    startpost := now;

    IdHTTP1.Post(url, request, response);
    terminator := 0;
    response.WriteBuffer(terminator,1); // Add terminating NULL!
    mem_recv.Text := trnslShortStr(PAnsiChar(response.Memory));

    startpost := Now - startpost;
    TXT_post.Text := FloatToStrF(startpost*24*60*60,ffNumber,80,4) + ' s';
  finally
    request.Free;
    response.Free;
  end;
end;

procedure TFRM_POST_TEST.BTN_POST_Click(Sender: TObject);
begin
  Post;
end;

procedure TFRM_POST_TEST.Button4Click(Sender: TObject);
begin
  stop := False;
  Sync_Systems(self);
end;

procedure TFRM_POST_TEST.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Stop := True;
  try
    FRM_Main.PlayerOptions.phpPost := txt_url.Text;
  except

  end;
end;

function TFRM_POST_TEST.do_login(user, pass: string): Boolean;
var res, tag: THTMLElement;
    param: string;
begin
  Result := false;
  sessionid := '';
  if (IdHTTP1.CookieManager <> nil) then
    IdHTTP1.CookieManager.CookieCollection.Clear;

  param := '';
  param:=param+'action=login&';
  param:=param+'username='+TIdURI.ParamsEncode(user)+'&';
  param:=param+'password='+TIdURI.ParamsEncode(pass)+'&';

  mem_send.Clear;
  mem_send.Lines.Add('<read><serverinfo/></read>');

  POST(param);

  if not ParseAnswer(trnsltoUTF8(mem_recv.Lines.Text)) then
    exit; // error on login!

  res := THTMLElement.Create(nil, 'root');
  try

    res.ParseHTMLCode(mem_recv.Lines.Text);

//    tag := res.FindChildTagPath_e('acknowledge');
    //ShowMessage(tag.FullTagContent);
    tag := res.FindChildTagPath_e('read/serverinfo');

    if tag.AttributeValue['universe'] <>
       (ODataBase.UniDomain + '.' + ODataBase.game_domain) then
      raise Exception.Create('Wrong OGame/Universe! "' +
                              tag.AttributeValue['universe'] + '"');

    tag := res.FindChildTagPath_e('sessionid');
    sessionid := trim(tag.FullTagContent);

    result := true;

  except

  on E: Exception do
    log('(' + E.ClassName + ') ' + E.Message, 10);

  end;
  res.Free;
end;

procedure TFRM_POST_TEST.Button10Click(Sender: TObject);
var user: string;
    pass: string;

begin
  user := InputBox('username', 'type your username', 'test');
  pass := InputBox('password', 'type your password', 'test');

  if do_login(user,pass) then
    ShowMessage('Login successfull')
  else
    ShowMessage('Login failed');
end;

procedure TFRM_POST_TEST.Button1Click(Sender: TObject);
begin
  Stop := True;
end;

procedure TFRM_POST_TEST.Button2Click(Sender: TObject);
begin
  more := not more;
  Panel1.Visible := more;
  ClientHeight := Panel1.Top + Panel1.Height * byte(more);

end;

procedure TFRM_POST_TEST.Button7Click(Sender: TObject);
var st: TStatTypeEx;
begin
  mem_send.Clear;
  st.NameType := sntAlliance;
  st.PointType := sptPoints;
  mem_send.Lines.Add('<write>' +
    entflines(StatToXML_(
      ODataBase.Statistic.StatisticType[st.NameType,st.PointType].Stats[0],st))
      + '</write>');
end;

function GetPlanetReportList(Pos: TPlanetPosition; since_u: int64): TReportTimeList;
var i: integer;
begin
  Result := ODataBase.UniTree.GetPlanetReportList(Pos);
  i := 0;
  while i < length(Result) do
  begin
    if Result[i].Time_u >= since_u then
      inc(i)
    else
    begin
      // da die Liste sortiert ist (neuere Scans zu erst)
      // kann sie einfach beim ersten Treffer gekürzt werden:

      SetLength(Result, i);
      break;
    end;
  end;
end;

procedure TFRM_POST_TEST.FormDestroy(Sender: TObject);
begin
  Scan.Free;
end;

procedure TFRM_POST_TEST.Button11Click(Sender: TObject);
var st: TStatTypeEx;
begin
  mem_send.Clear;
  st.NameType := sntPlayer;
  st.PointType := sptPoints;
  mem_send.Lines.Add('<write>' +
    entflines(StatToXML_(
      ODataBase.Statistic.StatisticType[st.NameType,st.PointType].Stats[0],st))
      + '</write>');
end;

{ TStatsPartTimes }

function TStatsPartTimes.Count: integer;
begin
  Result := fTimes.Count;
end;

constructor TStatsPartTimes.Create;
begin
  inherited Create;
  fTimes := TList.Create;
end;

destructor TStatsPartTimes.Destroy;
var time: TStatsPartTime;
begin
  while fTimes.Count > 0 do
  begin
    time := fTimes[0];
    if (time <> nil) then
      time.Free;
      
    fTimes.Delete(0);
  end;
  fTimes.Free;
  inherited;
end;

function TStatsPartTimes.getTimes(i: integer): Int64;
var time: TStatsPartTime;
begin
  Result := 0;
  if (i < fTimes.Count) then
  begin
    time := fTimes[i];
    if (time <> nil) then
    begin
      Result := time.time;
    end;
  end;
end;

procedure TStatsPartTimes.setTimes(i: integer; const Value: Int64);
begin
  if fTimes.Count <= i then
  begin
    fTimes.Count := i+10;
  end;

  if (fTimes[i] = nil) then
  begin
    fTimes[i] := TStatsPartTime.Create;
  end;

  TStatsPartTime(fTimes[i]).time := Value;
end;

procedure TFRM_POST_TEST.Button12Click(Sender: TObject);
var typ: TStatTypeEx;
    ntyp: TStatNameType;
    ptyp: TStatPointType;
begin
  Stop := false;
  for ntyp := low(ntyp) to high(ntyp) do
  begin
    for ptyp := low(ptyp) to high(ptyp) do
    begin
      typ.NameType := ntyp;
      typ.PointType := ptyp;
      Sync_Stats(typ);
      if (Stop) then
        Exit;
    end;
  end;
end;

procedure TFRM_POST_TEST.parseError(parser: TUnicodeXmlParser);
var ende: boolean;
    level: integer;
begin
  ende := false;
  level := 0;
  repeat
    case Parser.CurPartType of
      ptStartTag, ptEmptyTag:
        begin
          if parser.CurName = 'error' then
          begin
            log('error: '+parser.attrAsString('type')+':'+
                             parser.attrAsString('no'),10);
            inc(level);
          end;
        end;
      ptContent: if parser.CurName = 'error' then
              log(trnslShortStr(parser.CurContent),10);
      ptEndTag:
        begin
          if parser.CurName = 'error' then
          begin
            dec(level);
            ende := level <= 0;
          end;
        end;
    end;
    ende := ende or (not parser.Scan);
  until ende;
end;

end.

