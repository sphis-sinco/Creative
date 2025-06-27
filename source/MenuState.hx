package;

class MenuState extends FlxState
{
        override function create() {
                super.create();

		var logo:FlxSprite = new FlxSprite(0, 32).loadGraphic(FileManager.getImageFile('logo/logo'));
                add(logo);
		logo.scale.set(1 / 8, 1 / 8);
		logo.screenCenter(X);
        }
}