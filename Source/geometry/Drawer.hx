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
                if (conns.exists(c.joint1.id + c.joint2.id) || conns.exists(c.joint2.id + c.joint1.id)) continue;
				conns[c.joint1.id + c.joint2.id] = c;
            }
        }

		for (k => v in conns) {
			Lib.current.addChild(v);
		}

        for (e in EllipseBase.all) {
            Lib.current.addChild(e.ringGraphic);
        }

        for (j in Joint.all) {
            Lib.current.addChild(j);
        }

        
    }
}