extends Control

const ROUND_TIME := 30.0
var time_left := ROUND_TIME
var score := 0
var lives := 3
var level := 1
var ended := false
var spawn_clock := 0.0
var fever_time := 0.0
var slow_time := 0.0
var combo := ComboManager.new()
var difficulty := DifficultyManager.new()
var ui: UIManager

func _ready() -> void:
	theme = ThemeFactory.make_theme()
	randomize()
	level = int(get_tree().get_meta("selected_level", 1))
	$Background.texture = load("res://assets/backgrounds/level%d.svg" % level)
	$SpawnManager.initialize($SpawnPoints)
	$SpawnManager.target_resolved.connect(_target_resolved)
	$Pause.pressed.connect(_toggle_pause)
	ui = UIManager.new(self)
	ui.update(score, combo.combo, lives, time_left)
	_show_banner(["TROPICAL BEACH", "BLOOPIES ISLAND", "FLOATING HOUSE • ART PLACEHOLDER"][level - 1])

func _process(delta: float) -> void:
	if ended or get_tree().paused: return
	var speed := 0.72 if slow_time > 0.0 else 1.0
	time_left -= delta * speed
	spawn_clock -= delta
	fever_time = max(0.0, fever_time - delta)
	slow_time = max(0.0, slow_time - delta)
	$FeverOverlay.visible = fever_time > 0.0
	$SpawnManager.no_traps = fever_time > 0.0
	if spawn_clock <= 0.0:
		var cfg := difficulty.settings(ROUND_TIME - time_left)
		if fever_time > 0.0: cfg.max_targets = 3
		$SpawnManager.spawn_wave(cfg)
		spawn_clock = float(cfg.interval)
	ui.update(score, combo.combo, lives, time_left)
	if time_left <= 0.0 or lives <= 0: _finish()

func _target_resolved(kind: String, id: String) -> void:
	if ended: return
	match kind:
		"bloopie":
			var state := combo.success(id)
			var multiplier := 3 if fever_time > 0.0 else (2 if state.double else 1)
			score += multiplier
			AudioManager.play_character(id)
			_burst(CharacterDatabase.get_character(id).color)
			if state.super: _show_banner("SUPER COMBO!")
			if state.fever and fever_time <= 0.0:
				fever_time = 4.0
				AudioManager.set_fever(true)
				_show_banner("BLOOPIES FEVER!  x3")
			if not String(state.special).is_empty(): _special(id, state.special)
		"miss":
			combo.miss()
		"trap", "crab", "barrel":
			lives -= 1
			combo.miss()
			_show_banner("OOPS! Silly trap!")
			_burst("#a6e86d")
		"fruit":
			score += 2
			_show_banner("JUICY BONUS +2")
			_burst("#ffe35a")
		"treasure":
			score += 5
			_show_banner("TREASURE +5")
	ui.update(score, combo.combo, lives, time_left)

func _special(id: String, title: String) -> void:
	score += 3
	_show_banner(title + "  +3")
	match id:
		"zipp": slow_time = 3.0
		"glop":
			for i in range(2): $SpawnManager.spawn_wave({"max_targets":3,"duration":1.2,"trap_chance":0.0,"bonus_chance":1.0}, "fruit")
		"krak": $SpawnManager.spawn_wave({"max_targets":3,"duration":1.4,"trap_chance":0.0,"bonus_chance":1.0}, "treasure")
		"nano":
			$SpawnManager.highlight_next_target()
			_show_banner("DRONE SCAN • NEXT TARGET HIGHLIGHTED!")
		_: _burst(CharacterDatabase.get_character(id).color, 18)

func _burst(color_hex: String, amount := 10) -> void:
	for i in range(amount):
		var dot := ColorRect.new()
		dot.color = Color(color_hex)
		dot.size = Vector2(12, 12)
		dot.position = Vector2(randf_range(120, 600), randf_range(300, 900))
		dot.rotation = randf() * TAU
		$Effects.add_child(dot)
		var tween := create_tween()
		tween.tween_property(dot, "position", dot.position + Vector2(randf_range(-70,70), randf_range(-120,20)), 0.5)
		tween.parallel().tween_property(dot, "modulate:a", 0.0, 0.5)
		tween.finished.connect(dot.queue_free)

func _show_banner(text_value: String) -> void:
	$Banner.text = text_value
	$Banner.modulate.a = 1.0
	$Banner.scale = Vector2(0.6, 0.6)
	var tween := create_tween()
	tween.tween_property($Banner, "scale", Vector2.ONE, 0.18).set_trans(Tween.TRANS_BACK)
	tween.tween_interval(0.7)
	tween.tween_property($Banner, "modulate:a", 0.0, 0.25)

func _toggle_pause() -> void:
	get_tree().paused = not get_tree().paused
	$Pause.text = "▶" if get_tree().paused else "Ⅱ"

func _finish() -> void:
	ended = true
	AudioManager.set_fever(false)
	$SpawnManager.clear_all()
	var stars := 1 if score < 15 else (2 if score < 28 else 3)
	SaveManager.finish_round(score, combo.max_combo, stars)
	get_tree().set_meta("last_result", {"score":score, "max_combo":combo.max_combo, "stars":stars, "level":level})
	get_tree().change_scene_to_file("res://scenes/result_screen.tscn")
