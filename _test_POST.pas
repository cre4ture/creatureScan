unit _test_POST;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, OGame_Types, StdCtrls, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdHTTP, DateUtils, cS_XML, XMLDoc, xmldom,
  XMLIntf, msxmldom, shellapi, ExtCtrls, clientlogin, IdAuthentication,
  ComCtrls, LibXmlParser, LibXmlComps, Prog_unit, Spin, Inifiles;

type
  TFRM_POST_TEST = class(TForm)
    Edit1: TEdit;
    Button4: TButton;
    pb_xml: TProgressBar;
    TXT_ges: TEdit;
    Label2: TLabel;
    TXT_post: TEdit;
    Label3: TLabel;
    Button9: TButton;
    log: TMemo;
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
    Memo1: TMemo;
    BTN_genSys: TButton;
    BTN_POST_: TButton;
    Memo2: TMemo;
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
    Memo3: TMemo;
    Button7: TButton;
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
  private
    FServerUni: array of array of int64;
    more: Boolean;
    function ReadServerUni(p1, p2: word): int64;
    procedure WriteServerUni(p1, p2: word; value: int64);
    function PostAndParseAnswer(read, write: string): Boolean;
    { Private-Deklarationen }
  public
    System: TSystemCopy;
    Scan: TScanbericht;
    Stop: Boolean;
    property ServerUni[p1,p2 : word]: Int64 read ReadServerUni write WriteServerUni;
    function SysToXMLString(sys: TSystemCopy): string;
    function entflines(s: string): String;
    procedure SetServerUniSize;
    function ParseAnswer(xml: string): integer;
    procedure Sync_Report(agala: Integer; asys_begin: Integer = -1; asys_end: Integer = -1);
    procedure Sync_Systems(Sender: TObject);
    procedure POST;
    { Public-Deklarationen }
  end;

var
  FRM_POST_TEST: TFRM_POST_TEST;

function GetPlanetReportList(Pos: TPlanetPosition): TReportTimeList;

implementation

uses main, Math, RTLConsts;

{$R *.dfm}

procedure TFRM_POST_TEST.BTN_genSysClick(Sender: TObject);
begin
  Memo1.Clear;
  Memo1.Lines.Add('action=xml');
  Memo1.Lines.Add('xml=<write>' + entflines(SysToXMLString(System)) + '</write>');
end;

function TFRM_POST_TEST.SysToXMLString(sys: TSystemCopy): string;
begin
  Result := AnsiToUtf8(SysToXML_(sys));
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
  Memo2.Lines.SaveToFile('Response.html');
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
    Scan := FRM_Main.Frame_Bericht1.Bericht;
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
  frm.LBL_Servername.Caption := Edit1.Text;
  frm.LBL_IP_Port.Caption := 'http_POST';
  if frm.ShowModal = mrOK then
  begin
    Authentication.Username := frm.TXT_Username.Text;
    Authentication.Password := frm.TXT_Pass.Text;
    Handled := True;
  end;
  frm.free;
end;

procedure TFRM_POST_TEST.Sync_Systems(Sender: TObject);
var parser: TXmlParser;
    DocSize: Integer;
    snow: int64;
    pos: array[0..2] of word;
    p1, p2, i: integer;
    read, write: string;
    start: Tdatetime;
