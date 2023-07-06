extends GPUParticles2D

var effect_lifetime := 0.2

func _ready():
	one_shot = true
	emitting = true
	start_lifetime_timer()
	
func start_lifetime_timer():
	await get_tree().create_timer(effect_lifetime).timeout
	queue_free()
	
