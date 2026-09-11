class_name WorldTutorialSpeech
extends Node2D

@export_category("Fala de tutorial")
@export_multiline var preview_text := "Mensagem de tutorial"
@export_range(1.0,10.0,0.1) var display_duration := 4.0
@export_range(0.1,1.0,0.05) var entrance_duration := 0.22
@export_range(0.1,1.0,0.05) var exit_duration := 0.28
@export_range(0.4,1.2,0.05) var display_scale := 1.0

@onready var speech_label: Label = %SpeechLabel

func _ready() -> void:
	speech_label.text=preview_text

func configure(message: String, duration: float) -> void:
	preview_text=message
	display_duration=duration
	if is_node_ready(): speech_label.text=message
	play()

func play() -> void:
	modulate.a=0.0
	scale=Vector2.ONE*display_scale
	var resting_position:=position
	position.y+=7.0
	var presentation:=create_tween().bind_node(self)
	presentation.set_parallel(true)
	presentation.tween_property(self,"modulate:a",1.0,entrance_duration).set_trans(Tween.TRANS_SINE)
	presentation.tween_property(self,"position",resting_position,entrance_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	presentation.set_parallel(false)
	presentation.tween_interval(display_duration)
	presentation.tween_property(self,"modulate:a",0.0,exit_duration)
	presentation.tween_callback(queue_free)
