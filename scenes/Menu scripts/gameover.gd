extends CanvasLayer

func _ready():
	hide()  # Start hidden
	$VBoxContainer/MainMenuButton.pressed.connect(go_to_main_menu)
	$VBoxContainer/RestartButton.pressed.connect(restart_level)
	

func go_to_main_menu():
	get_tree().paused = false  # Important!
	get_tree().change_scene_to_file("res://scenes/StartMenu.tscn")
	GameState.reset()

func restart_level():
	get_tree().paused = false
	get_tree().reload_current_scene()
	GameState.reset()
	
