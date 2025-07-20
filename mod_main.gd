extends Node

signal current_mod_config_changed(config: ModConfig)

const Constants = preload("res://mods-unpacked/Abevol-OffScreenResourceIndicators/constants.gd")
const HookManager = preload("res://mods-unpacked/Abevol-OffScreenResourceIndicators/hook_manager.gd")
const FileWatcher = preload("res://mods-unpacked/Abevol-OffScreenResourceIndicators/file_watcher.gd")

static var LOG_NAME := Constants.MOD_ID + ":Main"  # Name of the log channel
var mod_dir_path := ""
var extensions_dir_path := ""
var translations_dir_path := ""

var _file_watcher: FileWatcher = null
var _hook_manager: HookManager = null


func _init() -> void:
	ModLoaderLog.info("Init", LOG_NAME)
	mod_dir_path = ModLoaderMod.get_unpacked_dir().path_join(Constants.MOD_DIR)

	install_script_extensions()
	install_script_hook_files()

	# 初始化钩子管理器
	_hook_manager = HookManager.new()
	add_child(_hook_manager)
	_hook_manager.register_all_hooks()

	# add_translations()


func install_script_extensions() -> void:
	extensions_dir_path = mod_dir_path.path_join("extensions")

	ModLoaderMod.install_script_extension(extensions_dir_path.path_join("content/caves/Cave.gd"))
	ModLoaderMod.install_script_extension(extensions_dir_path.path_join("content/map/chamber/Chamber.gd"))


func install_script_hook_files() -> void:
	extensions_dir_path = mod_dir_path.path_join("extensions")

	ModLoaderMod.install_script_hooks(
		"res://content/map/tile/Tile.gd", extensions_dir_path.path_join("content/map/tile/Tile.hooks.gd")
	)
	ModLoaderMod.install_script_hooks(
		"res://content/shared/drops/Carryable.gd",
		extensions_dir_path.path_join("content/shared/drops/Carryable.hooks.gd")
	)


func add_translations() -> void:
	translations_dir_path = mod_dir_path.path_join("translations")

	# ModLoaderMod.add_translation(translations_dir_path.path_join("modname.en.position"))


func _ready() -> void:
	ModLoaderLog.info("Ready", LOG_NAME)
	add_to_group("mod_init")

	# Connect to current_config_changed signal
	ModLoader.current_config_changed.connect(Callable(self, "_on_current_config_changed"))

	_file_watcher = FileWatcher.new()
	add_child(_file_watcher)
	_file_watcher.start_watching(
		ModLoaderConfig.get_current_config(Constants.MOD_DIR).save_path, Callable(self, "_on_config_file_modified")
	)


func _on_config_file_modified(_path: String) -> void:
	ModLoaderConfig.refresh_current_configs()


func _on_current_config_changed(config: ModConfig) -> void:
	# Check if the config of your mod has changed!
	if config.mod_id == Constants.MOD_ID:
		current_mod_config_changed.emit(config)


func modInit():
	pass