begin
  start := now;
  Memo1.Clear;
  Memo1.Lines.Add('action=xml');
  Memo1.Lines.Add('xml=<read><serverinfo/><solsystimes_timestamp/></read>');
  POST;
  DocSize := length(Memo2.Lines.Text);

  parser := TXmlParser.Create;
  try
    parser.LoadFromBuffer(PChar(Memo2.Lines.Text));
    parser.StartScan;
    while parser.Scan and (not stop) do
    begin
      pb_xml.Position := Trunc ((parser.CurFinal - parser.DocBuffer) / DocSize * 100.0);
      pb_main.Position := pb_xml.Position div 2;

      case parser.CurPartType of
        {ptNone: ShowMessage('ptNone: "' + parser.CurName + '"');
        ptXmlProlog: ShowMessage('ptXmlProlog: "' + parser.CurName + '"');
        ptComment: ShowMessage('ptComment: "' + parser.CurName + '"');
        ptPI: ShowMessage('ptPI: "' + parser.CurName + '"');
        ptDtdc: ShowMessage('ptDtdc: "' + parser.CurName + '"');   }
        ptStartTag, ptEmptyTag:
          begin

            if parser.CurName = 'serverinfo' then
            begin
              snow := StrToInt64(parser.CurAttr.Value('time'));
              pos[0] := StrToInt(parser.CurAttr.Value('galacount'));
              pos[1] := StrToInt(parser.CurAttr.Value('syscount'));
              pos[2] := StrToInt(parser.CurAttr.Value('planetcount'));
              if (pos[0] <> max_Galaxy)or(pos[1] <> max_Systems)or(pos[2] <> max_Planeten) then
                raise Exception.Create('Server pos_count definitions are not compatible!')
              else SetServerUniSize;
            end;

            if parser.CurName = 'solsystime' then
            begin
              pos[0] := StrToInt(parser.CurAttr.Value('gala'));
              pos[1] := StrToInt(parser.CurAttr.Value('sys'));
              ServerUni[pos[0],pos[1]] := StrToInt(parser.CurAttr.Value('time'));
            end;

          end;
        {ptEndTag: ShowMessage('ptEndTag: "' + parser.CurName + '"');
        ptContent: ShowMessage('ptContent: "' + parser.CurName + '"');
        ptCData: ShowMessage('ptCData: "' + parser.CurName + '"'); }
      end;
    end;
  finally
    parser.Free;
  end;

  if stop then exit;

  read := '';
  write := '';
  i := 0;
  pb_pos.Max := 100;
  for p1 := 1 to max_Galaxy do
  begin
    for p2 := 1 to max_Systems do
    begin

      if ServerUni[p1,p2] > ODataBase.GetSystemTime_u(p1,p2) then
      begin
        read := read + Format('<solsys_pos gala="%d" sys="%d"/>',[p1, p2]);
      end else
      if ServerUni[p1,p2] < ODataBase.GetSystemTime_u(p1,p2) then
      begin
        if (ODataBase.Uni[p1,p2].SystemCopy >= 0) then
          write := write + SysToXMLString(ODataBase.Systeme[ODataBase.Uni[p1,p2].SystemCopy]);
      end;

      inc(i);
      if (i > SpinEdit1.Value)or(p2 = max_systems) then
      begin
        PostAndParseAnswer(read,write);

        i := 0;
        read := '';
        write := '';
      end;

      pb_pos.Position := trunc((((p1-1)*max_Systems + p2)/(max_Galaxy*max_Systems))*100);
      pb_main.Position := pb_xml.Position div 2 + pb_pos.Position div 2;

      if stop then break;
    end;
    if stop then break;
  end;

  TXT_ges.Text := TimeToStr(Now-start);
end;

function TFRM_POST_TEST.ReadServerUni(p1, p2: word): int64;
begin
  if (p1 >= 1)and(p1 <= max_Galaxy)and(p2 >= 1)and(p2 <= max_Systems) then
    Result := FServerUni[p1-1,p2-1]
  else raise Exception.Create(Format('API: ReadServerUni. coordinates(%d:%d) out of valid range(%d:%d)!',[p1,p2,max_Galaxy,max_Systems]));
end;

procedure TFRM_POST_TEST.WriteServerUni(p1, p2: word; value: int64);
begin
  if (p1 >= 1)and(p1 <= max_Galaxy)and(p2 >= 1)and(p2 <= max_Systems) then
    FServerUni[p1-1,p2-1] := value
  else raise Exception.Create(Format('API: ReadServerUni. coordinates(%d:%d) out of valid range(%d:%d)!',[p1,p2,max_Galaxy,max_Systems]));
end;

