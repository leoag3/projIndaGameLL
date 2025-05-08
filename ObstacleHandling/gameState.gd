extends Node

var is_crashed := false

func crash():
	is_crashed = true
	#await get_tree().create_timer(2).timeout
	#get_tree().change_scene_to_file("res://scenes/StartMenu.tscn")
	#reset()

func reset():
	is_crashed = false
