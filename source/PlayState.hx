package;

import flixel.math.FlxRandom;
import flixel.text.FlxText;

class PlayState extends FlxState
{
	public var blockScale:Int = 2;

	public static var worldWidth:Int = 39;
	public static var worldHeight:Int = 22;

	public static var zoom:Float = 1.0;

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
			while (x < worldWidth)
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
		WorldWidthText = new FlxText(10, 10 + VersionText.y + VersionText.height, 0, 'World width: ' + Std.string(worldWidth), 16);
		WorldHeightText = new FlxText(10, 10 + WorldWidthText.y + WorldWidthText.height, 0, 'World height: ' + Std.string(worldHeight), 16);

		WorldWidthText.scrollFactor.set(0, 0);
		WorldHeightText.scrollFactor.set(0, 0);

		add(WorldWidthText);
		add(WorldHeightText);

		FlxG.camera.zoom = zoom;
		MouseBlock = new FlxSprite(0, 0).loadGraphic(FileManager.getImageFile('outline'));
		MouseBlock.scale.set(blockScale, blockScale);

		add(MouseBlock);
	}

	var WorldWidthText:FlxText;
	var WorldHeightText:FlxText;

	var MouseBlock:FlxSprite;

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if (FlxG.keys.justReleased.Q && zoom > 0.5)
			zoom -= 0.5;
		else if (FlxG.keys.justReleased.E && zoom < 2)
			zoom += 0.5;

		if (FlxG.keys.justReleased.Z && worldWidth > 1)
			worldWidth -= 1;
		else if (FlxG.keys.justReleased.X && worldWidth < 50)
			worldWidth += 1;

		if (FlxG.keys.anyJustReleased([Q, E, Z, X]))
			FlxG.resetState();

		MouseBlock.x = (Math.floor(FlxG.mouse.x / (16 * blockScale)) * (16 * blockScale) + (16 * 1.5));
		MouseBlock.y = (Math.floor(FlxG.mouse.y / (16 * blockScale)) * (16 * blockScale) + 16);
		if (FlxG.mouse.justReleased)
		{
			for (block in worldBlocks)
			{
				if (MouseBlock.overlaps(block))
				{
					block.destroy();
					worldBlocks.remove(block);
					break;
				}
			}
		}
	}

}
