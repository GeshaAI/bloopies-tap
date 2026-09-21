class_name BloopieTarget
extends Area2D

signal resolved(target, kind, character_id)
var kind := "bloopie"
var character_id := ""
var resolved_once := false
var lifetime := 0.9
var point_index := -1
var generation := 0

func setup(new_kind: String, data: Dictionary, duration: float, index: int) -> void:
	kind = new_kind
	point_index = index
	lifetime = duration
	resolved_once = false
	generation += 1
	var this_generation := generation
	monitoring = true
	visible = true
	scale = Vector2(0.15, 0.15)
	$Label.visible = new_kind != "bloopie"
	$Sprite.visible = new_kind == "bloopie"
	if new_kind == "bloopie":
		character_id = data.id
		$Sprite.texture = load(data.sprite)
	else:
		character_id = ""
		$Label.text = {"trap":"🥥", "crab":"🦀", "barrel":"🛢️", "fruit":"🍍", "treasure":"🧰"}.get(new_kind, "🍍")
	var pop := create_tween()
	pop.tween_property(self, "scale", Vector2.ONE, 0.18).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	get_tree().create_timer(duration).timeout.connect(func():
		if generation == this_generation: _expire()
	)

func _input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if (event is InputEventScreenTouch and event.pressed) or (event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT):
		resolve_tap()
		get_viewport().set_input_as_handled()

func resolve_tap() -> void:
	if resolved_once: return
	resolved_once = true
	monitoring = false
	var tween := create_tween()
	tween.tween_property(self, "scale", Vector2(1.25, 0.72), 0.08)
	tween.tween_property(self, "scale", Vector2.ZERO, 0.16).set_trans(Tween.TRANS_BACK)
	tween.finished.connect(func(): resolved.emit(self, kind, character_id))

func _expire() -> void:
	if resolved_once or not visible: return
	resolved_once = true
	monitoring = false
	var old_kind := kind
	var old_id := character_id
	var tween := create_tween()
	tween.tween_property(self, "scale", Vector2.ZERO, 0.16)
	tween.finished.connect(func(): resolved.emit(self, "miss" if old_kind == "bloopie" else "ignored", old_id))

func deactivate() -> void:
	visible = false
	monitoring = false
	resolved_once = true
