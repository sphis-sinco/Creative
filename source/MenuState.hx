package;

import flixel.addons.ui.FlxButtonPlus;
import flixel.addons.ui.FlxUIDropDownMenu;
import flixel.math.FlxRandom;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class MenuState extends State
{
	public static var btnWidth:Int = 200;

	public var present:String = 'blank';
	public var presents:Array<String> = ['blank', 'inferno'];

	override public function new()
	{
		super(true);
	}

	override function create()
	{
		super.create();

		PlayState.present = '';

		VersionText.text += '\nMade by sphis_sinco';

		var logo:FlxSprite = new FlxSprite(0, 0).loadGraphic(FileManager.getImageFile('logo/logo'));
		add(logo);
		logo.scale.set(1 / 6, 1 / 6);
		logo.screenCenter(X);
		logo.y -= (logo.height / 3);

		var playRegular:FlxButtonPlus = new FlxButtonPlus(0, 0, () ->
		{
			FlxG.switchState(() -> new PlayState());
		}, 'Play (Regular world)', btnWidth);
		add(playRegular);
		playRegular.screenCenter();
		playRegular.scale.set(2, 2);

		var playPresents:FlxButtonPlus = new FlxButtonPlus(0, 0, () ->
		{
			var file = 'assets/templates/$present';

			if (present == 'inferno')
			{
				file = null;
				PlayState.present = present;
			}

			FlxG.switchState(() -> new PlayState(file));
		}, 'Play (World presents)', btnWidth);
		add(playPresents);
		playPresents.screenCenter();
		playPresents.scale.set(2, 2);
		playPresents.y = playRegular.y + playRegular.height + 32;

		var presentsDropDown:FlxUIDropDownMenu = new FlxUIDropDownMenu(playPresents.x + (playPresents.width + 32) * 1.5, playPresents.y,
			FlxUIDropDownMenu.makeStrIdLabelArray(presents), function(present:String)
		{
			this.present = present;
		});
		add(presentsDropDown);

		var Settings:FlxButtonPlus = new FlxButtonPlus(0, 0, () ->
		{
			FlxG.switchState(() -> new SettingsMenu());
		}, 'Settings', btnWidth);
		add(Settings);
		Settings.screenCenter();
		Settings.scale.set(2, 2);
		Settings.y = playPresents.y + playPresents.height + 32;
		// Splash stuffs
		var splashes:Array<String> = FileManager.readFile(FileManager.getDataFile('splash.txt')).split('\n');
		var splashText:FlxText = new FlxText(0, 0, 0, splashes[new FlxRandom().int(0, splashes.length - 1)], 16);
		splashText.color = FlxColor.YELLOW;
		add(splashText);
		splashText.screenCenter();
		splashText.y -= splashText.height * 5;
		trace(splashText.text);

	}
}
