extends Node

signal current_mod_config_changed(config: ModConfig)

const Constants = preload("res://mods-unpacked/Abevol-OffScreenResourceIndicators/constants.gd")
const HookManager = preload("res://mods-unpacked/Abevol-OffScreenResourceIndicators/hook_manager.gd")
const FileWatcher = preload("res://mods-unpacked/Abevol-OffScreenResourceIndicators/file_watcher.gd")

static var LOG_NAME := Constants.MOD_ID + ":Main"  # Name of the log channel

var show_debug_info := false
var mod_dir_path := ""
var extensions_dir_path := ""
var translations_dir_path := ""

var _file_watcher: FileWatcher = null
var _hook_manager: HookManager = null


func _init() -> void:
	ModLoaderLog.info("Init", LOG_NAME)
	mod_dir_path = ModLoaderMod.get_unpacked_dir().path_join(Constants.MOD_DIR)
	extensions_dir_path = mod_dir_path.path_join("extensions")

	init_config()
	# add_translations()
	# install_script_extensions()
	install_script_hook_files()

	# 初始化钩子管理器
	_hook_manager = HookManager.new()
	_hook_manager.name = "HookManager"
	add_child(_hook_manager)
	_hook_manager.register_all_hooks()


func init_config() -> void:
	var config = ModLoaderConfig.get_current_config(Constants.MOD_DIR)
	show_debug_info = config.data.show_debug_info

	# Connect to current_config_changed signal
	ModLoader.current_config_changed.connect(Callable(self, "_on_current_config_changed"))

	_file_watcher = FileWatcher.new()
	_file_watcher.name = "FileWatcher"
	add_child(_file_watcher)
	_file_watcher.start_watching(
		ModLoaderConfig.get_current_config(Constants.MOD_DIR).save_path, Callable(self, "_on_config_file_modified")
	)


func install_script_extensions() -> void:
	pass
	# ModLoaderMod.install_script_extension(extensions_dir_path.path_join("content/caves/Cave.gd"))
	# ModLoaderMod.install_script_extension(extensions_dir_path.path_join("content/map/chamber/Chamber.gd"))


func install_script_hook_files() -> void:
	var scripts = [
		"res://content/caves/Cave.gd",
		"res://content/map/chamber/Chamber.gd",
		"res://content/map/tile/Tile.gd",
		"res://content/shared/drops/Carryable.gd"
	]

	for script_path in scripts:
		var basename = script_path.get_basename()
		var relative_path = basename.trim_prefix("res://")
		var hooks_path = extensions_dir_path.path_join(relative_path + ".hooks.gd")
		ModLoaderLog.info("Install script hooks: " + script_path + " -> " + hooks_path, LOG_NAME)
		ModLoaderMod.install_script_hooks(script_path, hooks_path)


func add_translations() -> void:
	translations_dir_path = mod_dir_path.path_join("translations")

	# ModLoaderMod.add_translation(translations_dir_path.path_join("modname.en.position"))


func _ready() -> void:
	ModLoaderLog.info("Ready", LOG_NAME)
	add_to_group("mod_init")


func _on_config_file_modified(_path: String) -> void:
	ModLoaderConfig.refresh_current_configs()


func _on_current_config_changed(config: ModConfig) -> void:
	# Check if the config of your mod has changed!
	if config.mod_id == Constants.MOD_ID:
		show_debug_info = config.data.show_debug_info
		current_mod_config_changed.emit(config)


func modInit():
	pass
