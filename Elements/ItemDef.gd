extends Node

var id : String
var label : String
var description : String
var animationName : String
var audioPath : String
var iconPath : String

func with_data(aId, aLabel, aDescription, aAnimationName, aAudioPath, aIconPath):
	id = aId
	label = aLabel
	description = aDescription
	animationName = aAnimationName
	audioPath = aAudioPath
	iconPath = aIconPath
	return self
