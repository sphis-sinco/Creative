package;

class Block extends FlxSprite
{
	public var block_tag:String = '';

	override public function new(Block:String, X:Float, Y:Float)
	{
		super(X, Y);

		block_tag = Block;
		changeBlock(block_tag);
		#if BLOCK_TRACES
		trace('New $Block block: $Block at x: $X, y: $Y');
		#end
	}
	public function changeBlock(new_block_tag:String)
	{
		block_tag = new_block_tag;
		var img:String = FileManager.getImageFile('blocks/blocks-${block_tag.toLowerCase()}');
		var json:BlockJson = null;

		var animated:Bool = false;
		var frames:Array<Int> = [];

		if (FileManager.exists(img.replace('png', 'json')))
		{
			json = FileManager.getJSON(img.replace('png', 'json'));
			animated = true;
		}

		loadGraphic(img, animated, 16, 16);

		var i:Int = 0;
		if (animated && json != null)
		{
			while (i < json.frames)
			{
				frames.push(i);
				i++;
			}

			animation.add('animation', frames, json.fps);
			animation.play('animation');
		}
	}
}
typedef BlockJson =
{
	var frames:Int;
	var fps:Float;
}
