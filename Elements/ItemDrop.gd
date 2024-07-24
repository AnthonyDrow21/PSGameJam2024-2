# World version of an item that exists on the map
# TODO: Add animation so the item can bobble around all cute n stuff
extends CharacterBody2D

const acceleration = 460
const max_speed = 500

var id: String
var label: String
var animationName: String

var player = null
var being_picked_up = false
var is_playing = false;

# Called when the node enters the scene tree for the first time.
func _ready():
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
	var itemDef = ItemDatabase.get_item(item_id)
	id = itemDef.id
	label = itemDef.label
	animationName = itemDef.animationName
	
	if FileAccess.file_exists(itemDef.audioPath):
		var file = FileAccess.open(itemDef.audioPath, FileAccess.READ)
		var buffer = file.get_buffer(file.get_length())
		var stream = AudioStreamMP3.new()
		stream.data = buffer
		$PickupAudio.stream = stream
	else:
		print("Error: Unable to create ItemUI with sound path ", itemDef.audioPath)
	return self

func pick_up_item(body):
	player = body
	being_picked_up = true

func _on_pickup_audio_finished() -> void:
	PlayerInventory.add_item(label, 1)
	queue_free()
