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

  ChildX = 1213;
  ChildY = 661;
  AppBaseX = 832;
  AppBaseY = 542;


var
  Scene: TScene;
  AppX, AppY, AppAngle: TCoord;
  AppAnimal: PCreature;
  AppMissing: Integer;
  AppCurChild: PCreature;



  PaintColor: TColor;
  PaintR: Integer;
  PaintShape: Integer = 1;
  ActiveShape: TSprite = res_Ashape1;
  prevx, prevy: TCoord;

  SomeAction: Int64;


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

uses uChildren, uDrag;

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
  PaintR:=10;
  SomeAction := -1;
end;

procedure GoApplication;
var
  ChildOK: Boolean;
  cell: TCell;
begin
  AppX := AppBaseX;
  AppY := AppBaseY;
  AppAngle := 0;
  Scene := Application;
  SomeAction := -1;
  ChildOK :=False;
  repeat
    AppCurChild := @ALL_CREATURES[Random(NCREATURES)+1];
    if random < 0.01 then break;
    //should be not same
    if AppCurChild = AppAnimal then continue;
    //should not be already
    ChildOK := True;
    for cell in ALL_CELLS do
      if cell.Filled and (cell.Parent = AppCurChild) then
      begin
        ChildOK := False;
        break;
      end;
    if not ChildOK then continue;
    //should be a room
    ChildOK := False;
    for cell in ALL_CELLS do
      if (not cell.Filled) and (cell.Child = AppCurChild^.Child) then
      begin
        ChildOK := True;
        break;
      end;
  until ChildOK;
  if not ChildOK then AppCurChild := nil;
end;

procedure DrawCircle(cx, cy: TCoord);
begin
  DrawRotatedCrunch(ActiveShape, Res.Empty, cx-ShapeW/4, cy-ShapeH/4, PaintR / ShapeW, PaintR / ShapeH, 1, PaintColor, False);
  if SomeAction < 0 then SomeAction := GetTickCount64+5000;
end;

procedure GoFlight;
begin
  Scene := Flight;
  AppAnimal := @ALL_CREATURES[Random(NCREATURES)+1];
  repeat
    AppMissing := Random(NPARTS)+1;
  until (not AppAnimal^.WasFixed[AppMissing]) or (random < 0.1);
  SomeAction := GetTickCount64;
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
    if not ProcessDrag then
    begin
      x := GetGUICoord(gcX);
      y := GetGUICoord(gcY);
      w := GetGUICoord(gcWidth);
      h := GetGUICoord(gcHeight);
      PaintR := EnsureRange(Trunc((MouseGet(CursorY) - y) / GetGUICoord(gcHeight) * PaintMaxR), 1, PaintMaxR);
    end
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
    if not ProcessDrag then
    begin
      if Index = 0 then
        PaintColor := 0
      else
        PaintColor := AppAnimal^.Palette[Index];
    end;
  end;

  if index = 0 then
    toshow := $FFFFFFFF
  else
    toshow := AppAnimal^.Palette[Index];

  SetLayer(101);
  Ellipse(x+ShapeW/2, y+ShapeH/2, ShapeW/2 - 5, ShapeH/2 - 5,true,toshow);
  SetLayer(1);
end;

procedure DrawPalette;
var
  i: Integer;
begin
  for i := 0 to AppAnimal^.PaletteSize do
    OneColor(i, ColorX1 + (i mod 2) * ColorDX, ColorY1 + (i div 2) * ColorDY);
end;

procedure DrawCells;
var
  cell: TCell;
begin
  for cell in ALL_CELLS do
    cell.Draw;
end;

procedure DrawFood;
var
  fd: TFood;
begin
  for fd in TFood do
    Sprite(FOOD_POS[fd].Img, FOOD_POS[fd].X+FoodW/2, FOOD_POS[fd].Y+FoodH/2);
end;

procedure DrawAddButtons;
begin
  Button(RES.Hud.Settings, 0, 57, 890, 59, 61);
  Button(RES.Hud.World, 0, 190, 885, 70, 70);
  if (SomeAction >= 0) and (SomeAction < GetTickCount64)  then
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
  DrawDrag;
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

  Sprite(RES.Empty, PaintX, PaintY);

  cx := MouseGet(CursorX) - (PaintX-PaintW/2);
  cy := MouseGet(CursorY) - (PaintY-PaintH/2);
  if not ProcessDrag then
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
      Sprite(AppAnimal^.Layers[I], AppBaseX, AppBaseY);
  Sprite(RES.Empty, AppX, AppY, 1, 1, AppAngle);

  if (AppCurChild <> nil) and ((DragMode <> DragChild)or(DragItem <> -1) ) then
    Sprite(AppCurChild^.Small, ChildX, ChildY);

  if not ProcessDrag then
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
      if SomeAction < 0 then SomeAction := GetTickCount64+4000;
      prevx := MouseGet(CursorX);
      prevy := MouseGet(CursorY);
    end;
  end
  else
    prevx := -1;
  if MouseGet(ScrollPos) <> 0 then
    AppAngle := AppAngle + MouseGet(ScrollPos)*4;
end;

procedure DrawFlight;
begin
  FontConfig(RES.Vera, 48, BLACK);
  DrawText(RES.Vera, PChar('К вам везут '+AppAnimal^.Name+#13#10'Ему срочно '+AppAnimal^.LayerNames[AppMissing]), MsgX, MsgY);
//  DrawText(RES.Vera, PChar(AppAnimal^.Name+' ждет новый '+AppAnimal^.LayerNames[AppMissing]), MsgX, MsgY);
  ProcessDrag;
end;

procedure UpdateImage;
begin
  AppAnimal^.WasFixed[AppMissing] := True;
  DrawRotatedCrunch(RES.Empty, AppAnimal^.Layers[AppMissing], AppX - PaintX, AppY - PaintY, 1, 1, AppAngle);
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

