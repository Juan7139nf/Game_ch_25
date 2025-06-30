extends Area3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("normal")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_body_entered(body: Node3D) -> void:
	if not body.is_in_group("jugador"):
		return
		
	Global.score += 1
	queue_free()
