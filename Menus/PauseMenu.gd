extends Control

signal toggle_pause(is_paused : bool)
signal restart_requested
signal options_requested


func _on_resume_button_pressed():
	emit_signal("toggle_pause", false)


func _on_restart_button_pressed():
	emit_signal("restart_requested")


func _on_exit_button_pressed():
	# reset back to main menu
	emit_signal("toggle_pause", false)
	get_tree().change_scene_to_file("res://Menus/MainMenu.tscn")
	

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		emit_signal("toggle_pause", not visible)


func _on_options_button_pressed() -> void:
	emit_signal("options_requested")
