extends Area2D

func _on_body_entered(body):
	var sceneChanger = load("res://Globals/SceneChanger.tscn").instantiate()
	add_child(sceneChanger)
	sceneChanger.change_scene("res://Maps/Outro.tscn", 0)
