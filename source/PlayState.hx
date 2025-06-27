package;

import flixel.text.FlxText;

class PlayState extends FlxState
{
	public var blockScale:Int = 2;

	public var worldWidth:Int = 38;
	public var worldHeight:Int = 22;

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
			block.x += block.width * 1.5;
			block.y += block.height;
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
			while (x < worldWidth + 1)
			{
				trace('$x|$y');
				if (y < worldHeight - worldLayers.stone)
				{
					var block:Block = new Block('stone', 0, 0);
					block.scale.set(blockScale, blockScale);
					block.setPosition(x * (x > 0 ? (blockScale * block.width) : 1), y * (y > 0 ? (blockScale * block.height) : 1));

					worldBlocks.push(block);
				}
				x++;
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
		var VersionText:FlxText = new FlxText(10, 10, 0, Version.generateVersionString(true, true, true), 16);
		add(VersionText);
		VersionText.scrollFactor.set(0, 0);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if (FlxG.keys.justReleased.Q)
			FlxG.camera.zoom -= 0.5;
		else if (FlxG.keys.justReleased.E)
			FlxG.camera.zoom += 0.5;
	}
}
