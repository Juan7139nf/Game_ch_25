extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const RUN_MULTIPLIER = 2.0  # Velocidad al correr

@onready var anim = $robot/AnimationPlayer
@onready var camera = $"../Node3D2/Camera3D"
@onready var audioEngine = $AudioEngine

var cubo_disparo = preload("res://src/scenes/Items/disparo.tscn")
@export var tiempo_entre_disparos: float = 0.2
var efecto_muerte = preload("res://src/scenes/Items/explosion.tscn")

var tiempo_disparo := 0.0

var activo = true

func _ready() -> void:
	add_to_group("jugador")
	anim.play("Armature|Idle")
	velocity = Vector3.ZERO
	global_position = Vector3(0, 0, 0)  # O la posición donde quieras que aparezca
	Global.jugador_position = global_position

func _physics_process(delta: float) -> void:
	# Proteger contra delta grande por pérdida de foco o pausa
	if delta > 0.2:
		return  # Ignora frames con delta acumulado
	if not DisplayServer.window_is_focused():
		return  # No procesar si la ventana está inactiva
	
	if not is_on_floor():
		velocity += get_gravity() * delta
		collision_mask = 1 | 2  # Capa 1 y 2 activas en el aire
	else:
		collision_mask = 1      # Solo capa 1 cuando está en el suelo

	if Input.is_action_pressed("Saltar") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir = Input.get_vector("Mover_Izquierda", "Mover_Derecha", "Mover_Abajo", "Mover_Arriba")
	var direction = Vector3.ZERO

	# Shift presionado => correr
	var speed_actual = SPEED
	if Input.is_action_pressed("Acelerar"):
		speed_actual *= RUN_MULTIPLIER

	if input_dir != Vector2.ZERO:
		var cam_basis = camera.global_transform.basis
		var forward = -cam_basis.z
		var right = cam_basis.x
		direction = (right * input_dir.x + forward * input_dir.y).normalized()

		velocity.x = lerp(velocity.x, direction.x * speed_actual, 0.1)
		velocity.z = lerp(velocity.z, direction.z * speed_actual, 0.1)

		var target = global_position + direction
		target.y = global_position.y
		var target_dir = (target - global_position).normalized()
		var current_dir = -global_transform.basis.z.normalized()
		var rot = current_dir.slerp(target_dir, 0.1)
		look_at(global_position + rot, Vector3.UP)
		audioEngine.playing = true
		anim.play("Armature|Run")
	else:
		audioEngine.playing = false
		
		# Si la velocidad es muy pequeña, la forzamos a 0
		if abs(velocity.x) < 0.01:
			velocity.x = 0.0
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

		if abs(velocity.z) < 0.01:
			velocity.z = 0.0
		else:
			velocity.z = move_toward(velocity.z, 0, SPEED)

		anim.play("Armature|Idle")
	
	velocity = velocity.limit_length(10.0)
	move_and_slide()
	Global.jugador_position = global_position

	tiempo_disparo -= delta
	if Input.is_action_pressed("Disparar") and tiempo_disparo <= 0.0:
		disparar()
		tiempo_disparo = tiempo_entre_disparos

func disparar():
	if not cubo_disparo:
		return

	var cubo = cubo_disparo.instantiate()
	cubo.name = "CuboDisparo"
	get_tree().current_scene.add_child(cubo)

	var arma_position = $MeshInstance3D.global_position
	var frente = -global_transform.basis.z.normalized()
	cubo.global_position = arma_position + frente * 0 + Vector3.UP * 0
	cubo.global_rotation = global_rotation

	if cubo.has_method("set_direccion"):
		cubo.call("set_direccion", frente)

func morir():
	if activo:
		activo = false
		audioEngine.playing = false
		anim.play("Armature|Muerte")
		set_physics_process(false)
		
		if efecto_muerte:
			var efecto = efecto_muerte.instantiate()
			get_tree().current_scene.add_child(efecto)
			efecto.global_position = self.global_position

			# Eliminar el efecto tras 0.5 segundos
			await get_tree().create_timer(0.5).timeout
			efecto.queue_free()
		
		await anim.animation_finished
		await get_tree().create_timer(2.5).timeout
		Global.jugador_position = Vector3.ZERO
		Global.jugador_muerto = true 
		queue_free()
