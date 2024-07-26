extends CanvasLayer

@export_file("*.json") var dialogue_file

@onready var textbox_container = $OuterMarginContainer
@onready var start_symbol = $OuterMarginContainer/Panel/MarginContainer/HBoxContainer/Start
@onready var end_symbol = $OuterMarginContainer/Panel/MarginContainer/HBoxContainer/End
@onready var middle_text = $OuterMarginContainer/Panel/MarginContainer/HBoxContainer/Text

enum State {
	NotVisible,
	NowPlaying,
	Finished
}

var dialogue = []
var current_state = State.NotVisible

func update_state(new_state):
	current_state = new_state
	
	var debug_string = ""
	if current_state == State.NotVisible:
		debug_string = "Not Visible"
	elif current_state == State.NowPlaying:
		debug_string = "Now Playing"
	elif current_state == State.Finished:
		debug_string = "Finished"
	else:
		debug_string = "Unknown"
		
	print(debug_string)

func _ready():
	display_textbox("You", "Oh no! My light is fading!\nHow can I make it last longer?")
	dialogue = load_dialogue()
	#display_textbox(dialogue[0]["text"])

func hide_textbox():
	start_symbol.text = ""
	end_symbol.text = ""
	middle_text.text = ""
	textbox_container.hide()
	
func tween_done():
	update_state(State.Finished)

func display_textbox(new_label, new_text):
	if current_state == State.NowPlaying || current_state == State.Finished:
		return
	
	update_state(State.NowPlaying)
	print("display_textbox: " + new_label)
	start_symbol.text = new_label + ": "
	end_symbol.text = "[Enter]"
	middle_text.text = new_text
	middle_text.visible_ratio = 0.0
	var tween = get_tree().create_tween()
	tween.tween_property(middle_text, "visible_ratio", 1.0, 0.075 * len(new_text))
	tween.tween_callback(tween_done)
	textbox_container.show()

func _process(delta):
	if Input.is_action_just_pressed("ui_accept") && current_state == State.Finished:
		hide_textbox()
		update_state(State.NotVisible)

func load_dialogue():
	var file = FileAccess.open(dialogue_file, FileAccess.READ)
	var content = JSON.parse_string(file.get_as_text())
	return content
	
func display_dialogue_for(who):
	var phrases = []
	
	for entry in dialogue:
		if entry["name"] == who:
			phrases.push_back(entry["text"])
			
	display_textbox(who, phrases[randi() % phrases.size()])
