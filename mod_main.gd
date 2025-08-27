extends Node

signal current_mod_config_changed(config: ModConfig)

const Constants = preload("res://mods-unpacked/Abevol-OffScreenResourceIndicators/constants.gd")
const FileWatcher = preload("res://mods-unpacked/Abevol-OffScreenResourceIndicators/file_watcher.gd")

static var LOG_NAME := Constants.MOD_ID + ":Main"  # Name of the log channel

var show_debug_info := true

var mod_dir_path := ""
var extensions_dir_path := ""
var translations_dir_path := ""

var _file_watcher: FileWatcher = null


func _init() -> void:
	ModLoaderLog.info("Init", LOG_NAME)
	mod_dir_path = ModLoaderMod.get_unpacked_dir().path_join(Constants.MOD_DIR)
	extensions_dir_path = mod_dir_path.path_join("extensions")
	translations_dir_path = mod_dir_path.path_join("translations")

	# add_translations()
	install_script_extensions()
	install_script_hook_files()


func install_script_extensions() -> void:
	var scripts = [
		# "res://content/caves/Cave.gd",
		"res://content/caves/bombcave/BombCave.gd",
		"res://content/caves/cobaltcave/Cobalt.gd",
		"res://content/caves/dragoncave/LunarNewYearDragonCave.gd",
		"res://content/caves/dronecave/DroneCave.gd",
		"res://content/caves/helmetextensioncave/HelmetCave.gd",
		"res://content/caves/mushroomcave/MushroomCave.gd",
		"res://content/caves/scannercave/ScannerCave.gd",
		"res://content/caves/seedcave/SeedCave.gd",
		"res://content/caves/treecave/Iron.gd",
		"res://content/caves/watercave/Water.gd",
		"res://content/map/chamber/Chamber.gd",
		# "res://content/map/chamber/gadget/GadgetChamber.gd",
		# "res://content/map/chamber/gift/GiftChamber.gd",
		# "res://content/map/chamber/relic/RelicChamber.gd",
		# "res://content/map/chamber/relicswitch/RelicSwitchChamber.gd",
		# "res://content/map/chamber/supplement/PowerCoreChamber.gd",
	]

	for script_path in scripts:
		var relative_path = script_path.trim_prefix("res://")
		var extension_path = extensions_dir_path.path_join(relative_path)
		ModLoaderLog.info("Install script extension: " + script_path + " -> " + extension_path, LOG_NAME)
		ModLoaderMod.install_script_extension(extension_path)


func install_script_hook_files() -> void:
	var scripts = [
		"res://content/caves/Cave.gd",
		"res://content/map/tile/Tile.gd",
		"res://content/shared/drops/Carryable.gd",
	]

	for script_path in scripts:
		var basename = script_path.get_basename()
		var relative_path = basename.trim_prefix("res://")
		var hooks_path = extensions_dir_path.path_join(relative_path + ".hooks.gd")
		ModLoaderLog.info("Install script hooks: " + script_path + " -> " + hooks_path, LOG_NAME)
		ModLoaderMod.install_script_hooks(script_path, hooks_path)


func add_translations() -> void:
	pass
	# ModLoaderMod.add_translation(translations_dir_path.path_join("modname.en.position"))


func _ready() -> void:
	ModLoaderLog.info("Ready", LOG_NAME)
	add_to_group("mod_init")
	init_config()


func init_config() -> void:
	var config = ModLoaderConfig.get_current_config(Constants.MOD_DIR)
	show_debug_info = config.data.show_debug_info

	# Connect to current_config_changed signal
	ModLoader.current_config_changed.connect(_on_current_config_changed)

	_file_watcher = FileWatcher.new()
	add_child(_file_watcher)
	var config_file_path = ModLoaderConfig.get_current_config(Constants.MOD_DIR).save_path
	ModLoaderLog.info("Config file path: " + config_file_path, LOG_NAME)
	_file_watcher.start_watching(config_file_path, _on_config_file_modified)


func _on_config_file_modified(_path: String) -> void:
	ModLoaderLog.info("Config file modified: " + _path, LOG_NAME)
	ModLoaderConfig.refresh_current_configs()
	# var current_config = ModLoaderConfig.get_current_config(Constants.MOD_DIR)
	# ModLoaderConfig.refresh_config_data(current_config)
	# ModLoader.current_config_changed.emit(current_config)


func _on_current_config_changed(config: ModConfig) -> void:
	ModLoaderLog.info("Config changed: " + config.mod_id, LOG_NAME)
	# Check if the config of your mod has changed!
	if config.mod_id == Constants.MOD_ID:
		show_debug_info = config.data.show_debug_info
		current_mod_config_changed.emit(config)


func modInit():
	pass
