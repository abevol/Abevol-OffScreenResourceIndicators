extends Node2D

const LOG_NAME := "Abevol-OffScreenResourceIndicators:Indicator"

var canvas
var borders

@onready var indicator = $Pointer
@onready var icon = $Pointer/Icon
@onready var notifier = $VisibilityNotifier2D


func print_children_names(node: Node) -> void:
	var children_names = []
	for child in node.get_children():
		children_names.append(child.name)
	ModLoaderLog.debug("Children names: " + ", ".join(children_names), LOG_NAME)


func _ready():
	var parent = get_parent() as Carryable
	var sprite = parent.find_child("Sprite2D")
	if sprite != null:
		if sprite is Sprite2D:
			icon.texture = sprite.texture
		elif sprite is AnimatedSprite2D:
			icon.texture = sprite.get_sprite_frames().get_frame(sprite.animation, sprite.get_frame())

	match parent.scene_file_path.get_file():
		"Seed.tscn":
			icon.texture = preload("res://content/gadgets/mineraltree/seeddrop.png")
		"Drillbot.tscn":
			icon.texture = preload("res://content/gadgets/drillbot/drillbot.png")

	# ModLoaderLog.debug("Scene file: " + parent.scene_file_path.get_file(), LOG_NAME)
	# print_children_names(parent)

	Style.init(self)


func _process(_delta: float) -> void:
	canvas = get_canvas_transform()
	borders = Rect2(-canvas.get_origin() / canvas.get_scale(), get_viewport_rect().size / canvas.get_scale())

	if (
		notifier.is_on_screen()
		|| (global_position.distance_to(borders.get_center()) > borders.get_center().distance_to(borders.end) * 3)
	):
		indicator.hide()
	else:
		move_indicator()
		indicator.show()


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
