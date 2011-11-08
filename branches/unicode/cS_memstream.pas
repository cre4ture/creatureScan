unit cS_memstream;

interface

uses
  Classes;

type
  TAbstractFixedMemoryStream = class
  private
    fp: pointer;
    fpos: Longint;
    fsize: Longint;
  public
    property p: pointer read fp;
    property size: Longint read fsize;
    procedure WriteBuffer(const Buffer; Count: Longint);
    procedure ReadBuffer(var Buffer; Count: Longint);
  end;

  TFixedMemoryStream_out = class(TAbstractFixedMemoryStream)
  public
    constructor Create(const size: cardinal);
    destructor Destroy; override;
  end;
  TFixedMemoryStream_in = class(TAbstractFixedMemoryStream)
  public
    constructor Create(const aP: pointer; const size: cardinal);
  end;

implementation

uses SysUtils;

constructor TFixedMemoryStream_out.Create(const size: cardinal);
begin
  inherited Create;
  GetMem(fp,size);
  fsize := size;
end;

destructor TFixedMemoryStream_out.Destroy;
begin
  FreeMem(fp);
  inherited;
end;

procedure TAbstractFixedMemoryStream.WriteBuffer(const Buffer; Count: Longint);
var epos: Longint;
begin
  if (fpos >= 0) and (Count >= 0) then
  begin
    epos := fpos + Count;
    if epos > 0 then
    begin
      if epos > fsize then
        raise Exception.Create('TFixedMemoryStream.Write(): Write over end!');

      System.Move(Buffer, Pointer(Longint(fp) + fpos)^, Count);
      fpos := ePos;
      Exit;
    end;
  end;
  raise Exception.Create('TFixedMemoryStream.Write(): ERROR!');
end;

procedure TAbstractFixedMemoryStream.ReadBuffer(var Buffer; Count: Longint);
begin
  if (fpos >= 0) and (Count >= 0) then
  begin
    if (fsize - fpos) < Count then
      raise Exception.Create('TFixedMemoryStream.Read(): to long!');
    
    Move(Pointer(Longint(fp) + fpos)^, Buffer, Count);
    Inc(fpos, Count);
    Exit;
  end;
  raise Exception.Create('TFixedMemoryStream.Write(): ERROR!');
end;

{ TFixedMemoryStream_in }

constructor TFixedMemoryStream_in.Create(const aP: pointer;
  const size: cardinal);
begin
  inherited Create;
  fp := aP;
  fsize := size;
end;

end.
 