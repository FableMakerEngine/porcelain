package objects.player;

import ceramic.InputMap;
import objects.player.enums.PlayerInput;

/**
 * The class that manage the player Input.
 * it is an Singleton abstraction Layer to the InputMap to allow 
 * an global access to the InputMap
 */
class Input {
  private static var _inputMap: InputMap<PlayerInput>;

  public static function init() {
    _inputMap = new InputMap<PlayerInput>();
    bindKeyCode();
  }

  /**
   * return the input map instance
   * @return InputMap<PlayerInput>
   */
  public static function inputMap(): InputMap<PlayerInput> {
    return _inputMap;
  }

  /**
   * return wheter the player press an key
   * @param key 
   * @return Bool
   */
  public static function isPressed(key: PlayerInput): Bool {
    return _inputMap.pressed(key);
  }

  /**
   * return whether the player just pressed an key
   * @param key 
   * @return Bool
   */
  public static function isJustPressed(key: PlayerInput): Bool {
    return _inputMap.justPressed(key);
  }

  /**
   * Return whether the player just released an key
   * @param key 
   * @return Bool
   */
  public static function isReleased(key: PlayerInput): Bool {
    return _inputMap.justReleased(key);
  }

  /**
   * Check if the player pressed any of the keys
   * @param key 
   * @return Bool
   */
  public static function isAnyPressed(key: PlayerInput): Bool {
    var bool = true;
    for (key in Type.allEnums(PlayerInput)) {
      if (_inputMap.pressed(key)) continue;
      bool = false;
      break;
    }
    return bool;
  }

  /**
   * check if the player just pressed any of the keys
   * @param key 
   * @return Bool
   */
  public static function isAnyJustPressed(key: PlayerInput): Bool {
    var bool = true;
    for (key in Type.allEnums(PlayerInput)) {
      if (_inputMap.justPressed(key)) continue;
      bool = false;
      break;
    }
    return bool;
  }

  private static function bindKeyCode() {
    bindKeyboard();
    bindGamepad();
    // Bind keyboard
    //
    /*

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
     */
  }

  private static function bindKeyboard() {
    var input = _inputMap;

    input.bindKeyCode(RIGHT, RIGHT);
    input.bindKeyCode(LEFT, LEFT);

    // ASERTY
    input.bindScanCode(RIGHT, KEY_D);
    input.bindScanCode(LEFT, KEY_A);

    input.bindScanCode(DEBUG, KEY_F);
  }

  private static function bindGamepad() {
    var input = _inputMap;

    input.bindGamepadAxisToButton(RIGHT, LEFT_X, 0.25);
    input.bindGamepadAxisToButton(LEFT, LEFT_X, -0.25);
  }
}
