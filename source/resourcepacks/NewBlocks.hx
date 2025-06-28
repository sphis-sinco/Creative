package resourcepacks;

class NewBlocks
{
	public static var NEW_BLOCKS:Array<String> = [''];
	public static var NEW_BLOCK_PREFIXES:Array<String> = [''];
	public static var NEW_BLOCK_MOD_NAMES:Array<String> = [''];

	public static function getNewBlocks()
	{
		NEW_BLOCKS = [];
		NEW_BLOCK_PREFIXES = [];
		NEW_BLOCK_MOD_NAMES = [];

		for (pack in PackLoader.ENABLED_RESOURCE_PACK_LOCATIONS)
		{
			var blocks:Array<String> = FileManager.readDirectory(pack + '/blocks');

			for (block in blocks)
			{
				if (block.endsWith('.png'))
				{
					NEW_BLOCKS.push(block.split('.png')[0].split('-')[1]);
                                        NEW_BLOCK_PREFIXES.push(block.split('-')[0]);
					NEW_BLOCK_MOD_NAMES.push(pack);
				}
			}
		}

		trace(NEW_BLOCKS);
		trace(NEW_BLOCK_PREFIXES);
		trace(NEW_BLOCK_MOD_NAMES);
	}
}
