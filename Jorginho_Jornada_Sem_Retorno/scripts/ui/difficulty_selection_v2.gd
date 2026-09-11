class_name DifficultySelectionV2
extends Control

signal difficulty_chosen(index: int)
signal canceled

const BUTTON_NORMAL: Texture2D = preload("res://assets/ui/componentes/botoes_madeira/estados/normal.png")

@export_category("Textos exibidos ao selecionar")
@export_multiline var detail_texts := PackedStringArray([
	"Dano menor  •  parry generoso  •  mais recursos",
	"Experiência recomendada  •  regras equilibradas",
	"Ataques rápidos  •  parry curto  •  pouca cura",
	"Dano extremo  •  ritmo implacável  •  raríssima cura"
])
@export_category("Aparência dos cartões")
@export var inactive_card_color := Color(0.78,0.82,0.79,0.94)
@export var selected_card_color := Color.WHITE

var selected_index := 1
var option_buttons: Array[TextureButton] = []
@onready var preview_label: Label = %DifficultyPreview
@onready var confirm_button: TextureButton = %ConfirmButton
@onready var back_button: TextureButton = %BackButton

func _ready() -> void:
	option_buttons=[%DifficultyCard0,%DifficultyCard1,%DifficultyCard2,%DifficultyCard3]
	var group:=ButtonGroup.new()
	for index in option_buttons.size():
		var card:=option_buttons[index]
		card.button_group=group
		card.texture_click_mask=_make_click_mask(BUTTON_NORMAL)
		card.pressed.connect(_select_option.bind(index))
		_bind_button_audio(card)
	back_button.texture_click_mask=_make_click_mask(BUTTON_NORMAL)
	confirm_button.texture_click_mask=_make_click_mask(BUTTON_NORMAL)
	_bind_button_audio(back_button)
	_bind_button_audio(confirm_button)
	back_button.pressed.connect(func(): canceled.emit())
	confirm_button.pressed.connect(func(): difficulty_chosen.emit(selected_index))
	_configure_focus_navigation()
	set_selected(selected_index)
	call_deferred("_focus_selected")

func set_selected(index: int) -> void:
	selected_index=clampi(index,0,option_buttons.size()-1 if not option_buttons.is_empty() else 3)
	if option_buttons.is_empty(): return
	for i in option_buttons.size():
		var button:=option_buttons[i]
		button.button_pressed=i==selected_index
		button.modulate=selected_card_color if i==selected_index else inactive_card_color
		var marker:=button.get_node_or_null("SelectedMarker") as Label
		if marker: marker.visible=i==selected_index
	if is_instance_valid(preview_label) and selected_index<detail_texts.size():
		preview_label.text=detail_texts[selected_index]

func _select_option(index: int) -> void:
	set_selected(index)

func _focus_selected() -> void:
	if selected_index<option_buttons.size(): option_buttons[selected_index].grab_focus()

func _configure_focus_navigation() -> void:
	for index in option_buttons.size():
		var column:=index%2
		var row:=index/2
		var horizontal_index:=row*2+(1-column)
		var vertical_index:=(1-row)*2+column
		option_buttons[index].focus_neighbor_left=option_buttons[horizontal_index].get_path()
		option_buttons[index].focus_neighbor_right=option_buttons[horizontal_index].get_path()
		option_buttons[index].focus_neighbor_top=option_buttons[vertical_index].get_path()
		option_buttons[index].focus_neighbor_bottom=option_buttons[vertical_index].get_path()
	option_buttons[2].focus_neighbor_bottom=back_button.get_path()
	option_buttons[3].focus_neighbor_bottom=confirm_button.get_path()
	back_button.focus_neighbor_top=option_buttons[2].get_path()
	back_button.focus_neighbor_right=confirm_button.get_path()
	confirm_button.focus_neighbor_top=option_buttons[3].get_path()
	confirm_button.focus_neighbor_left=back_button.get_path()

func _make_click_mask(texture: Texture2D) -> BitMap:
	var bitmap:=BitMap.new()
	var image:=texture.get_image()
	if image and not image.is_empty(): bitmap.create_from_image_alpha(image,0.12)
	return bitmap

func _bind_button_audio(button: BaseButton) -> void:
	button.mouse_entered.connect(func():
		button.self_modulate=Color(1.08,1.04,0.88,1.0)
		AudioManager.play_sfx("kenney/ui_hover.ogg",-20.0,1.02)
	)
	button.mouse_exited.connect(func(): button.self_modulate=Color.WHITE)
	button.button_down.connect(func(): button.self_modulate=Color(0.84,0.78,0.68,1.0))
	button.button_up.connect(func(): button.self_modulate=Color(1.08,1.04,0.88,1.0) if button.is_hovered() else Color.WHITE)
	button.focus_entered.connect(func(): AudioManager.play_sfx("kenney/ui_hover.ogg",-20.0,1.02))
	button.pressed.connect(func(): AudioManager.play_sfx("kenney/ui_confirm.ogg",-14.0,1.0))
