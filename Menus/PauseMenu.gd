extends Control

signal toggle_pause(is_paused : bool)
signal restart_requested

# Called when the node enters the scene tree for the first time.
func _ready():
	emit_signal("toggle_pause", true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_resume_button_pressed():
	# exiting menu
	get_parent().remove_child(get_node("."))
	emit_signal("toggle_pause", false)


func _on_restart_button_pressed():
	# exiting menu and restarting game
	emit_signal("restart_requested")
	emit_signal("toggle_pause", false)
	get_parent().remove_child(get_node("."))


func _on_exit_button_pressed():
	# reset back to main menu
	get_tree().change_scene_to_file("res://Menus/MainMenu.tscn")
