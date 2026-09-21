class_name SpawnManager
extends Node2D

signal target_resolved(kind, character_id)
const TARGET_SCENE := preload("res://scenes/bloopie.tscn")
var points: Array[SpawnPoint] = []
var pool: Array[BloopieTarget] = []
var active: Array[BloopieTarget] = []
var no_traps := false
var highlighted_index := -1
var scan_next := false

func initialize(marker_root: Node) -> void:
	for child in marker_root.get_children(): points.append(child as SpawnPoint)
	for i in range(8):
		var target := TARGET_SCENE.instantiate() as BloopieTarget
		target.visible = false
		target.resolved.connect(_resolved)
		add_child(target)
		pool.append(target)

func spawn_wave(settings: Dictionary, force_kind := "") -> void:
	var desired: int = randi_range(1, int(settings.max_targets))
	for i in range(desired):
		if active.size() >= int(settings.max_targets): return
		var free := _free_points()
		if free.is_empty(): return
		var point: SpawnPoint = free.pick_random()
		var target := _get_free_target()
		if target == null: return
		var kind := force_kind
		if kind.is_empty():
			var roll := randf()
			if not no_traps and roll < float(settings.trap_chance): kind = ["trap", "trap", "crab", "barrel"].pick_random()
			elif roll < float(settings.trap_chance) + float(settings.bonus_chance): kind = "fruit"
			else: kind = "bloopie"
		var data := CharacterDatabase.random_character()
		point.occupied = true
		target.position = point.position
		target.setup(kind, data, float(settings.duration), points.find(point))
		if scan_next and kind == "bloopie":
			scan_next = false
			target.modulate = Color(1.3, 1.3, 0.75, 1.0)
			var scan_tween := create_tween()
			scan_tween.tween_property(target, "modulate", Color.WHITE, 0.45)
		if kind == "fruit": _excite_glop()
		active.append(target)

func highlight_next_target() -> void:
	scan_next = true

func _excite_glop() -> void:
	for target in active:
		if target.character_id == "glop" and target.visible:
			var original := target.rotation
			var tween := create_tween()
			tween.tween_property(target, "rotation", original - 0.12, 0.08)
			tween.tween_property(target, "rotation", original + 0.12, 0.08)
			tween.tween_property(target, "rotation", original, 0.08)

func _free_points() -> Array[SpawnPoint]:
	var result: Array[SpawnPoint] = []
	for point in points:
		if not point.occupied: result.append(point)
	return result

func _get_free_target() -> BloopieTarget:
	for target in pool:
		if not target.visible: return target
	return null

func _resolved(target: BloopieTarget, kind: String, character_id: String) -> void:
	if target.point_index >= 0 and target.point_index < points.size(): points[target.point_index].occupied = false
	active.erase(target)
	target.deactivate()
	target_resolved.emit(kind, character_id)

func clear_all() -> void:
	for target in active.duplicate():
		if target.point_index >= 0: points[target.point_index].occupied = false
		target.deactivate()
	active.clear()
