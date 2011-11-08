unit ImportProgress;

interface                                                                   

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Gauges;

type
  TFRM_ImportProgress = class(TForm)
    GroupBox1: TGroupBox;
    Button1: TButton;
    Gauge1: TGauge;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    ende: ^Boolean;
    procedure Go(z: Integer = 1);
    procedure SetMax(Value: Integer);
    { Public-Deklarationen }
  end;

implementation

uses Languages;

{$R *.DFM}


procedure TFRM_ImportProgress.Button1Click(Sender: TObject);
begin
  if ende <> nil then
    ende^ := true;
end;

procedure TFRM_ImportProgress.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if ende <> nil then ende^ := true;
end;

procedure TFRM_ImportProgress.FormCreate(Sender: TObject);
begin
  if SaveCaptions then SaveAllCaptions(Self,LangFile);
  if LoadCaptions then LoadAllCaptions(Self,LangFile);
end;

procedure TFRM_ImportProgress.Go(z: Integer = 1);
begin
  Gauge1.Progress := Gauge1.Progress+z;
end;

procedure TFRM_ImportProgress.SetMax(Value: Integer);
begin
  Gauge1.MaxValue := Value;
end;

procedure TFRM_ImportProgress.FormDestroy(Sender: TObject);
begin
  if ende <> nil then ende^ := true;
end;

end.
