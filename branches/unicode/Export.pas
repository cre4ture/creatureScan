unit Export;
                                                                     
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, OGame_Types, ExtCtrls, Prog_Unit, cS_XML, CoordinatesRanges, cs_DB,
  cS_DB_reportFile, cS_DB_solsysFile;

const
  Typ_1_0_Sys = 1;

type
  TcSExportType = (cSeSysScanFile, cSeXML, cSe_1_0);
  TExportPosition = array[0..2] of Word;

  TFRM_Export = class(TForm)
    Button1: TButton;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    RB_Scans: TRadioButton;
    RB_Systems: TRadioButton;
    RB_alles: TRadioButton;
    RB_Ranges: TRadioButton;
    LV_export: TListView;
    TXT_Gala: TEdit;
    TXT_System: TEdit;
    TXT_Planet: TEdit;
    Button2: TButton;
    CH_OnlyNew: TCheckBox;
    Label2: TLabel;
    Label3: TLabel;
    BTN_Add: TButton;
    BTN_Del: TButton;
    GroupBox3: TGroupBox;
    Edit1: TEdit;
    Button3: TButton;
    SaveDialog1: TSaveDialog;
    Button4: TButton;
    Panel1: TPanel;
    ComboBox1: TComboBox;
    procedure Button2Click(Sender: TObject);
    procedure RB_ScansClick(Sender: TObject);
    procedure BTN_AddClick(Sender: TObject);
    procedure RB_RangesClick(Sender: TObject);
    procedure BTN_DelClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure CH_OnlyNewClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    SysFile: TcSSolSysDB;
    ScanFile: TcSReportDB;
    FileStream: TFileStream;
    ExportType: TcSExportType;
    exportcount: Integer;
    procedure ExportList(ExportPositionProcedure: TCoordinatesProcedure; Sys_On: Boolean);
    procedure ExportPositionSys(Position: TCoordinates; var Cancel: Boolean);
    procedure ExportPositionScan(Position: TCoordinates; var Cancel: Boolean);
    { Private-Deklarationen }
  public
    procedure ExportSys;
    procedure ExportScans;
    procedure ImportcSe_1_0(filename: String);
    { Public-Deklarationen }
  end;

var
  FRM_Export: TFRM_Export;

implementation

uses Languages, DateUtils, Math;

{$R *.DFM}

procedure TFRM_Export.Button2Click(Sender: TObject);
begin
  ShowMessage(STR_MSG_Export_Help);
end;

procedure TFRM_Export.RB_ScansClick(Sender: TObject);
begin
  CH_OnlyNew.Enabled := RB_Scans.Checked;
  TXT_Planet.Visible := RB_Scans.Checked;
end;

procedure TFRM_Export.BTN_AddClick(Sender: TObject);
begin
  if ValidRange(TXT_Gala.Text)and ValidRange(TXT_System.Text) and ValidRange(TXT_Planet.Text) then
  with LV_export.Items.Add do
  begin
    Caption := IntToStr(Index);
    SubItems.Add(TXT_Gala.Text);
    SubItems.Add(TXT_System.Text);
    SubItems.Add(TXT_Planet.Text);
  end
  else
    ShowMessage(STR_Bereich_fehlerhaft);
end;

procedure TFRM_Export.RB_RangesClick(Sender: TObject);
begin
  TXT_Gala.Enabled := RB_Ranges.Checked;
  TXT_System.Enabled := RB_Ranges.Checked;
  TXT_Planet.Enabled := RB_Ranges.Checked;
  LV_export.Enabled := RB_Ranges.Checked;
  BTN_Add.Enabled := RB_Ranges.Checked;
  BTN_Del.Enabled := RB_Ranges.Checked;
  if RB_alles.Checked then CH_OnlyNew.Checked := false;
end;

procedure TFRM_Export.BTN_DelClick(Sender: TObject);
begin
  if LV_export.Selected <> nil then
    LV_export.Selected.Delete;
end;

procedure TFRM_Export.Button3Click(Sender: TObject);
begin
  if SaveDialog1.Execute then
  begin
    Edit1.Text := SaveDialog1.FileName;
    if ExtractFileExt(Edit1.Text) = '' then
      Edit1.Text := Edit1.Text + '.csef';
  end;
end;

procedure TFRM_Export.Button4Click(Sender: TObject);
begin
  Close;
end;

