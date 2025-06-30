extends Area3D

@export var velocidad: float = 20.0
var direccion: Vector3 = Vector3.ZERO
var tiempo_vida: float = 5.0  # El cubo se destruye después de 5 segundos

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not is_connected("body_entered", Callable(self, "_on_body_entered")):
		connect("body_entered", Callable(self, "_on_body_entered"))

func set_direccion(dir: Vector3):
	direccion = dir.normalized()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Movimiento constante
	global_position += direccion * velocidad * delta

	# Contador de vida
	tiempo_vida -= delta
	if tiempo_vida <= 0:
		queue_free()


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("enemigo"):
		if body.has_method("instanciar_moneda"):
			body.call("instanciar_moneda")
		body.queue_free()
		Global.enemigos_activos -= 1
		queue_free()  # El disparo desaparece tambiénpass # Replace with function body.
