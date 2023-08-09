extends Node

@export var siguiente_escena : String
@export var enemy : PackedScene
@export var enemyNumber = 0
@onready var timer = $Timer
@onready var player = $player
var tmp = 0
@onready var timerLabel : Label = $GUI/TimerLabel
@onready var numActualCatalan = $GUI/Control/numCatalanActual

# Called when the node enters the scene tree for the first time.
func _ready():
	TRANSITION.fade_out()
	_on_mob_timer_timeout()
	new_game()
	randomize()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	progressBar()
	gameOver()
	comprobarWin()
	var timeleft : float = timer.time_left 
	timerLabel.text = str(timeleft).pad_decimals(0)

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
		var mob = enemy.instantiate()
		mob.position.x = randi_range(64, 1300)
		mob.position.y = randi_range(64,580)
		mob.scale.x = 3.5
		mob.scale.y = 3.5
		tmp += 1
		add_child(mob)
	
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
			if player.currentState != 4:
				$portal.visible = true
				$portal/CollisionShape2D.disabled = false
				$portal/AnimatedSprite2D.visible = true
				$portal/AnimatedSprite2D.play("idle")
				timer.paused = true
				


func _on_portal_body_entered(body):
	if body != null && !body.is_in_group("enemigos"):
		TRANSITION.changeEscena(siguiente_escena)
		print("win")
		
