package objects.player;

import ceramic.InputMap;
import ceramic.StateMachine;
import ceramic.Color;
import ceramic.Quad;
import ceramic.Sprite;

// TODO actually setting up haley in a proper way so its not hard to extend

/**
 * Haley state machine
 */
enum abstract HaleyState(String) {
  var IDLE;
  var WALKING;
  var RUNNING;
  var INTERACTING;
}

/**
 * The player Input
 */
enum PlayerInput {
  RIGHT;
  LEFT;
  DOWN;
  UP;
  ENTER;
  DASH;
  DEBUG;
}

/**
 * Haley direction
 */
enum abstract Direction(String) {
  var DTOP; // 0
  var DDOWN; // 1
  var DLEFT; // 2
  var DRIGHT; // 3
}

// WE MIGHT NOT HAVE TO USE Sprite here and instead use Spine!
class OLDHaley extends Sprite {
  public var name: String = "Haley";
  public final DEBUG: Bool = true;

  private var moveSpeed: Float = 50;
  private var debugSprite: Quad;

  public var direction: Direction;

  @component public var stateMachine = new StateMachine<HaleyState>();

  public var inputMap = new InputMap<PlayerInput>();

  public function new() {
    super();
    initMembers();
    bindInput();
    if (DEBUG) {
      drawDebugShape();
    }
  }

  private function initMembers() {
    direction = Direction.DDOWN;
    stateMachine.state = IDLE;
  }

  private function drawDebugShape() {
    debugSprite = new Quad();
    debugSprite.anchor(0.5, 0.5);
    debugSprite.size(100, 100);
    debugSprite.pos(width * 0.5, height * 0.5);
    debugSprite.color = Color.BLUE;

    add(debugSprite);
  }

  private function bindInput() {
    // Bind keyboard
    //
    inputMap.bindKeyCode(RIGHT, RIGHT);
    inputMap.bindKeyCode(LEFT, LEFT);
    inputMap.bindKeyCode(DOWN, DOWN);
    inputMap.bindKeyCode(UP, UP);
    inputMap.bindKeyCode(ENTER, SPACE); // TEMP
    inputMap.bindKeyCode(DASH, LSHIFT); // We use scan code for these so that it // will work with non-qwerty layouts as well
    inputMap.bindScanCode(RIGHT, KEY_D);
    inputMap.bindScanCode(LEFT, KEY_A);
    inputMap.bindScanCode(DOWN, KEY_S);
    inputMap.bindScanCode(UP, KEY_W);

    // Bind gamepad
    //
    inputMap.bindGamepadAxisToButton(RIGHT, LEFT_X, 0.25);
    inputMap.bindGamepadAxisToButton(LEFT, LEFT_X, -0.25);
    inputMap.bindGamepadAxisToButton(DOWN, LEFT_Y, 0.25);
    inputMap.bindGamepadAxisToButton(UP, LEFT_Y, -0.25);
    inputMap.bindGamepadButton(RIGHT, DPAD_RIGHT);
    inputMap.bindGamepadButton(LEFT, DPAD_LEFT);
    inputMap.bindGamepadButton(DOWN, DPAD_DOWN);
    inputMap.bindGamepadButton(UP, DPAD_UP);
  }

  // is update really needed in this case??
  override function update(delta: Float) {
    super.update(delta);
    updateMovement(delta);
    updateInput(delta);
    updateIdleAnimations();
  }

  private function updateMovement(delta: Float) {
    if (inputMap.pressed(DASH)) {
      moveSpeed = 400;
    } else {
      moveSpeed = 100;
    }
    if (inputMap.pressed(UP)) {
      y -= moveSpeed * delta;
      //  return;
    }
    if (inputMap.pressed(LEFT)) {
      x -= moveSpeed * delta;
      //  return;
    }

    if (inputMap.pressed(RIGHT)) {
      x += moveSpeed * delta;
      //  return;
    }

    if (inputMap.pressed(DOWN)) {
      y += moveSpeed * delta;
      //  return;
    }
  }

  public function IDLE_update(delta: Float) {
    // updateInput(delta);
    updateAnimations();
    // TODO : export this into an more less convulted system? or more extendible
  }

  public function WALKING_update(delta: Float) {
    // updateInput(delta);
    if (isMoving())
      return;
    stateMachine.state = IDLE;
  }

  private function updateInput(delta: Float) {
    if (inputMap.pressed(UP)) {
      direction = Direction.DTOP;
      stateMachine.state = WALKING;
    }
    if (inputMap.pressed(LEFT)) {
      direction = Direction.DLEFT;
      stateMachine.state = WALKING;
    }

    if (inputMap.pressed(RIGHT)) {
      direction = Direction.DRIGHT;
      stateMachine.state = WALKING;
    }

    if (inputMap.pressed(DOWN)) {
      direction = Direction.DDOWN;
      stateMachine.state = WALKING;
    }
    if (!isMoving())
      stateMachine.state = IDLE;
  }

  private function updateAnimations() {
    var state = stateMachine.state;
    if (state == IDLE || state == INTERACTING) {
      updateIdleAnimations();
    }
  }

  // todo until I create an custom function for the input map?
  private function isMoving(): Bool {
    var i = inputMap.pressed;
    return i(UP) || i(LEFT) || i(RIGHT) || i(DOWN);
  }

  private function updateIdleAnimations() {
    switch (direction) {
      case DTOP:
        debugSprite.color = Color.BROWN;
      case DLEFT:
        debugSprite.color = Color.CORAL;
      case DRIGHT:
        debugSprite.color = Color.DARKOLIVEGREEN;
      case DDOWN:
        debugSprite.color = Color.DARKRED;
    }
  }
}
