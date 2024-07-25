extends CanvasLayer

@onready var textbox_container = $OuterMarginContainer
@onready var start_symbol = $OuterMarginContainer/Panel/MarginContainer/HBoxContainer/Start
@onready var end_symbol = $OuterMarginContainer/Panel/MarginContainer/HBoxContainer/End
@onready var label = $OuterMarginContainer/Panel/MarginContainer/HBoxContainer/Label

func _ready():
	display_textbox("Oh no! My light is fading!\nHow can I make it last longer?")

func hide_textbox():
	start_symbol.text = ""
	end_symbol.text = ""
	label.text = ""
	textbox_container.hide()
	
func display_textbox(new_label):
	start_symbol.text = ">"
	end_symbol.text = "[Enter]"
	label.text = new_label
	label.visible_ratio = 0
	var tween = get_tree().create_tween()
	tween.tween_property(label, "visible_ratio", 1.0, 2.0)
	textbox_container.show()

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		hide_textbox()
