unit uEngine;

interface

uses Resources;
// Resources.pas генерится автоматически по содержимому каталога ресурсов и содержит объявления енумов TRawResource, TSprite, TSound, TButton, TTileMap, TFont

const
  BLACK = $000000FF;
  MAROON = $800000FF;
  GREEN = $008000FF;
  OLIVE = $808000FF;
  NAVY = $000080FF;
  PURPLE = $800080FF;
  TEAL = $008080FF;
  GRAY = $808080FF;
  SILVER = $C0C0C0FF;
  RED = $FF0000FF;
  LIME = $00FF00FF;
  YELLOW = $FFFF00FF;
  BLUE = $0000FFFF;
  FUCHSIA = $FF00FFFF;
  AQUA = $00FFFFFF;
  WHITE = $FFFFFFFF;
  MONEYGREEN = $C0DCC0FF;
  SKYBLUE = $A6CAF0FF;
  CREAM = $FFFBF0FF;
  MEDGRAY = $A0A0A4FF;

type
  TKey = (
    KeyA, KeyB, KeyC, KeyD, KeyE, KeyF, KeyG, KeyH,
    KeyI, KeyJ, KeyK, KeyL, KeyM, KeyN, KeyO, KeyP,
    KeyQ, KeyR, KeyS, KeyT, KeyU, KeyV, KeyW, KeyX,
    KeyY, KeyZ,
    KeyNum0, KeyNum1, KeyNum2, KeyNum3,
    KeyNum4, KeyNum5, KeyNum6, KeyNum7,
    KeyNum8, KeyNum9,
    KeyEscape,
    KeyLControl, KeyLShift, KeyLAlt, KeyLSystem,
    KeyRControl, KeyRShift, KeyRAlt, KeyRSystem,
    KeyMenu,         ///< The Menu key
    KeyLBracket,     ///< The [ key
    KeyRBracket,     ///< The ] key
    KeySemiColon,    ///< The ; key
    KeyComma,        ///< The , key
    KeyPeriod,       ///< The . key
    KeyQuote,        ///< The ' key
    KeySlash,        ///< The / key
    KeyBackSlash,    ///< The \ key
    KeyTilde,        ///< The ~ key
    KeyEqual,        ///< The = key
    KeyDash,         ///< The - key
    KeySpace,        ///< The Space key
    KeyReturn,       ///< The Return key
    KeyBack,         ///< The Backspace key
    KeyTab,          ///< The Tabulation key
    KeyPageUp,       ///< The Page up key
    KeyPageDown,     ///< The Page down key
    KeyEnd,          ///< The End key
    KeyHome,         ///< The Home key
    KeyInsert,       ///< The Insert key
    KeyDelete,       ///< The Delete key
    KeyAdd,          ///< +
    KeySubtract,     ///< -
    KeyMultiply,     ///< *
    KeyDivide,       ///< /
    KeyLeft,         ///< Left arrow
    KeyRight,        ///< Right arrow
    KeyUp,           ///< Up arrow
    KeyDown,         ///< Down arrow
    KeyNumpad0, KeyNumpad1, KeyNumpad2, KeyNumpad3,
    KeyNumpad4, KeyNumpad5, KeyNumpad6, KeyNumpad7,
    KeyNumpad8, KeyNumpad9,
    KeyF1, KeyF2, KeyF3, KeyF4, KeyF5, KeyF6, KeyF7, KeyF8,
    KeyF9, KeyF10, KeyF11, KeyF12, KeyF13, KeyF14, KeyF15,
    KeyPause,        ///< The Pause key
    Quit,
    AnyKey
    );


  //can be redefined in project to enums
  TPanel = Integer;
  TMaterial = Integer;
  TPolygon = Integer;

  TCoord = single;
  TColor = cardinal;
  TMouseButton = (LeftButton, RightButton, MiddleButton);
  TMouseAxis = (CursorX, CursorY, ScrollPos);
  TKeyState = (ksUp, ksDown, ksPressed);
  TMouseButtonState = (mbsUp, mbsDown, mbsClicked);

  TVAlign = (vaNone, vaTop, vaCenter, vaBottom, vaFlow);
  THAlign = (haNone, haLeft, haCenter, haRight, haFlow);

  TEngineValue = (
    Fullscreen, Width, Height, VSync, Antialias, UseLog, Autoscale, Volume, ClearColor,
    RealWidth, RealHeight, FPS, DeltaTime);
  TEngineConfig = Fullscreen..ClearColor;

  TFontStyle = (Bold, Italic, Underlined);
  TFontStyles = set of TFontStyle;

  TButtonState = (bsNormal, bsHover, bsPressed, bsClicked);

  TGUICoord = (gcX, gcY, gcWidth, gcHeight, gcMouseX, gcMouseY);

  TPathfindCallback = function(fromx, fromy, tox, toy: integer; opaque: pointer): single;
  TPathfindAlgorithm = (AStarNew, AStarReuse, DijkstraNew, DijkstraReuse);
  
