class_name ThemeFactory
extends RefCounted

static func make_theme() -> Theme:
	var theme := Theme.new()
	var font := SystemFont.new()
	font.font_names = PackedStringArray(["Arial Rounded MT Bold", "Noto Sans", "sans-serif"])
	theme.default_font = font
	theme.default_font_size = 28
	for type in ["Button", "Label"]:
		theme.set_font("font", type, font)
	var normal := StyleBoxFlat.new()
	normal.bg_color = Color("#ff9f1c")
	normal.corner_radius_top_left = 28
	normal.corner_radius_top_right = 28
	normal.corner_radius_bottom_left = 28
	normal.corner_radius_bottom_right = 28
	normal.border_width_left = 5
	normal.border_width_top = 5
	normal.border_width_right = 5
	normal.border_width_bottom = 5
	normal.border_color = Color("#fff3c4")
	normal.shadow_color = Color(0.05, 0.18, 0.25, 0.35)
	normal.shadow_size = 8
	var hover := normal.duplicate()
	hover.bg_color = Color("#ffbd3d")
	var pressed := normal.duplicate()
	pressed.bg_color = Color("#e87816")
	theme.set_stylebox("normal", "Button", normal)
	theme.set_stylebox("hover", "Button", hover)
	theme.set_stylebox("pressed", "Button", pressed)
	theme.set_color("font_color", "Button", Color.WHITE)
	theme.set_color("font_shadow_color", "Button", Color("#743900"))
	theme.set_constant("shadow_offset_x", "Button", 2)
	theme.set_constant("shadow_offset_y", "Button", 3)
	return theme

