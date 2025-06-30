extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	await get_tree().process_frame  # Espera al menos un frame
	$Control/VideoStreamPlayer.play()
	await $Control/VideoStreamPlayer.finished
	get_tree().change_scene_to_packed(load("res://src/scenes/menu.tscn"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
