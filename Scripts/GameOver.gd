extends CanvasLayer

@onready var sonidoGameOver = $Sounds/gameOver

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("click") && self.visible:
		self.visible = false
		get_parent().get_tree().reload_current_scene()
