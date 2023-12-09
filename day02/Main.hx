class Main {
	static function main() {
		var MAX_DICE:Map<String, Int> = ["red" => 12, "green" => 13, "blue" => 14];

		var games:Map<Int, Game> = [];

		var input:String = sys.io.File.getContent('input.txt');
		var lines:Array<String> = input.split('\n');
		for (l in lines) {
			var parts:Array<String> = l.split(': ');

			var gameName:Array<String> = parts[0].split(' ');
			var game_id:Int = Std.parseInt(gameName[1]);

			var game:Game = games.get(game_id);
			if (game == null)
				game = new Game();

			var reveals:Array<String> = parts[1].split('; ');
			for (r in reveals) {
				var dice:Array<String> = r.split(", ");
				for (d in dice) {
					var diceSplit:Array<String> = d.split(" ");

					var diceCount:Int = 0;
					var colorName:String = StringTools.trim(diceSplit[1]);
					if (game.dice.exists(colorName)) {
						diceCount = game.dice.get(colorName);
					}
					diceCount = Std.int(Math.max(diceCount, Std.parseInt(diceSplit[0])));

					game.dice.set(colorName, diceCount);
				}
			}
			games.set(game_id, game);
		}

		var sum:Int = 0;
		var game:Game = null;
		var anyNoGood:Bool = false;

		for (k in games.keys()) {
			game = games.get(k);
			anyNoGood = false;
			for (dk in MAX_DICE.keys()) {
				if (game.dice.exists(dk)) {
					if (game.dice.get(dk) > MAX_DICE.get(dk)) {
						anyNoGood = true;
						break;
					}
				}
			}

			// trace(k, game.dice, !anyNoGood);

			if (!anyNoGood) {
				sum += k;
			}
		}

		trace("Part 1: ", sum);

		var powers:Int = 0;
		for (k in games.keys()) {
			game = games.get(k);
			var prod:Int = 1;
			for (k in game.dice.keys()) {
				prod *= game.dice.get(k);
			}
			powers += prod;
		}

		trace("Part 2: ", powers);
	}
}

class Game {
	public var dice:Map<String, Int> = [];

	public function new():Void {}
}
