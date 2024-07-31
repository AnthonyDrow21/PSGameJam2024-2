extends Control

var optionsMenuActive = false

# Called when the node enters the scene tree for the first time.
func _ready():
	scaleImageToViewport()
	PlayerInventory.reset()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Update the Image scale every frame. We can improve this by checking if a change has occured.
	scaleImageToViewport();
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

func scaleImageToViewport():
	var viewportWidth = get_viewport().size.x
	var viewportHeight = get_viewport().size.y

	var scaleX = viewportWidth / $TitleSprite.texture.get_size().x
	var scaleY = viewportHeight / $TitleSprite.texture.get_size().y
	
	# Optional: Center the sprite, required only if the sprite's Offset>Centered checkbox is set
	$TitleSprite.set_position(Vector2(viewportWidth / 2, viewportHeight / 2))

	# Set same scale value horizontally/vertically to maintain aspect ratio
	# If however you don't want to maintain aspect ratio, simply set different
	# scale along x and y
	$TitleSprite.set_scale(Vector2(scaleX, scaleY))
