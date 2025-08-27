extends "res://content/map/chamber/relicswitch/RelicSwitchChamber.gd"

const Global = preload("res://mods-unpacked/Abevol-OffScreenResourceIndicators/global.gd")


func onOpening():
	super()
	if self.used:
		Global.update_indicator_state(self, false)
