package objects.player.states;

import ceramic.State;

class Haley_WalkingState extends State {
  private var _ctx: Haley;

  public function new(context: Haley) {
    super();
    _ctx = context;
  }

  public override function update(delta: Float) {
    super.update(delta);
    if (!isMoving()) _ctx.machine.state = IDLE; // to do since I feeelllll that will cause some bug later I fear it

    updateMovement(delta);
  }

  private function updateMovement(delta: Float) {
    var moveSpeed = _ctx.moveSpeed;
  }

  private function isMoving(): Bool {
    return Input.isPressed(LEFT) || Input.isPressed(RIGHT);
  }
}
