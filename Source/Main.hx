package;

import vision.ds.Point2D;
import geometry.basic.Shape;
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
		addChild(Drawer.drawShape(new Shape([
			"A" => new Point2D(50, 50),
			"B" => new Point2D(150, 50),
			"C" => new Point2D(150, 150),
			"D" => new Point2D(50, 150),
		])));
	}
}
