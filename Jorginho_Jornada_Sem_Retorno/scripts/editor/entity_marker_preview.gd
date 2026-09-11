@tool
extends Marker2D

## Prévia somente do editor para os pontos de nascimento das fases.
## O jogo continua criando os personagens pelo main.gd; nada é duplicado em execução.

const PREVIEW_NAME := "__PreviaDoPersonagem"
const LABEL_NAME := "__NomeDaPrevia"


func _enter_tree() -> void:
	if Engine.is_editor_hint():
		call_deferred("_refresh_preview")


func _refresh_preview() -> void:
	if not Engine.is_editor_hint() or not is_inside_tree():
		return
	_remove_old_preview()

	var kind := _preview_kind()
	var settings := _settings_for(kind)
	if settings.is_empty():
		return

	var sprite := Sprite2D.new()
	sprite.name = PREVIEW_NAME
	sprite.texture = load(String(settings.path)) as Texture2D
	if sprite.texture == null:
		return
	sprite.region_enabled = true
	sprite.region_rect = Rect2(0, 0, float(settings.frame_width), float(settings.frame_height))
	sprite.scale = settings.scale
	sprite.position = settings.offset
	sprite.flip_h = bool(settings.get("flip_h", false))
	sprite.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	sprite.modulate = Color(1.0, 1.0, 1.0, 0.88)
	sprite.z_index = 50
	sprite.show_behind_parent = false
	add_child(sprite)

	var label := Label.new()
	label.name = LABEL_NAME
	label.text = "Jorginho" if kind == "jorginho" else kind.replace("_boss", " (chefe)").capitalize()
	var sprite_top: float=sprite.position.y-float(settings.frame_height)*sprite.scale.y*0.5
	label.position = Vector2(-72, sprite_top-26.0)
	label.size = Vector2(144, 24)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", 13)
	label.add_theme_color_override("font_color", Color("#fff1b0"))
	label.add_theme_color_override("font_outline_color", Color("#17201d"))
	label.add_theme_constant_override("outline_size", 4)
	label.z_index = 51
	add_child(label)


func _remove_old_preview() -> void:
	for child_name in [PREVIEW_NAME, LABEL_NAME]:
		var child := get_node_or_null(NodePath(child_name))
		if child != null:
			child.free()


func _preview_kind() -> String:
	if name == "INICIO_JORGINHO":
		return "jorginho"
	return String(get_meta("tipo", ""))


func _settings_for(kind: String) -> Dictionary:
	match kind:
		"jorginho":
			return _settings("res://assets/hero/jorginho/jorginho_idle.png", 256, 256, Vector2(0.28, 0.28), Vector2(0, -1))
		"mushroom":
			return _settings("res://assets/enemies/mushroom.png", 80, 64, Vector2(1.35, 1.35), Vector2(0, -21))
		"flying":
			return _settings("res://assets/enemies/flying.png", 64, 64, Vector2(1.10, 1.10), Vector2(0, -1), true)
		"bramble":
			return _settings("res://assets/selected/enemies/bramble/Idle.png", 96, 96, Vector2(0.95, 0.95), Vector2(0, -19.6), true)
		"sentinel":
			return _settings("res://assets/selected/enemies/sentinel/Idle.png", 96, 96, Vector2(1.20, 1.20), Vector2(0, -31.6), true)
		"skeleton":
			return _settings("res://assets/selected/biomes/trapmoor/animations/skeleton_idle.png", 32, 24, Vector2(2.0, 2.0), Vector2(0, 2), true)
		"spore":
			return _settings("res://assets/selected/biomes/trapmoor/animations/spore_idle.png", 16, 16, Vector2(2.5, 2.5), Vector2(0, -3))
		"badger_boss":
			return _settings("res://assets/selected/bosses/badger/badger_idle.png", 128, 128, Vector2(1.28, 1.28), Vector2(0, -41.92))
		"cat_boss":
			return _settings("res://assets/selected/bosses/cat/cat_idle.png", 128, 128, Vector2(1.32, 1.32), Vector2(0, -44.48))
		"pengu_boss":
			return _settings("res://assets/selected/bosses/pengu/pengu_idle.png", 128, 128, Vector2(1.42, 1.42), Vector2(0, -50.88))
	return {}


func _settings(path: String, frame_width: int, frame_height: int, preview_scale: Vector2, offset: Vector2, flip_h := false) -> Dictionary:
	return {
		"path": path,
		"frame_width": frame_width,
		"frame_height": frame_height,
		"scale": preview_scale,
		"offset": offset,
		"flip_h": flip_h,
	}
