extends CanvasLayer

func _ready():
	hide()  # Start hidden
	$VBoxContainer/ResumeButton.pressed.connect(unpause)
	$VBoxContainer/MainMenuButton.pressed.connect(go_to_main_menu)

func unpause():
	get_tree().paused = false
	GameState.is_paused = false
	hide()
	get_viewport().set_input_as_handled()

func go_to_main_menu():
	get_tree().paused = false  # Important!
	GameState.is_paused = false
	get_tree().change_scene_to_file("res://scenes/StartMenu.tscn")

func restart_level():
	get_tree().paused = false
	GameState.is_paused = false
	get_tree().reload_current_scene()

func _input(event):
	if visible and event.is_action_pressed("ui_cancel"):  # Escape key by default
		unpause()
