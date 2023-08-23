package objects.player.states;

import ceramic.State;

class Haley_WalkingState extends Haley_BaseState {
  public function new(entity: Haley) {
    super(entity);
  }

  public override function update(delta: Float) {
    super.update(delta);
    if (!isMoving()) switchState(IDLE); // to do since I feeelllll that will cause some bug later I fear it

    updateMovement(delta);
  }

  private function updateMovement(delta: Float) {
    var moveSpeed = entity.moveSpeed;
    if (Input.isPressed(LEFT)) {
      entity.x -= moveSpeed * delta;
      return;
    }
    if (Input.isPressed(RIGHT)) {
      entity.x += moveSpeed * delta;
      return;
    }
  }

  private function isMoving(): Bool {
    return Input.isPressed(LEFT) || Input.isPressed(RIGHT);
  }
}
