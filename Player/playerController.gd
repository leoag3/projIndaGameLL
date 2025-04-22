extends CharacterBody3D

var lane_offset := 3.0
var lane_index := 0
var target_x := 0.0
var move_speed := 5.0
var crouch_timer: SceneTreeTimer
var is_crouching = false
var original_position := Vector3.ZERO
var wants_to_crouch_on_landing := false

# Jumping and gravity
var gravity := 20.0
var jump_force := 8.0

func _ready():
	target_x = global_position.x
	add_to_group("player")

func _unhandled_input(event):
	if event.is_action_pressed("ui_left") and lane_index > -1:
		lane_index -= 1
		target_x = lane_index * lane_offset
	elif event.is_action_pressed("ui_right") and lane_index < 1:
		lane_index += 1
		target_x = lane_index * lane_offset
	elif event.is_action_pressed("ui_up") and is_on_floor():
		uncrouch()  # Exit crouch if jumping
		velocity.y = jump_force
	elif event.is_action_pressed("ui_down"):
		if is_on_floor():
			crouch()
		else:
			# Slam down mid-air
			velocity.y = -jump_force * 1.5 #Tweak for feel
			wants_to_crouch_on_landing = true


func crouch():
	if not is_crouching:
		is_crouching = true
		original_position = global_position
		scale.y = 0.5
		global_position.y -= 0.5  # Adjust down to stay on the floor (tweak if needed)

		# Start crouch timer
		crouch_timer = get_tree().create_timer(1.0)
		crouch_timer.timeout.connect(uncrouch)

func uncrouch():
	if is_crouching:
		scale.y = 1.0
		global_position.y = original_position.y
		is_crouching = false

		if crouch_timer:
			crouch_timer.disconnect("timeout", uncrouch)
			crouch_timer = null

func _physics_process(delta):
	# Smooth horizontal lane movement
	var new_x = lerp(global_position.x, target_x, delta * move_speed)
	global_position.x = new_x

	# Gravity
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		if velocity.y < 0:
			velocity.y = 0.0

		# Auto-crouch if slammed down
		if wants_to_crouch_on_landing:
			crouch()
			wants_to_crouch_on_landing = false
	# Apply velocity with built-in movement
	move_and_slide()

	# Optional tilt effect
	var tilt = clamp((target_x - global_position.x) * 0.1, -0.2, 0.2)
	rotation.z = lerp(rotation.z, tilt, delta * 5)
	global_position.z = original_position.z
