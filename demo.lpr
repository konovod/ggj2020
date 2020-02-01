program demo;

uses
  SysUtils,
  uEngine,
  Resources, uPaint, uCreature;

begin
  //EngineSet(Antialias, 4);
  EngineSet(VSync, 1);
  EngineSet(Fullscreen, 0);
  EngineSet(Autoscale, 1);
  EngineSet(Width, 1920);
  EngineSet(Height, 1080);
  EngineInit('./resources');
  BuildPalettes;
  GoFlight;
  repeat
    DrawScene;
    EngineProcess;
  until (KeyState(Quit) <> ksUp) or (KeyState(KeyEscape) <> ksUp);
end.
