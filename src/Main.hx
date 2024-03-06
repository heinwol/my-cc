import cc.Peripheral;
// import cc.Turtle;
// import Union.TrustedUnion;
import Lib;
import Turtles;

using Lib.FaceDirection;
using Lib.MoveDirection;

class Main {
	static function main() {
		trace("Haxe is great!");
		var turtle = new TurtleWithRelativeState();
		turtle.move(Up);
		turtle.turn(Right);
		turtle.move(Forward);
		trace(turtle);

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
