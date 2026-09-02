extends Node2D

# =========================
# AJUSTES PARA O INSPECTOR
# =========================
# Valores principais usados na demonstração do projeto.
@export_category("Player")
@export var player_max_health := 5
@export var player_move_speed := 310.0
@export var player_jump_force := 720.0
@export var player_attack_damage := 1
@export_category("Boss")
@export var boss_max_health := 24
@export var boss_phase_two_ratio := 0.5

const VIEW := Vector2(1152, 648)
const GRAVITY := 1900.0
const SPEED := 310.0
const JUMP_SPEED := -720.0
const DASH_SPEED := 780.0
const DASH_DURATION := 0.16
const DASH_COOLDOWN := 0.85
const SAVE_PATH := "user://journey.save"
const SETTINGS_PATH := "user://settings.cfg"
const RECORDS_PATH := "user://records.cfg"
const SAVE_VERSION := 2
const HEART_TEXTURE := "res://assets/selected/ui_crimson/heart_full.png"
const HEART_FULL: Texture2D = preload("res://assets/selected/ui_crimson/heart_full.png")
const HEART_EMPTY: Texture2D = preload("res://assets/selected/ui_crimson/heart_empty.png")
const PORTAL_SHEET: Texture2D = preload("res://assets/selected/portal/dimensional_portal.png")
const PORTAL_FRAME_INACTIVE: Texture2D = preload("res://assets/selected/portal/inactive.png")
const PORTAL_FRAGMENT: Texture2D = preload("res://assets/selected/collectible/portal_fragment.png")
const DISPLAY_FONT: Font = preload("res://assets/selected/fonts/display.ttf")
const UI_LOGO: Texture2D = preload("res://assets/selected/ui/logo.png")
const UI_BUTTON: Texture2D = preload("res://assets/selected/ui/button.png")
const UI_PANEL: Texture2D = preload("res://assets/selected/ui/panel.png")
const UI_CURSOR: Texture2D = preload("res://assets/selected/ui/cursor.png")
const ILLUSION_PATH := "res://assets/selected/biomes/illusion/"
const TRAPMOOR_PATH := "res://assets/selected/biomes/trapmoor/"
const FOUR_SEASONS_PATH := "res://assets/selected/biomes/four_seasons/"
const HERO_SWORDSMAN_PATH := "res://assets/hero/swordsman/"
const KENNEY_INDUSTRIAL_PATH := "res://assets/selected/props/kenney_industrial/"
const GUARDIAN_PATH := "res://assets/selected/enemies/"
const TRANSITION_SHADER: Shader = preload("res://scripts/shaders/transition.gdshader")
const LIFE_DROP_CHANCE := 0.28
const BASE_RESOLUTION := Vector2i(1152,648)
const DISPLAY_RESOLUTIONS: Array[Vector2i] = [Vector2i(1152,648),Vector2i(1280,720),Vector2i(1600,900),Vector2i(1920,1080),Vector2i(2560,1440)]
const VISUAL_SCALES: Array[float] = [0.85,1.0,1.15,1.30]
const FX_SHIELD: Texture2D = preload("res://assets/selected/fx/shield_parry.png")
const FX_IMPACT: Texture2D = preload("res://assets/selected/fx/impact_burst.png")
const FX_PROJECTILE: Texture2D = preload("res://assets/selected/fx/spirit_flame.png")
const FX_ARC: Texture2D = preload("res://assets/selected/fx/arc_wave.png")
const BOSS_PATH := "res://assets/selected/bosses/"
const PENGU_FX_ICE: Texture2D = preload("res://assets/selected/bosses/pengu/pengu_fx_ice.png")
const PENGU_FX_FREEZE: Texture2D = preload("res://assets/selected/bosses/pengu/pengu_fx_freeze.png")
const CUTSCENE_CALM: Texture2D = preload("res://assets/selected/cutscene/origin_calm_v16.png")
const CUTSCENE_RUPTURE: Texture2D = preload("res://assets/selected/cutscene/origin_rupture_v16.png")
const CUTSCENE_STAGE: Texture2D = preload("res://assets/selected/cutscene/origin_stage_v20.png")
const LEVEL_SCENES := [
	"res://scenes/levels/fase_01_floresta_da_ilusao.tscn",
	"res://scenes/levels/fase_02_covil_das_raizes.tscn",
	"res://scenes/levels/fase_03_forja_de_trapmoor.tscn",
	"res://scenes/levels/fase_04_arsenal_do_gato.tscn",
	"res://scenes/levels/fase_05_abismo_congelado.tscn",
	"res://scenes/levels/fase_06_trono_do_inverno.tscn"
]
const PARRY_WINDOW := 0.18
const BLOCK_DAMAGE_RATIO := 0.35
const GAMEPAD_LABELS := {"move_left":"ANALÓGICO / ◀","move_right":"ANALÓGICO / ▶","jump":"A","attack":"X","guard":"LB","dash":"B","pause":"START"}
const EVENT_SFX := {
	"parry_cue":"kenney/ui_toggle.ogg",
	"posture_break":"kenney/impact_metal_heavy.ogg",
	"wall_impact":"kenney/impact_heavy.ogg",
	"badger_tremor":"kenney/impact_heavy.ogg",
	"grenade_throw":"kenney/impact_metal_light.ogg",
	"gun_shot":"kenney/impact_metal_light.ogg"
}
const DIFFICULTIES := [
	{"id":"trilha","name":"TRILHA DOS VAGA-LUMES","subtitle":"A floresta guia seus passos.","enemy_hp":0.78,"enemy_damage":0.65,"enemy_speed":0.88,"cooldown":1.18,"parry":1.30,"drops":1.55,"map_scale":0.92,"enemy_population":0.78},
	{"id":"limiar","name":"PASSOS PELO LIMIAR","subtitle":"A jornada em seu ritmo original.","enemy_hp":1.0,"enemy_damage":1.0,"enemy_speed":1.0,"cooldown":1.0,"parry":1.0,"drops":1.0,"map_scale":1.0,"enemy_population":1.0},
	{"id":"sem_retorno","name":"JORNADA SEM RETORNO","subtitle":"Guardiões mais ferozes e menos recursos.","enemy_hp":1.24,"enemy_damage":1.30,"enemy_speed":1.10,"cooldown":0.86,"parry":0.82,"drops":0.72,"map_scale":1.18,"enemy_population":1.34},
	{"id":"eclipse","name":"ECLIPSE DO ÚLTIMO PORTAL","subtitle":"Para quem já aprendeu cada sinal da arena.","enemy_hp":1.55,"enemy_damage":1.65,"enemy_speed":1.18,"cooldown":0.72,"parry":0.66,"drops":0.42,"map_scale":1.35,"enemy_population":1.65}
]

var state := "menu"
var level := 0
var current_level_scene: Node2D
var current_level_data: Dictionary = {}
var coins := 0
var total_coins := 0
var health: float = 5.0
var max_health := 5
var speed_multiplier := 1.0
var dash_cooldown_multiplier := 1.0
var player: CharacterBody2D
var player_sprite: Sprite2D
var camera: Camera2D
var camera_shake_tween: Tween
var world: Node2D
var enemies: Array[Dictionary] = []
var projectiles: Array[Dictionary] = []
var coin_nodes: Array[Area2D] = []
var portal: Area2D
var hud: CanvasLayer
var health_label: Label
var coin_label: Label
var objective_label: Label
var boss_label: Label
var boss_hud_bar: ProgressBar
var boss_hud_name: Label
var message_label: Label
var attack_time := 0.0
var combo_step := 0
var combo_window := 0.0
var combo_label: Label
var health_bar: ProgressBar
var heart_nodes: Array[TextureRect] = []
var dash_bar: ProgressBar
var guard_bar: ProgressBar
var guard_label: Label
var guard_button: Button
var guard_visual: Sprite2D
var boss_status_label: Label
var boss_posture_bar: ProgressBar
var boss_posture_label: Label
var timer_label: Label
var invincible_time := 0.0
var damage_flash_time := 0.0
var anim_time := 0.0
var attack_elapsed := 0.0
var attack_duration := 0.0
var attack_hit_done := false
var attack_direction := Vector2.RIGHT
var hitstop_active := false
var assisted_target: Node2D
var jumps_left := 2
var was_on_floor := false
var coyote_time := 0.0
var jump_buffer_time := 0.0
var dash_time := 0.0
var dash_cooldown := 0.0
var dash_direction := 1.0
var guarding := false
var parry_time := 0.0
var guard_recovery := 0.0
var parry_count := 0
var run_time := 0.0
var deaths := 0
var screen_shake := true
var flash_intensity := 0.75
var master_volume := 0.8
var music_volume := 0.75
var sfx_volume := 0.85
var remap_action := ""
var remap_button: Button
var remap_buttons := {}
var settings_status_label: Label
var windowed_resolution := BASE_RESOLUTION
var visual_scale := 1.0
var embedded_run := false
var fullscreen_preference := false
var footstep_timer := 0.0
var menu_layer: CanvasLayer
var menu_walk_time := 0.0
var menu_parallax_layers: Array[Parallax2D] = []
var last_hud_second := -1
var facing := 1.0
var checkpoint := Vector2.ZERO
var level_width := 3200.0
var hero_textures := {}
var hero_animation_frames := {
	"idle":[Vector2i(0,0),Vector2i(0,1)],
	"run":[Vector2i(0,0),Vector2i(1,0),Vector2i(2,0),Vector2i(0,1),Vector2i(1,1),Vector2i(2,1),Vector2i(0,2),Vector2i(1,2),Vector2i(2,2)],
	"jump":[Vector2i(0,0),Vector2i(1,0)],
	"fall":[Vector2i(0,1),Vector2i(1,1)],
	"attack":[Vector2i(0,0),Vector2i(1,0),Vector2i(2,0),Vector2i(3,0),Vector2i(4,0),Vector2i(5,0)],
	"attack_end":[Vector2i(0,0),Vector2i(1,0),Vector2i(2,0),Vector2i(3,0),Vector2i(4,0),Vector2i(5,0)],
	"jump_attack":[Vector2i(0,0),Vector2i(1,0),Vector2i(2,0),Vector2i(3,0),Vector2i(4,0),Vector2i(5,0)],
	"hurt":[Vector2i(0,0),Vector2i(1,0),Vector2i(2,0)]
}
var rng := RandomNumberGenerator.new()
var life_drops: Array[Area2D] = []
var seen_attack_tips := {}
var player_slow_time := 0.0
var difficulty_index := 1
var selected_difficulty_index := 1
var difficulty_preview_label: Label
var difficulty_hud_label: Label
var cutscene_token := 0
var cutscene_advance_requested := false
var portal_charge_bar: ProgressBar
var combat_chain := 0
var combat_chain_time := 0.0

enum TelegraphType { GROUND_AREA, GROUND_LINE, ARC, CHARGE, AIM, RADIAL }

var levels := [
	{
		"name": "I — FLORESTA DA ILUSÃO",
		"subtitle": "Siga os fragmentos por entre raízes e clareiras",
		"width": 3400.0,
		"biome": "illusion",
		"coins": [Vector2(350,485),Vector2(650,390),Vector2(950,280),Vector2(1260,365),Vector2(1510,485),Vector2(1750,260),Vector2(2200,355),Vector2(2500,250),Vector2(2700,485),Vector2(2910,365),Vector2(3160,485),Vector2(3290,485)],
		"platforms": [Vector4(0,560,3400,88),Vector4(580,450,200,32),Vector4(880,340,170,32),Vector4(1190,430,180,32),Vector4(1650,330,170,32),Vector4(2110,420,180,32),Vector4(2430,320,170,32),Vector4(2820,430,180,32)],
		"enemies": [["mushroom",380,505],["bramble",1260,495],["flying",1750,285],["mushroom",2360,505],["bramble",2910,375],["flying",3160,350]],
		"secrets": [Vector2(990,275)],
		"theme": "forest"
	},
	{
		"name": "II — COVIL DAS RAÍZES",
		"subtitle": "O Badger rompe o solo e bloqueia o primeiro portal",
		"width": 2100.0,
		"biome": "forest_boss",
		"coins": [],
		"platforms": [Vector4(0,560,2100,88),Vector4(350,430,190,24),Vector4(760,365,180,24),Vector4(1190,365,180,24),Vector4(1580,430,190,24)],
		"enemies": [["badger_boss",1450,480]],
		"secrets": [],
		"theme": "roots"
	},
	{
		"name": "III — FORJA DE TRAPMOOR",
		"subtitle": "Atravesse a fábrica corrompida e seus sentinelas",
		"width": 3600.0,
		"biome": "trapmoor",
		"coins": [Vector2(320,485),Vector2(620,390),Vector2(900,280),Vector2(1300,365),Vector2(1510,485),Vector2(1650,255),Vector2(2100,365),Vector2(2500,265),Vector2(2700,485),Vector2(2900,375),Vector2(3200,275),Vector2(3430,485)],
		"platforms": [Vector4(0,560,3600,88),Vector4(550,450,180,24),Vector4(820,340,180,24),Vector4(1210,430,180,24),Vector4(1570,320,180,24),Vector4(2020,430,180,24),Vector4(2410,330,180,24),Vector4(2810,440,180,24),Vector4(3120,340,180,24)],
		"enemies": [["skeleton",360,510],["skeleton",1180,510],["sentinel",1640,260],["spore",2260,520],["skeleton",2460,510],["sentinel",3180,280],["spore",3370,520]],
		"secrets": [Vector2(930,295)],
		"theme": "foundry"
	},
	{
		"name": "IV — ARSENAL DO GATO",
		"subtitle": "O Cat domina a distância com metralhadora e granadas",
		"width": 2100.0,
		"biome": "factory_boss",
		"coins": [],
		"platforms": [Vector4(0,560,2100,88),Vector4(300,440,200,24),Vector4(700,350,180,24),Vector4(1120,410,200,24),Vector4(1550,330,180,24)],
		"enemies": [["cat_boss",1450,480]],
		"secrets": [],
		"theme": "arsenal"
	},
	{
		"name": "V — ABISMO CONGELADO",
		"subtitle": "O frio fecha o caminho para o último portal",
		"width": 3500.0,
		"biome": "ice",
		"coins": [Vector2(330,485),Vector2(610,380),Vector2(900,270),Vector2(1210,410),Vector2(1490,485),Vector2(1730,290),Vector2(2050,410),Vector2(2340,270),Vector2(2640,485),Vector2(2910,370),Vector2(3190,260),Vector2(3380,485)],
		"platforms": [Vector4(0,560,3500,88),Vector4(520,445,190,24),Vector4(820,335,180,24),Vector4(1160,440,190,24),Vector4(1650,350,180,24),Vector4(1980,440,190,24),Vector4(2310,330,180,24),Vector4(2780,430,190,24),Vector4(3100,330,180,24)],
		"enemies": [["flying",420,330],["sentinel",980,280],["skeleton",1320,510],["flying",1810,300],["sentinel",2370,275],["skeleton",2780,510],["flying",3220,290]],
		"secrets": [Vector2(910,285)],
		"theme": "ice"
	},
	{
		"name": "VI — TRONO DO INVERNO",
		"subtitle": "Pengu aguarda no coração da tempestade eterna",
		"width": 2200.0,
		"biome": "ice_boss",
		"coins": [],
		"platforms": [Vector4(0,560,2200,88),Vector4(300,430,190,24),Vector4(690,335,180,24),Vector4(1080,420,200,24),Vector4(1480,335,180,24),Vector4(1840,430,190,24)],
		"enemies": [["pengu_boss",1520,480]],
		"secrets": [],
		"theme": "throne"
	}
]

func _ready() -> void:
	# O controlador precisa receber Start/Esc mesmo com a árvore pausada.
	process_mode = Node.PROCESS_MODE_ALWAYS
	rng.randomize()
	embedded_run = is_embedded_game_run()
	reset_exhibition_session()
	Input.set_custom_mouse_cursor(UI_CURSOR,Input.CURSOR_ARROW,Vector2(2,2))
	load_settings()
	hero_textures = {
		"idle": load(HERO_SWORDSMAN_PATH+"Hero swordsman idle.png"),
		"run": load(HERO_SWORDSMAN_PATH+"Hero swordsman Run.png"),
		"jump": load(HERO_SWORDSMAN_PATH+"Hero swordsman Jump and Fall.png"),
		"fall": load(HERO_SWORDSMAN_PATH+"Hero swordsman Jump and Fall.png"),
		"attack": load(HERO_SWORDSMAN_PATH+"Hero swordsman Attack.png"),
		"attack_end": load(HERO_SWORDSMAN_PATH+"Hero swordsman Attack.png"),
		"jump_attack": load(HERO_SWORDSMAN_PATH+"Hero swordsman Jump Attack.png"),
		"hurt": load(HERO_SWORDSMAN_PATH+"Hero swordsman Hurt and Die.png")
	}
	show_startup_presentation()

func hero_frame_rect(animation_name: String, frame_index: int) -> Rect2:
	var coordinates: Array = hero_animation_frames.get(animation_name,hero_animation_frames.idle)
	if coordinates.is_empty(): return Rect2(0,0,64,64)
	var coordinate: Vector2i = coordinates[posmod(frame_index,coordinates.size())]
	return Rect2(coordinate.x*64,coordinate.y*64,64,64)

func reset_exhibition_session() -> void:
	# A jornada existe apenas durante esta execução. Cada visitante da mostra
	# recebe uma experiência nova; vídeo, áudio e controles continuam salvos.
	if FileAccess.file_exists(SAVE_PATH):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(SAVE_PATH))

func _exit_tree() -> void:
	Engine.time_scale = 1.0
	Input.set_custom_mouse_cursor(null,Input.CURSOR_ARROW)
	var music := get_node_or_null("JorginhoMusic") as AudioStreamPlayer
	if music:
		music.stop()
		music.stream = null

func _process(delta: float) -> void:
	if state=="menu":
		menu_walk_time += delta
		var mouse_parallax := (get_viewport().get_mouse_position()-VIEW*0.5)/VIEW
		for layer_node in menu_parallax_layers:
			if not is_instance_valid(layer_node): continue
			var depth := float(layer_node.get_meta("depth"))
			layer_node.position = Vector2(-mouse_parallax.x*depth*7.0,-mouse_parallax.y*depth*4.0+sin(menu_walk_time*0.35+depth)*depth)

func clear_screen() -> void:
	for child in get_children():
		if child.name not in ["JorginhoMusic","LevelTransition"]: child.queue_free()
	world = null
	hud = null
	boss_hud_bar = null
	boss_hud_name = null
	boss_status_label = null
	difficulty_hud_label = null
	portal_charge_bar = null
	guard_bar = null
	guard_label = null
	guard_button = null
	guard_visual = null
	guarding = false
	parry_time = 0.0
	guard_recovery = 0.0
	heart_nodes.clear()
	menu_parallax_layers.clear()
	enemies.clear()
	projectiles.clear()
	coin_nodes.clear()
	life_drops.clear()

func panel_style(color: Color, border := Color("#55d6be"), radius := 14) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = color
	style.border_color = border
	style.set_border_width_all(2)
	style.set_corner_radius_all(radius)
	style.content_margin_left = 22
	style.content_margin_right = 22
	style.content_margin_top = 14
	style.content_margin_bottom = 14
	return style

func ui_texture_style(texture: Texture2D, tint := Color.WHITE, horizontal_margin := 60.0, vertical_margin := 38.0) -> StyleBoxTexture:
	var style := StyleBoxTexture.new()
	style.texture = texture
	style.texture_margin_left = horizontal_margin
	style.texture_margin_right = horizontal_margin
	style.texture_margin_top = vertical_margin
	style.texture_margin_bottom = vertical_margin
	style.content_margin_left = 24
	style.content_margin_right = 24
	style.content_margin_top = 12
	style.content_margin_bottom = 12
	style.modulate_color = tint
	return style

func ui_panel_style(tint := Color.WHITE, compact := false) -> StyleBoxTexture:
	var style := ui_texture_style(UI_PANEL,tint,58.0,42.0)
	style.content_margin_left = 18 if compact else 48
	style.content_margin_right = 18 if compact else 48
	style.content_margin_top = 10 if compact else 36
	style.content_margin_bottom = 10 if compact else 36
	return style

func make_button(text: String, width := 280) -> Button:
	var button := Button.new()
	button.focus_mode = Control.FOCUS_ALL
	button.text = text
	button.custom_minimum_size = Vector2(width, 58)
	button.add_theme_font_size_override("font_size", 20)
	button.add_theme_color_override("font_color",Color("#fff0bf"))
	button.add_theme_color_override("font_hover_color",Color.WHITE)
	button.add_theme_stylebox_override("normal",ui_texture_style(UI_BUTTON,Color(0.78,0.84,0.78,1.0),52.0,34.0))
	button.add_theme_stylebox_override("hover",ui_texture_style(UI_BUTTON,Color(1.12,1.22,1.24,1.0),52.0,34.0))
	button.add_theme_stylebox_override("pressed",ui_texture_style(UI_BUTTON,Color(0.66,0.78,0.88,1.0),52.0,34.0))
	button.mouse_entered.connect(func(): play_ui_sound("kenney/ui_hover.ogg",-20.0,1.02))
	button.focus_entered.connect(func(): play_ui_sound("kenney/ui_hover.ogg",-20.0,1.02))
	button.pressed.connect(func(): play_ui_sound("kenney/ui_confirm.ogg",-14.0))
	return button

func play_ui_sound(file_name: String, volume_db := -10.0, pitch_scale := 1.0) -> void:
	AudioManager.play_sfx(file_name,volume_db,pitch_scale)

func play_music(file_name: String, volume_db := -8.0) -> void:
	AudioManager.play_music(file_name,volume_db,0.24)

func show_startup_presentation() -> void:
	state = "startup"
	get_tree().paused = false
	play_music("Light Ambience 2.mp3",-12.0)
	clear_screen()
	var layer := CanvasLayer.new()
	layer.name = "ApresentacaoInicial"
	add_child(layer)
	var background := ColorRect.new()
	background.color = Color("#030708")
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	layer.add_child(background)
	var line := ColorRect.new()
	line.color = Color("#59d6c2")
	line.position = Vector2(426,382)
	line.size = Vector2(300,2)
	line.modulate.a = 0.0
	layer.add_child(line)
	var made := Label.new()
	made.position = Vector2(176,208)
	made.size = Vector2(800,50)
	made.text = "UM JOGO DESENVOLVIDO POR"
	made.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	made.add_theme_font_size_override("font_size",16)
	made.add_theme_color_override("font_color",Color("#a5c8bf"))
	made.modulate.a = 0.0
	layer.add_child(made)
	var author := Label.new()
	author.position = Vector2(176,252)
	author.size = Vector2(800,76)
	author.text = "GUSTAVO BENTO OUVERNEY"
	author.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	author.add_theme_font_override("font",DISPLAY_FONT)
	author.add_theme_font_size_override("font_size",34)
	author.add_theme_color_override("font_color",Color("#ffe7a0"))
	author.modulate.a = 0.0
	layer.add_child(author)
	var engine := Label.new()
	engine.position = Vector2(176,405)
	engine.size = Vector2(800,52)
	engine.text = "CRIADO COM GODOT ENGINE 4"
	engine.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	engine.add_theme_font_size_override("font_size",20)
	engine.add_theme_color_override("font_color",Color("#8fe9da"))
	engine.modulate.a = 0.0
	layer.add_child(engine)
	var note := Label.new()
	note.position = Vector2(176,452)
	note.size = Vector2(800,40)
	note.text = "Projeto de conclusão de curso  •  2026"
	note.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	note.add_theme_font_size_override("font_size",13)
	note.add_theme_color_override("font_color",Color("#738f89"))
	note.modulate.a = 0.0
	layer.add_child(note)
	var reveal := create_tween().bind_node(layer)
	reveal.tween_property(made,"modulate:a",1.0,0.38)
	reveal.parallel().tween_property(author,"modulate:a",1.0,0.62)
	reveal.parallel().tween_property(line,"modulate:a",0.8,0.62)
	reveal.tween_interval(0.72)
	reveal.tween_property(engine,"modulate:a",1.0,0.42)
	reveal.parallel().tween_property(note,"modulate:a",1.0,0.42)
	reveal.tween_interval(0.92)
	reveal.tween_property(background,"color",Color("#000000"),0.36)
	reveal.parallel().tween_property(made,"modulate:a",0.0,0.30)
	reveal.parallel().tween_property(author,"modulate:a",0.0,0.30)
	reveal.parallel().tween_property(line,"modulate:a",0.0,0.30)
	reveal.parallel().tween_property(engine,"modulate:a",0.0,0.30)
	reveal.parallel().tween_property(note,"modulate:a",0.0,0.30)
	reveal.tween_callback(show_menu)

func add_full_background(parent: Node, darken := 0.15) -> void:
	var bg := TextureRect.new()
	bg.texture = load("res://assets/world/background.png")
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	bg.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	parent.add_child(bg)
	var shade := ColorRect.new()
	shade.color = Color(0.015,0.055,0.075,darken)
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	parent.add_child(shade)

func show_menu() -> void:
	state = "menu"
	play_music("Light Ambience 2.mp3",-8.0)
	get_tree().paused = false
	clear_screen()
	menu_layer = CanvasLayer.new()
	add_child(menu_layer)
	var sky := ColorRect.new()
	sky.color = Color("#111b12")
	sky.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	sky.z_index = -20
	menu_layer.add_child(sky)
	# Somente floresta em movimento: sem castelo, chão artificial ou objetos soltos.
	create_menu_parallax_layer("back.png",2.40,Vector2(-5.0,0.0),Color(0.52,0.64,0.42,1.0),-18,1.0)
	create_menu_parallax_layer("middle.png",2.40,Vector2(-12.0,0.0),Color(0.72,0.86,0.70,0.96),-16,2.0)
	var veil := ColorRect.new()
	veil.color = Color(0.015,0.045,0.035,0.34)
	veil.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	veil.z_index = -10
	menu_layer.add_child(veil)
	create_menu_motes(menu_layer)
	menu_walk_time = 0.0
	# Marca reduzida para respirar melhor e não disputar atenção com a navegação.
	var logo := Sprite2D.new()
	logo.texture = UI_LOGO
	logo.position = Vector2(300,205)
	logo.scale = Vector2(0.62,0.62)
	logo.z_index = 8
	menu_layer.add_child(logo)
	var logo_float := create_tween().bind_node(logo).set_loops()
	logo_float.tween_property(logo,"position:y",200.0,2.8).set_trans(Tween.TRANS_SINE)
	logo_float.tween_property(logo,"position:y",208.0,2.8).set_trans(Tween.TRANS_SINE)
	var tagline := Label.new()
	tagline.position = Vector2(104,354)
	tagline.size = Vector2(390,32)
	tagline.text = "A FLORESTA SE MOVE. O LIMIAR ESPERA."
	tagline.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	tagline.add_theme_font_size_override("font_size",14)
	tagline.add_theme_color_override("font_color",Color("#d8e9c2"))
	tagline.z_index = 9
	menu_layer.add_child(tagline)
	var menu_panel := PanelContainer.new()
	menu_panel.position = Vector2(708,66)
	menu_panel.size = Vector2(392,516)
	menu_panel.add_theme_stylebox_override("panel",ui_panel_style(Color(0.56,0.66,0.56,0.94),false))
	menu_layer.add_child(menu_panel)
	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left",42)
	margin.add_theme_constant_override("margin_right",42)
	margin.add_theme_constant_override("margin_top",48)
	margin.add_theme_constant_override("margin_bottom",42)
	menu_panel.add_child(margin)
	var options := VBoxContainer.new()
	options.add_theme_constant_override("separation",8)
	margin.add_child(options)
	var menu_title := Label.new()
	menu_title.text = "MENU PRINCIPAL"
	menu_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	menu_title.add_theme_font_size_override("font_size",18)
	menu_title.add_theme_color_override("font_color",Color("#f8e8b2"))
	options.add_child(menu_title)
	options.add_spacer(false)
	if has_save():
		var continue_button := make_menu_button("CONTINUAR ESTA SESSÃO")
		continue_button.pressed.connect(continue_game)
		options.add_child(continue_button)
	var play := make_menu_button("NOVA JORNADA")
	play.pressed.connect(show_difficulty_selection)
	options.add_child(play)
	var settings_button := make_menu_button("CONFIGURAÇÕES")
	settings_button.pressed.connect(show_settings)
	options.add_child(settings_button)
	var credits_button := make_menu_button("CRÉDITOS")
	credits_button.pressed.connect(show_credits)
	options.add_child(credits_button)
	var quit_button := make_menu_button("SAIR")
	quit_button.pressed.connect(quit_game)
	options.add_child(quit_button)
	var version := Label.new()
	version.position = Vector2(1018,610)
	version.text = "PROJETO TCC • MODO MOSTRA"
	version.add_theme_font_size_override("font_size",12)
	version.add_theme_color_override("font_color",Color("#a6b99c"))
	menu_layer.add_child(version)
	call_deferred("focus_first_button",menu_layer)

func create_menu_parallax_layer(file_name: String, scale_value: float, speed: Vector2, tint: Color, z: int, depth: float) -> void:
	var texture: Texture2D = load(ILLUSION_PATH+file_name)
	var layer := Parallax2D.new()
	layer.name = "MenuParallax_%s" % file_name.get_basename()
	layer.autoscroll = speed
	layer.scroll_scale = Vector2.ONE
	layer.repeat_size = Vector2(float(texture.get_width())*scale_value,0.0)
	layer.repeat_times = 4
	layer.z_index = z
	layer.set_meta("depth",depth)
	menu_layer.add_child(layer)
	var sprite := Sprite2D.new()
	sprite.texture = texture
	sprite.scale = Vector2(scale_value,scale_value)
	sprite.position = Vector2(float(texture.get_width())*scale_value*0.5,float(texture.get_height())*scale_value*0.5)
	sprite.modulate = tint
	layer.add_child(sprite)
	menu_parallax_layers.append(layer)

func quit_game() -> void:
	Input.set_custom_mouse_cursor(null,Input.CURSOR_ARROW)
	AudioManager.stop_music()
	# O decoder MP3 e o cursor precisam de um ciclo para liberar recursos nativos.
	await get_tree().process_frame
	await get_tree().process_frame
	get_tree().quit()

func make_menu_button(text: String) -> Button:
	var button := Button.new()
	button.focus_mode = Control.FOCUS_ALL
	button.text = text
	button.custom_minimum_size = Vector2(300,58)
	button.add_theme_font_size_override("font_size",18)
	button.add_theme_color_override("font_color",Color("#fff0bf"))
	button.add_theme_color_override("font_hover_color",Color.WHITE)
	button.add_theme_color_override("font_pressed_color",Color("#bdefff"))
	button.add_theme_color_override("font_disabled_color",Color(0.55,0.58,0.56,0.72))
	button.add_theme_stylebox_override("normal",ui_texture_style(UI_BUTTON,Color(0.88,0.92,0.88,1.0)))
	button.add_theme_stylebox_override("hover",ui_texture_style(UI_BUTTON,Color(1.18,1.26,1.30,1.0)))
	button.add_theme_stylebox_override("pressed",ui_texture_style(UI_BUTTON,Color(0.68,0.82,0.92,1.0)))
	button.add_theme_stylebox_override("disabled",ui_texture_style(UI_BUTTON,Color(0.38,0.42,0.40,0.70)))
	button.mouse_entered.connect(func(): play_ui_sound("kenney/ui_hover.ogg",-20.0,1.02))
	button.focus_entered.connect(func(): play_ui_sound("kenney/ui_hover.ogg",-20.0,1.02))
	button.pressed.connect(func(): play_ui_sound("kenney/ui_confirm.ogg",-14.0))
	return button

func focus_first_button(root_node: Node) -> void:
	if not is_instance_valid(root_node): return
	for candidate in root_node.find_children("*","Button",true,false):
		var button := candidate as Button
		if button and button.visible and not button.disabled:
			button.grab_focus()
			return

func action_prompt(action: String) -> String:
	return "%s / %s" % [get_action_key(action),String(GAMEPAD_LABELS.get(action,"—"))]

func create_menu_motes(layer: CanvasLayer) -> void:
	for i in 24:
		var mote := Polygon2D.new()
		var points := PackedVector2Array()
		for p in 8:
			var a := TAU*float(p)/8.0
			points.append(Vector2(cos(a),sin(a))*(1.5+float(i%3)))
		mote.polygon = points
		mote.color = Color(0.35,0.95,0.72,0.18+float(i%4)*0.07)
		mote.position = Vector2(rng.randi_range(20,1130),rng.randi_range(80,590))
		layer.add_child(mote)
		var end_y := mote.position.y-rng.randi_range(80,180)
		var tween := create_tween().bind_node(mote).set_loops()
		tween.tween_property(mote,"position:y",end_y,rng.randf_range(2.5,5.0)).set_trans(Tween.TRANS_SINE)
		tween.tween_property(mote,"position:y",mote.position.y,rng.randf_range(2.5,5.0)).set_trans(Tween.TRANS_SINE)

