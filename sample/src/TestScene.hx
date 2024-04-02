package;

import ceramic.App;
import ceramic.Tilemap;
import ceramic.Text;
import elements.Im;

class TestScene extends ceramic.Scene {
  private var testScenes: Array<String>;

  @observe var selectedScene: Int = -1;

  public function new() {
    super();
    testScenes = ['Ceramic', 'Radial Menu', 'Scene3', 'Scene4', 'Scene5'];
    onSelectedSceneChange(this, handleSceneChange);
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
        case 'Ceramic':
          App.app.scenes.main = new tests.TestCeramic();
        case 'Radial Menu':
          App.app.scenes.main = new tests.TestRadialMenu();
        default:
          trace('Unknown scene: ' + sceneName);
      }
    }
  }
}
