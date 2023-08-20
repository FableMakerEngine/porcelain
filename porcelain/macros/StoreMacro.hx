package porcelain.macros;

import haxe.macro.Type;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.TypeTools;

using Lambda;
using StringTools;

typedef ClassFieldsPair = {
  className: Dynamic,
  fields: Array<ClassField>
}

class StoreMacro {
  macro public static function build(): Array<Field> {
    var localFields = Context.getBuildFields();
    var mutationFields = getFieldsWithMeta(localFields, 'mutation');

    if (mutationFields != null) {
      var commitMethodFields = createStaticMethods(mutationFields);
      for (field in commitMethodFields) {
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

  public static function createFunction(className: String, methodName: String, args: Dynamic): Function {
    var argExprs = args.map(arg -> macro $i{arg.name});
    var funcArgs = args.map(arg -> {
      var funcArg: FunctionArg = {
        name: arg.name,
        opt: arg.opt,
        type: TypeTools.toComplexType(arg.t),
      }
      return funcArg;
    });

    return {
      args: funcArgs,
      expr: macro return Reflect.callMethod($i{className}, Reflect.field($i{className}, $v{methodName}), $a{argExprs})
    }
  }

  public static function getClassFieldsFromKind(kind): Array<ClassFieldsPair> {
    var fields: Array<ClassFieldsPair> = [];

    switch kind {
      case FVar(TPath(p), e):
        switch Context.getType(p.name) {
          case TInst(t, params):
            var type = t.get();
            var tFields = type.fields.get();
            var tStatics = type.statics.get();

            fields.push({
              className: p.name,
              fields: tFields.concat(tStatics)
            });
          case _:
        }
      case _:
    }
    return fields;
  }

  public static function createStaticMethods(mutationFields: Array<Field>): Array<Field> {
    var funcsToCopy: Array<Field> = [];

    for (field in mutationFields) {
      var typeFieldPairs = getClassFieldsFromKind(field.kind);
      for (pair in typeFieldPairs) {
        for (tField in pair.fields) {
          switch TypeTools.follow(tField.type) {
            case TFun(args, ret):
              var name = tField.name;
              var func = createFunction(pair.className, name, args);
              var newMethod: Field = {
                name: name,
                kind: FieldType.FFun(func),
                access: [Access.APublic, Access.AStatic],
                pos: Context.currentPos(),
                doc: tField.doc
              };
              funcsToCopy.push(newMethod);
            case _:
          }
        }
      }
    }
    return funcsToCopy;
  }
  #end
}
