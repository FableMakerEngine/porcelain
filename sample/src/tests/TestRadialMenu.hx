package tests;

import ceramic.Point;
import ceramic.Quad;
import ceramic.Color;
import porcelain.RadialMenuButton;
import porcelain.RadialMenu;

class TestRadialMenu extends TestScene {
  var radialMenu: RadialMenu;

  public function new() {
    super();
    screen.onPointerDown(this, handlePointerDown);
    screen.onPointerUp(this, handlePointerUp);
  }

  public override function preload() {
    trace('Test Radial Menu Scene Initialized!');
    final iconsRegx = ~/^img\/.*$/ig;
    assets.addAll(iconsRegx);
  }

  public override function create() {
    super.create();
    titleText.content = "Radial Menu (Click to activate)";
    createRadialMenu();
  }

  function createRadialMenu() {
    radialMenu = new RadialMenu({
      arcHighlightColor: Color.fromRGB(38, 133, 178),
    });

    radialMenu.menuItems = [
      {
        label: 'Save',
        action: onRadialMenu,
        shortcutNumber: 1,
        icon: assets.imageAsset(Images.IMG__DARK__SAVE).texture
      },
      {
        label: 'Material Preview',
        action: onRadialMenu,
        shortcutNumber: 6,
        icon: assets.imageAsset(Images.IMG__DARK__GEAR).texture
      },
      {
        label: 'Lock',
        action: onRadialMenu,
        shortcutNumber: 9,
        icon: assets.imageAsset(Images.IMG__DARK__LOCKED).texture
      },
      {
        label: 'Select',
        action: onRadialMenu,
        shortcutNumber: 2,
        icon: assets.imageAsset(Images.IMG__DARK__POINTER).texture
      },
      {
        label: 'Brush',
        action: onRadialMenu,
        shortcutNumber: 3,
        icon: assets.imageAsset(Images.IMG__DARK__TOOL_BRUSH).texture
      },
      {
        label: 'Delete',
        action: onRadialMenu,
        shortcutNumber: 4,
        icon: assets.imageAsset(Images.IMG__DARK__TRASHCAN).texture
      }
    ];

    radialMenu.depth = 99;
    radialMenu.size(300, 300);
    radialMenu.pos(width * 0.5, height * 0.5);

    add(radialMenu);
  }

  function onRadialMenu(button: RadialMenuButton) {
    button.highlighted = true;
  }

  function handlePointerUp(info: ceramic.TouchInfo) {
    radialMenu.hide();
  }

  function handlePointerDown(info: ceramic.TouchInfo) {
    var p = new Point();
    radialMenu.pos(info.x, info.y);

    if (radialMenu.x + (radialMenu.width / 2) >= width) {
      radialMenu.x = width - (radialMenu.width / 2) - 25;
    }

    if (radialMenu.y + (radialMenu.height / 2) >= height) {
      radialMenu.y = height - (radialMenu.height / 2) - 25;
    }

    if (radialMenu.x - (radialMenu.width / 2) < 0) {
      radialMenu.x = 0 + radialMenu.width / 2 + 25;
    }

    if (radialMenu.y - (radialMenu.height / 2) < 0) {
      radialMenu.y = 0 + radialMenu.height / 2 + 25;
    }

    radialMenu.show();
  }
}
