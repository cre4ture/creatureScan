unit Suchen_Ersetzen;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Gauges, StdCtrls, OGame_Types, Prog_Unit;

type                                                                               
  TFRM_Suchen_Ersetzen = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Button1: TButton;
    Gauge1: TGauge;
    Label3: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  FRM_Suchen_Ersetzen: TFRM_Suchen_Ersetzen;

implementation

uses Notizen, Languages, cS_DB;

{$R *.DFM}

procedure TFRM_Suchen_Ersetzen.Button1Click(Sender: TObject);
var i, j: integer;
    nsuche, nersetzen: string;
    s: boolean;
begin
  nsuche := Edit1.Text;
  nersetzen := Edit2.Text;
  showmessage('this function is deaktivated! TODO: Implement');
  {if (nsuche <> '')and(nersetzen <> '') then
  with ODataBase do
  begin
    Gauge1.MaxValue := Systeme.Count + Berichte.Count + length(GlobalPlayerInfo) + FRM_Notizen.VST_Notizen.RootNodeCount;
    Gauge1.Progress := 0;
    for i := 0 to Systeme.Count-1 do  //Sonnensysteme
    begin
      s := false;
      for j := 1 to max_Planeten do
      if Systeme[i].Planeten[j].Player = nsuche then
      begin
        s := true;
        Systeme[i].Planeten[j].Player := nersetzen;
      end;
      if s then
        SaveSys(i);
      Gauge1.Progress := Gauge1.Progress +1;
    end;
    for i := 0 to length(Berichte)-1 do //Scanberichte
    begin
      if Berichte[i].Head.Spieler = nsuche then
      begin
        Berichte[i].Head.Spieler := nersetzen;
        SaveScan(i);
      end;
      Gauge1.Progress := Gauge1.Progress +1;
    end;
    for i := 0 to length(GlobalPlayerInfo)-1 do //neueste Forschungen der Spieler
    begin
      if GlobalPlayerInfo[i].Name = nsuche then
      begin
        GlobalPlayerInfo[i].Name := nersetzen;
        for j := i+1 to length(GlobalPlayerInfo)-1 do
          if GlobalPlayerInfo[j].Name = nersetzen then
          begin
            if GlobalPlayerInfo[i].ForschungsAktualitaet_u > GlobalPlayerInfo[j].ForschungsAktualitaet_u then
              GlobalPlayerInfo[i].Name := '------leer------'
            else GlobalPlayerInfo[j].Name := '------leer------';   //des stimmt schon! (für alle dies net checken!)
          end;
        Break;
        Gauge1.Progress := Gauge1.Progress + (length(GlobalPlayerInfo)-i);
      end;
      Gauge1.Progress := Gauge1.Progress +1;
    end;
    FRM_Notizen.ReplacePlayername(nsuche,nersetzen);
    Gauge1.Progress := Gauge1.Progress + FRM_Notizen.VST_Notizen.RootNodeCount;
  end
  else
    ShowMessage(STR_alles_ausfuellen); }
end;

procedure TFRM_Suchen_Ersetzen.FormCreate(Sender: TObject);
begin
  if SaveCaptions then SaveAllCaptions(Self,LangFile);
  if LoadCaptions then LoadAllCaptions(Self,LangFile);
end;

end.
