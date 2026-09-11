extends Control

signal play_requested
signal continue_requested
signal phase_select_requested
signal settings_requested
signal credits_requested
signal quit_requested
signal ui_hovered
signal ui_accepted

@export_category("Movimento ambiente")
@export_range(0.0, 8.0, 0.1) var logo_float_height := 2.5
@export_range(0.1, 4.0, 0.1) var logo_float_speed := 0.65
@export_range(0.0, 16.0, 0.5) var ornament_float_height := 5.0
@export_range(0.1, 4.0, 0.1) var ornament_float_speed := 0.55

@onready var hero: AnimatedSprite2D = %Hero
@onready var logo: TextureRect = %Logo
@onready var selector: Sprite2D = %Selector
@onready var continue_button: TextureButton = %ContinueButton

var _elapsed := 0.0
var _logo_base_y := 0.0
var _ornament_origins: Dictionary = {}
var _buttons: Array[TextureButton] = []

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_logo_base_y = logo.position.y
	_buttons = [
		%PlayButton,
		continue_button,
		%PhaseSelectButton,
		%SettingsButton,
		%CreditsButton,
		%QuitButton
	]
	for ornament in %AnimatedOrnaments.get_children():
		_ornament_origins[ornament] = ornament.position
	for button in _buttons:
		button.mouse_entered.connect(_focus_button.bind(button))
		button.focus_entered.connect(_focus_button.bind(button))
	%PlayButton.pressed.connect(_accept.bind(play_requested))
	continue_button.pressed.connect(_accept.bind(continue_requested))
	%PhaseSelectButton.pressed.connect(_accept.bind(phase_select_requested))
	%SettingsButton.pressed.connect(_accept.bind(settings_requested))
	%CreditsButton.pressed.connect(_accept.bind(credits_requested))
	%QuitButton.pressed.connect(_accept.bind(quit_requested))
	call_deferred("focus_first_available")

func configure(can_continue: bool) -> void:
	continue_button.disabled = not can_continue
	continue_button.mouse_default_cursor_shape = Control.CURSOR_FORBIDDEN if continue_button.disabled else Control.CURSOR_POINTING_HAND

func focus_first_available() -> void:
	for button in _buttons:
		if not button.disabled:
			button.grab_focus()
			return

func _focus_button(button: TextureButton) -> void:
	if button.disabled:
		return
	selector.visible = true
	selector.position.y = button.position.y + button.size.y * 0.5
	ui_hovered.emit()

func _accept(requested_signal: Signal) -> void:
	ui_accepted.emit()
	requested_signal.emit()

func _process(delta: float) -> void:
	_elapsed += delta
	logo.position.y = _logo_base_y + sin(_elapsed * logo_float_speed) * logo_float_height
	var index := 0
	for ornament_variant in _ornament_origins:
		var ornament := ornament_variant as Node2D
		if is_instance_valid(ornament):
			var origin: Vector2 = _ornament_origins[ornament]
			ornament.position = origin + Vector2(
				sin(_elapsed * ornament_float_speed + float(index) * 1.7) * 2.0,
				cos(_elapsed * ornament_float_speed * 0.8 + float(index)) * ornament_float_height
			)
		index += 1
	# Os recortes têm alturas diferentes. O offset ancora cada frame pelos pés
	# e elimina o efeito de crescer, encolher ou deslizar durante o idle.
	if is_instance_valid(hero) and hero.sprite_frames:
		var frame_texture := hero.sprite_frames.get_frame_texture(hero.animation,hero.frame)
		if frame_texture:
			hero.offset = Vector2(0.0,-float(frame_texture.get_height()) * 0.5)
