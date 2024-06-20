extends Control

func _on_start_button_down():
	get_tree().change_scene_to_file("res://scenes/world.tscn")


func _on_quit_button_down():
	get_tree().quit()
