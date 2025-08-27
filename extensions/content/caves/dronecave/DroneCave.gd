extends "res://content/caves/dronecave/DroneCave.gd"

const Constants = preload("res://mods-unpacked/Abevol-OffScreenResourceIndicators/constants.gd")
const Global = preload("res://mods-unpacked/Abevol-OffScreenResourceIndicators/global.gd")

static var LOG_NAME := Constants.MOD_ID + ":DroneCave"


func spawnDrone():
	super()
	Global.update_indicator_state(self, false)
