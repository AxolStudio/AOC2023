import haxe.ds.ArraySort;
import hl.F64;

using StringTools;
using Lambda;

class Main {
	public static var widthInCharacters:Int = -1;
	public static var heightInCharacters:Int = -1;
	public static var mapData:Array<String> = [];
	public static var pathNodes:Array<Node> = [];
	public static var nodePairs:Array<NodePair> = [];

	static function main() {
		var input:String = sys.io.File.getContent('input.txt');

		widthInCharacters = input.indexOf('\r\n');
		heightInCharacters = input.split('\r\n').length;

		mapData = input.replace("\r\n", "").split("");

		var startPos:Int = mapData.indexOf("S");
		var startNode:Node = new Node(startPos % widthInCharacters, Std.int(startPos / widthInCharacters), "S");

		// pathNodes.push(startNode);

		var thisNode:Node = startNode;
		var nextNode:Node = null;
		var lastNode:Node = null;
		while (nextNode == null || nextNode.type != "S") {
			nextNode = getNextNode(thisNode, lastNode);
			pathNodes.push(nextNode);
			lastNode = thisNode;
			thisNode = nextNode;
		}
		nextNode = pathNodes[0];

		trace("Part 1", Math.ceil(pathNodes.length / 2));

		startNode.type = convertStartNode(lastNode, startNode, nextNode);

		pathNodes[pathNodes.length - 1] = startNode;

		var enclosed:Int = 0;

		for (y in 0...heightInCharacters) {
			var windingCount:Int = 0;
			for (x in 0...widthInCharacters) {
				var node:Node = pathNodes.filter((n) -> {
					return n.x == x && n.y == y;
				})[0];
				if (node != null) {
					
					if (node.type == "|" || node.type == "F" || node.type == "7") {
						windingCount++;
						trace(node);
					};
				} else if (windingCount % 2 == 1)
					enclosed++;
			}
		}

		trace("Part 2", enclosed);
	}

	private static function convertStartNode(LastNode:Node, StartNode:Node, FirstNode:Node):String {
		var pattern:Array<Array<Int>> = [
			[LastNode.x - StartNode.x, LastNode.y - StartNode.y],
			[FirstNode.x - StartNode.x, FirstNode.y - StartNode.y]
		];

		var newType:String = switch (pattern) {
			case [[1, 0], [-1, 0]]: "-";
			case [[0, -1], [-1, 0]]: "J";
			case [[0, 1], [-1, 0]]: "7";
			case [[-1, 0], [0, -1]]: "J";
			case [[-1, 0], [0, 1]]: "7";
			case [[0, -1], [1, 0]]: "L";
			case [[0, 1], [1, 0]]: "F";
			case [[1, 0], [0, -1]]: "L";
			case [[1, 0], [0, 1]]: "F";
			case [[0, -1], [0, 1]]: "|";
			case [[-1, 0], [1, 0]]: "-";
			case [[0, 1], [0, -1]]: "|";

			default: "X";
		}

		return newType;
	}

	private static function sortNode(A:Node, B:Node):Int {
		var aV:Int = A.y * widthInCharacters + A.x;
		var bV:Int = B.y * widthInCharacters + B.x;
		return aV - bV;
	}

	private static function getNeighborNode(node:Node, direction:String):Node {
		var neighborNode:Node = null;
		switch (direction) {
			case "up":
				if (node.y > 0)
					neighborNode = new Node(node.x, node.y - 1, mapData[node.x + ((node.y - 1) * widthInCharacters)]);

			case "down":
				if (node.y < heightInCharacters - 1)
					neighborNode = new Node(node.x, node.y + 1, mapData[node.x + ((node.y + 1) * widthInCharacters)]);

			case "left":
				if (node.x > 0)
					neighborNode = new Node(node.x - 1, node.y, mapData[(node.x - 1) + (node.y * widthInCharacters)]);

			case "right":
				if (node.x < widthInCharacters - 1)
					neighborNode = new Node(node.x + 1, node.y, mapData[(node.x + 1) + (node.y * widthInCharacters)]);
		}
		return neighborNode;
	}

	private static function getNextNode(node:Node, lastNode:Node):Node {
		var nextNode:Node = null;

		switch (node.type) {
			case "S": // we have to look at all of our neighbors for a pipe that points our direction...
				var neighbors:Array<Node> = [];
				neighbors.push(getNeighborNode(node, "up"));
				neighbors.push(getNeighborNode(node, "down"));
				neighbors.push(getNeighborNode(node, "left"));
				neighbors.push(getNeighborNode(node, "right"));

				for (neighbor in neighbors) {
					if (neighbor != null) {
						if ((neighbor.type == "|" && (neighbor.y == node.y - 1 || neighbor.y == node.y + 1))
							|| (neighbor.type == "-" && (neighbor.x == node.x - 1 || neighbor.x == node.x + 1))
							|| (neighbor.type == "L" && (neighbor.y == node.y + 1 || neighbor.x == node.x - 1))
							|| (neighbor.type == "J" && (neighbor.y == node.y + 1 || neighbor.x == node.x + 1))
							|| (neighbor.type == "7" && (neighbor.y == node.y - 1 || neighbor.x == node.x + 1))
							|| (neighbor.type == "F" && (neighbor.y == node.y - 1 || neighbor.x == node.x + 1))) {
							nextNode = neighbor;
							break;
						}
					}
				}

			case "|":
				if (lastNode != null && lastNode.y > node.y)
					nextNode = getNeighborNode(node, "up");
				else
					nextNode = getNeighborNode(node, "down");

			case "-":
				if (lastNode != null && lastNode.x > node.x)
					nextNode = getNeighborNode(node, "left");
				else
					nextNode = getNeighborNode(node, "right");

			case "L":
				if (lastNode != null && lastNode.x > node.x)
					nextNode = getNeighborNode(node, "up");
				else
					nextNode = getNeighborNode(node, "right");

			case "J":
				if (lastNode != null && lastNode.x < node.x)
					nextNode = getNeighborNode(node, "up");
				else
					nextNode = getNeighborNode(node, "left");

			case "7":
				if (lastNode != null && lastNode.x < node.x)
					nextNode = getNeighborNode(node, "down");
				else
					nextNode = getNeighborNode(node, "left");

			case "F":
				if (lastNode != null && lastNode.x > node.x)
					nextNode = getNeighborNode(node, "down");
				else
					nextNode = getNeighborNode(node, "right");
		}

		return nextNode;
	}
}

class Node {
	public var x:Int;
	public var y:Int;
	public var type:String;

	public function new(x:Int, y:Int, type:String) {
		this.x = x;
		this.y = y;
		this.type = type;
	}

	public function toString():String {
		return "[ Node: " + x + ", " + y + " (" + type + ") ]\r\n";
	}
}

class NodePair {
	public var start:Node;
	public var end:Node;

	public function new(start:Node, end:Node) {
		this.start = start;
		this.end = end;
	}

	public function toString():String {
		return "[ NodePair: " + start + ", " + end + " ]";
	}
}