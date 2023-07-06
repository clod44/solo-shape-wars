extends Line2D

var point
@export var trail_length = 4
@onready var bullet := get_parent().get_parent()

func _physics_process(_delta):
	point = bullet.global_position
	add_point(point)

	if points.size() > trail_length:
		remove_point(0)
