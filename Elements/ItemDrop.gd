# World version of an item that exists on the map
# TODO: Add animation so the item can bobble around all cute n stuff
extends CharacterBody2D

const acceleration = 460
const max_speed = 500

var label: String
var animationName: String

var player = null
var being_picked_up = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play(animationName)

func _physics_process(delta):
	if being_picked_up == true:
		var direction = global_position.direction_to(player.global_position)
		velocity = velocity.move_toward(direction * max_speed, acceleration * delta)
		var distance = global_position.distance_to(player.global_position)
		if distance < 10:
			queue_free()
	move_and_slide()

# Call after instantiate
func with_data(aLabel, aAnimationName):
	animationName = aAnimationName	
	label = aLabel
	return self

func pick_up_item(body):
	player = body
	being_picked_up = true
