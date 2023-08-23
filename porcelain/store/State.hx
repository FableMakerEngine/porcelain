package porcelain.store;

#if ceramic
import tracker.Observable;
#end

class State implements ReadOnly #if ceramic implements Observable #end {
  public function new() {}
}
