extends "res://content/caves/dragoncave/LunarNewYearDragonCave.gd"

const Indicator = preload("res://mods-unpacked/Abevol-OffScreenResourceIndicators/content/indicator/Indicator.gd")


func _on_Egg_egg_taken():
	super()
	Indicator.update_indicator_state(self, false)
