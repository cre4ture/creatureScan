unit unit_test_explorer;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Bericht_Frame, UnitTestDB;

type
  Tfrm_unit_test = class(TForm)
    lb_tests: TListBox;
    lb_scans: TListBox;
    Frame_Bericht1: TFrame_Bericht;
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure lb_testsClick(Sender: TObject);
    procedure lb_scansClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    unitTestDB: TCSUnitTestDB;
    { Private-Deklarationen }
  public
  end;

var
  frm_unit_test: Tfrm_unit_test;

implementation

{$R *.dfm}

uses Scan, Sources, CSUnitTest_ScanBerichtHTTP, DLL_plugin_TEST;

procedure Tfrm_unit_test.Button1Click(Sender: TObject);
var
  i: Integer;
begin
  unitTestDB := FRM_Scan.unitTestDB;
  lb_tests.Clear;
  lb_scans.Clear;
  for i := 0 to unitTestDB.count-1 do
  begin
    lb_tests.Items.Add('Test #' + IntToStr(i));
  end;
end;

procedure Tfrm_unit_test.Button2Click(Sender: TObject);
var test: TCSUnitTest;
    scan_test: TCSUnitTest_ScanBericht;
begin
  if (lb_tests.ItemIndex < 0) then exit;

  test := unitTestDB.tests[lb_tests.ItemIndex];
  if test is TCSUnitTest_ScanBericht then
  begin
    scan_test := TCSUnitTest_ScanBericht(test);
    FRM_Sources.m_Text.Text := scan_test.cb_text;
    FRM_Sources.m_Html.Text := scan_test.cb_html;
  end;
end;

procedure Tfrm_unit_test.Button3Click(Sender: TObject);
begin
  if (lb_tests.ItemIndex < 0) then exit;

  if MessageDlg('Test wirklich Löschen?', mtConfirmation, mbYesNo, 0) = mrYes then
  begin
    unitTestDB.deleteUnitTest(lb_tests.ItemIndex);
    unitTestDB.saveToFile;
  end;
end;

procedure Tfrm_unit_test.FormCreate(Sender: TObject);
begin
  Frame_Bericht1.DontShowRaids := True;
  Frame_Bericht1.plugin := plugin;
end;

procedure Tfrm_unit_test.lb_testsClick(Sender: TObject);
var test: TCSUnitTest;
    scan_test: TCSUnitTest_ScanBericht;
    i: integer;
begin
  if (lb_tests.ItemIndex < 0) then exit;

  test := unitTestDB.tests[lb_tests.ItemIndex];
  if test is TCSUnitTest_ScanBericht then
  begin
    scan_test := TCSUnitTest_ScanBericht(test);
    lb_scans.Clear;
    for i := 0 to scan_test.result_count-1 do
    begin
      lb_scans.Items.Add('report #' + IntToStr(i));
    end;
  end;
end;

procedure Tfrm_unit_test.lb_scansClick(Sender: TObject);
var test: TCSUnitTest;
    scan_test: TCSUnitTest_ScanBericht;
    i: integer;
begin
  if (lb_tests.ItemIndex < 0) then exit;
  if (lb_scans.ItemIndex < 0) then exit;

  test := unitTestDB.tests[lb_tests.ItemIndex];
  if test is TCSUnitTest_ScanBericht then
  begin
    scan_test := TCSUnitTest_ScanBericht(test);
    Frame_Bericht1.SetBericht(scan_test.result_reports[lb_scans.ItemIndex]);
  end;
end;

end.
