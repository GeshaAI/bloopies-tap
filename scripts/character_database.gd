extends Node

const CHARACTERS := {
	"bubo": {"id":"bubo", "display_name":"BUBO", "sprite":"res://assets/characters/bubo.svg", "tap_animation":"ear_flap", "tap_sound":"bubo_tap", "special_combo":"EAR FLAP BONUS", "particle_effect":"stars", "color":"#ffc43d"},
	"luna": {"id":"luna", "display_name":"LUNA", "sprite":"res://assets/characters/luna.svg", "tap_animation":"flower_shower", "tap_sound":"luna_tap", "special_combo":"FLOWER SHOWER", "particle_effect":"petals", "color":"#ff73b5"},
	"zipp": {"id":"zipp", "display_name":"ZIPP", "sprite":"res://assets/characters/zipp.svg", "tap_animation":"inventor_boost", "tap_sound":"zipp_tap", "special_combo":"INVENTOR BOOST", "particle_effect":"gears", "color":"#39bcec"},
	"glop": {"id":"glop", "display_name":"GLOP", "sprite":"res://assets/characters/glop.svg", "tap_animation":"fruit_catch", "tap_sound":"glop_tap", "special_combo":"FRUIT FRENZY", "particle_effect":"fruit", "color":"#7ed957"},
	"krak": {"id":"krak", "display_name":"KRAK", "sprite":"res://assets/characters/krak.svg", "tap_animation":"hat_grab", "tap_sound":"krak_tap", "special_combo":"PIRATE TREASURE", "particle_effect":"coins", "color":"#ff7b32"},
	"nano": {"id":"nano", "display_name":"NANO", "sprite":"res://assets/characters/nano.svg", "tap_animation":"drone_circle", "tap_sound":"nano_tap", "special_combo":"DRONE SCAN", "particle_effect":"pixels", "color":"#a970ff"}
}

func get_character(id: String) -> Dictionary:
	return CHARACTERS.get(id, CHARACTERS.bubo)

func random_character() -> Dictionary:
	var keys := CHARACTERS.keys()
	return CHARACTERS[keys[randi() % keys.size()]]

