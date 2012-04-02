unit stat_explorer;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, VirtualTrees, OGame_Types, Stat_Points;

type
  Tfrm_stat_explorer = class(TForm)
    vst_stats: TVirtualStringTree;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    rb_player: TRadioButton;
    rb_ally: TRadioButton;
    rb_points: TRadioButton;
    rb_fleet: TRadioButton;
    rb_research: TRadioButton;
    Edit1: TEdit;
    Label1: TLabel;
    procedure rb_playerClick(Sender: TObject);
    procedure vst_statsGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure FormShow(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
  private
    mStat: TStatPoints;
    nt: TStatNameType;
    pt: TStatPointType;

    procedure updateStats();
  public
    { Public-Deklarationen }
  end;

implementation

{$R *.dfm}

uses Prog_Unit;

const
  ecol_platz = 0;
  ecol_name = ecol_platz+1;
  ecol_points = ecol_name+1;
  ecol_elem = ecol_points+1;
  ecol_ally = ecol_elem+1;

{ Tfrm_stat_explorer }

procedure Tfrm_stat_explorer.Edit1Change(Sender: TObject);
var i: integer;
    node: PVirtualNode;
begin
  if (length(Edit1.Text) = 0) then
    exit;

  if (nt = sntAlliance) and (Edit1.Text[1] <> '[') then
  begin
    ShowMessage('Verwende bei der Suche nach Allianzen die [eckigen Klammern]!');
  end;

  vst_stats.ClearSelection;
  node := vst_stats.GetFirst();
  for i := 1 to mStat.Count*100 do
  begin
    if pos( LowerCase(Edit1.Text), LowerCase(mStat.Statistik[i].Name) ) = 1 then
    begin
      vst_stats.FocusedNode := node;
      vst_stats.Selected[node] := true;
      Exit;
    end;
    node := vst_stats.GetNextSibling(node);
  end;
end;

procedure Tfrm_stat_explorer.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
  begin
    Edit1Change(Sender);
    key := #0;
  end;
end;

procedure Tfrm_stat_explorer.FormShow(Sender: TObject);
begin
  updateStats;
end;

procedure Tfrm_stat_explorer.rb_playerClick(Sender: TObject);
begin
  updateStats;
end;

procedure Tfrm_stat_explorer.updateStats;
begin
  if rb_player.Checked then
    nt := sntPlayer
  else
    nt := sntAlliance;

  if rb_points.Checked then
    pt := sptPoints
  else
  if rb_fleet.Checked then
    pt := sptFleet
  else
    pt := sptResearch;

  mStat := ODataBase.Statistic.StatisticType[nt, pt];

  if (nt = sntAlliance) then
  begin
    vst_stats.Header.Columns[ecol_ally].Options := vst_stats.Header.Columns[ecol_ally].Options - [coVisible];
    vst_stats.Header.Columns[ecol_elem].Text := 'Mitglieder';
  end
  else
  begin
    vst_stats.Header.Columns[ecol_ally].Options := vst_stats.Header.Columns[ecol_ally].Options + [coVisible];
    vst_stats.Header.Columns[ecol_elem].Text := 'Schiffe';
  end;

  vst_stats.RootNodeCount := mStat.Count*100;
  vst_stats.Refresh;
end;

procedure Tfrm_stat_explorer.vst_statsGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var platz: integer;
begin
  platz := Node.Index+1;
  case Column of
  0: CellText := IntToStr(platz);
  1: CellText := mStat.Statistik[platz].Name;
  2: CellText := IntToStrKP(mStat.Statistik[platz].Punkte);
  3: CellText := IntToStrKP(mStat.Statistik[platz].Elemente);
  4: CellText := mStat.Statistik[platz].Ally;
  end;
end;

end.
