extends Node

const Global = preload("res://mods-unpacked/Abevol-OffScreenResourceIndicators/global.gd")


func _process(_delta: float) -> void:
	var resource_node: Node = self.get_parent()
	Global.update_indicator_state(resource_node, resource_node.hasMushroom)
