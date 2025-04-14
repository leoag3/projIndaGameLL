extends Control

func _ready() -> void:
	$VBoxContainer/Start.grab_focus()
	MusicManager.play_menu_music()

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/scene.tscn")

func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Options.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
