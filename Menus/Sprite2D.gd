extends Sprite2D

var mindImage = preload("res://Assets/MenuArt/MindSymbol.png")
var bodyImage = preload("res://Assets/MenuArt/BodySymbol.png")
var spiritImage = preload("res://Assets/MenuArt/SpiritSymbol.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_mind_button_pressed():
	set_texture(mindImage)
	pass # Replace with function body.

func _on_body_button_pressed():
	set_texture(bodyImage)
	pass # Replace with function body.

func _on_spirit_button_pressed():
	set_texture(spiritImage)
	pass # Replace with function body.
