package geometry.math;

import texter.general.math.MathLexer;
import texter.general.math.MathAttribute;

class Equation {
    
    public var func:String;
    
    var parameters:Map<String, Float> = [];

    public function new(f:String, parameters:Map<String, Float>) {
        func = f;
    }

}