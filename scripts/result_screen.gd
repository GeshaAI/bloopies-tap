extends MenuBase

func _ready() -> void:
	theme = ThemeFactory.make_theme()
	var result: Dictionary = get_tree().get_meta("last_result", {"score":0,"max_combo":0,"stars":1,"level":1})
	$Stats.text = "SCORE   %d\nBEST SCORE   %d\nMAX COMBO   %d\n\n%s\nSTARS EARNED" % [int(result.score), int(SaveManager.data.best_score), int(result.max_combo), "⭐".repeat(int(result.stars))]
	$Again.pressed.connect(func(): change_scene("res://scenes/game.tscn"))
	$Levels.pressed.connect(func(): change_scene("res://scenes/level_select.tscn"))
	$Home.pressed.connect(func(): change_scene("res://scenes/main_menu.tscn"))

