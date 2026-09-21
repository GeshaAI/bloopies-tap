class_name ComboManager
extends RefCounted

var combo := 0
var max_combo := 0
var recent: Array[String] = []

func success(id: String) -> Dictionary:
	combo += 1
	max_combo = max(max_combo, combo)
	recent.append(id)
	if recent.size() > 3: recent.pop_front()
	var special := ""
	if recent.size() == 3 and recent[0] == id and recent[1] == id and recent[2] == id:
		special = CharacterDatabase.get_character(id).special_combo
		recent.clear()
	return {"special":special, "super":combo == 3, "double":combo >= 5, "fever":combo >= 10}

func miss() -> void:
	combo = 0
	recent.clear()

