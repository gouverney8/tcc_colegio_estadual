extends SceneTree

const CELL := Vector2i(16,16)
const MOTION_SCRIPT := preload("res://scripts/systems/parallax_motion.gd")
const LEVEL_SCENES := [
	"res://scenes/levels/fase_01_floresta_da_ilusao.tscn",
	"res://scenes/levels/fase_02_covil_das_raizes.tscn",
	"res://scenes/levels/fase_03_forja_de_trapmoor.tscn",
	"res://scenes/levels/fase_04_arsenal_do_gato.tscn",
	"res://scenes/levels/fase_05_abismo_congelado.tscn",
	"res://scenes/levels/fase_06_trono_do_inverno.tscn"
]
const TILE_TEXTURES := [
	"res://assets/terrain/tilesets_v2/tileset_fase_1.png",
	"res://assets/terrain/tilesets_v2/tileset_fase_2.png",
	"res://assets/terrain/tilesets_v2/tileset_fase_3.png"
]
const TILE_RESOURCES := [
	"res://assets/terrain/tilesets_v2/tileset_fase_1.tres",
	"res://assets/terrain/tilesets_v2/tileset_fase_2.tres",
	"res://assets/terrain/tilesets_v2/tileset_fase_3.tres"
]
const ANIMATIONS := [
	["res://assets/parallax/tropical/animated/water_strip.png",Vector2i(140,72),6,7.0,"res://assets/parallax/tropical/animated/water_frames.tres"],
	["res://assets/parallax/tropical/animated/leaves_strip.png",Vector2i(46,53),11,9.0,"res://assets/parallax/tropical/animated/leaves_frames.tres"],
	["res://assets/parallax/tropical/animated/birds_strip.png",Vector2i(91,86),7,8.0,"res://assets/parallax/tropical/animated/birds_frames.tres"],
	["res://assets/parallax/industrial/animated/smoke_big_strip.png",Vector2i(177,252),5,5.0,"res://assets/parallax/industrial/animated/smoke_big_frames.tres"],
	["res://assets/parallax/industrial/animated/smoke_small_strip.png",Vector2i(150,138),5,6.0,"res://assets/parallax/industrial/animated/smoke_small_frames.tres"],
	["res://assets/parallax/industrial/animated/embers_strip.png",Vector2i(95,126),3,8.0,"res://assets/parallax/industrial/animated/embers_frames.tres"],
	["res://assets/parallax/industrial/animated/birds_strip.png",Vector2i(82,81),5,8.0,"res://assets/parallax/industrial/animated/birds_frames.tres"],
	["res://assets/parallax/industrial/animated/fog_strip.png",Vector2i(387,69),5,1.6,"res://assets/parallax/industrial/animated/fog_frames.tres"],
	["res://assets/parallax/ruins_night/animated/waterfall_strip.png",Vector2i(127,182),7,8.0,"res://assets/parallax/ruins_night/animated/waterfall_frames.tres"],
	["res://assets/parallax/ruins_night/animated/splash_strip.png",Vector2i(106,74),7,8.0,"res://assets/parallax/ruins_night/animated/splash_frames.tres"],
	["res://assets/parallax/ruins_night/animated/orbs_strip.png",Vector2i(59,48),6,7.0,"res://assets/parallax/ruins_night/animated/orbs_frames.tres"],
	["res://assets/parallax/ruins_night/animated/birds_strip.png",Vector2i(37,29),6,9.0,"res://assets/parallax/ruins_night/animated/birds_frames.tres"],
	["res://assets/parallax/ruins_night/animated/fog_strip.png",Vector2i(319,69),4,1.4,"res://assets/parallax/ruins_night/animated/fog_frames.tres"]
]


func _init() -> void:
	for animation in ANIMATIONS:
		build_sprite_frames(animation)
	build_tropical()
	build_industrial()
	build_ruins()
	for family in 3:
		build_tileset(family)
	for level_index in LEVEL_SCENES.size():
		remap_level(level_index)
	print("CENARIOS_V2_OK")
	quit(0)


func build_sprite_frames(data: Array) -> void:
	var texture := load(String(data[0])) as Texture2D
	assert(texture != null)
	var cell: Vector2i = data[1]
	var frames := SpriteFrames.new()
	frames.set_animation_speed(&"default",float(data[3]))
	frames.set_animation_loop(&"default",true)
	for frame_index in int(data[2]):
		var atlas := AtlasTexture.new()
		atlas.atlas = texture
		atlas.region = Rect2i(frame_index*cell.x,0,cell.x,cell.y)
		frames.add_frame(&"default",atlas)
	assert(ResourceSaver.save(frames,String(data[4])) == OK)


