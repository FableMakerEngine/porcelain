package porcelain;

import ceramic.Texture;
import ceramic.Quad;
import ceramic.Color;
import ceramic.TouchInfo;
import ceramic.Text;
import ceramic.RoundedRect;

class RadialMenuButton extends RoundedRect {
  public var label: Text;
  public var highlighted(default, set): Bool = false;
  public var selected: Bool = false;
  public var shortcutText: Text;

  var icon: Quad;

  @event public function action(button: RadialMenuButton) {};

  public function new(entry: RadialMenuEntry) {
    super();
    radius(8);
    color = Color.fromRGB(34, 34, 34);

    if (entry.action != null) {
      onAction(this, (this) -> {
        handleAction(entry.action);
      });
    }

    if (entry.icon != null) {
      createIcon(entry.icon);
    }
    size(120, 40);
    createLabel(entry.label);
    createShortcutText();
    size(label.width + shortcutText.width + 15, label.height + 15);
  }

  function handleAction(action) {
    if (action != null) {
      action(this);
    }
  }

  function createLabel(?text: String) {
    label = new Text();
    label.anchor(0.5, 0.5);
    if (text != null) {
      label.content = text;
    }
    add(label);
  }

  function createShortcutText() {
    shortcutText = new Text();
    shortcutText.anchor(0.5, 0.5);
    shortcutText.pointSize = shortcutText.pointSize - 3;
    shortcutText.pos(width - (shortcutText.width + 10), label.height);
    add(shortcutText);
  }

  function createIcon(iconTexture: Texture) {
    icon = new Quad();
    icon.texture = iconTexture /*  */;
    icon.anchor(0.5, 0.5);
    // icon.color = Color.fromRGB(15, 15, 15);
    add(icon);
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

  public function set_highlighted(value: Bool) {
    if (value) {
      color = Color.fromRGB(38, 133, 178);
    } else {
      color = Color.fromRGB(15, 15, 15);
    }
    return highlighted = value;
  }

  override function set_width(width: Float): Float {
    if (width < 120) {
      width = 120;
    }
    if (label != null) {
      label.pos(width / 2, height / 2);
    }
    return super.set_width(width);
  }

  override function set_height(height: Float): Float {
    if (height < 40) {
      height = 40;
    }
    if (label != null) {
      label.pos(width / 2, height / 2);
    }
    return super.set_height(height);
  }
}
