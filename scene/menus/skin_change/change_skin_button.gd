extends Button

var level_files = {
	1: "res://scene/levels/level_1.tscn",
	2: "res://scene/levels/level_2.tscn",
	3: "res://scene/levels/level_3.tscn",
}

@export var index = 1

func _on_pressed():
	var level_file = level_files.get(index)
	if level_file:
		get_tree().change_scene_to_file(level_file)
	else:
		print("this level doesn't exist")
