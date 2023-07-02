package geometry.math;

import geometry.math.EquationParser.Token;
import vision.tools.MathTools.*;
class EquationInterpreter {

	public static function solveForVariable(tree:Array<Token>, variable:String, parameters:Map<String, Float>):Float {

		tree = reorderTree(tree);

		// Define the function for the given variable
		var solveFor:(Float) -> Float = function(value:Float):Float {
			parameters.set(variable, value);
			return evaluateExpression(tree, parameters);
		};

		// Define the derivative of the function for the given variable
		var slopeAt:(Float) -> Float = function(value:Float):Float {
			var epsilon:Float = 1e-9;
			var f0:Float = solveFor(value);
			var f1:Float = solveFor(value + epsilon);
			return (f1 - f0) / epsilon;
		};

		// Use the Newton-Raphson method to solve for the variable
		var maxIterations = 100;
		var tolerance = 1e-15;

		// Guess the initial value, go from there
		var variableValue = 1.1;

		for (i in 0...maxIterations) {
			var delta:Float = solveFor(variableValue) / slopeAt(variableValue);
			variableValue -= delta;
			trace('Guess $i: $variableValue');
			if (Math.abs(delta) < tolerance) {
				break;
			}
		}

		return variableValue;
	}

	public static function simplify(exp:String, ?params:Map<String, Float>):Float {
		return evaluateExpression(reorderTree(EquationParser.parse(exp)), if (params == null) [] else params);
	}

	public static function evaluateExpression(tree:Array<Token>, parameters:Map<String, Float>):Float {
		var stack:Array<Float> = [];
		for (token in tree) {
			switch (token) {
				case Function(name, params):
					// Evaluate the function and push the result onto the stack
					var args:Array<Float> = [];
					for (param in params) {
						args.push(evaluateExpression([param], parameters));
					}
					var result:Float = evaluateFunction(name, args);
					stack.push(result);
				case Closure(elements):
					// Evaluate the closure and push the result onto the stack
					var result:Float = evaluateExpression(elements, parameters);
					stack.push(result);
				case Variable(name):
					// Get the value of the variable from the parameters map and push it onto the stack
					var value:Float = parameters.get(name);
					stack.push(value);
				case Number(num):
					// Push the number onto the stack
					stack.push(num);
				case Sign(s):
					// Handle different mathematical operations
					switch (s) {
						case "+":
							var b:Float = stack.pop();
							var a:Float = stack.pop();
							stack.push(a + b);
						case "-":
							var b:Float = stack.pop();
							var a:Float = stack.pop();
							stack.push(a - b);
						case "*":
							var b:Float = stack.pop();
							var a:Float = stack.pop();
							stack.push(a * b);
						case "/":
							var b:Float = stack.pop();
							var a:Float = stack.pop();
							stack.push(a / b);
						case "^":
							var exponent:Float = stack.pop();
							var base:Float = stack.pop();
							stack.push(Math.pow(base, exponent));
					}
			}
		}

		return stack.pop();
	}

	public static function evaluateFunction(name:String, args:Array<Float>):Float {
		switch (name) {
			case "sin":  return sin(args[0]);
			case "sind": return sind(args[0]);
			case "cos":  return cos(args[0]);
			case "cosd": return cosd(args[0]);
			case "tan":  return tan(args[0]);
			case "tand": return tand(args[0]);
			case "cot":  return cotan(args[0]);
			case "cotd": return cotand(args[0]);
			case "sec":  return sec(args[0]);
			case "secd": return secd(args[0]);
			case "csc":  return cosec(args[0]);
			case "cscd": return cosecd(args[0]);
			case "sqrt": return sqrt(args[0]);
			case "abs":  return abs(args[0]);
				// Add more function evaluations as needed
		}

		// Default case: unsupported function
		trace("Unsupported function: " + name);
		return 0.0;
	}

	/**
		Shifts everything onto one side

		And

		Turns
		```
		Closure
  ├─── <operand>
  ├─── <sign>
  └─── <operand>
		```
		into:
		```
		Closure
  ├─── <operand>
  ├─── <operand>
  └─── <sign>
		```
	**/
	public static function reorderTree(tree:Array<Token>):Array<Token> {
		
		var pos = 0;
		for (token in tree) {
			if (token.equals(Sign("="))) break;
			pos++;
		}

		if (pos != tree.length) tree = tree.slice(0, pos).concat([Sign("-")]).concat(tree.slice(pos + 1));
		trace(EquationParser.prettyPrint(tree));
		return reorder(tree);
	}


	public static function reorder(pre:Array<Token>):Array<Token> {
		var post:Array<Token> = [];



		var i = 0;
		while (i < pre.length) {
			var token = pre[i];
			switch token {
				case Closure(elements): {
					if (elements.length == 3 && elements[1].getName() == "Sign") {
						post.push(Closure([
							if (elements[0].getName() == "Closure") Closure(reorder(elements[0].getParameters()[0])) else elements[0],
							if (elements[2].getName() == "Closure") Closure(reorder(elements[2].getParameters()[0])) else elements[2], 
							elements[1]]));
					}
					else post.push(Closure(reorder(elements)));
				}
				case Function(name, params): post.push(Function(name, reorder(params)));
				case _: post.push(token);
			}
			i++;
		}

		if (post.length == 3 && post[1].getName() == "Sign") {
			post = [post[0], post[2], post[1]];
		}

		return post;
	}
}