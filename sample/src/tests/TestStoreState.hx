package tests;

import porcelain.store.*;

class AppState extends State {
  @observe public var projectPath: String = '';
}

class AppStore implements Store {
  @state public static var state = new AppState();

  public var test = 'string';

  @mutation var projectMutations: StateMutations;
}

class StateMutations implements Mutation {
  public function new() {}

  public static function updateProjectPath(path: String) {
    @:privateAccess AppStore.state.projectPath = '';
  }
}

class TestStoreState {
  public function new() {
    AppStore.state.onProjectPathChange(null, (current, prev) -> {
      trace('projectPath has changed values from $prev to $current');
    });
    AppStore.updateProjectPath('new/path');
  }
}
