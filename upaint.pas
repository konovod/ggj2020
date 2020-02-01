unit uPaint;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, uengine, Resources, math, uCreature;

type
  TScene = (Flight, Paint, Application);

const

  PrinterX=434;
  PrinterY=39;
  PrinterW=1102;
  PrinterH=744;

  PaintX = 656+300;
  PaintY = 93+300;
  PaintW = 600;
  PaintH = 600;
  PaintMaxR = 20;

  MsgX = 656;
  MsgY = 150;

  BarX = 492;
  BarY = 323;
  BarW = 100;
  BarH = 232;

  ShapeX1 = 460;
  ShapeY1 = 600;
  ShapeDX = 80;
  ShapeDY = 80;
  ShapeW = 55;
  ShapeH = 55;

  ColorX1 = 1350;
  ColorY1 = 468;
  ColorDX = 110;
  ColorDY = 75;

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

  FoodX1 = 347;
  FoodY1 = 835;
  FoodX2 = 562;
  FoodY2 = 835;
  FoodX3 = 776;
  FoodY3 = 835;
  FoodX4 = 990;
  FoodY4 = 835;
  FoodX5 = 1205;
  FoodY5 = 835;
  FoodX6 = 1419;
  FoodY6 = 835;

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

  SomeAction: Boolean;



procedure DrawScene;


procedure GoPaint;
procedure GoApplication;
procedure GoFlight;

procedure GoNextStage;

procedure DrawBasic;

procedure DrawPaint;
procedure DrawApplication;
procedure DrawFlight;

procedure UpdateImage;

procedure BuildPalettes;

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
  SomeAction := False;
end;

procedure GoApplication;
begin
  AppX := PaintX;
  AppY := PaintY;
  AppAngle := 0;
  Scene := Application;
  SomeAction := False;
end;

procedure DrawCircle(cx, cy: TCoord);
begin
  DrawRotatedCrunch(ActiveShape, Res.Empty, cx-ShapeW/4, cy-ShapeH/4, PaintR / ShapeW, PaintR / ShapeH, 1, PaintColor, False);
  SomeAction := True;
end;

procedure GoFlight;
begin
  Scene := Flight;
  AppAnimal := ALL_CREATURES[Random(NCREATURES)+1];
  AppMissing := Random(NPARTS)+1;
  SomeAction := True;
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
  if Button(RES.Paint.Bar, 0, BarX, BarY, BarW, BarH) = bsPressed then
  begin
    x := GetGUICoord(gcX);
    y := GetGUICoord(gcY);
    w := GetGUICoord(gcWidth);
    h := GetGUICoord(gcHeight);
    PaintR := EnsureRange(Trunc((MouseGet(CursorY) - y) / GetGUICoord(gcHeight) * PaintMaxR), 1, PaintMaxR);
  end;
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

procedure OneColor(Index: Integer; x,y: TCoord);
var
  toshow: TColor;
begin
  if Button(Res.Paint.Color, 0, x, y, ShapeW, ShapeH) = bsPressed then
  begin
    if Index = 0 then
      PaintColor := 0
    else
      PaintColor := AppAnimal.Palette[Index];
  end;

  if index = 0 then
    toshow := $FFFFFFFF
  else
    toshow := AppAnimal.Palette[Index];

  SetLayer(101);
  Ellipse(x+ShapeW/2, y+ShapeH/2, ShapeW/2 - 5, ShapeH/2 - 5,true,toshow);
  SetLayer(1);
end;

procedure DrawPalette;
var
  i: Integer;
begin
  for i := 0 to AppAnimal.PaletteSize do
    OneColor(i, ColorX1 + (i mod 2) * ColorDX, ColorY1 + (i div 2) * ColorDY);
end;

procedure DrawCells;
begin
  Sprite(RES.Cells.Fence, CellX1+CellW/2, CellY1+CellH/2);
  Sprite(RES.Cells.Fence2, CellX2+CellW/2, CellY2+CellH/2);
  Sprite(RES.Cells.Nest, CellX3+CellW/2, CellY3+CellH/2);
  Sprite(RES.Cells.Cell, CellX4+CellW/2, CellY4+CellH/2);
end;

procedure DrawFood;
begin
  Sprite(RES.Food.Fish, FoodX1+FoodW/2, FoodY1+FoodH/2);
  Sprite(RES.Food.Meat, FoodX2+FoodW/2, FoodY2+FoodH/2);
  Sprite(RES.Food.Grass, FoodX3+FoodW/2, FoodY3+FoodH/2);
  Sprite(RES.Food.Maracas, FoodX4+FoodW/2, FoodY4+FoodH/2);
  Sprite(RES.Food.Wash, FoodX5+FoodW/2, FoodY5+FoodH/2);
  Sprite(RES.Food.Aid, FoodX6+FoodW/2, FoodY6+FoodH/2);
