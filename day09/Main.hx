import hl.F64;

using StringTools;
using Lambda;

class Main {
	static public var histories:Array<History> = [];
	static public var revHistories:Array<History> = [];

	static function main() {
		var input:String = sys.io.File.getContent('input.txt');
		var lines:Array<String> = input.split('\r\n');
		for (line in lines) {
			var nums:Array<String> = line.split(' ');
			var history:Array<Int> = [];
			var revHistory:Array<Int> = [];
			for (num in nums) {
				history.push(Std.parseInt(num));
				revHistory.unshift(Std.parseInt(num));
			}
			histories.push(new History(history));
			revHistories.push(new History(revHistory));
		}

		var sum:Int = 0;
		for (h in histories) {
			sum += h.getPrediction();
		}

		trace("Part 1: ", sum);

		sum = 0;
		for (h in revHistories) {
			sum += h.getPrediction();
		}

		trace("Part 2: ", sum);
	}
}

class History {
	public var records:Array<Array<Int>> = [];

	public function new(history:Array<Int>) {
		records.push(history.copy());

		var anyNonZero:Bool = true;
		while (anyNonZero) {
			var next:Array<Int> = build();
			records.push(next);
			anyNonZero = next.filter(function(n) return n != 0).length > 0;
		}
	}

	public function build():Array<Int> {
		var last:Array<Int> = records[records.length - 1];
		var next:Array<Int> = [];

		for (i in 1...last.length) {
			var diff:Int = last[i] - last[i - 1];

			next.push(diff);
		}

		return next;
	}

	public function toString():String {
		var str:String = '[\n';
		for (record in records) {
			str += "[ " + record.join(' ') + ' ]\n';
		}
		str += ']\n';
		return str;
	}

	public function getPrediction():Int {
		var sum:Int = 0;
		for (i in 0...records.length) {
			sum += records[i][records[i].length - 1];
		}
		return sum;
	}
}
