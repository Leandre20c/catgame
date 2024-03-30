extends Control

func _on_ready():
	$MarginContainer/VBoxContainer/player.reload_scene()
	
	
func _on_play_pressed():
	get_tree().change_scene_to_file("res://scene/levels/level_1.tscn")

func _on_levels_pressed():
	get_tree().change_scene_to_file("res://scene/menus/levels_menu.tscn")
	

func _on_options_pressed():
	get_tree().change_scene_to_file("res://scene/menus/option_menu.tscn")


func _on_skins_pressed():
	get_tree().change_scene_to_file("res://scene/menus/skin_change/skin_changer_menu.tscn")


func _on_quit_pressed():
	get_tree().quit()