func build_tileset(family: int) -> void:
	var texture := load(TILE_TEXTURES[family]) as Texture2D
	assert(texture != null)
	var image := texture.get_image()
	var tile_set := TileSet.new()
	tile_set.tile_size = CELL
	var atlas := TileSetAtlasSource.new()
	atlas.texture = texture
	atlas.texture_region_size = CELL
	for y in floori(float(image.get_height())/CELL.y):
		for x in floori(float(image.get_width())/CELL.x):
			if cell_has_pixels(image,Vector2i(x,y)):
				atlas.create_tile(Vector2i(x,y))
	tile_set.add_source(atlas,0)
	assert(ResourceSaver.save(tile_set,TILE_RESOURCES[family]) == OK)


func cell_has_pixels(image: Image, atlas_coord: Vector2i) -> bool:
	for y in CELL.y:
		for x in CELL.x:
			if image.get_pixel(atlas_coord.x*CELL.x+x,atlas_coord.y*CELL.y+y).a > 0.01:
				return true
	return false


func remap_level(level_index: int) -> void:
	var packed := load(LEVEL_SCENES[level_index]) as PackedScene
	assert(packed != null)
	var scene := packed.instantiate()
	var terrain := scene.get_node("TileMap_Terreno_E_Plataformas") as TileMapLayer
	var cells := terrain.get_used_cells()
	var occupied := {}
	for cell in cells:
		occupied[cell] = true
	terrain.clear()
	terrain.tile_set = load(TILE_RESOURCES[floori(float(level_index)/2.0)]) as TileSet
	for cell in cells:
		var above_empty := not occupied.has(cell+Vector2i.UP)
		var below_empty := not occupied.has(cell+Vector2i.DOWN)
		var row := 2
		if above_empty and below_empty:
			row = 4
		elif above_empty:
			row = 0
		elif below_empty:
			row = 6
		var atlas_coord := available_variant(terrain.tile_set,row,abs(cell.x*17+cell.y*31)%4)
		terrain.set_cell(cell,0,atlas_coord,0)
	var output := PackedScene.new()
	assert(output.pack(scene) == OK)
	var temporary_path: String = String(LEVEL_SCENES[level_index]).trim_suffix(".tscn")+".cenario_v2.tmp.tscn"
	assert(ResourceSaver.save(output,temporary_path) == OK)
	scene.free()
	var final_absolute := ProjectSettings.globalize_path(LEVEL_SCENES[level_index])
	var temporary_absolute := ProjectSettings.globalize_path(temporary_path)
	assert(DirAccess.remove_absolute(final_absolute) == OK)
	assert(DirAccess.rename_absolute(temporary_absolute,final_absolute) == OK)


func available_variant(tile_set: TileSet, preferred_row: int, variant: int) -> Vector2i:
	var source := tile_set.get_source(0) as TileSetAtlasSource
	for offset in 4:
		var candidate := Vector2i((variant+offset)%4,preferred_row)
		if source.has_tile(candidate):
			return candidate
	for index in source.get_tiles_count():
		return source.get_tile_id(index)
	return Vector2i.ZERO


func layer(root: Node2D, title: String, z: int, scroll: Vector2, repeat_width := 1536.0) -> Parallax2D:
	var result := Parallax2D.new()
	result.name = title
	result.z_index = z
	result.scroll_scale = scroll
	result.repeat_size = Vector2(repeat_width,0)
	result.repeat_times = 4
	root.add_child(result)
	result.owner = root
	return result


func sprite(root: Node2D, parent: Node, title: String, path: String, position: Vector2, scale_value := 1.0, alpha := 1.0) -> Sprite2D:
	var result := Sprite2D.new()
	result.name = title
	result.texture = load(path)
	result.position = position
	result.scale = Vector2.ONE*scale_value
	result.modulate.a = alpha
	result.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	parent.add_child(result)
	result.owner = root
	return result


func animated(root: Node2D, parent: Node, title: String, frames_path: String, position: Vector2, scale_value := 1.0) -> AnimatedSprite2D:
	var result := AnimatedSprite2D.new()
	result.name = title
	result.sprite_frames = load(frames_path)
	result.autoplay = &"default"
	result.position = position
	result.scale = Vector2.ONE*scale_value
	result.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	parent.add_child(result)
	result.owner = root
	return result


func motion(node: Node2D, velocity: Vector2, wrap_left: float, wrap_right: float, bob := 0.0) -> void:
	node.set_script(MOTION_SCRIPT)
	node.set("velocity",velocity)
	node.set("wrap_horizontal",true)
	node.set("wrap_left",wrap_left)
	node.set("wrap_right",wrap_right)
	node.set("bob_amount",bob)


func save_scene(root: Node2D, path: String) -> void:
	var packed := PackedScene.new()
	assert(packed.pack(root) == OK)
	assert(ResourceSaver.save(packed,path) == OK)
	root.free()


