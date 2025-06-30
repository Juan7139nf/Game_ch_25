extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Global.jugador_muerto:
		Global.jugador_muerto = false
		reiniciar_juego()

func reiniciar_juego():
	get_tree().reload_current_scene()

func _notification(what):
	if what == NOTIFICATION_WM_WINDOW_FOCUS_OUT:
		get_tree().paused = true
	elif what == NOTIFICATION_WM_WINDOW_FOCUS_IN:
		get_tree().paused = false
