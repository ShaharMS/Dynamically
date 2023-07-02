package geometry.math;

using texter.general.TextTools;
using vision.tools.MathTools;
using StringTools;

class EquationParser {
	public static var signs:Array<String> = ['+', '-', '*', '/', '%', '^', "(", ")", "="];

	public static function parse(code:String):Array<Token> {
		var tokens:Array<Token> = [];

		var i = 0;
		while (i < code.length) {
			var char = code.charAt(i);

			if ("1234567890.".contains(char)) {
				var num = char;
				i++;
				while (i < code.length && "1234567890.".contains(code.charAt(i))) {
					num += code.charAt(i);
					i++;
				}
				i--;
				if (num == ".")
					tokens.push(Sign("."))
				else if (num.endsWith(".")) {
					tokens.push(Number(num.replaceLast(".", "").parseFloat()));
					tokens.push(Sign("."));
				} else
					tokens.push(Number(num.parseFloat()));
			} else if (signs.contains(char)) {
				tokens.push(Sign(char));
			} else if (~/[^+-.!@#$%%^&*0-9 \t\n\r;,\(\)\[\]\{\}]/.match(char)) {
				var name = char;
				i++;
				while (i < code.length && ~/[^+-.!@#$%%^&*0-9 \t\n\r;,\(\)\[\]\{\}]/.match(code.charAt(i))) {
					name += code.charAt(i);
					i++;
				}
				i--;
				tokens.push(Variable(name));
			}
			i++;
		}

		tokens = mergeClosures(tokens);
		tokens = mergeFunctions(tokens);
		tokens = mergeOperations(tokens);

		return tokens;
	}

	public static function mergeClosures(pre:Array<Token>):Array<Token> {
		if (pre == null)
			return null;
		if (pre.length == 1 && pre[0] == null)
			return [null];

		var post:Array<Token> = [];

		var i = 0;
		while (i < pre.length) {
			var token = pre[i];
			switch token {
				case Sign("("):
					{
						var expressionBody:Array<Token> = [];
						var expressionStack = 1; // Open and close the block on the correct curly bracket
						while (i + 1 < pre.length) {
							var lookahead = pre[i + 1];
							if (Type.enumEq(lookahead, Sign("("))) {
								expressionStack++;
								expressionBody.push(lookahead);
							} else if (Type.enumEq(lookahead, Sign(")"))) {
								expressionStack--;
								if (expressionStack == 0)
									break;
								expressionBody.push(lookahead);
							} else
								expressionBody.push(lookahead);
							i++;
						}
						// Throw error for unclosed expressions;
						if (i == pre.length) {
							throw 'Equation contains unclosed parentheses';
						}
						post.push(Closure(mergeClosures(expressionBody))); // The check performed above includes unmerged closures inside the outer parentheses. These unmerged closures should be merged
						i++;
					}

				case Closure(parts):
					post.push(Closure(mergeClosures(parts)));
				case _:
					post.push(token);
			}
			i++;
		}

		return post;
	}

	public static function mergeFunctions(pre:Array<Token>):Array<Token> {
		if (pre == null)
			return null;
		if (pre.length == 1 && pre[0] == null)
			return [null];

		var post:Array<Token> = [];

		var i = 0;
		while (i < pre.length) {
			var token = pre[i];
			switch token {
				case Variable(name):
					{
						if (i + 1 >= pre.length)
							post.push(token);
						else if (pre[i + 1].getName() == "Closure") {
							post.push(Function(name, pre[i + 1].getParameters()[0]));
							i++;
						} else
							post.push(token);
					}
				case _:
					post.push(token);
			}
			i++;
		}

		return post;
	}

	public static function mergeOperations(pre:Array<Token>):Array<Token> {
		if (pre == null)
			return null;
		if (pre.length == 1 && pre[0] == null)
			return [null];

		var post:Array<Token> = [];

		// E
		// M/D
		// A/S

		var i = 0;
		while (i < pre.length) {
			var token = pre[i];
			switch token {
				case Sign(s):
					{
						if (i + 1 >= pre.length)
							throw "Operator at the end of equation/parentheses";
						if (s == "^") {
							var lhs = post.pop();
							var rhs = pre[i + 1];
							post.push(Closure([lhs, token, rhs]));
							i++;
						} else
							post.push(token);
					}
				case Closure(elements): {
                    if (elements.length == 3 || elements.length == 1) post.push(token);
					else post.push(Closure(mergeOperations(elements)));
                }
				case Function(name, params):
					post.push(Function(name, mergeOperations(params)));
				case _:
					post.push(token);
			}
			i++;
		}

		pre = post.copy();
		post = [];

		var i = 0;
		while (i < pre.length) {
			var token = pre[i];
			switch token {
				case Sign(s):
					{
						if (i + 1 >= pre.length)
							throw "Operator at the end of equation/parentheses";
						if (s == "*" || s == "/") {
							var lhs = post.pop();
							var rhs = pre[i + 1];
							post.push(Closure([lhs, token, rhs]));
							i++;
						} else
							post.push(token);
					}
				case Closure(elements): {
                    if (elements.length == 3 || elements.length == 1) post.push(token);
					else post.push(Closure(mergeOperations(elements)));
                }
				case Function(name, params):
					post.push(Function(name, mergeOperations(params)));
				case _:
					post.push(token);
			}
			i++;
		}

		pre = post.copy();
		post = [];

		var i = 0;
		while (i < pre.length) {
			var token = pre[i];
			switch token {
				case Sign(s):
					{
						if (i + 1 >= pre.length)
							throw "Operator at the end of equation/parentheses";
						if (s == "+" || s == "-") {
							var lhs = post.pop();
							var rhs = pre[i + 1];
							post.push(Closure([lhs, token, rhs]));
							i++;
						} else
							post.push(token);
					}
				case Closure(elements): {
                    if (elements.length == 3 || elements.length == 1) post.push(token);
					else post.push(Closure(mergeOperations(elements)));
                }
				case Function(name, params):
					post.push(Function(name, mergeOperations(params)));
				case _:
					post.push(token);
			}
			i++;
		}

		return post;
	}







    public static function prettyPrint(ast:Array<Token>, ?spacingBetweenNodes:Int = 6) {
		if (ast == null) return "null (look for errors in input)";
		s = " ".multiply(spacingBetweenNodes);
		var unfilteredResult = getTree(Closure(ast), [], 0, true);
		var filtered = "";
		for (line in unfilteredResult.split("\n")) {
			if (line == "└─── Closure")
				continue;
			filtered += line.substring(spacingBetweenNodes - 1) + "\n";
		}
		return "\nEquation\n" + filtered;
	}

	static function prefixFA(pArray:Array<Int>) {
		var prefix = "";
		for (i in 0...l) {
			if (pArray[i] == 1) {
				prefix += "│" + s.substring(1);
			} else {
				prefix += s;
			}
		}
		return prefix;
	}

	static function pushIndex(pArray:Array<Int>, i:Int) {
		var arr = pArray.copy();
		arr[i + 1] = 1;
		return arr;
	}

	static var s = "";
	static var l = 0;

	static function getTree(root:Token, prefix:Array<Int>, level:Int, last:Bool):String {
		l = level;
		var t = if (last) "└" else "├";
		var c = "├";
		var d = "───";
		if (root == null)
			return ''; //'${prefixFA(prefix)}$t$d SetLine($line)\n'
		switch root {
            case Number(num): return '${prefixFA(prefix)}$t$d $num\n';
			case Variable(name): return '${prefixFA(prefix)}$t$d $name\n';
			case Sign(value): return '${prefixFA(prefix)}$t$d $value\n';
			case Closure(body): {
                if (body.length == 0)
                    return '${prefixFA(prefix)}$t$d <empty closure>\n';
                var strParts = ['${prefixFA(prefix)}$t$d Closure\n'].concat([
                    for (i in 0...body.length - 1) getTree(body[i], pushIndex(prefix, level), level + 1, false)
                ]);
                strParts.push(getTree(body[body.length - 1], prefix.copy(), level + 1, true));
                return strParts.join("");
            }
			case Function(name, params):
			{
				var title = '${prefixFA(prefix)}$t$d Function\n';
				title += getTree(Variable(name), pushIndex(prefix, level), level + 1, false);
				title += getTree(Closure(params), prefix.copy(), level + 1, true);
				return title;
			}
		}
		return "";
	}

}

enum Token {
	Function(name:String, params:Array<Token>);
	Closure(elements:Array<Token>);
	Variable(name:String);
	Number(num:Float);
	Sign(s:String);
}
