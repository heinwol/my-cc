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

class Empty {
	public inline function new() {}

	// static public var self(default, null):T;
	public static final self:Empty = new Empty();
}

enum Result<T, E> {
	Ok(val:T);
	Error(e:E);
}

enum EmptyResult<E> {
	Ok;
	Error(e:E);
}

class TurtleActionResultExtender {
	static public inline function into(res:TurtleActionResult):EmptyResult<String> {
		if (res.successful) {
			return Ok;
		} else {
			return Error(res.error);
		}
	}
}

class EmptyResultExtender {
	static public function do_if<E, T>(res:EmptyResult<E>, fun:(() -> Void)):EmptyResult<E> {
		switch res {
			case Ok:
				fun();
				return Ok;
			case Error(e):
				return Error(e);
		}
	}
}

class ResultExtender {
	static public function map<T1, E, T2>(res:Result<T1, E>, fun:(T1->T2)):Result<T2, E> {
		switch res {
			case Ok(val):
				return Ok(fun(val));
			case Error(e):
				return Error(e);
		}
	}
}

enum InspectResult {
	Ok(detail:TurtleBlockDetail);
	Error(s:String);
}

// @:forward(x, y, z)
abstract TurtleInspectResult_(TurtleInspectResult) from TurtleInspectResult to TurtleInspectResult {
	public function into():InspectResult {
		if (this.successful) {
			return Ok(this.result);
		} else {
			return Error(this.result);
		}
	}
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