const
  nonoengine = 'nonoengine.dll';

//Общие функции движка
procedure EngineInit(ResDir: PChar); cdecl; external nonoengine;
procedure EngineSet(param: TEngineConfig; Value: integer); cdecl; external nonoengine;
function EngineGet(param: TEngineValue): integer; cdecl; external nonoengine;
procedure EngineProcess; cdecl; external nonoengine;
function RawResource(res: TRawResource; out size: integer): pointer; cdecl;
  external nonoengine;
function RawTexture(res: TSprite): cardinal; cdecl; external nonoengine;
procedure EngineLog(s: PChar); cdecl; external nonoengine;
procedure Log(s: string);
procedure Logf(s: string; const Args: array of const);

//Обработка ввода
function KeyState(key: TKey): TKeyState; cdecl; external nonoengine;
function MouseGet(axis: TMouseAxis): TCoord; cdecl; external nonoengine;
function MouseState(btn: TMouseButton): TMouseButtonState; cdecl; external nonoengine;

//2д-рендер - спрайты
procedure Sprite(sprite: TSprite; x, y: TCoord; kx: single = 1;
  ky: single = 1; angle: single = 0; Color: TColor = WHITE); cdecl; external nonoengine;
procedure DrawTiled(tiled: TTileMap; frame: integer; x, y: TCoord;
  kx: single = 1; ky: single = 1; angle: single = 0; Color: TColor = WHITE);
  cdecl; external nonoengine;
procedure Background(sprite: TSprite; kx: single = 1; ky: single = 1;
  dx: single = 0; dy: single = 0; Color: TColor = WHITE);
  cdecl; external nonoengine;

//2д-рендер - примитивы
procedure Line(x1, y1, x2, y2: TCoord; color1, color2: TColor); overload;
  cdecl; external nonoengine;
procedure Line(x1, y1, x2, y2: TCoord; color: TColor); overload;
procedure LineSettings(Width: single; Stipple: cardinal = $FFFFFFFF;
  StippleScale: single = 1); cdecl; external nonoengine;
procedure Ellipse(x, y, rx, ry: TCoord; filled: boolean; color1, color2: TColor;
  angle: single = 0);
  cdecl; external nonoengine; overload;
procedure Ellipse(x, y, rx, ry: TCoord; filled: boolean; color: TColor); overload;
procedure Rect(x0, y0, w, h: TCoord; filled: boolean;
  Color1, Color2, Color3, Color4: TColor; Angle: single = 0);
  cdecl; external nonoengine; overload;
procedure Rect(x0, y0, w, h: TCoord; filled: boolean; Color: TColor); overload;
procedure Point(x, y: TCoord; color: TColor); cdecl; external nonoengine;
procedure Triangle(x1, y1: TCoord; color1: TColor; x2, y2: TCoord;
  color2: TColor; x3, y3: TCoord; color3: TColor);
  cdecl; external nonoengine; overload;
procedure Triangle(x1, y1: TCoord; x2, y2: TCoord; x3, y3: TCoord;
  color: TColor); overload;
procedure TexturedTriangle(sprite: TSprite;
  x1, y1, tx1, ty1, x2, y2, tx2, ty2, x3, y3, tx3, ty3: TCoord);
  cdecl; external nonoengine; overload;
procedure TexturedTriangle(sprite: TSprite; x1, y1, x2, y2, x3, y3: TCoord;
  dx: TCoord = 0; dy: TCoord = 0; kx: TCoord = 1; ky: TCoord = 1); overload;

//2д-рендер - дополнительные функции
function GetPixel(x, y: TCoord; sprite: TSprite = THE_SCREEN): TColor;
  cdecl; external nonoengine;
procedure SetLayer(z: integer); cdecl; external nonoengine;
procedure Camera(dx, dy: TCoord; kx: single = 1; ky: single = 1; angle: single = 0);
  cdecl; external nonoengine;
procedure RenderTo(sprite: TSprite); cdecl; external nonoengine;
procedure SetPixel(sprite: TSprite; x, y: TCoord; Color: TColor); cdecl;external nonoengine;

//2д-рендер - вывод текста
procedure FontConfig(font: TFont; CharSize: integer = 24; color: TColor = WHITE;
  Styles: TFontStyles = []; kx: single = 1; ky: single = 1); cdecl; external nonoengine;
procedure DrawText(font: TFont; Text: PChar; x, y: TCoord); cdecl; external nonoengine;
procedure DrawTextBoxed(font: TFont; Text: PChar; x, y, w, h: TCoord;
  HAlign: THAlign = haLeft; VAlign: TVAlign = vaCenter);
  cdecl; external nonoengine;

