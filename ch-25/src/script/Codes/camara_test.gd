extends Node3D

@export var suavizado: float = 5.0
@export var limite_min: Vector3 = Vector3(-51, 0, -51)
@export var limite_max: Vector3 = Vector3(51, 0, 51)

var destino := Vector3.ZERO

@onready var objetivo := get_parent().get_node("Ch_25")

func _ready():
	destino = global_position

func _process(_delta):
	if objetivo:
		var pos_objetivo = objetivo.global_position
		# Solo seguimos en X y Z (sin cambiar altura Y)
		destino = Vector3(pos_objetivo.x, global_position.y, pos_objetivo.z)

		# Aplicar límites
		destino.x = clamp(destino.x, limite_min.x, limite_max.x)
		destino.z = clamp(destino.z, limite_min.z, limite_max.z)

		# Movimiento suavizado
		global_position = global_position.lerp(destino, _delta * suavizado)
