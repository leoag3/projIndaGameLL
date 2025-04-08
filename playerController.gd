extends CharacterBody3D

var lane_offset := 2.0  # Distance between lanes
var lane_index := 0  # Current lane (-1 = left, 0 = center, 1 = right)
var target_x := 0.0  # Target x-position based on lane
var move_speed := 5.0  # Movement speed between lanes

func _ready():
	# Set initial target position
	target_x = global_position.x

func _unhandled_input(event):
	if event.is_action_pressed("ui_left") and lane_index > -1:
		lane_index -= 1
		target_x = lane_index * lane_offset
	elif event.is_action_pressed("ui_right") and lane_index < 1:
		lane_index += 1
		target_x = lane_index * lane_offset

func _physics_process(delta):
	# Smoothly move towards the target x-position
	var current_pos = global_position
	var new_x = lerp(current_pos.x, target_x, delta * move_speed)
	global_position.x = new_x

	# Optional: Add a slight tilt when moving
	var tilt = clamp((target_x - global_position.x) * 0.1, -0.2, 0.2)
	rotation.z = lerp(rotation.z, tilt, delta * 5)
