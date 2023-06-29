package geometry.basic;

import openfl.display.Sprite;

class Connection extends Sprite {
    
    public var from:Joint;
    public var to:Joint;

    public var text:String;

    public function new(f:Joint, t:Joint, ?text:String) {
        super();

        from = f;
        to = t;
        this.text = text;
    }

}