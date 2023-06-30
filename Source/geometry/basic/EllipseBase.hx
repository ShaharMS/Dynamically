package geometry.basic;

import vision.ds.Point2D;
import vision.ds.Color;
import openfl.display.Sprite;

class EllipseBase extends Sprite implements IDrawable {

    public static var all:Array<EllipseBase> = [];

	public var onOutlineJoints:Array<Joint> = [];

	public var focal1:Joint;
	public var focal2:Joint;

	public var distanceSum(default, set):Float;
	function set_distanceSum(d:Float) {distanceSum = d; redraw(); return distanceSum;}

	public var ringGraphic:DraggableSprite = new DraggableSprite();

	public function new(f1:Joint, f2:Joint, radius:Float) {
		super();

		focal1 = f1;
		focal2 = f2;

		distanceSum = radius;

        all.push(this);

		focal1.onMoved.push((_, _, _, _) -> {redraw();});
		focal2.onMoved.push((_, _, _, _) -> {redraw();});
		focal1.onDragged.push((_, _, _, _) -> {reposition();});
		focal2.onDragged.push((_, _, _, _) -> {reposition();});


		ringGraphic.onMoved.push((x, y, mx, my) -> {
			ringGraphic.x = 0;
			ringGraphic.y = 0;
			distanceSum = new Point2D(focal1.x, focal1.y).distanceTo(new Point2D(mx, my)) + new Point2D(focal2.x, focal2.y).distanceTo(new Point2D(mx, my));
		});

		addChild(ringGraphic);
		redraw();
	}

	public function redraw() {
		trace("draw ring");
		ringGraphic.graphics.clear();
		var info = convertFocalsToEllipse(focal1.x, focal1.y, focal2.x, focal2.y);
		ringGraphic.graphics.lineStyle(2, Color.JET_BLACK);
		ringGraphic.graphics.drawEllipse(info.x, info.y, info.width, info.height);
		graphics.lineStyle(10, 0x000000, 0.01);
		ringGraphic.graphics.drawEllipse(info.x, info.y, info.width, info.height);


	}

	public function reposition() {}

	function convertFocalsToEllipse(focus1X:Float, focus1Y:Float, focus2X:Float, focus2Y:Float):{width:Float, height:Float, x:Float, y:Float} {
		var distance:Float = Math.sqrt(Math.pow(focus2X - focus1X, 2) + Math.pow(focus2Y - focus1Y, 2));
		var semiMajorAxis:Float = distanceSum / 2;
		var semiMinorAxis:Float = Math.sqrt(Math.pow(semiMajorAxis, 2) - Math.pow(distance / 2, 2));

		var width:Float = 2 * semiMajorAxis;
		var height:Float = 2 * semiMinorAxis;
		var x = (focus1X + focus2X) / 2 - width / 2;
		var y = (focus1Y + focus2Y) / 2 - height / 2;
		return {width: width, height: height, x: x, y: y};
	}
}
