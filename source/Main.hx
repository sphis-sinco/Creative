package;

import openfl.display.Sprite;

class Main extends Sprite
{
	public function new():Void
	{
		super();
		addChild(new FlxGame(0, 0, MenuState));
		trace(Version.generateVersionString(true, true, true));
		PackLoader.loadResourcePacks();
		SettingsMenu.loadSettings();
	}
}
