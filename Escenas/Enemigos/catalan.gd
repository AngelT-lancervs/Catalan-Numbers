extends CharacterBody2D
class_name Catalan

@onready var hitboxGlobal = $hitboxGlobal
@onready var collision = $deteccion/CollisionShape2D
@onready var area2d = $hitbox/CollisionShape2D
@onready var corriendo : bool = $AnimationTree.get("parameters/conditions/corriendo")
@onready var isAttacking1 : bool = $AnimationTree.get("parameters/conditions/isAttacking1")
#@onready var isHurt : bool = $AnimationTree.get("parameters/conditions/isHurt")
@onready var isAttacking2 : bool = $AnimationTree.get("parameters/conditions/isAttacking2")
@onready var isAttacking3 : bool = $AnimationTree.get("parameters/conditions/isAttacking3")
@onready var meditando : bool = $AnimationTree.get("parameters/conditions/meditando")
@onready var isIdle : bool = $AnimationTree.get("parameters/conditions/isIdle")
@onready var isDying : bool
@onready var timer = $Timer
var health: int = 1000

@onready var muerte = $Sounds/muerte
@onready var hurtS = $Sounds/hurt
var velocidad := 200
var jugador = null
@onready var animation : AnimationNodeStateMachinePlayback = $AnimationTree.get("parameters/playback")
@export var damage : int
var vector = Vector2.ZERO


func _ready():
	animation.travel("idle")
	randomize()

func _physics_process(delta):
	randomize()
	if jugador != null and jugador is Player:
		vector = position.direction_to(jugador.position)

	if !isAttacking1 and !isAttacking2 and !isAttacking3:
		if vector.x < 0:
			$Sprite2D.set_flip_h(true)
			$hitboxPoder1/CollisionShape2D.position.x = -82
			$hitboxPoder2/CollisionShape2D.position.x = -80
		else:
			$Sprite2D.set_flip_h(false)
			$hitboxPoder1/CollisionShape2D.position.x = 82
			$hitboxPoder2/CollisionShape2D.position.x = 80
			
	
	velocity = vector.normalized() * velocidad
	
	manejoAnimaciones()
	move_and_slide()
	


func _on_deteccion_body_entered(body):
	if body != self && body is Player:
		jugador = body

func _on_deteccion_body_exited(body):
	jugador = null

		
func realizarAtaque():
	randomize()
	
	var i = randi_range(0,5)
	if !isDying:
		match i:
			0:
				attack1()
			1:
				attack2()
			2:
				attack3()
			3:
				invocar()
			4: #idle
				idle()
				$Sounds/risa.play()
			5:
				velocidad = 200

func attack1():
	if !isDying:
		isAttacking1 = true
		velocidad = 0
		await get_tree().create_timer(0.5).timeout
		isAttacking1 = false
		isIdle = true


func attack2():
	if !isDying:
		isAttacking2 = true
		velocidad = 0
		await get_tree().create_timer(3).timeout
		isAttacking2 = false
		isIdle = true
		
func attack3():
	if !isDying:
		isAttacking3 = true
		velocidad = 0
		await get_tree().create_timer(4).timeout
		isAttacking3 = false
		isIdle = true


func invocar():
	if !isDying:
		meditando = true
		velocidad = 0
		await get_tree().create_timer(3).timeout
		meditando = false

func idle():
	if !isDying:
		isIdle = true
		velocidad = 0
		await get_tree().create_timer(3).timeout
		isIdle = false

func hurt():
	if !isDying:
		#isHurt = true
		velocidad = 0
		corriendo = false
		isIdle = false
		await get_tree().create_timer(2).timeout
		#isHurt = false
		isIdle = true

func _on_timer_timeout():
	realizarAtaque()

func manejoAnimaciones():
	if isAttacking1:
		animation.travel("attack1")
		$Sounds/ataque1.play()
		await get_tree().create_timer(0.3).timeout
		$hitboxPatada/CollisionShape2D.disabled = false
		await get_tree().create_timer(0.5).timeout
		$hitboxPatada/CollisionShape2D.disabled = true
	if isAttacking2 and !isDying:
		animation.travel("attack2")
		$Sounds/ataque2.play()
		await get_tree().create_timer(0.3).timeout
		$hitboxPoder1/CollisionShape2D.disabled = false
		await get_tree().create_timer(3).timeout
		$hitboxPoder1/CollisionShape2D.disabled = true
	elif isAttacking3 and !isDying:
		animation.travel("attack3")
		$Sounds/ataque3.play()
		await get_tree().create_timer(0.3).timeout
		$hitboxPoder2/CollisionShape2D.disabled = false
		await get_tree().create_timer(3).timeout
		$hitboxPoder2/CollisionShape2D.disabled = true
	elif meditando and !isDying:
		animation.travel("meditar")
	elif velocidad > 0 and !isDying:
		isIdle = false
		animation.travel("run")
	elif isIdle and !isDying:
		animation.travel("idle")
#	elif isHurt and !isDying:
#		animation.travel("hurt")


	
func _on_hitbox_patada_body_entered(body):
	if body is Player:
		body.health -= 20
		body.hurt()


func _on_hitbox_poder_2_body_entered(body):
	if body is Player:
		body.health -= 30
		body.hurt()


func _on_hitbox_poder_1_body_entered(body):
	if body is Player:
		body.health -= 25
		body.hurt()
