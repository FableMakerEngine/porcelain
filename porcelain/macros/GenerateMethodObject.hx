package porcelain.macros;

import haxe.macro.Type;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.TypeTools;

using Lambda;
using StringTools;

/**
 * Adds method names from a class and returns an object with those method names.
 * 
 * This allows you to call the methods with full type support which is useful
 * for store patterns.
 * 
 * `store.commit().mutationMethodName(arg, arg2);`
 * 
 * instead of something like this which is common in JS store patterns
 * 
 * `store.commit('mutationMethodName', [arg, arg2])`
 * 
 */
class GenerateMethodObject {
  static inline function getFunctionArgs(type) {
    var fieldArgs = [];

    switch type {
      case TFun(args, ret):
        for (arg in args) {
          fieldArgs.push({
            name: arg.name,
            opt: arg.opt,
            type: TypeTools.toComplexType(arg.t)
          });
        }
      case _:
    }

    return fieldArgs;
  }

  static inline function isFunctionType(type) {
    switch type {
      case TFun(args, ret):
        return true;
      case _:
        return false;
    }
  }

  macro public static function apply(classRef, extraRefs: Array<Expr>): Expr {
    var block: Array<Expr> = [];
    var classRefTypes = [{ ref: classRef, type: Context.typeof(classRef) }];
    var funcExprs = [];

    if (extraRefs.count() > 0) {
      for (ref in extraRefs)
        classRefTypes.push({
          type: Context.typeof(ref),
          ref: ref
        });
    }

    var allMethods = new Map<String, ObjectField>();
    var localMutations = new Map<String, ObjectField>();

    for (refType in classRefTypes) {
      var classRef = refType.ref;

      switch refType.type {
        case TType(t, _):
          var classType = t.get().type;

          switch classType {
            case TAnonymous(a):
              var fields: Array<ClassField> = a.get().fields;

              for (field in fields) {
                var type = field.type;

                if (isFunctionType(type)) {
                  var name = field.name;
                  var args = getFunctionArgs(type);
                  var nameIdent = macro $v{name};

                  switch args.length {
                    case 1:
                      var argName = args[0].name;
                      var argType = args[0].type;

                      funcExprs.push({
                        name: name,
                        expr: macro function($argName: $argType) {
                          return Reflect.callMethod(${classRef}, Reflect.field(${classRef}, $nameIdent), [$i{argName}]);
                        }
                      });

                    case 2:
                      var argName = args[0].name;
                      var argType = args[0].type;
                      var argName2 = args[1].name;
                      var argType2 = args[1].type;
                      var reflectArgs = [macro $i{argName}, macro $i{argName2}];

                      funcExprs.push({
                        name: name,
                        expr: macro function($argName: $argType, $argName2: $argType2) {
                          return return
                            Reflect.callMethod(${classRef}, Reflect.field(${classRef}, $nameIdent), $a{reflectArgs});
                        }
                      });

                    case 3:
                      var argName = args[0].name;
                      var argType = args[0].type;
                      var argName2 = args[1].name;
                      var argType2 = args[1].type;
                      var argName3 = args[2].name;
                      var argType3 = args[2].type;
                      var reflectArgs = [macro $i{argName}, macro $i{argName2}, macro $i{argName3}];

                      funcExprs.push({
                        name: name,
                        expr: macro function($argName: $argType, $argName2: $argType2, $argName3: $argType3) {
                          return
                            Reflect.callMethod(${classRef}, Reflect.field(${classRef}, $nameIdent), $a{reflectArgs});
                        }
                      });

                    default:
                      trace('Does not support functions with more than 3 arguments');
                  }
                }
              }

              for (funcExpr in funcExprs) {
                if (allMethods.exists(funcExpr.name)) {
                  trace('${funcExpr.name} already exists, overwriting with new one from $classRef');
                }
                allMethods.set(funcExpr.name, {
                  field: funcExpr.name,
                  expr: funcExpr.expr
                });
              }

              if (allMethods.count() <= 0) {
                trace('No methods in $classRef to add');
              }

            case _:
              trace('Only supports Anonymous types');
          }
        case _:
      }
    }

    var mutations = { expr: EObjectDecl(allMethods.array()), pos: Context.currentPos() };

    block.push(macro var mutationMethods = $mutations);
    block.push(macro return mutationMethods);

    return macro $b{block};
  }
}
