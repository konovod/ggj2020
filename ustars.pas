unit uStars;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Resources, uEngine, Math;

const
  ScoresX = 100;
  ScoresY = 40;

  StarsInitial = 30;
  StarsGravity = 2;
  StarsDamping = 0.95;
  //StarsCatch = 50;


type

  TStarF = record
    X,Y,VX, VY: TCoord;
  end;

  { TStarsEngine }

  TStarsEngine = class
    Flying: array of TStarF;
    Counter: Integer;
    procedure Draw;
    procedure Process;
    procedure AddStars(count: Integer;X,Y: TCoord);
  end;


var
  Stars: TStarsEngine;

function MakeStar(ax,ay,avx,avy: TCoord): TStarF;
implementation

function MakeStar(ax, ay, avx, avy: TCoord): TStarF;
begin
  Result.X := ax;
  Result.Y := ay;
  Result.VX := avx;
  Result.VY := avy;
end;


{ TStarsEngine }

procedure TStarsEngine.Draw;
var
  i: Integer;
begin
  Sprite(RES.Star, ScoresX, ScoresY);
  DrawText(RES.Vera, PChar(IntToStr(Counter)), ScoresX+30, ScoresY-30);
  for i := 0 to Length(Flying)-1 do
    Sprite(RES.Star, Flying[i].X, Flying[i].Y, 0.5, 0.5);

end;

procedure TStarsEngine.Process;
var
  i, totaln: Integer;
  d, dx, dy: TCoord;
begin
  totaln := Length(Flying);
  for i := Length(Flying)-1 downto 0 do
  begin
    Flying[i].X := Flying[i].X + Flying[i].VX;
    Flying[i].Y := Flying[i].Y + Flying[i].VY;
    dx := Flying[i].X-ScoresX;
    dy := Flying[i].Y-ScoresY;
    d := hypot(dx, dy);
    Flying[i].VX := Flying[i].VX*StarsDamping - dx/d*StarsGravity;
    Flying[i].VY := Flying[i].VY*StarsDamping - dy/d*StarsGravity;

    if (d < 100) and ((sign(Flying[i].VX) = sign(dx)) or (sign(Flying[i].VY) = sign(dy))) then
    begin
      Play(RES.Sounds.Star2);
      Flying[i] := Flying[totaln-1];
      dec(totaln);
      Inc(Counter);
    end;
  end;
  if totaln <> Length(Flying) then
    SetLength(Flying, totaln);
end;

procedure TStarsEngine.AddStars(count: Integer; X, Y: TCoord);
var
  i: Integer;
begin
  SetLength(Flying, Length(Flying)+count);
  for i := 1 to count do
  begin
    Flying[Length(Flying) - i] := MakeStar(x+random(50), y+random(50), random(StarsInitial), random(StarsInitial));
  end;
  for i := 1 to count div 5 do
  begin
    Play(RES.Sounds.Star1);
    sleep(15);
  end;
end;

end.

