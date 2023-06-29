package;

import geometry.basic.EllipseBase;
import geometry.basic.Joint;
import vision.ds.Point2D;
import geometry.Drawer;
import openfl.Lib;
import openfl.events.KeyboardEvent;
import openfl.events.Event;
import openfl.text.TextField;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();
		var j = new Joint(30, 30, "A").connect(new Joint(130, 30, "B")).connect(new Joint(120, 60, "C"));
		var c = new EllipseBase(new Joint(250, 250, "D"), new Joint(350, 250, "E"), 150);
		var c2 = new EllipseBase(new Joint(400, 400, "F"), new Joint(400, 400, "F"), 100);
		Drawer.draw();
	}
}
