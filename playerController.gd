extends CharacterBody3D

var lane_offset := 3.0
var lane_index := 0
var target_x := 0.0
var move_speed := 5.0

# Jumping and gravity
var gravity := 20.0
var jump_force := 8.0

func _ready():
	target_x = global_position.x

func _unhandled_input(event):
	if event.is_action_pressed("ui_left") and lane_index > -1:
		lane_index -= 1
		target_x = lane_index * lane_offset
	elif event.is_action_pressed("ui_right") and lane_index < 1:
		lane_index += 1
		target_x = lane_index * lane_offset
	elif event.is_action_pressed("ui_up") and is_on_floor():
		velocity.y = jump_force  # Use built-in velocity property

func _physics_process(delta):
	# Smooth horizontal lane movement
	var new_x = lerp(global_position.x, target_x, delta * move_speed)
	global_position.x = new_x

	# Gravity
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = max(velocity.y, 0.0)

	# Apply velocity with built-in movement
	move_and_slide()

	# Optional tilt effect
	var tilt = clamp((target_x - global_position.x) * 0.1, -0.2, 0.2)
	rotation.z = lerp(rotation.z, tilt, delta * 5)
