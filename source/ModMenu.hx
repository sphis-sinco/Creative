package;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class ModMenu extends FlxState
{
	// Base: https://github.com/FunkinCrew/Funkin/blob/985bd5374bdf55ffc8ba501c688e6fc54ad5cb09/source/ModdingSubstate.hx
	var grpMods:FlxTypedGroup<ModMenuItem>;
	var enabledMods:Array<String> = [];
	var modFolders:Array<String> = [];

	var curSelected:Int = 0;

	var camFollow:FlxObject;

	public function new():Void
	{
		super();

		grpMods = new FlxTypedGroup<ModMenuItem>();
		add(grpMods);

		refreshModList();
		getModById = function(id:String, func:Dynamic)
		{
			var i = 0;
			for (mod in PackLoader.RESOURCE_PACK_LOCATIONS)
			{
				if (mod.split('/')[1] == id)
				{
					modA = mod;
					iA = i;
					func(modA, iA);
					trace(mod.split('/')[1]);
					break;
				}

				i++;
			}
		};
	}

	override function create()
	{
		super.create();

		camFollow = new FlxObject(0, -400, 1280, 720);
		add(camFollow);

		FlxG.camera.follow(camFollow, LOCKON, 0.1);
		FlxG.camera.focusOn(camFollow.getPosition());
	}

	var modA = '';
	var iA = 0;
	var getModById:Dynamic;

	override function update(elapsed:Float)
	{
		if (FlxG.keys.justPressed.R)
			refreshModList();

		selections();

		if (FlxG.keys.justReleased.UP)
			selections(-1);
		if (FlxG.keys.justReleased.DOWN)
			selections(1);

		if (FlxG.keys.justPressed.SPACE)
		{
			grpMods.members[curSelected].modEnabled = !grpMods.members[curSelected].modEnabled;

			if (!grpMods.members[curSelected].modEnabled)
			{
				getModById(grpMods.members[curSelected].text, () ->
				{
					PackLoader.ENABLED_RESOURCE_PACK_LOCATIONS.remove(modA);
					PackLoader.ENABLED_RESOURCE_PACKS.remove(PackLoader.ENABLED_RESOURCE_PACKS[iA]);
				});
			}
			else
			{
				getModById(grpMods.members[curSelected].text, () ->
				{
					PackLoader.ENABLED_RESOURCE_PACK_LOCATIONS.push(modA);
					PackLoader.ENABLED_RESOURCE_PACKS.push(PackLoader.RESOURCE_PACKS[iA]);
				});
			}

			NewBlocks.getNewBlocks();
			PackLoader.genPacklist();
		}

		/* if (FlxG.keys.justPressed.I && curSelected != 0)
			{
				var oldOne = grpMods.members[curSelected - 1];
				grpMods.members[curSelected - 1] = grpMods.members[curSelected];
				grpMods.members[curSelected] = oldOne;
				selections(-1);
			}

			if (FlxG.keys.justPressed.K && curSelected < grpMods.members.length - 1)
			{
				var oldOne = grpMods.members[curSelected + 1];
				grpMods.members[curSelected + 1] = grpMods.members[curSelected];
				grpMods.members[curSelected] = oldOne;
				selections(1);
		}*/

		if (FlxG.keys.justReleased.ESCAPE)
		{
			FlxG.switchState(() -> new MenuState());
		}

		super.update(elapsed);
	}

	private function selections(change:Int = 0):Void
	{
		curSelected += change;

		if (curSelected >= modFolders.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = modFolders.length - 1;

		for (txt in 0...grpMods.length)
		{
			if (txt == curSelected)
			{
				grpMods.members[txt].color = FlxColor.YELLOW;
				camFollow.y = -400 + grpMods.members[txt].y;
			}
			else
				grpMods.members[txt].color = FlxColor.WHITE;
		}


		organizeByY();
	}

	private function refreshModList():Void
	{
		while (grpMods.members.length > 0)
		{
			grpMods.remove(grpMods.members[0], true);
		}

		#if desktop
		modFolders = [];

		for (file in FileSystem.readDirectory('${PackLoader.RPF}'))
		{
			if (FileSystem.isDirectory('${PackLoader.RPF}/' + file))
				modFolders.push(file);
		}

		enabledMods = [];

		for (mod in FileManager.readFile('${PackLoader.RPF}/packlist.txt').split('\n'))
		{
			enabledMods.push(mod);
		}

		var loopNum:Int = 0;
		for (i in modFolders)
		{
			var txt:ModMenuItem = new ModMenuItem(0, 10 + (40 * loopNum), 0, i, 32);
			txt.text = i;
			txt.modEnabled = enabledMods[loopNum] == txt.text;
			grpMods.add(txt);

			loopNum++;
		}
		#end
	}

	private function organizeByY():Void
	{
		for (i in 0...grpMods.length)
		{
			grpMods.members[i].y = 10 + (40 * i);
		}
	}
}

class ModMenuItem extends FlxText
{
	public var modEnabled:Bool = false;
	public var daMod:String;

	public function new(x:Float, y:Float, w:Float, str:String, size:Int)
	{
		super(x, y, w, str, size);
	}

	override function update(elapsed:Float)
	{
		if (modEnabled)
			alpha = 1;
		else
			alpha = 0.5;

		super.update(elapsed);
	}
}
