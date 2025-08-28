extends "res://content/caves/Cave.gd"

const Constants = preload("res://mods-unpacked/Abevol-OffScreenResourceIndicators/constants.gd")
const Global = preload("res://mods-unpacked/Abevol-OffScreenResourceIndicators/global.gd")

static var LOG_NAME := Constants.MOD_ID + ":Cave"


func _ready():
	super()
	var config = ModLoaderConfig.get_current_config(Constants.MOD_DIR)
	if config.data.show_debug_info:
		var sceneFile: String = scene_file_path.get_file()
		ModLoaderLog.debug(
			(
				"_ready: " + str(coord)
				+ ", scene: " + sceneFile
				+ ", state: " + State.find_key(currentState)
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
	var config = ModLoaderConfig.get_current_config(Constants.MOD_DIR)
	if config.data.show_debug_info:
		ModLoaderLog.debug(
			(
				"deserialize: " + str(coord)
				+ ", scene: " + sceneFile
				+ ", state: " + State.find_key(currentState)
				+ ", visible: " + str(visible)
			),
			LOG_NAME
		)

	var instance = get_node_or_null("Indicator")
	if instance != null:
		instance.init_data(data)
	else:
		ModLoaderLog.error("Indicator not found in " + sceneFile, LOG_NAME)
