package;

import flixel.addons.ui.FlxButtonPlus;

class SettingsMenu extends FlxState
{
        public static var Settings = {
		auto_gen_block_list: true,
		backup_files: true
        };

        var autoGenerateBlockList:FlxButtonPlus;
	var backupFiles:FlxButtonPlus;

	public static function loadSettings()
	{
		Settings = FileManager.getJSON('settings.json');
	}

        override function create() {
                super.create();

                Settings = FileManager.getJSON('settings.json');

                autoGenerateBlockList = new FlxButtonPlus(80, 20, () ->
		{
			Settings.auto_gen_block_list = !Settings.auto_gen_block_list;
			autoGenerateBlockList.text = 'Auto-generate block list (${Settings.auto_gen_block_list})';
		}, 'Auto-generate block list (${Settings.auto_gen_block_list})',
			MenuState.btnWidth);
		add(autoGenerateBlockList);
                autoGenerateBlockList.scale.set(2, 2);
		backupFiles = new FlxButtonPlus(80, 60, () ->
		{
			Settings.backup_files = !Settings.backup_files;
			backupFiles.text = 'Backup files (${Settings.backup_files})';
		}, 'Backup files (${Settings.backup_files})', MenuState.btnWidth);
		#if sys add(backupFiles); #end
		backupFiles.scale.set(2, 2);
        }

        override function update(elapsed:Float) {
                super.update(elapsed);

                if (FlxG.keys.justReleased.ESCAPE)
                {
                        FileManager.writeToPath('settings.json', Json.stringify(Settings));

                        FlxG.switchState(() -> new MenuState());
                }
        }
        
}