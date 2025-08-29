extends Node

const Constants = preload("res://mods-unpacked/Abevol-OffScreenResourceIndicators/constants.gd")
const ConfigWatcher = preload("res://mods-unpacked/Abevol-OffScreenResourceIndicators/config_watcher.gd")

static var LOG_NAME := Constants.MOD_ID + ":Main"  # Name of the log channel

var mod_dir_path := ""
var extensions_dir_path := ""

var _config_watcher: ConfigWatcher = null


func _init() -> void:
	ModLoaderLog.info("Init", LOG_NAME)

	mod_dir_path = ModLoaderMod.get_unpacked_dir().path_join(Constants.MOD_DIR)
	extensions_dir_path = mod_dir_path.path_join("extensions")

	install_script_extensions()
	install_script_hook_files()


func install_script_extensions() -> void:
	var scripts = [
		"res://content/caves/bombcave/BombCave.gd",
		"res://content/caves/cobaltcave/Cobalt.gd",
		"res://content/caves/dragoncave/LunarNewYearDragonCave.gd",
		"res://content/caves/dronecave/DroneCave.gd",
		"res://content/caves/helmetextensioncave/HelmetCave.gd",
		"res://content/caves/scannercave/ScannerCave.gd",
		"res://content/caves/seedcave/SeedCave.gd",
		"res://content/map/chamber/Chamber.gd",
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


func _ready() -> void:
	ModLoaderLog.info("Ready", LOG_NAME)
	add_to_group("mod_init")

	_config_watcher = ConfigWatcher.new()
	_config_watcher.name = "ConfigWatcher"
	add_child(_config_watcher)


func modInit():
	pass
