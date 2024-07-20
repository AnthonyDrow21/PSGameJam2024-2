extends Control

# This is almost copy-pasta from the pause menu, we could probs combine into
#something else but this works for now.
signal toggle_pause(is_paused : bool)
signal restart_requested

func _ready():
	emit_signal("toggle_pause", true)


func _process(delta):
	pass


func _on_restart_button_pressed():
	emit_signal("toggle_pause", false)
	emit_signal("restart_requested")
	
	
func _on_main_menu_button_pressed():
	emit_signal("toggle_pause", false)
	get_tree().change_scene_to_file("res://Menus/MainMenu.tscn")

