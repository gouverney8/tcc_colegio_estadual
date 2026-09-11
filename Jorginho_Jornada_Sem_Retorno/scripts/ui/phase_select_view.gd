extends Control

signal back_requested
signal stage_requested(index: int)
signal ui_hovered
signal ui_accepted

const CARD_ROOT := "res://assets/ui/menu_v2/cards/"
const CARD_FOLDERS := [
	"fase_1_vale_das_aguas",
	"chefe_1_templo_da_selva",
	"fase_2_trilhos_do_entardecer",
	"chefe_2_forja_ferroviaria",
	"fase_3_ruinas_ao_luar",
	"chefe_3_altar_de_gelo"
]
const TITLES := [
	"FASE 1  •  VALE DAS ÁGUAS",
	"CHEFE 1  •  TEMPLO DA SELVA",
	"FASE 2  •  TRILHOS DO ENTARDECER",
	"CHEFE 2  •  FORJA FERROVIÁRIA",
	"FASE 3  •  RUÍNAS AO LUAR",
	"CHEFE 3  •  ALTAR DE GELO"
]
const DESCRIPTIONS := [
	"A jornada começa entre rios, mata e ruínas esquecidas.",
	"O guardião das raízes protege o primeiro limiar.",
	"Trilhos, fornalhas e sentinelas dominam o entardecer.",
	"A forja transforma distância e pressão em armas.",
	"O luar revela caminhos congelados e antigas ruínas.",
	"No altar de gelo, o último guardião encerra a travessia."
]

@onready var title_label: Label = %SelectedTitle
@onready var description_label: Label = %SelectedDescription
@onready var play_button: TextureButton = %PlayButton
var _cards: Array[TextureButton] = []
var _selected_index := 0
var _highest_unlocked := 0
var _highest_completed := -1

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	for index in CARD_FOLDERS.size():
		var card := get_node("Cards/Card%d" % index) as TextureButton
		_cards.append(card)
		card.focus_entered.connect(_select_card.bind(index))
		card.mouse_entered.connect(_select_card.bind(index))
		card.pressed.connect(_select_card.bind(index))
	%BackButton.pressed.connect(_back)
	play_button.pressed.connect(_play)

func configure(highest_unlocked: int, current_level: int, highest_completed: int = -1) -> void:
	_highest_unlocked = clampi(highest_unlocked,0,CARD_FOLDERS.size()-1)
	_highest_completed = clampi(highest_completed,-1,CARD_FOLDERS.size()-1)
	for index in _cards.size():
		var card := _cards[index]
		var folder: String = CARD_ROOT + String(CARD_FOLDERS[index]) + "/"
		var textures := _load_normalized_card_states(folder)
		card.disabled = index > _highest_unlocked
		card.texture_disabled = textures["bloqueado"]
		card.texture_normal = textures["concluido"] if index <= _highest_completed else textures["normal"]
		card.texture_hover = textures["selecionado"]
		card.texture_focused = textures["selecionado"]
		card.texture_pressed = textures["selecionado"]
		card.mouse_default_cursor_shape = Control.CURSOR_FORBIDDEN if card.disabled else Control.CURSOR_POINTING_HAND
	_selected_index = clampi(current_level,0,_highest_unlocked)
	call_deferred("_focus_selected")
	_update_description()

func _load_normalized_card_states(folder: String) -> Dictionary:
	var loaded := {}
	var canvas_size := Vector2.ZERO
	for state_name in ["bloqueado", "concluido", "normal", "selecionado"]:
		var texture := load(folder + state_name + ".png") as Texture2D
		assert(texture != null, "Asset ausente no cartão: " + folder + state_name + ".png")
		loaded[state_name] = texture
		canvas_size.x = maxf(canvas_size.x, texture.get_width())
		canvas_size.y = maxf(canvas_size.y, texture.get_height())
	for state_name in loaded:
		loaded[state_name] = _texture_with_fixed_canvas(loaded[state_name] as Texture2D, canvas_size)
	return loaded

func _texture_with_fixed_canvas(texture: Texture2D, canvas_size: Vector2) -> Texture2D:
	if texture.get_size() == canvas_size:
		return texture
	var difference := canvas_size - texture.get_size()
	var padded := AtlasTexture.new()
	padded.atlas = texture
	padded.region = Rect2(Vector2.ZERO, texture.get_size())
	padded.margin = Rect2(difference * 0.5, difference)
	return padded

func _focus_selected() -> void:
	_cards[_selected_index].grab_focus()

func _select_card(index: int) -> void:
	if index < 0 or index >= _cards.size() or _cards[index].disabled:
		return
	_selected_index = index
	_update_description()
	ui_hovered.emit()

func _update_description() -> void:
	title_label.text = TITLES[_selected_index]
	description_label.text = DESCRIPTIONS[_selected_index]
	play_button.disabled = _selected_index > _highest_unlocked

func _back() -> void:
	ui_accepted.emit()
	back_requested.emit()

func _play() -> void:
	if _selected_index > _highest_unlocked:
		return
	ui_accepted.emit()
	stage_requested.emit(_selected_index)
