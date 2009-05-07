unit Stats_Einlesen;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, OGame_Types, Prog_Unit, Clipbrd, Languages,
  clipbrdfunctions, Stat_Points;

type
  TFRM_Stats_Einlesen = class(TForm)                                             
    PaintBox1: TPaintBox;
    PaintBox2: TPaintBox;
    PaintBox3: TPaintBox;
    PaintBox4: TPaintBox;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Timer1: TTimer;
    Panel2: TPanel;
    Button1: TButton;
    CH_Beep: TCheckBox;
    TXT_punkte: TEdit;
    Label3: TLabel;
    TXT_fleet: TEdit;
    TXT_Ally: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    procedure PaintBox3Paint(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    LastClipBoard: String;
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

implementation

{$R *.DFM}

procedure TFRM_Stats_Einlesen.PaintBox3Paint(Sender: TObject);
var i: integer;
begin
  with TPaintBox(Sender) do
  begin
    Canvas.Pen.Style := psClear;
    Canvas.Rectangle(Canvas.ClipRect);
    i := 0;
    while (i-1)*16 + 1 < PaintBox3.Height do
    begin
      Canvas.TextOut(5,(i-1)*16+1,IntToStr(((i-1)*100)+1));
      inc(i);
    end;
  end;
end;

procedure TFRM_Stats_Einlesen.PaintBox1Paint(Sender: TObject);
var i: integer;
    D: TDateTime;
    St: TStatPoints;
begin
  case TComponent(Sender).Tag of
    0: St := ODataBase.Stats;
    1: St := ODataBase.FleetStats;
    2: St := ODataBase.AllyStats;
  else
    Exit;
  end;
  with TPaintBox(Sender) do
  begin
    Canvas.Pen.Style := psClear;
    i := 0;
    d := St.Datum[i*100+1];
    while d <> -1 do
    begin
      Canvas.Brush.Color := AlterToColor_dt(now - D,ODataBase.redHours[rh_Stats]);
      Canvas.Rectangle(0,i*16,Width,i*16+16);
      Canvas.TextOut(4,i*16+1,DateTimeToStr(D));

      inc(i);
      d := St.Datum[i*100+1];
    end;
  end;
end;

procedure TFRM_Stats_Einlesen.Timer1Timer(Sender: TObject);
var st: TStat;
    st_typ: TStatTypeEx;
    text: string;

    i: integer;
begin
  try
    text := ClipBoard.AsText;
    if Text <> LastClipBoard then
    begin
      ODataBase.LanguagePlugIn.SetReadSourceText(text);
      ODataBase.LanguagePlugIn.SetReadSourceHTML(ReadClipboardHtml);

      LastClipBoard := Text;//Memo1.Lines.Text;
      begin
        if ODataBase.LanguagePlugIn.ReadStats(st,st_typ) then
        begin
          ODataBase.Statistic.AddStats(st_typ.NameType,st_typ.PointType,st);
          if CH_Beep.Checked then Beep;

          // Suche nach eigenen Punkten:
          for i := 0 to 99 do
          begin
            if st.Stats[i].Name = ODataBase.Username then
            begin
              if (st_typ.PointType = sptPoints)and(st_typ.NameType = sntPlayer) then
              begin
                TXT_punkte.Text := IntToStr(st.Stats[i].Punkte);
                TXT_punkte.Color := clLime;
                break;
              end;
            end;
          end;
        end
      end;
    end;
  except

  end;
  PaintBox1.Repaint;
  PaintBox2.Repaint;
  PaintBox4.Repaint;
end;

procedure TFRM_Stats_Einlesen.FormCreate(Sender: TObject);
begin
  if SaveCaptions then SaveAllCaptions(Self,LangFile);
  if LoadCaptions then LoadAllCaptions(Self,LangFile);
  
  LastClipBoard := ClipBoard.AsText;
  DoubleBuffered := True;
  CH_Beep.Checked := True;
end;

end.
