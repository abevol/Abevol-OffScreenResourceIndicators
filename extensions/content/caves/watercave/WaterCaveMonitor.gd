extends Node

const Indicator = preload("res://mods-unpacked/Abevol-OffScreenResourceIndicators/content/indicator/Indicator.gd")


func _process(_delta: float) -> void:
	var resource_node: Node = self.get_parent()

	var waters = [
		resource_node.get_node_or_null("%Water1"),
		resource_node.get_node_or_null("%Water2"),
		resource_node.get_node_or_null("%Water3"),
	]

	var has_resource = false
	for water in waters:
		if water and not water.taken:
			has_resource = true
			break

	Indicator.update_indicator_state(resource_node, has_resource)
