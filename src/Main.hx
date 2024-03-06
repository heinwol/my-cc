import cc.Peripheral;
// import cc.Turtle;
// import Union.TrustedUnion;
import Lib;
import Turtles;
import cc.Turtle;

using Lib.FaceDirection;
using Lib.MoveDirection;

class Main {
	static function main() {
		trace("Haxe is great!");
		var turtle = new TurtleWithRelativeState();
		trace(turtle.move(Up));
		// turtle.turn(Right);
		trace(turtle.move(Forward));
		trace(turtle);
		// Turtle.up();
		// Turtle.turnRight();
		// Turtle.forward();

		// var x = Peripheral.find("top", (s, t:Int) -> {
		// 	return s.length == 1;
		// });
		// trace("lala");
		// // x.sort()
		// // Table.
		// // x.
		// var y = new SomeClass(3);
		// trace(y);
	}
}
