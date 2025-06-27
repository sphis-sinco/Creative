package;

class PlayState extends FlxState
{
	public var blockRes:Int = 16;

	public var worldWidth:Int = 16;
	public var worldHeight:Int = 9;

	public var worldLayers = {
		'grass': 0,
		'stone': 0,
	};

	public var worldBlocks:Array<Block> = [];

	public function worldRender()
	{
		for (block in worldBlocks)
		{
			trace(block);
			add(block);
		}
	}

	public function worldInit()
	{
		var x:Int = 0;
		var y:Int = 0;

		while (y < worldHeight)
		{
			while (x < worldWidth)
			{
				if (y == worldHeight - worldLayers.stone)
					worldBlocks.push(new Block('stone', x * blockRes, y * blockRes));
				x++;
			}

			y++;
			x = 0;
		}
	}

	override public function create():Void
	{
		super.create();
		worldInit();
		worldRender();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
