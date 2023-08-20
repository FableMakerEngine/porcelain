package objects.player.states;

import ceramic.StateMachine;
import objects.player.enums.HaleyState;
import ceramic.State;

class Haley_IdleState extends State {
  private var context: Haley;

  public function new(context: Haley) {
    super();
    this.context = context;
    machine = context.machine;
  }

  public override function enter() {
    super.enter();
    // log.debug(machine.state);
  }

  public override function update(delta: Float) {
    super.update(delta);
    if (context.isMoving()) context.switchState(HaleyState.WALKING);
  }
}
