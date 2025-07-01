extends Node3D

@export var enemigo_escena: PackedScene = preload("res://src/scenes/Character/enemy_verde.tscn")
@export var cantidad_maxima: int = 5


func _ready() -> void:
	Global.score = 0
	Global.enemigos_activos = 0
	Global.fase = 0
	randomize()
	$Puntos/AnimationPlayer_Puntos.play("Puntos_Mover")
	spawn_enemigos()
	aumentar_dificultad()

func spawn_enemigos() -> void:
	while true:
		await get_tree().create_timer(2.5).timeout
		if Global.enemigos_activos < cantidad_maxima:
			spawnear_enemigo()

func spawnear_enemigo():
	$AnimationPlayer_Luz_Verde.play("Nuevo_Enemigo")
	await get_tree().create_timer(0.55).timeout
	var enemigo = enemigo_escena.instantiate()
	get_parent().add_child(enemigo)

	# Obtener posición del jugador
	var jugador_pos = Global.jugador_position

	# Obtener los puntos de spawn
	var puntos = $Puntos.get_children()
	var punto_cercano = puntos[0]
	var distancia_minima = puntos[0].global_position.distance_to(jugador_pos)

	for punto in $Puntos.get_children():
		if punto is Node3D:
			var dist = punto.global_position.distance_to(jugador_pos)
			if dist < distancia_minima:
				distancia_minima = dist
				punto_cercano = punto

	enemigo.global_position = punto_cercano.global_position - Vector3(0, 3.5, 0)

	Global.enemigos_activos += 1

func aumentar_dificultad():
	while Global.fase < 6:
		await get_tree().create_timer(30.0).timeout
		if Global.fase == 1:
			cantidad_maxima += 3
		elif Global.fase > 1:
			cantidad_maxima += 5
		Global.fase += 1
