extends Node2D


var carry_momentum := Vector2(0,0)
@onready var player : RigidBody2D = get_parent()
@export var isEnemy = false

func _ready():
	for node in get_children():
		node.isEnemy = isEnemy
		
func shootAll():
	carry_momentum = player.linear_velocity
	for weapon in get_children():
		weapon.carry_momentum = carry_momentum
		weapon.shoot()
