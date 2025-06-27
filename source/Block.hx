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
	public function changeBlock(new_block_tag:String)
	{
		block_tag = new_block_tag;
		loadGraphic(FileManager.getImageFile('blocks/blocks-${new_block_tag.toLowerCase()}'));
	}
}
