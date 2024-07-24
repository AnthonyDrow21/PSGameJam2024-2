extends CharacterBody2D

const SPEED = 300.0
const IDLE = 0
const RUNNING = 1
const CHARGE = 2
const DAMAGE = 3

@onready var _animated_sprite = $AnimatedSprite2D
@onready var _point_light_2d = $PointLight2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var animations = {IDLE: "idle", RUNNING: "running", CHARGE: "charge", DAMAGE: "damage"}
var current_animation = IDLE;


func player_pickup_item():
	# Pick up an item
	if $PickupZone.items_in_range.size() > 0:
		#print("Zone items: ", $PickupZone.items_in_range)
		
		var pickup_item = $PickupZone.items_in_range.values()[0]
		pickup_item.pick_up_item(self)
		$PickupZone.items_in_range.erase(pickup_item)

		print("Picked up item: ", pickup_item.id)
		PlayerInventory.add_item(pickup_item.id, 1)
	
# Called when the node enters the scene tree for the first time.
func _ready():
	_animated_sprite.play(animations.get(current_animation))
	
func _input(event):
	if event.is_action_pressed("ui_charge"):
		current_animation = CHARGE
	elif event.is_action_pressed("ui_damage"):
		current_animation = DAMAGE
	elif event.is_action_pressed("ui_select"):
		player_pickup_item()
		
	_animated_sprite.play(animations.get(current_animation))

func _physics_process(delta):
	if _animated_sprite.is_playing():
		if current_animation == DAMAGE || current_animation == CHARGE:
			return
	
	# Get the input direction and handle the movement/deceleration.
	var directionX = Input.get_axis("ui_left", "ui_right")
	var directionY = Input.get_axis("ui_up", "ui_down")
	
	if directionX:
		velocity.x = directionX * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if directionY:
		velocity.y = directionY * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)

	if abs(velocity.x) > 0:
		# The sprite is moving so we need to update the animation frames
		# and flip them horizontally to match the direction of travel.
		current_animation = RUNNING
		_animated_sprite.flip_h = 1 if directionX < 0 else 0
	else:
		current_animation = IDLE

	_animated_sprite.play(animations.get(current_animation))
	move_and_slide()
