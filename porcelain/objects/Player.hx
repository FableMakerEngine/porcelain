package porcelain.objects;

import ceramic.InputMap;
import ceramic.Sprite;

/**
 * the movement constraint for the player
 * it remap the input to work with those movement.
 */
enum MovementConstraint {
  SIDESCROLER;
  TOPDOWN;
}

enum abstract Direction(Int) {
  var RIGHT;
  var LEFT;
  var DOWN;
  var UP;
  //  var ENTER;
}

// @TODO should I separate the movement as a Character controller?

/**
 * the player class it can be easily extended but it provide basic system.
 * by doing so just extend the player class with your own behavior class and 
 * in Fable maker just create a new player object and assign a your new behaviour class
 */
class Player extends Sprite {
  public var direction: Direction;

  // @serialize // means that this variable is shown in the inspector

  /**
   * the player movement speed
   */
  private var moveSpeed = 4;

  private var inputMap: InputMap<Direction>;

  public function new() {
    super();
    inputMap = new InputMap(); // TODO later to actually separate this from the player logic or at least  bind it somewhere else

    bindInput();
  }

  private function bindInput() {
    // Bind keyboard
    //
    inputMap.bindKeyCode(RIGHT, RIGHT);
    inputMap.bindKeyCode(LEFT, LEFT);
    inputMap.bindKeyCode(DOWN, DOWN);
    inputMap.bindKeyCode(UP, UP);
    // We use scan code for these so that it
    // will work with non-qwerty layouts as well
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

  public function movementConstraint() {
    return SIDESCROLER;
  }

  private function movementVector() {}

  public override function update(delta: Float) {
    super.update(delta);
    // todo implement the state machine right now we only want to deal with the movement
    if (playerCanMove())
      updateMovement(delta);
  }

  public function playerCanMove() {
    return true; // for the moment theres no system to block.
  }

  private function updateMovement(delta: Float) {
    if (movementConstraint() != SIDESCROLER) {
      if (inputMap.pressed(UP)) {
        y += moveSpeed * delta;
        direction = UP;
      }
      if (inputMap.pressed(DOWN)) {
        y -= moveSpeed * delta;
        direction = DOWN;
      }
    }

    if (inputMap.pressed(LEFT)) {
      x -= moveSpeed * delta;
      direction = LEFT;
    }

    if (inputMap.pressed(RIGHT)) {
      y += moveSpeed * delta;
      direction = RIGHT;
    }
  }
}
