extends Node2D

const Chamber = preload("res://content/map/chamber/Chamber.gd")

const COBALT_CAVE_TEXTURE = preload(
	"res://mods-unpacked/Abevol-OffScreenResourceIndicators/content/indicator/assets/CobaltCave.png"
)
const IRON_TREE_CAVE_TEXTURE = preload(
	"res://mods-unpacked/Abevol-OffScreenResourceIndicators/content/indicator/assets/IronTreeCave.png"
)
const MUSHROOM_CAVE_TEXTURE = preload(
	"res://mods-unpacked/Abevol-OffScreenResourceIndicators/content/indicator/assets/MushroomCave.png"
)
const SEED_TEXTURE = preload("res://content/gadgets/mineraltree/seeddrop.png")
const DRILLBOT_TEXTURE = preload("res://content/gadgets/drillbot/drillbot.png")
const RELIC_CHAMBER_TEXTURE = preload("res://content/map/chamber/relic/artifact_socketed.png")

static var LOG_NAME := Constants.MOD_ID + ":Indicator"
var canvas
var borders
var data: Dictionary
var has_resource: bool = true

@onready var title = $Title
@onready var indicator = $Pointer
@onready var icon = $Pointer/Icon
@onready var notifier = $VisibilityNotifier2D


func _on_current_mod_config_changed(config: ModConfig) -> void:
	apply_config(config)


func apply_config(config: ModConfig) -> void:
	title.visible = config.data.show_debug_info
	var parent = get_parent()
	const TILE_CONFIG_MAP = {
		CONST.BORDER: "show_border_tile_indicator",
		CONST.IRON: "show_iron_tile_indicator",
		CONST.SAND: "show_sand_tile_indicator",
		CONST.WATER: "show_water_tile_indicator",
		CONST.GADGET: "show_gadget_tile_indicator",
		CONST.POWERCORE: "show_power_core_tile_indicator",
		CONST.RELIC: "show_relic_tile_indicator",
		CONST.RELICSWITCH: "show_relic_switch_tile_indicator",
		CONST.NEST: "show_nest_tile_indicator",
	}
	if parent is Tile:
		if TILE_CONFIG_MAP.has(parent.type):
			if config.data[TILE_CONFIG_MAP[parent.type]] == false:
				deactivate()
			else:
				activate()
		return

	const SCENE_CONFIG_MAP = {
		"BombCave.tscn": "show_bomb_cave_indicator",
		"LunarNewYearDragonCave.tscn": "show_chinese_new_year_dragon_cave_indicator",
		"CobaltCave.tscn": "show_cobalt_cave_indicator",
		"DrillbertCave.tscn": "show_drillbert_cave_indicator",
		"DroneCave.tscn": "show_drone_cave_indicator",
		"HalloweenSkeletonCave.tscn": "show_halloween_skeleton_cave_indicator",
		"HelmetCave.tscn": "show_helmet_cave_indicator",
		"IronTreeCave.tscn": "show_iron_tree_cave_indicator",
		"MushroomCave.tscn": "show_mushroom_cave_indicator",
		"NestCave.tscn": "show_nest_cave_indicator",
		"PortalCave.tscn": "show_portal_cave_indicator",
		"ScannerCave.tscn": "show_scanner_cave_indicator",
		"SeedCave.tscn": "show_seed_cave_indicator",
		"TeleportCave.tscn": "show_teleport_cave_indicator",
		"WaterCave.tscn": "show_water_cave_indicator",
		"FollowEye.tscn": "show_follow_eye_indicator",
		"GadgetChamber.tscn": "show_gadget_chamber_indicator",
		"GiftChamber.tscn": "show_gift_chamber_indicator",
		"PowerCoreChamber.tscn": "show_power_core_chamber_indicator",
		"RelicChamber.tscn": "show_relic_chamber_indicator",
		"RelicSwitchChamber.tscn": "show_relic_switch_chamber_indicator",
		"CaveBomb.tscn": "show_cave_bomb_indicator",
		"Drillbot.tscn": "show_drillbot_indicator",
		"Extractor.tscn": "show_extractor_indicator",
		"Mine.tscn": "show_mine_indicator",
		"Spore.tscn": "show_spore_indicator",
		"Teleporter.tscn": "show_teleporter_indicator",
		"Egg.tscn": "show_egg_indicator",
		"PackedDrop.tscn": "show_packed_drop_indicator",
		"Seed.tscn": "show_seed_indicator",
		"Treat.tscn": "show_treat_indicator",
		"IronDrop.tscn": "show_iron_drop_indicator",
		"SandDrop.tscn": "show_sand_drop_indicator",
		"WaterDrop.tscn": "show_water_drop_indicator",
	}
	var sceneFile = parent.scene_file_path.get_file()
	if sceneFile in SCENE_CONFIG_MAP:
		if config.data[SCENE_CONFIG_MAP[sceneFile]] == false:
			deactivate()
		else:
			activate()


