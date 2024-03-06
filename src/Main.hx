import cc.Peripheral;
import cc.Turtle;
import Union.TrustedUnion;
import Lib;

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
		trace(y);
	}
}
