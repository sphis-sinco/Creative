package;

import flixel.addons.ui.FlxUIInputText;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class PlaystateDebugSubState extends FlxSubState
{
	public static var inited:Bool = false;

	static var WorldWidthText:FlxText;
	static var WorldHeightText:FlxText;

	public static var commandInput:FlxUIInputText;
	public static var commandOutput:FlxText;

	public static function init() {
		WorldWidthText = new FlxText(0,0, 0, '', 16);
		WorldHeightText = new FlxText(0,0, 0, '', 16);

		WorldWidthText.scrollFactor.set(0, 0);
		WorldHeightText.scrollFactor.set(0, 0);

		commandInput = new FlxUIInputText(0, 0, 666, 16);

		commandOutput = new FlxText(0, 0, 666, '', 16);
		commandOutput.color = FlxColor.WHITE;

		inited = true;
	}

        override function create() {
                super.create();

		var black:FlxSprite = new FlxSprite();
		black.loadGraphic(FileManager.getImageFile('black'));
		black.scale.set(1280,720);
		black.alpha = 0.5;
		add(black);

		WorldWidthText.setPosition(10, 10 + PlayState.VersionText.y + PlayState.VersionText.height);
		WorldHeightText.setPosition(10, 10 + WorldWidthText.y + WorldWidthText.height);

		WorldWidthText.text = 'World width: ' + Std.string(PlayState.worldWidth);
		WorldHeightText.text = 'World height: ' + Std.string(PlayState.worldHeight);

		add(WorldWidthText);
		add(WorldHeightText);

		add(commandInput);
		add(commandOutput);

        }

        override function update(elapsed:Float) {
                super.update(elapsed);

                
		PlayState.TYPING = commandInput.hasFocus;
		commandInput.setPosition(PlayState.CurrentBlockText.x + PlayState.CurrentBlockText.width + 10, PlayState.CurrentBlockText.y);
		commandOutput.setPosition(commandInput.x, commandInput.y + commandInput.height + 10);

		
		if (FlxG.keys.justReleased.ENTER && PlaystateDebugSubState.commandInput.hasFocus)
		{
			PlayState.commandInputed();
		}
		if (PlaystateDebugSubState.commandInput.hasFocus)
		{
			PlaystateDebugSubState.commandOutput.text = 'resetState, resetGame, setworld PATH, clearworld, regenworld, setSelection BLOCK_TAG';
		}

		if (FlxG.keys.justReleased.SEVEN && !PlaystateDebugSubState.commandInput.hasFocus)
		{
			PlaystateDebugSubState.inited = false;
			close();
		}
        }
}