func build_tropical() -> void:
	var root := Node2D.new()
	root.name = "Parallax_Tropical_Editavel"
	var backdrop := layer(root,"01_Fundo_Completo_Fornecido",-19,Vector2(0.02,0.01),1276.0)
	sprite(root,backdrop,"Vale_Das_Aguas","res://assets/parallax/tropical/static/full_background.png",Vector2(638,359),0.76,1.0)
	var clouds := layer(root,"02_Nuvens_Suaves",-17,Vector2(0.05,0.02))
	for entry in [["cloud_1.png",Vector2(170,100),0.62],["cloud_3.png",Vector2(590,145),0.56],["cloud_2.png",Vector2(1030,105),0.60]]:
		sprite(root,clouds,"Nuvem_%d"%int(entry[1].x),"res://assets/parallax/tropical/static/"+entry[0],entry[1],entry[2],0.46)
	var birds := layer(root,"03_Passaros_Animados",-12,Vector2(0.18,0.07))
	var bird := animated(root,birds,"Passaros","res://assets/parallax/tropical/animated/birds_frames.tres",Vector2(160,170),0.58)
	motion(bird,Vector2(16,0),-140,1680,4.0)
	var details := layer(root,"04_Vida_Ambiental_Discreta",-5,Vector2(0.55,0.12))
	var leaves := animated(root,details,"Folhas_Animadas","res://assets/parallax/tropical/animated/leaves_frames.tres",Vector2(1080,300),0.52)
	motion(leaves,Vector2(-6,4),-100,1650,5.0)
	leaves.set("wrap_vertical",true)
	leaves.set("wrap_top",220.0)
	leaves.set("wrap_bottom",500.0)
	save_scene(root,"res://scenes/parallax/parallax_tropical.tscn")


func build_industrial() -> void:
	var root := Node2D.new()
	root.name = "Parallax_Industrial_Editavel"
	var backdrop := layer(root,"01_Fundo_Completo_Fornecido",-19,Vector2(0.02,0.01),1276.0)
	sprite(root,backdrop,"Forja_Ferroviaria","res://assets/parallax/industrial/static/full_background.png",Vector2(638,359),0.76,1.0)
	var birds_layer := layer(root,"02_Passaros_Animados",-14,Vector2(0.10,0.04))
	var birds := animated(root,birds_layer,"Passaros","res://assets/parallax/industrial/animated/birds_frames.tres",Vector2(150,145),0.48)
	motion(birds,Vector2(18,0),-120,1660,3.0)
	var fog := layer(root,"03_Nevoa_Lenta_Ao_Chao",-6,Vector2(0.34,0.08))
	for x in [280.0,900.0,1480.0]:
		var fog_sprite := animated(root,fog,"Nevoa_%d"%int(x),"res://assets/parallax/industrial/animated/fog_frames.tres",Vector2(x,548),0.72)
		fog_sprite.modulate.a = 0.36
	save_scene(root,"res://scenes/parallax/parallax_industrial.tscn")


func build_ruins() -> void:
	var root := Node2D.new()
	root.name = "Parallax_Ruinas_Noturnas_Editavel"
	var backdrop := layer(root,"01_Fundo_Completo_Fornecido",-19,Vector2(0.02,0.01),1276.0)
	sprite(root,backdrop,"Ruinas_Ao_Luar","res://assets/parallax/ruins_night/static/full_background.png",Vector2(638,359),0.76,1.0)
	# A ponte conectada e as cachoeiras com origem fisica ja fazem parte do
	# fundo completo. Os recortes soltos foram removidos para evitar deriva.
	var birds_layer := layer(root,"02_Passaros_Animados",-13,Vector2(0.12,0.05))
	var birds := animated(root,birds_layer,"Passaros","res://assets/parallax/ruins_night/animated/birds_frames.tres",Vector2(120,175),0.88)
	motion(birds,Vector2(14,0),-100,1650,3.0)
	var fog := layer(root,"03_Nevoa_Baixa_Lenta",-6,Vector2(0.34,0.08))
	for x in [260.0,850.0,1440.0]:
		var fog_sprite := animated(root,fog,"Nevoa_%d"%int(x),"res://assets/parallax/ruins_night/animated/fog_frames.tres",Vector2(x,548),0.72)
		fog_sprite.modulate.a = 0.34
	var details := layer(root,"04_Magia_Ambiental_Discreta",-5,Vector2(0.48,0.10))
	var orb := animated(root,details,"Orbes","res://assets/parallax/ruins_night/animated/orbs_frames.tres",Vector2(1080,330),0.62)
	motion(orb,Vector2(-2,-0.5),-80,1650,5.0)
	orb.set("wrap_vertical",true)
	orb.set("wrap_top",220.0)
	orb.set("wrap_bottom",460.0)
	save_scene(root,"res://scenes/parallax/parallax_ruins_night.tscn")
