extends Object

const Cave = preload("res://content/caves/Cave.gd")
const Constants = preload("res://mods-unpacked/Abevol-OffScreenResourceIndicators/constants.gd")
const MushroomCaveMonitor = preload("res://mods-unpacked/Abevol-OffScreenResourceIndicators/extensions/content/caves/mushroomcave/MushroomCaveMonitor.gd")
const IronTreeCaveMonitor = preload("res://mods-unpacked/Abevol-OffScreenResourceIndicators/extensions/content/caves/treecave/IronTreeCaveMonitor.gd")
const WaterCaveMonitor = preload("res://mods-unpacked/Abevol-OffScreenResourceIndicators/extensions/content/caves/watercave/WaterCaveMonitor.gd")

static var LOG_NAME := Constants.MOD_ID + ":Cave"


func _ready(chain: ModLoaderHookChain):
	chain.execute_next()
	var this := chain.reference_object as Cave
	var scene_file: String = this.scene_file_path.get_file()
	var config = ModLoaderConfig.get_current_config(Constants.MOD_DIR)
	if config.data.show_debug_info:
		ModLoaderLog.debug(
			(
				"_ready: " + str(this.coord)
				+ ", scene: " + scene_file
				+ ", state: " + this.State.find_key(this.currentState)
				+ ", visible: " + str(this.visible)
			),
			LOG_NAME
		)

	var instance = (
		preload("res://mods-unpacked/Abevol-OffScreenResourceIndicators/content/indicator/Indicator.tscn").instantiate()
	)
	this.add_child(instance)

	var monitor: Node = null
	match scene_file:
		"MushroomCave.tscn":
			monitor = MushroomCaveMonitor.new()
			monitor.name = "MushroomCaveMonitor"
			this.add_child(monitor)
		"IronTreeCave.tscn":
			monitor = IronTreeCaveMonitor.new()
			monitor.name = "IronTreeCaveMonitor"
			this.add_child(monitor)
		"WaterCave.tscn":
			monitor = WaterCaveMonitor.new()
			monitor.name = "WaterCaveMonitor"
			this.add_child(monitor)


func deserialize(chain: ModLoaderHookChain, data: Dictionary):
	chain.execute_next([data])
	var this := chain.reference_object as Cave
	var sceneFile: String = this.scene_file_path.get_file()
	var config = ModLoaderConfig.get_current_config(Constants.MOD_DIR)
	if config.data.show_debug_info:
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
