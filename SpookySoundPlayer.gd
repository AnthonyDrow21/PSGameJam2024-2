extends AudioStreamPlayer

const MAIN_SOUND = "res://Assets/Sounds/horror_01_drone_01.ogg"


func on_light_dying():
	print("Audio sees that the light is dying")
	stream = load(MAIN_SOUND)
	play()

	
func on_light_revived():
	print("Audio sees that the light is revived")
	stop()
