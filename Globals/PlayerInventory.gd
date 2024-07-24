# Logic for insertion/removal of items from the player's inventory
# Using just name and quantity; can be translated on actual inventory UI
# by getting an item def from the name (we could change this to indices or
# something to be slightly more efficient but oh well)
extends Node

# THIS MUST MATCH NUMBER OF SLOTS IN INVENTORYMENU GRID CONTAINER
const NUM_INVENTORY_SLOTS = 16

var inventory = {
	}

func add_item(item_id, quantity):
	if inventory.size() == NUM_INVENTORY_SLOTS:
		print("ERROR: Max inventory size reached. Unable to add item: ", item_id)
		return
	
	if inventory.has(item_id):
		inventory[item_id] += quantity
	else:
		inventory[item_id] = quantity

func remove_item(item_id, quantity):
	if not inventory.has(item_id):
		return
		
	# Remove quantity of itemName from inventory
	inventory[item_id] -= quantity
	
	# Remove itemName if quantity left is 0
	if inventory[item_id] == 0:
		inventory.erase(item_id)

func reset():
	inventory.clear()
