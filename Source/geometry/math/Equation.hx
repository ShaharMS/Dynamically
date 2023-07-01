package geometry.math;

import texter.general.math.MathLexer;
import texter.general.math.MathAttribute;

class Equation {
    
    public var func:String;

    var tree:Array<MathAttribute>;

    public function new(f:String, variables:Array<String>, parameters:Map<String, Float>) {
        func = f;
		tree = MathLexer.resetAttributesOrder(MathLexer.splitBlocks(MathLexer.getMathAttributes(f)));

    }

}