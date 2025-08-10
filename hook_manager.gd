extends Node

const Chamber = preload("res://content/map/chamber/Chamber.gd")
const ModMain = preload("res://mods-unpacked/Abevol-OffScreenResourceIndicators/mod_main.gd")
const Constants = preload("res://mods-unpacked/Abevol-OffScreenResourceIndicators/constants.gd")

static var LOG_NAME := Constants.MOD_ID + ":HookManager"

var mod_main: ModMain = null
var mod_dir_path := ""
var extensions_dir_path := ""

# 资源状态引用
var resource_states := {}


# 初始化钩子管理器
func _init():
	ModLoaderLog.info("Init", LOG_NAME)
	mod_dir_path = ModLoaderMod.get_unpacked_dir().path_join(Constants.MOD_DIR)
	extensions_dir_path = mod_dir_path.path_join("extensions")


func _ready():
	mod_main = get_node("/root/ModLoader/" + Constants.MOD_DIR)


# 注册所有钩子
func register_all_hooks() -> void:
	ModLoaderLog.info("register_all_hooks", LOG_NAME)

	# 为Cave类型注册钩子
	ModLoaderMod.add_hook(useHit, "res://content/caves/seedcave/SeedCave.gd", "useHit")
	ModLoaderMod.add_hook(useHit, "res://content/caves/bombcave/BombCave.gd", "useHit")
	ModLoaderMod.add_hook(useHit, "res://content/caves/helmetextensioncave/HelmetCave.gd", "useHit")
	ModLoaderMod.add_hook(useHit, "res://content/caves/scannercave/ScannerCave.gd", "useHit")
	ModLoaderMod.add_hook(onUsed, "res://content/caves/dronecave/DroneCave.gd", "spawnDrone")
	ModLoaderMod.add_hook(onUsed, "res://content/caves/dragoncave/LunarNewYearDragonCave.gd", "_on_Egg_egg_taken")
	ModLoaderMod.add_hook(_processForMushroomCave, "res://content/caves/mushroomcave/MushroomCave.gd", "_process")

	# 为Chamber类型注册钩子
	ModLoaderMod.add_hook(onUsed, "res://content/map/chamber/gadget/GadgetChamber.gd", "onUsed")
	ModLoaderMod.add_hook(onUsed, "res://content/map/chamber/gift/GiftChamber.gd", "onUsed")
	ModLoaderMod.add_hook(onUsed, "res://content/map/chamber/supplement/PowerCoreChamber.gd", "onUsed")
	ModLoaderMod.add_hook(onUsed, "res://content/map/chamber/relic/RelicChamber.gd", "onUsed")
	ModLoaderMod.add_hook(
		onUsedForRelicSwitchChamber, "res://content/map/chamber/relicswitch/RelicSwitchChamber.gd", "onUsed"
	)

	# 为其他类型注册特殊钩子
	ModLoaderMod.add_hook(useHitForCobalt, "res://content/caves/cobaltcave/Cobalt.gd", "useHit")
	ModLoaderMod.add_hook(useHitForIron, "res://content/caves/treecave/Iron.gd", "useHit")
	ModLoaderMod.add_hook(_processForIron, "res://content/caves/treecave/Iron.gd", "_process")
	ModLoaderMod.add_hook(useHitForWater, "res://content/caves/watercave/Water.gd", "useHit")
	ModLoaderMod.add_hook(_processForWater, "res://content/caves/watercave/Water.gd", "_process")
	ModLoaderMod.add_hook(setType, "res://content/map/tile/Tile.gd", "setType")


# 获取资源实例的唯一标识符
func get_resource_id(resource_node: Node) -> String:
	return resource_node.get_path()


# 更新资源状态
func update_resource_state(resource_node: Node, has_resource: bool) -> void:
	var resource_id := get_resource_id(resource_node)
	if resource_id.is_empty():
		return

	# 通知相关的指示器更新状态
	var indicator = resource_node.get_node_or_null("Indicator")
	if indicator != null:
		indicator.has_resource = has_resource
		resource_states[resource_id] = has_resource


