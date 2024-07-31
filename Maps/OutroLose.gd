extends TileMap

# Called when the node enters the scene tree for the first time.
func _ready():	
	$AnimatedSprite2D.play("default") # witch
	$AnimatedSprite2D2.play("default") # frog

	var sceneChanger = load("res://Globals/SceneChanger.tscn").instantiate()
	add_child(sceneChanger)
	sceneChanger.change_scene("res://Menus/MainMenu.tscn", 6)
