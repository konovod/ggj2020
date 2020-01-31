unit Resources;

interface
{$J-}
type
TRawResource = (TRawResource_NOT_USED);
TSprite = (THE_SCREEN = -1, res_Back, res_Elephant1, res_Elephant2, res_Empty);
TSound = (NO_MUSIC = -1, TSound_NOT_USED);
TButton = (TButton_NOT_USED);
TTileMap = (TTileMap_NOT_USED);
TFont = (res_Vera);


TRES = record
  Back: TSprite;
  Elephant1: TSprite;
  Elephant2: TSprite;
  Empty: TSprite;
  Vera: TFont;
end;

const RES: TRES = (
  Back: res_Back;
  Elephant1: res_Elephant1;
  Elephant2: res_Elephant2;
  Empty: res_Empty;
  Vera: res_Vera;
);

implementation
end.
