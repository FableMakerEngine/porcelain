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
  }

  public function show() {}

  public function hide() {}

  public function selectedButtonIndexChanged(selectedIndex: Int, prev: Int) {
    trace(selectedIndex);
    if (buttons[prev] != null) {
      buttons[prev].deselect();
    }
    if (buttons[selectedButtonIndex] != null) {
      buttons[selectedButtonIndex].select();
    }
  }

  public function addButton(label: String, callback: Void->Void): Void {
    var button = new RadialMenuButton(label, callback);
    buttons.push(button);
    add(button);
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
    add(centerMouseArc);
  }

  public function layoutButtons(): Void {
    var centerX: Float = width / 2;
    var centerY: Float = height / 2;
    var radius: Float = Math.min(width, height) / 2 - 20;

    var angleStep: Float = 2 * Math.PI / buttons.length;
    var currentAngle: Float = 0;

    for (button in buttons) {
      var x: Float = centerX + radius * Math.cos(currentAngle);
      var y: Float = centerY + radius * Math.sin(currentAngle);

      button.pos(x - button.width / 2, y - button.height / 2);

      currentAngle += angleStep;
    }

    createCenterCircle();
    createMouseArc();
  }

  function handlePointerMove(info: TouchInfo) {
    if (centerCircle == null || centerMouseArc == null) {
      return;
    }
    var mouseX: Float = info.x - App.app.screen.width / 2;
    var mouseY: Float = info.y - App.app.screen.height / 2;
    var angle = Math.atan2(mouseY, mouseX) * 180 / Math.PI;

    var lineLength: Float = centerMouseArc.radius * 8;
    var lineEndX: Float = centerMouseArc.x + lineLength * Math.cos(angle * Math.PI / 180);
    var lineEndY: Float = centerMouseArc.y + lineLength * Math.sin(angle * Math.PI / 180);

    // Determine the selected button
    var lineAngle: Float = Math.atan2(lineEndY - centerMouseArc.y, lineEndX - centerMouseArc.x) * 180 / Math.PI;
    lineAngle = (lineAngle + 360) % 360;
    var angleStep: Float = 360 / buttons.length;
    var tolerance: Float = angleStep * 0.5;
    selectedButtonIndex = Math.floor((lineAngle + tolerance) / angleStep) % buttons.length;

    centerMouseArc.rotation = angle + 45;
  }
}
