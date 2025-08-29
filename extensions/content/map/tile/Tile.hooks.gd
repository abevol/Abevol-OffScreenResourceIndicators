extends Object

const Constants = preload("res://mods-unpacked/Abevol-OffScreenResourceIndicators/constants.gd")
const Indicator = preload("res://mods-unpacked/Abevol-OffScreenResourceIndicators/content/indicator/Indicator.gd")

static var LOG_NAME := Constants.MOD_ID + ":Tile.hooks"


# 给土块以外的方块添加指示器
func _ready(chain: ModLoaderHookChain):
	var result = chain.execute_next()

	# Using a typecast here (with "as") can help with autocomplete and avoiding errors
	var tile := chain.reference_object as Tile
	if (tile.type != "dirt"):
		var instance = (
			preload("res://mods-unpacked/Abevol-OffScreenResourceIndicators/content/indicator/Indicator.tscn")
			. instantiate()
		)
		tile.add_child(instance)
	return result


# 修复铁蠕虫提炼完毕后铁矿图标仍然显示的问题
func setType(chain: ModLoaderHookChain, type: String):
	chain.execute_next([type])
	if type == "dirt":
		var resource_node := chain.reference_object
		Indicator.update_indicator_state(resource_node, false)
