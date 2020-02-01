unit uChildren;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, uEngine, Resources, uCreature, uDrag;

type

  TFood = (Fish, Meat, Grass, Game, Wash, Aid);
  { TCell }

  TCell = class
    Index: integer;
    X, Y, W, H: TCoord;
    Child: TChild;

    Filled: boolean;
    Parent: PCreature;
    FoodTimer: int64;
    SmileTimer: int64;
    NeedFood: TFood;
    Img: TSprite;

    constructor Create;
    procedure Draw;
    procedure StartTimer;
    procedure StopTimer;
  end;

  TFoodData = record
    X, Y: TCoord;
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

  Eats: array[TChild] of TFood = (Grass, Fish, Meat);

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
    Index := 0;
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
    Index := 1;
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
    Index := 2;
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
    Index := 3;
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
var
  scale: TCoord;
begin
  if Filled and ((DragMode <> DragChild) or (DragItem <> Index)) then
  begin
    Sprite(Parent^.Small, X + W / 2, Y + H / 2);
    if GetTickCount64 mod 1000 > 450 then
      scale := 1.1
    else
      scale := 0.95;
    if (SmileTimer > GetTickCount64) then
      Sprite(RES.Happy, X + W / 4, Y + H / 4, scale, scale)
    else if (FoodTimer > 0) and (FoodTimer < GetTickCount64) then
      Sprite(RES.Cry, X + W / 4, Y + H / 4, scale, scale);
  end;
  Sprite(Img, X + W / 2, Y + H / 2);
end;

procedure TCell.StartTimer;
begin
  if not Filled then
    exit;
  FoodTimer := GetTickCount64 + (5 + Random(10)) * (1000 + random(100));
  case random(4) of
    0: NeedFood := Eats[Child];
    1: NeedFood := Wash;
    else
      NeedFood := Game;
  end;
end;

procedure TCell.StopTimer;
begin
  FoodTimer := -1;
  SmileTimer := -1;
end;

end.
