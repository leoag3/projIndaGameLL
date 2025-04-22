extends Node3D

@export var obstacle_scene: PackedScene       # Carts
@export var obstacle_scene2: PackedScene      # Ramps
@export var spawn_rate := 1.0
@export var spawn_distance := -120.0            # Positive Z, since they move toward -Z
@export var obstacle_speed := 25.0
@export var lane_offset := 3.0
@export var ramp_chance := 0.25                # 0.0 to 1.0 chance a ramp will appear in front of a cart
@export var ramp_offset := -12.0                # How far in front of cart to place ramp

var lanes := [-1, 0, 1]  # left, center, right

func _ready():
	spawn_obstacle()
	start_timer()

func start_timer():
	await get_tree().create_timer(spawn_rate).timeout
	spawn_obstacle()
	start_timer()

func spawn_obstacle():
	var lane = lanes.pick_random()
	
	# Spawn cart
	var cart = obstacle_scene.instantiate()
	add_child(cart)
	var cart_pos = Vector3(lane * lane_offset, 0, spawn_distance)
	cart.global_position = cart_pos

	if cart.has_method("set_speed"):
		cart.set_speed(obstacle_speed)

	# Possibly spawn ramp in front of it
	if randf() < ramp_chance:
		var ramp = obstacle_scene2.instantiate()
		add_child(ramp)
		var ramp_pos = cart_pos - Vector3(0, 0, ramp_offset)  # closer to camera (−Z)
		ramp.global_position = ramp_pos

		if ramp.has_method("set_speed"):
			ramp.set_speed(obstacle_speed)
