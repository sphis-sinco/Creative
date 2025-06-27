package;

class MenuState extends FlxState
{
        override function create() {
                super.create();

                var logo:FlxSprite = new FlxSprite(0,0).loadGraphic(FileManager.getImageFile('logo/logo'));
                add(logo);
                logo.screenCenter();
                logo.y -= logo.height * 2;
        }
}