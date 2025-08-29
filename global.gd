extends Object

const Constants = preload("res://mods-unpacked/Abevol-OffScreenResourceIndicators/constants.gd")

static var LOG_NAME := Constants.MOD_ID + ":Global"


# 更新指示器的资源状态
static func update_indicator_state(resource_node: Node, has_resource: bool) -> void:
	var indicator = resource_node.get_node_or_null("Indicator")
	if indicator != null and indicator.has_resource != has_resource:
		indicator.has_resource = has_resource

		var config = ModLoaderConfig.get_current_config(Constants.MOD_DIR)
		if config.data.show_debug_info:
			var scene_file = resource_node.scene_file_path.get_file()
			ModLoaderLog.debug("update_indicator_state: " + "scene: " + scene_file + ", has_resource: " + str(has_resource), LOG_NAME)