procedure TFRM_Export.Button1Click(Sender: TObject);
var res: boolean;
begin
  ExportType := TcSExportType(ComboBox1.ItemIndex);

  Panel1.Visible := true;
  Enabled := False;
  Application.ProcessMessages;
  
  try
    if RB_Systems.Checked then ExportSys else ExportScans;
    res := True;
  except
    res := False;
  end;

  if res then ShowMessage(STR_Export_Erfolgreich)
         else ShowMessage(STR_Export_Fehlgeschlagen);

  Panel1.Visible := false;
  Enabled := true;
end;

procedure TFRM_Export.ExportSys;
var i: integer;
    s: shortString;
    t: byte;
    text: string;
begin
  case ExportType of
  cSeSysScanFile:
    begin
      SysFile := TcSSolSysDB_for_File.Create(Edit1.Text, ODataBase.UniDomain);  // TODO
      if RB_Ranges.Checked then
        ExportList(ExportPositionSys, True)
      else
      begin
        for i := 0 to ODataBase.Systeme.Count-1 do
          SysFile.AddSolSys(ODataBase.Systeme[i]);
      end;
      SysFile.Free;
    end;
  cSeXML:
    begin
      FileStream := TFileStream.Create(Edit1.Text,fmCreate);
      text := '<?xml version="1.0" encoding="UTF-8"?><export>';
      FileStream.WriteBuffer(PChar(text)^,length(text));

      if RB_Ranges.Checked then
      begin
        exportcount := 0;
        ExportList(ExportPositionSys, True);
      end
      else
      begin
        for i := 0 to ODataBase.Systeme.Count-1 do
        begin
          text := AnsiToUtf8(SysToXML_(ODataBase.Systeme[i], '9.9'));
          FileStream.WriteBuffer(PChar(text)^,length(text));
        end;
      end;
      
      text := '</export>';
      FileStream.WriteBuffer(PChar(text)^,length(text));
      FileStream.Free;
    end;
  cSe_1_0:
    begin
      FileStream := TFileStream.Create(Edit1.Text,fmCreate);
      s := 'cSe_1_0';
      WriteStringToStream(s,FileStream);
      if RB_Ranges.Checked then
        ExportList(ExportPositionSys, True)
      else
      begin
        t := Typ_1_0_Sys;
        for i := 0 to ODataBase.Systeme.Count-1 do
        begin
          FileStream.WriteBuffer(t,sizeof(t));
          WriteSysToStream_1_0(ODataBase.Systeme[i],FileStream);
        end;
      end;
      FileStream.Free;
    end;
  end;

end;

procedure TFRM_Export.ExportPositionSys(Position: TCoordinates; var Cancel: Boolean);
var t: byte;
    s: string;
begin
  if ODataBase.Uni[Position[0],Position[1]].SystemCopy >= 0 then
  begin
    case ExportType of
    cSeSysScanFile: SysFile.AddSolSys(ODataBase.Systeme[ODataBase.Uni[Position[0],Position[1]].SystemCopy]);
    cSeXML:
      begin
        s := AnsiToUtf8(SysToXML_(ODataBase.Systeme[ODataBase.Uni[Position[0],Position[1]].SystemCopy], '9.9'));
        FileStream.WriteBuffer(PChar(s)^,length(s));
      end;
    cSe_1_0:
      begin
        t := Typ_1_0_Sys;
        FileStream.WriteBuffer(t,sizeof(t));
        WriteSysToStream_1_0(ODataBase.Systeme[ODataBase.Uni[Position[0],Position[1]].SystemCopy],FileStream);
      end;
    end;
    inc(exportcount);
  end;
end;

procedure TFRM_Export.ExportScans;
var i: integer;
    text: string;
begin
  case ExportType of
  cSeSysScanFile:
    begin
      ScanFile := TcSReportDB_for_File.Create(Edit1.Text, ODataBase.UniDomain); // TODO
      if RB_Ranges.Checked then
        ExportList(ExportPositionScan, False)
      else
      begin
        for i := 0 to ODataBase.Berichte.Count-1 do
          ScanFile.AddReport(ODataBase.Berichte[i]);
      end;
      ScanFile.Free;
    end;
  cSeXML:
    begin
      FileStream := TFileStream.Create(Edit1.Text,fmCreate);
      text := '<?xml version="1.0" encoding="UTF-8"?><export>';
      FileStream.WriteBuffer(PChar(text)^,length(text));

      if RB_Ranges.Checked then
      begin
        exportcount := 0;
        ExportList(ExportPositionScan, False);
      end
      else
      begin
        for i := 0 to ODataBase.Berichte.Count-1 do
        begin
          text := AnsiToUtf8(ScanToXML_(ODataBase.Berichte[i], '9.9'));
          FileStream.WriteBuffer(PChar(text)^,length(text));
        end;
      end;

      text := '</export>';
      FileStream.WriteBuffer(PChar(text)^,length(text));
      FileStream.Free;
    end;
  cSe_1_0:
    begin
      Raise Exception.Create('Gibs nochnet!');
    end;
  end;
