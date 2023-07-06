extends Label

@export var font_size := 64
@export var shrinkSpeed := 0.01

func _ready():
	add_theme_font_size_override("font_size", font_size)

func _process(delta):
	# Shrink the Label's font size
	var currentFontSize = get_theme_font_size("font_size")
	var newFontSize = lerp(currentFontSize, 0, shrinkSpeed)
	add_theme_font_size_override("font_size", newFontSize)
	# Check if the Label's lifetime has expired
	if newFontSize < 1:
		queue_free()
