using StringTools;

class Main {
	public static var hands:Map<String, Int> = [];
	public static var order:Array<String> = [];

	static function main() {
		var input:String = sys.io.File.getContent('input.txt');
		var lines:Array<String> = input.split('\n');

		for (l in lines) {
			var split:Array<String> = l.split(" ");
			order.push(split[0]);
			hands.set(split[0], Std.parseInt(split[1]));
		}

		order.sort(handSorter);

		var winnings:Int = 0;
		for (o in 0...order.length) {
			var hand:Int = hands.get(order[o]);
			winnings += hand * (o + 1);
		}

		trace("Part 1: " + winnings);
	}

	private static function handSorter(A:String, B:String):Int {
		var cA:Array<Int> = convertHand(A);
		var cB:Array<Int> = convertHand(B);
		var aType:Int = getHandType(A);
		var bType:Int = getHandType(B);

		if (aType > bType)
			return 1;
		if (aType < bType)
			return -1;
		for (i in 0...cA.length) {
			if (cA[i] > cB[i])
				return 1;
			if (cA[i] < cB[i])
				return -1;
		}

		return 0;
	}

	private static function getHandType(Hand:String):HandType {
		var counts:Map<String, Int> = characterCounter(Hand);
		var values:Array<Int> = [];
		for (k in counts.keys())
			values.push(counts.get(k));
		if (values.contains(5))
			return HandType.FiveOfAKind;
		if (values.contains(4))
			return HandType.FourOfAKind;
		if (values.contains(3) && values.contains(2))
			return HandType.FullHouse;
		if (values.contains(3))
			return HandType.ThreeOfAKind;
		if (values.filter((i) -> {
			return i == 2;
		}).length == 2)
			return HandType.TwoPair;
		if (values.contains(2))
			return HandType.OnePair;
		return HandType.HighCard;
	}

	private static function characterCounter(Hand:String):Map<String, Int> {
		var counter:Map<String, Int> = [];
		var jokerCount:Int = 0;
		var highestCount:Int = -1;
		var higestCountChar:String = "";
		var value:Int = 0;
		for (i in Hand.split('')) {
			if (i == "J") {
				jokerCount++;
				continue;
			}
			if (counter.exists(i)) {
				value = counter.get(i) + 1;
				if (value > highestCount) {
					highestCount = value;
					higestCountChar = i;
				}
				counter.set(i, value);
			} else {
				counter.set(i, 1);
				if (1 > highestCount) {
					highestCount = 1;
					higestCountChar = i;
				}
			}
		}
		if (jokerCount > 0) {
			counter.set(higestCountChar, counter.get(higestCountChar) + jokerCount);
		}

		return counter;
	}

	private static function convertHand(Hand:String):Array<Int> {
		var converted:Array<Int> = [];
		for (i in Hand.split('')) {
			switch (i) {
				case "A":
					converted.push(14);
				case "K":
					converted.push(13);
				case "Q":
					converted.push(12);
				case "J":
					converted.push(1);
				case "T":
					converted.push(10);

				default:
					converted.push(Std.parseInt(i));
			}
		}
		return converted;
	}
}

enum abstract HandType(Int) from Int to Int {
	var FiveOfAKind:Int = 6;
	var FourOfAKind:Int = 5;
	var FullHouse:Int = 4;
	var ThreeOfAKind:Int = 3;
	var TwoPair:Int = 2;
	var OnePair:Int = 1;
	var HighCard:Int = 0;
}