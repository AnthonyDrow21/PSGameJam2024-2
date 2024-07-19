extends CharacterBody2D


const SPEED = 300.0
const IDLE = 0
const RUNNING = 1
const CHARGE = 2
const DAMAGE = 3

@onready var _animated_sprite = $AnimatedSprite2D
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var animations = {IDLE: "idle", RUNNING: "running", CHARGE: "charge", DAMAGE: "damage"}
var current_animation = IDLE;

# Called when the node enters the scene tree for the first time.
func _ready():
	_animated_sprite.play(animations.get(current_animation))
	
func _input(event):
	if event.is_action_pressed("ui_charge"):
		current_animation = CHARGE
	elif event.is_action_pressed("ui_damage"):
		current_animation = DAMAGE
		
	_animated_sprite.play(animations.get(current_animation))

func _physics_process(delta):
	if _animated_sprite.is_playing():
		if current_animation == DAMAGE || current_animation == CHARGE:
			return
	
	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if abs(velocity.x) > 0:
		# The sprite is moving so we need to update the animation frames
		# and flip them horizontally to match the direction of travel.
		current_animation = RUNNING
		_animated_sprite.flip_h = 1 if direction < 0 else 0
	else:
		current_animation = IDLE

	_animated_sprite.play(animations.get(current_animation))
	move_and_slide()
