unit EditScan;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, OGame_Types, StdCtrls, Prog_Unit;

type
  TFRM_EditScan = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    TXT_Planet: TEdit;
    TXT_Position: TEdit;
    TXT_Player: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure TXT_KeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    Edits: array[TScanGroup] of array of TEdit;
    Labels: array[TScanGroup] of array of TLabel;
    procedure LoadScan(Scan: TScanBericht);
    procedure GetScan(result: TScanbericht);
    { Public-Deklarationen }
  end;

var
  FRM_EditScan: TFRM_EditScan;

implementation

uses Math, DateUtils;

{$R *.dfm}

procedure TFRM_EditScan.FormCreate(Sender: TObject);
var j,k: integer;
    y,x: integer;
    sg: TScanGroup;
begin
  x := Label1.Left;
  k := 4;
  y := TXT_Player.Top + TXT_Player.Height + 15;
  for sg := low(sg) to high(sg) do
  begin
    SetLength(Edits[sg],ScanFileCounts[sg]);
    SetLength(Labels[sg],ScanFileCounts[sg]);
    for j := 0 to ScanFileCounts[sg]-1 do
    begin
      if k > 17 then
      begin
        k := 0;
        x := x + 155;
        y := TXT_Planet.Top;
      end;
      Edits[sg,j] := TEdit.Create(Self);
      Edits[sg,j].Parent := Self;
      Edits[sg,j].Left := x +  100;
      Edits[sg,j].Width := 50;
      Edits[sg,j].OnKeyPress := TXT_KeyPress;
      Labels[sg,j] := TLabel.Create(self);
      Labels[sg,j].Parent := Self;
      Labels[sg,j].Left := x;
      Edits[sg,j].Top := y;
      Labels[sg,j].Top := y;
      Edits[sg,j].Text := '0';
      Labels[sg,j].Caption := ODataBase.LanguagePlugIn.SBItems[sg][j+1];
      inc(y,Edits[sg,j].Height);

      inc(k);

      with Edits[sg,j] do
      begin
        If Top + Height + 5 > Self.ClientHeight then Self.ClientHeight := Top + Height + 5;
        If Left + Width + 5 > Self.ClientWidth then Self.ClientWidth := Left + Width + 5;
      end;
    end;
    y := y + 15;
    inc(k);
  end;
end;

procedure TFRM_EditScan.GetScan(result: TScanbericht);
var j: integer;
    sg: TScanGroup;
begin
  FillChar(Result.Head,Sizeof(Result.Head),0);
  Result.Head.Planet := TXT_Planet.Text;
  Result.Head.Position := StrToPosition(TXT_Position.Text);
  Result.Head.Spieler := TXT_Player.Text;
  Result.Head.Spionageabwehr := -2;
  Result.Head.Activity := -1;
  Result.Head.Time_u := DateTimeToUnix(now);
  for sg := low(sg) to high(sg) do
  begin
    for j := 0 to ScanFileCounts[sg]-1 do
    begin
      Result.Bericht[sg,j] := StrToInt(Edits[sg,j].Text);
    end;
  end;
end;

procedure TFRM_EditScan.LoadScan(Scan: TScanBericht);
var j: integer;
    sg: TScanGroup;
begin
  TXT_Planet.Text := Scan.Head.Planet;
  TXT_Position.Text := PositionToStrMond(Scan.Head.Position);
  TXT_Player.Text := Scan.Head.Spieler;
  for sg := low(sg) to high(sg) do
  begin
    for j := 0 to ScanFileCounts[sg]-1 do
    begin
      Edits[sg,j].Text := IntToStr(Scan.Bericht[sg,j]);
    end;
  end;
end;

procedure TFRM_EditScan.TXT_KeyPress(Sender: TObject;
  var Key: Char);
begin
  if not (Key in ['0'..'9','-',#8]) then
    Key := #0;
end;

procedure TFRM_EditScan.FormShow(Sender: TObject);
begin
  TXT_Planet.SetFocus;
end;

end.