procedure TFRM_POST_TEST.SetServerUniSize;
var i,j: integer;
begin
  SetLength(FServerUni,max_Galaxy);
  for i := 0 to max_Galaxy-1 do
  begin
    SetLength(FServerUni[i], max_Systems);
    for j := 0 to max_Systems-1 do
      FServerUni[i,j] := -1; //  n/a
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
  Memo1.Lines.Text := s;
end;

function TFRM_POST_TEST.ParseAnswer(xml: string): integer;
var parser: TXmlParser;
    read, write: boolean;
begin
  write := False;
  parser := TXmlParser.Create;
  parser.LoadFromBuffer(PChar(xml));
  parser.StartScan;
  if Parser.Scan then
  repeat
    case Parser.CurPartType of
      ptStartTag, ptEmptyTag:
        begin
          if parser.CurName = 'write' then write := True;
          if parser.CurName = 'read' then
          begin
            parse_unknown(parser,True);
          end;
          if parser.CurName = 'error' then
              Memo3.Lines.Add('error: '+parser.CurAttr.Value('type')+':'+parser.CurAttr.Value('no'));
        end;
      ptContent: if parser.CurName = 'error' then
              Memo3.Lines.Add(parser.CurContent);
      ptEndTag:
        begin
          if parser.CurName = 'write' then write := False;
        end;
    end;
  until (not Parser.Scan);
  parser.Free;
end;

procedure TFRM_POST_TEST.Button6Click(Sender: TObject);
begin
  ParseAnswer(Memo2.Lines.Text);
end;

procedure TFRM_POST_TEST.BTN_genScanClick(Sender: TObject);
begin
  Memo1.Clear;
  Memo1.Lines.Add('action=xml');
  Memo1.Lines.Add('xml=<write>' + entflines(ScanToXML_(Scan)) + '</write>');
end;

procedure TFRM_POST_TEST.Button8Click(Sender: TObject);
var parser: TXmlParser;
begin
  parser := TXmlParser.Create;
  parser.LoadFromBuffer(PChar(Memo2.Text));
  parser.StartScan;
  while parser.Scan do
    case parser.CurPartType of
      ptStartTag, ptEmptyTag: parse_unknown(parser,False);
    end;
  parser.Free;
end;

procedure TFRM_POST_TEST.Sync_Report(agala: Integer; asys_begin: Integer = -1; asys_end: Integer = -1);
var read, write: string;
    p_count: Integer;
    gala, sys_begin, sys_end: Integer;

  procedure SetPositionProgress(pos: TPlanetPosition);
  begin
    pb_pos.Max := (sys_end - sys_begin)*15;
    pb_pos.Position := (pos.P[1] - sys_begin)*15 + pos.P[2];
    pb_main.Position := pb_xml.Position div 2 + trunc(pb_pos.Position/pb_pos.Max*50);
  end;

  const
    ac_get = -1;
    ac_none = 0;
    ac_set = 1;

  procedure SendID(typ: integer; id: integer);
  begin
    case typ of
      ac_get:
        begin  //anfragen! id bezieht sich auf die serverseitige db
          read := read + '<report_id id="' + IntToStr(id) + '"/>';
        end;
      ac_none:;  //nix!
      ac_set:
        begin  //senden! id bezieht sich auf die lokale db
          write := write + ScanToXML_(ODataBase.Berichte[id]);
        end;
    end;
    if typ <> ac_None then inc(p_count);
    if p_count >= SpinEdit1.Value then
    begin
      PostAndParseAnswer(read, write);
      read := '';
      write := '';
      p_count := 0;
    end;
  end;

  procedure SendReports_between(pos1, pos2: TPlanetPosition);
  var list: TReportTimeList;
      i: integer;
  begin
    if not PosBigger(pos2, pos1) then raise Exception.Create('First >= Last Oo!!');
    NextPlanet(pos1);
    SetPositionProgress(pos1);
    while (not SamePlanet(pos1,pos2)) do
    begin
      if ODataBase.UniTree.UniReport(pos1) >= 0 then  //überprüft ob überhaupt einer vorhanden ist!
      begin
        list := GetPlanetReportList(pos1);
        for i := 0 to length(list)-1 do
        begin
          log.Lines.Add('set report(id:' + IntToStr(list[i].ID) + ' pos: ' + PositionToStrMond(pos1));
          SendID(ac_set, list[i].ID);
        end;
      end;
      SetPositionProgress(pos1);
      if not NextPlanet(Pos1) then break;
    end;
  end;

