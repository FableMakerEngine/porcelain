package objects.player.states;

class Haley_IdleState extends Haley_BaseState {
  public function new(entity: Haley) {
    super(entity);
  }

  public override function enter() {
    super.enter();
    // log.debug(machine.state);
  }

  public override function update(delta: Float) {
    super.update(delta);
    if (entity.isMoving()) switchState(WALKING);
  }
}
