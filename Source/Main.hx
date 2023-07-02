package;

import geometry.math.externs.Solver;
import geometry.math.EquationInterpreter;
import js.Syntax;
import js.html.XMLHttpRequest;
import js.Browser;
import geometry.shapes.Triangle;
import geometry.basic.EllipseBase;
import geometry.basic.Joint;
import vision.ds.Point2D;
import geometry.Drawer;
import openfl.Lib;
import openfl.events.KeyboardEvent;
import openfl.events.Event;
import openfl.text.TextField;
import openfl.display.Sprite;

using StringTools;

class Main extends Sprite
{
	public function new()
	{
		super();

		#if js

		var script = Browser.document.createScriptElement();
		script.src = './nerdamer.min.js';
		script.async = false;
		Browser.document.head.appendChild(script);

		script.onload = function () {
			var arr = geometry.math.externs.Solver.solve("x^2 = 5*x*sin(pi/6)", "x");
			var arr2 = arr.toString().replace("[", "").replace("]", "").split(",").map(s -> EquationInterpreter.simplify(s));
			trace(arr2);
			trace(Solver.solveEquations(["x = y + 4", "y = z - 6", "z = x + y"]).toString());
			Syntax.code("console.log(Object.getOwnPropertyNames({0}))", arr);
			//var ta = [for (s in arr) s.toString()];
			//trace(ta);
			//trace([for (s in ta) EquationInterpreter.simplify(s)]);

			Browser.document.addEventListener("contextmenu", function(event) {
				event.preventDefault(); // Prevent the default context menu
			});
			var j = new Joint(30, 30, "A").connect(new Joint(130, 30, "B")).connect(new Joint(120, 60, "C"));
			var c = new EllipseBase(new Joint(250, 250, "D"), new Joint(350, 250, "E"), 150);
			var c2 = new EllipseBase(new Joint(400, 400, "F"), new Joint(400, 400, "F"), 100);
			var t = new Triangle(new Joint(20, 80, "G"), new Joint(50, 85, "H"), new Joint(60, 120, "I"));
			Drawer.draw();
		}
		#end

	}
}
