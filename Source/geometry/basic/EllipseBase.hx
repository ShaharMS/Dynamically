package geometry.basic;

import vision.ds.Point2D;
import vision.ds.Color;
import openfl.display.Sprite;

class EllipseBase extends Sprite {

    public static var all:Array<EllipseBase> = [];

	public var onOutlineJoints:Array<Joint> = [];

	public var focal1:Joint;
	public var focal2:Joint;

	public var radius:Float;

	public function new(f1:Joint, f2:Joint, radius:Float) {
		super();

		focal1 = f1;
		focal2 = f2;

		this.radius = radius;

        all.push(this);

        ringGraphic = new Sprite();
        var info = convertFocalsToEllipse(focal1.x, focal1.y, focal2.x, focal2.y, radius);
        trace(info);
		ringGraphic.graphics.lineStyle(2, Color.JET_BLACK);
        ringGraphic.graphics.drawEllipse(info.x, info.y, info.width, info.height);
	}

	public var ringGraphic:Sprite;


	function convertFocalsToEllipse(focus1X:Float, focus1Y:Float, focus2X:Float, focus2Y:Float, distanceSum:Float):{width:Float, height:Float, x:Float, y:Float} {
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
