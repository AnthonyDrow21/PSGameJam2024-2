# TODO: Figure out how to get a highlight box around the selected item!
# TODO: Keep order that the player arranges through drag-and-drop!
extends Control

var ItemDropClass = preload("res://Elements/ItemDrop.tscn")

const SlotClass = preload("res://Menus/CraftingMenuSlot.gd")

var elementSlot = null
var metalSlot = null

func _on_brew_button_pressed():
	var player = get_tree().get_first_node_in_group("Player").get_child(0)
	if elementSlot == "WATER" && metalSlot == "GOLD":
		print("You did it! Aqua Regia!")
		var aquaregia = ItemDropClass.instantiate().with_id("aqua_regia")
		player.get_parent().add_child(aquaregia)
		aquaregia.global_position.x = player.global_position.x + 25
		aquaregia.global_position.y = player.global_position.y
	else:
		print("We better try something else...")
	pass # Replace with function body.
