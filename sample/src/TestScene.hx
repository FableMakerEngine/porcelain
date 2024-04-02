package;

import ceramic.App;
import ceramic.Tilemap;
import ceramic.Text;
import elements.Im;

class TestScene extends ceramic.Scene {
  var titleText: Text;
  private var testScenes: Array<String>;

  @observe var selectedScene: Int = -1;

  public function new() {
    super();
    testScenes = ['Initial', 'Ceramic', 'RadialMenu', 'Draggable'];
    onSelectedSceneChange(this, handleSceneChange);
  }

  public override function create() {
    titleText = new Text();
    titleText.content = 'Select a Scene';
    titleText.color = ceramic.Color.WHITE;
    titleText.pointSize = 52;
    titleText.anchor(0.5, 0.5);
    titleText.pos(screen.width * 0.5, screen.height * 0.5);
    add(titleText);
  }

  public override function update(dt: Float) {
    super.update(dt);
    debugWindow();
  }

  public function debugWindow() {
    Im.begin('Change Scene', 300);
    Im.text('Scene');
    Im.list(250, Im.array(testScenes), Im.int(selectedScene), true);
    Im.end();
  }

  function handleSceneChange(selectedScene: Int, prevScene: Int) {
    if (selectedScene != -1) {
      var sceneName = testScenes[selectedScene];

      switch (sceneName) {
        case 'Initial':
          App.app.scenes.main = new TestScene();
        case 'Ceramic':
          App.app.scenes.main = new tests.TestCeramic();
        case 'RadialMenu':
          App.app.scenes.main = new tests.TestRadialMenu();
        case 'Draggable':
          App.app.scenes.main = new tests.TestDraggable();
        default:
          trace('Unknown scene: ' + sceneName);
      }
    }
  }
}
