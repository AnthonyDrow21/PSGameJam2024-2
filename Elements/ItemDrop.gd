# World version of an item that exists on the map
# TODO: Add animation so the item can bobble around all cute n stuff
extends CharacterBody2D

var label: String

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Call after instantiate
func with_data(aLabel):
	label = aLabel

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
