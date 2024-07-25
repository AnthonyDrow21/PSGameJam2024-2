# Inventory version of an item
extends Node2D

var item_id : String
var label : String
var description : String
var iconPath : String
var item_quantity : int

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Call this with instantiate() to set up item data
func with_id(item_id, quantity):
	self.item_id = item_id
	
	assert(quantity >= 1)
	edit_quantity(quantity)
		
	var itemDef = ItemDatabase.get_item(item_id)
	label = itemDef.label
	description = itemDef.description
	
	if FileAccess.file_exists(itemDef.iconPath):
		iconPath = itemDef.iconPath
		$iconTextureRect.texture = load(itemDef.iconPath)
	else:
		print("Error: Unable to create ItemUI with icon ", itemDef.iconPath)
	
	if FileAccess.file_exists(itemDef.audioPath):
		$ItemInteract.stream = load(itemDef.audioPath)
	else:
		print("Error: Unable to create ItemUI with sound path ", itemDef.audioPath)
	return self

func edit_quantity(quantity):
	item_quantity += quantity
	$quantityLabel.text = str(item_quantity)
