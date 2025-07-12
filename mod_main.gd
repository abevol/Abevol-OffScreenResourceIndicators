extends Node

const MOD_DIR := "Abevol-OffScreenResourceIndicators"  # Name of the directory that this file is in
const LOG_NAME := "Abevol-OffScreenResourceIndicators:Main"  # Name of the log channel

var mod_dir_path := ""
var extensions_dir_path := ""
var translations_dir_path := ""


func _init() -> void:
	ModLoaderLog.info("Init", LOG_NAME)
	mod_dir_path = ModLoaderMod.get_unpacked_dir().path_join(MOD_DIR)

	# Add extensions
	# install_script_extensions()
	install_script_hook_files()

	# Add translations
	# add_translations()


func install_script_extensions() -> void:
	extensions_dir_path = mod_dir_path.path_join("extensions")

	# ModLoaderMod.install_script_extension(extensions_dir_path.path_join("content/shared/drops/Carryable.gd"))


func install_script_hook_files() -> void:
	extensions_dir_path = mod_dir_path.path_join("extensions")

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


func modInit():
	pass
