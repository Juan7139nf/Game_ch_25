extends Control

var juego_pausado = false
var conteo = 16
var tiempo_acumulado := 0.0

func _ready() -> void:
	tiempo_acumulado = 0.0
	conteo = 16
	set_process_input(true)
	process_mode = Node.PROCESS_MODE_ALWAYS
	$MenuPanel.process_mode = Node.PROCESS_MODE_ALWAYS
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	$MenuPanel.visible = false  # Asegúrate que el menú está oculto al iniciar

func _process(_delta: float) -> void:
	# if not DisplayServer.window_is_focused():
		#print("Ventana inactiva")
	# else:
		#print("Ventana activa")
	
	if Global.fase == 6 and conteo > 0:
		tiempo_acumulado += _delta
		if tiempo_acumulado >= 1.0:
			conteo -= 1
			$BoxContainer/Label.text = str(conteo)
			tiempo_acumulado = 0.0
	
	$BoxContainer/Fases/scoreF.text = str(Global.fase)
	$"BoxContainer/puntuación/score".text = str(Global.score)

	if Global.fase == 6 and conteo == 0:
		$Label.visible = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().paused = true
		await get_tree().create_timer(3).timeout
		get_tree().paused = false
		Cargarmenu()

	if Input.is_action_just_pressed("ui_cancel"):
		_toggle_pausa()

func _toggle_pausa():
	juego_pausado = !juego_pausado
	if juego_pausado:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		$AudioStreamPlayer.play()
		get_tree().paused = true
		$MenuPanel.visible = true
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		get_tree().paused = false
		$MenuPanel.visible = false
		$AudioStreamPlayer.stop()

func Cargarmenu():
	var nueva_escena = load("res://src/scenes/menu.tscn")
	get_tree().change_scene_to_packed(nueva_escena)


func _on_btn_renaudar_pressed() -> void:
	juego_pausado = false
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	get_tree().paused = false
	$MenuPanel.visible = false
	$AudioStreamPlayer.stop()

func _notification(what):
	if what == NOTIFICATION_WM_WINDOW_FOCUS_OUT:
		if not juego_pausado:
			_toggle_pausa()  # Pausar cuando se pierde el foco
	elif what == NOTIFICATION_WM_WINDOW_FOCUS_IN:
		if juego_pausado:
			_toggle_pausa()  # Reanudar cuando vuelve el foco


func _on_btn_reiniciar_pressed() -> void:
	get_tree().paused = false
	Global.jugador_muerto = true


func _on_btn_inicio_pressed() -> void:
	get_tree().paused = false
	Cargarmenu()
