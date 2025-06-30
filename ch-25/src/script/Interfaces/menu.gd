extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$AnimationPlayer.play("Luces")
	$Node3D/AnimationPlayer.play("Charge")
	$Node3D/AnimationCamera.play("Menu")
	$Control/Panel.visible = false
	Global.score = 0
	Global.enemigos_activos = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if $Control/Panel.visible == true && Input.is_key_pressed(KEY_ESCAPE):
		$Control/Panel.visible = false
		$Control/VBoxContainer.visible = true
		$Node3D/AnimationPlayer.play("Charge")
		$Node3D/AnimationCamera.play("Option_Menu")
		await $Node3D/AnimationCamera.animation_finished
		$Node3D/AnimationCamera.play("Menu")
		$Control/BoxContainer.visible = true


func _on_btn_jugar_pressed() -> void:
	$Control/BoxContainer.visible = false
	$AudioStreamPlayer.volume_db = -5.0
	$Node3D/AnimationPlayer.play("Charge_Success")
	$Node3D/AnimationCamera.play("Success")
	await $Node3D/AnimationCamera.animation_finished
	
	var nueva_escena = load("res://src/scenes/Niveles/nivel_01.tscn")
	get_tree().change_scene_to_packed(nueva_escena)


func _on_btn_opciones_pressed() -> void:
	$Control/BoxContainer.visible = false
	$Node3D/AnimationPlayer.play("Charge_Info")
	$Node3D/AnimationCamera.play("Option")
	$Control/Panel.visible = true
	$Control/VBoxContainer.visible = false


func _on_btn_salir_pressed() -> void:
	$Control/BoxContainer.visible = false
	$Node3D/AnimationPlayer.stop()
	$AnimationPlayer.play("Apagar_Luces")
	await get_tree().create_timer(1.5).timeout
	get_tree().quit()
