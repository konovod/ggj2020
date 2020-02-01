unit Resources;

interface
{$J-}
type
TRawResource = (TRawResource_NOT_USED);
TSprite = (THE_SCREEN = -1, res_Tukan_1, res_Tukan_2, res_Tukan_3, res_Tukan_body, res_Back, res_Elephant1, res_Elephant2, res_Empty, res_Empty2, res_Flight, res_Id_);
TSound = (NO_MUSIC = -1, TSound_NOT_USED);
TButton = (TButton_NOT_USED);
TTileMap = (TTileMap_NOT_USED);
TFont = (res_Vera);


TAnimals = record
  Tukan_1: TSprite;
  Tukan_2: TSprite;
  Tukan_3: TSprite;
  Tukan_body: TSprite;
end;

TRES = record
  Animals: TAnimals;
  Back: TSprite;
  Elephant1: TSprite;
  Elephant2: TSprite;
  Empty: TSprite;
  Empty2: TSprite;
  Flight: TSprite;
  Vera: TFont;
  Id_: TSprite;
end;

const RES: TRES = (
  Animals: (
    Tukan_1: res_Tukan_1;
    Tukan_2: res_Tukan_2;
    Tukan_3: res_Tukan_3;
    Tukan_body: res_Tukan_body;
  );
  Back: res_Back;
  Elephant1: res_Elephant1;
  Elephant2: res_Elephant2;
  Empty: res_Empty;
  Empty2: res_Empty2;
  Flight: res_Flight;
  Vera: res_Vera;
  Id_: res_Id_;
);

implementation
end.
