package porcelain.macros;

import haxe.macro.Type;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.TypeTools;

using Lambda;
using StringTools;

class StateMutationMacro {
  #if macro
  public static function build(): Array<Field> {
    var localFields = Context.getBuildFields();
    var cls = Context.getLocalClass();
    var className = cls.get().name;
    var fieldsToCollect = [];

    for (lf in localFields) {
      switch lf.kind {
        case FFun(f):
          if (lf.access.contains(AStatic)) {
            fieldsToCollect.push(lf);
          }
        case _:
      }
    }
    StoreMacro.collectedFields.set(className, fieldsToCollect);
    return null;
  }
  #end
}
