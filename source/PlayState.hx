package;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxRandom;
import flixel.text.FlxText;

class PlayState extends State
{
	static var initedWorldBlocks = false;

	public static var TYPING:Bool = false;

	public static var present:String = '';

	var randomWorld:Bool = true;

	override public function new(?file:String)
	{
		super();

		#if sys
		if (file != null)
		{
			randomWorld = false;
			trace('non-randomWorld');
			loadWorld(file);
		}
		#end
		if (!PlaystateDebugSubState.inited)
		{
			PlaystateDebugSubState.init();
		}
	}

	public static var blockScale:Int = 2;

	public static var worldWidth:Int = 39;
	public static var worldHeight:Int = 22;

	public static var zoom:Float = 1.0;

	public static var worldLayers = {
		'grass': 11,
		'dirt': 10,
		'dirt_offset_min': 0,
		'dirt_offset_max': 3,
		'stone': 8,
		// inferno
		'inferno_dirt': 15,
		'inferno_dirt_offset_min': 0,
		'inferno_dirt_offset_max': 10,
		'inferno': 12,
		'inferno_lava': 2,
	};

	public static var blocks:Array<String> = [
		'stone',
		'grass',
		'dirt',
		'inferno',
		'inferno_dirt',
		'tree_log_front',
		'tree_log_side',
		'tree_log_side_vertical',
		'plank',
		'door_top',
		'door_bottom',
		'lava',
		'gold',
		'iron',
		'diamond',
		'emerald',
		'gold_ore',
		'iron_ore',
		'diamond_ore',
		'emerald_ore',
		'rainbow',
	];
	public var wools:Array<String> = [
		'red', 'orange', 'yellow', 'green', 'lime', 'cyan', 'blue', 'purple', 'pink', 'brown', 'gray', 'white', 'black'
	];

	public static var worldBlocks:FlxTypedGroup<Block>;

	public static function worldRender()
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

	public static function worldInit()
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

	public static function blockSpawn(x:Float, y:Float)
	{
		#if WORLD_RENDERING_TRACES
		trace('$x|$y');
		#end
		var block_tag:String = 'air';

		if (present == 'inferno')
		{
			final dirtRandom:Int = new FlxRandom().int(worldLayers.inferno_dirt_offset_min, worldLayers.inferno_dirt_offset_max);
			if (y > worldHeight - (worldLayers.inferno_dirt + FlxMath.roundDecimal(dirtRandom / 2, 0)))
				block_tag = 'inferno_dirt';
			if (y > worldHeight - (worldLayers.inferno - dirtRandom))
				block_tag = 'inferno';
			if (y > worldHeight - (worldLayers.inferno_lava))
				block_tag = 'lava';
		}
		else
		{
			if (y > worldHeight - worldLayers.grass)
				block_tag = 'grass';
			final dirtRandom:Int = new FlxRandom().int(worldLayers.dirt_offset_min, worldLayers.dirt_offset_max);
			if (y > worldHeight - (worldLayers.dirt))
				block_tag = 'dirt';
			if (y > worldHeight - (worldLayers.stone - dirtRandom))
				block_tag = 'stone';
		}

		var block:Block = new Block(block_tag, 0, 0);
		block.scale.set(blockScale, blockScale);
		block.setPosition(x * (x > 0 ? (blockScale * block.width) : 1), y * (y > 0 ? (blockScale * block.height) : 1));

		if (block_tag != 'air')
			worldBlocks.add(block);
	}

	public static var verText:FlxText;

