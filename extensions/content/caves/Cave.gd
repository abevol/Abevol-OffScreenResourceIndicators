extends "res://content/caves/Cave.gd"

const Constants = preload("res://mods-unpacked/Abevol-OffScreenResourceIndicators/constants.gd")

static var LOG_NAME := Constants.MOD_ID + ":Cave"

func print_children_names(node: Node) -> void:
	var children_names = []
	for child in node.get_children():
		children_names.append(child.name)
	ModLoaderLog.debug("Children names: " + ", ".join(children_names), LOG_NAME)


func _ready():
	super()
	# var sceneFile: String = scene_file_path.get_file()
	# ModLoaderLog.debug(
	# 	(
	# 		"_ready: " + str(coord)
	# 		+ ", sceneFile: " + sceneFile
	# 		+ ", State: " + State.find_key(currentState)
	# 		+ ", visible: " + str(visible)
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
	# 		+ ", scene: " + sceneFile
	# 		+ ", state: " + State.find_key(currentState)
	# 		+ ", visible: " + str(visible)
	# 	),
	# 	LOG_NAME
	# )
	# print_children_names(self)

	var instance = get_node_or_null("Indicator")
	if instance != null:
		instance.init_data(data)
	else:
		ModLoaderLog.error("Indicator not found in " + sceneFile, LOG_NAME)
