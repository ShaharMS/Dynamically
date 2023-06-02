package geometry.basic;

import vision.ds.Point2D;

private class ShapeBase {
    
    public var points:Map<String, Point2D>;

    public function new(points:Map<String, Point2D>) {
        this.points = points;
    }

    public function getAngle(ang:String):Float {
        var pointA = points[ang.charAt(0)];
        var pointB = points[ang.charAt(1)];
        var pointC = points[ang.charAt(2)];

        var deltaX1 = pointA.x - pointB.x;
        var deltaY1 = pointA.y - pointB.y;
        var deltaX2 = pointC.x - pointB.x;
        var deltaY2 = pointC.y - pointB.y;

        var dotProduct = deltaX1 * deltaX2 + deltaY1 * deltaY2;

        var magnitude1 = Math.sqrt(Math.pow(deltaX1, 2) + Math.pow(deltaY1, 2));
        var magnitude2 = Math.sqrt(Math.pow(deltaX2, 2) + Math.pow(deltaY2, 2));

        var angle = Math.acos(dotProduct / (magnitude1 * magnitude2));
        var angleDegrees = angle * (180 / Math.PI);

        return angleDegrees;
    }

    public function getSide(s:String) {
        return points[s.charAt(0)].distanceTo(points[s.charAt(1)]);
    }

    public function pushPoint(point:Point2D, ?letter:String) {
        var freeLetter = letter;
        if (freeLetter == null) {
            // Find a free letter closer to 'A'
            var currentLetterCode = 'A'.charCodeAt(0);
            while (points.exists(String.fromCharCode(currentLetterCode))) {
                currentLetterCode++;
            }
            freeLetter = String.fromCharCode(currentLetterCode);
        }

        points.set(freeLetter, point);
        return point;
    }
}

@:forward
abstract Shape(ShapeBase) {
    
    public function new(points:Map<String, Point2D>) {
        this = new ShapeBase(points);
    }

    @:op(a.b) @:noCompletion public function getInfo(s:String):Float {
        if (s.length == 3) return this.getAngle(s);
        if (s.length == 2) return this.getSide(s);
        else return null;
    }

    @:op([]) @:noCompletion public function getPoint(letter:String) {
        return this.points[letter];
    }
    @:op([]) @:noCompletion public function setPoint(letter:String, p:Point2D) {
        return this.pushPoint(p, letter);
    }
}