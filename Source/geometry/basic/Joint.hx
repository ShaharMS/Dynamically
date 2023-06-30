package geometry.basic;

import openfl.display.Sprite;
import vision.ds.Color;

class Joint extends DraggableSprite implements IDrawable {
    
    public static var all:Array<Joint> = [];

    public var id:String = "";

    public var connections:Array<Connection> = [];

    public var outlineColor(default, set):Color = Color.JET_BLACK;
    public var fillColor(default, set):Color = Color.WHITE;

    function set_outlineColor(c:Color) {outlineColor = c; redraw(); return outlineColor;}
    function set_fillColor(c:Color) {outlineColor = c; redraw(); return fillColor;}

    public function new(x:Float, y:Float, letter:String) {

        super();
        this.x = x;
        this.y = y;
        id = letter;

        mouseEnabled = true;
        mouseChildren = true;

        onMoved[0] = (_, _, _, _) -> {
            for (c in connections) {
                c.redraw();
            }
        }
        onDragged[0] = (_, _, _, _) -> {
			for (c in connections) {
				c.reposition();
			}
        }

        redraw();

        all.push(this);
    }

    public function redraw() {
		graphics.clear();
		graphics.lineStyle(2, outlineColor);
		graphics.beginFill(fillColor);
		graphics.drawCircle(0, 0, 7);
		graphics.endFill();
    }

    public function reposition() {
        
    }

    public function connect(joint:Joint, ?connectionText:String):Joint {
		var connection = new Connection(this, joint, connectionText);
        connections.push(connection);
		joint.connections.push(connection);
        return this;
    }

    public function disconnect(joint:Joint):Joint {
        for (c in this.connections) {
            if (c.joint1 == this && c.joint2 == joint || c.joint1 == joint && c.joint2 == this) this.connections.remove(c);
        }

        for (c in joint.connections) {
            if (c.joint1 == this && c.joint2 == joint || c.joint1 == joint && c.joint2 == this) joint.connections.remove(c);
        }
        return this;
    }
}