package porcelain;

import ceramic.InputMap;
import tracker.Observable;
import ceramic.App;
import ceramic.Arc;
import ceramic.Color;
import ceramic.Text;
import ceramic.TouchInfo;
import ceramic.Visual;

enum abstract ShortcutInput(Int) from Int to Int {
  var ONE = 1;
  var TWO = 2;
  var THREE = 3;
  var FOUR = 4;
  var FIVE = 5;
  var SIX = 6;
  var SEVEN = 7;
  var EIGHT = 8;
  var NINE = 9;
  var TEN = 0;
}

class RadialMenu extends Visual implements Observable {
  var buttons: Array<RadialMenuButton>;
  var centerCircle: Arc;
  var centerMouseArc: Arc;
  var label: Text;
  var inputMap: InputMap<ShortcutInput>;

  @observe var selectedButtonIndex: Int = -1;

  public function new() {
    super();
    anchor(0.5, 0.5);
    buttons = [];
    App.app.screen.onPointerMove(this, handlePointerMove);
    onSelectedButtonIndexChange(this, selectedButtonIndexChanged);
    inputMap = new InputMap();
    bindInputs();
    createCenterCircle();
    createMouseArc();
    visible = false;
  }

  public function show() {
    visible = true;
    animateButtons();
  }

  public function hide() {
    visible = false;
    if (selectedButtonIndex != -1 && buttons[selectedButtonIndex] != null) {
      for (button in buttons) {
        button.deselect();
        button.highlighted = false;
      }
      buttons[selectedButtonIndex].emitAction(buttons[selectedButtonIndex]);
    }
  }

  public function selectedButtonIndexChanged(selectedIndex: Int, prev: Int) {
    if (buttons[prev] != null) {
      buttons[prev].deselect();
    }
    if (buttons[selectedButtonIndex] != null) {
      buttons[selectedButtonIndex].select();
    }
  }

  public function bindInputs() {
    inputMap.bindKeyCode(ShortcutInput.ONE, KEY_1);
    inputMap.bindKeyCode(ShortcutInput.TWO, KEY_2);
    inputMap.bindKeyCode(ShortcutInput.THREE, KEY_3);
    inputMap.bindKeyCode(ShortcutInput.FOUR, KEY_4);
    inputMap.bindKeyCode(ShortcutInput.FIVE, KEY_5);
    inputMap.bindKeyCode(ShortcutInput.SIX, KEY_6);
    inputMap.bindKeyCode(ShortcutInput.SEVEN, KEY_7);
    inputMap.bindKeyCode(ShortcutInput.EIGHT, KEY_8);
    inputMap.bindKeyCode(ShortcutInput.NINE, KEY_9);
    inputMap.bindKeyCode(ShortcutInput.TEN, KEY_0);

    inputMap.onKeyDown(this, handleKeyDown);
  }

  public function addButton(entry: RadialMenuEntry): RadialMenuButton {
    var button = new RadialMenuButton(entry);
    button.anchor(0.5, 0.5);
    buttons.push(button);
    add(button);

    return button;
  }

  function createCenterCircle(): Void {
    centerCircle = new Arc();
    centerCircle.angle = 360;
    centerCircle.depth = 6;
    centerCircle.radius = 15;
    centerCircle.borderPosition = OUTSIDE;
    centerCircle.thickness = 6;
    centerCircle.color = Color.GRAY;
    centerCircle.anchor(0.5, 0.5);
    centerCircle.pos(width / 2 - 7.5, height / 2 - 7.5);
    add(centerCircle);
  }

  function createMouseArc(): Void {
    centerMouseArc = new Arc();
    centerMouseArc.angle = 90;
    centerMouseArc.depth = 10;
    centerMouseArc.radius = 15;
    centerMouseArc.borderPosition = OUTSIDE;
    centerMouseArc.thickness = 6;
    centerMouseArc.color = Color.ORANGE;
    centerMouseArc.anchor(0.5, 0.5);
    centerMouseArc.pos(width / 2 - 7.5, height / 2 - 7.5);
    centerMouseArc.visible = false;
    add(centerMouseArc);
  }

  public function animateButtons(): Void {
    var centerX: Float = width / 2;
    var centerY: Float = height / 2;
    var radius: Float = Math.min(width, height) / 2 - 20;
    var angleStep: Float = 2 * Math.PI / buttons.length;
    var currentAngle: Float = 0;

    for (i in 0...buttons.length) {
      var button = buttons[i];
      var finalX: Float = centerX + radius * Math.cos(currentAngle);
      var finalY: Float = centerY + radius * Math.sin(currentAngle);

      button.tween(QUAD_EASE_IN_OUT, 0.1, centerX, finalX, (value, time) -> {
        button.x = value;
      });
      button.tween(QUAD_EASE_IN_OUT, 0.1, centerY, finalY, (value, time) -> {
        button.y = value;
      });

      currentAngle += angleStep;
    }

    centerCircle.pos(centerX, centerY);
    centerMouseArc.pos(centerX, centerY);
  }

  function handleKeyDown(key: ShortcutInput) {
    if (visible == false) {
      return;
    }
    trace('hjere');
    for (button in buttons) {
      if (button.entryData.shortcutNumber == key) {
        selectedButtonIndex = buttons.indexOf(button);
        button.emitAction(button);
        hide(); /*  */
      }
    }
  }

  function handlePointerMove(info: TouchInfo) {
    if (centerCircle == null || centerMouseArc == null || visible == false) {
      return;
    }

    var mouseX: Float = info.x - x;
    var mouseY: Float = info.y - y;
    var angle = Math.atan2(mouseY, mouseX) * 180 / Math.PI;

    var lineLength: Float = centerMouseArc.radius * 15;
    var lineEndX: Float = centerMouseArc.x + lineLength * Math.cos(angle * Math.PI / 180);
    var lineEndY: Float = centerMouseArc.y + lineLength * Math.sin(angle * Math.PI / 180);

    var dx: Float = info.x - x;
    var dy: Float = info.y - y;
    var distance: Float = Math.sqrt(dx * dx + dy * dy);

    if (distance <= centerCircle.radius + 4) {
      selectedButtonIndex = -1;
      centerMouseArc.visible = false;
    } else {
      centerMouseArc.visible = true;
      var lineAngle: Float = Math.atan2(lineEndY - centerMouseArc.y, lineEndX - centerMouseArc.x) * 180 / Math.PI;
      lineAngle = (lineAngle + 360) % 360;
      var angleStep: Float = 360 / buttons.length;
      var tolerance: Float = angleStep * 0.5;
      selectedButtonIndex = Math.floor((lineAngle + tolerance) / angleStep) % buttons.length;
    }

    centerMouseArc.rotation = angle + 45;
  }
}
