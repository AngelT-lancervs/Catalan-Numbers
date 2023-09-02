extends CanvasLayer

@onready var transition = $AnimationPlayer
@onready var formaActual = $formaActual
@onready var contenedor = $formaActual/contenedor
@onready var fairy = $formaActual/fairy
@onready var timerLabel = $formaActual/timerLabel
@onready var timer = $formaActual/Timer

func _ready():
	pass

func changeEscena(nombreEscena:String):
	transition.play("fade")
	await transition.animation_finished
	get_tree().change_scene_to_file(nombreEscena)
	transition.play_backwards("fade")
	await transition.animation_finished

	
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
		$sonidoFairy.play()
		fairy.visible = true
		fairy.play("default")
		match i:
			1:
				$formaActual/"1".visible = true
				$formaActual/"1".play("default")
				await $formaActual/"1".animation_finished
				await get_tree().create_timer(2).timeout
				$formaActual/"1".play_backwards("default")
				await $formaActual/"1".animation_finished
				await get_tree().create_timer(1).timeout
				$formaActual/"1".visible = false
				
			2:
				$formaActual/"2".visible = true
				$formaActual/"2".play("default")
				await $formaActual/"2".animation_finished
				await get_tree().create_timer(2).timeout
				$formaActual/"2".play_backwards("default")
				await $formaActual/"2".animation_finished
				await get_tree().create_timer(1).timeout
				$formaActual/"2".visible = false
			
			3:
				$formaActual/"3".visible = true
				$formaActual/"3".play("default")
				await $formaActual/"3".animation_finished
				await get_tree().create_timer(2).timeout
				$formaActual/"3".play_backwards("default")
				await $formaActual/"3".animation_finished
				await get_tree().create_timer(1).timeout
				$formaActual/"3".visible = false
				
			4:
				$formaActual/"4".visible = true
				$formaActual/"4".play("default")
				await $formaActual/"4".animation_finished
				await get_tree().create_timer(2).timeout
				$formaActual/"4".play_backwards("default")
				await $formaActual/"4".animation_finished
				await get_tree().create_timer(1).timeout
				$formaActual/"4".visible = false
				
			5:
				$formaActual/"5".visible = true
				$formaActual/"5".play("default")
				await $formaActual/"5".animation_finished
				await get_tree().create_timer(2).timeout
				$formaActual/"5".play_backwards("default")
				await $formaActual/"5".animation_finished
				await get_tree().create_timer(1).timeout
				$formaActual/"5".visible = false
				
			6:
				$formaActual/"6".visible = true
				$formaActual/"6".play("default")
				await $formaActual/"6".animation_finished
				await get_tree().create_timer(2).timeout
				$formaActual/"6".play_backwards("default")
				await $formaActual/"6".animation_finished
				await get_tree().create_timer(1).timeout
				$formaActual/"6".visible = false
				
			7:
				$formaActual/"7".visible = true
				$formaActual/"7".play("default")
				await $formaActual/"7".animation_finished
				await get_tree().create_timer(2).timeout
				$formaActual/"7".play_backwards("default")
				await $formaActual/"7".animation_finished
				await get_tree().create_timer(1).timeout
				$formaActual/"7".visible = false
				
		fairy.visible = false
		contenedor.play("default")
		await contenedor.animation_finished
		contenedor.visible = false
		
	
func catalan(n):
	# Base Case
	if n <= 1:
		return 1
	# Catalan(n) is the sum of catalan(i)*catalan(n-i-1)
	var res = 0
	for i in range(n):
		res += catalan(i) * catalan(n-i-1)
	return res

