extends Node

const Indicator = preload("res://mods-unpacked/Abevol-OffScreenResourceIndicators/content/indicator/Indicator.gd")


func _process(_delta: float) -> void:
	var resource_node: Node = self.get_parent()
	Indicator.update_indicator_state(resource_node, resource_node.hasMushroom)
