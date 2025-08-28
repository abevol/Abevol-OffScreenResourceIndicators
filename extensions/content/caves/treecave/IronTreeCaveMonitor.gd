extends Node

const Global = preload("res://mods-unpacked/Abevol-OffScreenResourceIndicators/global.gd")


func _process(_delta: float) -> void:
	var resource_node: Node = self.get_parent()

	var irons = [
		resource_node.get_node_or_null("%Iron1"),
		resource_node.get_node_or_null("%Iron2"),
		resource_node.get_node_or_null("%Iron3"),
		resource_node.get_node_or_null("%Iron4"),
		resource_node.get_node_or_null("%Iron5"),
	]

	var has_resource = false
	for iron in irons:
		if iron and not iron.taken:
			has_resource = true
			break

	Global.update_indicator_state(resource_node, has_resource)
