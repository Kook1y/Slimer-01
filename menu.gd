extends Control

func _on_play_button_pressed() -> void:
	# Change this path to match your actual main game scene file
	get_tree().change_scene_to_file("res://survivors_game.tscn")
