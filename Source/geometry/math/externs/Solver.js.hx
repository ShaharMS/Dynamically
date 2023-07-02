package geometry.math.externs;

@:native("nerdamer")
extern class Solver {


    static function solve(equation:String, variable:String):Solution;

    @:overload(function(equation:String, variable:String):Solution {})
    static function solveEquations(equations:Array<String>):Solution;
}

typedef Solution = {
    toString:Void -> String
}