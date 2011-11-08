unit oFight;

interface

uses Math, OGame_Types, Windows;

type
  TShip = Record
    space: Integer;
    oil: Integer;
  end;
  TWBRec = record
    Scan: TScanBericht;
    StartPlanet: TPlanetPosition;
    ZielPlanet: TPlanetPosition;
    Ship: TShip;
  end;

function CalcDragoShips(WBRec: TWBRec; Welle: integer): integer;
function Treibstoffverbrauch(Start, Ziel: TPlanetPosition;
      Verbrauch: Integer): integer; 

implementation

uses SysUtils;

function Treibstoffverbrauch(Start, Ziel: TPlanetPosition;
  Verbrauch: Integer): integer;
var i: integer;
begin
  i := 0;
  Result := -1;
  while (i<2)and(Start.P[i] = Ziel.P[i]) do
    inc(i);
  case i of
    0: Result := 1+ round(Verbrauch*((20000000*abs(Ziel.p[i]-Start.p[i]))/35000000)*sqr(100/100+1));
    1: Result := 1+ round(Verbrauch*((2700000+95000*abs(Ziel.p[i]-Start.p[i]))/35000000)*sqr(100/100+1));
    2: Result := 1+ round(Verbrauch*((1000000+5000*abs(Ziel.p[i]-Start.p[i]))/35000000)*sqr(100/100+1));
  end;
end;

function Prozent(M,K,D: integer; var TransportPlatz: Int64): Integer;
var Mres,Kres,Dres,TP: Int64;
begin
  //Gibt zurück wieviel von der möglichen Beute(M,K,D) mitgenommen wird!

  TP := TransportPlatz;
  if M < TP /3 then
    Mres := M
  else
    Mres := TP div 3;


  TP := TP - Mres;

  if K < TP /2 then
    Kres := K
  else
    Kres := TP div 2;


  TP := TP - Kres;

  if D < TP then
    Dres := D
  else
    Dres := TP;


  TP := TP - Dres;

  {if M - Mres < TP /2 then
  begin
    Mres := Mres + (M-Mres);     hier sieht man, das man sich auf keinen
    TP := TP - (M-Mres);         fremden code verlassen darf!!!! lalalala
  end                            lol... DragoSim!!
  else                           und ich merks erst jetzt...  uli hornung
  begin                                                       (alias creature)
    Mres := Mres + (TP div 2);                                16.2.07 v1.4.7.a-b
    TP := TP - (TP div 2);
  end;                                       (nach 2 stunden suche!!!!) uff...

  if K - Kres < TP then
  begin
    Kres := Kres + (K-Kres);
    TP := TP - (K-Kres);
  end
  else
  begin
    Kres := Kres + (TP);
    TP := TP - (TP);
  end;}

  if M - Mres < TP /2 then
  begin
    TP := TP - (M-Mres);      //Zeilen vertauschen, jetzt gehts!!!!
    Mres := Mres + (M-Mres);
  end
  else
  begin
    Mres := Mres + (TP div 2);
    TP := TP - (TP div 2);
  end;

  if K - Kres < TP then
  begin
    TP := TP - (K-Kres);
    Kres := Kres + (K-Kres);  //Zeilen vertauschen, jetzt gehts!!!!
  end
  else
  begin
    Kres := Kres + (TP);
    TP := TP - (TP);
  end;


  TransportPlatz := TP;

  if M+K+D <> 0 then
    Result := trunc(100*((Mres+Kres+Dres)/(M+K+D)))
  else
    Result := 100;   
end;

function CalcDragoShips(WBRec: TWBRec; Welle: integer): integer;
{not $DEFINE CalcDragoShips_Debug}
var last,next: integer;
    TP: Int64;
    M,K,D: integer;
    {$IFDEF CalcDragoShips_Debug}
    icount,dcount: Integer;
    {$ENDIF}
begin
  with WBRec do
  begin
    M := trunc(Scan.Bericht[sg_Rohstoffe,0] / IntPower(2,welle));
    K := trunc(Scan.Bericht[sg_Rohstoffe,1] / IntPower(2,welle));
    D := trunc(Scan.Bericht[sg_Rohstoffe,2] / IntPower(2,welle));

    {$IFDEF CalcDragoShips_Debug}
    icount := 0;
    {$ENDIF}
    //Ungefährer Voranschlag:   Res_Gesammt/Platz_pro_Shiff
    result := ceil((M+K+D) / Ship.space);
    TP := (Result * Ship.space);
    next := Prozent(M,K,D,TP);
    while (next < 100) do
    begin
      last := (Result * Ship.space);
      {$IFDEF CalcDragoShips_Debug}
      inc(icount);
      {$ENDIF}
      inc(Result,ceil(    ((Result/next)*(100-next))/2   ));
        //Ab ceil: 15.2.07: um die anzahl der schritte zu verringen
        //wird gleich prozentual mehr addiert!
      TP := (Result * Ship.space);
      next := Prozent(M,K,D,TP);
      if (last < 0) then
      begin
        Result := -1;
        Break;
      end;
    end;

    //Nachtrag: Wegen der Optimierung oben, kann es passieren, das zuviele
    //schiffe berechnet werden!
    {$IFDEF CalcDragoShips_Debug}
    dcount := 0;
    {$ENDIF}
    TP := (Result-1)*Ship.Space;
    while (prozent(M,K,D,TP) >= 100)and(result > 0) do
    begin
      {$IFDEF CalcDragoShips_Debug}
      inc(dcount);
      {$ENDIF}
      dec(Result);
      TP := (Result-1)*Ship.Space;
    end;

  end;
  {$IFDEF CalcDragoShips_Debug}
  OutputDebugString(PCHAR('inc_count: ' + IntToStr(icount) + ' dec_count: ' + IntToStr(dcount)));
  {$ENDIF}
end;

end.
