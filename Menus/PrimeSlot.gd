extends Panel
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_mind_button_pressed():
	$"../..".primeSlot = "MIND"
	pass # Replace with function body.

func _on_body_button_pressed():
	$"../..".primeSlot = "BODY"
	pass # Replace with function body.
	
func _on_spirit_button_pressed():
	$"../..".primeSlot = "SPIRIT"
	pass # Replace with function body.
