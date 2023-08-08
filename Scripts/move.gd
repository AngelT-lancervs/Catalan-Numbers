#autor lancervs
extends Area2D

var speed = 5
@onready var body = $player
@onready var animation = $player/AnimatedSprite2D
var movingRight = false
var movingLeft = false
var movingUp = false
var movingDown = false
var attacking = false
var cantidadRecorrida = 0
var attackTimer = 0
var attackDuration = 0.7

# Called when the node enters the scene tree for the first time.
func _ready():
	animation.play("idle")

# Called every frame. 'delta' es el tiempo transcurrido desde el fotograma anterior.
func _process(delta):
	move(delta)
	
	if attacking:
		attackTimer += delta
		if attackTimer >= attackDuration:
			attacking = false
			animation.play("idle")  # Volver al estado idle después del ataque
			attackTimer = 0

	if Input.is_action_just_pressed("atacar") and !attacking:
		attackAnimation()
	

func move(delta):
	if !movingRight and !movingLeft:
		if Input.is_action_just_pressed("ui_right"):
			movingRight = true
			animation.set_flip_h(false)
			animation.stop()
			animation.play("run")

		elif Input.is_action_just_pressed("ui_left"):
			movingLeft = true
			animation.set_flip_h(true)
			animation.stop()
			animation.play("run")
		
		elif Input.is_action_just_pressed("ui_up"):
			movingUp = true
			animation.set_flip_h(false)
			animation.stop()
			animation.play("run")
			
		elif Input.is_action_just_pressed("ui_down"):
			movingDown = true
			animation.set_flip_h(false)
			animation.stop()
			animation.play("run")	

	if movingRight:
		runRight()
	if movingLeft:
		runLeft()
	if movingUp:
		runUp()
	if movingDown:
		runDown()

func runRight():
	if cantidadRecorrida < 120:
		position.x += speed
		cantidadRecorrida += speed
	else:
		movingRight = false
		animation.stop()
		animation.play("idle")
func runLeft():
	if cantidadRecorrida < 120:
		position.x -= speed
		cantidadRecorrida += speed
	else:
		movingLeft = false
		animation.stop()
		animation.play("idle")
		cantidadRecorrida = 0
		
func runUp():
	if cantidadRecorrida < 120:
		position.y -= speed
		cantidadRecorrida += speed
	else:
		movingUp = false
		animation.stop()
		animation.play("idle")
		cantidadRecorrida = 0
		
func runDown():
	if cantidadRecorrida < 120:
		position.y += speed
		cantidadRecorrida += speed
	else:
		movingDown = false
		animation.stop()
		animation.play("idle")
		cantidadRecorrida = 0

func attackAnimation():
	attacking = true
	animation.stop()
	animation.play("attack")


func _on_attack_animation_finished():
	attacking = false
	animation.play("idle")  # Volver al estado idle después del ataque
	$Timer.queue_free()  # Liberar el Timer después de usarlo


