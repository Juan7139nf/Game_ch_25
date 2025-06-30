extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@onready var anim = $ch_25/Armature/AnimationPlayer
@onready var camera = $"../Node3D2/Camera3D"

func _ready() -> void:
	add_to_group("jugador")

func _physics_process(delta: float) -> void:
	# Gravedad
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Saltar
	# if Input.is_action_just_pressed("ui_accept") and is_on_floor():
	if Input.is_action_pressed("Saltar") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Dirección del input
	# var input_dir = Input.get_vector("ui_left", "ui_right", "ui_down", "ui_up")
	var input_dir = Input.get_vector("Mover_Izquierda", "Mover_Derecha", "Mover_Abajo", "Mover_Arriba")
	var direction = Vector3.ZERO

	if input_dir != Vector2.ZERO:
		# Movimiento relativo a la cámara
		var cam_basis = camera.global_transform.basis
		var forward = -cam_basis.z
		var right = cam_basis.x
		direction = (right * input_dir.x + forward * input_dir.y).normalized()

		# Movimiento suave
		velocity.x = lerp(velocity.x, direction.x * SPEED, 0.1)
		velocity.z = lerp(velocity.z, direction.z * SPEED, 0.1)

		# Rotar hacia la dirección
		var target = global_position + direction
		target.y = global_position.y
		var target_dir = (target - global_position).normalized()
		var current_dir = -global_transform.basis.z.normalized()
		var rot = current_dir.slerp(target_dir, 0.1)
		look_at(global_position + rot, Vector3.UP)

		# Animación
		anim.play("Run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		anim.stop()

	move_and_slide()
	Global.jugador_position = global_position