	override public function create():Void
	{
		super.create();

		var skyBG:String = 'sky';
		skyBG += present != '' ? '-$present' : '';
		trace(skyBG);

		if (!FileManager.exists(FileManager.getImageFile(skyBG)))
			skyBG = 'sky';

		var sky:FlxSprite = new FlxSprite();
		sky.loadGraphic(FileManager.getImageFile(skyBG));
		sky.scale.set(1280, 720);
		add(sky);

		for (wool in wools)
		{
			blocks.push('${wool}_wool');
		}

		#if sys
		if (SettingsMenu.Settings.auto_gen_block_list)
		{
			var blocksArr:Array<String> = FileManager.readDirectory('assets/images/blocks');

			if (blocksArr.length > 0)
			{
				blocks = [];
				for (block in blocksArr)
				{
					if (block.endsWith('.png'))
						blocks.push(block.replace('blocks-', '').replace('.png', ''));
				}

				blocks.remove('air');

				#if BLOCK_TRACES
				trace(blocks);
				#end
			}
		}
		#end

		verText = new FlxText(10, 10, 0, 'Creative '
			+ #if sys '(sys, press A to leave)' #else '(not sys, press ESCAPE to leave)' #end
			+ ' ${SLGame.isDebug ? '(Debug)' : ''} '
			+ Version.generateVersionString(true, true, true), 16);
		add(verText);
		verText.scrollFactor.set(0, 0);



		FlxG.camera.zoom = zoom;

		MouseBlock = new MouseBlock(0, 0);
		MouseBlock.scale.set(blockScale, blockScale);

		worldBlocks = new FlxTypedGroup<Block>();
		add(worldBlocks);
		if (randomWorld)
		{
			worldInit();
			initedWorldBlocks = true;
		}
		CurrentBlock = new Block('stone', verText.x + verText.width + 10, 10);
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

		if (worldBlocks.length > 0)
		{
			for (block in worldBlocks)
			{
				var data = {
					x: block.x,
					y: block.y,
					tag: block.block_tag
				}

				worldData.push(data);
			}
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

	public static function loadWorld(file:String = 'save')
	{
		var data:WorldSave = #if desktop FileManager.getJSON('$file.json'); #end

		if (Json.stringify(data) == '' || data.world == null)
			return;

		if (!initedWorldBlocks)
			for (block in worldBlocks)
				block.destroy();
		worldBlocks.clear();

		for (blockData in data.world)
		{
			var block:Block;

			// if (data.version == '0.3.0')
			block = new Block(blockData.tag, blockData.x, blockData.y);

			block.scale.set(blockScale, blockScale);
			worldBlocks.add(block);
		}
	}
	#end

	var MouseBlock:FlxSprite;

	public static var CurrentBlock:Block;
	public static var CurrentBlockText:FlxText;

	var new_tag:String;
	var new_tag_id:Int = 0;

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		CurrentBlockText.text = CurrentBlock.block_tag;

		if (new_tag != CurrentBlock.block_tag)
			new_tag = CurrentBlock.block_tag;

		#if debug
		if (FlxG.keys.justReleased.Q && zoom > 0.5 && !PlaystateDebugSubState.commandInput.hasFocus)
			zoom -= 0.5;
		else if (FlxG.keys.justReleased.E && zoom < 2 && !PlaystateDebugSubState.commandInput.hasFocus)
			zoom += 0.5;

		if (FlxG.keys.justReleased.Z && worldWidth > 1 && !PlaystateDebugSubState.commandInput.hasFocus)
			worldWidth -= 1;
		else if (FlxG.keys.justReleased.X && worldWidth < 50 && !PlaystateDebugSubState.commandInput.hasFocus)
			worldWidth += 1;

		if (FlxG.keys.anyJustReleased([Q, E, Z, X]) && !PlaystateDebugSubState.commandInput.hasFocus)
			FlxG.resetState();
		#end

		if (FlxG.mouse.justReleasedRight && !PlaystateDebugSubState.commandInput.hasFocus)
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
		else if (FlxG.mouse.justReleased && !PlaystateDebugSubState.commandInput.hasFocus)
		{
			placeBlock();
		}

		if (FlxG.keys.anyJustReleased([LEFT, RIGHT]) && !PlaystateDebugSubState.commandInput.hasFocus)
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
			// trace(new_tag_id);

			new_tag = blocks[new_tag_id];
			CurrentBlock.changeBlock(new_tag);
		}
		#if sys
		if (FlxG.keys.justReleased.ESCAPE && !PlaystateDebugSubState.commandInput.hasFocus)
			saveWorld();
		if (FlxG.keys.justReleased.ENTER && !PlaystateDebugSubState.commandInput.hasFocus)
			loadWorld();
		if (FlxG.keys.justReleased.A && !PlaystateDebugSubState.commandInput.hasFocus)
			FlxG.switchState(() -> new MenuState());
		#else
		if (FlxG.keys.justReleased.ESCAPE && !PlaystateDebugSubState.commandInput.hasFocus)
			FlxG.switchState(() -> new MenuState());
		#end
		if (FlxG.keys.justReleased.SEVEN)
		{
			if (!PlaystateDebugSubState.inited)
				PlaystateDebugSubState.init();

			openSubState(new PlaystateDebugSubState());
		}
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

	public static function commandInputed()
	{
		var args = PlaystateDebugSubState.commandInput.text.toLowerCase().split(' ');
		PlaystateDebugSubState.commandInput.text = '';
		PlaystateDebugSubState.commandInput.hasFocus = false;

		PlaystateDebugSubState.commandOutput.text = '';

		switch (args[0])
		{
			case 'resetstate':
				FlxG.resetState();
			case 'resetgame':
				FlxG.resetGame();
			case 'setworld':
				if (args[1] != null)
				{
					if (FileManager.exists(args[1]) || args[1] == 'inferno')
					{
						present = '';
						if (args[1] == 'inferno')
						{
							present = args[1];
							FlxG.switchState(() -> new PlayState());
						}
						else
							FlxG.switchState(() -> new PlayState(args[1]));
					}
					else
						PlaystateDebugSubState.commandOutput.text = 'Path doesn\'t exist';
				}
				else
					PlaystateDebugSubState.commandOutput.text = 'Path required';
			case 'clearworld':
				for (block in worldBlocks)
					block.destroy();
				worldBlocks.clear();
			case 'regenworld':
				for (block in worldBlocks)
					block.destroy();
				worldBlocks.clear();
				worldInit();
			case 'setselection':
				if (args[1] != null)
					if (blocks.contains(args[1].toLowerCase()))
						CurrentBlock.changeBlock(args[1].toLowerCase());
					else
						PlaystateDebugSubState.commandOutput.text = 'Block doesn\'t exist';
				else
					PlaystateDebugSubState.commandOutput.text = 'Block required';

			default:
				PlaystateDebugSubState.commandOutput.text = 'Unknown command: "${args[0]}"';
		}
		CurrentBlockText.text = CurrentBlock.block_tag;
	}
}
