package porcelain;

import ceramic.Color;
import ceramic.TouchInfo;
import ceramic.Text;
import ceramic.RoundedRect;

class RadialMenuButton extends RoundedRect {
  public var label: Text;
  public var highlighted: Bool = false;
  public var selected: Bool = false;

  @event public function action(button: RadialMenuButton) {};

  public function new(label: String, action: RadialMenuButton->Void) {
    super();
    radius(8);
    color = Color.fromRGB(34, 34, 34);

    if (action != null) {
      onAction(this, (this) -> {
        handleAction(action);
      });
    }

    onPointerOver(this, handlePointerOver);
    onPointerOut(this, handlePointerOut);

    createLabel(label);
  }

  function handleAction(action) {
    if (action != null) {
      action(this);
    }
    deselect();
    highlight();
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

  public function select() {
    if (highlighted || selected) {
      return;
    }
    selected = true;
    color = Color.fromRGB(100, 100, 100);
    scale(1.2, 1.2);
  }

  public function deselect() {
    if (selected) {
      color = Color.fromRGB(15, 15, 15);
      selected = false;
      scale(1, 1);
    }
  }

  public function highlight() {
    if (highlighted) {
      return;
    }
    color = Color.fromRGB(38, 133, 178);
    highlighted = true;
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
    select();
  }

  function handlePointerOut(info: TouchInfo) {
    deselect();
  }
}
