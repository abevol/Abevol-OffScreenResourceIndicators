extends Node

const MODNAME_MOD_DIR = "Gelulacus-OffScreenResourceIndicators/"
const MODNAME_LOG = "OffScreenResourceIndicators"

var dir = ""
var ext_dir = ""


func _init():
	ModLoaderLog.info("Init", MODNAME_LOG)
	dir = ModLoaderMod.get_unpacked_dir() + MODNAME_MOD_DIR
	ext_dir = dir + "extensions/"
	ModLoaderMod.install_script_extension(ext_dir + "content/shared/drops/Carryable.gd")


func _ready():
	ModLoaderLog.info("Done", MODNAME_LOG)
	add_to_group("mod_init")


func modInit():
	pass
