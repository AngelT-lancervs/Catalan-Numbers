extends CharacterBody2D
class_name Enemigo

@onready var sprites = $AnimatedSprite2D
@onready var hitboxGlobal = $hitboxGlobal
@onready var collision = $deteccion/CollisionShape2D
@onready var area2d = $hitbox/CollisionShape2D
@onready var timerMove = $CambiarDireccion
var velocidad := 100
@onready var sonidoDie = $Sounds/die
var jugador = null
@export var damage : int = 20
var vector = Vector2.ZERO

func _ready():
	sprites.play("walk")
	$Sounds/aparecer.play()
	randomize()

func _physics_process(delta):
	if jugador != null:
		vector = position.direction_to(jugador.position)
			
	if vector.x < 0:
		sprites.set_flip_h(true)
	else:
		sprites.set_flip_h(false)
	
	velocity = vector.normalized() * velocidad
	
	if position.x >= 1300:
		vector.x = -1
	if position.x <= 10:
		vector.x = 1
	if position.y >= 600:
		vector.y = -1
	if position.y <= 30:
		vector.y = 1
	move_and_slide()


func _on_deteccion_body_entered(body):
	if body != self && body.get_collision_layer() == 3:
		jugador = body

func _on_deteccion_body_exited(body):
	jugador = null

func _on_cambiar_direccion_timeout():
	if jugador == null:
		randomize()
		var move : int = randi_range(0, 3)
		match move:	
			0:
				vector.x = 1
			1:
				vector.x = -1
			2:
				vector.y = 1
			3:
				vector.y = -1
		
