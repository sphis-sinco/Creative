package;

import flixel.addons.ui.FlxButtonPlus;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxRandom;
import flixel.text.FlxText;

class PlayState extends FlxState
{
	public static var blockScale:Int = 2;

	public static var worldWidth:Int = 39;
	public static var worldHeight:Int = 22;

	public static var zoom:Float = 1.0;

	public var worldLayers = {
		'grass': 11,
		'dirt': 10,
		'dirt_offset_min': 0,
		'dirt_offset_max': 3,
		'stone': 8,
	};

	public var blocks:Array<String> = ['stone', 'grass', 'dirt'];
	public var wools:Array<String> = [
		'red', 'orange', 'yellow', 'green', 'lime', 'cyan', 'blue', 'purple', 'pink', 'brown', 'gray', 'white', 'black'
	];

	public var worldBlocks:FlxTypedGroup<Block> = new FlxTypedGroup<Block>();

	public function worldRender()
	{
		#if WORLD_RENDERING_TRACES
		trace('worldRender');
		#end
		for (block in worldBlocks)
		{
			block.x += block.width * 1.5;
			block.y += block.height;
		}
	}

	public function worldInit()
	{
		#if WORLD_RENDERING_TRACES
		trace('worldInit');
		#end

		if (worldBlocks.length > 0)
		{
			for (block in worldBlocks)
			{
				block.destroy();
				worldBlocks.remove(block, true);
			}
		}

		var x:Int = 0;
		var y:Int = 0;

		while (y < worldHeight)
		{
			while (x < worldWidth)
			{
				blockSpawn(x, y);
				x++;
			}
			y++;
			x = 0;
		}

		worldRender();
	}

	public function blockSpawn(x:Float, y:Float)
	{
		#if WORLD_RENDERING_TRACES
		trace('$x|$y');
		#end
		var block_tag:String = 'air';

		if (y > worldHeight - worldLayers.grass)
			block_tag = 'grass';
		final dirtRandom:Int = new FlxRandom().int(worldLayers.dirt_offset_min, worldLayers.dirt_offset_max);
		if (y > worldHeight - (worldLayers.dirt))
			block_tag = 'dirt';
		if (y > worldHeight - (worldLayers.stone - dirtRandom))
			block_tag = 'stone';

		var block:Block = new Block(block_tag, 0, 0);
		block.scale.set(blockScale, blockScale);
		block.setPosition(x * (x > 0 ? (blockScale * block.width) : 1), y * (y > 0 ? (blockScale * block.height) : 1));

		if (block_tag != 'air')
			worldBlocks.add(block);
	}

	override public function create():Void
	{
		super.create();

		for (wool in wools)
		{
			blocks.push('${wool}_wool');
		}

		#if sys
		var blocksArr:Array<String> = FileManager.readDirectory('assets/images/blocks');

		if (blocksArr.length > 0)
		{
			blocks = [];
			for (block in blocksArr)
			{
				blocks.push(block.replace('blocks-', '').replace('.png', ''));
			}

			blocks.remove('air');
			blocks.remove('blocks.aseprite');

			trace(blocks);
		}
		#end

		var VersionText:FlxText = new FlxText(10, 10, 0, 'Creative ' + Version.generateVersionString(true, true, true), 16);
		add(VersionText);
		VersionText.scrollFactor.set(0, 0);
		#if debug
		WorldWidthText = new FlxText(10, 10 + VersionText.y + VersionText.height, 0, 'World width: ' + Std.string(worldWidth), 16);
		WorldHeightText = new FlxText(10, 10 + WorldWidthText.y + WorldWidthText.height, 0, 'World height: ' + Std.string(worldHeight), 16);

		WorldWidthText.scrollFactor.set(0, 0);
		WorldHeightText.scrollFactor.set(0, 0);

		add(WorldWidthText);
		add(WorldHeightText);
		#end

		FlxG.camera.zoom = zoom;

		MouseBlock = new MouseBlock(0, 0);
		MouseBlock.scale.set(blockScale, blockScale);

		worldInit();
		add(worldBlocks);
		CurrentBlock = new Block('stone', VersionText.x + VersionText.width + 10, 10);
		CurrentBlock.scale.set(blockScale, blockScale);
		add(CurrentBlock);

		CurrentBlockText = new FlxText(CurrentBlock.x + CurrentBlock.width + 10, CurrentBlock.y, 0, 'stone', 16);
		add(CurrentBlockText);

		add(MouseBlock);
	}

