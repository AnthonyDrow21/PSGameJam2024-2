extends Control

var ItemDrop = preload("res://Elements/ItemDrop.tscn")
var paused = false

# Called when the node enters the scene tree for the first time.
func _ready():
	test_spawn_items()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("ui_cancel"):
		if not paused:
			var pauseMenu = load("res://Menus/PauseMenu.tscn").instantiate()
			pauseMenu.toggle_pause.connect(on_pause_toggled)
			
			# The CanvasLayer is uneffected by the game lighting models.
			get_tree().current_scene.get_node("CanvasLayer").add_child(pauseMenu)

func on_pause_toggled(is_paused):
	paused = is_paused
	get_tree().paused = paused
	print("Paused: ", paused)
	
func on_restart():
	print("UNIMPLEMNTED: User requested game restart")
	
# test spawning in some items 
func test_spawn_items():
	const offset = 200
	# we could be more clever about this, but just testing for now
	var item1 = ItemDrop.instantiate().with_data("potion_green", "green")
	get_tree().current_scene.add_child(item1)
	item1.position.x = $Player.position.x + offset
	item1.position.y = $Player.position.y
	
	var item2 = ItemDrop.instantiate().with_data("potion_black", "black")
	get_tree().current_scene.add_child(item2)
	item2.position.x = $Player.position.x
	item2.position.y = $Player.position.y + offset
	
	var item3 = ItemDrop.instantiate().with_data("potion_green", "green")
	get_tree().current_scene.add_child(item3)
	item3.position.x = $Player.position.x - offset
	item3.position.y = $Player.position.y
	
	var item4 = ItemDrop.instantiate().with_data("potion_black", "black")
	get_tree().current_scene.add_child(item4)
	item4.position.x = $Player.position.x
	item4.position.y = $Player.position.y - offset