end;

procedure TFRM_Export.ExportPositionScan(Position: TCoordinates; var Cancel: Boolean);
var M: boolean;
    i: word;
    s: string;
begin
  if CH_OnlyNew.Checked then
  begin
    for m := false to true do
     if ODataBase.Uni[Position[0],Position[1]].Planeten[Position[2],M].ScanBericht >= 0 then
     begin
       case ExportType of
       cSeSysScanFile: ScanFile.AddReport(ODataBase.Berichte[ODataBase.Uni[Position[0],Position[1]].Planeten[Position[2],M].ScanBericht]);
       cSeXML:
         begin
           s := AnsiToUtf8(ScanToXML_(ODataBase.Berichte[ODataBase.Uni[Position[0],Position[1]].Planeten[Position[2],M].ScanBericht], '9.9'));
           FileStream.WriteBuffer(PChar(s)^,length(s));
         end;
       cSe_1_0: Raise Exception.Create('Gibs nochnet!');
       end;

       inc(exportcount);
     end;
  end
  else
  begin
    for i := 0 to ODataBase.Berichte.Count-1 do
    begin
      if (Position[0] = ODataBase.Berichte[i].Head.Position.P[0])and
         (Position[1] = ODataBase.Berichte[i].Head.Position.P[1])and
         (Position[2] = ODataBase.Berichte[i].Head.Position.P[2]) then
      begin
        case ExportType of
        cSeSysScanFile: ScanFile.AddReport(ODataBase.Berichte[i]);
        cSeXML:
          begin
            s := AnsiToUtf8(ScanToXML_(ODataBase.Berichte[i], '9.9'));
            FileStream.WriteBuffer(PChar(s)^,length(s));
          end;
        cSe_1_0: Raise Exception.Create('Gibs nochnet!');
        end;

        inc(exportcount);
      end;
    end;
  end;
end;

procedure TFRM_Export.ExportList(ExportPositionProcedure: TCoordinatesProcedure; Sys_On: Boolean);
var i,r,cc: integer;
    Ranges: TCoordinatesRangeList;
begin
  cc := IfThen(RB_Systems.Checked,2,3);

  Ranges := TCoordinatesRangeList.Create;
  for i := 0 to LV_export.Items.Count-1 do
  begin
    Ranges.Clear;
    for r := 0 to cc-1 do
    begin
      Ranges.AddRange(StrToRange(LV_export.Items[i].SubItems[r]));
      Ranges[r] := RangeIntersection(Ranges[r],OGameRangeList[r])
    end;

    ProcessRangeList(Ranges,ExportPositionProcedure);
  end;
  Ranges.Free;
end;

procedure TFRM_Export.CH_OnlyNewClick(Sender: TObject);
begin
  if CH_OnlyNew.Checked then RB_Ranges.Checked := true;
  RB_alles.Enabled := not CH_OnlyNew.Checked;
end;

procedure TFRM_Export.FormCreate(Sender: TObject);
begin
  RB_RangesClick(self);
  if SaveCaptions then SaveAllCaptions(Self,LangFile);
  if LoadCaptions then LoadAllCaptions(Self,LangFile);
end;

procedure TFRM_Export.ImportcSe_1_0(filename: String);
var Stream: TFileStream;
    s: ShortString;
    sys: TSystemCopy;
    t: byte;
begin
  Stream := TFileStream.Create(filename,fmOpenRead);

  s := ReadStringFromStream(Stream);
  if s = 'cSe_1_0' then
  begin
    while (Stream.Position < Stream.Size) do
    begin
      Stream.ReadBuffer(t,sizeof(t));
      case t of
        Typ_1_0_Sys: sys := ReadSysFromStream_1_0(Stream);
      end;
      ODataBase.UniTree.AddNewSolSys(sys);
    end;
  end
  else
    ShowMessage('Can not import this file!');

  Stream.Free;
end;

end.

