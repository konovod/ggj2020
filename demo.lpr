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
  EngineSet(VSync, 1);
  EngineSet(Fullscreen, 1);
  EngineSet(Autoscale, 1);
  EngineSet(Width, 1920);
  EngineSet(Height, 1080);
  EngineInit('./resources');
  InitCreatures;
  Stars := TStarsEngine.Create;
  BuildPalettes;
  InitCells;
  GoFlight;
  repeat
    DrawScene;
    EngineProcess;
  until (KeyState(Quit) <> ksUp) or (KeyState(KeyEscape) <> ksUp);
end.
