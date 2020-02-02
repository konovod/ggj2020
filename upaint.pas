unit uPaint;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, uengine, Resources, Math, uCreature, uStars;

type
  TScene = (Flight, Paint, Application);

const

  BackgroundColor = $FBEADCFF;

  PrinterX = 434;
  PrinterY = 39;
  PrinterW = 1102;
  PrinterH = 744;

  PaintX = 656 + 300;
  PaintY = 93 + 300;
  PaintW = 600;
  PaintH = 600;
  PaintMaxR = 20;

  MsgX = 1920/2;
  MsgY = 100;

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
  AppBaseX = 957;
  AppBaseY = 410;

  ChildCaptureX = 0.33;
  ChildCaptureY = 0.5;


var
  Scene: TScene;
  AppX, AppY, AppAngle: TCoord;
  AppAnimal: TCreature;
  AppMissing: integer;
  AppCurChild: TCreature;



  PaintColor: TColor;
  PaintR: integer;
  PaintShape: integer = 1;
  ActiveShape: TSprite = res_Ashape1;
  prevx, prevy, DragX, DragY: TCoord;
  DragAngle: Boolean;

  LimitX1, LimitX2, LimitY1, LimitY2: TCoord;

  SomeAction: int64;


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
  PaintColor := AppAnimal.Palette[Random(AppAnimal.PaletteSize)+1];
  PaintR := 7+random(5);
  SomeAction := -1;
end;

procedure GoApplication;
var
  ChildOK: boolean;
  cell: TCell;
  i, j: Integer;
  c: TColor;
begin
  AppX := AppBaseX;
  AppY := AppBaseY;
  AppAngle := 0;
  Scene := Application;
  SomeAction := -1;
  ChildOK := False;
  repeat
    AppCurChild := ALL_CREATURES[Random(NCREATURES) + 1];
    if random < 0.01 then
      break;
    //should be not same
    if AppCurChild = AppAnimal then
      continue;
    //should not be already
    ChildOK := True;
    for cell in ALL_CELLS do
      if cell.Filled and (cell.Parent = AppCurChild) then
      begin
        ChildOK := False;
        break;
      end;
    if not ChildOK then
      continue;
    //should be a room
    ChildOK := False;
    for cell in ALL_CELLS do
      if (not cell.Filled) and (cell.Child = AppCurChild.Child) then
      begin
        ChildOK := True;
        break;
      end;
  until ChildOK;
  if not ChildOK then
    AppCurChild := nil;

  LimitX1 := PaintW-1;
  LimitX2 := 1;
  LimitY1 := PaintH-1;
  LimitY2 := 1;
  for i := 0 to PaintW - 1 do
    for j := 0 to PaintH - 1 do
    begin
      c := GetPixel(i,j,RES.Empty);
      if c and 255 < 250 then
        continue;
      if i < LimitX1 then LimitX1 := i;
      if i > LimitX2 then LimitX2 := i;
      if j < LimitY1 then LimitY1 := j;
      if j > LimitY2 then LimitY2 := j;
    end;
end;

procedure DrawCircle(cx, cy: TCoord);
begin
  DrawRotatedCrunch(ActiveShape, Res.Empty, cx - ShapeW / 4, cy - ShapeH / 4,
    PaintR / ShapeW, PaintR / ShapeH, 1, PaintColor, False);
  if SomeAction < 0 then
    SomeAction := GetTickCount64 + 5000;
end;

procedure GoFlight;
begin
  Scene := Flight;
  AppAnimal := ALL_CREATURES[Random(NCREATURES) + 1];
  repeat
    AppMissing := Random(AppAnimal.NParts) + 1;
  until (not AppAnimal.WasFixed[AppMissing]) or (random < 0.1);
  SomeAction := GetTickCount64;
end;

function ShowPaintColor: TColor;
begin
  if PaintColor = 0 then
    Result := BackgroundColor
  else
    Result := PaintColor;
end;

procedure OneShape(id: integer; btn: TButton; shp: TSprite; x, y: TCoord);
begin
  if Button(btn, 0, x, y, ShapeW, ShapeH) = bsPressed then
    PaintShape := id;
  if id = PaintShape then
  begin
    SetLayer(101);
    Sprite(shp, x + ShapeW / 2, y + ShapeH / 2, 1, 1, 0, PaintColor);
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
      PaintR := EnsureRange(Trunc((MouseGet(CursorY) - y) /
        GetGUICoord(gcHeight) * PaintMaxR), 1, PaintMaxR);
    end;
  end;
  x := GetGUICoord(gcX);
  y := GetGUICoord(gcY);
  w := GetGUICoord(gcWidth);
  h := GetGUICoord(gcHeight);

  SetLayer(101);
  Sprite(ActiveShape, x + w / 2,
    y + (h - PaintMaxR * 3) * PaintR / PaintMaxR + PaintR / 10,
    PaintR / 10,
    PaintR / 10,
    0, ShowPaintColor);
  SetLayer(1);
