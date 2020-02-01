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
  PaintMaxR = 20;

  MsgX = 656;
  MsgY = 150;

  BarX = 532;
  BarY = 323;
  BarW = 20;
  BarH = 232;

  ShapeX1 = 460;
  ShapeY1 = 600;
  ShapeDX = 80;
  ShapeDY = 80;
  ShapeW = 55;
  ShapeH = 55;

var
  Scene: TScene;
  AppX, AppY, AppAngle: TCoord;
  AppAnimal: TCreature;
  AppMissing: Integer;



  PaintColor: TColor;
  PaintR: Integer;
  PaintShape: Integer = 1;
  ActiveShape: TSprite = res_Ashape1;
  prevx, prevy: TCoord;



procedure DrawScene;


procedure GoPaint;
procedure GoApplication;
procedure GoFlight;


procedure DrawBasic;

procedure DrawPaint;
procedure DrawApplication;
procedure DrawFlight;

procedure UpdateImage;


implementation

procedure DrawScene;
begin
  DrawBasic;
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
  //if PaintColor = 0 then
  //begin
  //  for ax := Trunc(cx) - PaintR to Trunc(cx) + PaintR do
  //    for ay := Trunc(cy) - PaintR to Trunc(cy) + PaintR do
  //      begin
  //        if not (InRange(ax, 0, PaintW-1) and InRange(ay, 0, PaintH-1)) then
  //          continue;
  //        if hypot(ax-Trunc(cx), ay-Trunc(cy)) > PaintR then continue;
  //        SetPixel(RES.Empty, ax, ay, PaintColor);
  //      end;
  //end
  //else
  DrawRotatedCrunch(ActiveShape, Res.Empty, cx-ShapeW/4, cy-ShapeH/4, PaintR / ShapeW, PaintR / ShapeH, 1, PaintColor, False);
end;

procedure GoFlight;
begin
  Scene := Flight;
  AppAnimal := ALL_CREATURES[Random(NCREATURES)];
  AppMissing := Random(NPARTS)+1;
end;

function ShowPaintColor: TColor;
begin
  if PaintColor = 0 then
    Result := $FFFFFFFF
  else
    Result := PaintColor;
end;

procedure OneShape(id: integer; btn: TButton; shp: TSprite; x,y: TCoord);
begin
  if Button(btn, 0, x, y, ShapeW, ShapeH) = bsPressed then
    PaintShape := id;
  if id = PaintShape then
  begin
    SetLayer(101);
    Sprite(shp, x+ShapeW/2, y+ShapeH/2, 1,1,0,PaintColor);
    ActiveShape := shp;
    SetLayer(1);
  end;
end;

procedure DrawBar;
var
  x, y, w, h: TCoord;
begin
  Button(RES.Paint.Bar, 0, BarX, BarY, BarW, BarH);
  x := GetGUICoord(gcX);
  y := GetGUICoord(gcY);
  w := GetGUICoord(gcWidth);
  h := GetGUICoord(gcHeight);

  SetLayer(101);
  Sprite(ActiveShape, x+w/2,
    y+(h-PaintMaxR*3)*PaintR/PaintMaxR + PaintR/10,
    PaintR/10,
    PaintR/10,
    0,ShowPaintColor);
  SetLayer(1);
end;

procedure DrawBasic;
begin
  Background(RES.Back);
  DrawBar;

  OneShape(1, RES.Paint.Shape1, RES.Paint.Ashape1, ShapeX1, ShapeY1);
  OneShape(2, RES.Paint.Shape2, RES.Paint.Ashape2, ShapeX1+ShapeDX, ShapeY1);
  OneShape(3, RES.Paint.Shape3, RES.Paint.Ashape3, ShapeX1, ShapeY1+ShapeDY);
  OneShape(4, RES.Paint.Shape4, RES.Paint.Ashape4, ShapeX1+ShapeDX, ShapeY1+ShapeDY);

end;

procedure DrawPaint;
var
  cx, cy,dx,dy,dh, step: TCoord;
begin
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
    PaintR := EnsureRange(PaintR+Trunc(MouseGet(ScrollPos)), 1, PaintMaxR);
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
  DrawRotatedCrunch(RES.Empty, AppAnimal.Layers[AppMissing], AppX - PaintX, AppY - PaintY, 1, 1, AppAngle);
  DrawRotatedCrunch(RES.Empty2, Res.Empty, 0,0);
  //for i := 0 to PaintW-1 do
  //  for j := 0 to PaintH-1 do
  //    SetPixel(RES.Empty, i, j, 0);
end;

end.

