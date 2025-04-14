extends Node

@onready var menu_music: AudioStreamPlayer = $MenuMusic
@onready var game_music: AudioStreamPlayer = $GameMusic

func play_menu_music() -> void:
	if not menu_music.playing:
		game_music.stop()
		menu_music.play()

func play_game_music() -> void:
	if not game_music.playing:
		menu_music.stop()
		game_music.play()
