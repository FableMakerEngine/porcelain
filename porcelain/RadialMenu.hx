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

class Button extends RoundedRect {
  public var label: Text;

  @event public function click(info: TouchInfo) {};

  public function new(label: String, onClick: Void->Void) {
    super();
    radius(8);
    color = Color.fromRGB(34, 34, 34);

    onPointerUp(this, (info: TouchInfo) -> {
      emitClick(info);
    });

    onPointerOver(this, handlePointerOver);
    onPointerOut(this, handlePointerOut);

    createLabel(label);
  }

  function createLabel(?text: String) {
    label = new Text();
    label.anchor(0.5, 0.5);
    if (text != null) {
      label.content = text;
    }
    if (width == 0 || height == 0) {
      size(label.width + 15, label.height + 15);
    }
    add(label);
  }

  override function set_width(width: Float): Float {
    label.pos(width / 2, height / 2);
    return super.set_width(width);
  }

  override function set_height(height: Float): Float {
    label.pos(width / 2, height / 2);
    return super.set_height(height);
  }

  function handlePointerOver(info: TouchInfo) {
    color = Color.fromRGB(50, 50, 50);
  }

  function handlePointerOut(info: TouchInfo) {
    color = Color.fromRGB(34, 34, 34);
  }
}

class RadialMenu extends Visual implements Observable {
  var buttons: Array<Button>;
  var centerCircle: Arc;
  var centerMouseArc: Arc;
  var label: Text;
  var line: Line;
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
      buttons[prev].color = Color.fromRGB(34, 34, 34);
    }
    if (buttons[selectedButtonIndex] != null) {
      buttons[selectedButtonIndex].color = Color.fromRGB(50, 50, 50);
    }
  }

  public function addButton(label: String, callback: Void->Void): Void {
    var button = new Button(label, callback);
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

  function createLine(): Void {
    line = new Line();

    line.color = Color.WHITE;
    line.points = [0, 0, 0, 0];
    add(line);
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
    createLine();
  }

  function handlePointerMove(info: TouchInfo) {
    if (centerCircle == null || centerMouseArc == null) {
      return;
    }
    var mouseX: Float = info.x - App.app.screen.width / 2;
    var mouseY: Float = info.y - App.app.screen.height / 2;
    var angle = Math.atan2(mouseY, mouseX) * 180 / Math.PI;

    // Draw line
    var lineLength: Float = centerMouseArc.radius * 8;
    var lineEndX: Float = centerMouseArc.x + lineLength * Math.cos(angle * Math.PI / 180);
    var lineEndY: Float = centerMouseArc.y + lineLength * Math.sin(angle * Math.PI / 180);
    line.points = [centerMouseArc.x, centerMouseArc.y, lineEndX, lineEndY];

    // Determine the selected button
    var lineAngle: Float = Math.atan2(lineEndY - centerMouseArc.y, lineEndX - centerMouseArc.x) * 180 / Math.PI;
    lineAngle = (lineAngle + 360) % 360;
    var angleStep: Float = 360 / buttons.length;
    selectedButtonIndex = Math.floor(lineAngle / angleStep);

    centerMouseArc.rotation = angle + 45;
  }
}
