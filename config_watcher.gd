extends Node

const Constants = preload("res://mods-unpacked/Abevol-OffScreenResourceIndicators/constants.gd")
const FileWatcher = preload("res://mods-unpacked/Abevol-OffScreenResourceIndicators/file_watcher.gd")

static var LOG_NAME := Constants.MOD_ID + ":ConfigWatcher"  # Name of the log channel

var _file_watcher: FileWatcher = null


func _init() -> void:
	ModLoaderLog.info("Init", LOG_NAME)

	_file_watcher = FileWatcher.new()
	_file_watcher.name = "FileWatcher"
	add_child(_file_watcher)
	var config_file_path = ModLoaderConfig.get_current_config(Constants.MOD_DIR).save_path
	ModLoaderLog.info("Config file path: " + config_file_path, LOG_NAME)
	_file_watcher.start_watching(config_file_path, _on_config_file_modified)


func _on_config_file_modified(_path: String) -> void:
	ModLoaderLog.info("Config file modified: " + _path, LOG_NAME)
	ModLoaderConfig.refresh_current_configs()
