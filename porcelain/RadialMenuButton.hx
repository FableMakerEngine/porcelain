package porcelain;

import ceramic.Color;
import ceramic.TouchInfo;
import ceramic.Text;
import ceramic.RoundedRect;

class RadialMenuButton extends RoundedRect {
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

  public function select() {
    color = Color.fromRGB(50, 50, 50);
    size(width + 10, height + 10);
  }

  public function deselect() {
    color = Color.fromRGB(34, 34, 34);
    size(width - 10, height - 10);
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
