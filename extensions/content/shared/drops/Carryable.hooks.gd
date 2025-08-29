extends Object


# 给可携带物品添加指示器
func _ready(chain: ModLoaderHookChain) -> void:
	var instance = (
		preload("res://mods-unpacked/Abevol-OffScreenResourceIndicators/content/indicator/Indicator.tscn").instantiate()
	)
	# Using a typecast here (with "as") can help with autocomplete and avoiding errors
	var main_node := chain.reference_object as Carryable
	main_node.add_child(instance)
	# _ready, which we are hooking, does not have any arguments
	chain.execute_next()