	#if sys
	function saveWorld()
	{
		var worldData = [];

		for (block in worldBlocks)
		{
			var data = {
				x: block.x,
				y: block.y,
				tag: block.block_tag
			}

			worldData.push(data);
		}

		var data:WorldSave = {
			block_data_version: 3,
			version: Version.generateVersionString(true, true, true),
			world: worldData
		};

		#if desktop
		FileManager.writeToPath('save.json', Json.stringify(data));
		#end
	}

	function loadWorld()
	{
		var data:WorldSave = #if desktop FileManager.getJSON('save.json'); #end

		if (Json.stringify(data) == '' || data.world == null)
			return;

		if (worldBlocks.length > 0)
		{
			for (block in worldBlocks)
			{
				block.destroy();
				worldBlocks.remove(block);
			}
		}

		for (blockData in data.world)
		{
			var block:Block = new Block(blockData.tag, blockData.x, blockData.y);
			block.scale.set(blockScale, blockScale);

			worldBlocks.add(block);
		}
	}
	#end

	var WorldWidthText:FlxText;
	var WorldHeightText:FlxText;

	var MouseBlock:FlxSprite;

	var CurrentBlock:Block;
	var CurrentBlockText:FlxText;

	var new_tag:String;
	var new_tag_id:Int = 0;

	var saveWorldButton:FlxButtonPlus;

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		CurrentBlockText.text = CurrentBlock.block_tag;

		if (new_tag != CurrentBlock.block_tag)
			new_tag = CurrentBlock.block_tag;

		#if debug
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
		#end

		if (FlxG.mouse.justReleasedRight)
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
		else if (FlxG.mouse.justReleased)
		{
			placeBlock();
		}

		if (FlxG.keys.anyJustReleased([LEFT, RIGHT]))
		{
			var i:Int = 0;
			for (block in blocks)
			{
				if (block == new_tag)
				{
					new_tag_id = i;
				}
				i++;
			}

			if (FlxG.keys.justReleased.LEFT)
			{
				new_tag_id--;
			}
			else if (FlxG.keys.justReleased.RIGHT)
			{
				new_tag_id++;
			}

			if (new_tag_id < 0)
				new_tag_id = blocks.length - 1;
			else if (new_tag_id > blocks.length - 1)
				new_tag_id = 0;
			trace(new_tag_id);

			new_tag = blocks[new_tag_id];
			CurrentBlock.changeBlock(new_tag);
		}
		#if sys
		if (FlxG.keys.justReleased.ESCAPE)
			saveWorld();
		if (FlxG.keys.justReleased.ENTER)
			loadWorld();
		#end
	}

	public function placeBlock()
	{
		var blocked:Bool = false;
		var placed:Bool = false;
		var x:Int = 0;

		var y:Int = 0;

		while (y < worldHeight)
		{
			while (x < worldWidth)
			{
				for (block in worldBlocks)
				{
					if (MouseBlock.overlaps(block))
					{
						#if BLOCK_TRACES
						trace('${block.block_tag} block in the way');
						#end
						blocked = true;
						placed = false;
						break;
					}
					else
					{
						placed = true;
					}
				}

				x++;

				if (blocked || placed)
					break;
			}
			y++;
			x = 0;
			if (blocked || placed)
				break;
		}

		if (!blocked && placed)
		{
			var block:Block = new Block(CurrentBlock.block_tag, 0, 0);
			block.scale.set(blockScale, blockScale);
			block.setPosition(MouseBlock.x, MouseBlock.y);
			worldBlocks.add(block);
		}
	}
}
