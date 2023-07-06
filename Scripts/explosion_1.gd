extends GPUParticles2D

@export var explosionForce: float = 15000.0
@export var explosionTextures: Array = [
	preload("res://Assets/Textures/Particles/light_01.png"),
	preload("res://Assets/Textures/Particles/scorch_01.png"),
	preload("res://Assets/Textures/Particles/scorch_02.png"),
	preload("res://Assets/Textures/Particles/scorch_03.png"),
	preload("res://Assets/Textures/Particles/smoke_01.png"),
	preload("res://Assets/Textures/Particles/smoke_02.png"),
	preload("res://Assets/Textures/Particles/smoke_03.png"),
	preload("res://Assets/Textures/Particles/smoke_04.png"),
	preload("res://Assets/Textures/Particles/smoke_05.png"),
	preload("res://Assets/Textures/Particles/smoke_06.png"),
	preload("res://Assets/Textures/Particles/smoke_07.png"),
	preload("res://Assets/Textures/Particles/smoke_08.png"),
	preload("res://Assets/Textures/Particles/smoke_09.png"),
	preload("res://Assets/Textures/Particles/smoke_10.png")
]
@export var effect_lifetime := 2.0
@export var explosion_force_lifetime := 0.3
@onready var explosionArea: Area2D = $Area2D

func _ready():
	$ExplosionSound.play()
	Global.camera.shake(1,5)
	$Shockwave.one_shot = true
	$Shockwave.emitting = true
	one_shot = true
	emitting = true
	texture = explosionTextures.pick_random()
	explosionArea.connect("body_entered", _on_body_entered)
	start_lifetime_timer()
	start_explosion_force_timer()
	
func start_lifetime_timer():
	await get_tree().create_timer(effect_lifetime).timeout
	queue_free()
	
func start_explosion_force_timer():
	await get_tree().create_timer(explosion_force_lifetime).timeout
	explosionArea.set_deferred("monitorable", false) 

func _on_body_entered(body):
	if body is RigidBody2D:
		var direction = (body.global_position - explosionArea.global_position).normalized()
		var distance = body.global_position.distance_to(explosionArea.global_position)
		var force = direction * (explosionForce / distance)
		body.apply_central_impulse(force)

