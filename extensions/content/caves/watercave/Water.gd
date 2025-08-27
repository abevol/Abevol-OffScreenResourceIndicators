extends "res://content/caves/watercave/Water.gd"

const Global = preload("res://mods-unpacked/Abevol-OffScreenResourceIndicators/global.gd")

# 处理水洞穴
func useHit(keeper:Keeper) -> bool:
	var result = super(keeper)
	var resource_node: Node2D = self.get_parent()

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

	Global.update_indicator_state(resource_node.get_parent().get_parent(), has_resource)
	return result


func _process(delta: float) -> void:
	super(delta)
	var resource_node: Node2D = self.get_parent()

	var waters = [
		resource_node.get_node_or_null("%Water1"),
		resource_node.get_node_or_null("%Water2"),
		resource_node.get_node_or_null("%Water3"),
	]

	for water in waters:
		if water and not water.taken:
			Global.update_indicator_state(resource_node.get_parent().get_parent(), true)
			break
