extends CanvasLayer

func _ready():
	hide()  # Start hidden
	$VBoxContainer/ResumeButton.pressed.connect(unpause)
	$VBoxContainer/MainMenuButton.pressed.connect(go_to_main_menu)
	$VBoxContainer/RestartButton.pressed.connect(restart_level)

func unpause():
	get_tree().paused = false
	hide()
	get_viewport().set_input_as_handled()

func go_to_main_menu():
	get_tree().paused = false  # Important!
	get_tree().change_scene_to_file("res://scenes/StartMenu.tscn")

func restart_level():
	get_tree().paused = false
	get_tree().reload_current_scene()

func _input(event):
	if visible and event.is_action_pressed("ui_cancel"):  # Escape key by default
		unpause()
