extends Node

# Mixagem centralizada: uma faixa por vez e um pool fixo para efeitos.
const MUSIC_PATH := "res://assets/selected/music/"
const SFX_PATH := "res://assets/selected/sfx/"
const SFX_POOL_SIZE := 20

var music_volume := 0.75
var sfx_volume := 0.85
var current_track := ""
var current_track_volume_db := -8.0
var music_player: AudioStreamPlayer
var music_tween: Tween
var music_request_serial := 0
var sfx_players: Array[AudioStreamPlayer] = []
var sfx_cursor := 0

func _ready() -> void:
	music_player = AudioStreamPlayer.new()
	music_player.name = "MusicPlayer"
	music_player.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(music_player)
	for index in SFX_POOL_SIZE:
		var player := AudioStreamPlayer.new()
		player.name = "SfxPlayer%02d" % index
		player.process_mode = Node.PROCESS_MODE_ALWAYS
		player.finished.connect(_release_sfx_player.bind(player))
		add_child(player)
		sfx_players.append(player)
	if DisplayServer.get_name()=="headless": call_deferred("_cleanup_headless_audio")

func _cleanup_headless_audio() -> void:
	await get_tree().create_timer(0.5).timeout
	stop_music()
	for player in sfx_players:
		player.stop()
		player.stream = null

func _music_target_db() -> float:
	return linear_to_db(maxf(music_volume,0.001))+current_track_volume_db

func stop_music() -> void:
	music_request_serial += 1
	if music_tween and music_tween.is_valid(): music_tween.kill()
	music_tween = null
	if is_instance_valid(music_player):
		music_player.stop()
		music_player.stream = null
	current_track = ""

func play_music(track: String, track_volume_db := -8.0, fade_time := 0.30) -> void:
	var stream_path := MUSIC_PATH+track
	if not ResourceLoader.exists(stream_path):
		push_warning("Música ausente: %s" % stream_path)
		return
	current_track_volume_db = track_volume_db
	if current_track==track and music_player.playing:
		if music_tween and music_tween.is_valid(): music_tween.kill()
		music_tween=create_tween().bind_node(music_player)
		music_tween.tween_property(music_player,"volume_db",_music_target_db(),minf(fade_time,0.18))
		return
	music_request_serial += 1
	var request_id := music_request_serial
	if music_tween and music_tween.is_valid(): music_tween.kill()
	if fade_time>0.0 and music_player.playing:
		music_tween=create_tween().bind_node(music_player)
		music_tween.tween_property(music_player,"volume_db",-45.0,fade_time*0.45)
		music_tween.tween_callback(_commit_music.bind(request_id,track,load(stream_path),fade_time*0.55))
	else:
		# A primeira música começa junto com a cena; fade é reservado à troca de faixa.
		_commit_music(request_id,track,load(stream_path),0.0)

func _commit_music(request_id: int, track: String, stream: AudioStream, fade_in: float) -> void:
	if request_id!=music_request_serial or not is_instance_valid(music_player): return
	current_track=track
	music_player.stop()
	music_player.stream=stream
	music_player.volume_db=-45.0 if fade_in>0.0 else _music_target_db()
	music_player.play()
	if fade_in>0.0:
		music_tween=create_tween().bind_node(music_player)
		music_tween.tween_property(music_player,"volume_db",_music_target_db(),fade_in).set_trans(Tween.TRANS_SINE)

func play_sfx(file_name: String, volume_offset_db := 0.0, pitch_scale := 1.0) -> void:
	var stream_path := SFX_PATH+file_name
	if not ResourceLoader.exists(stream_path):
		push_warning("Efeito sonoro ausente: %s" % stream_path)
		return
	var player := _acquire_sfx_player()
	player.stream=load(stream_path)
	player.volume_db=linear_to_db(maxf(sfx_volume,0.001))+volume_offset_db
	player.pitch_scale=clampf(pitch_scale,0.72,1.32)
	player.play()

func _acquire_sfx_player() -> AudioStreamPlayer:
	for player in sfx_players:
		if not player.playing: return player
	var player := sfx_players[sfx_cursor%sfx_players.size()]
	sfx_cursor=(sfx_cursor+1)%sfx_players.size()
	player.stop()
	return player

func _release_sfx_player(player: AudioStreamPlayer) -> void:
	if is_instance_valid(player): player.stream=null

func duck_music(amount_db := 5.0, duration := 0.22) -> void:
	if not music_player.playing: return
	if music_tween and music_tween.is_valid(): music_tween.kill()
	music_tween=create_tween().bind_node(music_player)
	music_tween.tween_property(music_player,"volume_db",_music_target_db()-absf(amount_db),duration*0.25)
	music_tween.tween_property(music_player,"volume_db",_music_target_db(),duration*0.75).set_trans(Tween.TRANS_SINE)

func set_music_volume(value: float) -> void:
	music_volume=clampf(value,0.0,1.0)
	if music_player and music_player.playing: music_player.volume_db=_music_target_db()

func set_sfx_volume(value: float) -> void:
	sfx_volume=clampf(value,0.0,1.0)