func show_modal(title_text: String) -> VBoxContainer:
	var shade := ColorRect.new()
	shade.name = "Modal"
	shade.color = Color(0.005,0.015,0.02,0.82)
	shade.z_index = 100
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	menu_layer.add_child(shade)
	var panel := PanelContainer.new()
	panel.position = Vector2(236,16)
	panel.size = Vector2(680,616)
	panel.add_theme_stylebox_override("panel",ui_panel_style())
	shade.add_child(panel)
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation",8)
	panel.add_child(box)
	var title := Label.new()
	title.text = title_text
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size",30)
	title.add_theme_color_override("font_color",Color("#fff2b2"))
	box.add_child(title)
	call_deferred("focus_first_button",shade)
	return box

func show_settings() -> void:
	var box := show_modal("CONFIGURAÇÕES")
	var tabs := TabContainer.new()
	tabs.custom_minimum_size = Vector2(590,360)
	box.add_child(tabs)
	var audiovisual := VBoxContainer.new()
	audiovisual.name = "SOM E VIDEO"
	audiovisual.add_theme_constant_override("separation",12)
	tabs.add_child(audiovisual)
	audiovisual.add_child(make_section_label("VOLUMES"))
	audiovisual.add_child(make_volume_control("MÚSICA",music_volume,func(value): music_volume=float(value); AudioManager.set_music_volume(music_volume)))
	audiovisual.add_child(make_volume_control("EFEITOS",sfx_volume,func(value): sfx_volume=float(value); AudioManager.set_sfx_volume(sfx_volume)))
	audiovisual.add_child(make_section_label("EXIBIÇÃO"))
	var mode_row := HBoxContainer.new()
	var mode_label := Label.new(); mode_label.text="MODO"; mode_label.custom_minimum_size.x=150; mode_row.add_child(mode_label)
	var mode := OptionButton.new(); mode.custom_minimum_size.x=260; mode.add_item("JANELA"); mode.add_item("TELA CHEIA")
	mode.selected = 1 if fullscreen_preference else 0
	mode.item_selected.connect(func(index): play_ui_sound("kenney/ui_toggle.ogg",-16.0); set_fullscreen(index==1))
	mode_row.add_child(mode); audiovisual.add_child(mode_row)
	var resolution_row := HBoxContainer.new()
	var resolution_label := Label.new(); resolution_label.text="RESOLUÇÃO"; resolution_label.custom_minimum_size.x=150; resolution_row.add_child(resolution_label)
	var resolution := OptionButton.new(); resolution.custom_minimum_size.x=260
	for size in DISPLAY_RESOLUTIONS: resolution.add_item("%d × %d" % [size.x,size.y])
	resolution.selected = maxi(0,DISPLAY_RESOLUTIONS.find(windowed_resolution))
	resolution.item_selected.connect(func(index): play_ui_sound("kenney/ui_toggle.ogg",-16.0); set_resolution(DISPLAY_RESOLUTIONS[index]))
	resolution_row.add_child(resolution); audiovisual.add_child(resolution_row)
	var scale_row := HBoxContainer.new()
	var scale_label := Label.new(); scale_label.text="ESCALA VISUAL"; scale_label.custom_minimum_size.x=150; scale_row.add_child(scale_label)
	var scale_option := OptionButton.new(); scale_option.custom_minimum_size.x=260
	for factor in VISUAL_SCALES: scale_option.add_item("%d%%" % int(factor*100.0))
	scale_option.selected = maxi(0,VISUAL_SCALES.find(visual_scale))
	scale_option.item_selected.connect(func(index): play_ui_sound("kenney/ui_toggle.ogg",-16.0); set_visual_scale(VISUAL_SCALES[index]))
	scale_row.add_child(scale_option); audiovisual.add_child(scale_row)
	var shake := CheckButton.new(); shake.text="TREMOR DE CÂMERA"; shake.button_pressed=screen_shake
	shake.toggled.connect(func(enabled): play_ui_sound("kenney/ui_toggle.ogg",-16.0); screen_shake=enabled)
	audiovisual.add_child(shake)
	audiovisual.add_child(make_volume_control("FLASHES",flash_intensity,func(value): flash_intensity=float(value)))
	var video_hint := Label.new(); video_hint.text=("Preferência salva. O editor incorporado não muda de modo; ao executar em janela externa ou abrir o jogo novamente, a resolução e a tela cheia serão aplicadas." if embedded_run else "Resolução e tela cheia são aplicadas na janela real. A escala visual amplia toda a interface e o jogo."); video_hint.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART; video_hint.custom_minimum_size.y=42; video_hint.add_theme_color_override("font_color",Color("#ffcf78") if embedded_run else Color("#9be8cf")); audiovisual.add_child(video_hint)
	var controls := VBoxContainer.new()
	controls.name = "CONTROLES"
	controls.add_theme_constant_override("separation",5)
	tabs.add_child(controls)
	var instruction := Label.new(); instruction.text="Selecione uma ação e pressione a nova tecla. ESC cancela. Controle: analógico/D-pad, A pula, X ataca, LB guarda/apara, B impulsiona e Start pausa."; instruction.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART; instruction.custom_minimum_size.y=40; instruction.add_theme_color_override("font_color",Color("#9be8cf")); controls.add_child(instruction)
	var controls_grid := GridContainer.new(); controls_grid.columns=2; controls_grid.add_theme_constant_override("h_separation",24); controls_grid.add_theme_constant_override("v_separation",4); controls.add_child(controls_grid)
	remap_buttons.clear()
	var actions := {"move_left":"MOVER PARA A ESQUERDA","move_right":"MOVER PARA A DIREITA","jump":"PULAR","attack":"ATACAR","guard":"GUARDA / APARAR","dash":"IMPULSO","pause":"PAUSAR"}
	for action in actions:
		var action_label := Label.new(); action_label.text=actions[action]; action_label.custom_minimum_size.x=265; controls_grid.add_child(action_label)
		var key_button := Button.new(); key_button.text=get_action_key(action); key_button.custom_minimum_size=Vector2(220,32); key_button.pressed.connect(begin_remap.bind(action,key_button)); controls_grid.add_child(key_button); remap_buttons[action]=key_button
	settings_status_label = Label.new(); settings_status_label.text="Nenhuma ação selecionada."; settings_status_label.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER; settings_status_label.add_theme_color_override("font_color",Color("#ffe59a")); controls.add_child(settings_status_label)
	var defaults := make_button("RESTAURAR CONTROLES",270); defaults.custom_minimum_size.y=44; defaults.pressed.connect(restore_default_controls); controls.add_child(defaults)
	var footer := HBoxContainer.new(); box.add_child(footer)
	footer.alignment = BoxContainer.ALIGNMENT_CENTER
	var back := make_button("SALVAR E VOLTAR",300)
	back.custom_minimum_size.y=44
	back.pressed.connect(func(): save_settings(); close_menu_modal())
	footer.add_child(back)

func make_section_label(text_value: String) -> Label:
	var label := Label.new(); label.text=text_value; label.add_theme_font_size_override("font_size",16); label.add_theme_color_override("font_color",Color("#ffe59a")); return label

func make_volume_control(label_text: String, value: float, callback: Callable) -> HBoxContainer:
	var row := HBoxContainer.new(); var label := Label.new(); label.text=label_text; label.custom_minimum_size.x=110; row.add_child(label)
	var slider := HSlider.new(); slider.min_value=0; slider.max_value=1; slider.step=0.05; slider.value=value; slider.custom_minimum_size=Vector2(390,28); slider.value_changed.connect(callback); row.add_child(slider); return row

func set_fullscreen(enabled: bool) -> void:
	fullscreen_preference = enabled
	if embedded_run:
		if is_instance_valid(settings_status_label): settings_status_label.text="Preferência salva; será aplicada na próxima janela externa."
		return
	if enabled:
		if DisplayServer.window_get_mode()==DisplayServer.WINDOW_MODE_WINDOWED: windowed_resolution=DisplayServer.window_get_size()
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_size(windowed_resolution)
		center_game_window()

func is_embedded_game_run() -> bool:
	var args := OS.get_cmdline_args()
	for index in args.size():
		var arg := String(args[index])
		if arg=="--wid" or arg.begins_with("--wid="):
			return true
	return false

func set_resolution(size: Vector2i) -> void:
	windowed_resolution = size
	if embedded_run:
		if is_instance_valid(settings_status_label): settings_status_label.text="Resolução salva; será aplicada na próxima execução em janela externa."
		return
	if DisplayServer.window_get_mode()==DisplayServer.WINDOW_MODE_WINDOWED:
		call_deferred("apply_windowed_resolution")

func apply_windowed_resolution() -> void:
	if embedded_run or DisplayServer.window_get_mode()!=DisplayServer.WINDOW_MODE_WINDOWED: return
	DisplayServer.window_set_size(windowed_resolution)
	await get_tree().process_frame
	center_game_window()
	if is_instance_valid(settings_status_label): settings_status_label.text="Resolução aplicada: %d × %d." % [windowed_resolution.x,windowed_resolution.y]

func set_visual_scale(value: float) -> void:
	visual_scale = clampf(value,0.75,1.5)
	get_window().content_scale_factor = visual_scale

func center_game_window() -> void:
	if embedded_run: return
	var screen := DisplayServer.window_get_current_screen()
	var screen_size := DisplayServer.screen_get_size(screen)
	DisplayServer.window_set_position((screen_size-DisplayServer.window_get_size())/2)

func begin_remap(action: String, button: Button) -> void:
	if not remap_action.is_empty() and is_instance_valid(remap_button): remap_button.text=get_action_key(remap_action)
	remap_action=action; remap_button=button; button.text="PRESSIONE UMA TECLA..."
	if is_instance_valid(settings_status_label): settings_status_label.text="Aguardando tecla para %s — ESC cancela." % action.to_upper()

func get_action_key(action: String) -> String:
	for event in InputMap.action_get_events(action):
		if event is InputEventKey: return OS.get_keycode_string(event.physical_keycode)
	return "—"

func restore_default_controls() -> void:
	var defaults := {"move_left":KEY_A,"move_right":KEY_D,"jump":KEY_SPACE,"attack":KEY_J,"guard":KEY_K,"dash":KEY_SHIFT,"pause":KEY_ESCAPE}
	for action in defaults:
		replace_action_key(action,defaults[action])
		if remap_buttons.has(action) and is_instance_valid(remap_buttons[action]): remap_buttons[action].text=get_action_key(action)
	if is_instance_valid(settings_status_label): settings_status_label.text="Controles padrão restaurados."
	play_ui_sound("ui_confirm_v10.wav",-12.0,1.08)

func replace_action_key(action: String, keycode: int) -> void:
	for event in InputMap.action_get_events(action):
		if event is InputEventKey: InputMap.action_erase_event(action,event)
	var mapped := InputEventKey.new(); mapped.physical_keycode=keycode; InputMap.action_add_event(action,mapped)

func show_credits() -> void:
	var box := show_modal("CRÉDITOS")
	var scroll := ScrollContainer.new(); scroll.custom_minimum_size=Vector2(610,455); box.add_child(scroll)
	var text := Label.new(); text.custom_minimum_size.x=590
	text.text = credits_text()
	text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; text.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART
	text.add_theme_font_size_override("font_size",14); text.add_theme_color_override("font_color",Color("#d8e8dd")); scroll.add_child(text)
	var back := make_button("VOLTAR",420)
	back.pressed.connect(close_menu_modal)
	box.add_child(back)

func credits_text() -> String:
	return "DESENVOLVIMENTO, DIREÇÃO E TCC\nGustavo Bento Ouverney\n\nORIENTAÇÃO ACADÊMICA\nCarlos Alcantara\n\nESTRUTURAÇÃO E MIGRAÇÃO TÉCNICA\nOpenAI Codex — assistência na estruturação do projeto e na migração HTML → GDScript/Godot\n\nPERSONAGENS E CRIATURAS\nMale Hero Free — Ozzbit Games\nForest Monsters FREE • Flying Forest Enemies FREE\nFree Forest Bosses Pixel Art Sprite Sheet Pack — CraftPix\nBosses_Badger • Bosses_Cat • Bosses_Pengu — pacotes fornecidos sem autoria incorporada\n\nCENÁRIOS E INTERFACE\nForest of Illusion • Forest Parallax Vertical\nTrapmoor Dungeon Tileset v03 • Crimson Fantasy GUI\nRetro Inventory — ElvGames\nKenney Pixel Platformer Industrial Expansion — Kenney, CC0\nEffect and FX Pixel All Free\nInterface personalizada de Jorginho — direção de Gustavo, preparação assistida por ImageGen\nDimensional_Portal.png — arquivo fornecido pelo autor do projeto; autoria externa não identificada\n\nMÚSICA E EFEITOS\nFantasy RPG Music Pack — AlkaKrab\nUltimate UI SFX Pack — JDSherbert\nKenney UI Audio • Kenney Impact Sounds — Kenney, CC0\nInterface SFX Pack 1 — ObsydianX, CC0\nFreeSFX • Super Dialogue Audio Pack v1 — voz de Sean Lenhart\n\nTECNOLOGIA\nGodot Engine 4.7.1\n\nLicenças disponíveis na pasta credits. Pacotes sem autoria ou licença incorporada estão identificados no documento credits/ASSETS.md."

func show_difficulty_selection() -> void:
	selected_difficulty_index=difficulty_index
	var box := show_modal("ESCOLHA SEU LIMIAR")
	var intro := Label.new()
	intro.text="A dificuldade altera resistência, dano, ritmo dos ataques, janela de parry e chance de vida."
	intro.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER; intro.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART; intro.custom_minimum_size.y=42; intro.add_theme_color_override("font_color",Color("#bcead6")); box.add_child(intro)
	var cards := VBoxContainer.new(); cards.add_theme_constant_override("separation",6); box.add_child(cards)
	var selector := ButtonGroup.new()
	for index in DIFFICULTIES.size():
		var data: Dictionary=DIFFICULTIES[index]
		var card := Button.new(); card.toggle_mode=true; card.button_group=selector; card.button_pressed=index==selected_difficulty_index; card.custom_minimum_size=Vector2(590,64); card.alignment=HORIZONTAL_ALIGNMENT_LEFT
		card.text="  %s\n  %s" % [data.name,data.subtitle]
		card.add_theme_font_size_override("font_size",15); card.add_theme_color_override("font_color",Color("#f5e7bc")); card.add_theme_color_override("font_pressed_color",Color.WHITE)
		var tint: Color = [Color(0.45,0.74,0.50,0.92),Color(0.55,0.68,0.62,0.94),Color(0.72,0.48,0.28,0.94),Color(0.62,0.27,0.50,0.96)][index]
		card.add_theme_stylebox_override("normal",ui_texture_style(UI_BUTTON,tint,52.0,34.0)); card.add_theme_stylebox_override("hover",ui_texture_style(UI_BUTTON,tint.lightened(0.18),52.0,34.0)); card.add_theme_stylebox_override("pressed",ui_texture_style(UI_BUTTON,tint.lightened(0.28),52.0,34.0))
		card.pressed.connect(func(): selected_difficulty_index=index; update_difficulty_preview())
		cards.add_child(card)
	difficulty_preview_label=Label.new(); difficulty_preview_label.name="DifficultyPreview"; difficulty_preview_label.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER; difficulty_preview_label.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART; difficulty_preview_label.custom_minimum_size.y=44; difficulty_preview_label.add_theme_color_override("font_color",Color("#ffe59a")); box.add_child(difficulty_preview_label); update_difficulty_preview()
	var footer := HBoxContainer.new(); footer.alignment=BoxContainer.ALIGNMENT_CENTER; footer.add_theme_constant_override("separation",12); box.add_child(footer)
	var back := make_button("VOLTAR",230); back.custom_minimum_size.y=44; back.pressed.connect(close_menu_modal); footer.add_child(back)
	var begin := make_button("ATRAVESSAR O PORTAL",320); begin.custom_minimum_size.y=44; begin.pressed.connect(func(): difficulty_index=selected_difficulty_index; show_origin_cutscene()); footer.add_child(begin)

func update_difficulty_preview() -> void:
	if not is_instance_valid(difficulty_preview_label): return
	var data: Dictionary=DIFFICULTIES[selected_difficulty_index]
	var description: String = ["Dano recebido reduzido • parry generoso • mais vidas","Experiência recomendada • regras equilibradas","Inimigos resistentes • ataques acelerados • parry curto","Dano extremo • pouquíssimas vidas • ritmo implacável"][selected_difficulty_index]
	difficulty_preview_label.text="%s\n%s" % [data.name,description]

func current_difficulty() -> Dictionary:
	return DIFFICULTIES[clampi(difficulty_index,0,DIFFICULTIES.size()-1)]

func difficulty_name() -> String:
	return String(current_difficulty().name)

func difficulty_value(key: String, fallback := 1.0) -> float:
	return float(current_difficulty().get(key,fallback))

func effective_parry_window() -> float:
	return PARRY_WINDOW*difficulty_value("parry")

func close_menu_modal() -> void:
	remap_action=""
	remap_button=null
	settings_status_label=null
	var modal := menu_layer.get_node_or_null("Modal")
	if modal: modal.queue_free()

func start_game() -> void:
	level = 0
	max_health = player_max_health
	health = max_health
	speed_multiplier = 1.0
	dash_cooldown_multiplier = 1.0
	run_time = 0.0
	deaths = 0
	seen_attack_tips.clear()
	player_slow_time = 0.0
	save_progress()
	load_level()

func show_origin_cutscene() -> void:
	cutscene_token += 1
	var token := cutscene_token
	cutscene_advance_requested = false
	state = "cutscene"
	get_tree().paused = false
	clear_screen()
	play_music("Light Ambience 2.mp3",-8.0)
	var layer := CanvasLayer.new()
	layer.name = "OriginCutscene"
	add_child(layer)
	var stage_root := Node2D.new()
	stage_root.name = "ContinuousStage"
	# Leve enquadramento cinematografico: mantem o cenario vivo sem distorcer
	# os pixels e reserva a faixa inferior exclusivamente para o dialogo.
	stage_root.position = Vector2(-22,-12)
	stage_root.scale = Vector2(1.04,1.04)
	layer.add_child(stage_root)
	var stage := Sprite2D.new()
	stage.name = "Stage"
	stage.texture = CUTSCENE_STAGE
	stage.centered = false
	stage.scale = Vector2(VIEW.x/float(stage.texture.get_width()),VIEW.y/float(stage.texture.get_height()))
	stage.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	stage_root.add_child(stage)
	var atmosphere := ColorRect.new()
	atmosphere.color = Color(0.0,0.06,0.09,0.10)
	atmosphere.size = VIEW
	atmosphere.mouse_filter = Control.MOUSE_FILTER_IGNORE
	stage_root.add_child(atmosphere)
	# O núcleo fica centralizado dentro do vão do arco, sem cobrir suas pedras.
	var portal_fx := Node2D.new()
	portal_fx.name = "PortalNoLimiar"
	portal_fx.position = Vector2(777,316)
	portal_fx.modulate.a = 0.0
	portal_fx.z_index = 3
	stage_root.add_child(portal_fx)
	var outer_ring := make_ellipse_line("RunasExternas",Vector2(67,100),Color(0.38,1.0,0.78,0.55),4.0)
	portal_fx.add_child(outer_ring)
	var inner_ring := make_ellipse_line("RunasInternas",Vector2(53,86),Color(0.72,0.48,1.0,0.48),3.0)
	inner_ring.rotation = 0.16
	portal_fx.add_child(inner_ring)
	var outer_spin := create_tween().bind_node(outer_ring).set_loops()
	outer_spin.tween_property(outer_ring,"rotation",TAU,5.2).from(0.0)
	var inner_spin := create_tween().bind_node(inner_ring).set_loops()
	inner_spin.tween_property(inner_ring,"rotation",-TAU,4.1).from(0.16)
	var portal_core := Sprite2D.new()
	portal_core.name = "PortalCore"
	portal_core.texture = PORTAL_SHEET
	portal_core.region_enabled = true
	portal_core.region_rect = portal_frame_rect(0)
	portal_core.scale = Vector2(4.1,5.6)
	portal_core.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	portal_core.z_index = 2
	portal_fx.add_child(portal_core)
	var glow := PointLight2D.new()
	glow.name = "PortalLight"
	glow.energy = 0.0
	glow.color = Color("#66f5dd")
	glow.position = portal_fx.position
	glow.texture = make_radial_light_texture(192)
	glow.texture_scale = 2.6
	glow.z_index = 2
	stage_root.add_child(glow)
	var hero := Sprite2D.new()
	hero.name = "Jorginho"
	hero.texture = hero_textures.run
	hero.region_enabled = true
	hero.region_rect = hero_frame_rect("run",0)
	hero.position = Vector2(86,450)
	hero.scale = Vector2(1.48,1.48)
	hero.flip_h = false
	hero.z_index = 5
	hero.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	stage_root.add_child(hero)
	var fragment := Sprite2D.new()
	fragment.name = "Fragment"
	fragment.texture = PORTAL_FRAGMENT
	fragment.position = Vector2(695,448)
	fragment.scale = Vector2(1.25,1.25)
	fragment.modulate.a = 0.0
	fragment.z_index = 6
	fragment.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	stage_root.add_child(fragment)
	for index in 18:
		var mote:=Polygon2D.new(); mote.polygon=PackedVector2Array([Vector2(-2,-2),Vector2(2,-2),Vector2(2,2),Vector2(-2,2)]); mote.color=Color("#d5ffb6") if index%3==0 else Color("#63e6d0"); mote.position=Vector2(55+index*64,165+(index*47)%300); mote.modulate.a=0.18+float(index%4)*0.08; mote.z_index=2; stage_root.add_child(mote)
		var drift:=create_tween().bind_node(mote).set_loops(); var start:=mote.position; drift.tween_property(mote,"position",start+Vector2(18,-14),1.4+index%4*0.27).set_trans(Tween.TRANS_SINE); drift.tween_property(mote,"position",start,1.4+index%4*0.27).set_trans(Tween.TRANS_SINE)
	var top := ColorRect.new()
	top.color = Color("#03070a")
	top.size = Vector2(VIEW.x,52)
	layer.add_child(top)
	var chapter := Label.new()
	chapter.text = "PRÓLOGO  •  A NOITE EM QUE O LIMIAR RESPONDEU"
	chapter.position = Vector2(38,15)
	chapter.size = Vector2(760,30)
	chapter.add_theme_font_override("font",DISPLAY_FONT)
	chapter.add_theme_font_size_override("font_size",18)
	chapter.add_theme_color_override("font_color",Color("#9be8cf"))
	layer.add_child(chapter)
	var dialogue_shadow := ColorRect.new()
	dialogue_shadow.position = Vector2(0,476)
	dialogue_shadow.size = Vector2(VIEW.x,172)
	dialogue_shadow.color = Color(0.0,0.015,0.025,0.52)
	dialogue_shadow.mouse_filter = Control.MOUSE_FILTER_IGNORE
	dialogue_shadow.z_index = 18
	layer.add_child(dialogue_shadow)
	var dialogue_panel := PanelContainer.new()
	dialogue_panel.position = Vector2(58,500)
	dialogue_panel.size = Vector2(1036,136)
	dialogue_panel.add_theme_stylebox_override("panel",ui_panel_style(Color(0.50,0.72,0.68,0.98),true))
	dialogue_panel.z_index = 20
	layer.add_child(dialogue_panel)
	var speaker_plate := PanelContainer.new()
	speaker_plate.position = Vector2(98,484)
	speaker_plate.size = Vector2(280,38)
	speaker_plate.add_theme_stylebox_override("panel",ui_texture_style(UI_BUTTON,Color(0.54,0.72,0.68,1.0),52.0,34.0))
	speaker_plate.z_index = 22
	layer.add_child(speaker_plate)
	var speaker := Label.new()
	speaker.name = "Speaker"
	speaker.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	speaker.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	speaker.add_theme_font_override("font",DISPLAY_FONT)
	speaker.add_theme_font_size_override("font_size",15)
	speaker.add_theme_color_override("font_color",Color("#ffe7a6"))
	speaker_plate.add_child(speaker)
	var portrait := Sprite2D.new()
	portrait.name = "RetratoJorginho"
	portrait.texture = hero_textures.idle
	portrait.region_enabled = true
	portrait.region_rect = hero_frame_rect("idle",0)
	portrait.position = Vector2(140,568)
	portrait.scale = Vector2(1.06,1.06)
	portrait.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	portrait.z_index = 23
	layer.add_child(portrait)
	var story := Label.new()
	story.name = "StoryText"
	story.position = Vector2(218,522)
	story.size = Vector2(806,76)
	story.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	story.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	story.add_theme_font_size_override("font_size",18)
	story.add_theme_color_override("font_color",Color("#f8edcf"))
	story.add_theme_color_override("font_shadow_color",Color(0,0,0,0.9))
	story.add_theme_constant_override("shadow_offset_x",2)
	story.add_theme_constant_override("shadow_offset_y",2)
	story.z_index = 23
	layer.add_child(story)
	var prompt := Label.new()
	prompt.position = Vector2(772,606)
	prompt.size = Vector2(272,24)
	prompt.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	prompt.text = "%s / CLIQUE  •  ACELERAR" % action_prompt("jump")
	prompt.add_theme_font_size_override("font_size",10)
	prompt.add_theme_color_override("font_color",Color("#76d9c5"))
	prompt.z_index = 23
	layer.add_child(prompt)
	var prompt_pulse := create_tween().bind_node(prompt).set_loops()
	prompt_pulse.tween_property(prompt,"modulate:a",0.42,0.65).set_trans(Tween.TRANS_SINE)
	prompt_pulse.tween_property(prompt,"modulate:a",1.0,0.65).set_trans(Tween.TRANS_SINE)
	var skip := make_button("PULAR PRÓLOGO",176)
	skip.position = Vector2(940,8)
	skip.custom_minimum_size.y = 38
	skip.z_index = 10
	layer.add_child(skip)
	skip.pressed.connect(func(): finish_origin_cutscene(token))
	var beats := [
		{"speaker":"NARRADOR","text":"Na aldeia, todos conheciam a história do Limiar: uma porta antiga que só respondia quando os mundos corriam perigo.","x":265.0,"hold":3.8,"action":"walk"},
		{"speaker":"NARRADOR","text":"Jorginho nunca acreditou completamente. Mesmo assim, guardava o medalhão deixado por sua avó e a promessa de não fugir do desconhecido.","x":430.0,"hold":4.2,"action":"walk"},
		{"speaker":"JORGINHO","text":"Os vaga-lumes me trouxeram até aqui... e este símbolo é o mesmo do medalhão. Então ela estava tentando me preparar.","x":590.0,"hold":4.1,"action":"notice"},
		{"speaker":"VOZ DO LIMIAR","text":"As passagens foram quebradas. Três Guardiões tomaram os fragmentos e, sem eles, cada dimensão desaparecerá sozinha.","x":655.0,"hold":4.4,"action":"awaken"},
		{"speaker":"JORGINHO","text":"Se eu fui chamado até aqui, não vou abandonar ninguém. Vou recuperar cada fragmento e encontrar o caminho de volta.","x":695.0,"hold":4.2,"action":"resolve"},
		{"speaker":"NARRADOR","text":"O Limiar aceitou sua escolha. Naquela noite, Jorginho entrou como um garoto da aldeia... e começou sua Jornada Sem Retorno.","x":715.0,"hold":4.5,"action":"pull"}
	]
	for beat in beats:
		if token != cutscene_token or not is_instance_valid(story): return
		portrait.visible = String(beat.speaker) == "JORGINHO"
		match String(beat.action):
			"walk": cutscene_walk(hero,float(beat.x),3.8)
			"notice":
				cutscene_walk(hero,float(beat.x),1.8)
				await get_tree().create_timer(1.1).timeout
				hero.texture = hero_textures.idle
				hero.region_rect = hero_frame_rect("idle",0)
				fragment.modulate.a = 1.0
				var bob := create_tween().bind_node(fragment).set_loops()
				bob.tween_property(fragment,"position:y",432.0,0.72).set_trans(Tween.TRANS_SINE)
				bob.tween_property(fragment,"position:y",448.0,0.72).set_trans(Tween.TRANS_SINE)
			"awaken":
				play_event_sfx("origin_rupture","portal_open.wav",-9.0,0.82)
				hero.texture = hero_textures.idle
				hero.region_rect = hero_frame_rect("idle",0)
				var awaken := create_tween().bind_node(portal_fx)
				awaken.tween_property(portal_fx,"modulate:a",1.0,0.85)
				awaken.parallel().tween_property(glow,"energy",2.2,0.85)
				awaken.parallel().tween_property(fragment,"position",portal_fx.position,0.78).set_trans(Tween.TRANS_BACK)
				awaken.tween_callback(func(): fragment.visible=false)
				cutscene_portal_animation(portal_core,token)
				cutscene_wind(stage_root,portal_fx.position,hero)
				cutscene_guardian_visions(stage_root,portal_fx.position)
			"resolve":
				hero.texture = hero_textures.attack
				hero.region_rect = hero_frame_rect("attack",0)
				var stand := create_tween().bind_node(hero)
				stand.tween_property(hero,"scale",Vector2(1.65,1.65),0.18)
				stand.tween_property(hero,"scale",Vector2(1.55,1.55),0.22)
			"pull":
				cutscene_wind(stage_root,portal_fx.position,hero)
				var pull := create_tween().bind_node(hero)
				pull.tween_property(hero,"position",portal_fx.position+Vector2(-8,24),2.65).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
				pull.parallel().tween_property(hero,"rotation",-0.55,1.35)
				pull.parallel().tween_property(hero,"scale",Vector2(0.35,0.35),2.65)
				var camera_pull := create_tween().bind_node(stage_root)
				camera_pull.tween_property(stage_root,"scale",Vector2(1.07,1.07),2.5).set_trans(Tween.TRANS_SINE)
				camera_pull.parallel().tween_property(stage_root,"position",Vector2(-54,-22),2.5)
		await cutscene_rpg_line(story,speaker,prompt,String(beat.text),String(beat.speaker),float(beat.hold),token)
	var whiteout := ColorRect.new()
	whiteout.color = Color(0.72,1.0,0.95,0.0)
	whiteout.size = VIEW
	whiteout.z_index = 20
	layer.add_child(whiteout)
	var finish := create_tween().bind_node(whiteout)
	finish.tween_property(whiteout,"color:a",1.0,0.42)
	await finish.finished
	finish_origin_cutscene(token)

func cutscene_rpg_line(story: Label, speaker: Label, prompt: Label, line: String, speaker_name: String, minimum_hold: float, token: int) -> void:
	if token != cutscene_token or not is_instance_valid(story): return
	cutscene_advance_requested = false
	speaker.text = speaker_name
	story.text = line
	story.visible_characters = 0
	prompt.text = "%s / CLIQUE  •  ACELERAR" % action_prompt("jump")
	var character_count := line.length()
	for character_index in character_count:
		if token != cutscene_token or not is_instance_valid(story): return
		if cutscene_advance_requested:
			story.visible_characters = -1
			cutscene_advance_requested = false
			break
		story.visible_characters = character_index+1
		if character_index%4 == 0: play_ui_sound("ui_hover_v10.wav",-36.0,1.18)
		await get_tree().create_timer(0.052).timeout
	story.visible_characters = -1
	prompt.text = "%s / CLIQUE  •  AVANÇAR" % action_prompt("jump")
	var elapsed := 0.0
	var reading_time := maxf(minimum_hold,clampf(float(character_count)*0.042,3.4,7.2))
	while elapsed < reading_time:
		if token != cutscene_token or not is_instance_valid(story): return
		if cutscene_advance_requested:
			cutscene_advance_requested = false
			break
		await get_tree().create_timer(0.05).timeout
		elapsed += 0.05

