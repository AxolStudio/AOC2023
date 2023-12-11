import hl.F64;

using StringTools;

class Main {
	public static var widthInCharacters:Int = -1;
	public static var heightInCharacters:Int = -1;

	public static var galaxies:Array<Galaxy> = [];
	public static var spaces:Array<Array<Int>> = [[], []];

	static function main() {
		var input:String = sys.io.File.getContent('input.txt');

		widthInCharacters = input.indexOf('\r\n');
		heightInCharacters = input.split('\r\n').length;

		var mapData:Array<String> = input.replace("\r\n", "").split("");

		var lastPos:Int = 0;
		while (lastPos != -1) {
			lastPos = mapData.indexOf("#", lastPos);
			if (lastPos != -1) {
				var x:Int = lastPos % widthInCharacters;
				var y:Int = Std.int(lastPos / widthInCharacters);
				galaxies.push(new Galaxy(galaxies.length + 1, x, y));
				lastPos++;
			}
		}

		// expand the universe!
		var x:Int = widthInCharacters;
		while (x > 0) {
			x--;
			var gxyCount:Int = galaxies.filter((g) -> g.x == x).length;
			if (gxyCount == 0) {
				// galaxies = galaxies.map((g) -> g.x >= x ? new Galaxy(g.ID, g.x + 1, g.y) : g);
				spaces[0].push(x);
			}
		}

		var y:Int = heightInCharacters;
		while (y > 0) {
			y--;
			var gxyCount:Int = galaxies.filter((g) -> g.y == y).length;
			if (gxyCount == 0) {
				// galaxies = galaxies.map((g) -> g.y >= y ? new Galaxy(g.ID, g.x, g.y + 1) : g);
				spaces[1].push(y);
			}
		}

		var distances:F64 = 0;

		var pairs:Array<Array<Int>> = [];
		for (g in 0...galaxies.length) {
			for (o in g + 1...galaxies.length) {
				if (g == o)
					continue;
				pairs.push([g, o]);
			}
		}

		for (p in pairs) {
			var galaxy:Galaxy = galaxies[p[0]];
			var otherGalaxy:Galaxy = galaxies[p[1]];

			var distanceX:F64 = Math.abs(galaxy.getAdjustedX() - otherGalaxy.getAdjustedX());
			var distanceY:F64 = Math.abs(galaxy.getAdjustedY() - otherGalaxy.getAdjustedY());
			var distance:F64 = distanceX + distanceY;

			distances += distance;
		}

		trace("Part 1", distances);
		distances = 0;

		for (p in pairs) {
			var galaxy:Galaxy = galaxies[p[0]];
			var otherGalaxy:Galaxy = galaxies[p[1]];

			var distanceX:F64 = Math.abs(galaxy.getAdjustedX(1000000) - otherGalaxy.getAdjustedX(1000000));
			var distanceY:F64 = Math.abs(galaxy.getAdjustedY(1000000) - otherGalaxy.getAdjustedY(1000000));
			var distance:F64 = distanceX + distanceY;

			distances += distance;
		}

		trace("Part 2", distances);
	}

	public static function getSpaces(Dir:String = "X", Pos:Int):Int {
		var dir:Int = Dir == "X" ? 0 : 1;

		return spaces[dir].filter((n) -> n < Pos).length;
	}
}

class Galaxy {
	public var x:Int = -1;
	public var y:Int = -1;
	public var ID:Int = -1;

	public function new(ID:Int, x:Int, y:Int) {
		this.x = x;
		this.y = y;
		this.ID = ID;
	}

	public function getAdjustedX(Factor:F64 = 2):F64 {
		return x + (Main.getSpaces("X", x) * (Factor - 1));
	}

	public function getAdjustedY(Factor:F64 = 2):F64 {
		return y + (Main.getSpaces("Y", y) * (Factor - 1));
	}

	public function toString():String {
		return "Galaxy #" + ID + " at (" + x + " (" + getAdjustedX() + "), " + y + " (" + getAdjustedY() + "))";
	}
}

class Space {
	public var x:Int = -1;
	public var y:Int = -1;

	public function new(x:Int, y:Int) {
		this.x = x;
		this.y = y;
	}

	public function toString():String {
		return "Space at (" + x + ", " + y + ")";
	}
}