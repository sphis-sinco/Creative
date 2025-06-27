package;

class Block extends FlxSprite
{
	override public function new(Block:String, X:Float, Y:Float)
	{
		super(X, Y);

		loadGraphic(FileManager.getImageFile('blocks/blocks-$Block'));
	}
}
