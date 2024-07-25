# TODO: Figure out how to get a highlight box around the selected item!
# TODO: Keep order that the player arranges through drag-and-drop!
extends Control

const SlotClass = preload("res://Menus/InventoryMenuSlot.gd")

var heldItem = null
var activeSlot = null

func reset():
	for slot in $ColorRect/HBoxContainer/GridContainer.get_children():
		if slot.get_child_count() > 0:
			assert(slot.get_child_count() == 1) # should only ever have one item in the slot
			slot.remove_child(slot.get_children()[0])

func prepare_for_show():
	reset()
	
	# preparing to show the inventory to the user; load the items in
	var slots = $ColorRect/HBoxContainer/GridContainer.get_children()
	assert(slots.size() == PlayerInventory.NUM_INVENTORY_SLOTS)
	
	var slot_idx = 0
	for item_id in PlayerInventory.inventory:
		slots[slot_idx].initialize_item(item_id, PlayerInventory.inventory[item_id])
		slot_idx += 1

	# select the first slot so the user is looking at something
	update_selected_item_view(slots[0])

func _ready():
	for slot in $ColorRect/HBoxContainer/GridContainer.get_children():
		slot.gui_input.connect(slot_gui_input.bind(slot))
		slot.mouse_entered.connect(update_active_slot.bind(slot, true))
		slot.mouse_exited.connect(update_active_slot.bind(slot, false))

func update_selected_item_view(slot):
	if slot.get_child_count() > 0:
		assert(slot.get_child_count() == 1)
		var item = slot.get_children()[0]
		$ColorRect/HBoxContainer/VBoxContainer/itemLabel.text = item.label
		$ColorRect/HBoxContainer/VBoxContainer/itemDescription.text = item.description
		# todo: scaling is awful
		var image = Image.load_from_file(item.iconPath)
		$ColorRect/HBoxContainer/VBoxContainer/itemImage.texture = ImageTexture.create_from_image(image)
		
	else:
		$ColorRect/HBoxContainer/VBoxContainer/itemLabel.text = ""
		$ColorRect/HBoxContainer/VBoxContainer/itemDescription.text = ""
		$ColorRect/HBoxContainer/VBoxContainer/itemImage.texture = null

func update_active_slot(slot, activate):
	if activate:
		activeSlot = slot
	else:
		activeSlot = null

func slot_gui_input(event: InputEvent, slot:SlotClass):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT && event.is_pressed():
			#print("clicking on slot ", slot)
			update_selected_item_view(slot)
			if slot.selectedItem: # we are holding an item at this slot; take ownership
				heldItem = slot.selectedItem
				slot.move_item_out_of_slot()
				heldItem.global_position = get_global_mouse_position()
		elif event.button_index == MOUSE_BUTTON_LEFT && event.is_released():
			# NOTE: using 'activeSlot' here, since gui_input events are giving me first slot...
			#print("released on slot ", activeSlot)
			if heldItem != null: # we are holding an item; move ownership to slot we're hovering over
				if activeSlot != null: # hovering over a valid slot, move item into slot
					if !activeSlot.selectedItem:
						activeSlot.move_item_into_slot(heldItem)
						heldItem = null
					else: # there's already an item there
						# remove current item at active slot
						var tmp = activeSlot.selectedItem
						activeSlot.move_item_out_of_slot()
						# move held item into active slot
						activeSlot.move_item_into_slot(heldItem)
						tmp.global_position = event.global_position
						# put item that was at activeSlot into slot
						slot.move_item_into_slot(tmp)
						heldItem = null
				else: # not hovering over any slot, put the item back
					slot.move_item_into_slot(heldItem)
					heldItem = null

func _input(event):
	if heldItem != null:
		heldItem.global_position = get_global_mouse_position()
