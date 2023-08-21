package objects.player.states;

import objects.player.enums.HaleyState;
import ceramic.StateMachine;
import ceramic.State;

/**
 * The abstract class that shape Haley State. 
 * it is a workaround until ceramic has a more flexible state machine.
 * it also act as an super class to implement any specific method.
 */
abstract class Haley_BaseState extends State {
  private var _machine: StateMachine<HaleyState>; // it is due to the parent class rn the keyword machine is already taken
  private var entity: Haley;

  public function new(entity: Haley) {
    super();
    _machine = entity.machine;
    this.entity = entity;
  }

  /**
   * return the current active state
   * @return HaleyState
   */
  public function state(): HaleyState {
    return _machine.state;
  }

  public function switchState(nextState: HaleyState) {
    _machine.state = nextState;
  }
}
