package geometry.math;

using texter.general.TextTools;
using vision.tools.MathTools;
using StringTools;

class EquationInterpreter {
	public static var signs:Array<String> = ['+', '-', '*', '/', '%', '^'];

	public static function lex(code:String):Array<Token> {
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
				var sign = char;
				i++;
				while (i < code.length && signs.contains(code.charAt(i))) {
					sign += code.charAt(i);
					i++;
				}
				i--;
				tokens.push(Sign(sign));
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
						if (i + 1 == pre.length) {
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
					i++;
			}
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
				case Closure(elements):
					post.push(Closure(mergeOperations(elements)));
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
				case Closure(elements):
					post.push(Closure(mergeOperations(elements)));
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
				case Closure(elements):
					post.push(Closure(mergeOperations(elements)));
				case Function(name, params):
					post.push(Function(name, mergeOperations(params)));
				case _:
					post.push(token);
			}
			i++;
		}

		return post;
	}
}

enum Token {
	Function(name:String, params:Array<Token>);
	Closure(elements:Array<Token>);
	Variable(name:String);
	Number(num:Float);
	Sign(s:String);
}
