unit CSUnitTest_ScanBerichtHTTP;

interface

uses UnitTestDB, Xml.XMLIntf, OGame_Types, xml_parser_unicode, TIReadPlugin,
  System.Generics.Collections, System.Variants;

type
  TCSUnitTest_ScanBericht = class(TCSUnitTest)
  private
    function getReport(i: integer): TReadReport;
  protected
    text: AnsiString;
    html: AnsiString;
    test_time_u: Int64;
    reports: TList<TReadReport>;

  public
    function runUnitTest(plugin: TLangPlugIn): string; override;
    class function constructTestFromXML(xml: IXMLNode): TCSUnitTest; override;
    procedure saveToXML(xml: IXMLNode); override;
    function addResultReport(scan: TScanBericht; askMoon: Boolean): integer; // adds a copy of scan
    constructor Create(a_text, a_html: AnsiString; a_time_u: Int64);
    destructor Destroy; override;

    property cb_text: AnsiString read text;
    property cb_html: AnsiString read html;

    function result_count: integer;
    property result_reports[i: integer]: TReadReport read getReport;
  end;

implementation

uses UnitTestFactory, cS_XML, SysUtils, DateUtils;

{ TCSUnitTest_httpOnly }

function TCSUnitTest_ScanBericht.addResultReport(
  scan: TScanBericht; askMoon: Boolean): integer;
var my_scan: TReadReport;
begin
  my_scan := TReadReport.Create;
  my_scan.copyFrom(scan);
  my_scan.AskMoon := askMoon;
  Result := reports.Add(my_scan);
end;

class function TCSUnitTest_ScanBericht.constructTestFromXML(
  xml: IXMLNode): TCSUnitTest;
var node, result_node: IXMLNode;
    a_text: AnsiString;
    a_html: AnsiString;
    a_testtime: Int64;
    a_result: AnsiString;
    a_result_askMoon: Boolean;
    a_report: TScanBericht;
    parser: TUnicodeXmlParser;
    i: integer;
    inst: TCSUnitTest_ScanBericht;
    ole: OleVariant;
begin
  a_text := '';
  a_html := '';

  ole := xml.ChildValues['text'];
  if not VarIsNull(ole) then
    a_text := UTF8Encode(WideString(ole));

  ole := xml.ChildValues['html'];
  if not VarIsNull(ole) then
    a_html := UTF8Encode(WideString(ole));

  a_testtime := xml.ChildValues['time_u'];

  inst := TCSUnitTest_ScanBericht.Create(a_text, a_html,
                                         a_testtime);

  result_node := xml.ChildNodes.FindNode('result');
  if result_node <> nil then
  begin
    for i := 0 to result_node.ChildNodes.Count-1 do
    begin
      node := result_node.ChildNodes[i];
      a_result := utf8Encode(node.ChildValues['scan']);
      a_result_askMoon := node.ChildValues['askmoon'];
      a_report := TScanBericht.Create;
      parser := TUnicodeXmlParser.Create;
      try
        parser.LoadFromBuffer(PAnsiChar(a_result));
        parser.StartScan;
        parser.Scan;
        parse_report(parser, a_report);
        inst.addResultReport(a_report, a_result_askMoon);
      finally
        parser.Free;
        a_report.Free;
      end;
    end;
  end
  else
    raise Exception.Create('TCSUnitTest_ScanBerichtHTTP.constructTestFromXML(): Invalid XML!');

  Result := inst;
end;

function TCSUnitTest_ScanBericht.result_count: integer;
begin
  Result := reports.Count;
end;

constructor TCSUnitTest_ScanBericht.Create(a_text, a_html: AnsiString; a_time_u: Int64);
begin
  inherited Create;
  html := a_html;
  text := a_text;
  test_time_u := a_time_u;
  reports := TList<TReadReport>.Create;
end;

destructor TCSUnitTest_ScanBericht.Destroy;
var
  i: Integer;
begin
  for i := 0 to reports.Count-1 do
  begin
    reports[i].Free;
  end;
  reports.Free;
  inherited;
end;

function TCSUnitTest_ScanBericht.getReport(i: integer): TReadReport;
begin
  Result := reports[i];
end;

function TCSUnitTest_ScanBericht.runUnitTest(plugin: TLangPlugIn): string;
var handle, count: integer;
  i: Integer;
  report: TScanBericht;
  askMoon: Boolean;
  cmp_result: string;
begin
  handle := plugin.ReadSource_New;
  report := TScanBericht.Create;
  cmp_result := '';
  try
    plugin.SetReadSourceText(handle, text, test_time_u);
    plugin.SetReadSourceHTML(handle, html, test_time_u);
    count := plugin.ReadReports(handle);
    if count <> reports.count then
    begin
      cmp_result := cmp_result + 'count != count';
    end
    else
    begin
      for i := 0 to count-1 do
      begin
        plugin.GetReport(handle, i, report, askMoon);

        cmp_result := cmp_result + #13 + #10 + IntToStr(i) + ': { '
                       + CompareScans(reports[i],report);
        if reports[i].AskMoon <> askMoon then
        begin
          cmp_result := cmp_result + '; askMoon!';
        end;
        cmp_result := cmp_result + ' }';
      end;
    end;
  finally
    plugin.ReadSource_Free(handle);
    report.Free;
  end;
  Result := cmp_result;
end;

procedure TCSUnitTest_ScanBericht.saveToXML(xml: IXMLNode);
var node, result_node, report_node: IXMLNode;
  i: Integer;
begin
  node := xml.AddChild('text');
  node.Text := UTF8ToString(text);
  node := xml.AddChild('html');
  node.Text := UTF8ToString(html);
  node := xml.AddChild('time_u');
  node.NodeValue := test_time_u;

  result_node := xml.AddChild('result');
  for i := 0 to reports.Count-1 do
  begin
    report_node := result_node.AddChild('report');
    report_node.ChildValues['scan'] := ScanToXML_(reports[i], '9.9');
    report_node.ChildValues['askmoon'] := reports[i].AskMoon;
  end;
end;

initialization
  UnitTestFactory.registerCSUnitTest(TCSUnitTest_ScanBericht);

end.
