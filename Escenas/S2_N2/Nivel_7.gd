extends Node

@export var siguiente_escena : String
var packedScenePath1 = "res://Escenas/Enemigos/Enemigo2.tscn"
var packedScenePath2 = "res://Escenas/T1/enemigo.tscn"
var enemy1 = ResourceLoader.load(packedScenePath1) as PackedScene
var enemy2 = ResourceLoader.load(packedScenePath2) as PackedScene
@export var enemyNumber = 0
@onready var timer = $Timer
@onready var player = $player
var tmp = 0
@onready var timerLabel : Label = $GUI/TimerLabel
@onready var numActualCatalan = $GUI/Control/numCatalanActual
var enemigoBait : Enemigo2
var countTmp = 0
@onready var animacionInicial = $animacionInicial

func _ready():
	numActualCatalan.text = "= 5"
	new_game()
	add_child(enemy1.instantiate())
	enemigoBait = get_child(-1)
	enemigoBait.position.x = -999
	enemigoBait.position.y = -999
	enemigoBait.visible = false
	$MobTimer.paused = true
	timer.paused = true
	await TRANSITION.mostrarFigura(4)
	$MobTimer.paused = false
	timer.paused = false
	randomize()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	progressBar()
	if $Sound/win.playing:
		await get_tree().create_timer(1).timeout
	if player != null:
		if player.health > 0:
			player.velocidad = 300

	gameOver()
	comprobarWin()

	if timerLabel.text != "DONE!":
		var timeleft : float = timer.time_left 
		timerLabel.text = str(timeleft).pad_decimals(0)

func new_game():
	$StartTimer.start()
	timer.start()

func _on_timer_timeout():
	timer.stop()

func _on_start_timer_timeout():
	if $MobTimer != null && $GameOver.visible == false :
		$MobTimer.start()
	$StartTimer.start()


func _on_mob_timer_timeout():
	if tmp <= enemyNumber: 
		var mob
		await get_tree().create_timer(3).timeout
		var rd = randi_range(1,2)
		match rd:
			1:
				mob = enemy1.instantiate()
			2:
				mob = enemy2.instantiate()
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
		if child is Enemigo2:
			child.queue_free()
		if child is Enemigo2:
			child.queue_free()

func gameOver():
	if player != null:
		if player.health <= 0:
			await get_tree().create_timer(2).timeout
			if player != null:
				$MobTimer.paused = true
				player.queue_free()
				$GUI.visible = false
				$GameOver.visible = true
				tmp = 999
				clear_enemies()
				$Sound/ost.stop()
				$GameOver.sonidoGameOver.play()
				return true
				
		if timer.time_left == 0:
			if player != null:
				player.free()
				$GUI.visible = false
				$GameOver.visible = true
				$MobTimer.paused = true
				clear_enemies()
				$Sound/ost.stop()
				$GameOver.sonidoGameOver.play()
				return true
		
func progressBar():
	if player != null:
		$GUI/TextureProgressBar.value = $player.health
		if player.health < 100 && player.health > 0:
			player.health += 0.05
		if player.health <= 0:
			$GUI/TextureProgressBar/HeartsRed1.visible = false

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
	var enemigos : Array[Enemigo2]
	var enemigos2: Array[Enemigo]
	for child in get_children():
		if child is Enemigo2:
			enemigos.append(child)
		if child is Enemigo:
			enemigos2.append(child)
	print(enemigos.size())
	if enemigos.size() == 0 and tmp > enemyNumber and enemigos2.size() == 0:
		if player != null:
			if player.currentState != 4:
				$portal.visible = true
				$portal/CollisionShape2D.disabled = false
				$portal/AnimatedSprite2D.visible = true
				$portal/AnimatedSprite2D.play("idle")
				timer.paused = true
				timerLabel.text = "DONE!"
				$Sound/ost.stop()
				$Sound/win.play()
				

func _on_portal_body_entered(body):
	if body != null and !(body is Enemigo) and !(body is Enemigo2):
		TRANSITION.changeEscena(siguiente_escena)
		print("win")

func _on_ost_finished():
	$Sound/ost.play()
