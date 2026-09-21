class_name DifficultyManager
extends RefCounted

func settings(elapsed: float) -> Dictionary:
	if elapsed < 10.0: return {"max_targets":1, "duration":0.9, "trap_chance":0.08, "bonus_chance":0.09, "interval":0.72}
	if elapsed < 20.0: return {"max_targets":2, "duration":0.68, "trap_chance":0.14, "bonus_chance":0.12, "interval":0.55}
	return {"max_targets":3, "duration":0.48, "trap_chance":0.20, "bonus_chance":0.16, "interval":0.4}

