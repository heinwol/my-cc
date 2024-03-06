import cc.Peripheral;
import cc.Turtle;
import cc.Vector.Vector;
import Union.TrustedUnion;
import Union3.TrustedUnion3;

using lua.Table;

@:forward(x, y, z)
abstract Vec(Vector) from Vector to Vector {
	inline public function new(x:Int, y:Int, z:Int) {
		this = Vector.create(x, y, z);
	}

	static inline public function zero():Vec {
		return new Vec(0, 0, 0);
	}

	@:op(A + B)
	public function add(rhs:Vec):Vec {
		return this.add(rhs);
	}

	@:op(A - B)
	public function sub(rhs:Vec):Vec {
		return this.sub(rhs);
	}
}

enum TopBottomDirection {
	Top;
	Bottom;
}

enum FaceDirection {
	Front; // 0
	Right; // 1
	Back; // 2
	Left; // 3
}

function compose_face_dir(a:FaceDirection, b:FaceDirection):FaceDirection {
	return FaceDirection.createByIndex((a.getIndex() + b.getIndex()) % 4);
}

enum MoveDirection {
	Forward; // 0
	Back; // 1
	Up; // 2
	Down; // 3
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
