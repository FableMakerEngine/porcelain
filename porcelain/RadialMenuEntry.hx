package porcelain;

import ceramic.Texture;

typedef RadialMenuEntry = {
  var label: String;
  var shortcutNumber: Int;
  var action: RadialMenuButton->Void;
  var ?icon: Texture;
}
