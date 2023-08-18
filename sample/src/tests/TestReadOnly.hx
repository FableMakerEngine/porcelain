package tests;

import porcelain.ReadOnly;
import tracker.Observable;

class ReadOnlyObservers implements Observable implements ReadOnly {
  @observe public var myString: String = 'string';
  @observe public var myInt: Int = 1;

  public var myPublicString: String;

  public function new() {}
}

class TestReadOnly {
  var observers: ReadOnlyObservers;

  public function new() {
    observers = new ReadOnlyObservers();

    // Uncomment the following and the property should not be writable
    // observers.myString = 'a new string';
    // observers.myInt = 1;
  }
}
