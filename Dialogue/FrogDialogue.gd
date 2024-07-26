extends Area2D


func _input(event):
	if event.is_action_pressed("ui_accept") && len(get_overlapping_areas()) > 0:
		var dialogue = get_node("Dialogue")

		if dialogue:
			dialogue.display_dialogue_for("Froggo")
