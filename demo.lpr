program demo;

uses
  SysUtils,
  uEngine,
  Resources, uPaint;

begin
  //EngineSet(Antialias, 4);
  EngineSet(VSync, 1);
  EngineSet(Width, 1000);
  EngineSet(Height, 667);
  EngineInit('./resources');
  repeat
    DrawScene;
    EngineProcess;
  until (KeyState(Quit) <> ksUp) or (KeyState(KeyEscape) <> ksUp);
end.
