package;

typedef WorldSave = {
	var block_data_version:Int;
	var version:String;
	var world_name:String;
	var world:Array<{
		var tag:String;
		var x:Float;
		var y:Float;
	}>;
}