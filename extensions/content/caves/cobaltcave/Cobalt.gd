extends "res://content/caves/cobaltcave/Cobalt.gd"

const Indicator = preload("res://mods-unpacked/Abevol-OffScreenResourceIndicators/content/indicator/Indicator.gd")

# 处理钴矿洞穴
func useHit(keeper:Keeper) -> bool:
	var result = super(keeper)
	var resource_node: Node2D = self.get_parent()

	var cobalt1 = resource_node.get_node_or_null("Cobalt1")
	var cobalt2 = resource_node.get_node_or_null("Cobalt2")
	var has_cobalt1 = cobalt1 and not cobalt1.is_queued_for_deletion()
	var has_cobalt2 = cobalt2 and not cobalt2.is_queued_for_deletion()

	var indicator_parent = resource_node.get_parent().get_parent()
	Indicator.update_indicator_state(indicator_parent, has_cobalt1 or has_cobalt2)
	return result
