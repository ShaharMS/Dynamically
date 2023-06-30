package geometry.basic;

import openfl.display.Sprite;

class Connection extends DraggableSprite implements IDrawable {
    
    public var joint1:Joint;
    public var joint2:Joint;

    public var text:String;

    public var outlineColor(default, set):Color = Color.JET_BLACK;

    function set_outlineColor(c:Color) {outlineColor = c; redraw(); return outlineColor;}

	var org1X:Float;
	var org1Y:Float;
	var org2X:Float;
	var org2Y:Float;

    public function new(f:Joint, t:Joint, ?text:String) {
        super();

        joint1 = f;
        joint2 = t;
        org1X = f.x;
        org1Y = f.y;
        org2X = t.x;
        org2Y = t.y;
        this.text = text;

		onMoved.push((x, y, mx, my) -> {
			joint1.x = org1X + x;
			joint2.x = org2X + x;
			joint1.y = org1Y + y;
			joint2.y = org2Y + y;
			this.x = 0;
			this.y = 0;
            joint1.onMoved[0](0,0,0,0);
            joint2.onMoved[0](0,0,0,0);
			redraw();
		});

        onDragged.push((x, y, px, py) -> {
            reposition();
        });

        redraw();
    }

    public function redraw() {
		graphics.clear();
		graphics.lineStyle(2, outlineColor);
		graphics.moveTo(joint1.x, joint1.y);
		graphics.lineTo(joint2.x, joint2.y);
        graphics.lineStyle(10, 0x000000, 0.01);
		graphics.moveTo(joint1.x, joint1.y);
		graphics.lineTo(joint2.x, joint2.y);
    }

	public function reposition() {
		org1X = joint1.x;
		org1Y = joint1.y;
		org2X = joint2.x;
		org2Y = joint2.y;

        joint1.connections.remove(this);
		for (c in joint1.connections) c.reposition();
		joint1.connections.push(this);
		joint2.connections.remove(this);
		for (c in joint2.connections) c.reposition();
		joint2.connections.push(this);
    }
}