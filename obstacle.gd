extends Node3D

var speed := 10.0

func set_speed(val):
	speed = val

func _physics_process(delta):
	global_position.z += speed * delta  # Moves toward -Z (toward camera)
