extends AudioStreamPlayer

const SUB_SOUNDS = [	
	"res://Assets/Sounds/Ghost_moan_2.wav",
	"res://Assets/Sounds/Monster_growl_1.wav",
	"res://Assets/Sounds/Hiss.wav",
	"res://Assets/Sounds/Monster_Roar_4.wav"
	]
	
var index = 0

func on_light_dying():
	print("Audio sees that the light is dying")
	stream = load(SUB_SOUNDS[index])
	
	index += 1 # play another sound next time
	if index == SUB_SOUNDS.size():
		index = 0 # loop back to 0 idx if we're at the end
	
	play()

func on_light_revived():
	print("Audio sees that the light is revived")
	stop()

