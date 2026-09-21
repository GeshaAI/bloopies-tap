extends Node

var music_player := AudioStreamPlayer.new()
var sfx_player := AudioStreamPlayer.new()

func _ready() -> void:
	add_child(music_player)
	add_child(sfx_player)
	refresh_settings()

func refresh_settings() -> void:
	music_player.volume_db = 0.0 if SaveManager.data.music else -80.0
	sfx_player.volume_db = 0.0 if SaveManager.data.sfx else -80.0

func play_ui() -> void:
	# Audio hooks intentionally remain silent until original licensed assets are supplied.
	pass

func play_character(_id: String) -> void:
	pass

func set_fever(active: bool) -> void:
	music_player.pitch_scale = 1.12 if active else 1.0

