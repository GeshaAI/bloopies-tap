class_name MenuBase
extends Control

func make_button(text_value: String, width := 420) -> Button:
	var button := Button.new()
	button.text = text_value
	button.custom_minimum_size = Vector2(width, 92)
	button.add_theme_font_size_override("font_size", 30)
	return button

func change_scene(path: String) -> void:
	AudioManager.play_ui()
	get_tree().change_scene_to_file(path)

