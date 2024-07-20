extends Control


func _ready():
	pass # Replace with function body.


func _process(delta):
	pass


func _on_restart_button_pressed():
	# exiting menu and restarting game
	emit_signal("restart_requested")
	emit_signal("toggle_pause", false)
	get_parent().remove_child(get_node("."))


func _on_main_menu_button_pressed():
	# reset back to main menu
	emit_signal("toggle_pause", false)
	get_tree().change_scene_to_file("res://Menus/MainMenu.tscn")
	queue_free()
