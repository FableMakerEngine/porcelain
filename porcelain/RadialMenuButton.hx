package porcelain;

import ceramic.Texture;
import ceramic.Quad;
import ceramic.Color;
import ceramic.Text;
import ceramic.RoundedRect;

class RadialMenuButton extends RoundedRect {
  public var label: Text;
  public var highlighted(default, set): Bool = false;
  public var selected: Bool = false;
  public var shortcutText: Text;
  public var fontSize: Int = 18;
  public var entryData(default, null): RadialMenuEntry;

  @:allow(porcelain.RadialMenu)
  var baseColor(default, set): Color = Color.fromRGB(20, 20, 20);
  @:allow(porcelain.RadialMenu)
  var selectedColor(default, set): Color = Color.fromRGB(100, 100, 100);
  @:allow(porcelain.RadialMenu)
  var highlightColor(default, set): Color = Color.fromRGB(38, 133, 178);

  var padding: Int = 35;
  var paddingHeight: Int = 20;
  var shortcutNumberSpacing: Int = 25;
  var textWidth: Float = 0;

  var icon: Quad;

  @event public function action(button: RadialMenuButton) {};

  public function new(entry: RadialMenuEntry) {
    super();
    entryData = entry;
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
    createShortcutText(entry.shortcutNumber);

    textWidth = label.width + shortcutText.width;
    size(textWidth + padding + shortcutNumberSpacing, label.height + paddingHeight);
  }

  function handleAction(action) {
    if (action != null) {
      action(this);
    }
  }

  function createLabel(?text: String) {
    label = new Text();
    label.pointSize = fontSize;
    label.anchor(0.5, 0.5);
    if (text != null) {
      label.content = text;
    }
    add(label);
  }

  function createShortcutText(number: Int) {
    shortcutText = new Text();
    shortcutText.content = '$number';
    shortcutText.anchor(0.5, 0.5);
    shortcutText.pointSize = fontSize - 4;
    shortcutText.x = width - (shortcutText.width + 10);
    shortcutText.color = Color.fromRGB(200, 200, 200);
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
    color = selectedColor;
    scale(1.2, 1.2);
  }

  public function deselect() {
    if (selected) {
      color = baseColor;
      selected = false;
      scale(1, 1);
    }
  }

  public function set_highlighted(value: Bool) {
    if (value) {
      color = highlightColor;
    } else {
      color = baseColor;
    }
    return highlighted = value;
  }

  public function set_baseColor(color: Color) {
    if (color == baseColor) {
      return this.color;
    }
    baseColor = color;
    return this.color = color;
  }

  public function set_selectedColor(color: Color) {
    if (color == selectedColor) {
      return selectedColor;
    }
    return selectedColor = color;
  }

  public function set_highlightColor(color: Color) {
    if (color == highlightColor) {
      return highlightColor;
    }
    return highlightColor = color;
  }

  override function set_width(width: Float): Float {
    if (label != null) {
      label.pos(width / 2, height / 2);
      shortcutText.pos(width - (shortcutText.width + 5), height / 2);
    }
    return super.set_width(width);
  }

  override function set_height(height: Float): Float {
    if (label != null) {
      label.pos(width / 2, height / 2);
      shortcutText.pos(width - (shortcutText.width + 5), height / 2);
    }
    return super.set_height(height);
  }
}
