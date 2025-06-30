extends CharacterBody3D

@export var velocidad: float = 2.0

const moneda_escena = preload("res://src/scenes/Items/moneda.tscn")

var ultima_pos_moneda: Vector3 = Vector3.INF

@onready var anim = $alienVerde/AnimationPlayer

func _ready() -> void:
	add_to_group("enemigo")
	$AnimationPlayer.play("Run")

func _physics_process(delta):
	if typeof(Global.jugador_position) != TYPE_VECTOR3:
		return
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	var jugador = Global.jugador_position
	var direccion = (jugador - global_position).normalized()

	# Calcular distancia al jugador
	var distancia = global_position.distance_to(jugador)

	# Ajustar velocidad según la distancia
	var velocidad_actual = velocidad
	if distancia > 8.0:
		velocidad_actual = velocidad * 2.0  # Puedes ajustar el multiplicador

	# Movimiento y rotación siempre hacia el jugador
	velocity.x = lerp(velocity.x, direccion.x * velocidad_actual, 0.1)
	velocity.z = lerp(velocity.z, direccion.z * velocidad_actual, 0.1)

	if direccion.length_squared() > 0.01:
		var target = global_position + direccion
		target.y = global_position.y
		var current_dir = -global_transform.basis.z.normalized()
		var target_dir = (target - global_position).normalized()
		var rot = current_dir.slerp(target_dir, 0.1)
		look_at(global_position + rot, Vector3.UP)

	# Animaciones
	var velocidad_horizontal = Vector3(velocity.x, 0, velocity.z).length()
	if velocidad_horizontal > 0.05:
		if not anim.is_playing() or anim.current_animation != "Armature|Run":
			anim.play("Armature|Run")
	else:
		anim.stop()

	move_and_slide()


func instanciar_moneda():
	if moneda_escena:
		var nueva_moneda = moneda_escena.instantiate()
		get_parent().add_child(nueva_moneda)
		nueva_moneda.global_position = global_position
		ultima_pos_moneda = global_position


func _on_area_3d_body_entered(body: Node3D) -> void:
	if not body.is_in_group("jugador"):
		return
	set_physics_process(false)
	$AudioExploxion.playing = true
	$AnimationPlayer.play("Muerto")
	anim.play("Armature|Muerto")
	if body.has_method("morir"):
		body.call("morir")
	await get_tree().create_timer(1.5).timeout
	queue_free()
