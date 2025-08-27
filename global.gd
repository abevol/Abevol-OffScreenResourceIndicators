extends Object

 # 更新指示器的资源状态
static func update_indicator_state(resource_node: Node, has_resource: bool) -> void:
	var indicator = resource_node.get_node_or_null("Indicator")
	if indicator != null:
		indicator.has_resource = has_resource
