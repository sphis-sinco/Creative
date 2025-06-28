package;

import flixel.addons.ui.FlxButtonPlus;
import flixel.text.FlxText;

class MenuState extends FlxState
{
	public static var btnWidth:Int = 200;

	public var present:String = 'blank';
	public var presents:Array<String> = ['blank'];

	override function create()
	{
		super.create();

		var VersionText:FlxText = new FlxText(10, 10, 0, 'Creative ' + Version.generateVersionString(true, true, true), 16);
		add(VersionText);
		VersionText.scrollFactor.set(0, 0);
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

		var playBlank:FlxButtonPlus = new FlxButtonPlus(0, 0, () ->
		{
			FlxG.switchState(() -> new PlayState('assets/templates/$present'));
		}, 'Play (World presents)', btnWidth);
		add(playBlank);
		playBlank.screenCenter();
		playBlank.scale.set(2, 2);
		playBlank.y = playRegular.y + playRegular.height + 32;

		var Settings:FlxButtonPlus = new FlxButtonPlus(0, 0, () ->
		{
			FlxG.switchState(() -> new SettingsMenu());
		}, 'Settings', btnWidth);
		add(Settings);
		Settings.screenCenter();
		Settings.scale.set(2, 2);
		Settings.y = playBlank.y + playBlank.height + 32;
	}
}
