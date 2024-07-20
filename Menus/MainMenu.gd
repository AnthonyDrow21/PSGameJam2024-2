extends Control

var optionsMenuActive = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://World.tscn")

func on_options_menu_exiting():
	optionsMenuActive = false
	#print(GameSettings.difficulty)
	
func on_options_menu_opened():
	optionsMenuActive = true

func _on_options_button_pressed():
	if not optionsMenuActive:
		var optionsMenu = load("res://Menus/OptionsMenu.tscn").instantiate()
		optionsMenu.exiting_options.connect(on_options_menu_exiting)
		get_tree().current_scene.add_child(optionsMenu)
		on_options_menu_opened()

func _on_quit_button_pressed():
	get_tree().quit()
