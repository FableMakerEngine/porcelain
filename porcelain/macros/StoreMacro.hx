package porcelain.macros;

import haxe.macro.ExprTools;
import haxe.macro.Type;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.TypeTools;

using Lambda;
using StringTools;

class StoreMacro {
  public static var collectedFields: Map<String, Array<Field>> = [];

  macro public static function build(): Array<Field> {
    var localFields = Context.getBuildFields();
    var mutationFields = getFieldsWithMeta(localFields, 'mutation');

    localFields.push({
      name: 'status',
      access: [Access.APublic, Access.AStatic],
      kind: FProp('default', 'null', macro : String),
      pos: Context.currentPos()
    });

    if (mutationFields != null) {
      var newMethodFields = createStaticMethods(mutationFields);
      for (field in newMethodFields) {
        if (localFields.exists(f -> f.name == field.name)) {
          trace('A field with the name ${field.name} already exists, skipping');
          continue;
        }
        localFields.push(field);
      }
    }

    return localFields;
  }

  #if macro
  static function getFieldsWithMeta(fields: Array<Field>, metaName: String): Array<Field> {
    return fields.filter(i -> i.meta.exists(m -> m.name == metaName));
  }

  public static function createFunction(className: String, methodName: String, args: Array<FunctionArg>): Function {
    var argExprs = args.map(arg -> macro $i{arg.name});

    return {
      args: args,
      ret: null,
      expr: macro $b{
        [
          macro status = 'mutation',
          macro Reflect.callMethod($i{className}, Reflect.field($i{className}, $v{methodName}), $a{argExprs}),
          macro status = 'resting'
        ]
      }
    }
  }

  public static function getClassFromKind(kind): ClassType {
    var cls;
    switch kind {
      case FVar(t, e):
        switch t {
          case TPath(p):
            cls = TypeTools.getClass(Context.getType(p.name));
          case _:
            if (e != null) {
              switch e.expr {
                case ENew(t, params):
                  cls = TypeTools.getClass(Context.getType(t.name));
                case _:
              }
            }
        }

      case _:
    }
    return cls;
  }

  public static function createStaticMethods(mutationFields: Array<Field>): Array<Field> {
    var newMethods: Array<Field> = [];
    var classesHandled: Map<String, Bool> = [];

    for (field in mutationFields) {
      var cls = getClassFromKind(field.kind);
      if (classesHandled.exists(cls.name)) {
        Context.error('Cannot have more than one mutation class of the same type "${cls.name}"', field.pos);
      }
      classesHandled.set(cls.name, true);
      var clsFields = collectedFields.get(cls.name);
      for (field in clsFields) {
        // @TODO  do we want to reuse the same function or create custom which uses Reflect?
        var fieldFunc = field.kind;
        var newMethod: Field = {
          name: field.name,
          kind: field.kind,
          access: [Access.APublic, Access.AStatic],
          pos: Context.currentPos()
        };
        newMethods.push(newMethod);
      }
    }
    return newMethods;
  }
  #end
}
