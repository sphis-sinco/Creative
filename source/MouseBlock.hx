package;

class MouseBlock extends FlxSprite
{
	override public function new(X:Float, Y:Float)
	{
		super(X, Y);

		loadGraphic(FileManager.getImageFile('outline'));
	}

        override function update(elapsed:Float) {
                super.update(elapsed);

                x = (Math.floor(FlxG.mouse.x / (16 * PlayState.blockScale)) * (16 * PlayState.blockScale) + (16 * 1.5));
		y = (Math.floor(FlxG.mouse.y / (16 * PlayState.blockScale)) * (16 * PlayState.blockScale) + 16);
        }
}
