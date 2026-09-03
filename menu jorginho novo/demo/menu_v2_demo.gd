extends Control

@onready var new_game_button: Button = $MenuPanel/Content/NewGameButton


func _ready() -> void:
	new_game_button.grab_focus()


func _on_new_game_pressed() -> void:
	print("Substitua por: get_tree().change_scene_to_file(\"res://sua_fase.tscn\")")


func _on_continue_pressed() -> void:
	print("Carregue o save do jogador aqui.")


func _on_settings_pressed() -> void:
	print("Abra a cena de configurações aqui.")


func _on_credits_pressed() -> void:
	print("Abra a cena de créditos aqui.")


func _on_exit_pressed() -> void:
	get_tree().quit()

