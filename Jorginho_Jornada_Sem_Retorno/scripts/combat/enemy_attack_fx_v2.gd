class_name EnemyAttackFxV2
extends Sprite2D

@export_category("Animacao do efeito")
@export_range(1,16,1) var frame_count := 6
@export var frame_size := Vector2i(256,256)
@export_range(0.05,2.0,0.01) var animation_duration := 0.28
@export_range(0.0,0.5,0.01) var fade_duration := 0.07

func configure(texture_value: Texture2D, world_position: Vector2, scale_value: float, duration: float, flip_value: bool, anchor_y: float, rotation_value: float) -> void:
	texture=texture_value
	region_enabled=true
	region_rect=Rect2(Vector2.ZERO,Vector2(frame_size))
	global_position=world_position+Vector2(0,(float(frame_size.y)*0.5-anchor_y)*scale_value)
	scale=Vector2.ONE*scale_value
	flip_h=flip_value
	rotation=rotation_value
	animation_duration=duration
	play_animation()

func play_animation() -> void:
	var playback := create_tween().bind_node(self)
	playback.tween_method(set_frame_index,0.0,float(frame_count-1),animation_duration)
	playback.tween_property(self,"modulate:a",0.0,fade_duration)
	playback.tween_callback(queue_free)

func set_frame_index(frame_value: float) -> void:
	region_rect=Rect2(int(frame_value)*frame_size.x,0,frame_size.x,frame_size.y)
