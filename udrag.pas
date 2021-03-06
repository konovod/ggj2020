unit uDrag;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, uEngine, Resources, uCreature, uStars, Math;

type
  TDragMode = (NoDrag, DragChild, DragFood);


var
  DragMode: TDragMode;
  DragItem: integer;

function ProcessDrag: boolean;
function CheckDragStart(X, Y: TCoord): boolean;
function CheckDragDrop(X, Y: TCoord): boolean;
procedure ResetDrag;
procedure DrawDrag;

implementation

uses uChildren, uPaint;

function ProcessDrag: boolean;
begin
  if DragMode <> NoDrag then
  begin
    Result := True;
    if MouseState(LeftButton) <> mbsDown then
    begin
      CheckDragDrop(MouseGet(CursorX), MouseGet(CursorY));
      DragMode := NoDrag;
    end;
  end
  else
  begin
    Result := (MouseState(LeftButton) = mbsDown) and
      CheckDragStart(MouseGet(CursorX), MouseGet(CursorY));
  end;
end;

function FindCell(X, Y: TCoord): TCell;
var
  cell: TCell;
begin
  for cell in ALL_CELLS do
    if InRange(X, cell.X, Cell.X + cell.W) and InRange(Y, cell.Y, Cell.Y + cell.H) then
    begin
      Result := cell;
      exit;
    end;
  Result := nil;
end;

function CheckDragStart(X, Y: TCoord): boolean;
var
  fd: TFood;
  cell: TCell;
begin
  //check food
  for fd in TFood do
    if InRange(X, FOOD_POS[fd].X, FOOD_POS[fd].X + FoodW) and
      InRange(Y, FOOD_POS[fd].Y, FOOD_POS[fd].Y + FoodH) then
    begin
      DragMode := DragFood;
      DragItem := Ord(fd);
      Result := True;
      exit;
    end;
  //check cells
  cell := FindCell(X, Y);
  if (cell <> nil) and cell.Filled and (Scene = Application) then
  begin
    DragMode := DragChild;
    DragItem := Cell.index;
    Result := True;
    exit;
  end;
  //check child
  if Assigned(AppCurChild) and (Scene = Application) and
    InRange(X, ChildX - CellW * ChildCaptureX, ChildX + CellW * ChildCaptureX) and
    InRange(Y, ChildY - CellH * ChildCaptureY, ChildY + CellH * ChildCaptureY) and (AppCurChild <> AppAnimal) then
  begin
    DragMode := DragChild;
    DragItem := -1;
    Result := True;
    exit;
  end;
  Result := False;
end;

function CheckDragDrop(X, Y: TCoord): boolean;
var
  cell: TCell;
  animal: TCreature;
begin
  Result := False;
  case DragMode of
    NoDrag: exit;
    DragFood:
    begin
      cell := FindCell(X, Y);
      if not Assigned(cell) then
        exit;
      if (cell.FoodTimer <= 0) or (cell.FoodTimer > GetTickCount64) then
      begin
        Play(FOOD_POS[uChildren.TFood(DragItem)].Sound, FOOD_POS[uChildren.TFood(DragItem)].Volume);
        if (random < 0.25) then
          cell.SmileTimer := GetTickCount64 + 1000;
        exit;
      end;
      if cell.NeedFood <> uChildren.TFood(DragItem) then
      begin
        cell.PokerTimer := GetTickCount64 + 1000;
        Play(FOOD_POS[uChildren.TFood(DragItem)].Sound, FOOD_POS[uChildren.TFood(DragItem)].Volume);
        exit;
      end;
      Result := True;
      cell.StartTimer;
      Play(FOOD_POS[uChildren.TFood(DragItem)].Sound, FOOD_POS[uChildren.TFood(DragItem)].Volume);
      cell.SmileTimer := GetTickCount64 + 2000;
      FirstFood := False;
      Stars.AddStars(10, Cell.X+Cell.W/2, Cell.Y+Cell.H/2);
    end;
    DragChild:
    begin
      if DragItem < 0 then
        animal := AppCurChild
      else
        animal := ALL_CELLS[DragItem].Parent;
      cell := FindCell(X, Y);
      if cell = nil then
      begin
        if True {TODO - near the center} then
        begin
          if AppCurChild <> nil then
            exit;
          if AppAnimal <> animal then
            exit;
          //drop old item
          if DragItem < 0 then
            exit;
          ALL_CELLS[DragItem].Filled := False;
          ALL_CELLS[DragItem].StopTimer;
          AppCurChild := animal;
          Stars.AddStars(100, ChildX, ChildY);
        end;
      end
      else
      begin
        if cell.Filled then
          exit;
        if cell.Child <> animal.Child then
          exit;
        //drop old item
        if DragItem < 0 then
        begin
          AppCurChild := nil;
          Stars.AddStars(10, Cell.X+Cell.W/2, Cell.Y+Cell.H/2);
        end
        else
        begin
          ALL_CELLS[DragItem].StopTimer;
          ALL_CELLS[DragItem].Filled := False;
        end;

        cell.Filled := True;
        cell.Parent := animal;
        cell.StartTimer;
      end;
    end;
  end;
end;

procedure ResetDrag;
begin
  DragMode := NoDrag;
  DragItem := -1;
end;

procedure DrawDrag;
var
  animal: TCreature;
begin
  SetLayer(102);
  case DragMode of
    NoDrag: ;
    DragFood:
      Sprite(FOOD_POS[TFood(DragItem)].Img, MouseGet(CursorX),
        MouseGet(CursorY), 0.8, 0.8);
    DragChild:
    begin
      if DragItem < 0 then
        animal := AppCurChild
      else
        animal := ALL_CELLS[DragItem].Parent;
      Sprite(animal.Small, MouseGet(CursorX), MouseGet(CursorY));
    end;
  end;
  SetLayer(1);
end;

end.
