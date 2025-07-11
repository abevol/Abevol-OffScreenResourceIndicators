extends Node2D

var canvas
var borders

onready var indicator = $Pointer
onready var icon = $Pointer/Icon
onready var notifier = $VisibilityNotifier2D


func _ready():
	var sprite = get_parent().find_node("Sprite")
	if sprite != null:
		if sprite is Sprite:
			icon.texture = sprite.texture
		elif sprite is AnimatedSprite:
			icon.texture = sprite.get_sprite_frames().get_frame(sprite.animation, sprite.get_frame())

	match get_parent().filename.get_file():
		"Seed.tscn":
			icon.texture = preload("res://content/gadgets/mineraltree/seeddrop.png")
		"Drillbot.tscn":
			icon.texture = preload("res://content/gadgets/drillbot/drillbot.png")

	Style.init(self)


func _process(delta):
	canvas = get_canvas_transform()
	borders = Rect2(-canvas.get_origin() / canvas.get_scale(), get_viewport_rect().size / canvas.get_scale()) 
	
	if notifier.is_on_screen() || (global_position.distance_to(borders.get_center()) > borders.get_center().distance_to(borders.end) * 3):
		indicator.hide()
	else:
		move_indicator()
		indicator.show()


func move_indicator():
	if global_position.y <= borders.position.y:
		indicator.global_position.x = (borders.position.y - global_position.y) * (borders.get_center().x - global_position.x) / (borders.get_center().y - global_position.y) + global_position.x
	elif global_position.y >= borders.end.y:
		indicator.global_position.x = (borders.end.y - global_position.y) * (borders.get_center().x - global_position.x) / (borders.get_center().y - global_position.y) + global_position.x
	else:
		indicator.global_position.x = global_position.x
	if global_position.x <= borders.position.x:
		indicator.global_position.y = (borders.get_center().y - global_position.y) * (borders.position.x - global_position.x) / (borders.get_center().x - global_position.x) + global_position.y
	elif global_position.x >= borders.end.x:
		indicator.global_position.y = (borders.get_center().y - global_position.y) * (borders.end.x - global_position.x) / (borders.get_center().x - global_position.x) + global_position.y
	else:
		indicator.global_position.y = global_position.y

	indicator.global_position.x = clamp(indicator.global_position.x, borders.position.x, borders.end.x)
	indicator.global_position.y = clamp(indicator.global_position.y, borders.position.y, borders.end.y)
	
	indicator.global_rotation = (global_position - indicator.global_position).angle()
	icon.global_rotation = 0
