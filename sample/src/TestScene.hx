package;

import ceramic.Text;
import haxe.Json;

class TestScene extends ceramic.Scene {
  private var text: Text;
  private var rect: porcelain.Rect;

  public function new() {
    super();
  }

  public override function preload() {
    trace('Test Scene Initialized!');
  }

  public override function create() {
    createText();
    createRect();
  }

  private function createText() {
    text = new Text();
    text.content = "Hello World!";
    text.color = ceramic.Color.WHITE;
    text.pointSize = 52;
    text.anchor(0.5, 0.5);
    text.pos(screen.width * 0.5, screen.height * 0.5);
    add(text);
  }

  private function createRect() {
    rect = new porcelain.Rect(50, 50, 4);
    add(rect);
  }

  public override function resize(width: Float, height: Float) {
    text.pos(width * 0.5, height * 0.5);
  }

  public override function update(dt: Float) {
    text.rotation += 25 * dt;
  }
}
