extends Area2D

signal gate_unlocked

var _locked = true
@export var item_id_key = "pink_potion" # TODO: Update this with the right item


func player_can_unlock():	
	if PlayerInventory.find_item(item_id_key):
		return true
	else:
		return false


func unlock_gate():
	$audioUnlock.play()
	emit_signal("gate_unlocked")
	_locked = false


func _input(event):
	# done processing events once the gate is unlocked
	# TODO- we can probs just queue_free() after it's unlocked, but need to figure out
	#       keeping dialogue open until then...
	if not _locked:
		return
		
	if event.is_action_pressed("ui_accept") && len(get_overlapping_areas()) > 0:
		var dialogue = get_node("Dialogue")
		
		if player_can_unlock():
			PlayerInventory.remove_item(item_id_key, 1)
			unlock_gate()
			dialogue.display_dialogue_for("Gate Unlocked")
		else:
			dialogue.display_dialogue_for("Gate Locked")
