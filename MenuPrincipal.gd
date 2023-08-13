extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	$sol.play("default")
	$noche.play("default")
	$atardecer.play("default")
	$lluvia.play("default")


func _on_empezar_pressed():
	TRANSITION.changeEscena("res://Escenas/T1/Tutorial_1.tscn")
