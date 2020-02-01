unit uDrag;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, uEngine, Resources, uCreature, uChildren;

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

function ProcessDrag: Boolean;
begin
  Result := False;
end;

function CheckDragStart(X, Y: TCoord): Boolean;
begin
  //check food


end;

function CheckDragDrop(X, Y: TCoord): Boolean;
begin

end;

procedure ResetDrag;
begin

end;

procedure DrawDrag;
begin

end;

end.

