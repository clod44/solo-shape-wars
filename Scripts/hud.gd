extends Control


var fps = Engine.get_frames_per_second()
@onready var hud_fps = $CanvasLayer/VBoxContainer/FPS

func _process(_delta):
	fps = Engine.get_frames_per_second()
	hud_fps.text = str(fps) + "FPS"
