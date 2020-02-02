unit Resources;

interface
{$J-}
type
TRawResource = (TRawResource_NOT_USED);
TSprite = (THE_SCREEN = -1, res_Osel_1, res_Osel_2, res_Osel_3, res_Osel_body, res_Slon_1, res_Slon_2, res_Slon_3, res_Slon_4, res_Slon_5, res_Slon_body, res_Straus_1, res_Straus_2, res_Straus_3, res_Straus_body, res_Tukan_1, res_Tukan_2, res_Tukan_body, res_Zebra_1, res_Zebra_2, res_Zebra_3, res_Zebra_body, res_Cell, res_Fence, res_Fence2, res_Nest, res_Nest2, res_Elephant_small, res_Osel_small, res_Straus_egg, res_Tukan_small, res_Zebra_small, res_Aid, res_Fish, res_Grass, res_Maracas, res_Meat, res_Wash, res_Ashape1, res_Ashape2, res_Ashape3, res_Ashape4, res_Back, res_Board, res_Cry, res_Curtain, res_Empty, res_Empty2, res_Happy, res_Loading_back, res_Poker, res_Printer, res_Rotate, res_Star, res_Title, res_Title0, res_Wall);
TSound = (NO_MUSIC = -1, res_Aid_1, res_Grass_1, res_Meat_1, res_Music, res_Play, res_Star1, res_Star2, res_Starhit1, res_Starhit2, res_Stencil1, res_Stencil2, res_Stencil3, res_Wash_1);
TButton = (res_Go, res_Settings, res_Stop, res_World, res_Bar, res_Color, res_Shape1, res_Shape2, res_Shape3, res_Shape4);
TTileMap = (TTileMap_NOT_USED);
TFont = (res_Font1, res_Font2, res_Vera);


TAnimals = record
  Osel_1: TSprite;
  Osel_2: TSprite;
  Osel_3: TSprite;
  Osel_body: TSprite;
  Slon_1: TSprite;
  Slon_2: TSprite;
  Slon_3: TSprite;
  Slon_4: TSprite;
  Slon_5: TSprite;
  Slon_body: TSprite;
  Straus_1: TSprite;
  Straus_2: TSprite;
  Straus_3: TSprite;
  Straus_body: TSprite;
  Tukan_1: TSprite;
  Tukan_2: TSprite;
  Tukan_body: TSprite;
  Zebra_1: TSprite;
  Zebra_2: TSprite;
  Zebra_3: TSprite;
  Zebra_body: TSprite;
end;

TCells = record
  Cell: TSprite;
  Fence: TSprite;
  Fence2: TSprite;
  Nest: TSprite;
  Nest2: TSprite;
end;

TChildren = record
  Elephant_small: TSprite;
  Osel_small: TSprite;
  Straus_egg: TSprite;
  Tukan_small: TSprite;
  Zebra_small: TSprite;
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

TSounds = record
  Aid: TSound;
  Grass: TSound;
  Meat: TSound;
  Music: TSound;
  Play: TSound;
  Star1: TSound;
  Star2: TSound;
  Starhit1: TSound;
  Starhit2: TSound;
  Stencil1: TSound;
  Stencil2: TSound;
  Stencil3: TSound;
  Wash: TSound;
end;

TRES = record
  Animals: TAnimals;
  Cells: TCells;
  Children: TChildren;
  Food: TFood;
  Hud: THud;
  Paint: TPaint;
  Sounds: TSounds;
  Back: TSprite;
  Board: TSprite;
  Cry: TSprite;
  Curtain: TSprite;
  Empty: TSprite;
  Empty2: TSprite;
  Font1: TFont;
  Font2: TFont;
  Happy: TSprite;
  Loading_back: TSprite;
  Poker: TSprite;
  Printer: TSprite;
  Rotate: TSprite;
  Star: TSprite;
  Title: TSprite;
  Title0: TSprite;
  Vera: TFont;
  Wall: TSprite;
end;

const RES: TRES = (
  Animals: (
    Osel_1: res_Osel_1;
    Osel_2: res_Osel_2;
    Osel_3: res_Osel_3;
    Osel_body: res_Osel_body;
    Slon_1: res_Slon_1;
    Slon_2: res_Slon_2;
    Slon_3: res_Slon_3;
    Slon_4: res_Slon_4;
    Slon_5: res_Slon_5;
    Slon_body: res_Slon_body;
    Straus_1: res_Straus_1;
    Straus_2: res_Straus_2;
    Straus_3: res_Straus_3;
    Straus_body: res_Straus_body;
    Tukan_1: res_Tukan_1;
    Tukan_2: res_Tukan_2;
    Tukan_body: res_Tukan_body;
    Zebra_1: res_Zebra_1;
    Zebra_2: res_Zebra_2;
    Zebra_3: res_Zebra_3;
    Zebra_body: res_Zebra_body;
  );
  Cells: (
    Cell: res_Cell;
    Fence: res_Fence;
    Fence2: res_Fence2;
    Nest: res_Nest;
    Nest2: res_Nest2;
  );
  Children: (
    Elephant_small: res_Elephant_small;
    Osel_small: res_Osel_small;
    Straus_egg: res_Straus_egg;
    Tukan_small: res_Tukan_small;
    Zebra_small: res_Zebra_small;
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
  Sounds: (
    Aid: res_Aid_1;
    Grass: res_Grass_1;
    Meat: res_Meat_1;
    Music: res_Music;
    Play: res_Play;
    Star1: res_Star1;
    Star2: res_Star2;
    Starhit1: res_Starhit1;
    Starhit2: res_Starhit2;
    Stencil1: res_Stencil1;
    Stencil2: res_Stencil2;
    Stencil3: res_Stencil3;
    Wash: res_Wash_1;
  );
  Back: res_Back;
  Board: res_Board;
  Cry: res_Cry;
  Curtain: res_Curtain;
  Empty: res_Empty;
  Empty2: res_Empty2;
  Font1: res_Font1;
  Font2: res_Font2;
  Happy: res_Happy;
  Loading_back: res_Loading_back;
  Poker: res_Poker;
  Printer: res_Printer;
  Rotate: res_Rotate;
  Star: res_Star;
  Title: res_Title;
  Title0: res_Title0;
  Vera: res_Vera;
  Wall: res_Wall;
);

implementation
end.
