extends CanvasLayer

var dialogos1 : Array[String]
var dialogos2: Array[String]
var dialogos3: Array[String]
@onready var cajaTexto = $Control/cajaTexto
@onready var fairy = $Control/fairy
@onready var dialogoActual = $Control/dialogoActual

# Called when the node enters the scene tree for the first time.
func _ready():
	cajaTexto.play_backwards("default")
	await get_tree().create_timer(1).timeout
	fairy.play("default")
	dialogos1.append("¡Hola! Soy Eiry, tu nueva guía :D")
	dialogos1.append("Parece que estás en problemas, pero no te preocupes, yo te voy ayudar.")
	dialogos1.append("Primero, supongo que no recuerdas ni como moverte...\nSolo debes usar las flechitas ;)")
	dialogos1.append("Otra cosa importante, el reino no está en su mejor momento\ny hay enemigos en cada rincón del reino, incluso en el bosque.")
	dialogos1.append("...\nPor cierto ¿Cómo llegaste hasta este bosque?")
	dialogos1.append("En fin, con" + " X " + "puedes atacar para defenderte de los enemigos.")
	dialogos2.append("¡Buen Trabajo! pero hay algo que debes saber.")
	dialogos2.append("Quedarse por mucho tiempo en un solo lugar puede revelar nuestra ubicación D:")
	dialogos2.append("Procura derrotar a todos los enemigos de la zona lo más pronto posible.")
	dialogos3.append("A cierto, una última cosa. El Rey Catalán tiene dividido su poder de diferentes\n formas.")
	dialogos3.append("Para hacertelo más simple he usado la fórmula que puedes ver en la esquina\n superior derecha.")
	dialogos3.append("Es decir, que en cada escena tendrás que encargarte de una forma en la\n que El Rey Catalán ha TRIANGULADO su poder.")
	dialogos3.append("Cada vez que pases por un escenario te mostraré en que forma de\n triangulación vas :)")
	
	
	match (get_parent().name):
		"Tutorial_1":
			ponerDialogo(dialogos1)
		"Tutorial_2":
			ponerDialogo(dialogos2)
		"Tutorial_3":
			ponerDialogo(dialogos3)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	await get_tree().create_timer(3).timeout
	if Input.is_action_just_pressed("z") && visible == true:
		dialogoActual.text = ""
		match (get_parent().name):
			"Tutorial_1":
				ponerDialogo(dialogos1)
			"Tutorial_2":
				ponerDialogo(dialogos2)
			"Tutorial_3":
				ponerDialogo(dialogos3)

func ponerDialogo(array):
	var isSkipping := false
	if array.size() == 0:
		if fairy != null:
			fairy.free()
		cajaTexto.play("default")
		visible = false
	else:
		var s = array[0]
		array.remove_at(0)
		for char in s:
			if char != null && visible:
				if isSkipping:
					dialogoActual.text = s
					break
				else:
					dialogoActual.text += char
					await get_tree().create_timer(0.03).timeout
					isSkipping = Input.is_action_just_pressed("z")

