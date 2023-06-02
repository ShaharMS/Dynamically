package geometry;

import openfl.text.TextFormat;
import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.display.Graphics;
import vision.ds.Color;
import vision.ds.Point2D;
import geometry.basic.Shape;
import openfl.display.Shape as FLShape;

class Drawer {

    public static function drawShape(shape:Shape) {
        var sp = new Sprite();
        var s = new FLShape();
        var g = s.graphics;
        g.lineStyle(2, Color.JET_BLACK);
        var arr:Array<Point2D> = [];
        var ks = [for (x in shape.points.keys()) x];
        ks.sort((a, b) -> a.charCodeAt(0) - b.charCodeAt(0));
        var first = true;
        for (k in ks) {
            var p = shape.points[k];
            if (first) {
                g.moveTo(p.x, p.y);
                first = false;
            } else {
                g.lineTo(p.x, p.y);
            }
        }
        g.lineTo(shape.points[ks[0]].x, shape.points[ks[0]].y);

		for (k in ks) {
			var p = shape.points[k];
			g.lineStyle(2, Color.JET_BLACK);
			g.beginFill(Color.WHITE);
			g.drawCircle(p.x, p.y, 7);
			g.endFill();
        }

		for (k in ks) {
			var p = shape.points[k];
			addText(sp, k, p);
		}

        sp.addChild(s);
        return sp;
    }


    public static function addText(sp:Sprite, s:String, p:Point2D) {
        var tf = new TextField();
        tf.defaultTextFormat = new TextFormat(null, 20);
        tf.text = s;
		var isAfterMidX = p.x > sp.width / 2 ? 0.5 : -1.5, isAfterMidY = p.y > sp.height / 2 ? 0 : -1;
        tf.x = p.x + tf.textWidth * isAfterMidX;
        tf.y = p.y + tf.textHeight * isAfterMidY;
        sp.addChild(tf);
    }
}