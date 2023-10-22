import cc.Peripheral;

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
		var x = Peripheral.find("top", function(s:String, t:Int) {
			return s.length == 1;
		});
		// x.
		var y = new SomeClass(3);
	}
}
