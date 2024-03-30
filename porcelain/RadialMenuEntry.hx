package porcelain;

import ceramic.Texture;

typedef RadialMenuEntry = {
  var label: String;
  var ?shortcutNumber: Int;
  var ?icon: Texture;
  var ?action: RadialMenuButton->Void;
}
