# 2025-06-27
## 0.3.0
- .community folder for community stuff
- PlayState auto-block-list generation doesn't include any files that aren't a png
- Added animated block support via a simple json file (example with the [new lava animated block](./assets/images/blocks/blocks-lava.json))
- Added several new blocks
- Added a inferno world present playable through the main menu
- Added present list dropdown to the mainmenu to select other presents when they are added
- Removed new_tag_id trace
- Added Auto-generate block list option
- Added SettingsMenu
- In PlayState the array of blocks generated from the blocks image folder trace now required the BLOCK_TRACES conditional
- In PlayState it displays the control to leave the state
- In PlayState it displays if you support sys
- In PlayState it displays if you are in debug
- In PlayState you can leave to the MenuState by pressing A or ESCAPE
- Added a blank world present playable through the main menu
- When loading a world you can now add an optional argument to load a specific file
- Removed FlxButtonPlus from PlayState
- Added 'flixel-ui' library
- Added main menu with a logo

## 0.2.3
- There are now checks for null saved world data
- The current block selection now has text under it that says the block

## 0.2.2
- On systems that support sys, blocks are loaded automatically alphabetically
- Added world loading
- Added world saving
- Added wool blocks
        - 13 wool blocks

## 0.2.1
- Added block selecting
- Added function to change a block texture to the block class
- Block traces related to a block being in the way of placing a block now requires the BLOCK_TRACES conditional
- Block traces related to a block being in the way of placing a block now include the block_tag
- Added block_tag variable to the Block class
- Dirt layer offset is "softcoded" into the `worldLayers` variable
- Debug text is not visible outside of debug builds
- Code has been organized

## 0.2.0
- Added block placing
- Issue templates have been updated
- Debug tools are debug compiler flag exclusive
- Added block removal
- Added 'flixel-addons' library
- Added "MouseBlock"
- Fixed World width
- Added more debug tools that allow modification of the world size (Z,X)
- World size variables are public static now
- PlayState version text has 'Creative' infront of it
- More World Generation modifications
- All textures were modified

## 0.1.1
- Stone texture was modified
- World Generation has been modified
- Grass, Dirt, and Stone generation layers have been set
- Block name suffixes are now required to be lowercase
- Added new blocks: Dirt, Grass, and air
- Changelog now has date headers
- WORLD_RENDERING_TRACES Conditional added to clean up traces
- BLOCK_TRACES Conditional added to clean up traces
- Version text addition

## 0.1.0_01
- Hxcpp is added to the hmm.json
- Sinlib is removed from the hmm.json
- Changelog file
- The hotfix argument in generateVersionString doesn't matter if HotfixVersion == 0 now

## [0.1.0](https://github.com/sphis-sinco/Creative/commit/59bc5f211117836021d794b12ec171f1f14c8348)
- Version manager file

## [0.0.4](https://github.com/sphis-sinco/Creative/commit/ea0623303931fcdb604daac099482c80b9df1e04)
- Block position offset
- Zoom controls
- World size increase

## [0.0.3](https://github.com/sphis-sinco/Creative/commit/ee425451404a3dc38ad2b6a840136defb737f717)
- World rendering works properly now
- Project xml version is removed

## [0.0.2](https://github.com/sphis-sinco/Creative/commit/1cfd2c0c6cb55c089abac994db44bed085e92254)
- World rendering
- Blocks now have their own folder and are exported and expected like this: 'blocks-stone'

## [0.0.1](https://github.com/sphis-sinco/Creative/commit/06a7fb2f5b1a7ffa01460ddbce93d5f45f488ab8)
- Block atlas (Stone)
