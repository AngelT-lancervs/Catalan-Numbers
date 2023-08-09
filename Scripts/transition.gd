extends CanvasLayer

@onready var transition = $AnimationPlayer

func changeEscena(nombreEscena:String):
	layer = 1
	transition.play("fade")
	await get_tree().create_timer(0.7).timeout
	get_tree().change_scene_to_file(nombreEscena)
	transition.play_backwards("fade")
	await get_tree().create_timer(3).timeout
	layer = -1

func fade():
	transition.play("fade")
	await get_tree().create_timer(0.7).timeout

func fade_out():
	transition.play_backwards("fade")
	await get_tree().create_timer(0.7).timeout
