unit uDrag;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, uEngine, Resources, uCreature, uChildren, Math;

type
  TDragMode = (NoDrag, DragChild, DragFood);

var
DragMode: TDragMode;
DragItem: Integer;

function ProcessDrag: Boolean;
function CheckDragStart(X, Y: TCoord): Boolean;
function CheckDragDrop(X, Y: TCoord): Boolean;
procedure ResetDrag;
procedure DrawDrag;

implementation

uses uPaint;

function ProcessDrag: Boolean;
begin
  Result := False;
end;

function FindCell(X, Y: TCoord): TCell;
var
  cell: TCell;
begin
  for cell in ALL_CELLS do
    if InRange(X, cell.X, Cell.X+cell.W) and InRange(Y, cell.Y, Cell.Y+cell.H) then
    begin
      Result := cell;
      exit
    end;
  Result := nil;
end;

function CheckDragStart(X, Y: TCoord): Boolean;
var
  fd: TFood;
  cell: TCell;
  ani: PCreature;
begin
  //check food
  for fd in TFood do
    if InRange(X, FOOD_POS[fd].X, FOOD_POS[fd].X+FoodW) and InRange(Y, FOOD_POS[fd].Y, FOOD_POS[fd].Y+FoodH) then
    begin
      DragMode := DragFood;
      DragItem := Ord(fd);
      Result := True;
      exit;
    end;
  //check cells
  cell := FindCell(X, Y);
  if (cell <> nil) and cell.Filled then
  begin
    DragMode := DragChild;
    DragItem := Cell.index;
    Result := True;
    exit;
  end;
  //check child
  if Assigned(AppCurChild) and InRange(X, ChildX-CellW/2, ChildX+CellW/2) and InRange(Y, ChildY-CellH/2, ChildY-CellH/2) then
    begin
      DragMode := DragChild;
      DragItem := -1;
      Result := True;
      exit;
    end;
  Result := False;
end;

function CheckDragDrop(X, Y: TCoord): Boolean;
var
  cell: TCell;
  animal: PCreature;
begin
  Result := False;
  case DragMode of
    NoDrag: exit;
    DragFood:
      begin
        cell := FindCell(X, Y);
        if not Assigned(cell) then exit;
        if (cell.FoodTimer <= 0) or (cell.FoodTimer > GetTickCount64) then exit;
        if cell.NeedFood <> TFood(DragItem) then exit;
        Result := True;
        //TODO Food aten, now create next food
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
          if true {TODO - near the center} then
          begin
            if AppCurChild <> nil then exit;
            if AppAnimal <> animal then exit;
            //drop old item
            if DragItem < 0 then exit;
            ALL_CELLS[DragItem].Filled := False;
            AppCurChild := animal;
            //TODO well, child found
          end;
        end
        else
        begin
          if cell.Filled then exit;
          if cell.Child <> animal^.Child then exit;
          //drop old item
          if DragItem < 0 then
            AppCurChild                                          ;
          ALL_CELLS[DragItem].Filled := False;
          cell.Filled := True;
          //TODO well, child found
        end;

      end;
  end;

end;

procedure ResetDrag;
begin

end;

procedure DrawDrag;
begin

end;

end.

