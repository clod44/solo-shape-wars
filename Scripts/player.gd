extends RigidBody2D

@export var move_speed = 5.0
@export var forward_boost = 2.0

@onready var weapon_manager := $WeaponsManager

@onready var engine_sound = $EngineSound
@export var min_pitch = 0.5
@export var max_pitch = 3.0
@export var max_expected_linear_velocity_mag = 2000.0

var shooting_weapons = [false]

func _process(_delta):
	# Reset all flags
	for i in range(shooting_weapons.size()):
		shooting_weapons[i] = false

	# Shoot
	if Input.is_action_pressed("shoot"):
		shooting_weapons[0] = true

func _physics_process(_delta):
	for is_shooting in shooting_weapons:
		if is_shooting:
			weapon_manager.shootAll()

	var move_input = Vector2(
		Input.get_action_strength("move_right") -
		Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") -
		Input.get_action_strength("move_up")
	)

	# Normalize move_input and look direction
	move_input = move_input.normalized()
	var mouse_pos = get_global_mouse_position()
	var player_pos = global_position
	var look_dir = (mouse_pos - player_pos).normalized()

	# Calculate dot product to check if moving forward
	var dot_product = move_input.dot(look_dir)

	# Apply different speeds based on forward or not
	var speed_addition = max(1, 1 + (forward_boost * dot_product))
	var total_speed = move_speed * speed_addition
	apply_impulse(move_input * total_speed)

	# Rotate player to look at mouse
	var angle = look_dir.angle()
	var current_angle = rotation
	var torque = wrapf(angle - current_angle, -PI, PI) * move_speed * 10.0
	apply_torque_impulse(torque)
	
	
	# Adjust pitch based on linear velocity
	var velocityMagnitude = linear_velocity.length()
	var pitch = lerp(min_pitch, max_pitch, velocityMagnitude / max_expected_linear_velocity_mag)
	engine_sound.pitch_scale = pitch
