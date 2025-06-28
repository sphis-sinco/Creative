package;

class Block extends FlxSprite
{
	public var block_tag:String = '';
	public var block_prefix:String = 'blocks';

	override public function new(Block:String, X:Float, Y:Float, Custom_Path:Bool = false, custom_path_string:String = '')
	{
		super(X, Y);

		block_tag = Block;
		changeBlock(block_tag, Custom_Path, custom_path_string);
		#if BLOCK_TRACES
		trace('New $Block block: $Block at x: $X, y: $Y');
		#end
	}
	public function changeBlock(new_block_tag:String, custom_path:Bool = false, custom_path_string:String = '')
	{
		var cp = custom_path;
		var cps = custom_path_string;
		block_tag = new_block_tag;
		if (NewBlocks.NEW_BLOCKS.contains(block_tag))
		{
			cp = true;
			var i = 0;
			for (block in NewBlocks.NEW_BLOCKS)
			{
				if (block_tag == block)
				{
					block_prefix = NewBlocks.NEW_BLOCK_PREFIXES[i];
					cps = NewBlocks.NEW_BLOCK_MOD_NAMES[i];
				}
				i++;
			}
		}

		var img:String = FileManager.getImageFile('blocks/$block_prefix-${block_tag.toLowerCase()}');
		if (cp)
			img = '$cps/blocks/$block_prefix-${block_tag.toLowerCase()}.png';
		var json:BlockJson = null;

		block_prefix = 'blocks';

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
