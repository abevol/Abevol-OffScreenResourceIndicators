extends "res://content/caves/bombcave/BombCave.gd"

const Indicator = preload("res://mods-unpacked/Abevol-OffScreenResourceIndicators/content/indicator/Indicator.gd")


func useHit(keeper: Keeper) -> bool:
	Indicator.update_indicator_state(self, false)
	return super(keeper)
