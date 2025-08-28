extends "res://content/map/chamber/Chamber.gd"

const Constants = preload("res://mods-unpacked/Abevol-OffScreenResourceIndicators/constants.gd")
const Global = preload("res://mods-unpacked/Abevol-OffScreenResourceIndicators/global.gd")

static var LOG_NAME := Constants.MOD_ID + ":Chamber"


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
				+ ", type: " + str(type)
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
				+ ", type: " + str(type)
			),
			LOG_NAME
		)

	var instance = get_node_or_null("Indicator")
	if instance != null:
		instance.init_data(data)
	else:
		ModLoaderLog.error("Indicator not found in " + sceneFile, LOG_NAME)

# 栈帧
# 0 - res://content/map/chamber/Chamber.gd:133 - at function: useHit
# 1 - res://content/shared/Usable.gd:83 - at function: useHit
# 2 - res://content/keeper/Keeper.gd:195 - at function: useHit
# 3 - res://content/keeper/KeeperInputProcessor.gd:126 - at function: bouttonEvent
# 4 - res://systems/input/InputProcessor.gd:66 - at function: handle
# 5 - res://systems/input/InputSystem.gd:127 - at function:_unhandled_irput
func useHit(keeper:Keeper) -> bool:
	var result = super(keeper)
	if result:
		Global.update_indicator_state(self, false)
	return result
