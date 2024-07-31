extends CanvasLayer


func _ready():
	$Control/Black.color = Color(0,0,0,0)


func change_scene(path, delay):	
	var timer = get_tree().create_timer(delay)
	await timer.timeout
	
	# Fade Out
	$Control/Black.color = Color(0,0,0,1)
	$AnimationPlayer.play("fade")
	await $AnimationPlayer.animation_finished
	
	# Change Scene
	get_tree().change_scene_to_file(path)
	
	# Fade back in
	$AnimationPlayer.play_backwards("fade")
