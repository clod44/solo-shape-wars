extends RigidBody2D

var damage_indicator_scene = preload("res://Scenes/damage_indicator.tscn")
@export var health := 100.0 :
	set (value):
		apply_damage(health - value)
		health = value
@export var move_speed := 30
var attack_target : Node2D
@export var color := Color(0,1,0,1)
@export var damaged_color := Color(1,0,0,1)
var current_color := Color(1,1,1, 0.2)
@onready var color_indicator := $ColorRect

@onready var engine_sound = $EngineSound
@export var min_pitch = 0.5
@export var max_pitch = 3.0
@export var max_expected_linear_velocity_mag = 2000.0
@onready var weapon_manager = $WeaponsManager

func _ready():
	current_color = color
	attack_target = get_node("/root/Game/Player")

func _process(_delta):
	weapon_manager.shootAll()
	
func _physics_process(delta):
	current_color.lerp(color, 0.5)
	color_indicator.color = current_color
	if attack_target:
		var direction = Vector2.RIGHT.rotated(rotation)
		apply_impulse(direction * move_speed)


	# Rotate player to look at mouse
	var look_dir = (attack_target.global_position - global_position).normalized()
	var angle = look_dir.angle()
	var current_angle = rotation
	var torque = wrapf(angle - current_angle, -PI, PI) * (move_speed + 1) * 10.0
	apply_torque_impulse(torque)


	# Adjust pitch based on linear velocity
	var velocityMagnitude = linear_velocity.length()
	var pitch = lerp(min_pitch, max_pitch, velocityMagnitude / max_expected_linear_velocity_mag)
	engine_sound.pitch_scale = pitch
	
	


func apply_damage(amount):
	current_color = current_color.lerp(damaged_color, clamp(amount/health,0,1))
	
	var temp_effects = get_tree().get_root().get_node("Game/ActiveEffects")
	var new_damage_indicator = damage_indicator_scene.instantiate()
	new_damage_indicator.global_position = global_position
	new_damage_indicator.text = str(amount) + " DMG"
	temp_effects.call_deferred("add_child", new_damage_indicator)
	
	if health < 1:
		queue_free()


