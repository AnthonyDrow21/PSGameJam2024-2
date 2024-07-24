extends Node2D

var ItemDrop = preload("res://Elements/ItemDrop.tscn")

var INVENTORY_MENU = preload("res://Menus/InventoryMenu.tscn").instantiate()
var inInventoryMenu = false

var PAUSE_MENU = preload("res://Menus/PauseMenu.tscn").instantiate()
var inPauseMenu = false
var paused = false


func add_menu(menu):
	# The CanvasLayer is uneffected by the game lighting models.
	get_tree().current_scene.get_node("CanvasLayer").add_child(menu)


# Called when the node enters the scene tree for the first time.
func _ready():
	$Player/CharacterBody2D/PointLight2D.connect("game_over", on_game_over)
	test_spawn_items()
	add_menu(INVENTORY_MENU)
	INVENTORY_MENU.hide()
	
	add_menu(PAUSE_MENU)
	PAUSE_MENU.toggle_pause.connect(on_pause_toggled)
	PAUSE_MENU.restart_requested.connect(on_restart)
	PAUSE_MENU.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if not inPauseMenu:
			PAUSE_MENU.show()
			inPauseMenu = true			
		else:
			PAUSE_MENU.hide()
			on_pause_toggled(false) # pause menu won't emit if we 'close' it manually with ESC
			inPauseMenu = false
			
	elif event.is_action_pressed("toggle_inventory"):
		# only process inventory menu toggle if the game is not paused!
		if not inPauseMenu:
			if not inInventoryMenu:
				INVENTORY_MENU.prepare_for_show()
				INVENTORY_MENU.show()
				inInventoryMenu = true
			else:
				INVENTORY_MENU.hide()
				inInventoryMenu = false

func on_pause_toggled(is_paused):
	if not is_paused:
		PAUSE_MENU.hide()
		inPauseMenu = false
	paused = is_paused
	get_tree().paused = paused
	print("Paused: ", paused)
	
func on_restart():
	PlayerInventory.reset()
	get_tree().change_scene_to_file("res://World.tscn")
	
func on_game_over(didWin):
	if INVENTORY_MENU.visible:
		INVENTORY_MENU.hide()
		inInventoryMenu = false
	
	var gameOverMenu = load("res://Menus/GameOverMenu.tscn").instantiate()
	gameOverMenu.toggle_pause.connect(on_pause_toggled)
	gameOverMenu.restart_requested.connect(on_restart)
	add_menu(gameOverMenu)
	
# test spawning in some items 
func test_spawn_items():
	const offset = 200
	# we could be more clever about this, but just testing for now
	var item1 = ItemDrop.instantiate().with_id("green_potion")
	get_tree().current_scene.add_child(item1)
	item1.position.x = $Player.position.x + offset
	item1.position.y = $Player.position.y
	
	var item2 = ItemDrop.instantiate().with_id("black_potion")
	get_tree().current_scene.add_child(item2)
	item2.position.x = $Player.position.x
	item2.position.y = $Player.position.y + offset
	
	var item3 = ItemDrop.instantiate().with_id("green_potion")
	get_tree().current_scene.add_child(item3)
	item3.position.x = $Player.position.x - offset
	item3.position.y = $Player.position.y
	
	var item4 = ItemDrop.instantiate().with_id("black_potion")
	get_tree().current_scene.add_child(item4)
	item4.position.x = $Player.position.x
	item4.position.y = $Player.position.y - offset
	
	var item5 = ItemDrop.instantiate().with_id("pink_potion")
	get_tree().current_scene.add_child(item5)
	item5.position.x = $Player.position.x + offset
	item5.position.y = $Player.position.y + offset
	
	var item6 = ItemDrop.instantiate().with_id("pink_potion")
	get_tree().current_scene.add_child(item6)
	item6.position.x = $Player.position.x - offset
	item6.position.y = $Player.position.y - offset
