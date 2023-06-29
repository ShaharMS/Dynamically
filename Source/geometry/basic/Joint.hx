package geometry.basic;

import openfl.display.Sprite;

class Joint extends Sprite {
    
    public static var all:Array<Joint> = [];

    public var id:String = "";

    public var connections:Array<Connection> = [];

    public function new(x:Float, y:Float, letter:String) {

        super();
        this.x = x;
        this.y = y;
        id = letter;

        all.push(this);
    }

    public function connect(joint:Joint, ?connectionText:String):Joint {
        connections.push(new Connection(this, joint, connectionText));
		joint.connections.push(new Connection(joint, this, connectionText));
        return this;
    }
}