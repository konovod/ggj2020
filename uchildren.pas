unit uChildren;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, uEngine, Resources, uCreature;

type

  { TCell }

  TCell = class
    X,Y,W,H: TCoord;
    Child: TChild;

    Filled: Boolean;
    Parent: PCreature;
    FoodTimer: Integer;
    Img: TSprite;

    constructor Create;
    procedure Draw;
  end;

  TFood = (Fish, Meat, Grass, Game, Wash, Aid);
  TFoodData = record
    X,Y: TCoord;
    Img: TSprite;
  end;

const
  CellW = 320;
  CellH = 206;

  CellX1 = 0;
  CellY1 = 65;

  CellX2 = -1;
  CellY2 = 342;

  CellX3 = 1584;
  CellY3 = 66;

  CellX4 = 1600;
  CellY4 = 342;

  FoodW = 164;
  FoodH = 164;

  FOOD_POS: array[TFood] of TFoodData = (
    (X: 347; Y: 835; Img: res_Fish),
    (X: 562; Y: 835; Img: res_Meat),
    (X: 776; Y: 835; Img: res_Grass),
    (X: 990; Y: 835; Img: res_Maracas),
    (X: 1205; Y: 835; Img: res_Wash),
    (X: 1419; Y: 835; Img: res_Aid)
  );

var
  ALL_CELLS: array of TCell;

procedure InitCells;

implementation


procedure InitCells;
begin
  SetLength(ALL_CELLS, 4);
  ALL_CELLS[0] := TCell.Create;
  with ALL_CELLS[0] do
  begin
    X := CellX1;
    Y := CellY1;
    W := CellW;
    H := CellH;
    Child := Herbivore;
    Img := RES.Cells.Fence;
  end;

  ALL_CELLS[1] := TCell.Create;
  with ALL_CELLS[1] do
  begin
    X := CellX2;
    Y := CellY2;
    W := CellW;
    H := CellH;
    Child := Herbivore;
    Img := RES.Cells.Fence2;
  end;

  ALL_CELLS[2] := TCell.Create;
  with ALL_CELLS[2] do
  begin
    X := CellX3;
    Y := CellY3;
    W := CellW;
    H := CellH;
    Child := Bird;
    Img := RES.Cells.Nest;
  end;

  ALL_CELLS[3] := TCell.Create;
  with ALL_CELLS[3] do
  begin
    X := CellX4;
    Y := CellY4;
    W := CellW;
    H := CellH;
    Child := Carnivore;
    Img := RES.Cells.Cell;
  end;
end;

{ TCell }

constructor TCell.Create;
begin

end;

procedure TCell.Draw;
begin
  Sprite(Img, X+W/2, Y+H/2);
  if Filled then
    Sprite(Parent^.Small, X+W/2, Y+H/2);
end;

end.

