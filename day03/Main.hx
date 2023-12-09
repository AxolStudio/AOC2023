using StringTools;

class Main {
	static var gears:Map<String, Array<Int>> = [];

	static function main() {
		var parts:Array<PartNumber> = [];
		var symbols:Map<String, Symbol> = [];
		var symbolReg:EReg = ~/([^\.\d\r\n])/m;
		var numbersReg:EReg = ~/(\d+)/m;
		var input:String = sys.io.File.getContent('input.txt');

		var widthInChars:Int = input.indexOf('\n');
		var heightInChars:Int = Std.int(input.length / widthInChars);

		input = input.replace("\n", '');

		var search:String = input;

		var left:String = "";

		while (numbersReg.match(search)) {
			var x:Int = (numbersReg.matchedPos().pos + left.length) % widthInChars;
			var y:Int = Std.int((numbersReg.matchedPos().pos + left.length) / widthInChars);

			var value:Int = Std.parseInt(numbersReg.matched(1));
			left += numbersReg.matchedLeft() + value;
			parts.push(new PartNumber(x, y, value));
			search = numbersReg.matchedRight();
			// trace(x + " " + y + " " + value);
		}

		search = input;
		left = "";

		while (symbolReg.match(search)) {
			var x:Int = (symbolReg.matchedPos().pos + left.length) % widthInChars;
			var y:Int = Std.int((symbolReg.matchedPos().pos + left.length) / widthInChars);

			var symbol:String = symbolReg.matched(1);
			left += symbolReg.matchedLeft() + symbol;
			symbols.set(Std.string(x) + ":" + Std.string(y), new Symbol(x, y, symbol));
			if (symbol == "*")
				gears.set(Std.string(x) + ":" + Std.string(y), []);
			search = symbolReg.matchedRight();
		}

		var sum:Int = 0;
		for (part in parts) {
			if (isPartNumber(part, symbols, widthInChars, heightInChars)) {
				sum += part.value;
			}
		}

		trace("Part 1", sum);

		var gearRatios:Int = 0;
		for (g in gears) {
			if (g.length == 2) {
				gearRatios += g[0] * g[1];
			}
		}

		trace("Part 2", gearRatios);
	}

	static function isPartNumber(Part:PartNumber, Symbols:Map<String, Symbol>, WidthInChars:Int, HeightInChars:Int):Bool {
		var matched:Bool = false;
		for (x in Part.x - 1...Std.int(Part.x + Std.string(Part.value).length + 1)) {
			for (y in Part.y - 1...Part.y + 2) {
				if (Symbols.exists(Std.string(x) + ":" + Std.string(y))) {
					matched = true;
					var s:Symbol = Symbols.get(Std.string(x) + ":" + Std.string(y));
					if (s.symbol == "*") {
						var parts:Array<Int> = gears.get(Std.string(x) + ":" + Std.string(y));
						parts.push(Part.value);
						gears.set(Std.string(x) + ":" + Std.string(y), parts);
					}
				}
			}
		}

		return matched;
	}
}

class PartNumber {
	public var x:Int = -1;
	public var y:Int = -1;
	public var value:Int = -1;

	public function new(x:Int, y:Int, value:Int) {
		this.x = x;
		this.y = y;
		this.value = value;
	}
}

class Symbol {
	public var x:Int = -1;
	public var y:Int = -1;
	public var symbol:String = "";

	public function new(x:Int, y:Int, symbol:String) {
		this.x = x;
		this.y = y;
		this.symbol = symbol;
	}
}
