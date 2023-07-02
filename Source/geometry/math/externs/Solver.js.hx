package geometry.math.externs;

@:native("nerdamer")
extern class Solver {


    static function solve(equation:String, variable:String):Array<Symbol>;
}


extern class Symbol implements Dynamic {
    

    function toString():String;
    function isConstant():Bool;
}