func activate():
	visible = true


func deactivate():
	visible = false


func print_children_names(node: Node) -> void:
	var children_names = []
	for child in node.get_children():
		children_names.append(child.name)
	ModLoaderLog.debug("Children names: " + ", ".join(children_names), LOG_NAME)


func init_data(data: Dictionary):
	var parent = get_parent()
	if parent is Chamber:
		has_resource = parent.currentState != Chamber.State.EMPTY
		return

	var sceneFile = parent.scene_file_path.get_file()
	match sceneFile:
		"CobaltCave.tscn":
			has_resource = data["cobalt1"] or data["cobalt2"]
		"IronTreeCave.tscn":
			has_resource = (
				not data["Iron1_taken"]
				or not data["Iron2_taken"]
				or not data["Iron3_taken"]
				or not data["Iron4_taken"]
				or not data["Iron5_taken"]
			)
		"MushroomCave.tscn":
			has_resource = data["hasMushroom"]
		"BombCave.tscn":
			has_resource = data["hasBomb"]
		"DroneCave.tscn":
			has_resource = data["hasDrone"]
		"HelmetCave.tscn":
			has_resource = data["hasHelmet"]
		"SeedCave.tscn":
			has_resource = data["hasSeed"]
		"ScannerCave.tscn":
			has_resource = data["hasScanner"]
		"LunarNewYearDragonCave.tscn":
			has_resource = data["hasEgg"]


