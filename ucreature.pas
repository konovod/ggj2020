unit uCreature;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, uEngine, Resources;

const
  NCREATURES = 2;
  MAXPARTS = 3;
  MAXPALETTE = 7;

type

  TChild = (Herbivore, Bird, Carnivore);


  TCreature = class
    Name: string;
    SmallName: string;
    Gender: string;
    NParts: Integer;
    Layers: array[0..MAXPARTS] of TSprite;
    LayerNames: array[1..MAXPARTS] of string;
    Child: TChild;
    Small: TSprite;
    PaletteSize: integer;
    Palette: array[1..MAXPALETTE] of TColor;
    WasFixed: array[1..MAXPARTS] of boolean;
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
    NParts := 2;
    Layers[0] := res_Tukan_body;
    Layers[1] := res_Tukan_1; LayerNames[1] := 'Ему срочно нужна замена клюва';
    Layers[2] := res_Tukan_2; LayerNames[2] := 'Требуется протезирование поврежденных лапок';
    Child := Bird;
    Small := res_Tukan_small;
    SmallName := 'выпавший из гнезда туканчик';
    Gender := 'ним';
    PaletteSize := 7;
    Palette[1] := $000000FF;
    Palette[2] := $1B1B48FF;
    Palette[3] := $FFFFFFFF;
    Palette[4] := $D24A43FF;
    Palette[5] := $FFFF00FF;
    Palette[6] := $3EB5F1FF;
    Palette[7] := $00FF00FF;
  end;

  ALL_CREATURES[2] := TCreature.Create;
  with ALL_CREATURES[2] do
  begin
    Name := 'Зебру';
    NParts := 3;
    Layers[0] := res_Zebra_body;
    Layers[1] := res_Zebra_1; LayerNames[1] := 'Ей нужна искусственная нога';
    Layers[2] := res_Zebra_2; LayerNames[2] := 'Ей необходимо протезирование ушей';
    Layers[3] := res_Zebra_3; LayerNames[3] := 'Ей требуется новый хвост';
    Child := Herbivore;
    Small := res_Zebra_small;
    SmallName := 'отставший от мамы зебренок';
    Gender := 'ней';
    PaletteSize := 4;
    Palette[1] := $000000FF;
    Palette[2] := $FFFFFFFF;
    Palette[3] := $B6A48BFF;
    Palette[4] := $5E191DFF;
  end;

end;

end.
