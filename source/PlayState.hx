package;

class PlayState extends FlxState
{
	public var blockScale:Int = 6;

	public var worldWidth:Int = 16;
	public var worldHeight:Int = 9;

	public var worldLayers = {
		'grass': 0,
		'dirt': 0,
		'stone': 0,
	};

	public var worldBlocks:Array<Block> = [];

	public function worldRender()
	{
		trace('worldRender');
		for (block in worldBlocks)
		{
			add(block);
		}
	}

	public function worldInit()
	{
		trace('worldInit');

		worldBlocks = [];

		var x:Int = 0;
		var y:Int = 0;

		while (y < worldHeight)
		{
			while (x < worldWidth)
			{
				x++;
				trace('$x|$y');
				if (y < worldHeight - worldLayers.stone)
				{
					var block:Block = new Block('stone', x * blockScale, y * blockScale);
					block.scale.set(blockScale, blockScale);

					worldBlocks.push(block);
				}
			}

			y++;
			x = 0;
		}
		worldRender();
	}

	override public function create():Void
	{
		super.create();

		worldInit();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
