package;

import flixel.addons.ui.FlxUIInputText;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxRandom;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class PlayState extends State
{
	static var backupLocation:String = '';

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

	public static var blocks_og:Array<String> = [
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
		'portal',
	];

	private static var blocks:Array<String> = [];

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

	public static var saveName:FlxUIInputText;
	public static var saveFolder:FlxUIInputText;
	public static var saveMsg:FlxText;

	override public function create():Void
	{
		super.create();
		REQUIRED_PACKS = [];

		var skyBG:String = 'sky';
		skyBG += present != '' ? '-$present' : '';
		trace(skyBG);

		if (!FileManager.exists(FileManager.getImageFile(skyBG)))
			skyBG = 'sky';

		var sky:FlxSprite = new FlxSprite();
		sky.loadGraphic(FileManager.getImageFile(skyBG));
		sky.scale.set(1280, 720);
		add(sky);

		blocks = blocks_og;

		for (wool in wools)
		{
			blocks.push('${wool}_wool');
		}

		for (block in NewBlocks.NEW_BLOCKS)
		{
			blocks.push(block);
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
		saveName = new FlxUIInputText(0, 0, 666, 'save', 16);
		#if sys add(saveName); #end
		saveName.setPosition(verText.x, verText.y + verText.height + 10);

		saveFolder = new FlxUIInputText(0, 0, 666, 'customsaves', 16);
		#if sys add(saveFolder); #end
		saveFolder.setPosition(saveName.x, saveName.y + saveName.height + 10);

		saveMsg = new FlxText(saveFolder.x, saveFolder.y + saveFolder.height + 10, 666, '', 16);
		saveMsg.color = FlxColor.WHITE;
		#if sys add(saveMsg); #end

		add(MouseBlock);
	}

	public static var REQUIRED_PACKS:Array<String> = [];

	#if sys
	function saveWorld(file:String = 'save')
	{
		trace('Saving $file');

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

		var worldNameSplit = file.split('/');
		var world_name = worldNameSplit[worldNameSplit.length - 1];

		var data:WorldSave = {
			block_data_version: 3,
			version: Version.generateVersionString(true, true, true),
			world: worldData,
			world_name: world_name,
			required_packs: REQUIRED_PACKS
		};

		saveMsg.text = 'Saved world to $file.json';
		FileManager.writeToPath('$file.json', Json.stringify(data));
	}

	public static function loadWorld(file:String = 'save')
	{
		trace('loading $file');
		REQUIRED_PACKS = [];
		var data:WorldSave = FileManager.getJSON('$file.json');

		if (Json.stringify(data) == '' || data.world == null)
		{
			saveMsg.text = 'Null data';
			return;
		}

		var packs = data.required_packs.length;
		var curPacks = 0;

		var missingPacks = [];
		for (pack in data.required_packs)
		{
			missingPacks.push(pack);
		}

		var checkERPL:Dynamic = function(pack:String)
		{
			for (packLoc in PackLoader.ENABLED_RESOURCE_PACK_LOCATIONS)
			{
				if (packLoc.split('/')[1] == pack)
				{
					curPacks++;
					trace('Has $pack');
					missingPacks.remove(pack);
				}
			}
		};

		for (pack in data.required_packs)
		{
			trace('Checking for $pack');
			checkERPL(pack);
		}

		if (packs > curPacks)
		{
			saveMsg.text = 'Missing packs $missingPacks';
			return;
		}

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
		if (data.world_name != null)
			saveName.text = data.world_name;
	}
	#end

	var MouseBlock:FlxSprite;

	public static var CurrentBlock:Block;
	public static var CurrentBlockText:FlxText;

	var new_tag:String;
	var new_tag_id:Int = 0;

	var inputText_hasFocus:Bool = false;

	var non_valid_save_names:Array<String> = ['save', '', 'settings'];

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		CurrentBlockText.text = CurrentBlock.block_tag;

		inputText_hasFocus = saveName.hasFocus || saveFolder.hasFocus || PlaystateDebugSubState.commandInput.hasFocus;

		if (new_tag != CurrentBlock.block_tag)
			new_tag = CurrentBlock.block_tag;

		#if debug
		if (FlxG.keys.justReleased.Q && zoom > 0.5 && !inputText_hasFocus)
			zoom -= 0.5;
		else if (FlxG.keys.justReleased.E && zoom < 2 && !inputText_hasFocus)
			zoom += 0.5;

		if (FlxG.keys.justReleased.Z && worldWidth > 1 && !inputText_hasFocus)
			worldWidth -= 1;
		else if (FlxG.keys.justReleased.X && worldWidth < 50 && !inputText_hasFocus)
			worldWidth += 1;

		if (FlxG.keys.anyJustReleased([Q, E, Z, X]) && !inputText_hasFocus)
			FlxG.resetState();
		#end

		if (FlxG.mouse.justReleasedRight && !inputText_hasFocus)
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
		else if (FlxG.mouse.justReleased && !inputText_hasFocus)
		{
			placeBlock();
		}

		if (FlxG.keys.anyJustReleased([LEFT, RIGHT]) && !inputText_hasFocus)
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
		backupLocation = 'backups/${saveFolder.text}/${saveName.text}';

		#if sys
		if (FlxG.keys.justReleased.ESCAPE && !inputText_hasFocus)
		{
			saveWorld('save');
			if (!non_valid_save_names.contains(saveName.text.toLowerCase()))
				saveWorld('${saveFolder.text}/' + saveName.text);
		}
		if (FlxG.keys.justReleased.ENTER && !inputText_hasFocus)
		{
			var path:String = '${saveFolder.text}/' + saveName.text;

			if (FileManager.exists(path + '.json') && !non_valid_save_names.contains(saveName.text.toLowerCase()))
				loadWorld(path);
			else
			{
				saveMsg.text = 'Path "$path" doesn\'t exist ';
			}
		}
		if (FlxG.keys.justReleased.A && !inputText_hasFocus)
		{
			saveWorld(backupLocation);
			FlxG.switchState(() -> new MenuState());
		}
		#else
		if (FlxG.keys.justReleased.ESCAPE && !inputText_hasFocus)
		{
			saveWorld(backupLocation);
			FlxG.switchState(() -> new MenuState());
		}
		#end
		if (FlxG.keys.justReleased.SEVEN && !inputText_hasFocus && verText.visible)
		{
			if (!PlaystateDebugSubState.inited)
				PlaystateDebugSubState.init();

			openSubState(new PlaystateDebugSubState());
		}
		if (FlxG.keys.justReleased.ONE && !inputText_hasFocus)
		{
			verText.visible = !verText.visible;
			CurrentBlock.visible = !CurrentBlock.visible;
			CurrentBlockText.visible = !CurrentBlockText.visible;
			saveName.visible = !saveName.visible;
			saveFolder.visible = !saveFolder.visible;
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
