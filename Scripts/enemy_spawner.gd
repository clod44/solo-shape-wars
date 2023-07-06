extends Node

@export var enemy_scene = preload("res://Scenes/enemy_1.tscn")
@export var spawn_distance := 500
@export var spawn_distance_variety := 50
@export var spawn_frequency := 0.5
@export var spawn_center := Vector2.ZERO
@onready var follow_node := $"../Player"
var spawn_timer := Timer.new()


func _ready():
	spawn_timer.wait_time = spawn_frequency
	spawn_timer.connect("timeout", spawn)
	add_child(spawn_timer)
	spawn_timer.start()

func spawn():
	spawn_center = follow_node.global_position
	var enemy = enemy_scene.instantiate()
	var spawn_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	var spawn_position = spawn_center + spawn_direction * (spawn_distance + randf_range(0,spawn_distance_variety))
	enemy.global_position = spawn_position
	add_child(enemy)

