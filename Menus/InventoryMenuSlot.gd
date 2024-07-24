extends Panel

var ItemUIClass = preload("res://Elements/ItemUI.tscn")
var selectedItem = null

func move_item_out_of_slot():
	remove_child(selectedItem)
	var inventoryNode = find_parent("InventoryMenu")
	inventoryNode.add_child(selectedItem)
	selectedItem = null
	
func move_item_into_slot(new_item):
	selectedItem = new_item
	selectedItem.position = Vector2(self.size.x/2, self.size.y/2)
	var inventoryNode = find_parent("InventoryMenu")
	inventoryNode.remove_child(selectedItem)
	add_child(selectedItem)

func initialize_item(item_id, item_quantity):
	selectedItem = ItemUIClass.instantiate().with_id(item_id, item_quantity)
	selectedItem.position = Vector2(self.size.x/2, self.size.y/2)
	add_child(selectedItem)
