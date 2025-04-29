extends Node3D

@export var cart_scene: PackedScene
@export var ramp_scene: PackedScene
@export var spawn_distance := -120.0
@export var obstacle_speed := 40.0
@export var lane_offset := 3.0
@export var cart_length := 12.0
@export var min_train_length := 2
@export var max_train_length := 15
@export var base_ramp_chance := 0.3
@export var min_spawn_delay := 0.1
@export var max_spawn_delay := 3.0

@export var empty_lane_chance := 0.4  # 0.0 = never skip, 1.0 = always skip (unrealistic)

@onready var player = get_parent().get_node("Player")

var lanes := [-1, 0, 1]
var busy_lanes := {}
var lane_timers := {}

func _ready():
	for lane in lanes:
		busy_lanes[lane] = false
		spawn_for_lane(lane)

func spawn_for_lane(lane: int) -> void:
	spawn_lane_loop(lane)

func spawn_lane_loop(lane: int) -> void:
	async_func(lane)

func async_func(lane: int) -> void:
	while true:
		await get_tree().create_timer(randf_range(min_spawn_delay, max_spawn_delay)).timeout

		# Random chance to skip spawning (adds variation)
		if randf() < empty_lane_chance:
			continue

		if busy_lanes[lane]:
			continue  # Wait for lane to free

		var must_ramp = should_force_ramp(lane)
		spawn_train(lane, must_ramp)

func spawn_train(lane: int, must_ramp: bool) -> void:
	busy_lanes[lane] = true
	var base_pos = Vector3(lane * lane_offset, 0, spawn_distance)

	var do_ramp = must_ramp or randf() < base_ramp_chance
	var train_len = randi_range(min_train_length, max_train_length)

	if do_ramp:
		var ramp = ramp_scene.instantiate()
		add_child(ramp)
		ramp.global_position = base_pos
		if ramp.has_method("set_speed"):
			ramp.set_speed(obstacle_speed)
		base_pos.z -= cart_length

	for i in train_len:
		var cart = cart_scene.instantiate()
		add_child(cart)
		cart.global_position = base_pos - Vector3(0, 0, i * cart_length)
		if cart.has_method("set_speed"):
			cart.set_speed(obstacle_speed)

	var train_total_length = (1 if do_ramp else 0) + train_len
	var travel_time = (abs(spawn_distance) + train_total_length * cart_length - 50.0) / obstacle_speed

	# Add cooldown to simulate lane being empty for a while
	var cooldown_bonus := randf_range(1.5, 4.0)
	free_lane_after_delay(lane, travel_time + cooldown_bonus)


func free_lane_after_delay(lane: int, delay: float) -> void:
	await get_tree().create_timer(delay).timeout
	busy_lanes[lane] = false

func should_force_ramp(lane: int) -> bool:
	var occupied = busy_lanes.values().count(true)

	# If this is the only open lane, force ramp
	if occupied >= 2 and not busy_lanes[lane]:
		return true

	# Get player's current lane
	if player != null and player.has_method("get_lane_index"):
		var player_lane = player.get_lane_index()

		# If the player is on the left and mid is blocked, force ramp on left
		if player_lane == -1 and busy_lanes[0] and lane == -1:
			return true

		# If the player is on the right and mid is blocked, force ramp on right
		if player_lane == 1 and busy_lanes[0] and lane == 1:
			return true

		# If the player is in mid and both sides are blocked, force ramp mid
		if player_lane == 0 and busy_lanes[-1] and busy_lanes[1] and lane == 0:
			return true

	return false
