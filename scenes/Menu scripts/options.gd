extends Control

@onready var music_slider = $VBoxContainer/MusicSlider
@onready var sfx_slider = $VBoxContainer/SFXSlider

func _ready():
	# Load saved values from Settings singleton
	music_slider.value = Settings.music_volume * 100
	sfx_slider.value = Settings.sfx_volume * 100
	# Connect value change signals
	music_slider.value_changed.connect(_on_volume_music_changed)
	sfx_slider.value_changed.connect(_on_volume_sound_changed)

	# Immediately apply volume (in case it's 50% etc)
	update_volumes()

func _on_return_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/StartMenu.tscn")


func _on_volume_music_changed(value) -> void:
	Settings.music_volume = value / 100.0
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(Settings.music_volume))


func _on_volume_sound_changed(value) -> void:
	Settings.sfx_volume = value / 100.0
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(Settings.sfx_volume))


func update_volumes():
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("Music"),
		linear_to_db(Settings.music_volume)
	)
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("SFX"),
		linear_to_db(Settings.sfx_volume)
	)
