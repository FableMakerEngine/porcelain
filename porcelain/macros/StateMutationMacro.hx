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

    for (lf in localFields) {
      switch lf.kind {
        case FFun(f):
          if (lf.access.contains(AStatic)) {
            var name = lf.name;
            var args: Array<FunctionArg> = f.args;
            var argsForMeta = [];

            for (arg in args) {
              switch arg.type {
                case TPath(s):
                  var arrayTypeName = null;
                  if (s.name == 'Array') {
                    var argType = s.params[0];
                    switch argType {
                      case TPType(TPath(p)):
                        arrayTypeName = p.name;
                      case _:
                    }
                  }
                  argsForMeta.push({
                    name: arg.name,
                    opt: arg.opt,
                    typeName: s.name,
                    isArray: arrayTypeName != null,
                    arrayType: arrayTypeName
                  });
                case _:
              }
            }

            // var type
            lf.meta.push({
              name: 'tempFieldData',
              params: [macro $v{name}, macro $v{argsForMeta}],
              pos: lf.pos
            });
          }
        case _:
      }
    }

    return localFields;
  }
  #end
}
