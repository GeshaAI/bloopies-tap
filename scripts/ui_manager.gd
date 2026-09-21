class_name UIManager
extends RefCounted

var root: Control
func _init(game_root: Control) -> void: root = game_root
func update(score: int, combo: int, lives: int, time_left: float) -> void:
	root.get_node("HUD/Score").text = "⭐ SCORE\n%d" % score
	root.get_node("HUD/Combo").text = "🔥 COMBO\n%d" % combo
	root.get_node("HUD/Lives").text = "❤️ LIVES\n%d" % lives
	root.get_node("HUD/Timer").text = "⏱ %.1f" % max(time_left, 0.0)

