extends "res://content/caves/dragoncave/LunarNewYearDragonCave.gd"

const Global = preload("res://mods-unpacked/Abevol-OffScreenResourceIndicators/global.gd")


func _on_Egg_egg_taken():
	super()
	Global.update_indicator_state(self, false)