//ГУИ
procedure Panel(id: TPanel; Parent: TPanel; x, y, w, h: TCoord;
  HAlign: THAlign = haNone; VAlign: TVAlign = vaNone);
  cdecl; external nonoengine;
function Button(btn: TButton; Parent: TPanel; x, y, w, h: TCoord;
  HAlign: THAlign = haNone; VAlign: TVAlign = vaNone; Text: PChar = nil;
  Font: TFont = TFont(0); Data: pointer = nil): TButtonState;
  cdecl; external nonoengine;
function GetGUICoord(Coord: TGUICoord): TCoord; cdecl; external nonoengine;

//Звук
procedure Play(sound: TSound; volume: single = 100; Data: Pointer = nil);
  cdecl; external nonoengine;
procedure Music(music: TSound; volume: single = 100); cdecl; external nonoengine;
function SoundPlaying(sound: TSound; Data: Pointer = nil): boolean;
  cdecl; external nonoengine;

//Поиск пути
function Pathfind(SizeX, SizeY: integer; algorithm: TPathfindAlgorithm;
  diagonal_cost: single; fromx, fromy, tox, toy: integer; out x: integer;
  out y: integer; callback: TPathfindCallback; opaque: pointer = nil): boolean;
  cdecl; external nonoengine;

//физика
procedure Material(Material: TMaterial; Density, Friction, Elasticity: Double; IsStatic: boolean; IsPersistent: boolean; DefRadius: Double); cdecl; external nonoengine;
procedure MaterialCollisions(first, second: TMaterial; ShouldHit: boolean; NeedProcessing: Boolean); cdecl; external nonoengine;

procedure PolygonReset(p: TPolygon); cdecl; external nonoengine;
procedure PolygonAdd(p: TPolygon; x, y: TCoord); cdecl; external nonoengine;
procedure PolygonClose(p: TPolygon); cdecl; external nonoengine;
procedure PolygonDraw(p: TPolygon; c: TColor; sprite: TSprite; dx: TCoord = 0; dy: TCoord = 0; kx: TCoord = 1; ky: TCoord = 1); cdecl; external nonoengine;

procedure ShapeCircle(Material: TMaterial; id: pointer; var x, y, vx, vy, a: TCoord); cdecl; external nonoengine;
procedure ShapeBox(Material: TMaterial; id: pointer; x1, y1, x2, y2: TCoord); cdecl; external nonoengine;
procedure ShapePoly(Material: TMaterial; id: pointer; poly: TPolygon; var x, y, vx, vy, a: TCoord); cdecl; external nonoengine;
procedure BodyDelete(Material: TMaterial; id: pointer); cdecl; external nonoengine;
function BodyCollided(MyMaterial: TMaterial; MyID: pointer; WithMaterial: TMaterial; out WithID: pointer): boolean; cdecl; external nonoengine;
procedure SetCurrentCollision(React: Boolean); cdecl; external nonoengine;
procedure ShapeApplyForce(Material: TMaterial; id: pointer; fx, fy, dx, dy, moment: TCoord); cdecl; external nonoengine;


procedure DrawRotatedCrunch(afrom, ato: TSprite; x, y: TCoord; kx: single = 1;
  ky: single = 1; angle: single = 0; Color: TColor = WHITE; Clear: Boolean = True);cdecl;external nonoengine;

implementation

uses SysUtils;
//Функции с уменьшенным числом параметров, для часто используемых частных случаев

procedure Line(x1, y1, x2, y2: TCoord; color: TColor);
begin
  Line(x1, y1, x2, y2, color, color);
end;

procedure Ellipse(x, y, rx, ry: TCoord; filled: boolean; color: TColor);
begin
  Ellipse(x, y, rx, ry, filled, color, color);
end;

procedure Rect(x0, y0, w, h: TCoord; filled: boolean; Color: TColor);
begin
  Rect(x0, y0, w, h, filled, Color, Color, Color, Color);
end;

procedure Triangle(x1, y1: TCoord; x2, y2: TCoord; x3, y3: TCoord; color: TColor);
begin
  Triangle(x1, y1, color, x2, y2, color, x3, y3, color);
end;

procedure TexturedTriangle(sprite: TSprite; x1, y1, x2, y2, x3, y3, dx: TCoord;
  dy: TCoord; kx: TCoord; ky: TCoord);
begin
  TexturedTriangle(sprite,
    x1, y1, dx, dy,
    x2, y2, dx + (x2 - x1) * kx, dy + (y2 - y1) * ky,
    x3, y3, dx + (x3 - x1) * kx, dy + (y3 - y1) * ky
    );
end;

procedure Log(s: string);
begin
  EngineLog(PChar(s));
end;

procedure Logf(s: string; const Args: array of const);
begin
  Log(Format(s, args));
end;

end.
