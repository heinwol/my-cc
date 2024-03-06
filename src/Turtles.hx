// import haxe.ValueException;
// import cc.Vector;
// import cc.Peripheral;
import cc.Turtle;
// import Union.TrustedUnion;
import Lib;

// using Lib.MoveDirection;

function check_action_or_throw(action:TurtleActionResult) {
	if (!action.successful) {
		throw action.error;
	}
}

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

	public function turn(direction:FaceDirection) {
		switch direction {
			case Front:
				{};
			case Left:
				check_action_or_throw(Turtle.turnLeft());
				this.relative_face_direction = compose_face_dir(this.relative_face_direction, FaceDirection.Left);
			case Right:
				check_action_or_throw(Turtle.turnRight());
				this.relative_face_direction = compose_face_dir(this.relative_face_direction, FaceDirection.Right);
			case Back:
				check_action_or_throw(Turtle.turnRight());
				this.relative_face_direction = compose_face_dir(this.relative_face_direction, FaceDirection.Right);
				check_action_or_throw(Turtle.turnRight());
				this.relative_face_direction = compose_face_dir(this.relative_face_direction, FaceDirection.Right);
		}
	}

	public function move(direction:MoveDirection) {
		switch direction {
			case Up:
				check_action_or_throw(Turtle.up());
				this.relative_coordinates.y += 1;
			case Down:
				check_action_or_throw(Turtle.down());
				this.relative_coordinates.y -= 1;
			case Forward | Back:
				var coord_to_add = switch this.relative_face_direction {
					case Front: new Vec(1, 0, 0);
					case Back: new Vec(-1, 0, 0);
					case Left: new Vec(0, 0, -1);
					case Right: new Vec(0, 0, 1);
				}
				switch direction {
					case Forward:
						check_action_or_throw(Turtle.forward());
						this.relative_coordinates += coord_to_add;
					case Back:
						check_action_or_throw(Turtle.back());
						this.relative_coordinates -= coord_to_add;
					case _: {} // Never
				}
				check_action_or_throw(Turtle.forward());
		}
	}
}
