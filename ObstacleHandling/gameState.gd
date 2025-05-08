extends Node

var is_crashed := false

func crash():
	is_crashed = true
	await get_tree().create_timer(4).timeout
	
	reset()

func reset():
	is_crashed = false
