extends "res://content/caves/treecave/Iron.gd"

const Global = preload("res://mods-unpacked/Abevol-OffScreenResourceIndicators/global.gd")

# 处理铁矿树
func useHit(keeper:Keeper) -> bool:
	var result = super(keeper)
	var resource_node: Node2D = self.get_parent()

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

	Global.update_indicator_state(resource_node.get_parent().get_parent(), has_resource)
	return result


func _process(delta: float) -> void:
	super(delta)
	var resource_node: Node2D = self.get_parent()

	var irons = [
		resource_node.get_node_or_null("%Iron1"),
		resource_node.get_node_or_null("%Iron2"),
		resource_node.get_node_or_null("%Iron3"),
		resource_node.get_node_or_null("%Iron4"),
		resource_node.get_node_or_null("%Iron5"),
	]

	for iron in irons:
		if iron and not iron.taken:
			Global.update_indicator_state(resource_node.get_parent().get_parent(), true)
			break
