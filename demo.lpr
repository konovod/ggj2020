program demo;

uses
  SysUtils,
  uEngine,
  Resources,
  uPaint,
  uCreature,
  uChildren,
  uDrag, uStars;

begin
  //EngineSet(Antialias, 4);
  Randomize;
  EngineSet(Volume, 100);
  EngineSet(VSync, 1);
  EngineSet(Fullscreen, 1);
  EngineSet(Autoscale, 1);
  EngineSet(Width, 1920);
  EngineSet(Height, 1080);
  EngineInit('./resources');
  InitCreatures;
  Stars := TStarsEngine.Create;
  InitCells;
  GoFlight;
  repeat
    Background(RES.Loading_back);
    EngineProcess;
  until (KeyState(AnyKey) = ksDown) or (MouseState(LeftButton) = mbsClicked)or (MouseState(RightButton) = mbsClicked);
  repeat
    DrawScene;
    EngineProcess;
  until (KeyState(Quit) <> ksUp) or (KeyState(KeyEscape) <> ksUp);
end.
