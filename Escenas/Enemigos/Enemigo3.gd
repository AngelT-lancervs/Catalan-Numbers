extends CharacterBody2D
class_name Enemigo3

@onready var sprites = $AnimatedSprite2D
@onready var hitboxGlobal = $hitboxGlobal
@onready var collision = $deteccion/CollisionShape2D
@onready var area2d = $hitbox/CollisionShape2D
@onready var timerMove = $CambiarDireccion
@onready var sonidoDie = $Sounds/die
var velocidad := 100
var jugador = null
@export var damage : int
var vector = Vector2.ZERO


func _ready():
	$Sounds/aparecer.play()
	sprites.play("run")
	randomize()

func _physics_process(delta):
	if jugador != null:
		velocidad = 200
		vector = position.direction_to(jugador.position)
	else:
		velocidad = 100
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
		

