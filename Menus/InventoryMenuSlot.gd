extends Panel

var ItemClass = preload("res://Elements/Item.tscn")
var item = null

# Called when the node enters the scene tree for the first time.
func _ready():
	if randi() % 2 == 0:
		item = ItemClass.instantiate().with_data("pink_potion", "res://Assets/Items/Potions/Small Vial - PINK.png", "A mystical potion of unknown use.")
		add_child(item)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
