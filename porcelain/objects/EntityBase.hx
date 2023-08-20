package porcelain.objects;

import objects.player.enums.HaleyState;
import ceramic.StateMachine;
import ceramic.Sprite;

enum STATELESS {}

/**
 * The abstract class that shape an entity.
 * It contains an state machine as well support for multiple animations.
 * Entities all need an Enum to shape the entity state machine.
 * ```haxe
 * enum MyEntityState {
 *  IDLE;
 *  WALKING;
 *  // etc...
 * }
 *  
 * class TestEntity extends EntityBase<MyEntityState> {
 *  public function new() {
 *   super();
 * }
 * ```
 */
abstract class EntityBase<T> extends Sprite {
  /**
   * the entity name that is used to fetch them.
   */
  public var name: String;

  /**
   * the entity state machine
   */
  @:isVar public var machine(get, set): StateMachine<T>;

  public function new(entityName: String) {
    super();
    name = entityName;
    machine = new StateMachine<T>();
    setupStateMachine();
  }

  /**
   * return the current entity state
   * @return T
   */
  public function currentState(): T {
    return machine.state;
  }

  /**
   * Switch the entity state to its next one
   * @param nextState 
   */
  public function switchState(nextState: T) {
    machine.state = nextState;
  }

  /**
   * setup the state machine state. In some case it is not necessary if you are 
   * using the one 
   */
  private abstract function setupStateMachine(): Void;

  private function get_machine() {
    return machine;
  }

  private function set_machine(value) {
    return machine = value;
  }
}

class EntityTest extends EntityBase<HaleyState> {
  public function new(entityName: String) {
    super(entityName);
  }

  function setupStateMachine() {}
}
