using StringTools;

class Main {
	public static var races:Array<Race> = [];

	static function main() {
		var input:String = sys.io.File.getContent('input.txt');
		var lines:Array<String> = input.split('\n');

		var times:Array<Null<Int>> = cast lines[0].split(':')[1].split(" ").map((s) -> {
			if (s.trim() != "")
				return Std.parseInt(s);
			return null;
		}).filter((i) -> i != null);

		var distances:Array<Null<Int>> = cast lines[1].split(':')[1].split(" ").map((s) -> {
			if (s.trim() != "")
				return Std.parseInt(s);
			return null;
		}).filter((i) -> i != null);

		var products:Float = 1;

		for (i in 0...times.length) {
			var r:Race = new Race(times[i], distances[i]);
			races.push(r);
			var wins:Float = r.getNumberOfWins();

			products *= wins;
		}

		trace("Part 1", products);

		var time:String = "";
		var dist:String = "";
		for (t in times) {
			if (t != null)
				time += t + "";
		}
		for (d in distances) {
			if (d != null)
				dist += d + "";
		}

		var longRace:Race = new Race(Std.parseInt(time), Std.parseInt(dist));

		trace("Part 2", longRace.getNumberOfWins());
	}
}

class Race {
	public var maxTime:Int = -1;
	public var distanceToBeat:Int = -1;

	public function new(maxTime:Int, distanceToBeat:Int) {
		this.maxTime = maxTime;
		this.distanceToBeat = distanceToBeat;
	}

	inline private function getLowerBound():Int {
		return Math.ceil((maxTime - Math.sqrt(Math.pow(maxTime, 2) - 4 * (distanceToBeat + 1))) / 2);
	}

	inline private function getUpperBound():Int {
		return Math.floor((maxTime + Math.sqrt(Math.pow(maxTime, 2) - 4 * (distanceToBeat + 1))) / 2);
	}

	public function getNumberOfWins():Int {
		var lowerBound:Int = getLowerBound();
		var upperBound:Int = getUpperBound();

		return upperBound - lowerBound + 1;
	}
}