# 处理通用的资源使用
func useHit(chain: ModLoaderHookChain, keeper: Keeper) -> bool:
	var resource_node := chain.reference_object
	update_resource_state(resource_node, false)
	return chain.execute_next([keeper])


# 处理钴矿洞穴
func useHitForCobalt(chain: ModLoaderHookChain, keeper: Keeper) -> bool:
	var result = chain.execute_next([keeper])
	var resource_node: Node2D = chain.reference_object.get_parent()

	var cobalt1 = resource_node.get_node_or_null("Cobalt1")
	var cobalt2 = resource_node.get_node_or_null("Cobalt2")
	var has_cobalt1 = cobalt1 and not cobalt1.is_queued_for_deletion()
	var has_cobalt2 = cobalt2 and not cobalt2.is_queued_for_deletion()

	update_resource_state(resource_node.get_parent().get_parent(), has_cobalt1 or has_cobalt2)
	return result


# 处理铁矿树
func useHitForIron(chain: ModLoaderHookChain, keeper: Keeper) -> bool:
	var result = chain.execute_next([keeper])
	var resource_node: Node2D = chain.reference_object.get_parent()

	var irons = [
		resource_node.get_node_or_null("%Iron1"),
		resource_node.get_node_or_null("%Iron2"),
		resource_node.get_node_or_null("%Iron3"),
		resource_node.get_node_or_null("%Iron4"),
		resource_node.get_node_or_null("%Iron5"),
	]

	var has_resource = false
	for iron in irons:
		if iron and not iron.taken:
			has_resource = true
			break

	update_resource_state(resource_node.get_parent().get_parent(), has_resource)
	return result


# 处理水洞穴
func useHitForWater(chain: ModLoaderHookChain, keeper: Keeper) -> bool:
	var result = chain.execute_next([keeper])
	var resource_node: Node2D = chain.reference_object.get_parent()

	var waters = [
		resource_node.get_node_or_null("%Water1"),
		resource_node.get_node_or_null("%Water2"),
		resource_node.get_node_or_null("%Water3"),
	]

	var has_resource = false
	for water in waters:
		if water and not water.taken:
			has_resource = true
			break

	update_resource_state(resource_node.get_parent().get_parent(), has_resource)
	return result


# 处理蘑菇洞穴的进程
func _processForMushroomCave(chain: ModLoaderHookChain, delta):
	chain.execute_next([delta])
	var resource_node := chain.reference_object
	update_resource_state(resource_node, resource_node.hasMushroom)


# 处理铁矿树的进程
func _processForIron(chain: ModLoaderHookChain, delta):
	chain.execute_next([delta])
	var resource_node: Node2D = chain.reference_object.get_parent()

	var irons = [
		resource_node.get_node_or_null("%Iron1"),
		resource_node.get_node_or_null("%Iron2"),
		resource_node.get_node_or_null("%Iron3"),
		resource_node.get_node_or_null("%Iron4"),
		resource_node.get_node_or_null("%Iron5"),
	]

	for iron in irons:
		if iron and not iron.taken:
			update_resource_state(resource_node.get_parent().get_parent(), true)
			break


# 处理水洞穴的进程
func _processForWater(chain: ModLoaderHookChain, delta):
	chain.execute_next([delta])
	var resource_node: Node2D = chain.reference_object.get_parent()

	var waters = [
		resource_node.get_node_or_null("%Water1"),
		resource_node.get_node_or_null("%Water2"),
		resource_node.get_node_or_null("%Water3"),
	]

	for water in waters:
		if water and not water.taken:
			update_resource_state(resource_node.get_parent().get_parent(), true)
			break


# 处理资源被使用
func onUsed(chain: ModLoaderHookChain):
	var resource_node := chain.reference_object
	update_resource_state(resource_node, false)
	return chain.execute_next()


func onUsedForRelicSwitchChamber(chain: ModLoaderHookChain):
	chain.execute_next()
	var resource_node := chain.reference_object
	if resource_node.used:
		update_resource_state(resource_node, false)


func setType(chain: ModLoaderHookChain, type: String):
	chain.execute_next([type])

	if type == "dirt":
		var resource_node := chain.reference_object
		update_resource_state(resource_node, false)

