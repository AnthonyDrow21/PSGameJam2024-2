# TODO: Figure out how to get a highlight box around the selected item!
# TODO: Keep order that the player arranges through drag-and-drop!
extends Control

signal toggle_inventory(open)
signal toggle_journal(open)
signal send_item_signal(item)
const SlotClass = preload("res://Menus/InventoryMenuSlot.gd")

var heldItem = null
var hoverSlot = null

func reset():
	heldItem = null
	hoverSlot = null
	for slot in $ColorRect/HBoxContainer/GridContainer.get_children():
		slot.reset()

func prepare_for_show():
	reset()
	
	# preparing to show the inventory to the user; load the items in
	var slots = $ColorRect/HBoxContainer/GridContainer.get_children()
	assert(slots.size() == PlayerInventory.NUM_INVENTORY_SLOTS)
	
	for item_idx in PlayerInventory.inventory:
		var item_id = PlayerInventory.inventory[item_idx][0]
		var item_quantity = PlayerInventory.inventory[item_idx][1]
		slots[item_idx].initialize_item(item_id, item_quantity)

	# select the first slot so the user is looking at something
	update_selected_item_view(slots[0])

func _ready():
	var slot_idx = 0
	for slot in $ColorRect/HBoxContainer/GridContainer.get_children():
		slot.slot_idx = slot_idx
		slot_idx += 1
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
		var image = Image.load_from_file(item.icon_path)
		$ColorRect/HBoxContainer/VBoxContainer/itemImage.texture = ImageTexture.create_from_image(image)
		
		# todo: this is pretty ugly- if we want a use button for any other type, we need to add
		# it here... could implement some kind of usable system with callbacks for the item...
		if item.item_id == "journal":
			$ColorRect/HBoxContainer/VBoxContainer/openButton.show()
		else:
			$ColorRect/HBoxContainer/VBoxContainer/openButton.hide()
	else:
		$ColorRect/HBoxContainer/VBoxContainer/itemLabel.text = ""
		$ColorRect/HBoxContainer/VBoxContainer/itemDescription.text = ""
		$ColorRect/HBoxContainer/VBoxContainer/itemImage.texture = null
		$ColorRect/HBoxContainer/VBoxContainer/openButton.hide()

func update_active_slot(slot, activate):
	if activate:
		hoverSlot = slot
	else:
		hoverSlot = null

func move_item_into_empty_slot(from_slot, to_slot):
	PlayerInventory.remove_item_at_idx(from_slot.slot_idx)
	PlayerInventory.add_item_at_idx(to_slot.slot_idx, heldItem.item_id, heldItem.item_quantity)
	to_slot.move_item_into_slot(heldItem)
	heldItem = null
	
func swap_item_at_slot(from_slot, to_slot):
	PlayerInventory.swap_items_at_idx(from_slot.slot_idx, to_slot.slot_idx)
	
	# create tmp to store item at to_slot
	var tmp = to_slot.selectedItem
	to_slot.move_item_out_of_slot()
	
	# move held item into active slot
	to_slot.move_item_into_slot(heldItem)
	
	# put item that was at to_slot into from_slot
	from_slot.move_item_into_slot(tmp)
	
	# no longer holding an item
	heldItem = null
	
func slot_gui_input(event: InputEvent, slot:SlotClass):
	if event is InputEventMouseButton:
		# GRABBING ITEM FROM SLOT
		if event.button_index == MOUSE_BUTTON_LEFT && event.is_pressed():
			# If we click on a slot, update the view details
			update_selected_item_view(slot)
			
			# take ownership of the item at this slot so we can move it around between slots
			if slot.selectedItem: 
				heldItem = slot.selectedItem
				slot.move_item_out_of_slot()
				heldItem.global_position = get_global_mouse_position()
				
		# DROPPING ITEM INTO SLOT
		elif event.button_index == MOUSE_BUTTON_LEFT && event.is_released():
			if heldItem == null:
				return # no item to move
		
			# we are holding an item; move ownership to slot we're hovering over (if valid)
			if hoverSlot == null:
				# not hovering over a valid slot, put the item back into its old slot
				slot.move_item_into_slot(heldItem)
				heldItem = null
				return
			
			# dropping an item into a valid slot, move item into slot
			if !hoverSlot.selectedItem:
				move_item_into_empty_slot(slot, hoverSlot)
			else:
				swap_item_at_slot(slot, hoverSlot)
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			var item = slot.selectedItem
			send_item_ID(item)
			print(item)
			

func _input(event):
	if heldItem != null:
		heldItem.global_position = get_global_mouse_position()
	
	if event.is_action_pressed("toggle_inventory"):
		if not visible and not get_tree().paused:
			emit_signal("toggle_inventory", true)
		elif visible:
			emit_signal("toggle_inventory", false)

func _on_open_button_pressed():
	emit_signal("toggle_journal", true)
	
func send_item_ID(item):
	if item != null:
		emit_signal("send_item_signal", item)
		print(item.item_id)
	
