extends Node

@export var siguiente_escena : String
var packedScenePath = "res://Escenas/T1/enemigo.tscn"
var enemy = ResourceLoader.load(packedScenePath) as PackedScene
@export var enemyNumber = 0
@onready var timer = $Timer
@onready var player = $player
var tmp = 0
@onready var timerLabel : Label = $GUI/TimerLabel
@onready var numActualCatalan = $GUI/Control/numCatalanActual
var enemigoBait : Enemigo
var countTmp = 0
var animacionInicial = true


# Called when the node enters the scene tree for the first time.
func _ready():
	new_game()
	add_child(enemy.instantiate())
	timer.paused = true
	enemigoBait = get_child(-1)
	enemigoBait.position.x = -999
	enemigoBait.position.y = -999
	enemigoBait.visible = false
	TRANSITION.mostrarFigura(-1)
	randomize()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	progressBar()
	if  $tutorial_gui.visible == false:
		if countTmp == 0:
			timer.paused = false
			countTmp+=1
		if player != null:
			if player.health > 0:
				player.velocidad = 300
		await get_tree().create_timer(0.3).timeout
		TRANSITION.contenedor.stop()
		gameOver()
		comprobarWin()
		$StartTimer.paused = false
		$MobTimer.paused = false
		if timerLabel.text != "DONE!":
			var timeleft : float = timer.time_left 
			timerLabel.text = str(timeleft).pad_decimals(0)
	else:
		player.velocidad = 0
		$MobTimer.paused = true
		$StartTimer.paused = true
		

func new_game():
	$StartTimer.start()
	timer.start()

func _on_timer_timeout():
	timer.stop()

func _on_start_timer_timeout():
	$MobTimer.start()
	$StartTimer.start()


func _on_mob_timer_timeout():
	if tmp <= enemyNumber: 
		await get_tree().create_timer(3).timeout
		var mob = enemy.instantiate()
		mob.position.x = randi_range(64, 1300)
		mob.position.y = randi_range(64,580)
		mob.scale.x = 3.5
		mob.scale.y = 3.5
		tmp += 1
		add_child(mob)
		if enemigoBait != null:
			get_child(-2).free()
		
	
func clear_enemies():
	for child in get_children():
		if child is Enemigo:
			child.queue_free()

func gameOver():
	if player != null:
		if player.health == 0:
			await get_tree().create_timer(2).timeout
			if player != null:
				player.queue_free()
				$GUI.visible = false
				$GameOver.visible = true
				tmp = 999
				clear_enemies()
				return true
				
		if timer.time_left == 0:
			if player != null:
				player.free()
				$GUI.visible = false
				$GameOver.visible = true
				$MobTimer.stop()
				clear_enemies()
				return true
		
func progressBar():
	if player != null:
		$GUI/TextureProgressBar.value = $player.health
		if player.health == 0:
			$GUI/TextureProgressBar/HeartsRed1.visible = false


func _on_audio_stream_player_finished():
	$Sound/AudioStreamPlayer.play()

func catalan(n):
	# Base Case
	if n <= 1:
		return 1
	# Catalan(n) is the sum of catalan(i)*catalan(n-i-1)
	var res = 0
	for i in range(n):
		res += catalan(i) * catalan(n-i-1)
	return res

func comprobarWin():
	var enemigos : Array[Enemigo]
	for child in get_children():
		if child is Enemigo:
			enemigos.append(child)
	print(enemigos.size())
	if enemigos.size() == 0:
		if player != null:
			if player.currentState != 4 && tmp > 4:
				$portal.visible = true
				$portal/CollisionShape2D.disabled = false
				$portal/AnimatedSprite2D.visible = true
				$portal/AnimatedSprite2D.play("idle")
				timer.paused = true
				timerLabel.text = "DONE!"
				

func _on_portal_body_entered(body):
	if body != null && !(body is Enemigo):
		TRANSITION.changeEscena(siguiente_escena)
		print("win")
		