func cutscene_walk(hero: Sprite2D, target_x: float, duration: float) -> void:
	hero.texture=hero_textures.run
	hero.region_rect=hero_frame_rect("run",0)
	hero.flip_h=target_x<hero.position.x
	var start_x:=hero.position.x
	var tween:=create_tween().bind_node(hero)
	tween.tween_method(func(progress: float): hero.position.x=lerpf(start_x,target_x,progress); hero.region_rect=hero_frame_rect("run",int(progress*duration*10.0)),0.0,1.0,duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_callback(func(): hero.texture=hero_textures.idle; hero.region_rect=hero_frame_rect("idle",0))

func cutscene_portal_animation(portal_sprite: Sprite2D, token: int) -> void:
	for frame in 72:
		if token!=cutscene_token or not is_instance_valid(portal_sprite): return
		portal_sprite.region_rect=portal_frame_rect(frame%6); await get_tree().create_timer(0.075).timeout

func cutscene_wind(parent: Node2D, target: Vector2, hero: Sprite2D) -> void:
	for index in 22:
		var leaf:=Polygon2D.new(); leaf.polygon=PackedVector2Array([Vector2(-5,0),Vector2(0,-2),Vector2(6,0),Vector2(0,2)]); leaf.color=Color("#5cc98c") if index%2==0 else Color("#a8d66d"); leaf.position=Vector2(rng.randf_range(0,VIEW.x),rng.randf_range(90,510)); leaf.z_index=4; parent.add_child(leaf)
		var destination:=target+Vector2(rng.randf_range(-30,30),rng.randf_range(-80,80)); var wind:=create_tween().bind_node(leaf); wind.tween_property(leaf,"position",destination,rng.randf_range(0.65,1.4)).set_trans(Tween.TRANS_EXPO); wind.parallel().tween_property(leaf,"rotation",rng.randf_range(2.0,7.0),0.9); wind.parallel().tween_property(leaf,"modulate:a",0.0,1.1); wind.tween_callback(leaf.queue_free)
	var original_y:=hero.position.y; var shake:=create_tween().bind_node(hero); shake.tween_property(hero,"position:y",original_y-4,0.06); shake.tween_property(hero,"position:y",original_y+3,0.06); shake.set_loops(5)

func cutscene_guardian_visions(parent: Node2D, portal_position: Vector2) -> void:
	var kinds:=["badger_boss","cat_boss","pengu_boss"]
	var offsets:=[Vector2(-115,-128),Vector2(0,-158),Vector2(115,-128)]
	var colors:=[Color("#9bd16a"),Color("#ff9a5d"),Color("#8deaff")]
	for index in kinds.size():
		var animations: Dictionary=load_new_boss_animations(String(kinds[index]))
		var idle: Dictionary=animations.get("idle",{})
		if idle.is_empty(): continue
		var vision:=Sprite2D.new(); vision.name="GuardianVision%d"%index; vision.texture=idle.texture; vision.region_enabled=true; vision.region_rect=Rect2(0,0,int(idle.frame_width),128); vision.position=portal_position+offsets[index]; vision.scale=Vector2(0.72,0.72); vision.modulate=Color(colors[index],0.0); vision.z_index=4; vision.texture_filter=CanvasItem.TEXTURE_FILTER_NEAREST; parent.add_child(vision)
		var reveal:=create_tween().bind_node(vision); reveal.tween_interval(0.18*index); reveal.tween_property(vision,"modulate:a",0.62,0.24); reveal.parallel().tween_property(vision,"position:y",vision.position.y-10.0,0.42).set_trans(Tween.TRANS_SINE); reveal.tween_interval(1.25); reveal.tween_property(vision,"modulate:a",0.0,0.36); reveal.tween_callback(vision.queue_free)

func finish_origin_cutscene(token: int) -> void:
	if token!=cutscene_token: return
	cutscene_token += 1
	start_game()

func make_radial_light_texture(size: int) -> GradientTexture2D:
	var gradient := Gradient.new()
	gradient.colors=PackedColorArray([Color(1,1,1,1),Color(1,1,1,0)])
	gradient.offsets=PackedFloat32Array([0.0,1.0])
	var texture := GradientTexture2D.new()
	texture.gradient=gradient; texture.width=size; texture.height=size
	texture.fill=GradientTexture2D.FILL_RADIAL
	texture.fill_from=Vector2(0.5,0.5); texture.fill_to=Vector2(1.0,0.5)
	return texture

func continue_game() -> void:
	var save := ConfigFile.new()
	if save.load(SAVE_PATH) != OK:
		start_game()
		return
	var save_version := int(save.get_value("meta","version",1))
	if save_version> SAVE_VERSION:
		push_warning("Save criado por versão mais nova; valores serão carregados de forma conservadora.")
	level = clampi(int(save.get_value("journey","level",0)),0,levels.size()-1)
	max_health = clampi(int(save.get_value("journey","max_health",5)),5,8)
	health = clampf(float(save.get_value("journey","health",max_health)),0.25,float(max_health))
	speed_multiplier = clampf(float(save.get_value("journey","speed_multiplier",1.0)),1.0,1.15)
	dash_cooldown_multiplier = clampf(float(save.get_value("journey","dash_cooldown_multiplier",1.0)),0.70,1.0)
	run_time = clampf(float(save.get_value("journey","time",0.0)),0.0,86400.0)
	deaths = clampi(int(save.get_value("journey","deaths",0)),0,9999)
	difficulty_index = clampi(int(save.get_value("journey","difficulty",1)),0,DIFFICULTIES.size()-1)
	load_level()

func has_save() -> bool:
	return FileAccess.file_exists(SAVE_PATH)

func save_progress() -> void:
	var save := ConfigFile.new()
	save.set_value("meta","version",SAVE_VERSION)
	save.set_value("journey","level",level)
	save.set_value("journey","health",health)
	save.set_value("journey","max_health",max_health)
	save.set_value("journey","speed_multiplier",speed_multiplier)
	save.set_value("journey","dash_cooldown_multiplier",dash_cooldown_multiplier)
	save.set_value("journey","time",run_time)
	save.set_value("journey","deaths",deaths)
	save.set_value("journey","difficulty",difficulty_index)
	save.save(SAVE_PATH)

func load_settings() -> void:
	var settings := ConfigFile.new()
	if settings.load(SETTINGS_PATH) == OK:
		master_volume = clampf(float(settings.get_value("audio","master",0.8)),0.0,1.0)
		music_volume = clampf(float(settings.get_value("audio","music",0.75)),0.0,1.0)
		sfx_volume = clampf(float(settings.get_value("audio","sfx",0.85)),0.0,1.0)
		screen_shake = bool(settings.get_value("gameplay","screen_shake",true))
		flash_intensity = clampf(float(settings.get_value("gameplay","flash_intensity",0.75)),0.0,1.0)
		windowed_resolution = Vector2i(int(settings.get_value("display","width",BASE_RESOLUTION.x)),int(settings.get_value("display","height",BASE_RESOLUTION.y)))
		if not DISPLAY_RESOLUTIONS.has(windowed_resolution): windowed_resolution=BASE_RESOLUTION
		visual_scale = clampf(float(settings.get_value("display","visual_scale",1.0)),0.75,1.5)
		fullscreen_preference = bool(settings.get_value("display","fullscreen",false))
		if not embedded_run:
			if fullscreen_preference:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			else:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
				DisplayServer.window_set_size(windowed_resolution)
		for action in ["move_left","move_right","jump","attack","guard","dash","pause"]:
			var keycode := int(settings.get_value("controls",action,0))
			if keycode>0:
				replace_action_key(action,keycode)
	apply_settings()

func save_settings() -> void:
	var settings := ConfigFile.new()
	settings.load(SETTINGS_PATH)
	settings.set_value("audio","master",master_volume)
	settings.set_value("audio","music",music_volume)
	settings.set_value("audio","sfx",sfx_volume)
	settings.set_value("gameplay","screen_shake",screen_shake)
	settings.set_value("gameplay","flash_intensity",flash_intensity)
	settings.set_value("display","fullscreen",fullscreen_preference)
	settings.set_value("display","width",windowed_resolution.x)
	settings.set_value("display","height",windowed_resolution.y)
	settings.set_value("display","visual_scale",visual_scale)
	for action in ["move_left","move_right","jump","attack","guard","dash","pause"]:
		for event in InputMap.action_get_events(action):
			if event is InputEventKey:
				settings.set_value("controls",action,event.physical_keycode)
				break
	settings.save(SETTINGS_PATH)
	apply_settings()

func apply_settings() -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"),linear_to_db(maxf(master_volume,0.001)))
	AudioManager.set_music_volume(music_volume)
	AudioManager.set_sfx_volume(sfx_volume)
	get_window().content_scale_factor = visual_scale

func load_level() -> void:
	state = "playing"
	play_music(["Ambient 4.mp3","Dark Ambient 3.mp3","Action 1.mp3","Dark Ambient 3.mp3","Ambient 4.mp3","Dark Ambient 3.mp3"][level],-8.0 if not is_boss_level() else -6.0)
	clear_screen()
	coins = 0
	combo_step = 0
	combo_window = 0.0
	dash_time = 0.0
	dash_cooldown = 0.0
	var data := load_level_scene_data(level)
	if data.is_empty():
		data = levels[level].duplicate(true)
	current_level_data = data
	var map_scale := difficulty_value("map_scale")
	level_width = roundf(float(data.width)*map_scale)
	world = Node2D.new()
	world.name = "World"
	add_child(world)
	create_parallax()
	create_level_landmarks()
	create_ambient_life()
	if is_instance_valid(current_level_scene):
		world.add_child(current_level_scene)
		# A cena editavel agora tambem e a arte vista no jogo. Assim, qualquer
		# alteracao feita pelo professor no TileMap aparece ao executar a fase.
		current_level_scene.visible = true
		current_level_scene.scale = Vector2(map_scale,1.0)
	var terrain := current_level_scene.get_node_or_null("TileMap_Terreno_E_Plataformas") as TileMapLayer if is_instance_valid(current_level_scene) else null
	if terrain and terrain.get_used_cells().size()>0:
		create_platforms_from_tilemap(terrain,map_scale)
	else:
		for p in data.platforms:
			create_platform(scale_level_rect(p,map_scale))
	var visible_coins := scaled_visible_coin_positions(data,map_scale)
	total_coins = visible_coins.size()
	for pos in visible_coins:
		create_coin(pos)
	var enemy_entries := scaled_enemy_entries(data,map_scale)
	for e in enemy_entries:
		create_enemy(e[0],Vector2(e[1],e[2]))
	for secret_pos in data.get("secrets",[]):
		maybe_drop_life(secret_pos,true,true)
	var portal_position: Vector2 = data.get("portal_position",Vector2(float(data.width)-190.0,509.0))
	portal_position.x *= map_scale
	create_portal(portal_position)
	var player_position: Vector2 = data.get("player_position",Vector2(420,475) if is_boss_level() else Vector2(140,475))
	player_position.x *= map_scale
	create_player(player_position)
	checkpoint = player.position
	create_hud()
	show_banner(data.name, data.subtitle)
	if level==0 and not seen_attack_tips.has("movement"): call_deferred("show_onboarding_hint")
	if is_boss_level(): call_deferred("start_boss_intro",map_scale)

func load_level_scene_data(index: int) -> Dictionary:
	current_level_scene = null
	if index<0 or index>=LEVEL_SCENES.size(): return {}
	var packed := load(LEVEL_SCENES[index]) as PackedScene
	if not packed: return {}
	current_level_scene = packed.instantiate() as Node2D
	if not current_level_scene: return {}
	var result := {
		"name":String(current_level_scene.get_meta("nome",levels[index].name)),
		"subtitle":String(current_level_scene.get_meta("subtitulo",levels[index].subtitle)),
		"width":float(current_level_scene.get_meta("largura_base",levels[index].width)),
		"biome":String(current_level_scene.get_meta("bioma",levels[index].biome)),
		"theme":String(current_level_scene.get_meta("tema",levels[index].theme)),
		"platforms":[], "coins":[], "enemies":[], "secrets":[]
	}
	var points := current_level_scene.get_node_or_null("Pontos_Editaveis")
	if points:
		var start := points.get_node_or_null("INICIO_JORGINHO") as Marker2D
		var portal_marker := points.get_node_or_null("PORTAL_APARECE_AQUI") as Marker2D
		if start: result.player_position=start.position
		if portal_marker: result.portal_position=portal_marker.position
	var fragments := current_level_scene.get_node_or_null("Fragmentos")
	if fragments:
		for marker in fragments.get_children():
			if marker is Marker2D: result.coins.append(marker.position)
	var enemy_markers := current_level_scene.get_node_or_null("Inimigos")
	if enemy_markers:
		for marker in enemy_markers.get_children():
			if marker is Marker2D: result.enemies.append([String(marker.get_meta("tipo","mushroom")),marker.position.x,marker.position.y])
	var secrets := current_level_scene.get_node_or_null("Vidas_Secretas")
	if secrets:
		for marker in secrets.get_children():
			if marker is Marker2D: result.secrets.append(marker.position)
	return result

func create_platforms_from_tilemap(terrain: TileMapLayer, factor: float) -> void:
	var grid := Vector2(terrain.tile_set.tile_size)
	var cells := terrain.get_used_cells()
	var occupied := {}
	for cell in cells:
		occupied[cell]=true
	var top_rows := {}
	for cell in cells:
		if occupied.has(Vector2i(cell.x,cell.y-1)): continue
		if not top_rows.has(cell.y): top_rows[cell.y]=[]
		top_rows[cell.y].append(cell.x)
	var y_values := top_rows.keys()
	y_values.sort()
	for y_value in y_values:
		var x_values: Array=top_rows[y_value]
		x_values.sort()
		if x_values.is_empty(): continue
		var start_x := int(x_values[0])
		var previous_x := start_x
		for value_index in range(1,x_values.size()+1):
			var at_end := value_index>=x_values.size()
			var next_x := previous_x+2 if at_end else int(x_values[value_index])
			if next_x!=previous_x+1:
				var width_cells := previous_x-start_x+1
				var depth_cells := 1
				while true:
					var full_row := true
					for check_x in range(start_x,previous_x+1):
						if not occupied.has(Vector2i(check_x,int(y_value)+depth_cells)):
							full_row=false
							break
					if not full_row: break
					depth_cells += 1
				create_platform(Vector4(float(start_x)*grid.x*factor,float(y_value)*grid.y,float(width_cells)*grid.x*factor,float(depth_cells)*grid.y),false)
				start_x=next_x
			previous_x=next_x

func show_onboarding_hint() -> void:
	seen_attack_tips["movement"]=true
	await get_tree().create_timer(2.35).timeout
	if state=="playing" and level==0:
		flash_message("%s MOVER  •  %s PULAR  •  %s ATACAR" % [action_prompt("move_left"),action_prompt("jump"),action_prompt("attack")],Color("#c8f5dc"))

func scale_level_rect(rect: Vector4, factor: float) -> Vector4:
	return Vector4(rect.x*factor,rect.y,rect.z*factor,rect.w)

func scaled_visible_coin_positions(data: Dictionary, factor: float) -> Array[Vector2]:
	var result: Array[Vector2]=[]
	for source in data.coins:
		var candidate := Vector2(float(source.x)*factor,float(source.y))
		candidate.x=clampf(candidate.x,96.0,level_width-230.0)
		# Mantém cada fragmento longe do portal e sobre uma área visível do caminho.
		if candidate.distance_to(Vector2(level_width-190.0,509.0))<170.0: candidate.x=level_width-390.0
		result.append(candidate)
	return result

func scaled_enemy_entries(data: Dictionary, factor: float) -> Array:
	var result: Array=[]
	for entry in data.enemies:
		result.append([entry[0],float(entry[1])*factor,float(entry[2])])
	if is_boss_level(): return result
	var desired := maxi(result.size(),ceili(float(result.size())*difficulty_value("enemy_population")))
	var extras := desired-result.size()
	for index in extras:
		var source: Array=data.enemies[index%data.enemies.size()]
		var section := float(index+1)/float(extras+1)
		var x := clampf(420.0+section*(level_width-840.0)+float((index%3)-1)*95.0,300.0,level_width-310.0)
		var y := float(source[2]) if String(source[0])=="flying" else 505.0
		result.append([source[0],x,y])
	return result

func is_boss_level(index: int = level) -> bool:
	return index>=0 and index<levels.size() and String(levels[index].get("biome","")).ends_with("_boss")

func arena_left() -> float:
	return 300.0

func arena_right() -> float:
	return level_width-36.0

func arena_x(ratio: float) -> float:
	return lerpf(arena_left(),arena_right(),clampf(ratio,0.0,1.0))

func current_boss_name() -> String:
	var boss := get_boss()
	if boss.is_empty(): return "GUARDIÃO"
	return {"badger_boss":"BADGER, O ESCAVADOR","cat_boss":"CAT, O ARTILHEIRO","pengu_boss":"PENGU, REI DO INVERNO"}.get(String(boss.kind),"GUARDIÃO")

func current_boss_short_name() -> String:
	var boss := get_boss()
	if boss.is_empty(): return "GUARDIÃO"
	return {"badger_boss":"BADGER","cat_boss":"CAT","pengu_boss":"PENGU"}.get(String(boss.kind),"GUARDIÃO")

func start_boss_intro(map_scale := 1.0) -> void:
	state = "boss_intro"
	player.velocity = Vector2.ZERO
	create_arena_barrier(arena_left())
	create_boss_arena_ambience()
	var boss := get_boss()
	if not boss.is_empty():
		var boss_body: CharacterBody2D = boss.node
		# Mantém a posição definida no marcador da cena da fase.
		boss_body.position.y = 480.0
		boss_body.visible = true
		boss.sprite.modulate = Color(0.28,0.28,0.32,1.0)
	await get_tree().create_timer(1.1).timeout
	if not boss.is_empty() and is_instance_valid(boss.node):
		boss.sprite.modulate = Color.WHITE
		create_shockwave(boss.node.position)
		spawn_sheet_fx(FX_ARC,boss.node.global_position+Vector2(0,-28),22,2 if String(boss.kind)=="pengu_boss" else (0 if String(boss.kind)=="cat_boss" else 3),Vector2(2.2,2.2),0.48)
	play_music("Action 1.mp3",-5.0)
	state = "playing"

func create_arena_barrier(x_position: float) -> void:
	# Limites altos e invisíveis: integram-se ao enquadramento e não podem ser saltados.
	for entry in [[x_position,"BossArenaBoundaryLeft"],[level_width-18.0,"BossArenaBoundaryRight"]]:
		var barrier := StaticBody2D.new()
		barrier.name = String(entry[1])
		barrier.position = Vector2(float(entry[0]),250)
		var collision := CollisionShape2D.new()
		var shape := RectangleShape2D.new()
		shape.size=Vector2(42,920)
		collision.shape=shape
		barrier.add_child(collision)
		world.add_child(barrier)

func create_boss_arena_ambience() -> void:
	var boss := get_boss()
	var boss_kind := String(boss.get("kind","badger_boss"))
	var primary: Color = {"badger_boss":Color("#7fca55"),"cat_boss":Color("#ff7a38"),"pengu_boss":Color("#65d8ff")}.get(boss_kind,Color("#c36cff"))
	var secondary: Color = {"badger_boss":Color("#d95549"),"cat_boss":Color("#ffd15c"),"pengu_boss":Color("#a979ff")}.get(boss_kind,Color("#55d6be"))
	create_boss_arena_backdrop(boss_kind,primary)
	for index in 22:
		var mote := Polygon2D.new()
		mote.polygon = PackedVector2Array([Vector2(0,-4),Vector2(3,0),Vector2(0,4),Vector2(-3,0)])
		mote.color = Color(primary.r,primary.g,primary.b,0.12+float(index%4)*0.04) if index%2==0 else Color(secondary.r,secondary.g,secondary.b,0.12)
		mote.position = Vector2(rng.randf_range(arena_left()+60.0,arena_right()-60.0),rng.randf_range(180,520))
		mote.z_index = 2
		world.add_child(mote)
		var start := mote.position
		var drift := create_tween().bind_node(mote).set_loops()
		drift.tween_property(mote,"position",start+Vector2(rng.randf_range(-28,28),-rng.randf_range(45,100)),rng.randf_range(1.8,3.6)).set_trans(Tween.TRANS_SINE)
		drift.tween_property(mote,"position",start,rng.randf_range(1.8,3.6)).set_trans(Tween.TRANS_SINE)
	create_boss_arena_landmarks(boss_kind,primary,secondary)

func create_boss_arena_backdrop(kind: String, primary: Color) -> void:
	var file_name: String = {"badger_boss":"badger_background.png","cat_boss":"cat_background.png","pengu_boss":"pengu_background.png"}.get(kind,"")
	if file_name.is_empty(): return
	var texture: Texture2D = load("res://assets/selected/boss_arenas/"+file_name)
	if texture==null: return
	var layer := Parallax2D.new()
	layer.name="BossArenaBackdrop"
	layer.scroll_scale=Vector2(0.08,0.04)
	layer.repeat_size=Vector2(900,0)
	layer.repeat_times=4
	layer.z_index=-10
	world.add_child(layer)
	var sprite := Sprite2D.new()
	sprite.texture=texture
	var target_height := 520.0
	var scale_value := target_height/float(texture.get_height())
	sprite.scale=Vector2(scale_value,scale_value)
	sprite.position=Vector2(float(texture.get_width())*scale_value*0.5,292)
	sprite.modulate=Color(primary.r*0.55+0.38,primary.g*0.55+0.38,primary.b*0.55+0.38,0.92)
	layer.repeat_size.x=float(texture.get_width())*scale_value
	layer.add_child(sprite)

func create_boss_arena_landmarks(kind: String, primary: Color, secondary: Color) -> void:
	var arena_title := Label.new()
	arena_title.position=Vector2(arena_x(0.5)-460,186)
	arena_title.size=Vector2(920,52)
	arena_title.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER
	arena_title.text={"badger_boss":"COVIL EM COLAPSO","cat_boss":"ZONA DE TIRO","pengu_boss":"TEMPESTADE ETERNA"}.get(kind,"ARENA")
	arena_title.add_theme_font_override("font",DISPLAY_FONT)
	arena_title.add_theme_font_size_override("font_size",22)
	arena_title.add_theme_color_override("font_color",Color(primary.r,primary.g,primary.b,0.30))
	arena_title.z_index=0
	world.add_child(arena_title)
	# Decoração baixa e temática; não compete com os telegraphs de combate.
	if kind=="badger_boss":
		for ratio in [0.12,0.38,0.64,0.88]:
			var x := arena_x(ratio)
			var roots := Line2D.new()
			roots.points=PackedVector2Array([Vector2(-62,0),Vector2(-34,-13),Vector2(-8,-4),Vector2(22,-18),Vector2(66,0)])
			roots.position=Vector2(x,550); roots.width=6.0; roots.default_color=Color(0.25,0.16,0.08,0.68); roots.z_index=0; world.add_child(roots)
	elif kind=="cat_boss":
		for ratio in [0.12,0.31,0.50,0.69,0.88]:
			var x := arena_x(ratio)
			var hazard := Line2D.new()
			hazard.points=PackedVector2Array([Vector2(-70,0),Vector2(70,0)])
			hazard.position=Vector2(x,548); hazard.width=12.0; hazard.default_color=Color("#ff6a2d"); hazard.z_index=3; world.add_child(hazard)
			for stripe in 5:
				var mark := Line2D.new(); mark.points=PackedVector2Array([Vector2(-7,5),Vector2(7,-5)]); mark.position=Vector2(x-52+stripe*26,548); mark.width=5.0; mark.default_color=Color("#25130c"); mark.z_index=4; world.add_child(mark)
	else:
		for ratio in [0.10,0.28,0.50,0.70,0.90]:
			var x := arena_x(ratio)
			var shard := Polygon2D.new()
			var height := 48.0+float(int(x)%3)*15.0
			shard.polygon=PackedVector2Array([Vector2(-24,0),Vector2(-12,-height*0.55),Vector2(0,-height),Vector2(17,-height*0.42),Vector2(27,0)])
			shard.position=Vector2(x,558); shard.color=Color(primary.r,primary.g,primary.b,0.38); shard.z_index=-1; world.add_child(shard)
			var edge := Line2D.new(); edge.points=PackedVector2Array([Vector2(0,-height),Vector2(0,-7)]); edge.position=shard.position; edge.width=3.0; edge.default_color=Color(secondary.r,secondary.g,secondary.b,0.62); edge.z_index=0; world.add_child(edge)

func create_parallax() -> void:
	var sky := ColorRect.new()
	var sky_colors := [Color("#20250d"),Color("#13240d"),Color("#071a20"),Color("#2a130d"),Color("#071c31"),Color("#07142b")]
	sky.color = sky_colors[level]
	sky.position = Vector2(-1000,-300)
	sky.size = Vector2(level_width+2000,1000)
	sky.z_index = -20
	world.add_child(sky)
	var back_tint: Color = [Color(0.58,0.67,0.42,1.0),Color(0.42,0.58,0.30,0.96),Color(0.23,0.48,0.55,0.94),Color(0.55,0.28,0.18,0.94),Color(0.26,0.54,0.74,0.96),Color(0.32,0.52,0.82,0.98)][level]
	var middle_tint: Color = [Color(0.82,0.94,0.70,0.98),Color(0.65,0.82,0.42,0.96),Color(0.33,0.66,0.68,0.94),Color(0.84,0.38,0.20,0.96),Color(0.44,0.76,0.92,0.96),Color(0.55,0.75,1.0,0.98)][level]
	add_world_parallax_layer("back.png",2.40,Vector2(0.10,0.06),back_tint,-17)
	add_world_parallax_layer("middle.png",2.40,Vector2(0.30,0.14),middle_tint,-12)
	# As fases de travessia ganham o mesmo horizonte da arena que preparam.
	# Isso cria continuidade: a forja conduz ao arsenal e o abismo conduz ao
	# trono gelado, sem deixar um bosque verde por tras de pisos industriais.
	if level==2:
		create_boss_arena_backdrop("cat_boss",Color("#d46538"))
	elif level==4:
		create_boss_arena_backdrop("pengu_boss",Color("#65bde8"))
	var atmosphere := ColorRect.new()
	atmosphere.position = Vector2(-500,-100)
	atmosphere.size = Vector2(level_width+1000,748)
	atmosphere.color = [Color(0.08,0.22,0.05,0.05),Color(0.12,0.30,0.04,0.14),Color(0.00,0.10,0.18,0.22),Color(0.42,0.08,0.02,0.20),Color(0.02,0.18,0.38,0.20),Color(0.02,0.24,0.48,0.24)][level]
	atmosphere.z_index = -1
	atmosphere.mouse_filter = Control.MOUSE_FILTER_IGNORE
	world.add_child(atmosphere)

func add_world_parallax_layer(file_name: String, scale_value: float, scroll: Vector2, tint: Color, z: int) -> void:
	var texture: Texture2D = load(ILLUSION_PATH+file_name)
	var layer := Parallax2D.new()
	layer.name = "WorldParallax_%s" % file_name.get_basename()
	layer.scroll_scale = scroll
	layer.repeat_size = Vector2(float(texture.get_width())*scale_value,0.0)
	layer.repeat_times = 4
	layer.z_index = z
	world.add_child(layer)
	var sprite := Sprite2D.new()
	sprite.texture = texture
	sprite.scale = Vector2(scale_value,scale_value)
	sprite.position = Vector2(float(texture.get_width())*scale_value*0.5,float(texture.get_height())*scale_value*0.5)
	sprite.modulate = tint
	layer.add_child(sprite)

func create_level_landmarks() -> void:
	# Poucos elementos grandes e intencionais substituem a mistura anterior de
	# arvores, placas industriais e cristais vetoriais. Todos vem do mesmo pack.
	var prop_texture: Texture2D = load(FOUR_SEASONS_PATH+"four-seasons-platformer-01.png")
	if prop_texture==null: return
	var props: Array = []
	match level:
		0:
			props = [[Rect2(64,16,32,48),Vector2(760,512),2.0],[Rect2(16,16,16,48),Vector2(1880,512),2.0],[Rect2(64,16,32,48),Vector2(2860,512),2.0]]
		1:
			props = [[Rect2(96,16,16,48),Vector2(520,512),2.0],[Rect2(96,16,16,48),Vector2(1770,512),2.0]]
		2:
			props = [[Rect2(0,64,16,32),Vector2(760,528),2.0],[Rect2(16,64,16,32),Vector2(1880,528),2.0],[Rect2(32,64,16,32),Vector2(3020,528),2.0]]
		3:
			props = [[Rect2(16,64,16,32),Vector2(560,528),2.0],[Rect2(32,64,16,32),Vector2(1660,528),2.0]]
		4:
			props = [[Rect2(96,16,16,48),Vector2(700,512),2.0],[Rect2(96,16,16,48),Vector2(2050,512),2.0],[Rect2(96,16,16,48),Vector2(3050,512),2.0]]
		5:
			props = [[Rect2(96,16,16,48),Vector2(520,512),2.0],[Rect2(96,16,16,48),Vector2(1850,512),2.0]]
	for prop_data in props:
		var prop := Sprite2D.new()
		prop.texture = prop_texture
		prop.region_enabled = true
		prop.region_rect = prop_data[0]
		prop.position = prop_data[1]
		prop.scale = Vector2.ONE*float(prop_data[2])
		prop.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		prop.modulate = Color(0.82,0.90,0.84,0.78) if level in [1,5] else Color(0.94,0.96,0.90,0.88)
		prop.z_index = 0
		world.add_child(prop)

func create_level_landmarks_legacy() -> void:
	if level in [0,1]:
		# Duas ilhas visuais marcam desvios reais, sem árvores aleatórias sobre o caminho.
		for marker in [Vector2(940,347),Vector2(1970,327)]:
			var root_island := Sprite2D.new()
			root_island.texture = load(ILLUSION_PATH+"island.png")
			root_island.position = marker
			root_island.modulate = Color(0.78,0.90,0.68,0.82)
			root_island.z_index = -2
			world.add_child(root_island)
	elif level in [2,3]:
		var light_positions := [Vector2(420,420),Vector2(1480,360),Vector2(2440,420),Vector2(3300,400)] if level in [2,4] else [Vector2(420,430),Vector2(1040,370),Vector2(1660,410)]
		for light_pos in light_positions:
			var glow := Polygon2D.new()
			var points := PackedVector2Array()
			for point_index in 20:
				var angle := TAU*float(point_index)/20.0
				points.append(Vector2(cos(angle)*52.0,sin(angle)*52.0))
			glow.polygon = points
			glow.position = light_pos
			glow.color = Color(0.18,0.78,0.78,0.10) if level==2 else (Color(1.0,0.30,0.10,0.12) if level==3 else Color(0.18,0.68,1.0,0.13))
			glow.z_index = -3
			world.add_child(glow)
			var lamp := Sprite2D.new()
			lamp.texture = load(TRAPMOOR_PATH+"WallLight32x32Spritesheet.png")
			lamp.region_enabled = true
			lamp.region_rect = Rect2(0,0,32,32)
			lamp.position = light_pos
			lamp.scale = Vector2(2.0,2.0)
			lamp.modulate = Color(0.72,0.94,0.92,0.78)
			lamp.z_index = -2
			world.add_child(lamp)
		# O pack Kenney entra apenas como sinalização secundária: silhueta simples,
		# pequena e atrás da navegação, sem misturar seu tilemap ao Trapmoor.
		for prop_data in [[Vector2(790,518),"warning.png"],[Vector2(1890,518),"beacon_red.png"],[Vector2(level_width-470,518),"warning.png"]]:
			var prop := Sprite2D.new()
			prop.texture=load(KENNEY_INDUSTRIAL_PATH+String(prop_data[1]))
			prop.position=prop_data[0]
			prop.scale=Vector2(1.35,1.35)
			prop.modulate=Color(0.78,0.73,0.66,0.82)
			prop.z_index=1
			world.add_child(prop)
	else:
		# Gelo mantém linguagem própria; cristais estilizados substituem as antigas luminárias industriais.
		for x in [430.0,1320.0,2240.0,level_width-390.0]:
			var crystal := Polygon2D.new()
			crystal.polygon=PackedVector2Array([Vector2(-18,0),Vector2(-9,-46),Vector2(0,-70),Vector2(14,-38),Vector2(20,0)])
			crystal.position=Vector2(x,548)
			crystal.color=Color("#4bb5dc") if int(x)%2==0 else Color("#86e6ff")
			crystal.modulate.a=0.54
			crystal.z_index=1
			world.add_child(crystal)

func create_ambient_life() -> void:
	var count := 22 if not is_boss_level() else 14
	var colors: Array[Color]
	if level in [0,1]: colors=[Color("#c9ff79"),Color("#62e0a1"),Color("#ffe686")]
	elif level in [2,3]: colors=[Color("#ff9a4e"),Color("#ffc75d"),Color("#8de3de")]
	else: colors=[Color("#d8f6ff"),Color("#77c8ff"),Color("#c8a8ff")]
	for index in count:
		var mote := Polygon2D.new()
		mote.name = "VidaAmbiente%d" % index
		var mote_size := 2.0+float(index%3)
		mote.polygon = PackedVector2Array([Vector2(0,-mote_size),Vector2(mote_size,0),Vector2(0,mote_size),Vector2(-mote_size,0)])
		mote.color = Color(colors[index%colors.size()],0.22+float(index%4)*0.08)
		mote.position = Vector2(70.0+fmod(float(index)*173.0,level_width-140.0),180.0+fmod(float(index)*71.0,310.0))
		mote.z_index = -1 if index%3 else 4
		world.add_child(mote)
		var origin := mote.position
		var drift_x := 20.0+float(index%5)*9.0
		var drift_y := -18.0-float(index%4)*8.0 if level not in [3] else -42.0-float(index%4)*10.0
		var duration := 2.2+float(index%5)*0.36
		var drift := create_tween().bind_node(mote).set_loops()
		drift.tween_property(mote,"position",origin+Vector2(drift_x,drift_y),duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		drift.parallel().tween_property(mote,"rotation",PI, duration)
		drift.tween_property(mote,"position",origin,duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		drift.parallel().tween_property(mote,"rotation",TAU,duration)

func four_seasons_platform_profile() -> Dictionary:
	# Coordenadas em tiles 16x16. Cada fase usa uma paleta do mesmo pack para
	# manter variedade de bioma sem trocar de linguagem visual.
	return [
		{"texture":"four-seasons-platformer-07.png","thin":[Vector2i(0,0),Vector2i(1,0),Vector2i(2,0)],"top":[Vector2i(0,2),Vector2i(1,2),Vector2i(2,2)],"body":[Vector2i(7,3),Vector2i(7,3),Vector2i(7,3)]},
		{"texture":"four-seasons-platformer-07.png","thin":[Vector2i(0,5),Vector2i(1,5),Vector2i(2,5)],"top":[Vector2i(0,7),Vector2i(1,7),Vector2i(2,7)],"body":[Vector2i(7,8),Vector2i(7,8),Vector2i(7,8)]},
		{"texture":"four-seasons-platformer-12.png","thin":[Vector2i(0,15),Vector2i(1,15),Vector2i(2,15)],"top":[Vector2i(0,17),Vector2i(1,17),Vector2i(2,17)],"body":[Vector2i(1,18),Vector2i(1,18),Vector2i(1,18)]},
		{"texture":"four-seasons-platformer-11.png","thin":[Vector2i(0,0),Vector2i(1,0),Vector2i(5,0)],"top":[Vector2i(0,3),Vector2i(1,3),Vector2i(5,3)],"body":[Vector2i(4,5),Vector2i(4,5),Vector2i(4,5)]},
		{"texture":"four-seasons-platformer-06.png","thin":[Vector2i(3,0),Vector2i(4,0),Vector2i(5,0)],"top":[Vector2i(6,18),Vector2i(7,18),Vector2i(8,18)],"body":[Vector2i(7,18),Vector2i(7,18),Vector2i(7,18)]},
		{"texture":"four-seasons-platformer-06.png","thin":[Vector2i(0,5),Vector2i(1,5),Vector2i(2,5)],"top":[Vector2i(0,7),Vector2i(1,7),Vector2i(2,7)],"body":[Vector2i(7,8),Vector2i(7,8),Vector2i(7,8)]}
	][level]

func platform_tile_coordinate(options: Array, column: int, column_count: int) -> Vector2i:
	if column==0: return options[0]
	if column==column_count-1: return options[2]
	return options[1]

func draw_four_seasons_platform(body: StaticBody2D, rect: Vector4, collision_height: float, is_ground: bool) -> void:
	var profile := four_seasons_platform_profile()
	var texture: Texture2D = load(FOUR_SEASONS_PATH+String(profile.texture))
	if texture==null: return
	var world_tile := 16.0
	var columns := maxi(1,ceili(rect.z/world_tile))
	var rows := maxi(1,ceili(rect.w/world_tile)) if is_ground else 1
	var visual_width := float(columns)*world_tile
	for row in rows:
		for column in columns:
			var coordinate: Vector2i
			if not is_ground:
				coordinate = platform_tile_coordinate(profile.thin,column,columns)
			elif row==0:
				coordinate = platform_tile_coordinate(profile.top,column,columns)
			else:
				coordinate = platform_tile_coordinate(profile.body,column,columns)
			var tile := Sprite2D.new()
			tile.texture = texture
			tile.region_enabled = true
			tile.region_rect = Rect2(coordinate.x*16,coordinate.y*16,16,16)
			tile.position = Vector2(-visual_width*0.5+(float(column)+0.5)*world_tile,-collision_height*0.5+(float(row)+0.5)*world_tile)
			tile.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
			tile.z_index = 1
			body.add_child(tile)

func create_platform(rect: Vector4, draw_visual := true) -> void:
	var is_ground := rect.y>=550.0 and rect.z>=level_width*0.85
	var collision_height := rect.w if is_ground else 14.0
	var body := StaticBody2D.new()
	body.z_index = 2
	body.position = Vector2(rect.x + rect.z/2.0, rect.y + collision_height/2.0)
	var collision := CollisionShape2D.new()
	var shape := RectangleShape2D.new()
	shape.size = Vector2(rect.z,collision_height)
	collision.shape = shape
	if not is_ground:
		collision.one_way_collision = true
		collision.one_way_collision_margin = 10.0
	body.add_child(collision)
	if draw_visual:
		draw_four_seasons_platform(body,rect,collision_height,is_ground)
	world.add_child(body)

func create_player(pos: Vector2) -> void:
	player = CharacterBody2D.new()
	player.name = "Jorginho"
	player.position = pos
	player.z_index = 10
	player.collision_layer = 2
	player.collision_mask = 1
	var col := CollisionShape2D.new()
	var shape := CapsuleShape2D.new()
	shape.radius = 18
	shape.height = 64
	col.shape = shape
	col.position.y = 3
	player.add_child(col)
	player_sprite = Sprite2D.new()
	player_sprite.texture = hero_textures.idle
	player_sprite.region_enabled = true
	player_sprite.region_rect = hero_frame_rect("idle",0)
	player_sprite.scale = Vector2(1.35,1.35)
	# O pixel mais baixo do herói está em y=79 dentro do frame 128x128.
	# Este deslocamento alinha visualmente os pés ao fundo da cápsula física.
	player_sprite.position.y = -5
	player_sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	player.add_child(player_sprite)
	# Sem luz local: ela criava um retângulo escuro acompanhando a câmera em GL Compatibility.
	camera = Camera2D.new()
	camera.position = Vector2(64,-40)
	camera.position_smoothing_enabled = true
	camera.position_smoothing_speed = 6.0
	camera.limit_left = 0
	camera.limit_right = int(level_width)
	camera.limit_top = 0
	camera.limit_bottom = 648
	player.add_child(camera)
	world.add_child(player)
	jumps_left = 2
	was_on_floor = false

func create_coin(pos: Vector2) -> void:
	var area := Area2D.new()
	area.position = pos
	area.z_index = 18
	area.collision_layer = 0
	area.collision_mask = 2
	area.monitoring = true
	area.set_meta("base_position",pos)
	area.set_meta("phase",rng.randf_range(0.0,TAU))
	var col := CollisionShape2D.new()
	var shape := CircleShape2D.new()
	shape.radius = 27
	col.shape = shape
	area.add_child(col)
	var aura := Line2D.new()
	aura.name = "Aura"
	var aura_points := PackedVector2Array()
	for i in 25:
		var a := TAU*float(i)/24.0
		aura_points.append(Vector2(cos(a)*23.0,sin(a)*23.0))
	aura.points = aura_points
	aura.width = 3.0
	aura.default_color = Color(0.45,1.0,0.82,0.34)
	area.add_child(aura)
	var crystal := Sprite2D.new()
	crystal.name = "Crystal"
	crystal.texture = PORTAL_FRAGMENT
	crystal.scale = Vector2(2.25,2.25)
	area.add_child(crystal)
	for i in 3:
		var mote := Polygon2D.new()
		mote.polygon = PackedVector2Array([Vector2(0,-2),Vector2(2,0),Vector2(0,2),Vector2(-2,0)])
		mote.color = Color("#fff3ad")
		mote.position = Vector2(cos(TAU*i/3.0)*30,sin(TAU*i/3.0)*17)
		mote.set_meta("orbit",TAU*i/3.0)
		area.add_child(mote)
	area.body_entered.connect(func(body): if body == player: collect_coin(area))
	world.add_child(area)
	coin_nodes.append(area)

func collect_coin(area: Area2D) -> void:
	if not is_instance_valid(area) or area.has_meta("collected"): return
	area.set_meta("collected",true)
	area.set_deferred("monitoring",false)
	coins += 1
	coin_nodes.erase(area)
	create_collect_burst(area.position)
	create_floating_text(area.position,"+1 FRAGMENTO",Color("#ffe15b"))
	play_ui_sound("fragment_pickup.wav",-10.0,rng.randf_range(0.96,1.08))
	var pickup := create_tween().bind_node(area)
	pickup.tween_property(area,"scale",Vector2(1.7,1.7),0.10).set_trans(Tween.TRANS_BACK)
	pickup.parallel().tween_property(area,"modulate:a",0.0,0.16)
	pickup.tween_callback(area.queue_free)
	update_hud()
	pulse_fragment_feedback()
	flash_message("FRAGMENTO ENCONTRADO  %d/%d" % [coins,total_coins], Color("#ffe28a"))
	update_portal_charge()
	if coins == total_coins:
		set_portal_active()
		flash_message("PORTAL DESBLOQUEADO!", Color("#7dffcf"))

func pulse_fragment_feedback() -> void:
	if is_instance_valid(portal_charge_bar):
		var pulse := create_tween().bind_node(portal_charge_bar)
		pulse.tween_property(portal_charge_bar,"modulate",Color("#ffffff"),0.05)
		pulse.tween_property(portal_charge_bar,"modulate",Color("#75f5d7"),0.10)
		pulse.tween_property(portal_charge_bar,"modulate",Color.WHITE,0.18)
	if is_instance_valid(coin_label):
		var label_pulse := create_tween().bind_node(coin_label)
		label_pulse.tween_property(coin_label,"scale",Vector2(1.12,1.12),0.08).set_trans(Tween.TRANS_BACK)
		label_pulse.tween_property(coin_label,"scale",Vector2.ONE,0.15)

func create_floating_text(pos: Vector2, text_value: String, color: Color) -> void:
	var label := Label.new()
	label.text = text_value
	label.position = pos-Vector2(55,38)
	label.size = Vector2(110,30)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size",15)
	label.add_theme_color_override("font_color",color)
	label.z_index = 30
	world.add_child(label)
	var float_up := create_tween().bind_node(label)
	float_up.tween_property(label,"position:y",label.position.y-34.0,0.46).set_trans(Tween.TRANS_QUAD)
	float_up.parallel().tween_property(label,"modulate:a",0.0,0.46)
	float_up.tween_callback(label.queue_free)

func set_portal_active() -> void:
	if not is_instance_valid(portal): return
	if portal.has_meta("active"): return
	portal.set_meta("active",true)
	portal.visible = true
	portal.monitoring = true
	portal.scale = Vector2(0.72,0.72)
	play_ui_sound("portal_open.wav",-8.0)
	portal.modulate = Color.WHITE
	var portal_art := portal.get_node_or_null("VisualRoot/PortalArt") as Sprite2D
	if portal_art:
		portal_art.modulate=Color(1.08,1.08,1.12,1.0)
	create_portal_activation_fx()
	var label: Label = portal.get_node_or_null("PortalLabel")
	if label:
		label.text = "LIMIAR DESPERTO\nATRAVESSE"
		label.add_theme_color_override("font_color",Color("#fff0a8"))
	var core: Polygon2D = portal.get_node_or_null("VisualRoot/Core")
	if core: core.color.a = 0.62
	for ring_name in ["Ring0","Ring1"]:
		var ring: Line2D = portal.get_node_or_null("VisualRoot/"+ring_name)
		if ring: ring.default_color.a = 0.96
	var rune_container := portal.get_node_or_null("VisualRoot/Runas")
	if rune_container:
		for child in rune_container.get_children():
			var rune := child as Polygon2D
			if rune: rune.modulate.a=1.0
	if is_instance_valid(portal_charge_bar): portal_charge_bar.value=portal_charge_bar.max_value
	var reveal := create_tween().bind_node(portal)
	reveal.tween_property(portal,"modulate:a",1.0,0.24)
	reveal.parallel().tween_property(portal,"scale",Vector2(1.08,1.08),0.30).set_trans(Tween.TRANS_BACK)
	reveal.tween_property(portal,"scale",Vector2.ONE,0.18)

func update_portal_charge() -> void:
	if not is_instance_valid(portal) or total_coins<=0: return
	var ratio := float(coins)/float(total_coins)
	if is_instance_valid(portal_charge_bar): portal_charge_bar.value=coins

func create_portal_activation_fx() -> void:
	if not is_instance_valid(portal): return
	for i in mini(total_coins,12):
		var energy := Polygon2D.new()
		energy.polygon = PackedVector2Array([Vector2(0,-5),Vector2(4,0),Vector2(0,5),Vector2(-4,0)])
		energy.color = Color("#ffe365") if i%2==0 else Color("#c77cff")
		energy.global_position = player.global_position+Vector2(rng.randf_range(-55,55),rng.randf_range(-70,20))
		energy.z_index = 30
		world.add_child(energy)
		var travel := create_tween().bind_node(energy)
		travel.tween_interval(float(i)*0.045)
		travel.tween_property(energy,"global_position",portal.global_position,0.48).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
		travel.parallel().tween_property(energy,"scale",Vector2(0.25,0.25),0.48)
		travel.tween_callback(energy.queue_free)
	var pulse := create_tween().bind_node(portal)
	pulse.tween_property(portal,"scale",Vector2(1.12,1.12),0.20).set_trans(Tween.TRANS_BACK)
	pulse.tween_property(portal,"scale",Vector2.ONE,0.28)

func create_collect_burst(pos: Vector2) -> void:
	for i in 10:
		var spark := Polygon2D.new()
		spark.polygon = PackedVector2Array([Vector2(0,-3),Vector2(2,0),Vector2(0,3),Vector2(-2,0)])
		spark.color = Color("#fff3ad") if i%2==0 else Color("#72e2c3")
		spark.position = pos
		spark.z_index = 12
		world.add_child(spark)
		var angle := TAU*float(i)/10.0
		var target := pos+Vector2(cos(angle),sin(angle))*rng.randf_range(36,70)
		var tween := create_tween()
		tween.tween_property(spark,"position",target,0.32).set_trans(Tween.TRANS_QUAD)
		tween.parallel().tween_property(spark,"modulate:a",0.0,0.32)
		tween.tween_callback(spark.queue_free)

func create_enemy(kind: String, pos: Vector2) -> void:
	var body := CharacterBody2D.new()
	body.name = ("%sBoss" % kind.trim_suffix("_boss").capitalize() if is_boss_kind(kind) else "%sEnemy" % kind.capitalize())
	body.position = pos
	body.z_index = 7
	body.collision_layer = 4
	body.collision_mask = 1
	var col := CollisionShape2D.new()
	var foot_y := 24.0
	var sensor_half_width := 24.0
	if kind == "mushroom":
		var shape := RectangleShape2D.new()
		shape.size = Vector2(38,42)
		col.shape = shape
		col.position.y = 1
		foot_y = 22.0
		sensor_half_width = 20.0
	elif kind == "spore":
		var shape := RectangleShape2D.new()
		shape.size = Vector2(34,34)
		col.shape = shape
		foot_y = 17.0
		sensor_half_width = 18.0
	elif kind == "flying":
		var shape := CapsuleShape2D.new()
		shape.radius = 20
		shape.height = 48
		col.shape = shape
		col.position = Vector2(1,0)
	elif is_boss_kind(kind):
		var shape := CapsuleShape2D.new()
		shape.radius = 32
		shape.height = 82
		col.shape = shape
		col.position = Vector2(0,-2)
		foot_y = 40.0
		sensor_half_width = 34.0
	else:
		var shape := CapsuleShape2D.new()
		shape.radius = 23
		shape.height = 52
		col.shape = shape
		foot_y = 26.0
		sensor_half_width = 24.0
	body.add_child(col)
	var sprite := Sprite2D.new()
	var frame_width := 80
	var frame_height := 64
	var frames := 7
	var animations := {}
	if kind == "mushroom":
		sprite.texture = load("res://assets/enemies/mushroom.png")
		sprite.scale = Vector2(1.35,1.35)
		sprite.position.y = -21
	elif kind == "flying":
		sprite.texture = load("res://assets/enemies/flying.png")
		frame_width = 64
		frames = 8
		sprite.scale = Vector2(1.10,1.10)
		sprite.position.y = -1
	elif kind in ["bramble","sentinel"]:
		animations = load_guardian_animations(kind)
		sprite.texture = animations.idle
		frame_width = 96
		frame_height = 96
		frames = 4
		sprite.scale = {"bramble":Vector2(0.95,0.95),"sentinel":Vector2(1.20,1.20)}[kind]
		sprite.position.y = foot_y-48.0*sprite.scale.y
	elif is_boss_kind(kind):
		animations = load_new_boss_animations(kind)
		var idle_data: Dictionary = animations.idle
		sprite.texture = idle_data.texture
		frame_width = int(idle_data.frame_width)
		frame_height = 128
		frames = int(idle_data.frames)
		sprite.scale = {"badger_boss":Vector2(1.28,1.28),"cat_boss":Vector2(1.32,1.32),"pengu_boss":Vector2(1.42,1.42)}.get(kind,Vector2(1.3,1.3))
		sprite.position.y = foot_y-64.0*sprite.scale.y
	elif kind == "skeleton":
		animations = {
			"idle":load(TRAPMOOR_PATH+"animations/skeleton_idle.png"),
			"walk":load(TRAPMOOR_PATH+"animations/skeleton_walk.png"),
			"attack":load(TRAPMOOR_PATH+"animations/skeleton_attack.png"),
			"hurt":load(TRAPMOOR_PATH+"animations/skeleton_idle.png")
		}
		sprite.texture = animations.idle
		frame_width = 32
		frame_height = 24
		frames = 8
		sprite.scale = Vector2(2.0,2.0)
		sprite.position.y = foot_y-12.0*sprite.scale.y
	else:
		sprite.texture = load(TRAPMOOR_PATH+"animations/spore_idle.png")
		frame_width = 16
		frame_height = 16
		frames = 4
		sprite.scale = Vector2(2.5,2.5)
		sprite.position.y = foot_y-8.0*sprite.scale.y
	sprite.region_enabled = true
	sprite.region_rect = Rect2(0,0,frame_width,frame_height)
	body.add_child(sprite)
	var base_enemy_hp: int = int({"badger_boss":20,"cat_boss":26,"pengu_boss":34}.get(kind,boss_max_health)) if is_boss_kind(kind) else int({"spore":2,"bramble":3,"sentinel":4,"skeleton":3}.get(kind,3))
	var enemy_hp: int = maxi(1,ceili(float(base_enemy_hp)*difficulty_value("enemy_hp")))
	var life := create_world_health_bar(enemy_hp,is_boss_kind(kind))
	body.add_child(life)
	world.add_child(body)
	body.floor_snap_length = 12.0
	body.floor_stop_on_slope = true
	var enemy_data := {"node":body,"sprite":sprite,"bar":life,"kind":kind,"hp":enemy_hp,"max_hp":enemy_hp,"spawn":pos,"origin":pos.x,"dir":-1.0,"facing":-1.0,"source_faces_left":kind in ["bramble","skeleton","flying"],"frame":0,"frames":frames,"fw":frame_width,"fh":frame_height,"animations":animations,"anim_name":"idle","anim_clock":rng.randf_range(0.0,0.3),"anim_fps":8.0,"anim_loop":true,"active_frame":-1,"cooldown":rng.randf_range(0.65,1.25),"hurt":0.0,"stun_time":0.0,"attack_cycle":rng.randi_range(0,2),"attack_state":"patrol","state_time":0.0,"stomp_lock":0.0,"turn_lock":0.35,"foot_y":foot_y,"sensor_half_width":sensor_half_width,"boss_phase":1,"ammo":16,"max_ammo":16,"tip_state":{},"followup":"","fx_timer":0.0,"visual_offset":Vector2.ZERO,"last_boss_anim":"idle","posture":100.0,"max_posture":100.0,"posture_broken":false,"phase_transition":false,"last_attack":"","repeat_count":0,"combat_slot":false}
	if is_boss_kind(kind):
		var meta: Dictionary = animations.idle
		enemy_data.fw=int(meta.frame_width); enemy_data.frames=int(meta.frames); enemy_data.anim_fps=float(meta.fps); enemy_data.anim_loop=bool(meta.loop)
	enemies.append(enemy_data)

func is_boss_kind(kind: String) -> bool:
	return kind in ["badger_boss","cat_boss","pengu_boss"]

func load_guardian_animations(kind: String) -> Dictionary:
	var folder := GUARDIAN_PATH+kind+"/"
	return {
		"idle":load(folder+"Idle.png"),
		"walk":load(folder+"Walk.png"),
		"attack":load(folder+"Attack1.png"),
		"hurt":load(folder+"Hurt.png"),
		"death":load(folder+"Death.png"),
		"special":load(folder+"Attack1.png")
	}

func load_new_boss_animations(kind: String) -> Dictionary:
	var folder := BOSS_PATH+kind.trim_suffix("_boss")+"/"
	if kind=="badger_boss":
		return {"idle":boss_anim(folder+"badger_idle.png",128,5,8.0,true),"walk":boss_anim(folder+"badger_move.png",384,8,12.0,true),"attack":boss_anim(folder+"badger_attack_A.png",384,15,20.0,false,10),"special":boss_anim(folder+"badger_ability.png",384,15,18.0,false,9),"hurt":boss_anim(folder+"badger_hurt.png",384,4,14.0,false),"death":boss_anim(folder+"badger_hurt.png",384,4,10.0,false),"attack_b":boss_anim(folder+"badger_attack_B.png",384,11,18.0,false,5)}
	if kind=="cat_boss":
		return {"idle":boss_anim(folder+"cat_idle.png",128,5,8.0,true),"walk":boss_anim(folder+"cat_move.png",384,8,12.0,true),"attack":boss_anim(folder+"cat_melee.png",384,10,18.0,false,5),"special":boss_anim(folder+"cat_shooting.png",384,13,20.0,false,4),"hurt":boss_anim(folder+"cat_hurt.png",384,4,14.0,false),"death":boss_anim(folder+"cat_hurt.png",384,4,10.0,false),"grenade":boss_anim(folder+"cat_grenade.png",384,16,20.0,false,7),"out_of_ammo":boss_anim(folder+"cat_outofammo.png",384,28,24.0,false),"idle_no_ammo":boss_anim(folder+"cat_idle_noammo.png",128,5,8.0,true),"reload":boss_anim(folder+"cat_reload.png",384,41,28.0,false,30)}
	return {"idle":boss_anim(folder+"pengu_idle.png",128,5,8.0,true),"walk":boss_anim(folder+"pengu_move.png",384,8,12.0,true),"attack":boss_anim(folder+"pengu_attack_peck.png",384,11,18.0,false,5),"special":boss_anim(folder+"pengu_attack_ray.png",384,14,18.0,false,7),"hurt":boss_anim(folder+"pengu_hurt.png",384,4,14.0,false),"death":boss_anim(folder+"pengu_hurt.png",384,4,10.0,false),"ice":boss_anim(folder+"pengu_attack_ice.png",384,8,14.0,false,4)}

func boss_anim(path: String, frame_width: int, frame_count: int, fps: float, loop: bool, active_frame := -1) -> Dictionary:
	return {"texture":load(path),"frame_width":frame_width,"frame_height":128,"frames":frame_count,"fps":fps,"loop":loop,"active_frame":active_frame}

func set_enemy_animation(enemy: Dictionary, animation_name: String) -> void:
	var animations: Dictionary = enemy.get("animations",{})
	if animations.is_empty() or enemy.get("anim_name","")==animation_name: return
	if not animations.has(animation_name): animation_name = "idle"
	enemy.anim_name = animation_name
	var animation_data: Variant = animations[animation_name]
	var texture: Texture2D
	if animation_data is Dictionary:
		texture=animation_data.texture
		enemy.fw=int(animation_data.frame_width); enemy.fh=int(animation_data.frame_height); enemy.frames=int(animation_data.frames); enemy.anim_fps=float(animation_data.fps); enemy.anim_loop=bool(animation_data.loop); enemy.active_frame=int(animation_data.get("active_frame",-1))
	else:
		texture=animation_data
		enemy.frames=maxi(1,int(texture.get_width()/int(enemy.fw)))
	var sprite: Sprite2D = enemy.sprite
	sprite.texture = texture
	enemy.anim_clock = 0.0
	sprite.region_rect = Rect2(0,0,int(enemy.fw),int(enemy.fh))

func create_world_health_bar(value: int, boss: bool) -> ProgressBar:
	var bar := ProgressBar.new()
	bar.position = Vector2(-48 if boss else -32,-105 if boss else -62)
	bar.size = Vector2(96 if boss else 64,9)
	bar.max_value = value
	bar.value = value
	bar.show_percentage = false
	bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var bg := StyleBoxFlat.new()
	bg.bg_color = Color(0.03,0.04,0.05,0.92)
	bg.border_color = Color(0.75,0.86,0.80,0.7)
	bg.set_border_width_all(1)
	bg.set_corner_radius_all(3)
	var fill := StyleBoxFlat.new()
	fill.bg_color = Color("#e95858") if not boss else Color("#ff9b55")
	fill.set_corner_radius_all(3)
	bar.add_theme_stylebox_override("background",bg)
	bar.add_theme_stylebox_override("fill",fill)
	bar.visible = false
	return bar

func create_portal(pos: Vector2) -> void:
	portal = Area2D.new()
	portal.name = "PortalDaFase"
	portal.position = pos
	portal.z_index = 8
	portal.collision_layer = 0
	portal.collision_mask = 2
	portal.monitoring = true
	portal.set_meta("base_y",portal.position.y)
	portal.set_meta("portal_phase",rng.randf_range(0.0,TAU))
	var shadow := Polygon2D.new()
	var shadow_points := PackedVector2Array()
	for shadow_index in 24:
		var shadow_angle := TAU*float(shadow_index)/24.0
		shadow_points.append(Vector2(cos(shadow_angle)*70.0,sin(shadow_angle)*10.0))
	shadow.polygon = shadow_points
	shadow.position = Vector2(0,43)
	shadow.color = Color(0.01,0.02,0.025,0.52)
	shadow.z_index = -2
	portal.add_child(shadow)
	var visual_root := Node2D.new()
	visual_root.name = "VisualRoot"
	visual_root.position = Vector2(0,-42)
	portal.add_child(visual_root)
	var portal_art := Sprite2D.new()
	portal_art.name = "PortalArt"
	portal_art.texture = PORTAL_FRAME_INACTIVE
	portal_art.region_enabled=true
	portal_art.region_rect=Rect2(60,28,300,260)
	portal_art.scale = Vector2(0.72,0.72)
	portal_art.position = Vector2(0,0)
	portal_art.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	portal_art.z_index = 2
	visual_root.add_child(portal_art)
	var core := Polygon2D.new()
	core.name = "Core"
	var core_points := PackedVector2Array()
	for core_index in 32:
		var core_angle := TAU*float(core_index)/32.0
		core_points.append(Vector2(cos(core_angle)*48.0,sin(core_angle)*72.0))
	core.polygon = core_points
	core.color = Color(0.28,0.95,0.84,0.08)
	core.position = Vector2(0,-1)
	core.z_index = 0
	visual_root.add_child(core)
	var dimensional_core := Sprite2D.new()
	dimensional_core.name="DimensionalCore"
	dimensional_core.texture=PORTAL_SHEET
	dimensional_core.region_enabled=true
	dimensional_core.region_rect=portal_frame_rect(0)
	dimensional_core.scale=Vector2(2.65,3.25)
	dimensional_core.modulate=Color(0.68,1.0,0.90,0.36)
	dimensional_core.texture_filter=CanvasItem.TEXTURE_FILTER_NEAREST
	dimensional_core.z_index=1
	visual_root.add_child(dimensional_core)
	var ring0 := make_ellipse_line("Ring0",Vector2(54,79),Color(0.30,0.96,0.86,0.24),3.0)
	ring0.position=Vector2(0,-1)
	ring0.z_index=1
	visual_root.add_child(ring0)
	var ring1 := make_ellipse_line("Ring1",Vector2(45,69),Color(0.79,0.53,1.0,0.20),2.0)
	ring1.position=Vector2(0,-1)
	ring1.rotation=0.18
	ring1.z_index=1
	visual_root.add_child(ring1)
	var runes := Node2D.new()
	runes.name="Runas"
	runes.position=Vector2(0,-1)
	runes.z_index=2
	visual_root.add_child(runes)
	for rune_index in 8:
		var rune := Polygon2D.new()
		var rune_angle := TAU*float(rune_index)/8.0
		rune.polygon=PackedVector2Array([Vector2(0,-5),Vector2(4,0),Vector2(0,5),Vector2(-4,0)])
		rune.position=Vector2(cos(rune_angle)*63.0,sin(rune_angle)*88.0)
		rune.rotation=rune_angle
		rune.color=Color("#fff0a6")
		rune.modulate.a=0.15
		runes.add_child(rune)
	var sparkles := Node2D.new()
	sparkles.name="Centelhas"
	sparkles.z_index=3
	visual_root.add_child(sparkles)
	for spark_index in 10:
		var spark := Polygon2D.new()
		spark.polygon=PackedVector2Array([Vector2(0,-3),Vector2(2,0),Vector2(0,3),Vector2(-2,0)])
		spark.color=Color("#9bfbe5") if spark_index%2==0 else Color("#d9a9ff")
		spark.position=Vector2(-48.0+float((spark_index*29)%97),-62.0+float((spark_index*41)%125))
		spark.modulate.a=0.22
		spark.set_meta("spark_phase",float(spark_index)*0.63)
		sparkles.add_child(spark)
	var col := CollisionShape2D.new()
	var shape := CapsuleShape2D.new()
	shape.radius = 52
	shape.height = 154
	col.shape = shape
	col.position.y=-58
	portal.add_child(col)
	var color: Color = [Color("#55e6be"),Color("#8bd35f"),Color("#67bfff"),Color("#ff7a38"),Color("#72dfff"),Color("#9ac8ff")][level]
	var label := Label.new()
	label.name = "PortalLabel"
	label.position = Vector2(-120,-207)
	label.size = Vector2(240,48)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.text = "LIMIAR ADORMECIDO"
	label.add_theme_font_override("font",DISPLAY_FONT)
	label.add_theme_font_size_override("font_size",12)
	label.add_theme_color_override("font_color",color)
	label.add_theme_color_override("font_shadow_color",Color(0,0,0,0.95))
	label.add_theme_constant_override("shadow_offset_x",2)
	label.add_theme_constant_override("shadow_offset_y",2)
	portal.add_child(label)
	portal.modulate = Color(0.70,0.74,0.75,0.92)
	portal.body_entered.connect(func(body): if body==player: call_deferred("try_finish_level"))
	world.add_child(portal)
	# O portal não ocupa a arena nem fica escondido atrás do chefe.
	# Ele só nasce visualmente quando todos os fragmentos forem reunidos
	# ou quando o Guardião da fase for derrotado.
	portal.visible = false
	portal.monitoring = false
	portal.modulate.a = 0.0

func make_ellipse_line(line_name: String, radii: Vector2, color: Color, width: float) -> Line2D:
	var line := Line2D.new()
	line.name = line_name
	var points := PackedVector2Array()
	for point_index in 49:
		var angle := TAU*float(point_index)/48.0
		points.append(Vector2(cos(angle)*radii.x,sin(angle)*radii.y))
	line.points=points
	line.closed=true
	line.width=width
	line.default_color=color
	line.antialiased=true
	return line

func portal_frame_rect(index: int) -> Rect2:
	var safe := clampi(index,0,5)
	return Rect2(float(safe%3)*32.0,float(safe/3)*32.0,32.0,32.0)

func create_hud() -> void:
	hud = CanvasLayer.new()
	hud.layer = 10
	add_child(hud)
	var status_panel := PanelContainer.new()
	status_panel.position = Vector2(10,8)
	status_panel.size = Vector2(332,142)
	status_panel.add_theme_stylebox_override("panel",ui_panel_style(Color(0.62,0.48,0.40,0.98),true))
	hud.add_child(status_panel)
	var status := VBoxContainer.new()
	status.add_theme_constant_override("separation",4)
	status_panel.add_child(status)
	health_label = Label.new()
	health_label.text = "JORGINHO  •  PORTADOR DO FRAGMENTO"
	health_label.add_theme_font_override("font",DISPLAY_FONT)
	health_label.add_theme_font_size_override("font_size",15)
	health_label.add_theme_color_override("font_color",Color("#f8e4b0"))
	health_label.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER
	status.add_child(health_label)
	var hearts_row := HBoxContainer.new()
	hearts_row.add_theme_constant_override("separation",2)
	status.add_child(hearts_row)
	for i in max_health:
		var heart := TextureRect.new()
		heart.custom_minimum_size = Vector2(25,25)
		heart.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		heart.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		hearts_row.add_child(heart)
		heart_nodes.append(heart)
		var pulse := create_tween().bind_node(heart).set_loops()
		pulse.tween_interval(float(i)*0.06)
		pulse.tween_property(heart,"scale",Vector2(1.08,1.08),0.32).set_trans(Tween.TRANS_SINE)
		pulse.tween_property(heart,"scale",Vector2.ONE,0.45).set_trans(Tween.TRANS_SINE)
		pulse.tween_interval(1.1)
	health_bar = make_hud_progress(Color("#e95b5b"),max_health)
	health_bar.visible = false
	var dash_row := HBoxContainer.new()
	status.add_child(dash_row)
	var dash_text := Label.new()
	dash_text.text = "IMPULSO  "
	dash_text.add_theme_font_size_override("font_size",12)
	dash_text.add_theme_color_override("font_color",Color("#dcc39d"))
	dash_row.add_child(dash_text)
	dash_bar = make_hud_progress(Color("#3fc7bb"),1.0)
	dash_bar.custom_minimum_size = Vector2(200,7)
	dash_row.add_child(dash_bar)
	var guard_row := HBoxContainer.new()
	status.add_child(guard_row)
	guard_label = Label.new()
	guard_label.text = "GUARDA  "
	guard_label.custom_minimum_size.x = 66
	guard_label.add_theme_font_size_override("font_size",12)
	guard_label.add_theme_color_override("font_color",Color("#8ecbff"))
	guard_row.add_child(guard_label)
	guard_bar = make_hud_progress(Color("#79bfff"),1.0)
	guard_bar.custom_minimum_size = Vector2(190,7)
	guard_row.add_child(guard_bar)
	var fragment_panel := PanelContainer.new()
	fragment_panel.position = Vector2(376,10)
	fragment_panel.size = Vector2(400,82)
	fragment_panel.add_theme_stylebox_override("panel",ui_panel_style(Color(0.54,0.64,0.52,0.97),true))
	hud.add_child(fragment_panel)
	coin_label = Label.new()
	coin_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	coin_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	coin_label.add_theme_font_override("font",DISPLAY_FONT)
	coin_label.add_theme_font_size_override("font_size",18)
	coin_label.add_theme_color_override("font_color",Color("#ffe28a"))
	var fragment_box := VBoxContainer.new()
	fragment_box.add_theme_constant_override("separation",3)
	fragment_panel.add_child(fragment_box)
	fragment_box.add_child(coin_label)
	portal_charge_bar = make_hud_progress(Color("#61dfc4"),maxi(total_coins,1))
	portal_charge_bar.value=coins
	portal_charge_bar.custom_minimum_size=Vector2(330,7)
	fragment_box.add_child(portal_charge_bar)
	var portal_hint := Label.new()
	portal_hint.text="CADA FRAGMENTO ACORDA O LIMIAR"
	portal_hint.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER
	portal_hint.add_theme_font_size_override("font_size",9)
	portal_hint.add_theme_color_override("font_color",Color("#91cbbd"))
	fragment_box.add_child(portal_hint)
	var objective_panel := PanelContainer.new()
	objective_panel.position = Vector2(804,8)
	objective_panel.size = Vector2(340,132)
	var objective_style := ui_panel_style(Color(0.38,0.60,0.59,0.98),true)
	objective_style.content_margin_left = 22
	objective_style.content_margin_right = 18
	objective_style.content_margin_top = 14
	objective_style.content_margin_bottom = 12
	objective_panel.add_theme_stylebox_override("panel",objective_style)
	hud.add_child(objective_panel)
	var objective_box := VBoxContainer.new()
	objective_box.add_theme_constant_override("separation",2)
	objective_panel.add_child(objective_box)
	objective_label = Label.new()
	objective_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	objective_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	objective_label.add_theme_font_size_override("font_size",14)
	objective_label.add_theme_color_override("font_color",Color("#d8e8dd"))
	objective_box.add_child(objective_label)
	timer_label = Label.new()
	timer_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	timer_label.add_theme_font_size_override("font_size",12)
	timer_label.add_theme_color_override("font_color",Color("#9be8cf"))
	objective_box.add_child(timer_label)
	difficulty_hud_label=Label.new()
	difficulty_hud_label.horizontal_alignment=HORIZONTAL_ALIGNMENT_RIGHT
	difficulty_hud_label.add_theme_font_size_override("font_size",10)
	difficulty_hud_label.add_theme_color_override("font_color",Color("#f3cf7b"))
	objective_box.add_child(difficulty_hud_label)
	boss_label = Label.new()
	boss_label.position = Vector2(326,104)
	boss_label.size = Vector2(500,35)
	boss_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	boss_label.add_theme_font_size_override("font_size",18)
	boss_label.add_theme_color_override("font_color",Color("#ff927d"))
	hud.add_child(boss_label)
	if is_boss_level():
		fragment_panel.visible = false
		var boss_panel := PanelContainer.new()
		boss_panel.position = Vector2(350,8)
		boss_panel.size = Vector2(438,126)
		boss_panel.add_theme_stylebox_override("panel",ui_panel_style(Color(0.68,0.42,0.48,0.98),true))
		hud.add_child(boss_panel)
		var boss_box := VBoxContainer.new()
		boss_box.add_theme_constant_override("separation",3)
		boss_panel.add_child(boss_box)
		boss_hud_name = Label.new()
		boss_hud_name.text = current_boss_name()
		boss_hud_name.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		boss_hud_name.add_theme_font_override("font",DISPLAY_FONT)
		boss_hud_name.add_theme_font_size_override("font_size",17)
		boss_hud_name.add_theme_color_override("font_color",Color("#ffd898"))
		boss_box.add_child(boss_hud_name)
		var boss_maximum := float(get_boss().get("max_hp",boss_max_health))
		boss_hud_bar = make_hud_progress(Color("#cf493f"),boss_maximum)
		boss_hud_bar.custom_minimum_size = Vector2(410,15)
		boss_box.add_child(boss_hud_bar)
		boss_posture_bar = make_hud_progress(Color("#f2c35e"),100.0)
		boss_posture_bar.custom_minimum_size=Vector2(410,7)
		boss_posture_bar.value=100.0
		boss_box.add_child(boss_posture_bar)
		boss_posture_label=Label.new()
		boss_posture_label.text="POSTURA  •  APARE PARA QUEBRAR"
		boss_posture_label.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER
		boss_posture_label.add_theme_font_size_override("font_size",9)
		boss_posture_label.add_theme_color_override("font_color",Color("#f2c35e"))
		boss_box.add_child(boss_posture_label)
		boss_status_label = Label.new()
		boss_status_label.text = boss_phase_status(get_boss())
		boss_status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		boss_status_label.add_theme_font_size_override("font_size",11)
		boss_status_label.add_theme_color_override("font_color",Color("#e8b87a"))
		boss_box.add_child(boss_status_label)
	combo_label = Label.new()
	combo_label.position = Vector2(24,132)
	combo_label.size = Vector2(330,42)
	combo_label.add_theme_font_size_override("font_size",22)
	combo_label.add_theme_color_override("font_color",Color("#ffe28a"))
	hud.add_child(combo_label)
	message_label = Label.new()
	message_label.position = Vector2(326,126)
	message_label.size = Vector2(500,50)
	message_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	message_label.add_theme_font_size_override("font_size",22)
	hud.add_child(message_label)
	guard_button = Button.new()
	guard_button.text = "GUARDA / APARAR\n%s  •  MOUSE DIREITO" % action_prompt("guard")
	guard_button.position = Vector2(12,158)
	guard_button.size = Vector2(198,58)
	guard_button.focus_mode = Control.FOCUS_NONE
	guard_button.add_theme_font_size_override("font_size",12)
	guard_button.add_theme_color_override("font_color",Color("#dff8ff"))
	guard_button.add_theme_stylebox_override("normal",ui_texture_style(UI_BUTTON,Color(0.48,0.72,0.75,0.96),52.0,34.0))
	guard_button.add_theme_stylebox_override("hover",ui_texture_style(UI_BUTTON,Color(0.68,0.94,0.98,1.0),52.0,34.0))
	guard_button.add_theme_stylebox_override("pressed",ui_texture_style(UI_BUTTON,Color(0.88,1.12,1.18,1.0),52.0,34.0))
	guard_button.button_down.connect(start_guard)
	guard_button.button_up.connect(stop_guard)
	hud.add_child(guard_button)
	update_hud()

func make_hud_progress(color: Color, maximum: float) -> ProgressBar:
	var bar := ProgressBar.new()
	bar.max_value = maximum
	bar.value = maximum
	bar.show_percentage = false
	bar.custom_minimum_size = Vector2(300,16)
	var bg := StyleBoxFlat.new()
	bg.bg_color = Color(0.01,0.025,0.03,0.95)
	bg.set_corner_radius_all(4)
	var fill := StyleBoxFlat.new()
	fill.bg_color = color
	fill.set_corner_radius_all(4)
	bar.add_theme_stylebox_override("background",bg)
	bar.add_theme_stylebox_override("fill",fill)
	return bar

func update_hud() -> void:
	if not is_instance_valid(health_label): return
	health_label.text = ("JORGINHO  •  VIDA %d/%d" % [int(health),max_health]) if is_equal_approx(health,roundf(health)) else ("JORGINHO  •  VIDA %.1f/%d" % [health,max_health])
	health_bar.value = health
	for i in heart_nodes.size():
		var fraction := clampf(health-float(i),0.0,1.0)
		heart_nodes[i].texture = HEART_FULL if fraction>0.0 else HEART_EMPTY
		heart_nodes[i].modulate = Color(1.0,0.58,0.58,0.78) if fraction>0.0 and fraction<1.0 else Color.WHITE
	coin_label.text = ("ARENA SELADA" if is_boss_level() else "◆  FRAGMENTOS   %d / %d" % [coins,total_coins])
	if is_instance_valid(portal_charge_bar): portal_charge_bar.value=coins
	objective_label.text = "OBJETIVO\n" + ("Derrote %s" % current_boss_short_name() if is_boss_level() and not get_boss().is_empty() else ("Atravesse o portal desperto" if coins == total_coins else "Reúna todos os fragmentos"))
	var boss := get_boss()
	boss_label.text = ""
	if is_instance_valid(boss_hud_bar):
		boss_hud_bar.value = 0 if boss.is_empty() else boss.hp
	if is_instance_valid(boss_hud_name):
		boss_hud_name.text = "PORTAL LIBERADO" if boss.is_empty() else "%s   %d / %d" % [current_boss_name(),boss.hp,boss.max_hp]
	if is_instance_valid(boss_status_label):
		boss_status_label.text = "A ARENA SILENCIOU" if boss.is_empty() else boss_phase_status(boss)
	if is_instance_valid(boss_posture_bar):
		boss_posture_bar.value=0.0 if boss.is_empty() else float(boss.get("posture",100.0))
	if is_instance_valid(boss_posture_label):
		boss_posture_label.text="QUEBRADO  •  CAUSE DANO AGORA" if not boss.is_empty() and bool(boss.get("posture_broken",false)) else "POSTURA  •  APARE PARA QUEBRAR"
	if is_instance_valid(difficulty_hud_label):
		difficulty_hud_label.text="LIMIAR  •  "+difficulty_name()
	update_dynamic_hud()

func boss_phase_status(boss: Dictionary) -> String:
	if boss.is_empty(): return "A ARENA SILENCIOU"
	var phase := int(boss.get("boss_phase",1))
	match String(boss.kind):
		"badger_boss": return ["","ATO I  •  O DESPERTAR","ATO II  •  FÚRIA SUBTERRÂNEA","ATO FINAL  •  O COVIL DESABA"][phase]
		"cat_boss": return ["","ATO I  •  CAÇADA ARMADA","ATO II  •  SOBRECARGA TOTAL","ATO FINAL  •  ÚLTIMA BALA"][phase]
		"pengu_boss": return ["","ATO I  •  TEMPESTADE CRESCENTE","ATO II  •  TRONO DE GELO","ATO FINAL  •  ZERO ABSOLUTO"][phase]
	return "ATO %d" % phase

func update_dynamic_hud() -> void:
	if not is_instance_valid(dash_bar): return
	dash_bar.value = 1.0-clampf(dash_cooldown/(DASH_COOLDOWN*dash_cooldown_multiplier),0.0,1.0)
	if is_instance_valid(guard_bar):
		guard_bar.value = clampf(parry_time/maxf(0.01,effective_parry_window()),0.0,1.0) if guarding else (1.0-clampf(guard_recovery/0.22,0.0,1.0))
	if is_instance_valid(guard_label):
		guard_label.text = "APAROU!  " if parry_time>0.0 else ("GUARDA  " if guarding else "APARAR  ")
		guard_label.add_theme_color_override("font_color",Color("#fff3a8") if parry_time>0.0 else Color("#8ecbff"))
	var current_second := int(run_time)
	if current_second != last_hud_second:
		last_hud_second = current_second
		timer_label.text = "TEMPO  %02d:%02d" % [int(float(current_second)/60.0),current_second%60]

func show_banner(title: String, subtitle: String) -> void:
	var panel := PanelContainer.new()
	panel.name = "LevelBanner"
	panel.position = Vector2(376,258)
	panel.size = Vector2(400,120)
	panel.add_theme_stylebox_override("panel",panel_style(Color(0.02,0.09,0.11,0.94),Color("#55d6be"),14))
	var v := VBoxContainer.new()
	v.alignment = BoxContainer.ALIGNMENT_CENTER
	panel.add_child(v)
	var a := Label.new()
	a.text = title
	a.add_theme_font_override("font",DISPLAY_FONT)
	a.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	a.add_theme_font_size_override("font_size",24)
	a.add_theme_color_override("font_color",Color("#fff2b2"))
	v.add_child(a)
	var b := Label.new()
	b.text = subtitle
	b.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	b.add_theme_font_size_override("font_size",14)
	b.add_theme_color_override("font_color",Color("#9be8cf"))
	v.add_child(b)
	hud.add_child(panel)
	var tween := create_tween()
	tween.tween_interval(1.45)
	tween.tween_property(panel,"modulate:a",0.0,0.5)
	tween.tween_callback(panel.queue_free)

func flash_message(text: String, color: Color) -> void:
	if not is_instance_valid(message_label): return
	message_label.text = text
	message_label.modulate = color
	var tween := create_tween().bind_node(message_label)
	tween.tween_interval(1.1)
	tween.tween_property(message_label,"modulate:a",0.0,0.5)

func _physics_process(delta: float) -> void:
	if state != "playing" or not is_instance_valid(player): return
	run_time += delta
	attack_time = maxf(0.0,attack_time-delta)
	if attack_time > 0.0:
		attack_elapsed += delta
		var hit_moment := attack_duration*0.16
		if not attack_hit_done and attack_elapsed >= hit_moment:
			attack_hit_done = true
			perform_attack(combo_step)
	combo_window = maxf(0.0,combo_window-delta)
	if combo_window <= 0.0 and attack_time <= 0.0:
		combo_step = 0
		if is_instance_valid(combo_label): combo_label.text = ""
	invincible_time = maxf(0.0,invincible_time-delta)
	player_slow_time = maxf(0.0,player_slow_time-delta)
	damage_flash_time = maxf(0.0,damage_flash_time-delta)
	dash_time = maxf(0.0,dash_time-delta)
	dash_cooldown = maxf(0.0,dash_cooldown-delta)
	parry_time = maxf(0.0,parry_time-delta)
	combat_chain_time=maxf(0.0,combat_chain_time-delta)
	if combat_chain_time<=0.0: combat_chain=0
	guard_recovery = maxf(0.0,guard_recovery-delta)
	footstep_timer = maxf(0.0,footstep_timer-delta)
	jump_buffer_time = maxf(0.0,jump_buffer_time-delta)
	if Input.is_action_just_pressed("jump"):
		jump_buffer_time = 0.12
	if player.is_on_floor():
		coyote_time = 0.12
		jumps_left = 2
	else:
		coyote_time = maxf(0.0,coyote_time-delta)
	var axis := Input.get_axis("move_left","move_right")
	if Input.is_action_pressed("guard") and not guarding:
		start_guard()
	elif not Input.is_action_pressed("guard") and guarding and not (is_instance_valid(guard_button) and guard_button.button_pressed):
		stop_guard()
	if guarding:
		axis *= 0.28
	if axis != 0:
		facing = sign(axis)
	if is_instance_valid(camera):
		var look_ahead := facing*92.0 if absf(axis)>0.15 else facing*64.0
		camera.position.x=lerpf(camera.position.x,look_ahead,clampf(delta*5.5,0.0,1.0))
	if Input.is_action_just_pressed("dash") and dash_cooldown <= 0.0 and dash_time <= 0.0 and not guarding:
		start_dash(axis)
	if dash_time > 0.0:
		player.velocity = Vector2(dash_direction*DASH_SPEED,0)
	else:
		var control_speed := player_move_speed*speed_multiplier*(0.72 if attack_time > 0.0 else 1.0)*(0.82 if player_slow_time>0.0 else 1.0)
		player.velocity.x = move_toward(player.velocity.x,axis*control_speed,1500.0*delta)
		if not player.is_on_floor():
			player.velocity.y += GRAVITY*delta
		if jump_buffer_time>0.0 and (coyote_time>0.0 or jumps_left>0):
			try_jump()
			jump_buffer_time = 0.0
			coyote_time = 0.0
		if Input.is_action_just_released("jump") and player.velocity.y < -250:
			player.velocity.y = -250
	if Input.is_action_just_pressed("attack") and attack_time <= 0.0 and dash_time <= 0.0 and not guarding:
		attack_direction = get_assisted_attack_direction()
		if is_instance_valid(assisted_target): create_target_hint(assisted_target)
		if abs(attack_direction.x)>0.12: facing = sign(attack_direction.x)
		combo_step = combo_step + 1 if combo_window > 0.0 else 1
		if combo_step > 3: combo_step = 1
		attack_duration = [0.0,0.27,0.31,0.39][combo_step]
		attack_time = attack_duration
		attack_elapsed = 0.0
		attack_hit_done = false
		combo_window = 0.82
		play_ui_sound("player_attack.wav",-13.0,0.96+float(combo_step)*0.05)
	player.move_and_slide()
	if player.is_on_floor() and not was_on_floor:
		jumps_left = 2
		if player.velocity.y>=0.0: play_ui_sound("player_land.wav",-16.0,rng.randf_range(0.94,1.05))
	if player.is_on_floor() and absf(axis)>0.2 and dash_time<=0.0 and footstep_timer<=0.0:
		var surface := "grass" if level<2 else ("concrete" if level<4 else "snow")
		play_ui_sound("kenney/footstep_%s_%03d.ogg" % [surface,rng.randi_range(0,4)],-22.0,rng.randf_range(0.97,1.04))
		footstep_timer=0.27
	was_on_floor = player.is_on_floor()
	if player.position.y > 760:
		take_damage(1,true)
	animate_guard_visual()
	animate_player(delta,axis)
	update_enemies(delta)
	update_projectiles(delta)
	for coin in coin_nodes:
		if is_instance_valid(coin):
			var phase := float(coin.get_meta("phase"))
			var time := Time.get_ticks_msec()/1000.0
			var base_position: Vector2=coin.get_meta("base_position")
			if base_position.distance_to(player.position)<86.0:
				base_position=base_position.move_toward(player.position,165.0*delta)
				coin.set_meta("base_position",base_position)
			coin.position=base_position+Vector2(0,sin(time*2.5+phase)*7.0)
			coin.get_node("Crystal").rotation = sin(time*1.7+phase)*0.12
			coin.get_node("Aura").rotation = time*0.45
			var orbit_index := 0
			for child in coin.get_children():
				if child.has_meta("orbit"):
					var angle := float(child.get_meta("orbit"))+time*(0.9+orbit_index*0.12)
					child.position = Vector2(cos(angle)*30,sin(angle)*17)
					orbit_index += 1
	if is_instance_valid(portal):
		var portal_time := Time.get_ticks_msec()/1000.0
		var phase := float(portal.get_meta("portal_phase"))
		var visual_root := portal.get_node_or_null("VisualRoot") as Node2D
		if visual_root: visual_root.position.y=-42.0
		var ring0 := portal.get_node_or_null("VisualRoot/Ring0") as Line2D
		var ring1 := portal.get_node_or_null("VisualRoot/Ring1") as Line2D
		if ring0: ring0.rotation = portal_time*0.42
		if ring1: ring1.rotation = -portal_time*0.34+0.18
		var core := portal.get_node_or_null("VisualRoot/Core") as Polygon2D
		if core:
			var pulse := 1.0+sin(portal_time*3.0)*0.055
			core.scale = Vector2(pulse,pulse)
		var dimensional_core := portal.get_node_or_null("VisualRoot/DimensionalCore") as Sprite2D
		if dimensional_core:
			var frame_rate := 11.0 if portal.has_meta("active") else 5.0
			dimensional_core.region_rect=portal_frame_rect(int(portal_time*frame_rate)%6)
			dimensional_core.modulate.a=(0.62+sin(portal_time*3.4)*0.14) if portal.has_meta("active") else 0.18+sin(portal_time*2.0)*0.05
		var runes := portal.get_node_or_null("VisualRoot/Runas") as Node2D
		if runes: runes.rotation=sin(portal_time*0.75)*0.08
		var sparkles := portal.get_node_or_null("VisualRoot/Centelhas")
		if sparkles:
			for child in sparkles.get_children():
				var spark := child as Polygon2D
				if spark:
					var spark_phase := float(spark.get_meta("spark_phase"))
					spark.modulate.a=(0.30+sin(portal_time*3.2+spark_phase)*0.24) if portal.has_meta("active") else 0.10+sin(portal_time*1.6+spark_phase)*0.07
	update_dynamic_hud()

func start_dash(axis: float = 0.0) -> void:
	if dash_cooldown>0.0 or dash_time>0.0: return
	dash_direction = sign(axis) if axis!=0.0 else facing
	dash_time = DASH_DURATION
	dash_cooldown = DASH_COOLDOWN*dash_cooldown_multiplier
	invincible_time = maxf(invincible_time,DASH_DURATION)
	player.velocity = Vector2(dash_direction*DASH_SPEED,0)
	play_ui_sound("player_dash.wav",-13.0,rng.randf_range(0.94,1.04))
	create_dash_fx()

func start_guard() -> void:
	if state!="playing" or guarding or guard_recovery>0.0 or attack_time>0.0 or dash_time>0.0 or not is_instance_valid(player): return
	guarding = true
	parry_time = effective_parry_window()
	player.velocity.x *= 0.35
	play_ui_sound("ui_confirm_v10.wav",-17.0,1.25)
	guard_visual = Sprite2D.new()
	guard_visual.name = "GuardAura"
	guard_visual.texture = FX_SHIELD
	guard_visual.region_enabled = true
	guard_visual.region_rect = Rect2(0,128,64,64)
	guard_visual.scale = Vector2(1.35,1.35)
	guard_visual.position = Vector2(facing*18.0,-7.0)
	guard_visual.z_index = 18
	player.add_child(guard_visual)
	spawn_sheet_fx(FX_SHIELD,player.global_position+Vector2(facing*14.0,-7.0),13,2,Vector2(1.15,1.15),0.24)

func stop_guard() -> void:
	if not guarding: return
	guarding = false
	parry_time = 0.0
	guard_recovery = 0.22
	if is_instance_valid(guard_visual): guard_visual.queue_free()
	guard_visual = null

func animate_guard_visual() -> void:
	if not guarding or not is_instance_valid(guard_visual): return
	var frame := int(Time.get_ticks_msec()/45)%13
	guard_visual.region_rect = Rect2(frame*64,128,64,64)
	guard_visual.position.x = facing*18.0
	guard_visual.flip_h = facing<0.0

func try_jump() -> bool:
	if jumps_left<=0: return false
	player.velocity.y = -player_jump_force
	jumps_left -= 1
	play_ui_sound("player_jump.wav",-15.0,1.05 if jumps_left==0 else 0.95)
	if jumps_left==0:
		create_double_jump_fx()
	return true

func get_assisted_attack_direction() -> Vector2:
	var desired := player.get_global_mouse_position()-player.global_position
	if desired.length()<12.0:
		desired = Vector2(facing,0)
	return choose_assisted_attack_direction(desired.normalized())

func choose_assisted_attack_direction(desired: Vector2) -> Vector2:
	assisted_target = null
	desired = desired.normalized() if desired.length()>0.01 else Vector2(facing,0)
	var best_direction := desired
	var best_score := INF
	for enemy in enemies:
		var candidate: Variant = enemy.get("node")
		if not is_instance_valid(candidate): continue
		var offset: Vector2 = candidate.global_position-player.global_position
		var distance := offset.length()
		if distance>260.0 or distance<1.0: continue
		var angle: float = absf(desired.angle_to(offset.normalized()))
		# Muito perto: assistência forte. Mais longe: exige intenção aproximada do mouse.
		if distance>175.0 and angle>deg_to_rad(130.0): continue
		var score: float = distance*0.72+angle*24.0
		if score<best_score:
			best_score = score
			best_direction = offset.normalized()
			assisted_target = candidate
	return best_direction

func create_target_hint(target: Node2D) -> void:
	var hint := Line2D.new()
	var points := PackedVector2Array()
	for i in 25:
		var angle := TAU*float(i)/24.0
		points.append(Vector2(cos(angle)*31.0,sin(angle)*22.0))
	hint.points = points
	hint.width = 3.0
	hint.default_color = Color("#d9fff0")
	hint.z_index = 18
	target.add_child(hint)
	var tween := create_tween().bind_node(hint)
	tween.tween_property(hint,"scale",Vector2(1.25,1.25),0.18)
	tween.parallel().tween_property(hint,"modulate:a",0.0,0.18)
	tween.tween_callback(hint.queue_free)

func create_double_jump_fx() -> void:
	var ring := Line2D.new()
	var points := PackedVector2Array()
	for i in 25:
		var angle := TAU*float(i)/24.0
		points.append(Vector2(cos(angle)*22.0,sin(angle)*9.0))
	ring.points = points
	ring.position = player.position+Vector2(0,32)
	ring.width = 5
	ring.default_color = Color("#9be8cf")
	ring.z_index = 8
	world.add_child(ring)
	var tween := create_tween()
	tween.tween_property(ring,"scale",Vector2(2.4,2.4),0.22)
	tween.parallel().tween_property(ring,"modulate:a",0.0,0.22)
	tween.tween_callback(ring.queue_free)

func animate_player(delta: float, axis: float) -> void:
	anim_time += delta
	var anim := "idle"
	if attack_time > 0:
		anim = "jump_attack" if not player.is_on_floor() else ("attack_end" if combo_step == 3 else "attack")
	elif not player.is_on_floor():
		anim = "jump" if player.velocity.y < 0 else "fall"
	elif abs(axis) > 0.1:
		anim = "run"
	player_sprite.texture = hero_textures[anim]
	var animation_coordinates: Array = hero_animation_frames.get(anim,hero_animation_frames.idle)
	var frame := int(anim_time*(10.0 if anim=="run" else 7.0))%animation_coordinates.size()
	if attack_time > 0.0:
		frame = mini(animation_coordinates.size()-1,int((attack_elapsed/maxf(attack_duration,0.01))*float(animation_coordinates.size())))
	player_sprite.region_rect = hero_frame_rect(anim,frame)
	# O spritesheet original olha para a direita; espelha apenas ao caminhar
	# para a esquerda. A mesma regra vale para corrida e todos os ataques.
	player_sprite.flip_h = facing < 0
	if damage_flash_time > 0:
		var progress := 1.0-damage_flash_time/0.62
		var impact := pow(maxf(0.0,sin(progress*PI)),0.55)
		player_sprite.modulate = Color(1.0,1.0-impact*0.72,1.0-impact*0.72,1.0)
	else:
		player_sprite.modulate = Color.WHITE

func assign_combat_slots() -> void:
	if not is_instance_valid(player): return
	var candidates: Array[Dictionary]=[]
	for enemy in enemies:
		enemy.combat_slot=false
		var candidate: Variant=enemy.get("node")
		if not is_instance_valid(candidate) or candidate.has_meta("defeated") or is_boss_kind(String(enemy.kind)): continue
		if String(enemy.attack_state) not in ["patrol","recovery"]:
			enemy.combat_slot=true
			continue
		if candidate.global_position.distance_to(player.global_position)<470.0: candidates.append(enemy)
	candidates.sort_custom(func(a: Dictionary,b: Dictionary): return a.node.global_position.distance_squared_to(player.global_position)<b.node.global_position.distance_squared_to(player.global_position))
	var slots:=1 if difficulty_index==0 else (2 if difficulty_index<3 else 3)
	for index in mini(slots,candidates.size()): candidates[index].combat_slot=true

func update_enemies(delta: float) -> void:
	assign_combat_slots()
	for enemy in enemies:
		var candidate: Variant = enemy.get("node")
		if not is_instance_valid(candidate): continue
		var body: CharacterBody2D = candidate
		if body.has_meta("defeated"): continue
		var sprite: Sprite2D = enemy.sprite
		enemy.cooldown = maxf(0.0,float(enemy.cooldown)-delta/maxf(0.55,difficulty_value("cooldown")))
		enemy.hurt = maxf(0.0,float(enemy.hurt)-delta)
		enemy.state_time = maxf(0.0,float(enemy.state_time)-delta)
		enemy.stomp_lock = maxf(0.0,float(enemy.stomp_lock)-delta)
		enemy.turn_lock = maxf(0.0,float(enemy.turn_lock)-delta)
		enemy.stun_time = maxf(0.0,float(enemy.get("stun_time",0.0))-delta)
		enemy.anim_clock = float(enemy.anim_clock)+delta
		var kind: String = enemy.kind
		if enemy.attack_state=="stunned":
			if float(enemy.stun_time)>0.0:
				if kind!="flying" and not body.is_on_floor(): body.velocity.y += GRAVITY*delta
				body.velocity.x = move_toward(body.velocity.x,0.0,920.0*delta)
				body.move_and_slide()
				set_enemy_animation(enemy,"hurt")
				sprite.modulate = Color("#8fdcff")
				continue
			enemy.attack_state="patrol"
			enemy.cooldown=0.65
		var distance: Vector2 = player.position-body.position
		if body.position.y>690.0:
			body.position = enemy.spawn
			body.velocity = Vector2.ZERO
		if try_stomp_enemy(enemy,distance):
			continue
		var attack_state: String = enemy.attack_state
		if kind != "flying" and not body.is_on_floor():
			body.velocity.y += GRAVITY*delta
		if kind == "spore":
			body.velocity.x = move_toward(body.velocity.x,0.0,1100.0*delta)
			if attack_state == "projectile_windup":
				if enemy.state_time<=0.0:
					spawn_aimed_projectile(enemy,265.0,"spore")
					enemy.attack_state="recovery"
					enemy.state_time=0.38
					enemy.cooldown=1.55
			elif attack_state == "windup":
				if enemy.state_time<=0.0:
					perform_spore_burst(enemy)
					enemy.attack_state="recovery"
					enemy.state_time=0.42
			elif attack_state == "recovery":
				if enemy.state_time<=0.0: enemy.attack_state="patrol"
			elif distance.length()<355.0 and enemy.cooldown<=0.0 and bool(enemy.get("combat_slot",false)) and enemy_has_line_of_sight(body):
				enemy.attack_cycle=int(enemy.attack_cycle)+1
				enemy.attack_state="projectile_windup" if distance.length()>145.0 or int(enemy.attack_cycle)%2==0 else "windup"
				enemy.state_time=0.52 if enemy.attack_state=="projectile_windup" else 0.48
				create_attack_telegraph(enemy,Color("#c36cff"))
				play_enemy_attack_sound(kind)
			body.move_and_slide()
		elif kind != "flying" and not is_boss_kind(kind):
			if attack_state == "ranged_windup":
				body.velocity.x = move_toward(body.velocity.x,0.0,900.0*delta)
				if enemy.state_time<=0.0:
					spawn_aimed_projectile(enemy,320.0 if kind=="sentinel" else 285.0,kind)
					if kind=="sentinel" and level>=4:
						var original_facing: float = float(enemy.facing)
						spawn_combat_projectile(enemy,body.global_position+Vector2(original_facing*28.0,-12.0),(player.global_position-body.global_position).normalized().rotated(-0.13)*310.0,"rune_orb")
						spawn_combat_projectile(enemy,body.global_position+Vector2(original_facing*28.0,-12.0),(player.global_position-body.global_position).normalized().rotated(0.13)*310.0,"rune_orb")
					enemy.attack_state="recovery"
					enemy.state_time=0.40
					enemy.cooldown=1.65
			elif attack_state == "windup":
				body.velocity.x = move_toward(body.velocity.x,0.0,900.0*delta)
				if enemy.state_time <= 0.0:
					enemy.attack_state = "lunge"
					enemy.state_time = 0.26 if kind=="skeleton" else 0.30
					enemy.facing = signf(distance.x) if absf(distance.x)>1.0 else float(enemy.facing)
					body.velocity.x = float(enemy.facing)*(275.0 if kind=="mushroom" else (335.0 if kind=="skeleton" else 350.0))
					if kind=="mushroom": body.velocity.y=-220.0
					create_enemy_lunge_fx(enemy)
					play_enemy_attack_sound(kind)
			elif attack_state == "lunge":
				if enemy.state_time <= 0.0:
					if kind=="mushroom": spawn_spore_landing_puff(body.global_position+Vector2(0,18))
					enemy.attack_state = "patrol"
					enemy.cooldown = 1.35
					body.velocity.x = 0.0
			elif abs(distance.x)<430 and abs(distance.y)<105 and enemy.cooldown<=0.0 and bool(enemy.get("combat_slot",false)) and enemy_has_line_of_sight(body):
				enemy.attack_cycle=int(enemy.attack_cycle)+1
				var can_shoot: bool = kind in ["sentinel","bramble"] and abs(distance.x)>175.0 and int(enemy.attack_cycle)%2==0
				enemy.attack_state = "ranged_windup" if can_shoot else "windup"
				enemy.state_time = 0.52 if can_shoot else (0.34 if kind=="skeleton" else 0.42)
				enemy.facing = signf(distance.x) if absf(distance.x)>1.0 else float(enemy.facing)
				create_attack_telegraph(enemy,Color("#72e2c3") if can_shoot else Color("#ffc15a"))
				play_enemy_attack_sound(kind)
			else:
				var chase: bool = abs(distance.x)<330 and enemy_has_line_of_sight(body)
				var patrol_speed := 34.0 if kind=="mushroom" else (46.0 if kind=="skeleton" else 40.0)
				var chase_speed := 66.0 if kind=="mushroom" else (82.0 if kind=="skeleton" else 72.0)
				var desired_direction := signf(distance.x) if chase and absf(distance.x)>2.0 else float(enemy.dir)
				body.velocity.x = move_toward(body.velocity.x,desired_direction*(chase_speed if chase else patrol_speed),520.0*delta)
				if abs(body.position.x-float(enemy.origin))>180 and not chase and enemy.turn_lock<=0.0:
					enemy.dir = -signf(body.position.x-float(enemy.origin))
					enemy.turn_lock = 0.30
				apply_ground_sensors(enemy,body)
			body.move_and_slide()
		elif kind == "flying":
			if attack_state == "shoot_windup":
				body.velocity = body.velocity.move_toward(Vector2.ZERO,520.0*delta)
				if enemy.state_time<=0.0:
					spawn_aimed_projectile(enemy,345.0,"flying")
					enemy.attack_state="recovery"
					enemy.state_time=0.40
					play_enemy_attack_sound(kind)
			elif attack_state == "windup":
				body.velocity = body.velocity.move_toward(Vector2.ZERO,520.0*delta)
				if enemy.state_time <= 0.0:
					enemy.attack_state = "dive"
					enemy.state_time = 0.58
					enemy["attack_velocity"] = distance.normalized()*440.0
					enemy.facing = signf(distance.x) if absf(distance.x)>1.0 else float(enemy.facing)
					play_enemy_attack_sound(kind)
			elif attack_state == "dive":
				body.velocity = enemy.get("attack_velocity",Vector2.ZERO)
				enemy.fx_timer=float(enemy.get("fx_timer",0.0))-delta
				if float(enemy.fx_timer)<=0.0:
					enemy.fx_timer=0.11
					spawn_sheet_fx(FX_ARC,body.global_position-Vector2(body.velocity).normalized()*20.0,22,2,Vector2(0.48*float(enemy.facing),0.28),0.13)
				if enemy.state_time <= 0.0:
					enemy.attack_state = "recovery"
					enemy.state_time = 0.45
			elif attack_state == "recovery":
				var home: Vector2 = enemy.spawn
				body.velocity = (home-body.position).limit_length(170.0)
				if enemy.state_time<=0.0:
					enemy.attack_state="patrol"
					enemy.cooldown=1.55
			elif distance.length()<440 and enemy.cooldown<=0.0 and bool(enemy.get("combat_slot",false)) and enemy_has_line_of_sight(body):
				enemy.attack_cycle=int(enemy.attack_cycle)+1
				enemy.attack_state = "shoot_windup" if int(enemy.attack_cycle)%2==0 and distance.length()>145.0 else "windup"
				enemy.state_time = 0.48 if enemy.attack_state=="shoot_windup" else 0.38
				create_attack_telegraph(enemy,Color("#72d8ff") if enemy.attack_state=="shoot_windup" else Color("#ffc15a"))
			else:
				var home: Vector2 = enemy.spawn
				var horizontal := signf(distance.x)*55.0 if absf(distance.x)<330.0 else signf(home.x-body.position.x)*38.0
				body.velocity = Vector2(horizontal,clampf((home.y-body.position.y)*2.2,-95.0,95.0)+sin(float(Time.get_ticks_msec())/320.0)*12.0)
			body.move_and_slide()
		else:
			update_boss_combat(enemy,body,distance,delta)
		attack_state = enemy.attack_state
		var dangerous := attack_state in ["lunge","dive"]
		if dangerous and abs(distance.x)<55+(30 if is_boss_kind(kind) else 0) and abs(distance.y)<80 and enemy.cooldown<=0.0:
			enemy.cooldown = 0.75
			take_damage(1,false,enemy)
		var desired_animation := "idle"
		if enemy.hurt>0.0:
			desired_animation = "hurt"
		elif attack_state in ["windup","lunge","ranged_windup","shoot_windup","projectile_windup","slam_windup","burrow_windup","collapse_windup","charge_windup","volley_windup","grenade_windup","melee_windup","suppress_windup","ice_windup","ray_windup","peck_windup","zero_windup","charge","melee_active","peck_active"]:
			desired_animation = "attack"
		elif absf(body.velocity.x)>10.0:
			desired_animation = "walk"
		if is_boss_kind(kind) and attack_state in ["burrow_windup","collapse_windup","volley_windup","shooting","suppress_windup","suppress_active","ray_windup","ray_active","zero_windup"]: desired_animation="special"
		if kind=="badger_boss" and attack_state=="slam_windup": desired_animation="attack"
		if kind=="badger_boss" and attack_state in ["charge_windup","charge"]: desired_animation="attack_b"
		if kind=="badger_boss" and attack_state=="charge": desired_animation="walk"
		if kind=="cat_boss" and attack_state=="grenade_windup": desired_animation="grenade"
		if kind=="cat_boss" and attack_state in ["out_of_ammo","reload"]: desired_animation=attack_state
		if kind=="cat_boss" and attack_state=="overheat": desired_animation="idle_no_ammo"
		if kind=="pengu_boss" and attack_state=="ice_windup": desired_animation="ice"
		if is_boss_kind(kind):
			if attack_state=="recovery":
				var last_animation := String(enemy.get("last_boss_anim","idle"))
				var last_meta: Variant = enemy.animations.get(last_animation)
				if last_meta is Dictionary and float(enemy.anim_clock)<float(last_meta.frames)/maxf(1.0,float(last_meta.fps)): desired_animation=last_animation
			elif desired_animation not in ["idle","walk","hurt"]:
				enemy.last_boss_anim=desired_animation
		set_enemy_animation(enemy,desired_animation)
		if absf(body.velocity.x)>6.0 and attack_state not in ["windup","ranged_windup","shoot_windup","projectile_windup","slam_windup","burrow_windup","collapse_windup","charge_windup","volley_windup","grenade_windup","melee_windup","suppress_windup","ice_windup","ray_windup","peck_windup","zero_windup"]: enemy.facing=signf(body.velocity.x)
		var animation_fps := float(enemy.get("anim_fps",8.0))
		if not is_boss_kind(kind):
			if desired_animation=="walk": animation_fps=10.0
			elif desired_animation=="attack": animation_fps=13.0
			elif desired_animation=="hurt": animation_fps=14.0
		var raw_frame := int(float(enemy.anim_clock)*animation_fps)
		var animation_frame := raw_frame%maxi(1,int(enemy.frames)) if bool(enemy.get("anim_loop",true)) else mini(raw_frame,maxi(0,int(enemy.frames)-1))
		sprite.region_rect = Rect2(animation_frame*int(enemy.fw),0,int(enemy.fw),int(enemy.fh))
		update_enemy_visual_offset(enemy,sprite,attack_state,animation_frame)
		sprite.flip_h = float(enemy.facing)>0.0 if bool(enemy.source_faces_left) else float(enemy.facing)<0.0
		if enemy.hurt>0.0:
			sprite.modulate = Color("#ff4f4f")
		elif attack_state in ["windup","ranged_windup","shoot_windup","projectile_windup","slam_windup","charge_windup","volley_windup","nova_windup","grenade_windup","ice_windup"]:
			sprite.modulate = Color("#ffc15a")
		else:
			sprite.modulate = Color.WHITE

func update_boss_combat(enemy: Dictionary, body: CharacterBody2D, distance: Vector2, delta: float) -> void:
	var kind := String(enemy.kind)
	var hp_ratio:=float(enemy.hp)/maxf(1.0,float(enemy.max_hp))
	var next_phase:=3 if hp_ratio<=0.30 else (2 if hp_ratio<=0.66 else 1)
	if next_phase>int(enemy.boss_phase): begin_boss_phase_transition(enemy,next_phase)
	if bool(enemy.get("phase_transition",false)):
		body.velocity.x=move_toward(body.velocity.x,0.0,1400.0*delta); body.move_and_slide(); return
	if bool(enemy.get("posture_broken",false)):
		if float(enemy.stun_time)<=0.0:
			enemy.posture_broken=false; enemy.posture=100.0; enemy.attack_state="patrol"; enemy.cooldown=0.9
		body.velocity.x=move_toward(body.velocity.x,0.0,1100.0*delta); body.move_and_slide(); return
	enemy.posture=minf(float(enemy.max_posture),float(enemy.posture)+delta*(5.0+float(enemy.boss_phase)*1.5))
	var attack_state := String(enemy.attack_state)
	if attack_state.ends_with("_windup"):
		body.velocity.x=move_toward(body.velocity.x,0.0,1200.0*delta)
		if enemy.state_time<=0.0: activate_boss_attack(enemy,body,distance)
	elif attack_state in ["charge","melee_active","peck_active"]:
		update_boss_contact_attack(enemy,body,distance,delta)
	elif attack_state=="shooting":
		update_cat_burst(enemy,body,distance)
	elif attack_state=="ray_active":
		update_pengu_ray(enemy,body)
	elif attack_state=="suppress_active":
		update_cat_suppression(enemy,body)
	elif attack_state in ["out_of_ammo","reload","overheat","recovery"]:
		body.velocity.x=move_toward(body.velocity.x,0.0,920.0*delta)
		if enemy.state_time<=0.0:
			if attack_state=="out_of_ammo": enemy.attack_state="reload"; enemy.state_time=1.45 if int(enemy.boss_phase)==1 else 1.05
			elif attack_state=="reload": enemy.ammo=enemy.max_ammo; enemy.attack_state="recovery"; enemy.state_time=0.34
			elif attack_state=="recovery" and not String(enemy.get("followup","")).is_empty(): start_boss_followup(enemy)
			else: enemy.attack_state="patrol"
	elif enemy.cooldown<=0.0 and absf(distance.y)<190.0:
		choose_boss_attack(enemy,distance)
	else:
		var desired := signf(distance.x) if absf(distance.x)>235.0 else 0.0
		body.velocity.x=move_toward(body.velocity.x,desired*62.0*difficulty_value("enemy_speed"),330.0*delta)
		if desired!=0.0: enemy.facing=desired
	body.move_and_slide()
	body.position.x=clampf(body.position.x,arena_left()+45.0,arena_right()-36.0)

func begin_boss_phase_transition(enemy: Dictionary, next_phase: int) -> void:
	enemy.boss_phase=next_phase; enemy.phase_transition=true; enemy.attack_state="phase_change"; enemy.state_time=0.85; enemy.attack_cycle=0; enemy.cooldown=0.55; enemy.followup=""
	face_boss_to_player(enemy)
	flash_message("%s  •  ATO %s" % [current_boss_short_name(),"FINAL" if next_phase==3 else "II"],Color("#ffcf83"))
	create_shockwave(enemy.node.position); create_phase_burst(enemy.node.global_position,String(enemy.kind)); shake_camera_once(8.0)
	play_event_sfx("phase_change","boss_roar.wav",-7.0,1.08 if next_phase==3 else 1.0)
	var veil:=ColorRect.new(); veil.position=Vector2(0,0); veil.size=VIEW; veil.color=Color(0.15,0.02,0.08,0.0); veil.z_index=80; hud.add_child(veil)
	var drama:=create_tween().bind_node(veil); drama.tween_property(veil,"color:a",0.28*flash_intensity,0.16); drama.tween_property(veil,"color:a",0.0,0.48); drama.tween_callback(veil.queue_free)
	var timer:=get_tree().create_timer(0.85); timer.timeout.connect(func():
		if is_instance_valid(enemy.get("node")): enemy.phase_transition=false; enemy.attack_state="patrol"; enemy.cooldown=0.45
	)

func face_boss_to_player(enemy: Dictionary) -> void:
	var candidate: Variant=enemy.get("node")
	if not is_instance_valid(candidate) or not is_instance_valid(player): return
	var delta_x: float = player.global_position.x-candidate.global_position.x
	if absf(delta_x)>2.0: enemy.facing=signf(delta_x)

func boss_base_sprite_y(enemy: Dictionary, sprite: Sprite2D) -> float:
	return float(enemy.foot_y)-64.0*absf(sprite.scale.y)

func update_enemy_visual_offset(enemy: Dictionary, sprite: Sprite2D, attack_state: String, animation_frame: int) -> void:
	if not is_boss_kind(String(enemy.kind)): return
	var base_y := boss_base_sprite_y(enemy,sprite)
	var target_offset := Vector2.ZERO
	if String(enemy.kind)=="badger_boss":
		if attack_state in ["charge_windup","charge"]: target_offset=Vector2(-float(enemy.facing)*4.0,2.0)
		elif attack_state in ["slam_windup","burrow_windup","collapse_windup"]: target_offset=Vector2(0,2.0+sin(float(animation_frame)*0.8)*2.0)
		elif absf(enemy.node.velocity.x)>8.0: target_offset=Vector2(0,sin(float(animation_frame)*PI*0.5)*1.8)
	elif String(enemy.kind)=="cat_boss" and attack_state in ["shooting","suppress_active"]:
		target_offset=Vector2(-float(enemy.facing)*(2.0+float(animation_frame%2)*2.0),0)
	elif String(enemy.kind)=="pengu_boss" and attack_state in ["ice_windup","ray_windup","ray_active","zero_windup"]:
		target_offset=Vector2(0,-2.0+sin(float(animation_frame)*0.65)*2.0)
	enemy.visual_offset=Vector2(enemy.get("visual_offset",Vector2.ZERO)).lerp(target_offset,0.34)
	sprite.position=Vector2(float(enemy.visual_offset.x),base_y+float(enemy.visual_offset.y))

func choose_boss_attack(enemy: Dictionary, distance: Vector2) -> void:
	var kind := String(enemy.kind)
	face_boss_to_player(enemy)
	enemy.attack_cycle=int(enemy.attack_cycle)+1
	var phase_two := int(enemy.boss_phase)>=2
	var phase_final := int(enemy.boss_phase)>=3
	var pattern := int(enemy.attack_cycle)%(5 if phase_final else (4 if phase_two else 3))
	if kind=="badger_boss":
		if pattern==0: begin_boss_attack(enemy,"slam_windup",0.52,"TREMOR DO COVIL",Color("#b9d36a"),TelegraphType.GROUND_LINE)
		elif pattern==1: begin_boss_attack(enemy,"charge_windup",0.34,"INVESTIDA DO ESCAVADOR",Color("#ffd07a"),TelegraphType.CHARGE)
		elif pattern==2: begin_boss_attack(enemy,"burrow_windup",0.72,"ROCHAS SUBTERRÂNEAS",Color("#d3a85c"),TelegraphType.GROUND_AREA)
		else: begin_boss_attack(enemy,"collapse_windup",0.72 if phase_final else 0.84,"COLAPSO DO COVIL",Color("#8fbf58"),TelegraphType.GROUND_LINE)
	elif kind=="cat_boss":
		if int(enemy.ammo)<=0: enemy.attack_state="out_of_ammo"; enemy.state_time=0.78; show_attack_tip_once("cat_reload","ARMA VAZIA  •  CONTRA-ATAQUE",Color("#ffcf7a")); return
		if absf(distance.x)<130.0: begin_boss_attack(enemy,"melee_windup",0.34,"CORONHADA",Color("#ffe19a"),TelegraphType.CHARGE)
		elif pattern==0: begin_boss_attack(enemy,"volley_windup",0.28,"RAJADA DE METRALHADORA",Color("#ffb35c"),TelegraphType.AIM)
		elif pattern==1: begin_boss_attack(enemy,"grenade_windup",0.42,"GRANADA",Color("#ff7845"),TelegraphType.ARC)
		elif phase_two and pattern>=3: begin_boss_attack(enemy,"suppress_windup",0.30 if phase_final else 0.34,"FOGO DE SUPRESSÃO",Color("#ff7338"),TelegraphType.AIM)
		else: begin_boss_attack(enemy,"volley_windup",0.26,"RAJADA DE METRALHADORA",Color("#ffb35c"),TelegraphType.AIM)
	else:
		if pattern==0: begin_boss_attack(enemy,"ice_windup",0.38,"LANÇAS DE GELO",Color("#8feaff"),TelegraphType.GROUND_AREA)
		elif pattern==1: begin_boss_attack(enemy,"ray_windup",0.48,"RAIO GLACIAL",Color("#63cfff"),TelegraphType.AIM)
		elif pattern==2: begin_boss_attack(enemy,"peck_windup",0.32,"BICADA CONGELANTE",Color("#d6f8ff"),TelegraphType.CHARGE)
		else: begin_boss_attack(enemy,"zero_windup",0.88 if phase_final else 1.05,"ZERO ABSOLUTO",Color("#b0ddff"),TelegraphType.GROUND_AREA)

func begin_boss_attack(enemy: Dictionary, state_name: String, duration: float, tip: String, color: Color, telegraph_type: int) -> void:
	face_boss_to_player(enemy)
	enemy.repeat_count=int(enemy.get("repeat_count",0))+1 if String(enemy.get("last_attack",""))==state_name else 0
	enemy.last_attack=state_name
	var adjusted_duration := duration*difficulty_value("cooldown")
	enemy.attack_state=state_name; enemy.state_time=adjusted_duration
	var target := player.global_position
	var size := 108.0 if telegraph_type==TelegraphType.GROUND_AREA else 0.0
	create_typed_telegraph(telegraph_type,enemy,color,target,adjusted_duration,size)
	show_attack_tip_once("%s_%s" % [enemy.kind,state_name],tip,color)
	play_event_sfx("windup","boss_roar.wav",-14.0,0.90 if enemy.kind=="badger_boss" else (1.12 if enemy.kind=="pengu_boss" else 1.02))

func activate_boss_attack(enemy: Dictionary, body: CharacterBody2D, distance: Vector2) -> void:
	face_boss_to_player(enemy)
	distance=player.global_position-body.global_position
	match String(enemy.attack_state):
		"slam_windup": perform_badger_tremor(enemy); enemy.attack_state="recovery"; enemy.state_time=0.72; enemy.followup="charge_windup" if int(enemy.boss_phase)>=2 else ""
		"burrow_windup": perform_badger_burrow(enemy); enemy.attack_state="recovery"; enemy.state_time=0.78
		"collapse_windup": perform_badger_collapse(enemy); enemy.attack_state="recovery"; enemy.state_time=0.95
		"charge_windup": enemy.attack_state="charge"; enemy.state_time=0.92; enemy.facing=signf(distance.x); body.velocity.x=float(enemy.facing)*(500.0 if int(enemy.boss_phase)>=2 else 440.0)*difficulty_value("enemy_speed"); enemy["charge_hit"]=false; create_parry_cue(body.global_position)
		"volley_windup": enemy.attack_state="shooting"; enemy.state_time=0.68; enemy.anim_clock=0.0; enemy["burst_timer"]=0.0; enemy["burst_shots"]=0
		"grenade_windup": perform_cat_grenade(enemy); enemy.attack_state="recovery"; enemy.state_time=0.56
		"melee_windup": enemy.attack_state="melee_active"; enemy.state_time=0.22; enemy.facing=signf(distance.x); body.velocity.x=float(enemy.facing)*250.0*difficulty_value("enemy_speed"); enemy["charge_hit"]=false; create_parry_cue(body.global_position)
		"suppress_windup": begin_cat_suppression(enemy); enemy.attack_state="suppress_active"; enemy.state_time=1.42; enemy.anim_clock=0.0; enemy.anim_loop=true
		"ice_windup": perform_pengu_ice(enemy); enemy.attack_state="recovery"; enemy.state_time=0.64; enemy.followup="ray_windup" if int(enemy.boss_phase)>=2 else ""
		"ray_windup": enemy.attack_state="ray_active"; enemy.state_time=0.88; enemy.anim_clock=0.0; enemy.anim_loop=true; enemy["ray_tick"]=0.0; enemy["ray_height"]=player.global_position.y; play_event_sfx("ray_fire","boss_roar.wav",-11.0,1.24)
		"peck_windup": enemy.attack_state="peck_active"; enemy.state_time=0.48; enemy.facing=signf(distance.x); body.velocity.x=float(enemy.facing)*480.0*difficulty_value("enemy_speed"); enemy["charge_hit"]=false; create_parry_cue(body.global_position)
		"zero_windup": perform_zero_absolute(enemy); enemy.attack_state="recovery"; enemy.state_time=1.15

func update_boss_contact_attack(enemy: Dictionary, body: CharacterBody2D, distance: Vector2, delta: float) -> void:
	if String(enemy.attack_state) in ["melee_active","peck_active"]: body.velocity.x=move_toward(body.velocity.x,float(enemy.facing)*360.0,820.0*delta)
	if not bool(enemy.get("charge_hit",false)) and absf(distance.x)<88.0 and absf(distance.y)<82.0:
		enemy.charge_hit=true; take_damage(1.0,false,enemy)
		if enemy.kind=="pengu_boss": player_slow_time=0.60; spawn_penguin_freeze_fx(player.global_position)
	if body.is_on_wall() and enemy.kind=="badger_boss":
		enemy.attack_state="stunned"; enemy.stun_time=1.15; enemy.state_time=1.15; body.velocity=Vector2(-float(enemy.facing)*130.0,-80.0); create_shockwave(body.global_position); play_event_sfx("wall_impact","boss_slam.wav",-7.0,0.84); return
	if enemy.state_time<=0.0: enemy.attack_state="recovery"; enemy.state_time=0.58; enemy.cooldown=1.05; body.velocity.x=0.0

func update_cat_burst(enemy: Dictionary, body: CharacterBody2D, distance: Vector2) -> void:
	enemy.burst_timer=float(enemy.get("burst_timer",0.0))-get_physics_process_delta_time()
	if float(enemy.burst_timer)<=0.0 and int(enemy.burst_shots)<6 and int(enemy.ammo)>0:
		enemy.burst_timer=0.105; enemy.burst_shots=int(enemy.burst_shots)+1; enemy.ammo=int(enemy.ammo)-1
		var direction := (player.global_position+Vector2(0,-10)-(body.global_position+Vector2(float(enemy.facing)*58,-28))).normalized()
		spawn_combat_projectile(enemy,body.global_position+Vector2(float(enemy.facing)*58,-28),direction.rotated(rng.randf_range(-0.025,0.025))*560.0,"cat_bullet")
		spawn_muzzle_flash(body.global_position+Vector2(float(enemy.facing)*62,-28),enemy.facing)
		play_event_sfx("gun_shot","enemy_attack_skeleton.wav",-18.0,rng.randf_range(0.96,1.04))
	if enemy.state_time<=0.0 or int(enemy.burst_shots)>=6 or int(enemy.ammo)<=0:
		enemy.attack_state="out_of_ammo" if int(enemy.ammo)<=0 else "recovery"; enemy.state_time=0.72 if int(enemy.ammo)<=0 else 0.46; enemy.cooldown=1.1
		if int(enemy.boss_phase)>=2 and int(enemy.attack_cycle)%4==0 and int(enemy.ammo)>0: enemy.followup="grenade_windup"

func update_pengu_ray(enemy: Dictionary, body: CharacterBody2D) -> void:
	enemy.ray_tick=float(enemy.get("ray_tick",0.0))-get_physics_process_delta_time()
	if float(enemy.ray_tick)<=0.0:
		enemy.ray_tick=0.12
		spawn_pengu_beam_slice(enemy,body.global_position+Vector2(float(enemy.facing)*52,-20),float(enemy.facing),float(enemy.get("ray_height",player.global_position.y)))
	if enemy.state_time<=0.0: enemy.attack_state="recovery"; enemy.state_time=0.72; enemy.cooldown=1.35

func spawn_pengu_beam_slice(enemy: Dictionary, origin: Vector2, direction: float, target_height: float) -> void:
	if not is_instance_valid(world): return
	var length := (level_width-origin.x-35.0) if direction>0.0 else (origin.x-315.0)
	length=maxf(80.0,length)
	var beam := Polygon2D.new()
	beam.polygon=PackedVector2Array([Vector2(0,-7),Vector2(direction*length,-4),Vector2(direction*length,4),Vector2(0,7)])
	beam.color=Color(0.36,0.88,1.0,0.30); beam.global_position=Vector2(origin.x,target_height); beam.z_index=18; world.add_child(beam)
	var pulse := create_tween().bind_node(beam); pulse.tween_property(beam,"modulate:a",0.62,0.045); pulse.tween_property(beam,"modulate:a",0.0,0.09); pulse.tween_callback(beam.queue_free)
	for index in 4:
		var ice_pos := Vector2(origin.x+direction*length*(0.18+float(index)*0.22),target_height+rng.randf_range(-8,8))
		spawn_sheet_fx(FX_IMPACT,ice_pos,8,2,Vector2(0.34,0.34),0.12)
	var on_firing_side := (player.global_position.x-origin.x)*direction>0.0
	if on_firing_side and absf(player.global_position.y-target_height)<34.0: take_damage(1.0,false,enemy)

func perform_badger_tremor(enemy: Dictionary) -> void:
	var body: CharacterBody2D=enemy.node
	play_event_sfx("badger_tremor","boss_slam.wav",-7.0,0.82)
	create_shockwave(body.position); spawn_dirt_burst(body.global_position+Vector2(0,34),14)
	spawn_combat_projectile(enemy,body.global_position+Vector2(-54,22),Vector2(-410,0),"ground_wave")
	spawn_combat_projectile(enemy,body.global_position+Vector2(54,22),Vector2(410,0),"ground_wave")
	shake_camera_once(6.0)
	enemy.cooldown=1.45

func perform_badger_burrow(enemy: Dictionary) -> void:
	var prediction := player.global_position.x+player.velocity.x*0.28
	var count := 5 if int(enemy.boss_phase)>=2 else 3
	for index in count:
		var centered := float(index)-float(count-1)*0.5
		var x := clampf(prediction+centered*135.0,390.0,level_width-120.0)
		create_delayed_blast(enemy,Vector2(x,540),Color("#b8904d"),58.0,0.46+float(index)*0.12,"earth")
	enemy.cooldown=1.65

func perform_badger_collapse(enemy: Dictionary) -> void:
	for index in 4:
		var x := arena_x((float(index)+0.5)/4.0)
		create_delayed_blast(enemy,Vector2(x,540),Color("#9bb85b"),95.0,0.52+index*0.24,"earth")
	enemy.cooldown=2.05

func begin_cat_suppression(enemy: Dictionary) -> void:
	var body: CharacterBody2D=enemy.node
	enemy["suppress_row"]=0; enemy["suppress_shots"]=0; enemy["suppress_timer"]=0.0
	spawn_muzzle_flash(body.global_position+Vector2(float(enemy.facing)*58,-28),enemy.facing)

func update_cat_suppression(enemy: Dictionary, body: CharacterBody2D) -> void:
	enemy.suppress_timer=float(enemy.get("suppress_timer",0.0))-get_physics_process_delta_time()
	if float(enemy.suppress_timer)<=0.0 and int(enemy.suppress_row)<3:
		enemy.suppress_timer=0.075
		var rows := [475.0,390.0,305.0]
		var row_index := int(enemy.suppress_row)
		var direction := Vector2(float(enemy.facing),0)
		spawn_combat_projectile(enemy,body.global_position+Vector2(float(enemy.facing)*58,float(rows[row_index])-body.global_position.y),direction*(485.0+int(enemy.suppress_shots)*10.0),"cat_bullet")
		spawn_muzzle_flash(body.global_position+Vector2(float(enemy.facing)*58,float(rows[row_index])-body.global_position.y),enemy.facing)
		enemy.suppress_shots=int(enemy.suppress_shots)+1; enemy.ammo=maxi(0,int(enemy.ammo)-1)
		if int(enemy.suppress_shots)>=5:
			enemy.suppress_shots=0; enemy.suppress_row=int(enemy.suppress_row)+1; enemy.suppress_timer=0.18
	if enemy.state_time<=0.0 or int(enemy.suppress_row)>=3:
		enemy.ammo=0; enemy.attack_state="overheat"; enemy.state_time=1.05; enemy.cooldown=1.4
		create_overheat_fx(body.global_position+Vector2(float(enemy.facing)*54,-25))

func start_boss_followup(enemy: Dictionary) -> void:
	var followup := String(enemy.get("followup","")); enemy.followup=""
	match followup:
		"charge_windup": begin_boss_attack(enemy,followup,0.34,"INVESTIDA ENCADEADA",Color("#ffd07a"),TelegraphType.CHARGE)
		"grenade_windup": begin_boss_attack(enemy,followup,0.42,"GRANADA ENCADEADA",Color("#ff7845"),TelegraphType.ARC)
		"ray_windup": begin_boss_attack(enemy,followup,0.48,"GELO + RAIO",Color("#63cfff"),TelegraphType.AIM)
		_: enemy.attack_state="patrol"

func perform_zero_absolute(enemy: Dictionary) -> void:
	var safe_center := arena_x(0.62) if player.global_position.x<arena_x(0.5) else arena_x(0.38)
	for ratio in [0.12,0.25,0.38,0.50,0.62,0.75,0.88]:
		var x := arena_x(ratio)
		if absf(x-safe_center)<150.0: continue
		create_delayed_blast(enemy,Vector2(x,540),Color("#8de9ff"),76.0,0.70+absf(x-safe_center)/1800.0,"ice")
	var wash := ColorRect.new(); wash.position=Vector2(300,0); wash.size=Vector2(level_width-300,648); wash.color=Color(0.3,0.75,1.0,0.0); wash.z_index=14; world.add_child(wash)
	var freeze := create_tween().bind_node(wash); freeze.tween_property(wash,"color:a",0.22,0.55); freeze.tween_property(wash,"color:a",0.0,0.75); freeze.tween_callback(wash.queue_free)
	play_event_sfx("zero_absolute","boss_roar.wav",-8.0,1.28); shake_camera_once(7.0)

func show_attack_tip_once(key: String, text_value: String, color: Color) -> void:
	if seen_attack_tips.has(key): return
	seen_attack_tips[key]=true
	flash_message(text_value,color)

func play_event_sfx(event_name: String, fallback: String, volume_db: float, pitch: float) -> void:
	play_ui_sound(String(EVENT_SFX.get(event_name,fallback)),volume_db,pitch)

func create_parry_cue(pos: Vector2) -> void:
	spawn_sheet_fx(FX_IMPACT,pos+Vector2(0,-38),8,2,Vector2(0.62,0.62),0.16)
	play_event_sfx("parry_cue","ui_confirm_v10.wav",-17.0,1.22)

func spawn_muzzle_flash(pos: Vector2, direction: float) -> void:
	spawn_sheet_fx(FX_IMPACT,pos,8,1,Vector2(0.54*direction,0.42),0.09)

func spawn_dirt_burst(pos: Vector2, count: int) -> void:
	for index in count:
		var debris := Polygon2D.new(); debris.polygon=PackedVector2Array([Vector2(-4,-3),Vector2(5,0),Vector2(-3,4)]); debris.color=Color("#9a6d3a"); debris.global_position=pos; debris.z_index=19; world.add_child(debris)
		var target := pos+Vector2(rng.randf_range(-110,110),rng.randf_range(-76,-18)); var tween:=create_tween().bind_node(debris); tween.tween_property(debris,"global_position",target,0.28); tween.parallel().tween_property(debris,"modulate:a",0.0,0.34); tween.tween_callback(debris.queue_free)

func create_phase_burst(pos: Vector2, kind: String) -> void:
	var color := Color("#72d8ff") if kind=="pengu_boss" else (Color("#ff8b46") if kind=="cat_boss" else Color("#9edb63"))
	for index in 14:
		var spark:=Polygon2D.new(); spark.polygon=PackedVector2Array([Vector2(0,-5),Vector2(4,3),Vector2(-4,3)]); spark.color=color; spark.global_position=pos; spark.z_index=20; world.add_child(spark); var angle:=TAU*float(index)/14.0; var tween:=create_tween().bind_node(spark); tween.tween_property(spark,"global_position",pos+Vector2(cos(angle),sin(angle))*120.0,0.38); tween.parallel().tween_property(spark,"modulate:a",0.0,0.38); tween.tween_callback(spark.queue_free)

func create_overheat_fx(pos: Vector2) -> void:
	for index in 9:
		var smoke:=Polygon2D.new(); smoke.polygon=PackedVector2Array([Vector2(-7,4),Vector2(-4,-5),Vector2(5,-7),Vector2(8,3)]); smoke.color=Color(0.32,0.25,0.24,0.62); smoke.global_position=pos+Vector2(rng.randf_range(-8,8),0); smoke.z_index=19; world.add_child(smoke); var tween:=create_tween().bind_node(smoke); tween.tween_property(smoke,"global_position",smoke.global_position+Vector2(rng.randf_range(-18,18),-70),0.72); tween.parallel().tween_property(smoke,"modulate:a",0.0,0.72); tween.tween_callback(smoke.queue_free)

func shake_camera_once(amount: float) -> void:
	if not screen_shake or not is_instance_valid(camera): return
	if camera_shake_tween and camera_shake_tween.is_valid(): camera_shake_tween.kill()
	camera.offset=Vector2.ZERO
	camera_shake_tween=create_tween().bind_node(camera)
	camera_shake_tween.tween_property(camera,"offset",Vector2(-amount,amount*0.5),0.035)
	camera_shake_tween.tween_property(camera,"offset",Vector2(amount,-amount*0.4),0.035)
	camera_shake_tween.tween_property(camera,"offset",Vector2.ZERO,0.07)

func enemy_has_line_of_sight(body: CharacterBody2D) -> bool:
	var query := PhysicsRayQueryParameters2D.create(body.global_position,player.global_position,1)
	query.exclude = [body.get_rid()]
	var hit := get_world_2d().direct_space_state.intersect_ray(query)
	return hit.is_empty() or hit.get("collider")==player

func apply_ground_sensors(enemy: Dictionary, body: CharacterBody2D) -> void:
	if not body.is_on_floor() or float(enemy.turn_lock)>0.0: return
	var direction := signf(body.velocity.x)
	if direction==0.0: direction=float(enemy.dir)
	var space := get_world_2d().direct_space_state
	var sensor_x := float(enemy.sensor_half_width)+9.0
	var foot := float(enemy.foot_y)
	var edge_query := PhysicsRayQueryParameters2D.create(body.global_position+Vector2(direction*sensor_x,foot-5.0),body.global_position+Vector2(direction*sensor_x,foot+34.0),1)
	edge_query.exclude=[body.get_rid()]
	var wall_query := PhysicsRayQueryParameters2D.create(body.global_position+Vector2(0,-8),body.global_position+Vector2(direction*(sensor_x+12.0),-8),1)
	wall_query.exclude=[body.get_rid()]
	var ground_ahead := not space.intersect_ray(edge_query).is_empty()
	var wall_ahead := not space.intersect_ray(wall_query).is_empty()
	if not ground_ahead or wall_ahead:
		enemy.dir = -direction
		enemy.facing = float(enemy.dir)
		enemy.turn_lock = 0.32
		body.velocity.x = 0.0

func play_enemy_attack_sound(kind: String) -> void:
	var sound := "enemy_attack_forest.wav"
	if kind=="skeleton": sound="enemy_attack_skeleton.wav"
	elif kind=="spore": sound="enemy_attack_sludge.wav"
	AudioManager.play_sfx(sound,-14.0,rng.randf_range(0.92,1.08))

func create_enemy_lunge_fx(enemy: Dictionary) -> void:
	var body: CharacterBody2D = enemy.node
	if String(enemy.kind)=="skeleton":
		spawn_sheet_fx(FX_ARC,body.global_position+Vector2(float(enemy.facing)*30.0,-12),22,2,Vector2(0.70*float(enemy.facing),0.70),0.18)
	elif String(enemy.kind)=="bramble":
		spawn_leaf_burst(body.global_position+Vector2(float(enemy.facing)*22.0,-12),Color("#78c84d"))
	elif String(enemy.kind)=="mushroom":
		spawn_leaf_burst(body.global_position+Vector2(0,18),Color("#c57adf"))

func spawn_leaf_burst(pos: Vector2, color: Color) -> void:
	if not is_instance_valid(world): return
	for index in 7:
		var leaf := Polygon2D.new()
		leaf.polygon=PackedVector2Array([Vector2(-4,0),Vector2(0,-2),Vector2(5,0),Vector2(0,2)])
		leaf.color=color; leaf.global_position=pos; leaf.z_index=18; world.add_child(leaf)
		var angle := TAU*float(index)/7.0
		var tween := create_tween().bind_node(leaf)
		tween.tween_property(leaf,"global_position",pos+Vector2(cos(angle)*48.0,sin(angle)*28.0),0.28)
		tween.parallel().tween_property(leaf,"rotation",angle+1.8,0.28)
		tween.parallel().tween_property(leaf,"modulate:a",0.0,0.28)
		tween.tween_callback(leaf.queue_free)

func spawn_spore_landing_puff(pos: Vector2) -> void:
	if not is_instance_valid(world): return
	for index in 8:
		var mote := Polygon2D.new()
		mote.polygon=PackedVector2Array([Vector2(-4,-4),Vector2(4,-4),Vector2(4,4),Vector2(-4,4)])
		mote.color=Color(0.72,0.42,0.82,0.58); mote.global_position=pos; mote.z_index=16; world.add_child(mote)
		var angle := PI+PI*float(index)/7.0
		var target := pos+Vector2(cos(angle)*rng.randf_range(26.0,58.0),sin(angle)*rng.randf_range(14.0,32.0))
		var puff := create_tween().bind_node(mote); puff.tween_property(mote,"global_position",target,0.32); puff.parallel().tween_property(mote,"modulate:a",0.0,0.32); puff.tween_callback(mote.queue_free)

func perform_spore_burst(enemy: Dictionary) -> void:
	var body: CharacterBody2D = enemy.node
	var ring := Line2D.new()
	var points := PackedVector2Array()
	for index in 25:
		var angle := TAU*float(index)/24.0
		points.append(Vector2(cos(angle)*18.0,sin(angle)*10.0))
	ring.points=points; ring.width=5.0; ring.default_color=Color("#c36cff"); ring.position=body.position; ring.z_index=12; world.add_child(ring)
	var pulse := create_tween().bind_node(ring)
	pulse.tween_property(ring,"scale",Vector2(5.0,5.0),0.28).set_trans(Tween.TRANS_QUAD)
	pulse.parallel().tween_property(ring,"modulate:a",0.0,0.28)
	pulse.tween_callback(ring.queue_free)
	if player.position.distance_to(body.position)<132.0: take_damage(1,false,enemy)
	enemy.cooldown=1.8

func try_stomp_enemy(enemy: Dictionary, distance: Vector2) -> bool:
	if enemy.stomp_lock>0.0 or player.velocity.y<150.0: return false
	var width := 56.0 if is_boss_kind(enemy.kind) else 30.0
	var upper := 112.0 if is_boss_kind(enemy.kind) else 72.0
	if abs(distance.x)<=width and distance.y < -12.0 and distance.y > -upper:
		enemy.stomp_lock = 0.55
		player.velocity.y = -520.0
		invincible_time = maxf(invincible_time,0.18)
		damage_enemy(enemy,1,Vector2(sign(distance.x)*80.0,80.0))
		flash_message("PISÃO!",Color("#fff2b2"))
		return true
	return false

func perform_cat_grenade(enemy: Dictionary) -> void:
	var body: CharacterBody2D = enemy.node
	var target := player.global_position+player.velocity*0.22
	play_event_sfx("grenade_throw","boss_slam.wav",-13.0,1.22)
	var grenade_offsets: PackedFloat32Array
	if int(enemy.boss_phase)>=2: grenade_offsets=PackedFloat32Array([-145.0,0.0,145.0])
	else: grenade_offsets=PackedFloat32Array([0.0])
	for offset in grenade_offsets:
		var landing := Vector2(clampf(target.x+offset,arena_left()+48.0,arena_right()-48.0),526.0)
		var origin := body.global_position+Vector2(float(enemy.facing)*48.0,-36.0)
		var flight_time := 0.72+absf(offset)*0.00045
		var gravity := 720.0
		var launch := Vector2((landing.x-origin.x)/flight_time,(landing.y-origin.y-0.5*gravity*flight_time*flight_time)/flight_time)
		spawn_combat_projectile(enemy,origin,launch,"cat_grenade")
		create_typed_telegraph(TelegraphType.GROUND_AREA,enemy,Color("#ff7638"),landing,flight_time,92.0)
	enemy.cooldown=1.65

func perform_pengu_ice(enemy: Dictionary) -> void:
	var target_x := player.global_position.x
	play_ui_sound("boss_slam.wav",-10.0,1.35)
	var spikes := 7 if int(enemy.boss_phase)>=2 else 5
	for index in spikes:
		var centered := float(index)-float(spikes-1)*0.5
		var position := Vector2(clampf(target_x+centered*105.0,arena_left()+38.0,arena_right()-38.0),536.0)
		create_delayed_blast(enemy,position,Color("#63d9ff"),64.0,0.34+absf(centered)*0.065,"ice")
	enemy.cooldown=1.85

func create_delayed_blast(enemy: Dictionary, pos: Vector2, color: Color, radius: float, delay: float, blast_kind: String) -> void:
	if not is_instance_valid(world): return
	var warning := Line2D.new()
	var points := PackedVector2Array()
	for index in 33:
		var angle := TAU*float(index)/32.0
		points.append(Vector2(cos(angle)*radius,sin(angle)*radius*0.28))
	warning.points=points; warning.width=5.0; warning.default_color=Color(color.r,color.g,color.b,0.82); warning.position=pos; warning.z_index=17; world.add_child(warning)
	var pulse := create_tween().bind_node(warning)
	pulse.set_loops(2); pulse.tween_property(warning,"modulate:a",0.20,delay*0.23); pulse.tween_property(warning,"modulate:a",1.0,delay*0.23)
	var timer := get_tree().create_timer(delay)
	timer.timeout.connect(func():
		if not is_instance_valid(warning): return
		warning.queue_free()
		if blast_kind=="ice":
			spawn_penguin_ice_fx(Vector2(pos.x,560.0))
			spawn_sheet_fx(FX_IMPACT,pos+Vector2(0,-18),8,2,Vector2(1.35,1.35),0.26)
		elif blast_kind=="earth":
			spawn_dirt_burst(pos+Vector2(0,-4),10)
			spawn_sheet_fx(FX_ARC,pos+Vector2(0,-8),22,3,Vector2(1.25,0.72),0.28)
		else:
			spawn_sheet_fx(FX_ARC,pos+Vector2(0,-22),22,0,Vector2(2.1,1.5),0.34)
			spawn_sheet_fx(FX_IMPACT,pos+Vector2(0,-18),8,7,Vector2(1.55,1.55),0.26)
		create_shockwave(pos)
		if is_instance_valid(player) and absf(player.global_position.x-pos.x)<radius and absf(player.global_position.y-pos.y)<105.0:
			take_damage(1.0,false,enemy)
	,CONNECT_ONE_SHOT)

func spawn_penguin_ice_fx(pos: Vector2) -> void:
	if not is_instance_valid(world): return
	var sprite := Sprite2D.new()
	sprite.texture=PENGU_FX_ICE; sprite.region_enabled=true; sprite.region_rect=Rect2(9*48,0,48,128); sprite.scale=Vector2(1.65,1.65); sprite.global_position=Vector2(pos.x,pos.y-64.0*sprite.scale.y); sprite.z_index=19; world.add_child(sprite)
	var tween := create_tween().bind_node(sprite)
	tween.tween_property(sprite,"scale:y",2.0,0.10).set_trans(Tween.TRANS_BACK)
	tween.tween_interval(0.28)
	tween.tween_property(sprite,"modulate:a",0.0,0.16)
	tween.tween_callback(sprite.queue_free)

func create_shockwave(pos: Vector2) -> void:
	var wave := Line2D.new()
	wave.position = Vector2(pos.x,548.0) if pos.y>500.0 else pos+Vector2(0,34)
	wave.points = PackedVector2Array([Vector2(-24,0),Vector2(24,0)])
	wave.width = 13
	wave.default_color = Color("#ff9b55")
	wave.z_index = 9
	world.add_child(wave)
	var tween := create_tween()
	tween.tween_property(wave,"scale:x",9.0,0.36).set_trans(Tween.TRANS_QUAD)
	tween.parallel().tween_property(wave,"modulate:a",0.0,0.36)
	tween.tween_callback(wave.queue_free)

func create_attack_telegraph(enemy: Dictionary, color: Color) -> void:
	var candidate: Variant = enemy.get("node")
	if not is_instance_valid(candidate) or not is_instance_valid(player) or not is_instance_valid(world): return
	var kind := String(enemy.kind)
	var state_name := String(enemy.attack_state)
	if state_name in ["slam_windup","ice_windup","grenade_windup"]:
		create_typed_telegraph(TelegraphType.GROUND_AREA,enemy,color,player.global_position,0.52,92.0)
	elif kind=="spore" or state_name=="nova_windup":
		create_typed_telegraph(TelegraphType.RADIAL,enemy,color,candidate.global_position,0.48,96.0)
	elif kind in ["bramble","flying"] and state_name in ["ranged_windup","shoot_windup","projectile_windup"]:
		create_typed_telegraph(TelegraphType.ARC,enemy,color,player.global_position,0.48,0.0)
	else:
		create_typed_telegraph(TelegraphType.CHARGE,enemy,color,candidate.global_position,0.42,0.0)

func create_typed_telegraph(type: int, enemy: Dictionary, color: Color, target: Vector2, duration: float, size: float) -> Node2D:
	var root_node := Node2D.new()
	if not is_instance_valid(world): return root_node
	root_node.name="Telegraph_%s" % TelegraphType.keys()[type]
	root_node.z_index=16
	world.add_child(root_node)
	var origin: Vector2 = enemy.node.global_position if is_instance_valid(enemy.get("node")) else target
	if type in [TelegraphType.GROUND_AREA,TelegraphType.GROUND_LINE,TelegraphType.RADIAL]:
		root_node.global_position=Vector2(target.x,540.0) if type!=TelegraphType.RADIAL else origin
		var ring := Line2D.new()
		var points := PackedVector2Array()
		var radius := size if size>0.0 else 88.0
		for index in 33:
			var angle := TAU*float(index)/32.0
			points.append(Vector2(cos(angle)*radius,sin(angle)*radius*(0.20 if type!=TelegraphType.RADIAL else 0.55)))
		ring.points=points; ring.width=4.0; ring.default_color=Color(color.r,color.g,color.b,0.84); root_node.add_child(ring)
		if type==TelegraphType.GROUND_LINE:
			ring.scale.x=2.4
	elif type==TelegraphType.ARC:
		root_node.global_position=origin
		var arc := Line2D.new(); var relative := target-origin
		for index in 11:
			var ratio := float(index)/10.0
			arc.add_point(relative*ratio+Vector2(0,-sin(ratio*PI)*86.0))
		arc.width=2.0; arc.default_color=Color(color.r,color.g,color.b,0.50); root_node.add_child(arc)
		for point_index in range(0,arc.get_point_count(),2):
			var dot := Polygon2D.new(); dot.polygon=PackedVector2Array([Vector2(0,-3),Vector2(3,0),Vector2(0,3),Vector2(-3,0)]); dot.position=arc.get_point_position(point_index); dot.color=color; root_node.add_child(dot)
	elif type==TelegraphType.AIM:
		root_node.global_position=origin+Vector2(0,-20)
		var sight := Line2D.new(); sight.points=PackedVector2Array([Vector2.ZERO,target-origin+Vector2(0,20)]); sight.width=1.0; sight.default_color=Color(color.r,color.g,color.b,0.30); root_node.add_child(sight)
		for point_index in range(2,9,2):
			var marker := Polygon2D.new(); marker.polygon=PackedVector2Array([Vector2(0,-2),Vector2(2,0),Vector2(0,2),Vector2(-2,0)]); marker.position=(target-origin+Vector2(0,20))*float(point_index)/9.0; marker.color=Color(color.r,color.g,color.b,0.62); root_node.add_child(marker)
	else:
		root_node.global_position=origin+Vector2(0,-20)
		for index in 8:
			var spark := Polygon2D.new(); spark.polygon=PackedVector2Array([Vector2(0,-4),Vector2(3,2),Vector2(-3,2)]); spark.color=color; var angle := TAU*float(index)/8.0; spark.position=Vector2(cos(angle)*34.0,sin(angle)*24.0); root_node.add_child(spark)
			var converge := create_tween().bind_node(spark); converge.tween_property(spark,"position",Vector2.ZERO,duration).set_trans(Tween.TRANS_QUAD)
	var fade := create_tween().bind_node(root_node)
	fade.tween_property(root_node,"modulate:a",0.18,duration*0.65)
	fade.tween_property(root_node,"modulate:a",0.0,duration*0.35)
	fade.tween_callback(root_node.queue_free)
	return root_node

func spawn_aimed_projectile(enemy: Dictionary, speed: float, projectile_kind: String) -> void:
	var candidate: Variant = enemy.get("node")
	if not is_instance_valid(candidate) or not is_instance_valid(player): return
	var origin: Vector2 = candidate.global_position+Vector2(float(enemy.facing)*28.0,-12.0)
	var direction := (player.global_position+Vector2(0,-8)-origin).normalized()
	if projectile_kind in ["spore","bramble"]:
		spawn_combat_projectile(enemy,origin,Vector2(direction.x*speed,-215.0),"spore_bomb" if projectile_kind=="spore" else "thorn_seed")
	elif projectile_kind=="flying":
		spawn_combat_projectile(enemy,origin,direction*speed,"wind_crescent")
	elif projectile_kind=="sentinel":
		spawn_combat_projectile(enemy,origin,direction*speed,"rune_orb")
	else:
		spawn_combat_projectile(enemy,origin,direction*speed,projectile_kind)

func spawn_combat_projectile(enemy: Dictionary, origin: Vector2, velocity: Vector2, projectile_kind: String) -> void:
	if not is_instance_valid(world): return
	var root := Node2D.new()
	root.name = "CombatProjectile_%s" % projectile_kind
	root.global_position = origin
	root.z_index = 15
	var spec := projectile_definition(projectile_kind)
	var sprite := Sprite2D.new()
	sprite.texture = spec.texture
	sprite.region_enabled = true
	var row: int = int(spec.row)
	var frames: int = int(spec.frames)
	sprite.region_rect = Rect2(0,int(row)*64,64,64)
	sprite.scale=spec.scale
	sprite.modulate=spec.tint
	sprite.rotation = velocity.angle()
	root.add_child(sprite)
	if projectile_kind=="cat_bullet":
		var tracer := Line2D.new(); tracer.points=PackedVector2Array([Vector2(-28,0),Vector2(-4,0)]); tracer.width=2.0; tracer.default_color=Color(1.0,0.78,0.30,0.68); root.add_child(tracer)
	elif projectile_kind=="rune_orb":
		var rune := Line2D.new(); rune.points=PackedVector2Array([Vector2(0,-10),Vector2(9,0),Vector2(0,10),Vector2(-9,0),Vector2(0,-10)]); rune.width=2.0; rune.default_color=Color("#80fff0"); root.add_child(rune)
	world.add_child(root)
	projectiles.append({"node":root,"sprite":sprite,"velocity":velocity,"life":float(spec.life),"damage":1.0,"owner":enemy,"radius":float(spec.radius),"kind":projectile_kind,"frames":frames,"row":row,"clock":0.0,"gravity":float(spec.gravity),"spin":float(spec.spin),"explode_on_ground":bool(spec.explode_on_ground)})

func projectile_definition(kind: String) -> Dictionary:
	var definitions := {
		"thorn_seed":{"texture":FX_PROJECTILE,"row":3,"frames":11,"scale":Vector2(0.55,0.55),"tint":Color("#78c84d"),"radius":19.0,"gravity":520.0,"spin":2.0,"life":3.0,"explode_on_ground":false},
		"wind_crescent":{"texture":FX_ARC,"row":2,"frames":22,"scale":Vector2(0.72,0.44),"tint":Color(0.72,0.93,1.0,0.72),"radius":22.0,"gravity":0.0,"spin":0.0,"life":2.7,"explode_on_ground":false},
		"rune_orb":{"texture":FX_PROJECTILE,"row":2,"frames":11,"scale":Vector2(0.54,0.54),"tint":Color("#67e7d2"),"radius":20.0,"gravity":0.0,"spin":2.4,"life":3.2,"explode_on_ground":false},
		"spore_bomb":{"texture":FX_PROJECTILE,"row":1,"frames":11,"scale":Vector2(0.62,0.62),"tint":Color("#c975ed"),"radius":25.0,"gravity":610.0,"spin":1.8,"life":3.2,"explode_on_ground":true},
		"cat_bullet":{"texture":FX_PROJECTILE,"row":0,"frames":11,"scale":Vector2(0.34,0.22),"tint":Color("#ffb14d"),"radius":14.0,"gravity":0.0,"spin":0.0,"life":2.3,"explode_on_ground":false},
		"cat_grenade":{"texture":FX_PROJECTILE,"row":7,"frames":11,"scale":Vector2(0.58,0.58),"tint":Color("#ff7040"),"radius":28.0,"gravity":720.0,"spin":4.8,"life":3.5,"explode_on_ground":true},
		"ground_wave":{"texture":FX_ARC,"row":0,"frames":22,"scale":Vector2(0.86,0.42),"tint":Color("#9b6a36"),"radius":27.0,"gravity":0.0,"spin":0.0,"life":2.6,"explode_on_ground":false},
		"badger_rock":{"texture":FX_ARC,"row":3,"frames":22,"scale":Vector2(0.74,0.74),"tint":Color("#9a7247"),"radius":26.0,"gravity":660.0,"spin":3.2,"life":3.0,"explode_on_ground":true},
		"ice_shard":{"texture":FX_PROJECTILE,"row":2,"frames":11,"scale":Vector2(0.62,0.82),"tint":Color("#74e1ff"),"radius":23.0,"gravity":0.0,"spin":0.0,"life":2.8,"explode_on_ground":false}
	}
	return definitions.get(kind,{"texture":FX_PROJECTILE,"row":0,"frames":11,"scale":Vector2(0.68,0.68),"tint":Color.WHITE,"radius":23.0,"gravity":0.0,"spin":2.8,"life":3.4,"explode_on_ground":false})

func update_projectiles(delta: float) -> void:
	if projectiles.is_empty(): return
	var survivors: Array[Dictionary] = []
	for projectile in projectiles:
		var candidate: Variant = projectile.get("node")
		if not is_instance_valid(candidate): continue
		var root: Node2D = candidate
		projectile.life = float(projectile.life)-delta
		projectile.clock = float(projectile.clock)+delta
		if float(projectile.get("gravity",0.0))>0.0:
			projectile.velocity = Vector2(projectile.velocity)+Vector2(0,float(projectile.gravity)*delta)
		root.global_position += Vector2(projectile.velocity)*delta
		var sprite: Sprite2D = projectile.sprite
		var frame := int(float(projectile.clock)*18.0)%int(projectile.frames)
		sprite.region_rect = Rect2(frame*64,int(projectile.row)*64,64,64)
		if projectile.kind=="ground_wave":
			sprite.rotation = 0.0
		else:
			sprite.rotation += delta*float(projectile.get("spin",2.8))
		var hit_player: bool = String(projectile.kind)!="spore_bomb_armed" and is_instance_valid(player) and root.global_position.distance_to(player.global_position)<float(projectile.radius)+24.0
		if hit_player:
			take_damage(float(projectile.damage),false,projectile.owner)
			spawn_sheet_fx(FX_IMPACT,root.global_position,8,2 if projectile.kind=="flying" else 1,Vector2(0.8,0.8),0.20)
			if projectile.kind=="pengu_ray": spawn_penguin_freeze_fx(player.global_position)
			root.queue_free()
			continue
		if bool(projectile.get("explode_on_ground",false)) and root.global_position.y>=535.0:
			if projectile.kind=="spore_bomb":
				projectile.kind="spore_bomb_armed"; projectile.life=0.58; projectile.velocity=Vector2.ZERO; projectile.gravity=0.0; projectile.explode_on_ground=false; root.global_position.y=535.0; sprite.rotation=0.0
				create_typed_telegraph(TelegraphType.GROUND_AREA,projectile.owner,Color("#c975ed"),root.global_position,0.58,82.0)
				survivors.append(projectile)
				continue
			create_shockwave(root.global_position)
			var impact_row := 1 if projectile.kind in ["cat_grenade","spore_bomb"] else 3
			spawn_sheet_fx(FX_IMPACT,root.global_position+Vector2(0,-8),8,impact_row,Vector2(1.25,1.25),0.22)
			if projectile.kind in ["cat_grenade","spore_bomb"] and is_instance_valid(player) and root.global_position.distance_to(player.global_position)<105.0:
				take_damage(1.0,false,projectile.owner)
			root.queue_free()
			continue
		if projectile.kind=="spore_bomb_armed" and float(projectile.life)<=0.0:
			create_shockwave(root.global_position); spawn_sheet_fx(FX_IMPACT,root.global_position+Vector2(0,-8),8,1,Vector2(1.35,1.35),0.24)
			if is_instance_valid(player) and root.global_position.distance_to(player.global_position)<105.0: take_damage(1.0,false,projectile.owner)
			root.queue_free(); continue
		if float(projectile.life)<=0.0 or root.global_position.x<-120.0 or root.global_position.x>level_width+120.0 or root.global_position.y<-180.0 or root.global_position.y>740.0:
			root.queue_free()
			continue
		survivors.append(projectile)
	projectiles = survivors

func spawn_sheet_fx(texture: Texture2D, pos: Vector2, frames: int, row: int, scale_value: Vector2, duration: float) -> Sprite2D:
	var sprite := Sprite2D.new()
	if not is_instance_valid(world): return sprite
	sprite.texture = texture
	sprite.region_enabled = true
	sprite.region_rect = Rect2(0,row*64,64,64)
	sprite.global_position = pos
	sprite.scale = scale_value
	sprite.z_index = 22
	world.add_child(sprite)
	var tween := create_tween().bind_node(sprite)
	tween.tween_method(func(value: float): sprite.region_rect=Rect2(int(value)*64,row*64,64,64),0.0,float(frames-1),duration)
	tween.tween_property(sprite,"modulate:a",0.0,0.08)
	tween.tween_callback(sprite.queue_free)
	return sprite

func spawn_penguin_freeze_fx(pos: Vector2) -> void:
	if not is_instance_valid(world): return
	var sprite := Sprite2D.new()
	sprite.texture=PENGU_FX_FREEZE; sprite.region_enabled=true; sprite.region_rect=Rect2(4*48,0,48,128); sprite.global_position=pos+Vector2(0,-58); sprite.scale=Vector2(1.25,1.25); sprite.z_index=21; world.add_child(sprite)
	var tween := create_tween().bind_node(sprite)
	tween.tween_property(sprite,"modulate",Color("#d8f8ff"),0.08)
	tween.tween_interval(0.18)
	tween.tween_property(sprite,"modulate:a",0.0,0.18)
	tween.tween_callback(sprite.queue_free)

func perform_attack(step: int) -> void:
	var sizes := [Vector2.ZERO,Vector2(130,90),Vector2(150,102),Vector2(184,118)]
	var damages := [0,player_attack_damage,player_attack_damage,player_attack_damage*2]
	var knockbacks := [0.0,220.0,290.0,450.0]
	if is_instance_valid(combo_label):
		combo_label.text = "COMBO  %d/3  %s" % [step,"◆".repeat(step)]
	create_slash_fx(step)
	# Retângulo orientado pela mira: projeção longitudinal + distância perpendicular.
	var direction := attack_direction.normalized()
	var side := direction.orthogonal()
	for enemy in enemies:
		var candidate: Variant = enemy.get("node")
		if not is_instance_valid(candidate): continue
		var body: CharacterBody2D = candidate
		var relative: Vector2 = body.global_position-player.global_position
		var forward: float = relative.dot(direction)
		var lateral: float = absf(relative.dot(side))
		var attack_size: Vector2 = sizes[step]
		var target_padding := 28.0
		if enemy.kind=="flying": target_padding = 32.0
		elif is_boss_kind(enemy.kind): target_padding = 52.0
		if forward>=-target_padding and forward<=attack_size.x+target_padding and lateral<=attack_size.y/2.0+target_padding*0.72:
			var knockback: Vector2 = direction*float(knockbacks[step])
			if step==3: knockback.y -= 70.0
			damage_enemy(enemy,damages[step],knockback)

func damage_enemy(enemy: Dictionary, amount: int, knockback: Vector2) -> void:
	var candidate: Variant = enemy.get("node")
	if not is_instance_valid(candidate): return
	var body: CharacterBody2D = candidate
	var final_amount:=amount
	if is_boss_kind(String(enemy.kind)) and bool(enemy.get("posture_broken",false)): final_amount=maxi(amount+1,int(ceil(float(amount)*1.6)))
	enemy.hp = maxi(0,int(enemy.hp)-final_amount)
	enemy.hurt = 0.24
	body.velocity += knockback
	create_hit_impact(body.global_position,final_amount,knockback.normalized())
	spawn_sheet_fx(FX_IMPACT,body.global_position+Vector2(0,-12),8,7 if is_boss_kind(enemy.kind) else 0,Vector2(1.45,1.45) if is_boss_kind(enemy.kind) else Vector2(0.72,0.72),0.24)
	trigger_hitstop(0.025 if final_amount==1 else 0.04)
	combat_chain+=1; combat_chain_time=1.65
	if is_boss_kind(String(enemy.kind)) and not bool(enemy.get("posture_broken",false)):
		enemy.posture=maxf(0.0,float(enemy.posture)-float(final_amount)*(4.0 if combat_chain<4 else 6.0))
		if float(enemy.posture)<=0.0: break_boss_posture(enemy)
	if is_boss_kind(enemy.kind) and is_instance_valid(boss_hud_bar):
		var boss_pulse := create_tween().bind_node(boss_hud_bar)
		boss_pulse.tween_property(boss_hud_bar,"modulate",Color("#fff3a8"),0.04)
		boss_pulse.tween_property(boss_hud_bar,"modulate",Color.WHITE,0.14)
	var bar: ProgressBar = enemy.bar
	bar.value = enemy.hp
	bar.visible = not is_boss_kind(enemy.kind)
	bar.modulate.a = 1.0
	var tween := create_tween().bind_node(bar)
	tween.tween_interval(1.5)
	if not is_boss_kind(enemy.kind): tween.tween_property(bar,"modulate:a",0.0,0.16)
	if enemy.hp<=0:
		if body.has_meta("defeated"): return
		body.set_meta("defeated",true)
		maybe_drop_life(body.global_position,is_boss_kind(enemy.kind))
		if is_boss_kind(enemy.kind):
			flash_message("%s CAIU!  •  PORTAL LIBERADO" % current_boss_short_name(),Color("#ffe28a"))
			set_portal_active()
			play_music("Light Ambience 2.mp3",-8.0)
		finish_enemy_death(enemy)
	update_hud()

func finish_enemy_death(enemy: Dictionary) -> void:
	var candidate: Variant = enemy.get("node")
	if not is_instance_valid(candidate): return
	var body: CharacterBody2D = candidate
	var sprite: Sprite2D = enemy.sprite
	body.collision_layer=0; body.collision_mask=0; body.velocity=Vector2.ZERO
	if is_instance_valid(enemy.bar): enemy.bar.visible=false
	play_ui_sound("boss_slam.wav" if is_boss_kind(enemy.kind) else "enemy_hit.wav",-10.0,0.82 if is_boss_kind(enemy.kind) else 0.78)
	var animations: Dictionary = enemy.get("animations",{})
	if animations.has("death"):
		set_enemy_animation(enemy,"death")
		var frame_count := maxi(1,int(enemy.frames))
		var duration := 0.82 if is_boss_kind(enemy.kind) else 0.48
		var death_tween := create_tween().bind_node(body)
		death_tween.tween_method(func(progress: float):
			sprite.region_rect.position.x=mini(frame_count-1,int(progress*float(frame_count)))*int(enemy.fw)
		,0.0,1.0,duration)
		death_tween.parallel().tween_property(sprite,"modulate:a",0.0,0.22).set_delay(duration-0.20)
		death_tween.parallel().tween_property(sprite,"position:y",sprite.position.y-10.0,duration)
		await death_tween.finished
	else:
		var fade := create_tween().bind_node(body)
		fade.tween_property(sprite,"scale",sprite.scale*Vector2(1.16,0.72),0.10)
		fade.tween_property(sprite,"modulate:a",0.0,0.22)
		await fade.finished
	if is_instance_valid(body): body.queue_free()

func trigger_hitstop(duration: float) -> void:
	if hitstop_active: return
	hitstop_active = true
	Engine.time_scale = 0.10
	await get_tree().create_timer(duration,true,false,true).timeout
	Engine.time_scale = 1.0
	hitstop_active = false

func create_hit_impact(pos: Vector2, amount: int, direction: Vector2) -> void:
	play_ui_sound("kenney/impact_heavy.ogg",-15.0,clampf(0.96+float(amount)*0.04,0.9,1.16))
	create_floating_text(pos-Vector2(0,28),"-%d" % amount,Color("#fff0a8"))
	for i in 8:
		var spark := Polygon2D.new()
		spark.polygon = PackedVector2Array([Vector2(-3,-2),Vector2(5,0),Vector2(-3,2)])
		spark.color = Color("#fff4bd") if i%2==0 else Color("#ff765f")
		spark.position = pos+Vector2(rng.randf_range(-8,8),rng.randf_range(-10,10))
		spark.rotation = direction.angle()+rng.randf_range(-0.8,0.8)
		spark.z_index = 25
		world.add_child(spark)
		var burst_target := spark.position+direction*rng.randf_range(22,48)+Vector2(rng.randf_range(-18,18),rng.randf_range(-24,24))
		var burst := create_tween().bind_node(spark)
		burst.tween_property(spark,"position",burst_target,0.16).set_trans(Tween.TRANS_QUAD)
		burst.parallel().tween_property(spark,"modulate:a",0.0,0.16)
		burst.tween_callback(spark.queue_free)
	shake_camera_once(3.0)

func maybe_drop_life(pos: Vector2, guaranteed := false, persistent := false) -> void:
	if not guaranteed and rng.randf()>clampf(LIFE_DROP_CHANCE*difficulty_value("drops"),0.05,0.75): return
	var drop := Area2D.new()
	drop.position = pos-Vector2(0,22)
	drop.collision_layer = 0
	drop.collision_mask = 2
	drop.z_index = 15
	world.add_child(drop)
	life_drops.append(drop)
	var sprite := Sprite2D.new()
	sprite.texture = load(HEART_TEXTURE)
	sprite.scale = Vector2(1.35,1.35)
	drop.add_child(sprite)
	var shape := CollisionShape2D.new()
	var circle := CircleShape2D.new()
	circle.radius = 22
	shape.shape = circle
	drop.add_child(shape)
	drop.body_entered.connect(func(body: Node):
		if body==player: collect_life(drop)
	)
	var bob := create_tween().bind_node(drop).set_loops()
	bob.tween_property(sprite,"position:y",-8.0,0.55).set_trans(Tween.TRANS_SINE)
	bob.tween_property(sprite,"position:y",4.0,0.55).set_trans(Tween.TRANS_SINE)
	if not persistent:
		var expiry := create_tween().bind_node(drop)
		expiry.tween_interval(8.65)
		expiry.tween_property(drop,"modulate:a",0.0,0.35)
		expiry.tween_callback(drop.queue_free)

func collect_life(drop: Area2D) -> void:
	if not is_instance_valid(drop) or drop.has_meta("collected"): return
	if health>=max_health:
		flash_message("VIDA JA ESTA CHEIA",Color("#fff2b2"))
		return
	drop.set_meta("collected",true)
	health = minf(float(max_health),health+1.0)
	play_ui_sound("life_pickup_v10.wav",-9.0)
	update_hud()
	flash_message("+1 VIDA",Color("#ff8a93"))
	create_collect_burst(drop.global_position)
	var tween := create_tween().bind_node(drop)
	tween.tween_property(drop,"scale",Vector2(1.8,1.8),0.12).set_trans(Tween.TRANS_BACK)
	tween.parallel().tween_property(drop,"modulate:a",0.0,0.12)
	tween.tween_callback(drop.queue_free)

func create_slash_fx(step: int) -> void:
	var slash := Line2D.new()
	slash.width = 9.0+step*3.0
	slash.default_color = [Color.WHITE,Color("#b9fff0"),Color("#ffe28a"),Color("#ff9c64")][step]
	slash.position = attack_direction*34.0+Vector2(0,-2)
	slash.rotation = attack_direction.angle()
	var radius := 42.0+step*10.0
	var points := PackedVector2Array()
	for i in 8:
		var angle: float = lerpf(-1.05,1.05,float(i)/7.0)
		points.append(Vector2(cos(angle)*radius,sin(angle)*radius))
	slash.points = points
	slash.z_index = 8
	player.add_child(slash)
	var tween := create_tween()
	tween.tween_property(slash,"modulate:a",0.0,0.20)
	tween.parallel().tween_property(slash,"scale",Vector2(1.28,1.28),0.20)
	tween.tween_callback(slash.queue_free)

func create_dash_fx() -> void:
	for i in 4:
		var ghost := Sprite2D.new()
		ghost.texture = player_sprite.texture
		ghost.region_enabled = true
		ghost.region_rect = player_sprite.region_rect
		ghost.position = player.position-Vector2(dash_direction*i*22.0,0)
		ghost.scale = player_sprite.scale
		ghost.flip_h = dash_direction<0
		ghost.modulate = Color(0.35,0.95,0.82,0.30-float(i)*0.05)
		ghost.z_index = 8
		world.add_child(ghost)
		var tween := create_tween()
		tween.tween_property(ghost,"modulate:a",0.0,0.24)
		tween.tween_callback(ghost.queue_free)

func take_damage(amount: float, fell := false, attacker: Dictionary = {}) -> void:
	if invincible_time > 0:
		if fell:
			player.position = checkpoint
			player.velocity = Vector2.ZERO
		return
	var adjusted_amount := amount if fell else amount*difficulty_value("enemy_damage")
	if guarding and not fell:
		if parry_time>0.0:
			perform_perfect_parry(attacker)
			return
		var blocked_damage := maxf(0.2,adjusted_amount*BLOCK_DAMAGE_RATIO)
		health = maxf(0.0,health-blocked_damage)
		invincible_time = 0.42
		player.velocity.x *= -0.18
		create_guard_impact(false)
		play_ui_sound("enemy_hit.wav",-16.0,1.35)
		flash_message("DEFESA — DANO REDUZIDO A 35%",Color("#8fdcff"))
		update_hud()
		if health<=0.0:
			deaths += 1
			show_end(false)
		return
	health = maxf(0.0,health-maxf(0.25,adjusted_amount))
	invincible_time = 1.25
	damage_flash_time = 0.62
	play_ui_sound("player_hurt.wav",-7.0,rng.randf_range(0.94,1.04))
	flash_player_damage()
	update_hud()
	if health <= 0:
		deaths += 1
		show_end(false)
	elif fell:
		player.position = checkpoint
		player.velocity = Vector2.ZERO
	else:
		var knock_direction := -facing
		var attacker_node: Variant = attacker.get("node")
		if is_instance_valid(attacker_node): knock_direction=signf(player.global_position.x-attacker_node.global_position.x)
		player.velocity = Vector2(knock_direction*330,-350)

func perform_perfect_parry(attacker: Dictionary) -> void:
	parry_count += 1
	parry_time = 0.0
	invincible_time = maxf(invincible_time,0.34)
	player.velocity *= Vector2(0.15,0.45)
	create_guard_impact(true)
	play_ui_sound("portal_open.wav",-10.0,1.35)
	trigger_hitstop(0.065)
	if not attacker.is_empty():
		if is_boss_kind(String(attacker.get("kind",""))):
			attacker.posture=maxf(0.0,float(attacker.get("posture",100.0))-(34.0 if int(attacker.get("boss_phase",1))<3 else 27.0))
			if float(attacker.posture)<=0.0: break_boss_posture(attacker)
			else: stun_enemy(attacker,0.72)
		else: stun_enemy(attacker,1.65)
	flash_message("DEFESA PERFEITA!  •  INIMIGO ATORDOADO",Color("#fff3a8"))
	if is_instance_valid(boss_status_label) and not attacker.is_empty() and is_boss_kind(String(attacker.get("kind",""))):
		boss_status_label.text = "QUEBRA DE GUARDA  •  ATAQUE AGORA!"

func break_boss_posture(enemy: Dictionary) -> void:
	if bool(enemy.get("posture_broken",false)): return
	enemy.posture_broken=true; enemy.posture=0.0; enemy.stun_time=2.35; enemy.state_time=2.35; enemy.attack_state="stunned"; enemy.followup=""; enemy.cooldown=2.7
	enemy.node.velocity=Vector2(-float(enemy.facing)*145.0,-110.0)
	create_shockwave(enemy.node.global_position); create_phase_burst(enemy.node.global_position,String(enemy.kind)); shake_camera_once(9.0)
	play_event_sfx("posture_break","boss_slam.wav",-6.0,1.2)
	flash_message("POSTURA QUEBRADA!  •  DANO AMPLIFICADO",Color("#fff0a0"))

func stun_enemy(enemy: Dictionary, duration: float) -> void:
	var candidate: Variant = enemy.get("node")
	if not is_instance_valid(candidate) or candidate.has_meta("defeated"): return
	enemy.stun_time = duration
	enemy.attack_state = "stunned"
	enemy.state_time = duration
	enemy.cooldown = duration+0.35
	candidate.velocity = Vector2(-float(enemy.facing)*110.0,-90.0 if enemy.kind!="flying" else 0.0)
	spawn_sheet_fx(FX_IMPACT,candidate.global_position+Vector2(0,-16),8,2,Vector2(1.15,1.15) if not is_boss_kind(enemy.kind) else Vector2(1.8,1.8),0.28)

func create_guard_impact(perfect: bool) -> void:
	if not is_instance_valid(player) or not is_instance_valid(world): return
	spawn_sheet_fx(FX_SHIELD,player.global_position+Vector2(facing*18.0,-8.0),13,2 if perfect else 5,Vector2(1.75,1.75) if perfect else Vector2(1.18,1.18),0.30 if perfect else 0.20)
	if perfect:
		spawn_sheet_fx(FX_ARC,player.global_position+Vector2(facing*26.0,-8.0),22,2,Vector2(1.25*facing,1.25),0.25)
	shake_camera_once(5.0 if perfect else 2.5)
	if perfect:
		AudioManager.duck_music(4.5,0.26)
		play_ui_sound("kenney/impact_metal_heavy.ogg",-8.0,1.06)

func flash_player_damage() -> void:
	var base_scale := Vector2(1.35,1.35)
	var squash := create_tween()
	squash.tween_property(player_sprite,"scale",Vector2(1.55,1.12),0.07).set_trans(Tween.TRANS_QUAD)
	squash.tween_property(player_sprite,"scale",base_scale,0.19).set_trans(Tween.TRANS_BACK)
	create_damage_particles()
	if is_instance_valid(health_bar):
		var pulse := create_tween()
		pulse.tween_property(health_bar,"modulate",Color("#ffffff"),0.04)
		pulse.tween_property(health_bar,"modulate",Color("#ff3c3c"),0.08)
		pulse.tween_property(health_bar,"modulate",Color.WHITE,0.16)
	if is_instance_valid(hud):
		var red := ColorRect.new()
		red.color = Color(0.9,0.05,0.04,0.10*flash_intensity)
		red.mouse_filter = Control.MOUSE_FILTER_IGNORE
		red.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		hud.add_child(red)
		var fade := create_tween()
		fade.tween_property(red,"modulate:a",0.0,0.22)
		fade.tween_callback(red.queue_free)
	shake_camera_once(8.0)

func create_damage_particles() -> void:
	for i in 7:
		var shard := Polygon2D.new()
		shard.polygon = PackedVector2Array([Vector2(-3,-2),Vector2(4,0),Vector2(-2,3)])
		shard.color = Color("#ff6a5c")
		shard.position = player.position+Vector2(rng.randf_range(-15,15),rng.randf_range(-22,10))
		shard.z_index = 12
		world.add_child(shard)
		var target := shard.position+Vector2(rng.randf_range(-54,54),rng.randf_range(-55,-18))
		var burst := create_tween()
		burst.tween_property(shard,"position",target,0.28).set_trans(Tween.TRANS_QUAD)
		burst.parallel().tween_property(shard,"modulate:a",0.0,0.28)
		burst.tween_callback(shard.queue_free)

func get_boss() -> Dictionary:
	for enemy in enemies:
		var candidate: Variant = enemy.get("node")
		if is_boss_kind(enemy.kind) and is_instance_valid(candidate) and not candidate.has_meta("defeated"): return enemy
	return {}

func try_finish_level() -> void:
	if state!="playing": return
	if coins < total_coins:
		flash_message("AINDA FALTAM %d FRAGMENTOS" % (total_coins-coins),Color("#ff9b7d"))
		return
	if is_boss_level() and not get_boss().is_empty():
		flash_message("DERROTE %s PRIMEIRO" % current_boss_short_name(),Color("#ff9b7d"))
		return
	if level < levels.size()-1: transition_to_next_level()
	else: show_end(true)

func transition_to_next_level() -> void:
	state = "transition"
	player.velocity = Vector2.ZERO
	play_ui_sound("portal_enter.wav",-8.0)
	var portal_visual: Node2D = null
	if is_instance_valid(portal): portal_visual=portal.get_node_or_null("VisualRoot") as Node2D
	if is_instance_valid(portal_visual):
		var entry_target := portal.global_position+Vector2(0,-60)
		var entry := create_tween().bind_node(player)
		entry.tween_property(player,"global_position",entry_target,0.48).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
		entry.parallel().tween_property(player,"scale",Vector2(0.32,0.32),0.48).set_trans(Tween.TRANS_BACK)
		entry.parallel().tween_property(player,"modulate:a",0.0,0.42).set_delay(0.08)
		entry.parallel().tween_property(portal_visual,"scale",Vector2(1.13,1.13),0.22).set_trans(Tween.TRANS_BACK)
		entry.tween_property(portal_visual,"scale",Vector2.ONE,0.18)
		await entry.finished
	var transition := CanvasLayer.new()
	transition.name = "LevelTransition"
	transition.layer = 50
	add_child(transition)
	var wipe := ColorRect.new()
	wipe.color = Color.WHITE
	wipe.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var material := ShaderMaterial.new()
	material.shader = TRANSITION_SHADER
	material.set_shader_parameter("base_color",Color("#07171a"))
	material.set_shader_parameter("node_resolution",VIEW)
	material.set_shader_parameter("width",0.34)
	material.set_shader_parameter("shape_tiling",8.0)
	material.set_shader_parameter("shape_scroll",Vector2(0.035,-0.018))
	material.set_shader_parameter("shape_feathering",0.42)
	var gradient := Gradient.new()
	gradient.offsets = PackedFloat32Array([0.0,1.0])
	gradient.colors = PackedColorArray([Color.BLACK,Color.WHITE])
	var gradient_texture := GradientTexture2D.new()
	gradient_texture.gradient = gradient
	gradient_texture.width = 256
	gradient_texture.height = 16
	gradient_texture.fill_from = Vector2(0.0,0.5)
	gradient_texture.fill_to = Vector2(1.0,0.5)
	material.set_shader_parameter("gradient_texture",gradient_texture)
	var noise := FastNoiseLite.new()
	noise.frequency = 0.055
	noise.fractal_octaves = 3
	var shape_texture := NoiseTexture2D.new()
	shape_texture.width = 128
	shape_texture.height = 128
	shape_texture.seamless = true
	shape_texture.noise = noise
	material.set_shader_parameter("shape_texture",shape_texture)
	material.set_shader_parameter("factor",0.0)
	wipe.material = material
	transition.add_child(wipe)
	var transition_panel := PanelContainer.new()
	transition_panel.position = Vector2(276,210)
	transition_panel.size = Vector2(600,228)
	transition_panel.add_theme_stylebox_override("panel",ui_panel_style(Color(0.58,0.70,0.66,0.98),true))
	transition_panel.modulate.a = 0.0
	transition.add_child(transition_panel)
	var text_box := VBoxContainer.new()
	text_box.alignment = BoxContainer.ALIGNMENT_CENTER
	transition_panel.add_child(text_box)
	var text := Label.new()
	text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	var next_is_boss := is_boss_level(level+1)
	text.text = "O LIMIAR SELA A ARENA ADIANTE" if next_is_boss else "ENTRE RAÍZES, O CAMINHO SE REESCREVE"
	text.add_theme_font_size_override("font_size",13)
	text.add_theme_color_override("font_color",Color("#9be8cf"))
	text_box.add_child(text)
	var chapter := Label.new()
	chapter.text="CAPÍTULO  %s" % roman_number(level+2)
	chapter.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER
	chapter.add_theme_font_size_override("font_size",11)
	chapter.add_theme_color_override("font_color",Color("#c5a25a"))
	text_box.add_child(chapter)
	var next_name := Label.new()
	next_name.text = levels[level+1].name
	next_name.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	next_name.add_theme_font_override("font",DISPLAY_FONT)
	next_name.add_theme_font_size_override("font_size",28)
	next_name.add_theme_color_override("font_color",Color("#ffe2a3"))
	text_box.add_child(next_name)
	var next_subtitle := Label.new()
	next_subtitle.text=levels[level+1].subtitle
	next_subtitle.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER
	next_subtitle.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART
	next_subtitle.add_theme_font_size_override("font_size",13)
	next_subtitle.add_theme_color_override("font_color",Color("#d8e8dd"))
	text_box.add_child(next_subtitle)
	for mote_index in 18:
		var mote := Polygon2D.new()
		mote.polygon=PackedVector2Array([Vector2(0,-3),Vector2(3,0),Vector2(0,3),Vector2(-3,0)])
		mote.color=Color("#5ee5cb") if mote_index%2==0 else Color("#d29aff")
		mote.position=Vector2(70.0+float((mote_index*67)%1010),80.0+float((mote_index*83)%500))
		mote.modulate.a=0.0
		transition.add_child(mote)
		var passage := create_tween().bind_node(mote)
		passage.tween_interval(0.20+float(mote_index)*0.025)
		passage.tween_property(mote,"modulate:a",0.80,0.12)
		passage.parallel().tween_property(mote,"position",Vector2(576,324),0.72).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
		passage.tween_property(mote,"modulate:a",0.0,0.12)
	var cover := create_tween()
	cover.tween_method(func(value: float): material.set_shader_parameter("factor",value),0.0,1.0,0.72).set_trans(Tween.TRANS_QUAD)
	cover.parallel().tween_property(transition_panel,"modulate:a",1.0,0.35).set_delay(0.28)
	await cover.finished
	await get_tree().create_timer(0.42).timeout
	level += 1
	health = minf(float(max_health),health+1.0)
	save_progress()
	load_level()
	await get_tree().process_frame
	await get_tree().create_timer(0.28).timeout
	var reveal := create_tween()
	reveal.tween_property(transition_panel,"modulate:a",0.0,0.22)
	reveal.parallel().tween_method(func(value: float): material.set_shader_parameter("factor",value),1.0,0.0,0.76).set_trans(Tween.TRANS_QUAD)
	await reveal.finished
	transition.queue_free()

func roman_number(value: int) -> String:
	return ["I","II","III","IV","V","VI"][clampi(value-1,0,5)]

func show_end(victory: bool) -> void:
	if victory:
		show_final_credits()
		return
	state = "ended"
	AudioManager.stop_music()
	play_ui_sound("victory_stinger.wav" if victory else "death_stinger.wav",-6.0)
	var best_time := 0.0
	if victory:
		var records := ConfigFile.new()
		if records.load(RECORDS_PATH)!=OK:
			# Migração única de versões que guardavam recorde nas preferências.
			var legacy := ConfigFile.new()
			if legacy.load(SETTINGS_PATH)==OK:
				records.set_value("records","best_time",legacy.get_value("records","best_time",0.0))
		best_time = float(records.get_value("records","best_time",0.0))
		if best_time<=0.0 or run_time<best_time:
			best_time = run_time
			records.set_value("records","best_time",best_time)
			records.save(RECORDS_PATH)
	clear_screen()
	var layer := CanvasLayer.new()
	add_child(layer)
	add_end_background(layer,victory)
	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	layer.add_child(center)
	var panel := PanelContainer.new()
	panel.custom_minimum_size=Vector2(720,500)
	panel.add_theme_stylebox_override("panel",ui_panel_style(Color(0.72,0.78,0.78,0.98) if victory else Color(0.72,0.52,0.54,0.98)))
	center.add_child(panel)
	var box := VBoxContainer.new()
	box.alignment = BoxContainer.ALIGNMENT_CENTER
	box.add_theme_constant_override("separation",13)
	panel.add_child(box)
	var symbol := TextureRect.new()
	symbol.texture = HEART_FULL if victory else HEART_EMPTY
	symbol.custom_minimum_size=Vector2(64,64)
	symbol.expand_mode=TextureRect.EXPAND_IGNORE_SIZE
	symbol.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	box.add_child(symbol)
	var eyebrow := Label.new()
	eyebrow.text="O PORTAL RESPONDEU" if victory else "ECO DA QUEDA"
	eyebrow.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER
	eyebrow.add_theme_font_size_override("font_size",15)
	eyebrow.add_theme_color_override("font_color",Color("#9be8cf") if victory else Color("#f2a08f"))
	box.add_child(eyebrow)
	var title := Label.new()
	title.text = "JORNADA CONCLUÍDA" if victory else "JORGINHO CAIU"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_override("font",DISPLAY_FONT)
	title.add_theme_font_size_override("font_size",44)
	title.add_theme_color_override("font_color",Color("#fff2b2") if victory else Color("#ff927d"))
	box.add_child(title)
	var text := Label.new()
	text.text = ("Os fragmentos responderam ao chamado.\nO caminho de volta finalmente se abriu." if victory else "A floresta guardará este passo.\nRespire, aprenda o ritmo dos inimigos e tente outra vez.")
	text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	text.add_theme_font_size_override("font_size",20)
	text.add_theme_color_override("font_color",Color("#d8e8dd"))
	box.add_child(text)
	var stats := Label.new()
	var rank := "S" if run_time<210.0 and deaths==0 else ("A" if run_time<360.0 else "B")
	stats.text = ("RANK %s   •   TEMPO %02d:%02d   •   QUEDAS %d\nMELHOR TEMPO  %02d:%02d" % [rank,int(run_time/60.0),int(run_time)%60,deaths,int(best_time/60.0),int(best_time)%60]) if victory else ("TEMPO  %02d:%02d   •   FASE  %d/6   •   QUEDAS  %d" % [int(run_time/60.0),int(run_time)%60,level+1,deaths])
	stats.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	stats.add_theme_font_size_override("font_size",18)
	stats.add_theme_color_override("font_color",Color("#ffe28a"))
	box.add_child(stats)
	var again := make_button("JOGAR NOVAMENTE")
	again.pressed.connect(start_game)
	box.add_child(again)
	var menu := make_button("VOLTAR AO MENU")
	menu.pressed.connect(show_menu)
	box.add_child(menu)

func show_final_credits() -> void:
	state="credits_roll"; AudioManager.stop_music(); play_ui_sound("victory_stinger.wav",-6.0); play_music("Light Ambience 2.mp3",-8.0); clear_screen()
	if FileAccess.file_exists(SAVE_PATH): DirAccess.remove_absolute(ProjectSettings.globalize_path(SAVE_PATH))
	var layer := CanvasLayer.new(); layer.name="FinalCredits"; add_child(layer); add_end_background(layer,true)
	var title := Label.new(); title.position=Vector2(176,38); title.size=Vector2(800,66); title.text="JORNADA CONCLUÍDA"; title.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER; title.add_theme_font_override("font",DISPLAY_FONT); title.add_theme_font_size_override("font_size",42); title.add_theme_color_override("font_color",Color("#fff0b8")); layer.add_child(title)
	var subtitle := Label.new(); subtitle.position=Vector2(176,98); subtitle.size=Vector2(800,36); subtitle.text="Jorginho encontrou o caminho de volta. Obrigado por atravessar o limiar."; subtitle.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER; subtitle.add_theme_font_size_override("font_size",17); subtitle.add_theme_color_override("font_color",Color("#9be8cf")); layer.add_child(subtitle)
	var viewport := Control.new(); viewport.position=Vector2(176,146); viewport.size=Vector2(800,390); viewport.clip_contents=true; layer.add_child(viewport)
	var roll := Label.new(); roll.name="CreditsRoll"; roll.position=Vector2(30,390); roll.size=Vector2(740,980); roll.text=credits_text(); roll.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER; roll.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART; roll.add_theme_font_size_override("font_size",15); roll.add_theme_color_override("font_color",Color("#e5efe8")); viewport.add_child(roll)
	var scroll := create_tween().bind_node(roll); scroll.tween_property(roll,"position:y",-roll.size.y,34.0)
	var again := make_button("NOVA EXPERIÊNCIA",270); again.position=Vector2(292,570); again.custom_minimum_size.y=46; again.pressed.connect(show_difficulty_from_end); layer.add_child(again)
	var menu := make_button("MENU",190); menu.position=Vector2(590,570); menu.custom_minimum_size.y=46; menu.pressed.connect(show_menu); layer.add_child(menu)

func show_difficulty_from_end() -> void:
	show_menu()
	call_deferred("show_difficulty_selection")

func add_end_background(layer: CanvasLayer, victory: bool) -> void:
	var base := ColorRect.new()
	base.color = Color("#071f22") if victory else Color("#190d1c")
	base.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	layer.add_child(base)
	var forest := TextureRect.new()
	forest.texture = load(ILLUSION_PATH+"middle.png")
	forest.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	forest.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	forest.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	forest.modulate = Color(0.34,0.48,0.44,0.40) if victory else Color(0.30,0.16,0.28,0.46)
	layer.add_child(forest)
	var shade := ColorRect.new()
	shade.color = Color(0.01,0.025,0.03,0.46) if victory else Color(0.08,0.005,0.025,0.58)
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	layer.add_child(shade)
	for index in 18:
		var mote := Polygon2D.new()
		mote.polygon=PackedVector2Array([Vector2(0,-3),Vector2(3,0),Vector2(0,3),Vector2(-3,0)])
		mote.color=Color(0.55,1.0,0.82,0.22) if victory else Color(1.0,0.30,0.34,0.20)
		mote.position=Vector2(rng.randf_range(40,1110),rng.randf_range(50,620))
		layer.add_child(mote)
		var drift := create_tween().bind_node(mote).set_loops()
		drift.tween_property(mote,"position:y",mote.position.y-rng.randf_range(28,75),rng.randf_range(2.0,4.0)).set_trans(Tween.TRANS_SINE)
		drift.tween_property(mote,"position:y",mote.position.y,rng.randf_range(2.0,4.0)).set_trans(Tween.TRANS_SINE)

func _unhandled_input(event: InputEvent) -> void:
	if state=="cutscene" and event.is_pressed() and not event.is_echo():
		if event is InputEventKey or event is InputEventMouseButton or event is InputEventJoypadButton:
			cutscene_advance_requested=true
			get_viewport().set_input_as_handled()
			return
	if not remap_action.is_empty() and event is InputEventKey and event.pressed and not event.echo:
		if event.physical_keycode==KEY_ESCAPE:
			if is_instance_valid(remap_button): remap_button.text=get_action_key(remap_action)
			if is_instance_valid(settings_status_label): settings_status_label.text="Alteração cancelada."
			remap_action=""
			play_ui_sound("ui_back_v10.wav",-13.0)
			get_viewport().set_input_as_handled()
			return
		var key_name := OS.get_keycode_string(event.physical_keycode)
		for other_action in ["move_left","move_right","jump","attack","guard","dash","pause"]:
			if other_action==remap_action: continue
			for old_event in InputMap.action_get_events(other_action):
				if old_event is InputEventKey and old_event.physical_keycode==event.physical_keycode:
					InputMap.action_erase_event(other_action,old_event)
					if remap_buttons.has(other_action) and is_instance_valid(remap_buttons[other_action]): remap_buttons[other_action].text=get_action_key(other_action)
		replace_action_key(remap_action,event.physical_keycode)
		if is_instance_valid(remap_button): remap_button.text=key_name
		if is_instance_valid(settings_status_label): settings_status_label.text="%s atribuído a %s." % [key_name,remap_action.to_upper()]
		remap_action=""
		play_ui_sound("ui_confirm_v10.wav",-11.0,1.08)
		get_viewport().set_input_as_handled()
		return
	if event.is_action_pressed("pause"):
		if state == "playing": show_pause()
		elif state == "paused": resume_game()

func show_pause() -> void:
	state = "paused"
	get_tree().paused = true
	var layer := CanvasLayer.new()
	layer.name = "PauseLayer"
	layer.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	add_child(layer)
	var shade := ColorRect.new()
	shade.color = Color(0.01,0.03,0.05,0.82)
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	layer.add_child(shade)
	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	layer.add_child(center)
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation",12)
	center.add_child(box)
	var title := Label.new()
	title.text = "JORNADA PAUSADA"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size",38)
	title.add_theme_color_override("font_color",Color("#fff2b2"))
	box.add_child(title)
	var resume := make_button("CONTINUAR")
	resume.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	resume.pressed.connect(resume_game)
	box.add_child(resume)
	var restart := make_button("REINICIAR FASE")
	restart.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	restart.pressed.connect(restart_level)
	box.add_child(restart)
	var controls := Label.new()
	controls.text = "%s atacar  •  %s escudo/parry  •  %s impulso  •  %s saltar" % [action_prompt("attack"),action_prompt("guard"),action_prompt("dash"),action_prompt("jump")]
	controls.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	controls.add_theme_font_size_override("font_size",13)
	controls.add_theme_color_override("font_color",Color("#9be8cf"))
	box.add_child(controls)
	var quit := make_button("VOLTAR AO MENU")
	quit.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	quit.pressed.connect(func(): get_tree().paused=false; show_menu())
	box.add_child(quit)
	resume.call_deferred("grab_focus")

func restart_level() -> void:
	get_tree().paused = false
	state = "playing"
	deaths += 1
	load_level()

func resume_game() -> void:
	get_tree().paused = false
	state = "playing"
	var layer := get_node_or_null("PauseLayer")
	if layer: layer.queue_free()
