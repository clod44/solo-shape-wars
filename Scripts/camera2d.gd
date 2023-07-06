extends Camera2D

@export var target_zoom := 1
var shake_amount := 1.0 #this represent the t of shaking 1 to 0 expoential decay. dont touch this
var shake_strength := 5.0
var default_offset = offset
@onready var tween = create_tween()
@onready var timer = $Timer
var shaking = false

func _ready():
	#see https://www.youtube.com/watch?v=4mll7LKIITM for camera shaking stuff and global accessing
	Global.camera = self
	randomize() #randomize RNG seed
	
func _process(_delta):
	if Input.is_action_just_released("zoom_in"):
		target_zoom += 1
	elif Input.is_action_just_released("zoom_out"):
		target_zoom -= 1	
	target_zoom = clamp(target_zoom, 1, 10)
	var current_zoom = lerpf(zoom.x, target_zoom, 0.1)
	zoom = Vector2(current_zoom, current_zoom)
		
	if shaking:
		offset = Vector2(randf_range(-1, 1) * shake_strength * shake_amount, randf_range(-1, 1) * shake_strength * shake_amount)
		shake_amount *= max(shake_amount - 0.01, 0)
		
func shake(time, _shake_strength):
	timer.wait_time = time
	shake_amount = 1 #reset exponential decay
	shake_strength = _shake_strength
	shaking = true
	timer.start()


func _on_timer_timeout():
	shaking = false
	tween.tween_property(self, "offset", default_offset, 2.0)
