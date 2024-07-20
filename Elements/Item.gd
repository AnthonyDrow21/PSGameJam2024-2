# Inventory version of an item
extends Node2D

var label : String
var description : String

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Call this with instantiate() to set up item data
func with_data(aLabel, aIconPath, aDescription):
	$iconTextureRect.texture = load(aIconPath)
	label = aLabel
	description = aDescription
	return self
