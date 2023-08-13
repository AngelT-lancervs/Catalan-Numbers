extends CharacterBody2D
class_name Player

enum CharacterState {
	IDLE,
	RUNNING,
	ATTACKING,
	HURT,
	DYING
}

var currentState
var velocidad := 300
var direccionX := 0.0
var direccionY := 0.0
@onready var sprite = $Sprite2D
@onready var isRunning : bool = $AnimationTree.get("parameters/conditions/isRunning")
@onready var isIdle : bool = $AnimationTree.get("parameters/conditions/isIdle")
@onready var isAttacking : bool = $AnimationTree.get("parameters/conditions/isAttacking")
@onready var isHurt : bool = $AnimationTree.get("parameters/conditions/isHurt")
var kills = 0
@onready var animation : AnimationNodeStateMachinePlayback = $AnimationTree.get("parameters/playback")
@onready var swordCollider = $swordHitBox/swordCollider
@onready var bodyCollider = $hitbox/CollisionPolygon2D
@export var health = 100

func _ready():
	currentState = CharacterState.IDLE
	isIdle = true
	idle()
	

func _physics_process(delta):
	var vector = Vector2.ZERO
	direccionX = 0
	direccionY = 0
		
	if Input.is_action_pressed("ui_left"):
		direccionX = -1
	elif Input.is_action_pressed("ui_right"):
		direccionX = 1
	if Input.is_action_pressed("ui_down"):
		direccionY = 1
	elif Input.is_action_pressed("ui_up"):
		direccionY = -1
		

	vector.x = direccionX
	vector.y = direccionY
	velocity = vector.normalized() * velocidad
	
	animaciones()
	move_and_slide()

func animaciones():
	if direccionX != 0 or direccionY != 0:
		if direccionX < 0.0:
			sprite.set_flip_h(true)
			if(swordCollider.position.x > 0):
				swordCollider.position.x = -5
		else:
			sprite.set_flip_h(false)
			if(swordCollider.position.x < 0):
				swordCollider.position.x = 2
		correr()
		currentState = CharacterState.RUNNING
	else:
		if currentState != CharacterState.DYING:
			currentState = CharacterState.IDLE
			idle()
		
	if Input.is_action_just_pressed("atacar"):
		if currentState == CharacterState.RUNNING:
			correr()
		currentState = CharacterState.ATTACKING
		attack()
	
	if health <= 0:
		currentState = CharacterState.DYING
		die()
	
	
func _on_hitbox_body_entered(body):
	if body != self and !(body is Catalan):
		var enem = body
		if enem.hitboxGlobal.disabled == false:
			damage_player(body.damage)
			$Sounds/hurt.play()
			body.queue_free()
			hurt()
			if health != 0:
				kills +=1
	if body is Catalan:
		await get_tree().create_timer(0.3).timeout
		set_collision_layer_value(1, false)
		set_collision_mask_value(1, false)
		set_collision_layer_value(2, false)
		set_collision_mask_value(2, false)
		$Sounds/hurt.play()
		hurt()
		health -= 5
		await get_tree().create_timer(1).timeout
		set_collision_layer_value(1, true)
		set_collision_mask_value(1, true)
		set_collision_layer_value(2, true)
		set_collision_mask_value(2, true)

		
func correr():
	animation.travel("run")

func idle():
	animation.travel("idle")

func attack():
	if health > 0:
		$Sounds/swordSound.play()
		animation.travel("attack")
		swordCollider.disabled = false
		await get_tree().create_timer(0.5).timeout
		swordCollider.disabled = true

func hurt():
	animation.start("hurt")

func die():
	animation.travel("die")
	$bodyCollider.disabled = true
	velocidad = 0
	$hitbox/CollisionShape2D.disabled = true

func damage_player(damage):
	for i in range(damage):
		await get_tree().create_timer(0.005).timeout
		health -= 1
	

func _on_sword_hit_box_body_entered(body):
	if health > 0:
		if body != self:
			if !(body is Catalan):
				var enem = body
				if enem.hitboxGlobal.disabled == false:
					enem.sprites.play("die")
					enem.velocidad = 0
					enem.hitboxGlobal.disabled = true
					enem.hitboxGlobal.free()
					enem.collision.disabled = true
					enem.area2d.disabled = true
					enem.sonidoDie.play()
					await get_tree().create_timer(1.5).timeout
					if body != null:
						kills += 1
						body.free()
			else:
				body.health -= 25
				if !body.isAttacking1 and !body.isAttacking2 and !body.isAttacking3 and body.health >= 0:
					body.animation.start("hurt")
					body.hurtS.play()
				if body.health <= 0 && !body.isDying:
					body.velocidad = 0
					body.isDying = true
					body.animation.travel("die")
					body.muerte.play()
					await get_tree().create_timer(5).timeout
					body.free()