var parser: TXmlParser;
    DocSize: Integer;
    snow: int64;
    uni_pos: array[0..2] of word;
    p1, p2, i: integer;
    start, startpost: Tdatetime;

    Pos, APos: TPlanetPosition;
    time_u: Int64;
    ScanList: TReportTimeList;
    slp: Integer;
    id, ac: Integer;
    s: string;
begin
  read := '';
  write := '';
  p_count := 0;
  FillChar(Pos,Sizeof(pos),0);
  FillChar(APos,Sizeof(Apos),0);

  start := now;
  Memo1.Clear;
  Memo1.Lines.Add('action=xml');
  s := 'xml=<read><serverinfo/><reporttimes gala="' + inttostr(agala) + '"';
  if asys_begin = -1 then asys_begin := 1
  else s := s + ' sys_begin="' + IntToStr(asys_begin) + '"';
  if asys_end = -1 then asys_end := max_Systems
  else s := s + ' sys_end="' + IntToStr(asys_end) + '"';
  s := s + '/></read>';
  Memo1.Lines.Add(s);
  log.Lines.Add('send request: ' + s);
  POST;
  log.Lines.Add('request ready, start sync...');
  DocSize := length(Memo2.Lines.Text);

  parser := TXmlParser.Create;
  try
    parser.LoadFromBuffer(PChar(Memo2.Lines.Text));
    parser.StartScan;
    while parser.Scan and (not Stop) do
    begin
      pb_xml.Position := Trunc ((parser.CurFinal - parser.DocBuffer) / DocSize * 100.0);
      pb_main.Position := pb_xml.Position div 2 + trunc(pb_pos.Position/pb_pos.Max*50);

      case parser.CurPartType of
        ptStartTag, ptEmptyTag:
          begin

            if parser.CurName = 'serverinfo' then
            begin
              snow := StrToInt64(parser.CurAttr.Value('time'));
              Uni_pos[0] := StrToInt(parser.CurAttr.Value('galacount'));
              Uni_pos[1] := StrToInt(parser.CurAttr.Value('syscount'));
              Uni_pos[2] := StrToInt(parser.CurAttr.Value('planetcount'));
              if (Uni_pos[0] <> max_Galaxy)or(Uni_pos[1] <> max_Systems)or(Uni_pos[2] <> max_Planeten) then
                raise Exception.Create('Server pos_count definitions are not compatible!')
              else SetServerUniSize;
              log.Lines.Add('check serverinfo -> OK');
            end;

            if parser.CurName = 'reporttimes' then
            begin
              FillChar(pos,sizeof(pos),0);
              gala := StrToInt(parser.CurAttr.Value('gala'));
              pos.P[0] := gala;  //Pos = "ArbeitsKoordinaten" im xml ("Arbeitsverzeichniss")
              
              sys_begin := StrToInt(parser.CurAttr.Value('sys_begin'));
              sys_end := StrToInt(parser.CurAttr.Value('sys_end'));
              if (sys_begin < asys_begin)or(sys_end > asys_end)or(gala <> agala) then
                raise Exception.Create('Anfrageparameter stimmen in der Antwort nicht überein!');

              APos.P[0] := gala;
              APos.P[1] := sys_begin-1;
              APos.P[2] := max_Planeten;
              APos.Mond := True;  //Setze APos auf einen Planeten vor dem StartPlani!
                //APos = Sync-Fortschritt

              log.Lines.Add('start sync in gala=' + IntToStr(gala) +
                ' from solsys ' + IntToStr(sys_begin) + ' to ' + IntToStr(sys_end));
            end;

            if parser.CurName = 'sys' then //Koordinatenangabe _ Sonnensystem
            begin
              Pos.P[1] := StrToInt(parser.CurAttr.Value('sys'));
              log.Lines.Add('<sys> Position:' + IntToStr(pos.p[0]) + ':' + IntToStr(pos.P[1]));
            end;

            if parser.CurName = 'pos' then //Koordinatenangabe _ Planet (kein <sys> ohne <pos>!)
            begin
              Pos.P[2] := StrToInt(parser.CurAttr.Value('pos'));
              Pos.Mond := parser.CurAttr.Value('moon') = 'true';
              ScanList := GetPlanetReportList(Pos);
              slp := 0;

              SendReports_between(apos,pos);

              apos := pos;
              log.Lines.Add('<pos> Position:' + PositionToStrMond(pos));
            end;

            if parser.CurName = 'report' then
            begin
              time_u := StrToInt64(parser.CurAttr.Value('time'));
              id := StrToInt(parser.CurAttr.Value('id'));

              repeat
                if (slp <= length(ScanList)-1) then
                begin
                  ac := CompareValue(ScanList[slp].Time_u,time_u);
                end
                else ac := ac_get;

                case ac of
                ac_get:
                  begin
                    SendID(ac,id);
                    log.Lines.Add('get report(id:' + IntToStr(id) + ' pos: ' + PositionToStrMond(pos));
                  end;
                ac_set:
                  begin
                    SendID(ac,ScanList[slp].ID);
                    log.Lines.Add('set report(id:' + IntToStr(ScanList[slp].ID) + ' pos: ' + PositionToStrMond(pos));
                  end;
                end;

                if ac in [ac_none,ac_set] then inc(slp);
              until (ac <> ac_set);

            end;

          end;
      end;
    end;
    pos.P[1] := sys_end;         //damit auch die hinteren Scans geschickt werden!
    pos.P[2] := max_Planeten;
    pos.Mond := True;
    NextPlanet(pos);
    SendReports_between(apos,pos);
    if (read <> '')or(write <> '') then
      PostAndParseAnswer(read,write); 
  finally
    parser.Free;
  end;

  TXT_ges.Text := TimeToStr(Now-start);
