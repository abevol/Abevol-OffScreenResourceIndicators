extends "res://content/map/chamber/gadget/GadgetChamber.gd"

const Global = preload("res://mods-unpacked/Abevol-OffScreenResourceIndicators/global.gd")


func onUsed():
	super()
	Global.update_indicator_state(self, false)
