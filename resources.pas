unit Resources;

interface
{$J-}
type
TRawResource = (TRawResource_NOT_USED);
TSprite = (THE_SCREEN = -1, res_Tukan_1, res_Tukan_2, res_Tukan_3, res_Tukan_body, res_Cell, res_Fence, res_Fence2, res_Nest, res_Aid, res_Fish, res_Grass, res_Maracas, res_Meat, res_Wash, res_Ashape1, res_Ashape2, res_Ashape3, res_Ashape4, res_Back, res_Empty, res_Empty2, res_Printer, res_Rotate);
TSound = (NO_MUSIC = -1, TSound_NOT_USED);
TButton = (res_Go, res_Settings, res_Stop, res_World, res_Bar, res_Color, res_Shape1, res_Shape2, res_Shape3, res_Shape4);
TTileMap = (TTileMap_NOT_USED);
TFont = (res_Vera);


TAnimals = record
  Tukan_1: TSprite;
  Tukan_2: TSprite;
  Tukan_3: TSprite;
  Tukan_body: TSprite;
end;

TCells = record
  Cell: TSprite;
  Fence: TSprite;
  Fence2: TSprite;
  Nest: TSprite;
end;

TFood = record
  Aid: TSprite;
  Fish: TSprite;
  Grass: TSprite;
  Maracas: TSprite;
  Meat: TSprite;
  Wash: TSprite;
end;

THud = record
  Go: TButton;
  Settings: TButton;
  Stop: TButton;
  World: TButton;
end;

TPaint = record
  Ashape1: TSprite;
  Ashape2: TSprite;
  Ashape3: TSprite;
  Ashape4: TSprite;
  Bar: TButton;
  Color: TButton;
  Shape1: TButton;
  Shape2: TButton;
  Shape3: TButton;
  Shape4: TButton;
end;

TRES = record
  Animals: TAnimals;
  Cells: TCells;
  Food: TFood;
  Hud: THud;
  Paint: TPaint;
  Back: TSprite;
  Empty: TSprite;
  Empty2: TSprite;
  Printer: TSprite;
  Rotate: TSprite;
  Vera: TFont;
end;

const RES: TRES = (
  Animals: (
    Tukan_1: res_Tukan_1;
    Tukan_2: res_Tukan_2;
    Tukan_3: res_Tukan_3;
    Tukan_body: res_Tukan_body;
  );
  Cells: (
    Cell: res_Cell;
    Fence: res_Fence;
    Fence2: res_Fence2;
    Nest: res_Nest;
  );
  Food: (
    Aid: res_Aid;
    Fish: res_Fish;
    Grass: res_Grass;
    Maracas: res_Maracas;
    Meat: res_Meat;
    Wash: res_Wash;
  );
  Hud: (
    Go: res_Go;
    Settings: res_Settings;
    Stop: res_Stop;
    World: res_World;
  );
  Paint: (
    Ashape1: res_Ashape1;
    Ashape2: res_Ashape2;
    Ashape3: res_Ashape3;
    Ashape4: res_Ashape4;
    Bar: res_Bar;
    Color: res_Color;
    Shape1: res_Shape1;
    Shape2: res_Shape2;
    Shape3: res_Shape3;
    Shape4: res_Shape4;
  );
  Back: res_Back;
  Empty: res_Empty;
  Empty2: res_Empty2;
  Printer: res_Printer;
  Rotate: res_Rotate;
  Vera: res_Vera;
);

implementation
end.
