package objects.player;

import objects.player.states.Haley_WalkingState;
import objects.player.states.Haley_IdleState;
import ceramic.StateMachine;
import ceramic.Sprite;
import objects.player.enums.HaleyState;

/**
 * Haley is the main player class
 * TODO: convert haley system to the new system when it work
 */
class Haley extends Sprite {
  public var name = "Haley";

  @component
  public var machine: StateMachine<HaleyState>;
  @:isVar public var moveSpeed(get, set): Int;
  @:isVar public var dashSpeed(get, set): Int;

  public function new() {
    super();
    setupStateMachine();
    initMembers();
  }

  override function update(delta: Float) {
    super.update(delta);
  }

  private function initMembers() {
    moveSpeed = 400;
    moveSpeed = 700;
    machine.state = IDLE;
  }

  /**
   * Haley current state
   * @return HaleyState
   */
  public function currentState(): HaleyState {
    return machine.state;
  }

  /**
   * switch haley current state
   * TODO:  create an base class for all entity
   * @param newState 
   */
  public function switchState(newState: HaleyState) {
    machine.state = newState;
  }

  private function setupStateMachine() {
    machine = new StateMachine<HaleyState>();
    machine.set(HaleyState.IDLE, new Haley_IdleState(this));
    machine.set(HaleyState.WALKING, new Haley_WalkingState(this));
  }

  private function get_moveSpeed(): Int {
    return moveSpeed;
  }

  private function set_moveSpeed(value: Int) {
    return moveSpeed = value;
  }

  private function get_dashSpeed(): Int {
    return dashSpeed;
  }

  private function set_dashSpeed(value: Int) {
    return dashSpeed = value;
  }

  public function isMoving(): Bool {
    return Input.isPressed(LEFT) || Input.isPressed(RIGHT);
  }
}
