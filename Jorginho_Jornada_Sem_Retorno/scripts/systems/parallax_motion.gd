extends Node2D

@export_category("Movimento")
@export var velocity := Vector2.ZERO
@export var wrap_horizontal := false
@export var wrap_left := -400.0
@export var wrap_right := 1800.0
@export var wrap_vertical := false
@export var wrap_top := -200.0
@export var wrap_bottom := 800.0

@export_category("Flutuacao")
@export var bob_amount := 0.0
@export var bob_speed := 1.0
@export var pulse_alpha := 0.0
@export var pulse_speed := 1.0

var _drift_position := Vector2.ZERO
var _elapsed := 0.0


func _ready() -> void:
	_drift_position = position


func _process(delta: float) -> void:
	_elapsed += delta
	_drift_position += velocity * delta
	if wrap_horizontal:
		if velocity.x < 0.0 and _drift_position.x < wrap_left:
			_drift_position.x = wrap_right
		elif velocity.x > 0.0 and _drift_position.x > wrap_right:
			_drift_position.x = wrap_left
	if wrap_vertical:
		if velocity.y < 0.0 and _drift_position.y < wrap_top:
			_drift_position.y = wrap_bottom
		elif velocity.y > 0.0 and _drift_position.y > wrap_bottom:
			_drift_position.y = wrap_top
	position = _drift_position + Vector2(0.0,sin(_elapsed * bob_speed) * bob_amount)
	if pulse_alpha > 0.0:
		modulate.a = clampf(1.0 - pulse_alpha * (0.5 + 0.5 * sin(_elapsed * pulse_speed)),0.08,1.0)
