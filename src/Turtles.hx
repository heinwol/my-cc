// import haxe.ValueException;
// import cc.Vector;
// import cc.Peripheral;
import cc.Turtle;
// import Union.TrustedUnion;
import Lib;

using Lib.TurtleActionResultExtender;
using Lib.ResultExtender;
using Lib.EmptyResultExtender;

class TurtleWithRelativeState {
	// "relativeness" is in the sense "relative to initial position and face direction"
	//
	// relative_coordinates should start with (0, 0, 0)
	public var relative_coordinates:Vec;
	public var relative_face_direction:FaceDirection;

	public function new() {
		this.relative_coordinates = new Vec(0, 0, 0);
		this.relative_face_direction = FaceDirection.Front;
	}

	public function turn(direction:FaceDirection):EmptyResult<String> {
		var set_dir = dir -> () -> {
			this.relative_face_direction = compose_face_dir(this.relative_face_direction, dir);
		};
		switch direction {
			case Front:
				return Ok;
			case Left:
				return Turtle.turnLeft().into().do_if(set_dir(FaceDirection.Left));
			case Right:
				return Turtle.turnRight().into().do_if(set_dir(FaceDirection.Right));
			case Back:
				return Turtle.turnRight()
					.into()
					.do_if(set_dir(FaceDirection.Right))
					.do_if(() -> Turtle.turnRight().into().do_if(set_dir(FaceDirection.Right)));
		}
	}

	public function move(direction:MoveDirection):EmptyResult<String> {
		switch direction {
			case Up:
				return Turtle.up().into().do_if(() -> this.relative_coordinates.y += 1);
			case Down:
				return Turtle.down().into().do_if(() -> this.relative_coordinates.y -= 1);
			case Forward | Back:
				var coord_to_add = switch this.relative_face_direction {
					case Front: new Vec(1, 0, 0);
					case Back: new Vec(-1, 0, 0);
					case Left: new Vec(0, 0, -1);
					case Right: new Vec(0, 0, 1);
				}
				switch direction {
					case Forward:
						return Turtle.forward().into().do_if(() -> this.relative_coordinates += coord_to_add);
					case Back:
						return Turtle.back().into().do_if(() -> this.relative_coordinates -= coord_to_add);
					case _:
						return Ok; // Never
				}
		}
	}
}
