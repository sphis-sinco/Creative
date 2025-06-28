package resourcepacks;

class PackLoader
{
        public static var RESOURCE_PACKS:Array<Pack> = [];
        public static var RESOURCE_PACK_LOCATIONS:Array<String> = [];

        public static function loadResourcePacks() {
                RESOURCE_PACKS = [];
                RESOURCE_PACK_LOCATIONS = [];

                #if sys
                var resourcePackFolder = FileManager.readDirectory('resourcepacks');
                for (item in resourcePackFolder)
                {
                        if (item.contains('.'))
                        {
                                resourcePackFolder.remove(item);
                        }
                }
                trace(resourcePackFolder);
                #else
                trace('Not SYS');
                #end
        }
        
}