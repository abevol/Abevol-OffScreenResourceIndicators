extends "res://content/caves/mushroomcave/MushroomCave.gd"

const Global = preload("res://mods-unpacked/Abevol-OffScreenResourceIndicators/global.gd")


func _process(delta):
	super(delta)
	if self.hasMushroom:
		Global.update_indicator_state(self, true)


func useHit(keeper: Keeper) -> bool:
	Global.update_indicator_state(self, false)
	return super(keeper)
