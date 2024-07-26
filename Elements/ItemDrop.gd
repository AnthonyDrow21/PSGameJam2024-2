# World version of an item that exists on the map
# TODO: Add animation so the item can bobble around all cute n stuff
extends CharacterBody2D

const acceleration = 460
const max_speed = 500

@export var id: String
var label: String
var animationName: String

var _initialized = false
var player = null
var being_picked_up = false
var is_playing = false;

signal picked_up

# Called when the node enters the scene tree for the first time.
func _ready():
	# If item is placed in the World through Godot UI, we will initialize it here
	if not _initialized:
		self.with_id(id)
	$AnimatedSprite2D.play(animationName)

func _physics_process(delta):
	if being_picked_up == true:
		var direction = global_position.direction_to(player.global_position)
		velocity = velocity.move_toward(direction * max_speed, acceleration * delta)
		var distance = global_position.distance_to(player.global_position)
		if distance < 10:
			if is_playing == false:
				is_playing = true;
				self.hide();
				$PickupAudio.play()
	move_and_slide()

# Call after instantiate
func with_id(item_id):
	_initialized = true
	
	var itemDef = ItemDatabase.get_item(item_id)
	id = itemDef.id
	label = itemDef.label
	animationName = itemDef.animationName
	
	if FileAccess.file_exists(itemDef.audioPath):
		$PickupAudio.stream = load(itemDef.audioPath)
	else:
		print("Error: Unable to create ItemUI with sound path ", itemDef.audioPath)
	return self

func pick_up_item(body):
	player = body
	being_picked_up = true
	emit_signal("picked_up")

func _on_pickup_audio_finished() -> void:
	queue_free()
