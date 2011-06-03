unit quickupdate;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, VirtualTrees, OGame_Types, html, IdHTTP,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, ExtCtrls;

type
  PQuickUpdateFileData = ^TQuickUpdateFileData;
  TQuickUpdateFileData = record
    filename: string;
    hash_local: string;
    hash_server: string;
    status: string;
  end;
  Tfrm_quickupdate = class(TForm)
    Panel1: TPanel;
    lbl_update: TLabel;
    Label1: TLabel;
    vst_files: TVirtualStringTree;
    btn_update: TButton;
    Button2: TButton;
    Button3: TButton;
    IdHTTP1: TIdHTTP;
    procedure vst_filesGetNodeDataSize(Sender: TBaseVirtualTree;
      var NodeDataSize: Integer);
    procedure vst_filesGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure Button3Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btn_updateClick(Sender: TObject);
    procedure vst_filesCompareNodes(Sender: TBaseVirtualTree; Node1,
      Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure vst_filesBeforeCellPaint(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      CellPaintMode: TVTCellPaintMode; CellRect: TRect;
      var ContentRect: TRect);
  private
    ODB: TObject;
    { Private-Deklarationen }
  public
    enable_plugin_reload: boolean;
    function getUpdates: boolean;
    function applyUpdates: integer;
    constructor Create(AOwner: TComponent); overload; override; // throw exception!
    constructor Create(AOwner: TComponent; aODB: TObject;
      aEnablePluginReload: boolean); reintroduce; overload;
    { Public-Deklarationen }
  end;

implementation

{$R *.dfm}

uses IdHashMessageDigest, idHash, Math, Prog_Unit;
 
 //returns MD5 has for a file
 function MD5(const fileName : string) : string;
 var
   idmd5 : TIdHashMessageDigest5;
   fs : TFileStream;
 begin
   idmd5 := TIdHashMessageDigest5.Create;
   fs := TFileStream.Create(fileName, fmOpenRead OR fmShareDenyWrite) ;
   try
     result := idmd5.AsHex(
       idmd5.HashValue(fs)
       );
   finally
     fs.Free;
     idmd5.Free;
   end;
 end;

function Tfrm_quickupdate.getUpdates: boolean;
var net: TIdHTTP;
    mem: TMemoryStream;
    xml, node, filenode: THTMLElement;
    text: PChar;
    zero: byte;
    i: integer;
    localPath: string;
begin
  Result := false;
  localPath := ExtractFilePath(Application.ExeName);
  net := TIdHTTP.Create(Application);
  mem := TMemoryStream.Create;
  try
    net.Get(QuickUpdateUrl+'quick.xml',mem);
    zero := 0;
    mem.Write(zero,sizeof(zero));
    text := mem.Memory;
    xml := THTMLElement.Create(nil, 'root');
    try
      vst_files.BeginUpdate;
      vst_files.Clear;
      xml.ParseHTMLCode(text);
      node := xml.FindChildTagPath('quickupdate/files');
      if node <> nil then
      begin
        for i := 0 to node.ChildCount-1 do
        begin
          filenode := node.ChildElements[i];
          if filenode.TagName = 'file' then
          begin
            with TQuickUpdateFileData(vst_files.GetNodeData(
                        vst_files.AddChild(nil)
                        )^) do
            begin
              filename := trim(filenode.FullTagContent);
              hash_server := LowerCase(trim(filenode.AttributeValue['hash']));
              if FileExists(localPath+filename) then
              begin
                hash_local := LowerCase(MD5(localPath+filename));
                if hash_server <> hash_local then
                begin
                  status := 'needs update';
                  Result := true;
                end
                else
                  status := 'latest';
              end
              else
              begin
                hash_local := '<new>';
                status := 'new file';
                Result := true;
              end;
            end;
          end;
        end;
      end;
      vst_files.SortTree(3, sdDescending);
    finally
      xml.Free;
      vst_files.EndUpdate;
    end;
  finally
    net.free;
    mem.Free;
  end;
  btn_update.Enabled := Result;
end;


procedure Tfrm_quickupdate.vst_filesGetNodeDataSize(
  Sender: TBaseVirtualTree; var NodeDataSize: Integer);
begin
  NodeDataSize := SizeOf(TQuickUpdateFileData);
end;

procedure Tfrm_quickupdate.vst_filesGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var data: PQuickUpdateFileData;
begin
  CellText := '-';
  data := Sender.GetNodeData(Node);
  case Column of
  0: CellText := data.filename;
  1: CellText := data.hash_local;
  2: CellText := data.hash_server;
  3: CellText := data.status;
  end;
end;

procedure Tfrm_quickupdate.Button3Click(Sender: TObject);
begin
  getUpdates;
end;

procedure Tfrm_quickupdate.FormShow(Sender: TObject);
begin
  getUpdates;
end;

function Tfrm_quickupdate.applyUpdates: integer;

  procedure testFilename(filename: string);
  begin
    if pos('..', filename) > 0 then
      raise Exception.Create(
        'Filename includes backreferences! This is not allowed!');
  end;

  procedure doUpdate(localfile: string; fileurl: string);
  var fs: TFileStream;
      localbackup: string;
  begin
    // nur Änderungen an "Unterverzeichnissen" erlaubt,
    // also teste den Pfad vorher!
    testFilename(localfile);
    
    localbackup := localfile + '.bak';
    CopyFile(PChar(localfile),PChar(localbackup), false);
    try
      fs := TFileStream.Create(localfile, fmCreate);
      try
        IdHTTP1.Get(fileurl, fs);
      finally
        fs.Free;
      end;
      DeleteFile(localbackup);
      Result := Result +1;
    except
      CopyFile(PChar(localbackup), PChar(localfile), false);
      raise;
    end;
  end;


var node: PVirtualNode;
    localPath, localfile: string;
    tmp_plugin: string;
begin
  tmp_plugin := TOgameDataBase(ODB).LanguagePlugIn.PluginFilename;
  if enable_plugin_reload then
    TOgameDataBase(ODB).LanguagePlugIn.LoadPluginFile('','','');
  try

    Result := 0;
    localPath := ExtractFilePath(Application.ExeName);
    node := vst_files.GetFirst;
    while (node <> nil) do
    begin
      with TQuickUpdateFileData(vst_files.GetNodeData(node)^) do
      begin
        localfile := localPath + filename;
        if status <> 'latest' then
        begin
          doUpdate(localfile,QuickUpdateUrl+filename);
        end;
      end;

      // next
      node := vst_files.GetNext(node);
    end;
    ShowMessage('Update erfolgreich! ' + IntToStr(Result) + ' Dateien bearbeitet!');

  finally
    if enable_plugin_reload then
    begin
      TOgameDataBase(ODB).LanguagePlugIn.PluginFilename := tmp_plugin;
      TOgameDataBase(ODB).SelectPlugIn(false);
    end;
  end;
end;

procedure Tfrm_quickupdate.btn_updateClick(Sender: TObject);
begin
  applyUpdates;
  ModalResult := mrOk;
end;

procedure Tfrm_quickupdate.vst_filesCompareNodes(Sender: TBaseVirtualTree;
  Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var text1, text2: WideString;
begin
  vst_filesGetText(Sender, Node1, Column, ttNormal, text1);
  vst_filesGetText(Sender, Node2, Column, ttNormal, text2);
  Result := IfThen(text1 > text2, 1, -1);
end;

procedure Tfrm_quickupdate.vst_filesBeforeCellPaint(
  Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode;
  Column: TColumnIndex; CellPaintMode: TVTCellPaintMode; CellRect: TRect;
  var ContentRect: TRect);
var status: WideString;
begin
  if Column = 3 then
  begin
    vst_filesGetText(Sender, Node, Column, ttNormal, status);
    if status = 'latest' then
      TargetCanvas.Brush.Color := clLime
    else
      TargetCanvas.Brush.Color := clRed;
    TargetCanvas.FillRect(CellRect);
  end;
end;

constructor Tfrm_quickupdate.Create(AOwner: TComponent; aODB: TObject;
  aEnablePluginReload: boolean);
begin
  inherited Create(AOwner);
  enable_plugin_reload := aEnablePluginReload;
  self.ODB := aODB;
end;

constructor Tfrm_quickupdate.Create(AOwner: TComponent);
begin
  raise Exception.Create('Tfrm_quickupdate.Create: disabled contructor!');
  inherited;
end;

end.

