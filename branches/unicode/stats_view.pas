unit stats_view;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, VirtualTrees, OGame_Types;

type
  Tfrm_stats_view = class(TForm)
    vst_stats: TVirtualStringTree;
    Label1: TLabel;
    procedure vst_statsGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: string);
    procedure FormCreate(Sender: TObject);
  private
    stats: TStat;
    typ: TStatTypeEx;
    { Private-Deklarationen }
  public
    constructor Create(AOwner: TComponent; aStat: TStat; aTyp: TStatTypeEx); reintroduce;
  end;

implementation

{$R *.dfm}

constructor Tfrm_stats_view.Create(AOwner: TComponent; aStat: TStat; aTyp: TStatTypeEx);
begin
  inherited Create(AOwner);
  stats := aStat;
  typ := aTyp;

  case typ.NameType of
    sntPlayer:
      begin
        if (typ.PointType = sptFleet) then
           vst_stats.Header.Columns.Items[5].Text := 'Schiffe'
         else
           vst_stats.Header.Columns.Items[5].Options := [];
      end;
    sntAlliance: vst_stats.Header.Columns.Items[4].Options := [];
  end;

end;

procedure Tfrm_stats_view.FormCreate(Sender: TObject);
begin
  vst_stats.RootNodeCount := 100;
  Label1.Caption := StatNameTypeTranslate_[typ.NameType] + '/' + StatPointTypeTranslate_[typ.PointType] + ': '+
    IntToStr(stats.first) + ' - ' + IntToStr(stats.first + stats.count-1);
end;

procedure Tfrm_stats_view.vst_statsGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var i: integer;
begin
  i := Node.Index;
  case Column of
    0: CellText := IntToStrKP(stats.first + i);
    1: CellText := stats.Stats[i].Name;
    2: CellText := IntToStrKP(stats.Stats[i].Punkte);
    3: CellText := IntToStr(stats.Stats[i].NameId);
    4: CellText := stats.Stats[i].Ally;
    5: CellText := IntToStrKP(stats.Stats[i].Elemente);
  end;
end;

end.
