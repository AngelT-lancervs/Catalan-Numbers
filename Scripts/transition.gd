extends CanvasLayer

@onready var transition = $AnimationPlayer
@onready var formaActual = $formaActual
@onready var contenedor = $formaActual/contenedor
@onready var figura1 = $formaActual/figura1

func changeEscena(nombreEscena:String):
	layer = 1
	transition.play("fade")
	await transition.animation_finished
	get_tree().change_scene_to_file(nombreEscena)
	transition.play_backwards("fade")
	await transition.animation_finished
	layer = -1
	
func fade():
	transition.play("fade")
	await get_tree().create_timer(0.7).timeout

func fade_out():
	transition.play_backwards("fade")
	await get_tree().create_timer(0.7).timeout
	
func mostrarFigura(i : int):
	if i != -1:
		contenedor.visible = true
		contenedor.play_backwards("default")
		await contenedor.animation_finished
		
		match i:
			1:
				figura1.visible = true
				figura1.play("default")
				await figura1.animation_finished
				figura1.visible = false

		contenedor.play("default")
		await contenedor.animation_finished
		contenedor.visible = false

