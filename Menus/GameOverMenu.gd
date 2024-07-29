extends Control

# This is almost copy-pasta from the pause menu, we could probs combine into
#something else but this works for now.
signal restart_requested

func _process(delta):
	pass


func _on_restart_button_pressed():
	emit_signal("restart_requested")
	
	
func _on_main_menu_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Menus/MainMenu.tscn")

