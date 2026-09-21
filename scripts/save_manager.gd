extends Node

const SAVE_PATH := "user://bloopies_tap_save.json"
var data := {"best_score": 0, "max_combo": 0, "total_stars": 0, "unlocked_levels": 1, "music": true, "sfx": true}

func _ready() -> void:
	load_game()

func load_game() -> void:
	if not FileAccess.file_exists(SAVE_PATH): return
	var parsed = JSON.parse_string(FileAccess.get_file_as_string(SAVE_PATH))
	if parsed is Dictionary:
		for key in data: data[key] = parsed.get(key, data[key])

func save_game() -> void:
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file: file.store_string(JSON.stringify(data))

func finish_round(score: int, combo: int, stars: int) -> void:
	data.best_score = max(int(data.best_score), score)
	data.max_combo = max(int(data.max_combo), combo)
	data.total_stars = int(data.total_stars) + stars
	if int(data.total_stars) >= 3: data.unlocked_levels = max(int(data.unlocked_levels), 2)
	if int(data.total_stars) >= 8: data.unlocked_levels = max(int(data.unlocked_levels), 3)
	save_game()

