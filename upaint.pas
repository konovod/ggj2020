unit uPaint;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, uengine, Resources, math, uCreature;

type
  TScene = (Flight, Paint, Application);

const
  PaintX = 656+300;
  PaintY = 93+300;
  PaintW = 600;
  PaintH = 600;

  MsgX = 656;
  MsgY = 150;

var
  Scene: TScene;
  AppX, AppY, AppAngle: TCoord;
  AppAnimal: TCreature;
  AppMissing: Integer;


  PaintColor: TColor;
  PaintR: Integer;
  prevx, prevy: TCoord;

procedure DrawScene;


procedure GoPaint;
procedure GoApplication;
procedure GoFlight;
procedure DrawPaint;
procedure DrawApplication;
procedure DrawFlight;

procedure UpdateImage;


implementation

procedure DrawScene;
begin
  case Scene of
    Paint: DrawPaint;
    Application: DrawApplication;
    Flight: DrawFlight;
  end;
end;


procedure GoPaint;
begin
  Scene := Paint;
  PaintColor:=$000000FF;
  PaintR:=3;
end;

procedure GoApplication;
begin
  AppX := PaintX;
  AppY := PaintY;
  AppAngle := 0;
  Scene := Application;
end;

procedure DrawCircle(cx, cy: TCoord);
var
  ax, ay: integer;
begin
  for ax := Trunc(cx) - PaintR to Trunc(cx) + PaintR do
    for ay := Trunc(cy) - PaintR to Trunc(cy) + PaintR do
      begin
        if not (InRange(ax, 0, PaintW-1) and InRange(ay, 0, PaintH-1)) then
          continue;
        if hypot(ax-Trunc(cx), ay-Trunc(cy)) > PaintR then continue;
        SetPixel(RES.Empty, ax, ay, PaintColor);
      end;
end;

procedure GoFlight;
begin
  Scene := Flight;
  AppAnimal := ALL_CREATURES[Random(NCREATURES)];
  AppMissing := Random(NPARTS)+1;
end;

procedure DrawPaint;
var
  cx, cy,dx,dy,dh, step: TCoord;
begin
  Background(RES.Back);
  Rect(PaintX-PaintW/2, PaintY-PaintH/2, PaintW,PaintH,true,$FFFFFF9F);
  Rect(PaintX-PaintW/2, PaintY-PaintH/2, PaintW,PaintH,false,$000000FF);
  Sprite(RES.Empty, PaintX, PaintY);

  cx := MouseGet(CursorX) - (PaintX-PaintW/2);
  cy := MouseGet(CursorY) - (PaintY-PaintH/2);
  if InRange(cx, 0, PaintW-1) and InRange(cy, 0, PaintH-1)then
    begin
      if MouseState(LeftButton) = mbsDown then
      begin
        if prevx < 0 then
        begin
          prevx := cx;
          prevy := cy;
          DrawCircle(cx, cy);
        end
        else
        begin
          dx := cx-prevx;
          dy := cy-prevy;
          dh := hypot(dx, dy);
          step := 0;
          while step < dh do
          begin
            prevx := prevx + dx/dh*0.5;
            prevy := prevy + dy/dh*0.5;
            step := step+0.5;
            DrawCircle(prevx, prevy);
          end;
          DrawCircle(cx, cy);
          prevx := cx;
          prevy := cy;
        end;
      end
      else
        prevx := -1;
    end;

  if MouseGet(ScrollPos) <> 0 then
    PaintR := EnsureRange(PaintR+Trunc(MouseGet(ScrollPos)), 1, 10);
  if MouseState(RightButton) = mbsClicked then
    if PaintColor = 0 then
      PaintColor := $000000FF
    else
      PaintColor := 0;

  if KeyState(KeyReturn) = ksPressed then
    GoApplication;
end;

procedure DrawApplication;
var
  i: integer;
begin
  Background(RES.Back);
  for i := 0 to NPARTS do
    if i <> AppMissing then
      Sprite(AppAnimal.Layers[I], PaintX, PaintY);
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
  begin
    UpdateImage;
    GoFlight;
  end;
end;

procedure DrawFlight;
begin
  Background(RES.Back);
  FontConfig(RES.Vera, 48, BLACK);
  DrawText(RES.Vera, PChar(AppAnimal.Name+' ждет новый '+AppAnimal.LayerNames[AppMissing]), MsgX, MsgY);

  if KeyState(KeyReturn) = ksPressed then
    GoPaint;
end;

procedure UpdateImage;
var
  i, j: integer;
  nx, ny: TCoord;
begin
  DrawRotatedCrunch(RES.Empty, AppAnimal.Layers[AppMissing], AppX - PaintX, AppY - PaintY, AppAngle );
  DrawRotatedCrunch(RES.Empty2, Res.Empty, 0,0,0 );
  //for i := 0 to PaintW-1 do
  //  for j := 0 to PaintH-1 do
  //    SetPixel(RES.Empty, i, j, 0);
end;

end.

