extends RigidBody2D

@export var lifetime = 1.5
@export var damage = 100
@export var damage_variety = 50
@export var lifetime_variation := 0.5
@export var missile_speed := 150.0
@export var missile_speed_variation := 10.0
@export var explosion_scene = preload("res://Scenes/explosion_1.tscn")
@export var hit_effect_scene = preload("res://Scenes/hit_effect_1.tscn")

var target: Node2D = null

func _ready():
	$MissileSound.play()
	lifetime += randf_range(-lifetime_variation, lifetime_variation)
	missile_speed += randf_range(-1, 1) * missile_speed_variation
	damage += ceil(randf_range(-damage_variety, damage_variety))
	
	lifetime += randf_range(0.0, 0.5)
	start_bullet_lifetime()
	
	# Connect signals
	connect("body_entered", _on_body_entered)
	$Area2D.connect("body_entered", _on_area_2d_body_entered)
	$Area2D.connect("body_exited", _on_area_2d_body_exited)
	
var look_dir = Vector2.ZERO
func _physics_process(delta):
	apply_impulse(Vector2(0, -missile_speed).rotated(rotation))
	if target != null:
		look_dir = (target.position - position).normalized()
		var angle = look_dir.angle()
		var current_angle = rotation
		var torque = wrapf(angle - current_angle + 90, -PI, PI) * 10.0
		#apply_torque_impulse(torque)
	queue_redraw()


func _draw():
	if target != null:
		print("s")
		draw_rect(Rect2(target.position.x,target.position.y, 200.0, 200.0), Color.BLUE, false, 1.0)
	draw_line(Vector2.ZERO, look_dir * 100, Color(0, 1, 0), 2)

func start_bullet_lifetime():
	await get_tree().create_timer(lifetime).timeout
	explode()

func explode():
	var new_explosion = explosion_scene.instantiate()
	var new_hit_effect = hit_effect_scene.instantiate()
	new_explosion.global_position = global_position
	new_hit_effect.global_position = global_position
	new_hit_effect.global_rotation = global_rotation
	var temp_effects = get_tree().get_root().get_node("Game/ActiveEffects")
	temp_effects.call_deferred("add_child", new_explosion)
	temp_effects.call_deferred("add_child", new_hit_effect)
	queue_free()

func _on_area_2d_body_entered(body):
	if body is RigidBody2D and body != self:
		if target == null:
			target = body
		else:
			var currentDistance = global_position.distance_squared_to(target.global_position)
			var newDistance = global_position.distance_squared_to(body.global_position)
			if newDistance < currentDistance:
				target = body
				
func _on_area_2d_body_exited(body):
	if body == target:
		target = null


func _on_body_entered(body):
	explode()


