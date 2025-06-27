package;

import flixel.math.FlxRandom;
import flixel.text.FlxText;

class PlayState extends FlxState
{
	public var blockScale:Int = 2;

	public var worldWidth:Int = 38;
	public var worldHeight:Int = 22;

	public var worldLayers = {
		'grass': 11,
		'dirt': 10,
		'stone': 8,
	};

	public var worldBlocks:Array<Block> = [];

	public function worldRender()
	{
		#if WORLD_RENDERING_TRACES
		trace('worldRender');
		#end
		for (block in worldBlocks)
		{
			add(block);
			block.x += block.width * 1.5;
			block.y += block.height;
		}
	}

	public function worldInit()
	{
		#if WORLD_RENDERING_TRACES
		trace('worldInit');
		#end

		worldBlocks = [];

		var x:Int = 0;
		var y:Int = 0;

		while (y < worldHeight)
		{
			while (x < worldWidth + 1)
			{
				#if WORLD_RENDERING_TRACES
				trace('$x|$y');
				#end
				var block_tag:String = 'air';

				if (y > worldHeight - worldLayers.grass)
					block_tag = 'grass';
				final dirtRandom:Int = new FlxRandom().int(0, 3);
				if (y > worldHeight - (worldLayers.dirt))
					block_tag = 'dirt';
				if (y > worldHeight - (worldLayers.stone - dirtRandom))
					block_tag = 'stone';

				var block:Block = new Block(block_tag, 0, 0);
				block.scale.set(blockScale, blockScale);
				block.setPosition(x * (x > 0 ? (blockScale * block.width) : 1), y * (y > 0 ? (blockScale * block.height) : 1));

				if (block_tag != 'air') 
					worldBlocks.push(block);
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
		var VersionText:FlxText = new FlxText(10, 10, 0, 'Creative ' + Version.generateVersionString(true, true, true), 16);
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
