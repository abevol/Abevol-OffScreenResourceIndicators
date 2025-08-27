extends "res://content/caves/bombcave/BombCave.gd"

const Global = preload("res://mods-unpacked/Abevol-OffScreenResourceIndicators/global.gd")


func useHit(keeper: Keeper) -> bool:
	Global.update_indicator_state(self, false)
	return super(keeper)
