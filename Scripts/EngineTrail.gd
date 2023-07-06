extends Line2D

var point
@export var trail_length = 16
@onready var engine_trail_position := get_parent().get_parent().get_node("EngineTrailPosition")

func _physics_process(_delta):
	point = engine_trail_position.global_position
	add_point(point)

	if points.size() > trail_length:
		remove_point(0)
