package resourcepacks;

class PackLoader
{
	/**
	 * Resource Pack Folder
	 */
	public static var RPF:String = 'resourcepacks';

        public static var RESOURCE_PACKS:Array<Pack> = [];
        public static var RESOURCE_PACK_LOCATIONS:Array<String> = [];

        public static function loadResourcePacks() {
                RESOURCE_PACKS = [];
                RESOURCE_PACK_LOCATIONS = [];
		var packlist:String = '';

                #if sys
		var resourcePackFolder = FileManager.readDirectory('$RPF');
                for (item in resourcePackFolder)
                {
                        if (item.contains('.'))
                        {
                                resourcePackFolder.remove(item);
                        }
                }
                trace(resourcePackFolder);
		for (folder in resourcePackFolder)
		{
			if (folder.contains('.'))
				continue;

			var folderCont = FileManager.readDirectory('$RPF/$folder');
			trace('$folder: $folderCont');

			for (item in folderCont)
			{

				var location = '$RPF/$folder/$item';
				if (item == 'pack.json')
				{
					var pack:Pack = FileManager.getJSON(location);

					trace(pack);

					if (pack.pack_format != PackClass.PACK_FORMAT)
						trace('$folder has an outdated pack_format: ${pack.pack_format}');

					RESOURCE_PACKS.push(pack);
					RESOURCE_PACK_LOCATIONS.push(location.replace('/$item', ''));
					packlist += '$item\n';
				}
			}
		}
		NewBlocks.getNewBlocks();
		trace(packlist);
		FileManager.writeToPath('resourcepacks/packlist.txt', packlist);
                #else
                trace('Not SYS');
                #end
        }
        
}