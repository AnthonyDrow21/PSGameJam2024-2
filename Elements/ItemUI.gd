# Inventory version of an item
extends Node2D

var item_id : String
var label : String
var description : String
var icon_path : String
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
	
	if FileAccess.file_exists(itemDef.icon_path):
		icon_path = itemDef.icon_path
		$iconTextureRect.texture = load(itemDef.icon_path)
	else:
		print("Error: Unable to create ItemUI with icon ", itemDef.icon_path)
	
	if FileAccess.file_exists(itemDef.audio_path):
		$ItemInteract.stream = load(itemDef.audio_path)
	else:
		print("Error: Unable to create ItemUI with sound path ", itemDef.audio_path)
	return self

func edit_quantity(quantity):
	item_quantity += quantity
	$quantityLabel.text = str(item_quantity)
