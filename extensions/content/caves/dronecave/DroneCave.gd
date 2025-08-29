extends "res://content/caves/dronecave/DroneCave.gd"

const Constants = preload("res://mods-unpacked/Abevol-OffScreenResourceIndicators/constants.gd")
const Indicator = preload("res://mods-unpacked/Abevol-OffScreenResourceIndicators/content/indicator/Indicator.gd")

static var LOG_NAME := Constants.MOD_ID + ":DroneCave"


func spawnDrone():
	super()
	Indicator.update_indicator_state(self, false)
