unit uCreature;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, uEngine, Resources;

const
  NCREATURES = 2;
  NPARTS = 3;
  MAXPALETTE = 7;

type

  TChild = (Herbivore, Bird, Carnivore);


  TCreature = class
    Name: string;
    Layers: array[0..NPARTS] of TSprite;
    LayerNames: array[1..NPARTS] of string;
    Child: TChild;
    Small: TSprite;
    PaletteSize: integer;
    Palette: array[1..MAXPALETTE] of TColor;
    WasFixed: array[1..NPARTS] of boolean;
  end;


var
  ALL_CREATURES: array[1..NCREATURES] of TCreature;

procedure InitCreatures;
implementation

procedure InitCreatures;
begin
  ALL_CREATURES[1] := TCreature.Create;
  with ALL_CREATURES[1] do
  begin
    Name := 'Тукана';
    Layers[0] := res_Tukan_body;
    Layers[1] := res_Tukan_1; LayerNames[1] := 'нужна замена клюва';
    Layers[2] := res_Tukan_2; LayerNames[2] := 'нужен новый хвост';
    Layers[3] := res_Tukan_3; LayerNames[3] := 'требуется замена глаза';
    Child := Bird;
    Small := res_Tukan_small;
  end;

  ALL_CREATURES[2] := TCreature.Create;
  with ALL_CREATURES[2] do
  begin
    Name := 'Слона';
    Layers[0] := res_Elephant_body;
    Layers[1] := res_Elephant_1; LayerNames[1] := 'нужен искусственный хобот';
    Layers[2] := res_Elephant_2; LayerNames[2] := 'нужен новый хвост';
    Layers[3] := res_Elephant_3; LayerNames[3] := 'требуется протез ноги';
    Child := Herbivore;
    Small := res_Elephant_small;
  end;

end;

end.
