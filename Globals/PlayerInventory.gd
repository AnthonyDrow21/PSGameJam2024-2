# Logic for insertion/removal of items from the player's inventory
# Using just name and quantity; can be translated on actual inventory UI
# by getting an item def from the name (we could change this to indices or
# something to be slightly more efficient but oh well)
extends Node

const NUM_INVENTORY_SLOTS = 12

signal item_added(itemName : String)
signal item_removed(itemName : String)

var inventory = {}

func add_item(itemName):
	if inventory.size() == NUM_INVENTORY_SLOTS:
		print("ERROR: Max inventory size reached. Unable to add item: ", itemName)
		return
	
	if inventory.has(itemName):
		inventory[itemName] += 1
	else:
		inventory.add_item(itemName, 1)
	emit_signal("item_added", itemName)

func remove_item(itemName):
	if not inventory.has(itemName):
		return
		
	# Remove one item of itemName from inventory
	inventory[itemName] -= 1
	emit_signal("item_removed", itemName)
	
	# Remove itemName if quantity left is 0
	if inventory[itemName] == 0:
		inventory.erase(itemName)

func reset():
	inventory.clear()
