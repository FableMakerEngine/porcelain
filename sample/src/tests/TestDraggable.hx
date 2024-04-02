package tests;

import ceramic.Color;
import ceramic.Quad;
import porcelain.Draggable;

class TestDraggable extends TestScene {
  var draggableQuads: Array<Quad> = [];

  public function new() {
    super();
  }

  public override function create() {
    super.create();
    titleText.content = "Draggable Component!";
    createDraggableIems();
  }

  private function createDraggableIems() {
    for (i in 0...8) {
      var quad = new Quad();
      quad.size(100, 100);
      quad.color = Color.GREEN;
      quad.anchor(0.5, 0.5);
      quad.pos(100 + (Math.random() * (width - 100)), 100 + (Math.random() * (height - 100)));

      draggableQuads.push(quad);
      add(quad);

      var draggable = new Draggable();
      quad.component('draggable', draggable);
      draggable.enabled = true;

      if (i == 5) {
        draggable.enabled = false;
        quad.color = Color.RED;
      }

      quad.onPointerDown(null, _ -> {
        if (quad.hasComponent('draggable') && draggable.enabled) {
          quad.color = Color.LIGHTPINK;
        }
      });

      quad.onPointerUp(null, _ -> {
        if (quad.hasComponent('draggable') && draggable.enabled) {
          quad.color = Color.GREEN;
        }
      });
    }
  }
}
