extends PointLight2D

# TODO We can use this signal to notify the rest of the game
# about how much time is left, e.g. music change?
signal light_dying(time_left : float)
signal game_over(didWin : bool)

var max_time = 0.0
var _timer : Timer

func _ready():
	# Do not run light timer if running in dev mode
	if GameSettings.devModeOn:
		return
	
	if GameSettings.difficulty == GameSettings.DIFFICULTY_LEVEL.Easy:
		max_time = 40.0
	elif GameSettings.difficulty == GameSettings.DIFFICULTY_LEVEL.Normal:
		max_time = 30.0
	elif GameSettings.difficulty == GameSettings.DIFFICULTY_LEVEL.Hard:
		max_time = 20.0
	else:
		print("Unknown game difficulty setting!")
	
	_timer = Timer.new()
	add_child(_timer)
	_timer.start(max_time)
	_timer.one_shot = true
	_timer.connect("timeout", _on_timer_timeout)

func _process(delta):
	if _timer:
		# Scale the size of the light source based on the remaining time
		texture_scale = (_timer.time_left / max_time)


func _on_timer_timeout():
	print("game_over")
	emit_signal("game_over", false)
	queue_free()


func update_remaining_time(delta):
	if _timer == null:
		# Ignore for developer mode
		return
	
	var time_left = _timer.time_left
	_timer.stop()
	
	var new_time = time_left + delta
	if new_time > max_time:
		new_time = max_time
	
	if new_time > 0:
		_timer.start(new_time)
	else:
		_on_timer_timeout()
