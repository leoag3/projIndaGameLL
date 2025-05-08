extends Node3D

var speed := 10.0

func set_speed(val):
	speed = val

func _physics_process(delta):
	if GameState.is_crashed:
		return  # Halt movement
	global_position.z += speed * delta  # Moves toward -Z (toward camera)

func _on_CrashTrigger_body_entered(body):
	if body.name == "Player":  # Adjust as needed
		print("CRASH")
		if not GameState.is_crashed:
			GameState.crash()


func _on_crash_trigger_body_entered(body: Node3D) -> void:
	if body.name == "Player":  # Adjust as needed
		print("CRASH")
		if not GameState.is_crashed:
			GameState.crash()
			
