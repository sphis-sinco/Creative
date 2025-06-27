package;

import flixel.addons.ui.FlxButtonPlus;
import flixel.text.FlxText;
import flixel.ui.FlxButton;

class MenuState extends FlxState
{
        override function create() {
                super.create();

		var VersionText:FlxText = new FlxText(10, 10, 0, 'Creative ' + Version.generateVersionString(true, true, true), 16);
		add(VersionText);
		VersionText.scrollFactor.set(0, 0);

		var logo:FlxSprite = new FlxSprite(0, 0).loadGraphic(FileManager.getImageFile('logo/logo'));
                add(logo);
		logo.scale.set(1 / 6, 1 / 6);
		logo.screenCenter(X);
		logo.y -= (logo.height / 3);

		var playRegular:FlxButtonPlus = new FlxButtonPlus(0, 0, () ->
		{
			FlxG.switchState(() -> new PlayState());
		}, 'Play (Regular world)', 125);
		add(playRegular);
		playRegular.screenCenter();
		playRegular.scale.set(2, 2);

		var playBlank:FlxButtonPlus = new FlxButtonPlus(0, 0, () ->
		{
			FlxG.switchState(() -> new PlayState('assets/templates/blank'));
		}, 'Play (Blank world)');
		add(playBlank);
		playBlank.screenCenter();
		playBlank.scale.set(2, 2);
		playBlank.y += playRegular.height + 32;
        }
}