end;

procedure OneColor(Index: integer; x, y: TCoord);
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
        PaintColor := AppAnimal.Palette[Index];
    end;
  end;

  if index = 0 then
    toshow := BackgroundColor
  else
    toshow := AppAnimal.Palette[Index];

  SetLayer(101);
  Ellipse(x + ShapeW / 2, y + ShapeH / 2, ShapeW / 2 - 5, ShapeH / 2 - 5, True, toshow);
  SetLayer(1);
end;

procedure DrawPalette;
var
  i: integer;
begin
  for i := 0 to AppAnimal.PaletteSize do
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
    Sprite(FOOD_POS[fd].Img, FOOD_POS[fd].X + FoodW / 2, FOOD_POS[fd].Y + FoodH / 2);
end;

procedure DrawAddButtons;
begin
  Button(RES.Hud.Settings, 0, 57, 890, 59, 61);
  Button(RES.Hud.World, 0, 190, 885, 70, 70);
  if (SomeAction >= 0) and (SomeAction < GetTickCount64) then
  begin
    if Button(RES.Hud.Go, 0, 1632, 858, 250, 134) = bsClicked then
      GoNextStage;
  end
  else
  if Button(RES.Hud.Stop, 0, 1628, 859, 257, 137) = bsClicked then
    GoNextStage;
  //Button(RES.Hud.Stop, 0, 1628, 859, 257, 137)
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
  Stars.Draw;
  Stars.Process;
end;

procedure DrawPaint;
var
  cx, cy, dx, dy, dh, step: TCoord;
begin
  Sprite(RES.Printer, PrinterX + PrinterW / 2, PrinterY + PrinterH / 2);
  DrawBar;

  OneShape(1, RES.Paint.Shape1, RES.Paint.Ashape1, ShapeX1, ShapeY1);
  OneShape(2, RES.Paint.Shape2, RES.Paint.Ashape2, ShapeX1 + ShapeDX, ShapeY1);
  OneShape(3, RES.Paint.Shape3, RES.Paint.Ashape3, ShapeX1, ShapeY1 + ShapeDY);
  OneShape(4, RES.Paint.Shape4, RES.Paint.Ashape4, ShapeX1 + ShapeDX, ShapeY1 + ShapeDY);

  DrawPalette;

  Sprite(RES.Empty, PaintX, PaintY);

  cx := MouseGet(CursorX) - (PaintX - PaintW / 2);
  cy := MouseGet(CursorY) - (PaintY - PaintH / 2);
  if not ProcessDrag then
    if InRange(cx, 0, PaintW - 1) and InRange(cy, 0, PaintH - 1) then
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
          dx := cx - prevx;
          dy := cy - prevy;
          dh := hypot(dx, dy);
          step := 0;
          while step < dh do
          begin
            prevx := prevx + dx / dh * 0.5;
            prevy := prevy + dy / dh * 0.5;
            step := step + 0.5;
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


procedure DrawRotator;
begin
  Rect(AppX - PaintW/2, AppY - PaintH/2, PaintW, PaintH, False, $000000FF, $000000FF, $000000FF, $000000FF, AppAngle);
  //Rect(AppX - PaintW/2 + LimitX1, AppY - PaintH/2 + LimitY1, LimitX2-LimitX1, LimitY2-LimitY1, False, $000000FF, $000000FF, $000000FF, $000000FF, AppAngle);
  LineSettings(1, $00440044, 100);
  DragX := AppX+250*cos(AppAngle/180*Pi);
  DragY := AppY-250*sin(AppAngle/180*Pi);
  Sprite(RES.Rotate, DragX, DragY, 1,1,AppAngle);
  Line(AppX, AppY, DragX, DragY, BLACK);
  //Line(AppX, AppY, (LimitX1+LimitX2)/2, (LimitY1+LimitY2)/2, BLACK);
end;


procedure DrawApplication;
var
  i: integer;
