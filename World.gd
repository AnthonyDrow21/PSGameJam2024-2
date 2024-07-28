extends Node2D

var ItemDrop = preload("res://Elements/ItemDrop.tscn")

var CRAFTING_MENU = preload("res://Menus/CraftingMenu.tscn").instantiate()
var INVENTORY_MENU = preload("res://Menus/InventoryMenu.tscn").instantiate()
var JOURNAL_MENU = preload("res://Menus/Journal/JournalMenu.tscn").instantiate()
var PAUSE_MENU = preload("res://Menus/PauseMenu.tscn").instantiate()

var Menus_Hidden = []
var paused = false

func add_menu(menu):
	# The CanvasLayer is uneffected by the game lighting models.
	get_tree().current_scene.get_node("CanvasLayer").add_child(menu)

func hide_game_menu_if_visible(menu):
	if menu.visible:
		Menus_Hidden.push_back(menu)
		menu.hide()

func show_hidden_menus(visible):
	for menu in Menus_Hidden:
		menu.show()
	Menus_Hidden.clear()

# Called when the node enters the scene tree for the first time.
func _ready():
	$Player/CharacterBody2D/PointLight2D.connect("game_over", on_game_over)	
	
	add_menu(INVENTORY_MENU)
	INVENTORY_MENU.toggle_inventory.connect(toggle_inventory_menu)
	INVENTORY_MENU.toggle_journal.connect(toggle_journal_menu) # open journal from inventory menu
	INVENTORY_MENU.hide()
	
	add_menu(CRAFTING_MENU) # crafting menu will get toggled with inventory
	CRAFTING_MENU.hide()
	
	add_menu(JOURNAL_MENU)
	JOURNAL_MENU.toggle_journal.connect(toggle_journal_menu) # close journal from journal menu
	JOURNAL_MENU.hide()	
	
	add_menu(PAUSE_MENU)
	PAUSE_MENU.toggle_pause.connect(toggle_pause_menu)
	PAUSE_MENU.restart_requested.connect(on_restart)
	PAUSE_MENU.hide()
	
	# initialize spawn zones
	for zone in get_tree().get_nodes_in_group("SpawnZones"):
		zone._initialize()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func toggle_pause_menu(open):
	if not open:
		show_hidden_menus(true)
		PAUSE_MENU.hide()
	else:
		# Hide all game menus when we open pause menu
		hide_game_menu_if_visible(INVENTORY_MENU)
		hide_game_menu_if_visible(CRAFTING_MENU)
		hide_game_menu_if_visible(JOURNAL_MENU)
		PAUSE_MENU.show()
	toggle_pause(open)

func toggle_inventory_menu(open):
	if not open:
		INVENTORY_MENU.hide()
		CRAFTING_MENU.hide()
	else:
		INVENTORY_MENU.prepare_for_show()
		INVENTORY_MENU.show()
		CRAFTING_MENU.show()
	toggle_pause(open)
	
func toggle_journal_menu(open):
	if not open:
		show_hidden_menus(true)
		JOURNAL_MENU.hide()
	else:
		# Hide inventory/crafting menu when we open journal
		hide_game_menu_if_visible(INVENTORY_MENU)
		hide_game_menu_if_visible(CRAFTING_MENU)
		JOURNAL_MENU.show()
	toggle_pause(open)

func toggle_pause(is_paused):
	paused = is_paused
	get_tree().paused = paused
	
func on_restart():
	PlayerInventory.reset()
	get_tree().change_scene_to_file("res://World.tscn")
	
func on_game_over(didWin):	
	toggle_pause(true)
	var gameOverMenu = load("res://Menus/GameOverMenu.tscn").instantiate()
	gameOverMenu.restart_requested.connect(on_restart)
	add_menu(gameOverMenu)
