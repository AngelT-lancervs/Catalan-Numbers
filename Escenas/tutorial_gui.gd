extends CanvasLayer

var dialogos1 : Array[String]
var dialogos2: Array[String]
var dialogos3: Array[String]
var dialogos4: Array[String]
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
	
	dialogos3.append("Por cierto, una última cosa.\nUn monje, ha poseído el cuerpo del Rey Catalan")
	dialogos3.append("Y usó su propia fórmula para dividir su esencia en fragmentos >:(")
	dialogos3.append("Mira la fórmula de arriba.")
	dialogos3.append("Cuando tengas tiempo, revisala detalladamente.")
	dialogos3.append("En cada escena tendrás que encargarte de una forma en la\n que El Rey Catalan ha sido TRIANGULADO.")
	dialogos3.append("Y lo ha hecho esparciendo fragmentos en forma de\n polígonos que llevan dentro una imagen con algún lugar del reino.")
	dialogos3.append("Cada vez que pases por un escenario te mostraré \nel fragmento el cuál estamos recuperando.")
	dialogos3.append("Eso es todo :)")
	dialogos3.append("Si quieres una explicación más detallada de la fórmula te la daré.")
	dialogos3.append("Si no, presiona Z rápidamente.")
	dialogos3.append("n es lo que falta para completar el lado del polígono actual.")
	dialogos3.append("Por ejemplo, un Triángulo tiene 3 lados, n + 2 = 3\n¿Cuanto debería ser n para llegar a 3?")
	dialogos3.append("¡Exacto! n tiene que ser 1 y el número de Catalan en n = 1 es 1 ;)")
	dialogos3.append("De esa misma forma será para todas las demás formas que tiene su poder.")
	dialogos3.append("Buena suerte, héroe.")
	
	dialogos4.append("Hola héroe, soy Eiry.")
	dialogos4.append("Parece que deseas encontrar un camino al cielo :o")
	dialogos4.append("Para lograr tu cometido solo te podrás mover hacia la derecha o hacia arriba.")
	dialogos4.append("No podrás ir hacia atrás ni para abajo.\nPara llegar al cielo solo puedes ir hacia adelante ;)")
	dialogos4.append("En tu camino te encontrarás con enemigos y personas que te ayudarán\n en tu travesía.")
	dialogos4.append("Es probable que te canses así que trata de hacerlo en la menor cantidad\n de movimientos.")
	dialogos4.append("Buena suerte héroe ;)")
	
	
	match (get_parent().name):
		"Tutorial_1":
			ponerDialogo(dialogos1)
		"Tutorial_2":
			ponerDialogo(dialogos2)
		"Tutorial_3":
			ponerDialogo(dialogos3)
		"nivel1":
			ponerDialogo(dialogos4)


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
			"nivel1":
				ponerDialogo(dialogos4)

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
					break
				else:
					dialogoActual.text += char
					await get_tree().create_timer(0.03).timeout
					isSkipping = Input.is_action_just_pressed("z")

