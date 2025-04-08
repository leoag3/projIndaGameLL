extends CharacterBody3D

var speed = 5.0

func _physics_process(delta):
	# Get input direction
	var input_dir = Input.get_axis("ui_left", "ui_right")
	
	# Calculate velocity (only for x-axis movement)
	var direction = Vector3(input_dir, 0, 0)
	velocity.x = direction.x * speed
	
	# Keep vertical velocity (for future gravity implementation if needed)
	velocity.y = 0  # No vertical movement
	velocity.z = 0  # No forward/backward movement
	
	# Move the character
	move_and_slide()
	
	# Optional: Add a small visual rotation when moving
	if input_dir != 0:
		rotation.z = lerp(rotation.z, -input_dir * 0.2, delta * 5)
	else:
		rotation.z = lerp(rotation.z, 0.0, delta * 5)
