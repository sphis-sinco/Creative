package resourcepacks;

class PackClass {
	public static var PACK_FORMAT:Int = 3;
}

typedef Pack = {
        var name:String;
	var pack_format:Int;
	var ?authors:Array<String>;
}