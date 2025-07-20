extends Object

const Constants = preload("res://mods-unpacked/Abevol-OffScreenResourceIndicators/constants.gd")

static var LOG_NAME := Constants.MOD_ID + ":Tile.hooks"


func _ready(chain: ModLoaderHookChain):
	var result = chain.execute_next()

	# Using a typecast here (with "as") can help with autocomplete and avoiding errors
	var tile := chain.reference_object as Tile
	if (tile.type != "dirt"):
		# ModLoaderLog.debug("_ready: " + str(tile.coord) + ", type: " + tile.type, LOG_NAME)
		var instance = (
			preload("res://mods-unpacked/Abevol-OffScreenResourceIndicators/content/indicator/Indicator.tscn")
			. instantiate()
		)
		tile.add_child(instance)

	return result
