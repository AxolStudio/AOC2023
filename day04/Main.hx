using StringTools;

class Main {
	static public var cards:Array<Card> = [null];

	static function main() {
		var input:String = sys.io.File.getContent('input.txt');
		var lines:Array<String> = input.split('\n');
		for (l in lines) {
			cards.push(new Card(l));
		}

		var totalScore:Int = 0;
		for (c in cards) {
			if (c != null)
				totalScore += c.score;
		}

		trace("Part 1", totalScore);

		var cardCount:Int = 0;
		for (c in cards) {
			if (c != null)
				cardCount += c.worth();
		}

		trace("Part 2", cardCount);
	}
}

class Card {
	public var id:Int = -1;
	public var winningNumbers:Array<Null<Int>> = [];
	public var ownedNumbers:Array<Null<Int>> = [];
	public var score:Int = 0;
	public var matches:Int = 0;

	public function new(Input:String):Void {
		var cardSplit:Array<String> = Input.split(':');
		var name:Array<String> = cardSplit[0].split(' ');

		this.id = Std.parseInt(name[name.length - 1]);
		var sides:Array<String> = cardSplit[1].split(' | ');
		this.winningNumbers = sides[0].split(' ').map((s) -> Std.parseInt(s.trim()));
		this.ownedNumbers = sides[1].split(' ').map((s) -> Std.parseInt(s.trim()));

		for (n in this.ownedNumbers) {
			if (this.winningNumbers.contains(n) && n != null) {
				this.matches++;
				if (this.score == 0)
					this.score = 1;
				else
					this.score *= 2;
			}
		}
	}

	public function worth():Int {
		var sum:Int = 1;
		if (this.matches == 0) {
			return sum;
		} else {
			for (i in this.id + 1...this.id + this.matches + 1) {
				var newWorth:Int = Main.cards[i].worth();
				sum += newWorth;
			}
			return sum;
		}
	}
}
