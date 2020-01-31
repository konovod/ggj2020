unit uPaint;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, uengine, Resources, math;

type
  TScene = (Paint, Application);

const
  PaintX = 500;
  PaintY = 300;
  PaintW = 300;
  PaintH = 300;

var
  Scene: TScene;
  AppX, AppY, AppAngle: TCoord;
  prevx, prevy: TCoord;

procedure GoPaint;
procedure GoApplication;
procedure DrawPaint;
procedure DrawApplication;
procedure DrawScene;


implementation

procedure DrawScene;
begin
  case Scene of
    Paint: DrawPaint;
    Application: DrawApplication;
  end;
end;


procedure GoPaint;
var
  i, j: Integer;
begin
  for i := 0 to PaintW-1 do
    for j := 0 to PaintH-1 do
      SetPixel(RES.Empty, i, j, 0);
  Scene := Paint;
end;

procedure GoApplication;
begin
  AppX := PaintX;
  AppY := PaintY;
  AppAngle := 0;
  Scene := Application;
end;

procedure DrawPaint;
var
  cx, cy: TCoord;
begin
  Background(RES.Back);
  Rect(PaintX-PaintW/2, PaintY-PaintH/2, PaintW,PaintH,true,$FFFFFF9F);
  Rect(PaintX-PaintW/2, PaintY-PaintH/2, PaintW,PaintH,false,$000000FF);
  Sprite(RES.Empty, PaintX, PaintY);

  if MouseState(LeftButton) = mbsDown then
  begin
    cx := MouseGet(CursorX) - (PaintX-PaintW/2);
    cy := MouseGet(CursorY) - (PaintY-PaintH/2);
    if InRange(cx, 0, PaintW-1) and InRange(cy, 0, PaintH-1)then
      begin
        SetPixel(RES.Empty, cx, cy, 255);
        SetPixel(RES.Empty, cx-1, cy, 255);
        SetPixel(RES.Empty, cx, cy-1, 255);
        SetPixel(RES.Empty, cx-1, cy-1, 255);
      end;
  end;

  if KeyState(KeyReturn) = ksPressed then
    GoApplication;
end;

procedure DrawApplication;
begin
  Background(RES.Back);
  Sprite(RES.Elephant2, PaintX, PaintY);
  Sprite(RES.Empty, AppX, AppY, 1, 1, AppAngle);

  if MouseState(LeftButton) = mbsDown then
  begin
    if prevx < 0 then
    begin
      prevx := MouseGet(CursorX);
      prevy := MouseGet(CursorY);
    end
    else
    begin
      AppX := AppX + MouseGet(CursorX) - prevx;
      AppY := AppY + MouseGet(CursorY) - prevy;
      prevx := MouseGet(CursorX);
      prevy := MouseGet(CursorY);
    end;
  end
  else
    prevx := -1;
  if MouseGet(ScrollPos) <> 0 then
    AppAngle := AppAngle + MouseGet(ScrollPos);

  if KeyState(KeyReturn) = ksPressed then
    GoPaint;
end;

end.

