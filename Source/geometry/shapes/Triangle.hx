package geometry.shapes;

import geometry.basic.Joint;
import geometry.basic.DraggableSprite;

class Triangle extends DraggableSprite {
    
    public var joint1:Joint;
    public var joint2:Joint;
    public var joint3:Joint;

    public var type:TriangleType = SCALENE;

    public function new(j1:Joint, j2:Joint, j3:Joint) {

        super();

        joint1 = j1;
        joint2 = j2;
        joint3 = j3;

        joint1.connect(joint2, joint3);
        joint2.connect(joint3);
    }
}

enum abstract TriangleType(Int) {
    var EQUILATERAL;
    var ISOSCELES;
    var RIGHT;
    var SCALENE;
}