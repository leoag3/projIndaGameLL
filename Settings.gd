extends Node

# Volume variables with custom setters (Godot 4.x style)
var music_volume: float = 0.5
var sfx_volume: float = 0.5

const CONFIG_PATH = "user://settings.cfg"

func _ready() -> void:
	load_settings()

# Save/Load functions remain the same...
func save_settings() -> void:
	var config = ConfigFile.new()
	config.set_value("audio", "music_volume", music_volume)
	config.set_value("audio", "sfx_volume", sfx_volume)
	config.save(CONFIG_PATH)

func load_settings() -> void:
	var config = ConfigFile.new()
	if config.load(CONFIG_PATH) == OK:
		music_volume = clamp(config.get_value("audio", "music_volume", 0.5), 0.0, 1.0)
		sfx_volume = clamp(config.get_value("audio", "sfx_volume", 0.5), 0.0, 1.0)
	else:
		music_volume = 0.5
		sfx_volume = 0.5
		save_settings()
	update_audio_servers()

func update_audio_servers() -> void:
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("Music"),
		linear_to_db(music_volume)
	)
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("SFX"),
		linear_to_db(sfx_volume)
	)
