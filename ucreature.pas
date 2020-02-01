unit uCreature;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, uEngine, Resources;

const
    NCREATURES = 1;
    NPARTS = 3;
    MAXPALETTE = 7;

type

  TChild = (Herbivore,Bird,Carnivore);


  TCreature = record
    Name: string;
    Layers: array[0..NPARTS] of TSprite;
    LayerNames: array[1..NPARTS] of string;
    Child: TChild;
    Small: TSprite;
    PaletteSize: Integer;
    Palette: array[1..MAXPALETTE] of TColor;
    WasFixed: array[1..NPARTS] of Boolean;
  end;
  PCreature = ^TCreature;


const
    ALL_CREATURES: array[1..NCREATURES] of TCreature = (
      (Name: 'Тукана';
        Layers: (res_Tukan_body, res_Tukan_1, res_Tukan_2, res_Tukan_3);
        LayerNames: ('нужна замена клюва', 'нужен новый хвост', 'требуется замена глаза');
        Child: Bird;
        Small: res_Tukan_small
        )
    );


implementation

end.

