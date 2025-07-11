package;

class Version {
        public static var MajorVersion:Int = 0;
	public static var MinorVersion:Int = 4;
	public static var PatchVersion:Int = 0;
	public static var HotfixVersion:Int = 2;
        public static var Suffix:String = '';

        public static function generateVersionString(patch:Bool, hotfix:Bool, suffix:Bool)
        {
                var versionString:String = 'v${MajorVersion}.${MinorVersion}';
		versionString += '${patch ? '.${PatchVersion}' : ''}${hotfix && HotfixVersion > 0 ? '_${HotfixVersion > 9 ? '' : '0'}${HotfixVersion}' : ''}';
                if (suffix)
                        versionString += Suffix;

                return versionString;
        }
}