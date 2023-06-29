package geometry.basic;

import openfl.display.Sprite;

class Connection extends Sprite implements IDrawable {
    
    public var joint1:Joint;
    public var joint2:Joint;

    public var text:String;

    public var outlineColor(default, set):Color = Color.JET_BLACK;

    function set_outlineColor(c:Color) {outlineColor = c; draw(); return outlineColor;}

    public function new(f:Joint, t:Joint, ?text:String) {
        super();

        joint1 = f;
        joint2 = t;
        this.text = text;

        draw();
    }

    public function draw() {
		graphics.clear();
		graphics.lineStyle(2, outlineColor);
		graphics.moveTo(joint1.x, joint1.y);
		graphics.lineTo(joint2.x, joint2.y);
    }
}