extends Marker2D
@export var mirrored = true
@export var bullet_scene = preload("res://Scenes/bullet_1.tscn")
var carry_momentum := Vector2(0,0)
@onready var active_bullets := $ActiveBullets
@export var accuracy_variation := 0.1
@export var fire_rate := 0.05
var cooldown := false
@export var isEnemy = false
@onready var ammo = $Magazine/Bullet1


func shoot():
	if not cooldown:
		cooldown = true
		var new_bullet = bullet_scene.instantiate()
		updatePhysicsLayer(new_bullet)
		new_bullet.global_position = global_position
		new_bullet.global_rotation = global_rotation + randf_range(-accuracy_variation, accuracy_variation)
		#add momentum
		new_bullet.apply_impulse(carry_momentum)
		active_bullets.add_child(new_bullet)
		start_cooldown()
		
	
func start_cooldown():
	await get_tree().create_timer(fire_rate).timeout
	cooldown = false



func updatePhysicsLayer(node):
	if isEnemy:
		node.set_collision_layer_value(5, true)
		node.set_collision_mask_value(1, true)
		node.set_collision_mask_value(2, true)
	else:
		node.set_collision_layer_value(3, true)
		node.set_collision_mask_value(1, true)
		node.set_collision_mask_value(4, true)

func printPhysicsLayers(node: RigidBody2D):
	var collisionLayer = node.collision_layer
	var collisionMask = node.collision_mask
	
	for i in range(32):
		if collisionLayer & (1 << i) != 0:
			print("layer:", i)
		if collisionMask & (1 << i) != 0:
			print("mask:", i)
