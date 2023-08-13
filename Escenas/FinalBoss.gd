extends Node

@onready var player = $player
var gm = false
@export var siguiente_escena : String
# Called when the node enters the scene tree for the first time.
func _ready():
	$GUI/barraBoss.visible = true
	$GUI/Control.visible = false
	$GUI/Node2D.visible = true
	$entradaA/AnimationPlayer.play("entrada")
	await $entradaA/AnimationPlayer.animation_finished
	$CATALAN.velocidad = 0
	$CATALAN.timer.paused = true
	for i in "EUGÈNE CHARLES CATALAN (POSEÍDO)":
		$entradaA/Label.text += i
		await get_tree().create_timer(0.1).timeout
	await get_tree().create_timer(1).timeout
	$entradaA.visible = false
	
	$CATALAN.timer.paused = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	progressBar()
	progressBar2()
	if !gm:
		gameOver()
	win()
	
	
func progressBar():
	if player != null:
		$GUI/TextureProgressBar.value = player.health
		if player.health < 100 && player.health > 0:
			player.health += 0.01
		if player.health <= 0:
			$GUI/TextureProgressBar/HeartsRed1.visible = false

func progressBar2():
	if $CATALAN != null:
		$GUI/barraBoss.value = $CATALAN.health
		$CATALAN.health += 0.1

func gameOver():
	if $player.health <= 0:
		$player.velocidad = 0
		$GameOver.visible = true
		$GUI.visible = false
		$Sounds/ost.stop()
		gm = true
		if !$Sounds/gameOver.playing:
			$Sounds/gameOver.play()

func win():
	if $CATALAN == null:
		$Sounds/ost.stop()
		$portal.visible = true
		$portal/CollisionShape2D.disabled = false
		$portal/AnimatedSprite2D.play("default")
		$GUI.visible = false
		if !$Sounds/win.playing: 
			$Sounds/win.play()


func _on_ost_finished():
	$Sounds/ost.play()


func _on_win_finished():
	$Sounds/win.play()


func _on_portal_body_entered(body):
	if body != null && !(body is Enemigo):
		TRANSITION.changeEscena(siguiente_escena)
