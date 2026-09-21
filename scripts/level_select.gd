extends MenuBase

func _ready() -> void:
	theme = ThemeFactory.make_theme()
	$Back.pressed.connect(func(): change_scene("res://scenes/main_menu.tscn"))
	var unlock := int(SaveManager.data.unlocked_levels)
	for i in range(1, 4):
		var button: Button = get_node("Level%d" % i)
		button.disabled = i > unlock
		if button.disabled: button.text += "\n🔒 LOCKED"
		else: button.pressed.connect(_play.bind(i))
	$Hint.text = "Earn 3 stars for BLOOPIES ISLAND\nEarn 8 stars for FLOATING HOUSE\n⭐ You have %d" % int(SaveManager.data.total_stars)

func _play(level: int) -> void:
	get_tree().set_meta("selected_level", level)
	change_scene("res://scenes/game.tscn")

