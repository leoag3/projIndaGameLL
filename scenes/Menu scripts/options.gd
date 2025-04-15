extends Control

@onready var music_slider = $VBoxContainer/MusicSlider
@onready var sfx_slider = $VBoxContainer/SFXSlider

func _ready():
	MusicManager.play_menu_music()
	# Initialize sliders with current values
	music_slider.value = Settings.music_volume * 100
	sfx_slider.value = Settings.sfx_volume * 100
	music_slider.value_changed.connect(_on_music_changed)
	sfx_slider.value_changed.connect(_on_sfx_changed)

func _on_music_changed(value: float):
	Settings.music_volume = value / 100.0
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("Music"),
		linear_to_db(Settings.music_volume)
	)

func _on_sfx_changed(value: float):
	Settings.sfx_volume = value / 100.0
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("SFX"),
		linear_to_db(Settings.sfx_volume)
	)


func _on_return_pressed():
	Settings.save_settings()  # Save only when exiting options
	get_tree().change_scene_to_file("res://scenes/StartMenu.tscn")
