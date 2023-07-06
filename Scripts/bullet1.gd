extends RigidBody2D

# if it is an ammo, nothing will trigger. this object will be placehodler to copy from
@export var isAmmo = false
@export var lifetime = 1.5
@export var damage = 10
@export var damage_variety = 5
@export var lifetime_variation := 0.5
@export var bullet_speed := 1500.0
@export var bullet_speed_variation := 200.0
@export var explosion_scene = preload("res://Scenes/explosion_1.tscn")
@export var hit_effect_scene = preload("res://Scenes/hit_effect_1.tscn")
var damage_indicator_scene = preload("res://Scenes/damage_indicator.tscn")

func _ready():
	if isAmmo:
		set_process(false)
		set_physics_process(false)
		return
	
	$BulletSound.play()
	lifetime += randf_range(-lifetime_variation, lifetime_variation)
	bullet_speed += randf_range(-bullet_speed_variation, bullet_speed_variation)
	damage += ceil(randf_range(-damage_variety, damage_variety))
	apply_impulse(Vector2(0,-bullet_speed).rotated(rotation))
	
	lifetime += randf_range(0.0, 0.5)
	start_bullet_lifetime()
	
func start_bullet_lifetime():
	await get_tree().create_timer(lifetime).timeout
	queue_free()
	


func _on_body_entered(body):
	var new_explosion = explosion_scene.instantiate()
	var new_hit_effect = hit_effect_scene.instantiate()
	new_explosion.global_position = global_position
	new_hit_effect.global_position = global_position
	new_hit_effect.global_rotation = rotation
	var temp_effects = get_tree().get_root().get_node("Game/ActiveEffects")
	if not body.get("health") == null:
		body.health -= damage
	temp_effects.call_deferred("add_child", new_explosion)
	temp_effects.call_deferred("add_child", new_hit_effect)
	
	#damage indicator effect
	var new_damage_indicator = damage_indicator_scene.instantiate()
	new_damage_indicator.global_position = global_position
	new_damage_indicator.text = str(damage) + " DMG"
	temp_effects.call_deferred("add_child", new_damage_indicator)
	
	queue_free()


