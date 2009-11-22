unit PlanetListInterface;

interface

uses Classes, OGame_Types;

type
  TPlanetListInterface = class(TComponent)
  public
    function selectNextPlanet(out pos: TPlanetPosition): Boolean; virtual; abstract;
    function getPlanet(): TPlanetPosition; virtual; abstract;
    function selectPreviousPlanet(out pos: TPlanetPosition): Boolean; virtual; abstract;
  end;

implementation

{ TPlanetListInterface }

end.