end;



function TFRM_POST_TEST.PostAndParseAnswer(read, write: string): Boolean;
begin
  Memo1.Clear;
  Memo1.Lines.Add('action=xml');
  memo1.Lines.Add('xml=<maintag><read>' + read + '</read><write>' + write + '</write></maintag>');
  Application.ProcessMessages;
  while CH_Pause.Checked do Application.ProcessMessages;
  CH_Pause.Checked := CheckBox1.Checked;
  if (read <> '')or(write <> '') then
  begin
    POST; //POST!
    ParseAnswer(Utf8ToAnsi(Memo2.Text));
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
  Stop := False;
  more := True;
  Button2Click(self); //more := not more;
  Edit1.Text := FRM_Main.PlayerOptions.phpPost;
end;

procedure TFRM_POST_TEST.POST;
var startpost: Tdatetime;
begin
  startpost := now;
  Memo2.Text := IdHTTP1.Post(Edit1.Text,Memo1.Lines);
  startpost := Now - startpost;
  TXT_post.Text := FloatToStrF(startpost*24*60*60,ffNumber,80,4) + ' s';
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
    FRM_Main.PlayerOptions.phpPost := Edit1.Text;
  except

  end;
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
  Memo1.Clear;
  Memo1.Lines.Add('action=xml');
  st.NameType := sntAlliance;
  st.PointType := sptPoints;
  Memo1.Lines.Add('xml=<write>' + entflines(StatToXML_(ODataBase.Statistic.StatisticType[sntPlayer,sptPoints].Stats[0],st)) + '</write>');
end;

function GetPlanetReportList(Pos: TPlanetPosition): TReportTimeList;
begin
  Result := ODataBase.UniTree.GetPlanetReportList(Pos);
end;

end.

