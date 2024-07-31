extends Node

var id : String
var label : String
var description : String
var animation_name : String
var audio_path : String
var icon_path : String
var is_shiny : bool

func with_data(a_id, a_label, a_description, a_animation_name, a_audio_path, a_icon_path, a_is_shiny = false):
	id = a_id
	label = a_label
	description = a_description
	animation_name = a_animation_name
	audio_path = a_audio_path
	icon_path = a_icon_path
	is_shiny = a_is_shiny
	return self
