extends Node3D

@export var obstacle_scene: PackedScene
@export var spawn_rate := 1.5  # seconds between spawns
@export var spawn_distance := -30.0  # how far away obstacles spawn (on Z axis)
@export var obstacle_speed := 10.0
@export var lane_offset := 3.0

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
	var instance = obstacle_scene.instantiate()
	add_child(instance)

	# Set spawn position in one of the lanes, far down the Z axis (opposite direction)
	var position = Vector3(lane * lane_offset, 0, spawn_distance)
	instance.global_position = position

	# Give the obstacle a script or velocity to move toward the player
	if instance.has_method("set_speed"):
		instance.set_speed(obstacle_speed)
