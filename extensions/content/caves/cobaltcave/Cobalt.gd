extends "res://content/caves/cobaltcave/Cobalt.gd"

const Global = preload("res://mods-unpacked/Abevol-OffScreenResourceIndicators/global.gd")

# 处理钴矿洞穴
func useHit(keeper:Keeper) -> bool:
	var result = super(keeper)
	var resource_node: Node2D = self.get_parent()

	var cobalt1 = resource_node.get_node_or_null("Cobalt1")
	var cobalt2 = resource_node.get_node_or_null("Cobalt2")
	var has_cobalt1 = cobalt1 and not cobalt1.is_queued_for_deletion()
	var has_cobalt2 = cobalt2 and not cobalt2.is_queued_for_deletion()

	Global.update_indicator_state(resource_node.get_parent().get_parent(), has_cobalt1 or has_cobalt2)
	return result