end;

procedure DrawAddButtons;
begin
  Button(RES.Hud.Settings, 0, 57, 890, 59, 61);
  Button(RES.Hud.World, 0, 190, 885, 70, 70);
  if SomeAction then
  begin
    if Button(RES.Hud.Go, 0, 1632, 858, 250, 134) = bsClicked then
      GoNextStage;
  end
  else
    Button(RES.Hud.Stop, 0, 1628, 859, 257, 137)
end;

procedure GoNextStage;
begin
  case Scene of
    Flight: GoPaint;
    Paint: GoApplication;
    Application:
    begin
      UpdateImage;
      GoFlight;
    end;
  end;
end;

procedure DrawBasic;
begin
  Background(RES.Back);
  DrawCells;
  DrawFood;
  DrawAddButtons;
end;

procedure DrawPaint;
var
  cx, cy,dx,dy,dh, step: TCoord;
begin
  Sprite(RES.Printer, PrinterX+PrinterW/2, PrinterY+PrinterH/2);
  DrawBar;

  OneShape(1, RES.Paint.Shape1, RES.Paint.Ashape1, ShapeX1, ShapeY1);
  OneShape(2, RES.Paint.Shape2, RES.Paint.Ashape2, ShapeX1+ShapeDX, ShapeY1);
  OneShape(3, RES.Paint.Shape3, RES.Paint.Ashape3, ShapeX1, ShapeY1+ShapeDY);
  OneShape(4, RES.Paint.Shape4, RES.Paint.Ashape4, ShapeX1+ShapeDX, ShapeY1+ShapeDY);

  DrawPalette;

  //Rect(PaintX-PaintW/2, PaintY-PaintH/2, PaintW,PaintH,true,$FFFFFF9F);
  //Rect(PaintX-PaintW/2, PaintY-PaintH/2, PaintW,PaintH,false,$000000FF);

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
  end
  else
    prevx := -1;
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
      SomeAction := True;
      prevx := MouseGet(CursorX);
      prevy := MouseGet(CursorY);
    end;
  end
  else
    prevx := -1;
  if MouseGet(ScrollPos) <> 0 then
    AppAngle := AppAngle + MouseGet(ScrollPos);
end;

procedure DrawFlight;
begin
  FontConfig(RES.Vera, 48, BLACK);
  DrawText(RES.Vera, PChar(AppAnimal.Name+' ждет новый '+AppAnimal.LayerNames[AppMissing]), MsgX, MsgY);
end;

procedure UpdateImage;
begin
  DrawRotatedCrunch(RES.Empty, AppAnimal.Layers[AppMissing], AppX - PaintX, AppY - PaintY, 1, 1, AppAngle);
  DrawRotatedCrunch(RES.Empty2, Res.Empty, 0,0);
end;

function ColorDelta(c1, c2: TColor): Integer;
var
  red, blue, green: Integer;
begin
  red := abs((c1 shr 24) - (c2 shr 24));
  green := abs(((c1 shr 16) and 255) - ((c2 shr 16) and 255));
  blue := abs(((c1 shr 8) and 255) - ((c2 shr 8) and 255));
  Result := red+green+blue;
end;

procedure BuildPalettes;
var
  cr: PCreature;
  crindex, index, lay, i, j: Integer;
  found: boolean;
  c: TColor;
  label palette_full;
begin
  for crindex := 1 to NCREATURES do
  begin
    cr := @ALL_CREATURES[crindex];
    cr^.PaletteSize := 1;
    cr^.Palette[1] := $000000FF;
    for lay := 0 to NPARTS do
      for i := 0 to PaintW-1 do
        for j := 0 to PaintH-1 do
        begin
          c := GetPixel(i,j,cr^.Layers[lay]);
          if c and 255 < 250 then continue;
          found := false;
          for index := 1 to cr^.PaletteSize do
            if ColorDelta(cr^.Palette[index], c) < 100 then
            begin
              found := True;
              break;
            end;
          if not found then
          begin
            Inc(cr^.PaletteSize);
            cr^.Palette[cr^.PaletteSize] := (c and (not 255)) or 255;
            if cr^.PaletteSize >= MAXPALETTE then goto palette_full;
          end;
        end;
    palette_full:;
  end;
end;

end.

