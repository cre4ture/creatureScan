unit ThreadProtocolObject;

interface

uses
  Controls, Sysutils, syncobjs, classes;

const
  TimeOut = 10000;

type
  TLogLevel = (llNormal, llDebug);
  TIdentifySenderFunction = function(Sender, SenderToIdentify: TObject;
    var SenderName: string): Boolean;
  TThreadProtocol = class
  protected
    Dir: String;
    CanWrite: TEvent;
    Protocol: TFileStream;
    procedure WriteString(s: string);
    function SenderToStr(Sender: TObject): String;
  public
    LogLevel: TLogLevel;
    OnIdentifySender: TIdentifySenderFunction;
    constructor Create(ADir: String);
    function DateToFilename(Date: TDate): String;
    procedure AddEntry(Sender: TObject; Entry: string; Level: TLogLevel = llNormal);
    destructor Destroy; override;
  end;

implementation

procedure TThreadProtocol.AddEntry(Sender: TObject; Entry: string; Level: TLogLevel = llNormal);
var final: string;
begin
  if (Level <= LogLevel) then
  begin
    final := DateTimeToStr(now) + '|' + SenderToStr(Sender) + '|:|' + Entry + #13 + #10;
    WriteString(final);
  end;
end;

constructor TThreadProtocol.Create(ADir: String);
begin
  inherited Create;
  Dir := ADir;
  LogLevel := llDebug;

  if (not FileExists(DateToFilename(now))) then
  begin
    Protocol := TFileStream.Create(DateToFilename(Now),fmCreate);
    Protocol.Free;
  end;
  Protocol := TFileStream.Create(DateToFilename(Now),fmOpenWrite or fmShareDenyNone);
  Protocol.Seek(0,soFromEnd);
  CanWrite := TEvent.Create(nil,False,True,'');

  AddEntry(Self,'Start Protocol');
end;

function TThreadProtocol.DateToFilename(Date: TDate): String;
var d,m,y: word;
begin
  DecodeDate(now,Y,M,D);
  Result := Dir + '_' + IntToStr(Y) + '.' + IntToStr(M) + '.' + IntToStr(D) + '.txt';
end;

destructor TThreadProtocol.Destroy;
begin
  AddEntry(Self,'End Protocol');
  Protocol.Free;
  CanWrite.Free;
  inherited Destroy;
end;

function TThreadProtocol.SenderToStr(Sender: TObject): String;
begin
  if Sender = Self then
    Result := 'ProtocolObject'
  else
  if not(Assigned(OnIdentifySender) and
         OnIdentifySender(Self, Sender, Result)) then
    Result := IntToHex(Cardinal(Sender),4)
end;

procedure TThreadProtocol.WriteString(s: string);
begin
  if CanWrite.WaitFor(TimeOut) = wrSignaled then
  try
    Protocol.Write(PChar(s)^,length(s));
  finally
    CanWrite.SetEvent;
  end else raise Exception.Create('TThreadProtocol.AddEntry: ' +
    'Timeout beim Warten auf Schreiberlaubnis MSG:' + s);
end;

end.
