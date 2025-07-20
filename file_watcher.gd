extends Node

var file_to_watch: String
var check_interval: float = 1.0
var _callback: Callable = Callable()
var _last_modified_time: int = 0
var _timer: Timer


func _init():
	_timer = Timer.new()
	_timer.autostart = false
	_timer.one_shot = false
	_timer.timeout.connect(_on_check_file_changed)
	add_child(_timer)


func start_watching(path: String, callback: Callable, interval_sec: float = 1.0):
	file_to_watch = path
	check_interval = interval_sec
	_callback = callback

	_last_modified_time = get_modified_time(file_to_watch)
	_timer.wait_time = check_interval
	_timer.start()


func stop_watching():
	if _timer:
		_timer.stop()


func _on_check_file_changed():
	var current_time = get_modified_time(file_to_watch)
	if current_time != _last_modified_time:
		_last_modified_time = current_time
		if _callback.is_valid():
			_callback.call(file_to_watch)


func get_modified_time(path: String) -> int:
	return FileAccess.get_modified_time(path)
