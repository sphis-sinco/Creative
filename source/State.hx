package;

import flixel.text.FlxText;

class State extends FlxState
{
	var VersionText:FlxText;

	override public function new(premadeVersionText:Bool = false)
	{
		super();

		if (premadeVersionText)
		{
			VersionText = new FlxText(10, 10, 0, 'Creative ' + Version.generateVersionString(true, true, true), 16);
			add(VersionText);
			VersionText.scrollFactor.set(0, 0);
		}
	}
}
