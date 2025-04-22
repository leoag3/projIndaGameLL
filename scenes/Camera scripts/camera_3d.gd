extends Camera3D

@export var player_path: NodePath  # Set this in the Inspector
@export var follow_strength := 0.5  # How strongly it follows the player (0.0–1.0)
@export var fixed_offset := Vector3(0, 5, 10)  # Position relative to player

var player: Node3D

func _ready():
	player = get_node(player_path)

func _process(delta):
	if player == null:
		return

	# Calculate target position (follows X partially, Y and Z are fixed offsets)
	var target_x = lerp(global_position.x / 2, player.global_position.x, follow_strength)
	var target_y = player.global_position.y + fixed_offset.y
	var target_z = player.global_position.z + fixed_offset.z

	global_position = Vector3(target_x, target_y, target_z)
