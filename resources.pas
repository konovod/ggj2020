unit Resources;

interface
{$J-}
type
TRawResource = (TRawResource_NOT_USED);
TSprite = (THE_SCREEN = -1, res_Tukan_1, res_Tukan_2, res_Tukan_3, res_Tukan_body, res_Ashape1, res_Ashape2, res_Ashape3, res_Ashape4, res_Back, res_Empty, res_Empty2);
TSound = (NO_MUSIC = -1, TSound_NOT_USED);
TButton = (res_Bar, res_Shape1, res_Shape2, res_Shape3, res_Shape4);
TTileMap = (TTileMap_NOT_USED);
TFont = (res_Vera);


TAnimals = record
  Tukan_1: TSprite;
  Tukan_2: TSprite;
  Tukan_3: TSprite;
  Tukan_body: TSprite;
end;

TPaint = record
  Ashape1: TSprite;
  Ashape2: TSprite;
  Ashape3: TSprite;
  Ashape4: TSprite;
  Bar: TButton;
  Shape1: TButton;
  Shape2: TButton;
  Shape3: TButton;
  Shape4: TButton;
end;

TRES = record
  Animals: TAnimals;
  Paint: TPaint;
  Back: TSprite;
  Empty: TSprite;
  Empty2: TSprite;
  Vera: TFont;
end;

const RES: TRES = (
  Animals: (
    Tukan_1: res_Tukan_1;
    Tukan_2: res_Tukan_2;
    Tukan_3: res_Tukan_3;
    Tukan_body: res_Tukan_body;
  );
  Paint: (
    Ashape1: res_Ashape1;
    Ashape2: res_Ashape2;
    Ashape3: res_Ashape3;
    Ashape4: res_Ashape4;
    Bar: res_Bar;
    Shape1: res_Shape1;
    Shape2: res_Shape2;
    Shape3: res_Shape3;
    Shape4: res_Shape4;
  );
  Back: res_Back;
  Empty: res_Empty;
  Empty2: res_Empty2;
  Vera: res_Vera;
);

implementation
end.
