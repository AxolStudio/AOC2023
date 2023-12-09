using StringTools;

class Main {
	public static var seeds:Array<String> = [];

	public static var almanacs:Map<String, Map<String, Float>> = [];

	public static var Maps:Map<String, MapMap> = [];

	public static var pairs:Map<String, Array<Pair>> = [];

	static function main() {
		var input:String = sys.io.File.getContent('input.txt');
		var lines:Array<String> = input.split('\n');

		var whichMapMap:MapMap = null;
		var mapMapName:String = "";
		for (l in lines) {
			if (l.startsWith("seeds: ")) {
				var seedSplit:Array<String> = l.split(' ');
				for (s in seedSplit) {
					if (s.startsWith("seeds:")) {
						continue;
					}
					seeds.push(s);
				}
			} else {
				if (l.endsWith(":\r")) {
					var name:Array<String> = l.split(" ");
					var nameParts:Array<String> = name[0].split("-");
					mapMapName = nameParts[0] + "->" + nameParts[2];
					whichMapMap = new MapMap();
				} else if (l != "\r") {
					var entry:MapMapEntry = new MapMapEntry(l);
					whichMapMap.entries.push(entry);
				} else {
					if (mapMapName != "" && whichMapMap != null)
						Maps.set(mapMapName, whichMapMap);
					mapMapName = "";
					whichMapMap = null;
				}
			}
		}
		if (mapMapName != "" && whichMapMap != null)
			Maps.set(mapMapName, whichMapMap);

		var lowest:Float = Math.POSITIVE_INFINITY;

		for (s in seeds) {
			almanacs.set(s, []);
			lowest = Math.min(lowest, mapThing(s, "seed", Std.parseFloat(s)));
		}

		trace("Part 1", lowest);

		var seedRanges:Array<Pair> = [];
		for (i in 0...Std.int(seeds.length / 2)) {
			seedRanges.push(new Pair(Std.parseFloat(seeds[i * 2]), Std.parseFloat(seeds[i * 2 + 1])));
		}
		pairs.set("seed", seedRanges);

		transform("seed");

		lowest = Math.POSITIVE_INFINITY;
		for (p in pairs.get("location")) {
			lowest = Math.min(lowest, p.start);
		}

		trace("Part 2", lowest);
	}

	public static function transform(From:String):Void {
		for (k in Maps.keys()) {
			if (k.startsWith(From + "->")) {
				var m:MapMap = Maps.get(k);
				var newThing:String = k.split("->")[1];

				var thisPairs:Array<Pair> = pairs.get(From);

				var newPairs:Array<Pair> = getTransformedPairs(m, thisPairs);

				pairs.set(newThing, newPairs);

				transform(newThing);
			}
		}
	}

	public static function getTransformedPairs(M:MapMap, P:Array<Pair>):Array<Pair> {
		var newPairs:Array<Pair> = [];

		for (p in P) {
			var start:Float = p.start;
			var length:Float = p.length;
			var end:Float = p.start + length;
			var tmpLength:Float = length;
			while (start < end) {
				var match:Bool = false;
				for (e in M.entries) {
					if (!(start + tmpLength < e.sourceStart || start >= e.sourceStart + e.length)) {
						var adj:Float = start - e.sourceStart;

						if (adj < 0) {
							tmpLength = -adj;
							continue;
						}

						var newStart:Float = e.destStart + adj;
						var newLength:Float = Math.min(e.length - adj, tmpLength);

						newPairs.push(new Pair(newStart, newLength));
						start += newLength;
						tmpLength = length - newLength;

						match = true;
						break;
					}
				}
				if (!match) {
					newPairs.push(new Pair(start, tmpLength));
					start += tmpLength;
					tmpLength = length - tmpLength;
				}
			}
		}

		return newPairs;
	}

	public static function mapThing(SeedNo:String, Thing:String, Value:Float):Float {
		var newThing:String = "";
		for (m in Maps.keys()) {
			if (m.startsWith(Thing + "->")) {
				var mapMap:MapMap = Maps.get(m);
				var result:Float = mapMap.getMappedValue(Value);
				newThing = m.split("->")[1];
				var a:Map<String, Float> = almanacs.get(SeedNo);
				a.set(newThing, result);
				almanacs.set(SeedNo, a);
				mapThing(SeedNo, newThing, result);
			}
		}
		return almanacs.get(SeedNo).get("location");
	}
}

class MapMap {
	public var entries:Array<MapMapEntry> = [];

	public function new():Void {
		entries = [];
	}

	public function getMappedValue(Source:Float):Float {
		for (e in entries) {
			var adj:Float = Source - e.sourceStart;
			if (adj <= e.length && adj >= 0) {
				return e.destStart + adj;
			}
		}
		return Source;
	}

	public function reverseLookup(Dest:Float):Float {
		for (e in entries) {
			var adj:Float = Dest - e.destStart;
			if (adj <= e.length && adj >= 0) {
				return e.sourceStart + adj;
			}
		}
		return Dest;
	}
}

class MapMapEntry {
	public var destStart:Float;
	public var sourceStart:Float;
	public var length:Float;
	public var mod:Float;

	public function new(Input:String):Void {
		var parts:Array<String> = Input.split(' ');
		destStart = Std.parseFloat(parts[0]);
		sourceStart = Std.parseFloat(parts[1]);
		length = Std.parseFloat(parts[2]);
		mod = destStart - sourceStart;
	}

	public function toString():String {
		return "[" + Std.string(destStart) + ", " + Std.string(sourceStart) + ", " + Std.string(length) + "]";
	}
}

class Pair {
	public var start:Float;
	public var length:Float;

	public function new(Start:Float, Length:Float):Void {
		start = Start;
		length = Length;
	}

	public function toString():String {
		return "[" + Std.string(start) + ", " + Std.string(length) + "]";
	}
}