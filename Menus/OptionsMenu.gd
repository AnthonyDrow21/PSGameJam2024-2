extends Control

signal exiting_options

@onready var devModeLabel = $TextureRect/TabContainer/Gameplay/VBoxContainer/GridContainer/Label2
@onready var devModeButton = $TextureRect/TabContainer/Gameplay/VBoxContainer/GridContainer/developerModeButton

func load_difficulty_option():
	var difficultyButton = find_child("difficultyButton") as OptionButton
	assert(GameSettings.difficulty >= 0)
	assert(GameSettings.difficulty < difficultyButton.item_count)
	difficultyButton.select(GameSettings.difficulty)
	
	var devModeButton = find_child("developerModeButton") as CheckButton
	devModeButton.button_pressed = GameSettings.devModeOn
	
# Called when the node enters the scene tree for the first time.
func _ready():
	load_difficulty_option()
	devModeLabel.hide()
	devModeButton.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_back_button_pressed():
	# remove ourselves
	get_parent().remove_child(get_node("."))
	emit_signal("exiting_options")


func _on_difficulty_button_item_selected(index):
	assert(index >= 0)
	assert(index < GameSettings.DIFFICULTY_LEVEL.size())
	GameSettings.difficulty = index


func _on_developer_mode_button_toggled(toggled_on):
	GameSettings.devModeOn = toggled_on