func _ready():
	apply_config(ModLoaderConfig.get_current_config(Constants.MOD_DIR))
	var main = get_node("/root/ModLoader/" + Constants.MOD_DIR)
	main.current_mod_config_changed.connect(_on_current_mod_config_changed)

	var parent = get_parent()
	var sprite = parent.get_node_or_null("Sprite")
	if sprite == null:
		sprite = parent.get_node_or_null("Sprite2D")
	if sprite == null:
		sprite = parent.get_node_or_null("ResourceSprite")
	if sprite == null:
		sprite = parent.get_node_or_null("Background")
	if sprite == null:
		sprite = parent.get_node_or_null("Sprites/Sprite")

	if sprite != null:
		if sprite is Sprite2D:
			if sprite.hframes > 1 || sprite.vframes > 1:
				# 处理精灵表
				var texture = sprite.texture
				var frame_width = texture.get_width() / sprite.hframes
				var frame_height = texture.get_height() / sprite.vframes
				var frame_x = sprite.frame_coords.x * frame_width
				var frame_y = sprite.frame_coords.y * frame_height
				var atlas_texture = AtlasTexture.new()
				atlas_texture.atlas = texture
				atlas_texture.region = Rect2(frame_x, frame_y, frame_width, frame_height)
				icon.texture = atlas_texture
			else:
				icon.texture = sprite.texture
		elif sprite is AnimatedSprite2D:
			icon.texture = sprite.get_sprite_frames().get_frame_texture(sprite.animation, sprite.get_frame())

	var sceneFile = parent.scene_file_path.get_file()
	match sceneFile:
		"Seed.tscn":
			icon.texture = SEED_TEXTURE
		"SeedCave.tscn":
			icon.texture = SEED_TEXTURE
		"Drillbot.tscn":
			icon.texture = DRILLBOT_TEXTURE
		"CobaltCave.tscn":
			icon.texture = COBALT_CAVE_TEXTURE
		"IronTreeCave.tscn":
			icon.texture = IRON_TREE_CAVE_TEXTURE
		"MushroomCave.tscn":
			icon.texture = MUSHROOM_CAVE_TEXTURE
			add_to_group("unstyled")
		"RelicChamber.tscn":
			icon.texture = RELIC_CHAMBER_TEXTURE
			# parent.connect("relic_taken", Callable(self, "deactivate"))
			# visible = not Data.ofOr("map.relictaken", false)

	var alphaMap = parent.get_node_or_null("AlphaMap") as Sprite2D
	if alphaMap != null:
		position = alphaMap.position
	var usable = parent.get_node_or_null("Usable") as Area2D
	if usable != null:
		position = usable.position
	var focusMarker = parent.get_node_or_null("FocusMarker") as Sprite2D
	if focusMarker != null:
		position = focusMarker.position
	var marker = parent.get_node_or_null("Marker2D") as Sprite2D
	if marker != null:
		position = marker.position

	# !判断类型只能用is，不能用match
	if parent is Carryable:
		# title.visible = false
		title.text = sceneFile
	elif parent is Tile:
		title.text = sceneFile + ":" + str(parent.type)
	elif parent is Chamber:
		title.text = (sceneFile + ", State: " + parent.State.find_key(parent.currentState))
	else:
		title.text = sceneFile

	# ModLoaderLog.debug("Scene file: " + parent.scene_file_path.get_file(), LOG_NAME)
	# print_children_names(parent)

	Style.init(self)


func _process(_delta: float) -> void:
	canvas = get_canvas_transform()
	borders = Rect2(-canvas.get_origin() / canvas.get_scale(), get_viewport_rect().size / canvas.get_scale())

	if (
		notifier.is_on_screen()
		|| !has_resource
		|| (global_position.distance_to(borders.get_center()) > borders.get_center().distance_to(borders.end) * 3)
	):
		indicator.hide()
	else:
		move_indicator()
		indicator.show()

	var parent = get_parent()
	var sceneFile = parent.scene_file_path.get_file()
	if parent is Chamber:
		title.text = (sceneFile + ", State: " + parent.State.find_key(parent.currentState))


func move_indicator():
	if global_position.y <= borders.position.y:
		indicator.global_position.x = (
			(
				(borders.position.y - global_position.y)
				* (borders.get_center().x - global_position.x)
				/ (borders.get_center().y - global_position.y)
			)
			+ global_position.x
		)
	elif global_position.y >= borders.end.y:
		indicator.global_position.x = (
			(
				(borders.end.y - global_position.y)
				* (borders.get_center().x - global_position.x)
				/ (borders.get_center().y - global_position.y)
			)
			+ global_position.x
		)
	else:
		indicator.global_position.x = global_position.x
	if global_position.x <= borders.position.x:
		indicator.global_position.y = (
			(
				(borders.get_center().y - global_position.y)
				* (borders.position.x - global_position.x)
				/ (borders.get_center().x - global_position.x)
			)
			+ global_position.y
		)
	elif global_position.x >= borders.end.x:
		indicator.global_position.y = (
			(
				(borders.get_center().y - global_position.y)
				* (borders.end.x - global_position.x)
				/ (borders.get_center().x - global_position.x)
			)
			+ global_position.y
		)
	else:
		indicator.global_position.y = global_position.y

	indicator.global_position.x = clamp(indicator.global_position.x, borders.position.x, borders.end.x)
	indicator.global_position.y = clamp(indicator.global_position.y, borders.position.y, borders.end.y)

	indicator.global_rotation = (global_position - indicator.global_position).angle()
	icon.global_rotation = 0


func _on_visibility_notifier_2d_screen_exited():
	pass  # Replace with function body.
