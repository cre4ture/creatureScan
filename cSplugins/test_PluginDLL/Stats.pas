unit Stats;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, VirtualTrees, DLL_plugin_TEST, Ogame_Types,
  DateUtils;

type
  TFRM_Stats = class(TForm)
    Button1: TButton;
    VST_Stats: TVirtualStringTree;
    Shape1: TShape;
    ComboBox1: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    ComboBox2: TComboBox;
    procedure Button1Click(Sender: TObject);
    procedure VST_StatsGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure FormCreate(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    stats: TStat;
    stype: TStatTypeEx;
    { Public-Deklarationen }
  end;

var
  FRM_Stats: TFRM_Stats;

implementation

uses Sources;

{$R *.dfm}

procedure TFRM_Stats.Button1Click(Sender: TObject);
begin
  FillChar(stats,sizeof(stats),0);
  if plugin.ReadStats(FRM_Sources.plugin_handle, stats, stype) then
    Shape1.Brush.Color := clLime
  else Shape1.Brush.Color := clRed;
  VST_Stats.Refresh;
  ComboBox1.ItemIndex := Byte(stype.NameType);
  ComboBox2.ItemIndex := Byte(stype.PointType);
  Label2.Caption := DateTimeToStr(UnixToDateTime(stats.Time_u));
end;

procedure TFRM_Stats.VST_StatsGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
begin
  case Column of
  0: //nummer
    CellText := IntToStr(stats.first + node^.Index);
  1: //name
    CellText := stats.stats[node^.Index].Name;
  2: //punkte
    CellText := IntToStrKP(stats.stats[node^.Index].Punkte);
  3: //Ally
    CellText := stats.stats[node^.Index].Ally;
  4: //Mitglieder
    CellText := IntToStr(stats.stats[node^.Index].Mitglieder);
  5: // ID
    CellText := IntToStr(stats.stats[node^.Index].NameId);
  end;
end;

procedure TFRM_Stats.FormCreate(Sender: TObject);
begin
  VST_Stats.RootNodeCount := 100;
end;

end.
