extends Object

const Cave = preload("res://content/caves/Cave.gd")
const ModMain = preload("res://mods-unpacked/Abevol-OffScreenResourceIndicators/mod_main.gd")
const Constants = preload("res://mods-unpacked/Abevol-OffScreenResourceIndicators/constants.gd")

static var LOG_NAME := Constants.MOD_ID + ":Cave"

var mod_main: ModMain = null


func _ready(chain: ModLoaderHookChain):
	chain.execute_next()
	var this := chain.reference_object as Cave
	mod_main = this.get_node("/root/ModLoader/" + Constants.MOD_DIR)
	if mod_main.show_debug_info:
		var sceneFile: String = this.scene_file_path.get_file()
		ModLoaderLog.debug(
			(
				"_ready: " + str(this.coord)
				+ ", scene: " + sceneFile
				+ ", state: " + this.State.find_key(this.currentState)
				+ ", visible: " + str(this.visible)
			),
			LOG_NAME
		)

	var instance = (
		preload("res://mods-unpacked/Abevol-OffScreenResourceIndicators/content/indicator/Indicator.tscn").instantiate()
	)
	this.add_child(instance)


func deserialize(chain: ModLoaderHookChain, data: Dictionary):
	chain.execute_next([data])
	var this := chain.reference_object as Cave
	var sceneFile: String = this.scene_file_path.get_file()
	if mod_main.show_debug_info:
		ModLoaderLog.debug(
			(
				"deserialize: " + str(this.coord)
				+ ", scene: " + sceneFile
				+ ", state: " + this.State.find_key(this.currentState)
				+ ", visible: " + str(this.visible)
			),
			LOG_NAME
		)

	var instance = this.get_node_or_null("Indicator")
	if instance != null:
		instance.init_data(data)
	else:
		ModLoaderLog.error("Indicator not found in " + sceneFile, LOG_NAME)
