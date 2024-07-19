extends Control

var paused = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if( Input.is_action_pressed("ui_cancel") ):
		if not paused:
			var pauseMenu = load("res://Menus/PauseMenu.tscn").instantiate()
			pauseMenu.toggle_pause.connect(on_pause_toggled)
			get_tree().current_scene.add_child(pauseMenu)

func on_pause_toggled(is_paused):
	paused = is_paused
	
func on_restart():
	print("UNIMPLEMNTED: User requested game restart")
