extends "res://content/caves/Cave.gd"

const ModMain = preload("res://mods-unpacked/Abevol-OffScreenResourceIndicators/mod_main.gd")
const Constants = preload("res://mods-unpacked/Abevol-OffScreenResourceIndicators/constants.gd")

static var LOG_NAME := Constants.MOD_ID + ":Cave"

var mod_main: ModMain = null

func print_children_names(node: Node) -> void:
	var children_names = []
	for child in node.get_children():
		children_names.append(child.name)
	ModLoaderLog.debug("Children names: " + ", ".join(children_names), LOG_NAME)


func _ready():
	super()
	mod_main = get_node("/root/ModLoader/" + Constants.MOD_DIR)
	if mod_main.show_debug_info:
		var sceneFile: String = scene_file_path.get_file()
		ModLoaderLog.debug(
			(
				"_ready: " + str(coord)
				+ ", sceneFile: " + sceneFile
				+ ", State: " + State.find_key(currentState)
				+ ", visible: " + str(visible)
			),
			LOG_NAME
		)

	var instance = (
		preload("res://mods-unpacked/Abevol-OffScreenResourceIndicators/content/indicator/Indicator.tscn").instantiate()
	)
	add_child(instance)


func deserialize(data: Dictionary):
	super(data)
	var sceneFile: String = scene_file_path.get_file()
	if mod_main.show_debug_info:
		ModLoaderLog.debug(
			(
				"deserialize: " + str(coord)
				+ ", scene: " + sceneFile
				+ ", state: " + State.find_key(currentState)
				+ ", visible: " + str(visible)
			),
			LOG_NAME
		)
		print_children_names(self)

	var instance = get_node_or_null("Indicator")
	if instance != null:
		instance.init_data(data)
	else:
		ModLoaderLog.error("Indicator not found in " + sceneFile, LOG_NAME)
