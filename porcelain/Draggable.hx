package porcelain;

import ceramic.MouseButton;
import ceramic.App;
import ceramic.Point;
import ceramic.Visual;
import ceramic.TouchInfo;
import ceramic.Entity;
import ceramic.Component;

class Draggable extends Entity implements Component {
  @entity var visual: Visual;
  var dragStart = new Point();
  var isDragging: Bool = false;

  public var enabled: Bool = false;

  public function new() {
    super();
  }

  function bindAsComponent() {
    visual.onPointerDown(this, handleMouseDown);
    visual.onPointerUp(this, handleMouseUp);
    App.app.screen.onMouseMove(this, handleMouseMove);
  }

  function handleMouseMove(x: Float, y: Float) {
    if (isDragging) {
      visual.x = x - dragStart.x;
      visual.y = y - dragStart.y;
    }
  }

  function handleMouseUp(info: TouchInfo) {
    if (visual == null || !enabled) {
      return;
    }
    if (info.buttonId == MouseButton.LEFT && isDragging) {
      isDragging = false;
    }
  }

  function handleMouseDown(info: TouchInfo) {
    if (visual == null || !enabled) {
      return;
    }
    if (info.buttonId == MouseButton.LEFT && !isDragging) {
      isDragging = true;
      dragStart.x = info.x - visual.x;
      dragStart.y = info.y - visual.y;
    }
  }
}
