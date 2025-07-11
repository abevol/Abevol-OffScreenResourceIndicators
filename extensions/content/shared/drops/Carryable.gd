extends "res://content/shared/drops/Carryable.gd"

func _ready():
	var instance = preload("res://mods-unpacked/Gelulacus-OffScreenResourceIndicators/content/indicator/Indicator.tscn").instance()
	add_child(instance)
