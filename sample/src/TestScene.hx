package;

import objects.player.enums.HaleyState;
import objects.player.Input;
import objects.player.enums.PlayerInput;
import ceramic.TextAlign;
import objects.player.Haley;
import elements.Im;

// import elements.Im;
class TestScene extends ceramic.Scene {
  private var haley: Haley;
  private var _isDebugWindowActive = false;

  public function new() {
    super();
    Input.init();
  }

  public override function preload() {
    trace('Test Scene Initialized!');
    assets.addTilemap('data/MapTest.tmx');
  }

  public override function create() {
    createHaley();
    /*
      for (i in 0...10) {
        var child = new EntityTest("Entity_" + i);
        add(child);
      }
      for (child in children) {
        if (child is EntityBase) {
          debugList.push(cast(child));
        }
      }
     */
  }

  private function createHaley() {
    haley = new Haley();
    haley.pos(screen.width * 0.5, screen.height * 0.5);
    add(haley);
  }

  public override function resize(width: Float, height: Float) {}

  public override function update(dt: Float) {
    haley.update(dt);

    if (Input.isJustPressed(DEBUG)) {
      if (_isDebugWindowActive) {
        _isDebugWindowActive = false;
      }
      else {
        _isDebugWindowActive = true;
      }
    }
    if (_isDebugWindowActive) {
      buildUI();
    }
  }

  public function buildUI() {
    Im.begin('haley debug window', 300);
    Im.text("MetaData", TextAlign.CENTER);
    Im.separator();
    Im.text("Entity name: " + haley.name);
    Im.text("Entity class: " + Type.getClassName(Type.getClass(haley)) + ".hx");
    Im.text("active: " + haley.active);
    Im.check("Toggle visibility", Im.bool(haley.active), true);
    Im.separator();
    Im.space();

    Im.text("Coordinates", TextAlign.CENTER);
    Im.separator();
    Im.text("x: " + Math.round(haley.x));
    Im.text("y: " + Math.round(haley.y));
    //  Im.text("Direction: " + haley.direction);
    if (Im.button("center Haley")) {
      haley.pos(screen.width * 0.5, screen.height * 0.5);
    }
    Im.space();
    Im.separator();
    Im.text("State Machine", TextAlign.CENTER);
    Im.separator();
    Im.text("active state: " + haley.currentState());
    Im.space();
    Im.end();
  }
}
