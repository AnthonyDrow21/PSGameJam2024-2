# Logic for insertion/removal of items from the player's inventory
# NOTE: THIS WILL NOT SCALE WELL. lol. Iterating linearly. If we have oodles
#       of items, we should use a better data structure here.
extends Node

signal picked_up_journal_page(pagename)
signal picked_up_journal

# THIS MUST MATCH NUMBER OF SLOTS IN INVENTORYMENU GRID CONTAINER
const NUM_INVENTORY_SLOTS = 16

# key is unsigned int 0 - NUM_INVENTORY_SLOTS-1
# value is array [item_id, item_quantity]
var inventory = {
	}

func add_item_at_idx(idx, item_id, quantity):
	if inventory.has(idx):
		print("ERROR: idx ", idx, " already has item, but passed to PlayerInventory.add_item_at_idx")
	else:
		inventory[idx] = [item_id, quantity]

func swap_items_at_idx(idx1, idx2):
	if not inventory.has(idx1):
		print("ERROR: Invalid idx ", idx1, " passed to PlayerInventory.swap_items_at_idx")
		return
	if not inventory.has(idx2):
		print("ERROR: Invalid idx ", idx2, " passed to PlayerInventory.swap_items_at_idx")
		return
	# idxs are valid, do the swap
	var tmp = inventory[idx1]
	inventory[idx1] = inventory[idx2]
	inventory[idx2] = tmp

func remove_item_at_idx(idx):
	if not inventory.has(idx):
		print("ERROR: Invalid idx ", idx, " passed to PlayerInventory.remove_item_at_idx")
	else:
		inventory.erase(idx)		
	
func add_item(item_id, quantity):
	# Journal pages don't go into the 'inventory', they go into the journal (if the journal is found)
	# TODO: this is funky- we should really have the logic somewhere else like in a dediated scene
#       for the journal pages, but this works for now... just not extendable.
	if "journalpage" in item_id:
		for item in inventory:
			if inventory[item][0] == "journal":
				emit_signal("picked_up_journal_page", item_id)
				return
		# we don't have the journal yet, add it to the inventory until we get the journal
	elif "journal" in item_id:
		emit_signal("picked_up_journal")
		# check to see if we have journal pages pending to go into journal
		for item in inventory:
			if "journalpage" in inventory[item][0]:
				emit_signal("picked_up_journal_page", inventory[item][0])
				inventory.erase(item)
	
	# try to find item_id in the inventory already
	for item in inventory:
		if inventory[item][0] == item_id:
			inventory[item][1] += quantity
			return
	# item_id not in inventory; try to find an open slot
	for i in range(NUM_INVENTORY_SLOTS):
		if not inventory.has(i):
			inventory[i] = [item_id, quantity]
			return
	# we didn't find an open slot
	print("ERROR: Max inventory size reached. Unable to add item: ", item_id)

func remove_item(item_id, quantity):
	for item in inventory:
		if inventory[item][0] == item_id:
			inventory[item][1] -= quantity
			if inventory[item][1] == 0:
				inventory.erase(item)
			return
	print("ERROR: Unable to find item ", item_id, " to remove from inventory.")

func reset():
	inventory.clear()
