package resourcepacks;

class PackLoader
{
	/**
	 * Resource Pack Folder
	 */
	public static var RPF:String = 'resourcepacks';

	public static var RESOURCE_PACKS:Array<Pack> = [];
	public static var RESOURCE_PACK_LOCATIONS:Array<String> = [];

	public static var ENABLED_RESOURCE_PACKS:Array<Pack> = [];
	public static var ENABLED_RESOURCE_PACK_LOCATIONS:Array<String> = [];

	public static function loadResourcePacks()
	{
		RESOURCE_PACKS = [];
		RESOURCE_PACK_LOCATIONS = [];

		var existingPacklist:Array<String> = FileManager.readFile('resourcepacks/packlist.txt').split('\n');

		#if sys
		var resourcePackFolder = FileManager.readDirectory('$RPF');
		for (item in resourcePackFolder)
		{
			if (!FileSystem.isDirectory('$RPF/' + item))
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

					if (!RESOURCE_PACK_LOCATIONS.contains('$RPF/$folder') && !RESOURCE_PACKS.contains(pack))
					{
						RESOURCE_PACKS.push(pack);
						RESOURCE_PACK_LOCATIONS.push(location.replace('/$item', ''));
					}

					if (existingPacklist != null)
					{
						for (modpack in existingPacklist)
						{
							if (modpack == folder)
							{
								ENABLED_RESOURCE_PACKS.push(pack);
								ENABLED_RESOURCE_PACK_LOCATIONS.push(location.replace('/$item', ''));
								break;
							}
						}
					}
					else if (modsEnabledByDefault)
					{
						if (!ENABLED_RESOURCE_PACK_LOCATIONS.contains('$RPF/$folder') && !ENABLED_RESOURCE_PACKS.contains(pack))
						{
							ENABLED_RESOURCE_PACKS.push(pack);
							ENABLED_RESOURCE_PACK_LOCATIONS.push(location.replace('/$item', ''));
						}
					}
				}
			}
		}
		NewBlocks.getNewBlocks();
		genPacklist();
		#else
		trace('Not SYS');
		#end
	}

	static var modsEnabledByDefault:Bool = false;

	public static function genPacklist()
	{
		var packlist:String = '';
		var i = 0;
		for (mod in ENABLED_RESOURCE_PACK_LOCATIONS)
		{
			var folder = mod.split('/')[1];

			if (!packlist.contains(folder))
				packlist += '$folder\n';
			i++;
		}
		trace(packlist);
		FileManager.writeToPath('resourcepacks/packlist.txt', packlist);
	}
}
