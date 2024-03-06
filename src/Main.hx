import cc.Peripheral;
import cc.Turtle;
import Union.TrustedUnion;

using lua.Table;

enum Direction {
	Top;
	Bottom;
}

enum DirectionAbsolute {
	Top;
	Bottom;
	Left;
	Right;
	Front;
	Back;
}

typedef AnyDirection = TrustedUnion<Direction, DirectionAbsolute>;

private function getDirection(d:AnyDirection):String {
	return switch d.type() {
		case Direction(d_):
			switch d_ {
				case Top: "Top";
				case Bottom: "Bottom";
			};
		case DirectionAbsolute(d_):
			switch d_ {
				case Top: "Top";
				case Bottom: "Bottom";
				case Left: "Left";
				case Right: "Right";
				case Front: "Front";
				case Back: "Back";
			};
	};
}

class MyPeripheral extends Peripheral {
	public function wrapDirection<T>(d:Direction):T {
		return Peripheral.wrap(getDirection(d));
	}
}

class SomeClass {
	public var state:Int;

	public function new(state:Int) {
		this.state = state;
	}

	public function sth(x:Int):Int {
		return x + 1 + state;
	}
}

class Main {
	static function main() {
		trace("Haxe is great!");
		var x = Peripheral.find("top", (s, t:Int) -> {
			return s.length == 1;
		});
		trace("lala");
		// x.sort()
		// Table.
		// x.
		var y = new SomeClass(3);
	}
}
