package porcelain.macros;

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
    var getClsType = (name: String) -> {
      return switch Context.getType(name) {
        case TInst(t, params): t.get();
        case _: null;
      }
    }
    switch kind {
      case FVar(t, e):
        switch t {
          case TPath(p):
            cls = getClsType(p.name);
          case _:
            if (e != null) {
              switch e.expr {
                case ENew(t, params):
                  cls = getClsType(t.name);
                case _:
              }
            }
        }

      case _:
    }
    return cls;
  }

  public static function isExprTrue(expr: Expr): Bool {
    return switch expr.expr {
      case EConst(CIdent(s)):
        return s == 'true';
      case _:
        false;
    }
  }

  public static function extractStringFromExpr(expr: Expr): String {
    return switch expr.expr {
      case EConst(CString(s, kind)):
        s;
      case _:
        null;
    }
  }

  public static function extractArgsFromObjectArrayExpr(expr: Expr): Array<FunctionArg> {
    return switch expr.expr {
      case EArrayDecl(values):
        var exValues = [];
        for (value in values) {
          switch value.expr {
            case EObjectDecl(fields):
              var t = fields.list();
              var typeField = t.find(i -> i.field == 'typeName');
              var nameField = t.find(i -> i.field == 'name');
              var optField = t.find(i -> i.field == 'opt');
              var isArray = isExprTrue(t.find(i -> i.field == 'isArray').expr);
              var arrType = null;

              if (isArray) {
                var arrTypeField = t.find(i -> i.field == 'arrayType');
                var arrTypeName = extractStringFromExpr(arrTypeField.expr);
                var arrParamType = Context.toComplexType(Context.getType(arrTypeName));
                arrType = TPath({
                  name: 'Array',
                  pack: [],
                  params: [TPType(arrParamType)]
                });
              }
              var typeName = extractStringFromExpr(typeField.expr);
              var type = Context.toComplexType(Context.getType(typeName));
              exValues.push({
                type: isArray ? arrType : type,
                opt: isExprTrue(optField.expr),
                name: extractStringFromExpr(nameField.expr)
              });
            case _:
          }
        }
        exValues;
      case _:
        null;
    }
  }

  public static function createStaticMethods(mutationFields: Array<Field>): Array<Field> {
    var funcsToCopy: Array<Field> = [];

    for (field in mutationFields) {
      var cls = getClassFromKind(field.kind);
      var clsFields = cls.statics.get();
      for (field in clsFields) {
        var fieldMeta = field.meta.get();
        for (meta in fieldMeta) {
          if (meta.name == 'tempFieldData') {
            var metaParams = meta.params;
            var fieldName = extractStringFromExpr(metaParams[0]);
            var fieldArgs = extractArgsFromObjectArrayExpr(metaParams[1]);
            var func = createFunction(cls.name, fieldName, fieldArgs);
            var newMethod: Field = {
              name: fieldName,
              kind: FieldType.FFun(func),
              access: [Access.APublic, Access.AStatic],
              pos: Context.currentPos()
            };
            funcsToCopy.push(newMethod);
          }
        }
      }
    }
    return funcsToCopy;
  }
  #end
}
