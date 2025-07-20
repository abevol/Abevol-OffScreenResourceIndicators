extends "res://content/map/chamber/Chamber.gd"

const Constants = preload("res://mods-unpacked/Abevol-OffScreenResourceIndicators/constants.gd")

static var LOG_NAME := Constants.MOD_ID + ":Chamber"


func _ready():
	super()

	# var sceneFile: String = scene_file_path.get_file()
	# ModLoaderLog.debug(
	# 	(
	# 		"_ready: " + str(coord)
	# 		+ ", sceneFile: " + sceneFile
	# 		+ ", State: " + State.find_key(currentState)
	# 		+ ", visible: " + str(visible)
	# 		+ ", type: " + str(type)
	# 	),
	# 	LOG_NAME
	# )

	var instance = (
		preload("res://mods-unpacked/Abevol-OffScreenResourceIndicators/content/indicator/Indicator.tscn").instantiate()
	)
	add_child(instance)


func deserialize(data: Dictionary):
	super(data)
	var sceneFile: String = scene_file_path.get_file()
	# ModLoaderLog.debug(
	# 	(
	# 		"deserialize: " + str(coord)
	# 		+ ", sceneFile: " + sceneFile
	# 		+ ", State: " + State.find_key(currentState)
	# 		+ ", visible: " + str(visible)
	# 		+ ", type: " + str(type)
	# 	),
	# 	LOG_NAME
	# )

	var instance = get_node_or_null("Indicator")
	if instance != null:
		instance.init_data(data)
	else:
		ModLoaderLog.error("Indicator not found in " + sceneFile, LOG_NAME)
