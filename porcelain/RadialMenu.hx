package porcelain;

import ceramic.Transform;
import ceramic.Line;
import tracker.Observable;
import ceramic.AlphaColor;
import ceramic.App;
import ceramic.Quad;
import ceramic.Arc;
import ceramic.Color;
import ceramic.Text;
import ceramic.TouchInfo;
import ceramic.Visual;
import ceramic.RoundedRect;

class RadialMenu extends Visual implements Observable {
  var buttons: Array<RadialMenuButton>;
  var centerCircle: Arc;
  var centerMouseArc: Arc;
  var label: Text;

  @observe var selectedButtonIndex: Int = -1;

  public function new() {
    super();
    anchor(0.5, 0.5);
    buttons = [];
    App.app.screen.onPointerMove(this, handlePointerMove);
    onSelectedButtonIndexChange(this, selectedButtonIndexChanged);
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

      if (button.shortcutText.content != null) {
        var shortcutNumber = i + 1;
        button.shortcutText.content = '$shortcutNumber';
      }
      currentAngle += angleStep;
    }

    centerCircle.pos(centerX, centerY);
    centerMouseArc.pos(centerX, centerY);
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
