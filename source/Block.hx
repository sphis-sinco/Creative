package;

class Block extends FlxSprite
{
	public var block_tag:String = '';

	override public function new(Block:String, X:Float, Y:Float)
	{
		super(X, Y);

		block_tag = Block;
		loadGraphic(FileManager.getImageFile('blocks/blocks-${Block.toLowerCase()}'));
		#if BLOCK_TRACES
		trace('New $Block block: $Block at x: $X, y: $Y');
		#end
	}
}
