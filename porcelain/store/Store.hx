package porcelain.store;

import tracker.Observable;
import ceramic.Entity;
import ceramic.PersistentData;

class Store extends Entity implements Observable {
  public static final store: Store = new Store();

  public var state: State;

  private var status: String = 'resting';

  private function new() {
    super();
  }
}
