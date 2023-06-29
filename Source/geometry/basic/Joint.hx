package geometry.basic;

import openfl.display.Sprite;

class Joint extends Sprite {
    
    public static var all:Array<Joint> = [];

    public var id:String = "";

    public var connections:Array<Connection> = [];

    public var outlineColor:Color = Color.JET_BLACK;
    public var fillColor:Color = Color.WHITE;

    public function new(x:Float, y:Float, letter:String) {

        super();
        this.x = x;
        this.y = y;
        id = letter;

		graphics.lineStyle(2, outlineColor);
		graphics.beginFill(fillColor);
		graphics.drawCircle(0, 0, 7);
		graphics.endFill();

        all.push(this);
    }

    public function connect(joint:Joint, ?connectionText:String):Joint {
        connections.push(new Connection(this, joint, connectionText));
		joint.connections.push(new Connection(joint, this, connectionText));
        return this;
    }

    public function disconnect(joint:Joint):Joint {
        for (c in this.connections) {
            if (c.from == this && c.to == joint || c.from == joint && c.to == this) this.connections.remove(c);
        }

        for (c in joint.connections) {
            if (c.from == this && c.to == joint || c.from == joint && c.to == this) joint.connections.remove(c);
        }
        return this;
    }
}