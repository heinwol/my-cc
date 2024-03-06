import cc.Peripheral;
import cc.Turtle;
import Union.TrustedUnion;
import Union3.TrustedUnion3;

using lua.Table;

// class

enum TopBottomDirection {
	Top;
	Bottom;
}

enum FaceDirection {
	Left;
	Right;
	Front;
	Back;
}

enum DirectionAbsolute {
	Top;
	Bottom;
	Left;
	Right;
	Front;
	Back;
}

typedef AnyDirection = TrustedUnion3<TopBottomDirection, FaceDirection, DirectionAbsolute>;

function getDirection(d:AnyDirection):String {
	return switch d.type() {
		case TopBottomDirection(d_):
			switch d_ {
				case Top: "Top";
				case Bottom: "Bottom";
			};
		case FaceDirection(d_):
			switch d_ {
				case Left: "Left";
				case Right: "Right";
				case Front: "Front";
				case Back: "Back";
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
	public function wrapDirection<T>(d:TopBottomDirection):T {
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
