package geometry;

import geometry.basic.EllipseBase;
import openfl.Lib;
import openfl.display.Stage;
import geometry.basic.Connection;
import geometry.basic.Joint;
import openfl.text.TextFormat;
import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.display.Graphics;
import vision.ds.Color;
import vision.ds.Point2D;
import openfl.display.Shape as FLShape;

class Drawer {

    public static function draw() {

        var conns:Map<String, Connection> = [];
        for (j in Joint.all) {
            for (c in j.connections) {
                if (conns.exists(c.from.id + c.to.id) || conns.exists(c.to.id + c.from.id)) continue;
				conns[c.from.id + c.to.id] = c;
            }
        }

		for (k => v in conns) {
			var g = v.graphics;
			g.lineStyle(2, Color.JET_BLACK);
			g.moveTo(v.from.x, v.from.y);
			g.lineTo(v.to.x, v.to.y);

			Lib.current.addChild(v);
		}

        for (e in EllipseBase.all) {
            Lib.current.addChild(e.ringGraphic);
        }

        for (j in Joint.all) {
			var g = j.graphics;
			g.lineStyle(2, Color.JET_BLACK);
			g.beginFill(Color.WHITE);
			g.drawCircle(0, 0, 7);
			g.endFill();
            
            Lib.current.addChild(j);
        }

        
    }
}