begin
  for i := 0 to AppAnimal.NParts do
    if i <> AppMissing then
      Sprite(AppAnimal.Layers[I], AppBaseX, AppBaseY);
  Sprite(RES.Empty, AppX, AppY, 1, 1, AppAngle);
  DrawRotator;

  if (AppCurChild <> nil) and ((DragMode <> DragChild) or (DragItem <> -1)) then
    Sprite(AppCurChild.Small, ChildX, ChildY);

  if not ProcessDrag then
    if MouseState(LeftButton) = mbsDown then
    begin
      if prevx < 0 then
      begin
        prevx := MouseGet(CursorX);
        prevy := MouseGet(CursorY);
        DragAngle := hypot(prevx-DragX, prevy-DragY) < 35;
      end
      else
      begin
        if DragAngle then
          AppAngle := -arctan2(MouseGet(CursorY) - AppY, MouseGet(CursorX) - AppX) / pi * 180
        else
        begin
          AppX := AppX + MouseGet(CursorX) - prevx;
          AppY := AppY + MouseGet(CursorY) - prevy;
        end;
        if SomeAction < 0 then
          SomeAction := GetTickCount64 + 4000;
        prevx := MouseGet(CursorX);
        prevy := MouseGet(CursorY);
      end;
    end
    else
      prevx := -1;
  if MouseGet(ScrollPos) <> 0 then
    AppAngle := AppAngle + MouseGet(ScrollPos) * 4;
end;

procedure DrawFlight;
var
  i, j: integer;
begin
  FontConfig(RES.Vera, 48, BLACK);
  DrawTextBoxed(RES.Vera, PChar('К вам везут ' + AppAnimal.Name +
    #13#10+AppAnimal.LayerNames[AppMissing]), MsgX-500, MsgY-500, 1000, 1000, haCenter, vaCenter);
  ProcessDrag;

{  for j := 1 to NCREATURES do
    for i := 0 to NPARTS do
      Sprite(ALL_CREATURES[j].Layers[I], 10+j*500, 400);}


 // if MouseState(LeftButton) <> mbsUp then Stars.AddStars(10, MouseGet(CursorX),MouseGet(CursorY));

end;

procedure UpdateImage;
begin
  Stars.AddStars(15, 1628, 859);
  AppAnimal.WasFixed[AppMissing] := True;
  DrawRotatedCrunch(RES.Empty, AppAnimal.Layers[AppMissing], AppX -
    AppBaseX - 10, AppY - AppBaseY - 10, 1, 1, AppAngle);
  DrawRotatedCrunch(RES.Empty2, Res.Empty, 0, 0);
end;

function ColorDelta(c1, c2: TColor): integer;
var
  red, blue, green: integer;
begin
  red := abs((c1 shr 24) - (c2 shr 24));
  green := abs(((c1 shr 16) and 255) - ((c2 shr 16) and 255));
  blue := abs(((c1 shr 8) and 255) - ((c2 shr 8) and 255));
  Result := red + green + blue;
end;

procedure BuildPalettes;
var
  cr: TCreature;
  crindex, index, lay, i, j: integer;
  found: boolean;
  c: TColor;
  bestcount, besti: integer;
  colors: array of TColor;
  colorscount: array of TColor;
begin
  for cr in ALL_CREATURES do
    for i := 1 to cr.PaletteSize do
      cr.Palette[i] := (cr.Palette[i] and (not 255)) or 255;
  exit;
  for crindex := 1 to NCREATURES do
  begin
    cr := ALL_CREATURES[crindex];

    SetLength(colors, 0);
    SetLength(colorscount, 0);
    for lay := 0 to cr.NParts do
      for i := 0 to PaintW - 1 do
        for j := 0 to PaintH - 1 do
        begin
          c := GetPixel(i, j, cr.Layers[lay]);
          if c and 255 < 250 then
            continue;
          found := False;
          for index := 0 to Length(colors)-1 do
            if ColorDelta(colors[index], c) < 75 then
            begin
              found := True;
              inc(colorscount[index]);
              break;
            end;
          if not found then
          begin
            SetLength(colors, Length(colors)+1);
            SetLength(colorscount, Length(colorscount)+1);
            colors[Length(colors)-1] := (c and (not 255)) or 255;
            colorscount[Length(colors)-1] := 1;
          end;
        end;
    cr.PaletteSize := 0;
    //omg selection sort
    for i := 1 to MAXPALETTE do
    begin
      bestcount := 1;
      besti := -1;
      for j := 0 to Length(colorscount)-1 do
        if colorscount[j] > bestcount then
        begin
          besti := j;
          bestcount := colorscount[j];
        end;
      if besti > 0 then
      begin
        inc(cr.PaletteSize);
        cr.Palette[cr.PaletteSize] := colors[besti];
        if cr.PaletteSize >= MAXPALETTE then break;;
        colorscount[besti] := 0;
      end;
    end;

  end;
end;

end.
