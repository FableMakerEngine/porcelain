package tests;

import ceramic.Tilemap;
import ceramic.Text;

using ceramic.TilemapPlugin;

class TestCeramic extends TestScene {
  private var tileemap: Tilemap;

  public function new() {
    super();
  }

  public override function preload() {
    trace('Test Scene Initialized!');
    assets.addTilemap('data/MapTest.tmx');
  }

  public override function create() {
    super.create();
    titleText.content = "Hello World!";
    createTilemap();
  }

  private function createTilemap() {
    var tilemap = new Tilemap();
    tilemap.roundTilesTranslation = 1;
    tilemap.tilemapData = assets.tilemap('data/MapTest.tmx');
    tilemap.depth = 0;
    add(tilemap);
  }

  public override function resize(width: Float, height: Float) {
    if (titleText != null) {
      titleText.pos(width * 0.5, height * 0.5);
    }
  }

  public override function update(dt: Float) {
    super.update(dt);
    if (titleText != null) {
      titleText.rotation += 25 * dt;
    }
  }
}
