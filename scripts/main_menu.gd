extends MenuBase

func _ready() -> void:
	theme = ThemeFactory.make_theme()
	$Play.pressed.connect(func(): change_scene("res://scenes/game.tscn"))
	$Levels.pressed.connect(func(): change_scene("res://scenes/level_select.tscn"))
	$Music.button_pressed = bool(SaveManager.data.music)
	$Sound.button_pressed = bool(SaveManager.data.sfx)
	$Music.toggled.connect(_setting.bind("music"))
	$Sound.toggled.connect(_setting.bind("sfx"))
	$Stars.text = "⭐  %d TOTAL STARS" % int(SaveManager.data.total_stars)
	for mascot in $Mascots.get_children():
		var tween := create_tween().set_loops()
		tween.tween_property(mascot, "position:y", mascot.position.y - 12.0, 0.8).set_trans(Tween.TRANS_SINE)
		tween.tween_property(mascot, "position:y", mascot.position.y, 0.8).set_trans(Tween.TRANS_SINE)

func _setting(enabled: bool, key: String) -> void:
	SaveManager.data[key] = enabled
	SaveManager.save_game()
	AudioManager.refresh_settings()

