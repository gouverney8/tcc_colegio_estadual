class_name EditableTextureButton
extends TextureButton

@export_category("Texto editável")
@export var caption := "BOTÃO":
	set(value):
		caption = value
		_update_caption()
@export var caption_color := Color("#ffe39a")
@export var caption_hover_color := Color("#fff8d2")
@export var caption_disabled_color := Color("#aaa28d")
@export_range(8, 72, 1) var caption_size := 25
@export_range(0, 8, 1) var outline_size := 3
@export_range(0, 80, 1) var caption_horizontal_padding := 22
@export var caption_offset := Vector2.ZERO
@export_category("Resposta visual sem deformação")
@export var normal_tint := Color.WHITE
@export var hover_tint := Color(1.08,1.04,0.88,1.0)
@export var pressed_tint := Color(0.84,0.78,0.68,1.0)
@export var disabled_tint := Color(0.58,0.58,0.58,1.0)
@export_category("Área de clique")
@export var use_texture_alpha_as_click_mask := true

@onready var caption_label: Label = get_node_or_null("Caption") as Label
var _last_visual_state := -1

func _ready() -> void:
	_update_caption()
	_update_click_mask()
	_update_visual_state(true)

func _process(_delta: float) -> void:
	_update_visual_state()

func _update_caption() -> void:
	if not is_node_ready():
		return
	caption_label = get_node_or_null("Caption") as Label
	if caption_label == null:
		return
	caption_label.text = caption
	caption_label.offset_left = caption_horizontal_padding + caption_offset.x
	caption_label.offset_top = caption_offset.y
	caption_label.offset_right = -caption_horizontal_padding + caption_offset.x
	caption_label.offset_bottom = caption_offset.y
	caption_label.clip_text = true
	caption_label.add_theme_font_size_override("font_size",caption_size)
	caption_label.add_theme_constant_override("outline_size",outline_size)
	caption_label.add_theme_color_override("font_outline_color",Color(0.12,0.055,0.018,0.95))

func _update_visual_state(force := false) -> void:
	if caption_label == null:
		return
	var visual_state := 0
	if disabled:
		visual_state = 2
	elif button_pressed:
		visual_state = 3
	elif is_hovered() or has_focus():
		visual_state = 1
	if not force and visual_state == _last_visual_state:
		return
	_last_visual_state = visual_state
	self_modulate = disabled_tint if visual_state == 2 else pressed_tint if visual_state == 3 else hover_tint if visual_state == 1 else normal_tint
	caption_label.add_theme_color_override("font_color",
		caption_disabled_color if visual_state == 2 else caption_hover_color if visual_state == 1 else caption_color)

func _update_click_mask() -> void:
	if not use_texture_alpha_as_click_mask or texture_normal == null:
		texture_click_mask=null
		return
	var source_image := texture_normal.get_image()
	if source_image == null or source_image.is_empty():
		return
	var alpha_mask := BitMap.new()
	alpha_mask.create_from_image_alpha(source_image,0.12)
	texture_click_mask=alpha_mask
