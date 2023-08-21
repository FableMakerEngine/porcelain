package objects.player;

import ceramic.Assets;
import ceramic.Color;
import ceramic.Quad;
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

  private var debugSprite: Quad;
  private var assets: Assets;

  public function new(assets: Assets) {
    super();
    this.assets = assets;
    setupStateMachine();
    initMembers();
    createDebugQuad();
  }

  private function createDebugQuad() {
    debugSprite = new Quad();
    debugSprite.anchor(0.5, 0.5);
    debugSprite.texture = assets.texture(Images.IMG__SMOLL);
    // debugSprite.size(100, 100);
    debugSprite.pos(width * 0.5, height * 0.5);
    // debugSprite.color = Color.BLUE;

    add(debugSprite);
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
