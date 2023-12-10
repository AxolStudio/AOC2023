import hl.F64;

using StringTools;

class Main {
	public static var directions:Array<String> = [];
	public static var network:Map<String, Element> = [];

	static function main() {
		var input:String = sys.io.File.getContent('input.txt');
		var lines:Array<String> = input.split('\n');
		directions = lines[0].trim().split('');
		for (l in 2...lines.length - 1) {
			var split:Array<String> = lines[l].split(' = (');
			var name:String = split[0];
			var sides:Array<String> = split[1].substr(0, split[1].length - 2).split(', ');
			network.set(name, new Element(sides[0], sides[1]));
		}

		// var currentPos:String = "AAA";
		// var steps:Int = 0;
		// while (currentPos != "ZZZ") {
		// 	var element:Element = network.get(currentPos);
		// 	var direction:String = directions[steps % directions.length];
		// 	if (direction == "L") {
		// 		currentPos = element.left;
		// 	} else {
		// 		currentPos = element.right;
		// 	}
		// 	steps++;
		// }

		// trace("Part 1: " + steps);

		var currentPoses:Array<String> = [];
		for (e in network.keys()) {
			if (e.endsWith("A")) {
				currentPoses.push(e);
			}
		}

		var steps:Array<Int> = [];
		for (c in currentPoses) {
			steps.push(computeStepsToEnd(c));
		}

		var totalSteps:F64 = lcm(steps);

		trace("Part 2: " + totalSteps);
	}

	private static function lcm(Numbers:Array<Int>):F64 {
		var result:F64 = 1;
		for (n in Numbers) {
			result = result * n / gcd(result, n);
		}
		return result;
	}

	private static function gcd(a:F64, b:F64):F64 {
		if (b == 0)
			return a;
		return gcd(b, a % b);
	}

	private static function computeStepsToEnd(StartPos:String):Int {
		var currentPos:String = StartPos;
		var steps:Int = 0;
		while (!currentPos.endsWith("Z")) {
			var element:Element = network.get(currentPos);
			var direction:String = directions[steps % directions.length];
			if (direction == "L") {
				currentPos = element.left;
			} else {
				currentPos = element.right;
			}
			steps++;
		}

		return steps;
	}
}

class Element {
	public var left:String = "";
	public var right:String = "";

	public function new(left:String, right:String) {
		this.left = left;
		this.right = right;
	}
}