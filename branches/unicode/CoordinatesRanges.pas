unit CoordinatesRanges;

interface

uses Math, SysUtils, Classes;

type
  TCoordinate = Integer;
  PCoordinatesRange = ^TCoordinatesRange;
  TCoordinatesRange = record
    start, ende: TCoordinate;
  end;
  TCoordinates = array of TCoordinate;
  TCoordinatesProcedure = procedure(Coordinates: TCoordinates; var Cancel: Boolean) of object;
  TCoordinatesRangeList = class
  {  Looks like: [1-2:1-200:1-15]  }
  private
    FRList: TList;
    function GetCount: integer;
    function GetRangeByIndex(Index: Integer): TCoordinatesRange;
    procedure SetRangeByIndex(Index: Integer; aRange: TCoordinatesRange);
  public
    property Count: Integer read GetCount;
    property Range[Index: Integer]: TCoordinatesRange
      read GetRangeByIndex write SetRangeByIndex
      ; default;
    function AddRange(Range: TCoordinatesRange): Integer;
    procedure Clear;
    procedure ReadFromString(s: string);
    constructor Create;
    destructor Destroy; override;
    function GetAsString: String;
  end;

function ValidInteger(const S:String): Boolean;
function RangeIntersection(r1, r2: TCoordinatesRange): TCoordinatesRange;
function StrToRange(s: string): TCoordinatesRange;
function EndofRange(s: string): Word;
function BeginofRange(s: string): word;
function ValidRange(const s: String): Boolean;
procedure ProcessRangeList(RangeList: TCoordinatesRangeList; proc: TCoordinatesProcedure);
function ElementOfRange(x: TCoordinate; Range: TCoordinatesRange): Boolean;
function ElementOfRangeList(x: TCoordinates; Ranges: TCoordinatesRangeList): Boolean;
function RangeToStr(Range: TCoordinatesRange): string;
procedure RangeListIntersection(rohling, maske: TCoordinatesRangeList);

implementation

function ValidRange(const s: String): Boolean;
var p: integer;
    a,e: string;
begin
  if UpperCase(s) = 'X' then
    Result := true
  else
    if ValidInteger(s) then
      Result := True
    else
    begin
      p := pos('-',s);
      a := copy(s,1,p-1);
      e := copy(s,p+1,high(integer));
      Result := (p > 0)and ValidInteger(a)and ValidInteger(e)and(StrToInt(a) < StrToInt(e));
    end;
end;

function ValidInteger(const S:String): Boolean;
begin
  Result := True;
  try
    StrToInt(s);
  except
    Result := False;
  end;
end;

function BeginofRange(s: string): word;
var p: integer;
begin
  if UpperCase(s)  = 'X' then
    Result := low(Result)
  else
    if ValidInteger(s) then
      Result := StrToInt(s)
    else
    begin
      p := pos('-',s);
      Result := StrToInt(copy(s,1,p-1));
    end;
end;

function EndofRange(s: string): Word;
var p: integer;
begin
  if UpperCase(s) = 'X' then
    Result := high(Result)
  else
    if ValidInteger(s) then
      Result := StrToInt(s)
    else
    begin
      p := pos('-',s);
      Result := StrToInt(copy(s,p+1,length(s)-p));
    end;
end;

function RangeIntersection(r1, r2: TCoordinatesRange): TCoordinatesRange;
begin
  Result.start := IfThen((r1.start > r2.start),r1.start,r2.start);
  Result.ende  := IfThen((r1.ende  < r2.ende ),r1.ende ,r2.ende );
end;

function StrToRange(s: string): TCoordinatesRange;
begin
  Result.start := BeginofRange(s);
  Result.ende := EndofRange(s);
end;

procedure ProcessRangeList(RangeList: TCoordinatesRangeList; proc: TCoordinatesProcedure);
var listlength: integer;
    Coordinates: TCoordinates;
    cancel: boolean;
procedure ProcessRange(nr: integer);
var i: word;
begin
  for i := RangeList[nr].start to RangeList[nr].ende do  //Wenn Start > Ende -> kein Durchlauf!
  begin
    Coordinates[nr] := i;
    if (nr = listlength-1) then
      proc(Coordinates,cancel)
    else ProcessRange(nr+1);

    if cancel then break;
  end;
end;

begin
  if not Assigned(proc) then raise Exception.Create('ProcessRangeList: proc is not set!');

  listlength := RangeList.Count;
  setlength(Coordinates,listlength);
  cancel := False;
  if listlength > 0 then ProcessRange(0);
end;

function ElementOfRange(x: TCoordinate; Range: TCoordinatesRange): Boolean;
begin
  Result := (x >= Range.start)and(x <= Range.ende);
end;

function ElementOfRangeList(x: TCoordinates; Ranges: TCoordinatesRangeList): Boolean;
var cc, i: integer;
begin
  cc := length(x);
  if cc > Ranges.Count then raise Exception.Create('Coordinates different dimension!');

  Result := True;
  for i := 0 to cc-1 do
    Result := Result and ElementOfRange(x[i],Ranges[i]);
end;

procedure TCoordinatesRangeList.ReadFromString(s: string);
var p: integer;
    s1: string;
begin
  Clear;
  repeat
    p := pos(':',s);
    s1 := copy(s,1,IfThen((p > 0),p-1,high(integer)));
    delete(s,1,p);
    AddRange(StrToRange(s1));
  until (p = 0);
end;

function RangeToStr(Range: TCoordinatesRange): string;
begin
  if Range.start <> Range.ende then
    Result := IntToStr(Range.start) + '-' + IntToStr(Range.ende)
  else
    Result := IntToStr(Range.start);
end;

function TCoordinatesRangeList.GetAsString: string;
var i: integer;
begin
  Result := '';
  for i := 0 to Count-1 do
  begin
    if i > 0 then Result := Result + ':';
    Result := Result + RangeToStr(Range[i]);
  end;
end;

procedure RangeListIntersection(rohling, maske: TCoordinatesRangeList);
var i,l: Integer;
begin
  l := rohling.Count;
  if maske.Count <> l then
    raise Exception.Create('RangeListIntersection: lists are different in length!');

  for i := 0 to l-1 do
    rohling[i] := RangeIntersection(rohling[i], maske[i]);
end;

function TCoordinatesRangeList.AddRange(Range: TCoordinatesRange): Integer;
var p: PCoordinatesRange;
begin
  New(p);
  p^ := Range;
  Result := FRList.Add(p);
end;

procedure TCoordinatesRangeList.Clear;
var i: Integer;
begin
  for i := 0 to FRList.Count-1 do
    Dispose(PCoordinatesRange(FRList[i]));

  FRList.Clear;
end;

function TCoordinatesRangeList.GetCount: integer;
begin
  Result := FRList.Count;
end;

function TCoordinatesRangeList.GetRangeByIndex(
  Index: Integer): TCoordinatesRange;
begin
  Result := TCoordinatesRange(FRList[Index]^);
end;

procedure TCoordinatesRangeList.SetRangeByIndex(Index: Integer;
  aRange: TCoordinatesRange);
begin
  TCoordinatesRange(FRList[Index]^) := aRange;
end;

constructor TCoordinatesRangeList.Create;
begin
  inherited;
  FRList := TList.Create;
end;

destructor TCoordinatesRangeList.Destroy;
begin
  Clear;
  FRList.Free;
  inherited;
end;

end.
