extends SceneTree

# Gera as seis fases como TileMapLayer reais e editaveis.
# O mesmo TileMap que aparece no editor agora e exibido durante o jogo.

const GRID := 16
const OUTPUT := "res://scenes/levels/"
const PACK := "res://assets/selected/biomes/four_seasons/"
const TILESET_OUTPUT := "res://assets/editor_tiles/four_seasons/"

var fases := [
	{
		"arquivo":"fase_01_floresta_da_ilusao.tscn", "nome":"FASE 01 - FLORESTA DA ILUSAO",
		"subtitulo":"Siga os fragmentos por entre raizes e clareiras", "bioma":"illusion", "tema":"forest", "largura":3400.0,
		"tile":PACK+"four-seasons-platformer-07.png", "thin":[Vector2i(0,0),Vector2i(1,0),Vector2i(2,0)], "top":[Vector2i(0,2),Vector2i(1,2),Vector2i(2,2)], "body":[Vector2i(7,3),Vector2i(7,3),Vector2i(7,3)],
		"jogador":Vector2(140,475), "portal":Vector2(3210,509),
		"plataformas":[Vector4(0,560,3400,88),Vector4(580,450,200,32),Vector4(880,340,170,32),Vector4(1190,430,180,32),Vector4(1650,330,170,32),Vector4(2110,420,180,32),Vector4(2430,320,170,32),Vector4(2820,430,180,32)],
		"fragmentos":[Vector2(350,485),Vector2(650,390),Vector2(950,280),Vector2(1260,365),Vector2(1510,485),Vector2(1750,260),Vector2(2200,355),Vector2(2500,250),Vector2(2700,485),Vector2(2910,365),Vector2(3160,485),Vector2(3290,485)],
		"inimigos":[["mushroom",380,505],["bramble",1260,495],["flying",1750,285],["mushroom",2360,505],["bramble",2910,375],["flying",3160,350]], "segredos":[Vector2(990,275)]
	},
	{
		"arquivo":"fase_02_covil_das_raizes.tscn", "nome":"FASE 02 - COVIL DAS RAIZES",
		"subtitulo":"O Badger guarda a primeira passagem", "bioma":"forest_boss", "tema":"roots", "largura":2100.0,
		"tile":PACK+"four-seasons-platformer-07.png", "thin":[Vector2i(0,5),Vector2i(1,5),Vector2i(2,5)], "top":[Vector2i(0,7),Vector2i(1,7),Vector2i(2,7)], "body":[Vector2i(7,8),Vector2i(7,8),Vector2i(7,8)],
		"jogador":Vector2(420,475), "portal":Vector2(1910,509),
		"plataformas":[Vector4(0,560,2100,88),Vector4(350,430,190,24),Vector4(760,365,180,24),Vector4(1190,365,180,24),Vector4(1580,430,190,24)],
		"fragmentos":[], "inimigos":[["badger_boss",1450,480]], "segredos":[]
	},
	{
		"arquivo":"fase_03_forja_de_trapmoor.tscn", "nome":"FASE 03 - FORJA DE TRAPMOOR",
		"subtitulo":"Atravesse a forja corrompida e seus sentinelas", "bioma":"trapmoor", "tema":"foundry", "largura":3600.0,
		"tile":PACK+"four-seasons-platformer-12.png", "thin":[Vector2i(0,15),Vector2i(1,15),Vector2i(2,15)], "top":[Vector2i(0,17),Vector2i(1,17),Vector2i(2,17)], "body":[Vector2i(1,18),Vector2i(1,18),Vector2i(1,18)],
		"jogador":Vector2(140,475), "portal":Vector2(3410,509),
		"plataformas":[Vector4(0,560,3600,88),Vector4(550,450,180,24),Vector4(820,340,180,24),Vector4(1210,430,180,24),Vector4(1570,320,180,24),Vector4(2020,430,180,24),Vector4(2410,330,180,24),Vector4(2810,440,180,24),Vector4(3120,340,180,24)],
		"fragmentos":[Vector2(320,485),Vector2(620,390),Vector2(900,280),Vector2(1300,365),Vector2(1510,485),Vector2(1650,255),Vector2(2100,365),Vector2(2500,265),Vector2(2700,485),Vector2(2900,375),Vector2(3200,275),Vector2(3430,485)],
		"inimigos":[["skeleton",360,510],["skeleton",1180,510],["sentinel",1640,260],["spore",2260,520],["skeleton",2460,510],["sentinel",3180,280],["spore",3370,520]], "segredos":[Vector2(930,295)]
	},
	{
		"arquivo":"fase_04_arsenal_do_gato.tscn", "nome":"FASE 04 - ARSENAL DO GATO",
		"subtitulo":"Cat domina a distancia com tiros e granadas", "bioma":"factory_boss", "tema":"arsenal", "largura":2100.0,
		"tile":PACK+"four-seasons-platformer-11.png", "thin":[Vector2i(0,0),Vector2i(1,0),Vector2i(5,0)], "top":[Vector2i(0,3),Vector2i(1,3),Vector2i(5,3)], "body":[Vector2i(4,5),Vector2i(4,5),Vector2i(4,5)],
		"jogador":Vector2(420,475), "portal":Vector2(1910,509),
		"plataformas":[Vector4(0,560,2100,88),Vector4(300,440,200,24),Vector4(700,350,180,24),Vector4(1120,410,200,24),Vector4(1550,330,180,24)],
		"fragmentos":[], "inimigos":[["cat_boss",1450,480]], "segredos":[]
	},
	{
		"arquivo":"fase_05_abismo_congelado.tscn", "nome":"FASE 05 - ABISMO CONGELADO",
		"subtitulo":"O frio fecha o caminho para o ultimo portal", "bioma":"ice", "tema":"ice", "largura":3500.0,
		"tile":PACK+"four-seasons-platformer-06.png", "thin":[Vector2i(3,0),Vector2i(4,0),Vector2i(5,0)], "top":[Vector2i(6,18),Vector2i(7,18),Vector2i(8,18)], "body":[Vector2i(7,18),Vector2i(7,18),Vector2i(7,18)],
		"jogador":Vector2(140,475), "portal":Vector2(3310,509),
		"plataformas":[Vector4(0,560,3500,88),Vector4(520,445,190,24),Vector4(820,335,180,24),Vector4(1160,440,190,24),Vector4(1650,350,180,24),Vector4(1980,440,190,24),Vector4(2310,330,180,24),Vector4(2780,430,190,24),Vector4(3100,330,180,24)],
		"fragmentos":[Vector2(330,485),Vector2(610,380),Vector2(900,270),Vector2(1210,410),Vector2(1490,485),Vector2(1730,290),Vector2(2050,410),Vector2(2340,270),Vector2(2640,485),Vector2(2910,370),Vector2(3190,260),Vector2(3380,485)],
		"inimigos":[["flying",420,330],["sentinel",980,280],["skeleton",1320,510],["flying",1810,300],["sentinel",2370,275],["skeleton",2780,510],["flying",3220,290]], "segredos":[Vector2(910,285)]
	},
	{
		"arquivo":"fase_06_trono_do_inverno.tscn", "nome":"FASE 06 - TRONO DO INVERNO",
		"subtitulo":"Pengu aguarda no coracao da tempestade eterna", "bioma":"ice_boss", "tema":"throne", "largura":2200.0,
		"tile":PACK+"four-seasons-platformer-06.png", "thin":[Vector2i(0,5),Vector2i(1,5),Vector2i(2,5)], "top":[Vector2i(0,7),Vector2i(1,7),Vector2i(2,7)], "body":[Vector2i(7,8),Vector2i(7,8),Vector2i(7,8)],
		"jogador":Vector2(420,475), "portal":Vector2(2010,509),
		"plataformas":[Vector4(0,560,2200,88),Vector4(300,430,190,24),Vector4(690,335,180,24),Vector4(1080,420,200,24),Vector4(1480,335,180,24),Vector4(1840,430,190,24)],
		"fragmentos":[], "inimigos":[["pengu_boss",1520,480]], "segredos":[]
	}
]

func _initialize() -> void:
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(OUTPUT))
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(TILESET_OUTPUT))
	for dados in fases:
		gerar_fase(dados)
	print("FASES_FOUR_SEASONS_GERADAS=",fases.size())
	quit()

func adicionar(parent: Node, child: Node, root: Node) -> void:
	parent.add_child(child)
	child.owner = root

func coordenada_de_borda(opcoes: Array, coluna: int, largura: int) -> Vector2i:
	if coluna==0: return opcoes[0]
	if coluna==largura-1: return opcoes[2]
	return opcoes[1]

func criar_tileset(caminho: String, identificador: String) -> TileSet:
	var textura: Texture2D = load(caminho)
	var tiles := TileSet.new()
	tiles.tile_size = Vector2i(GRID,GRID)
	var atlas := TileSetAtlasSource.new()
	atlas.texture = textura
	atlas.texture_region_size = Vector2i(GRID,GRID)
	for atlas_y in int(textura.get_height()/GRID):
		for atlas_x in int(textura.get_width()/GRID):
			atlas.create_tile(Vector2i(atlas_x,atlas_y))
	tiles.add_source(atlas,0)
	var destino := TILESET_OUTPUT+identificador+".tres"
	var save_result := ResourceSaver.save(tiles,destino)
	if save_result!=OK:
		push_error("Nao foi possivel salvar o TileSet "+destino)
		return tiles
	return load(destino) as TileSet

func pintar_plataforma(mapa: TileMapLayer, rect: Vector4, dados: Dictionary) -> void:
	var x0 := roundi(rect.x/GRID)
	var y0 := roundi(rect.y/GRID)
	var largura := maxi(1,roundi(rect.z/GRID))
	var eh_chao := rect.w>=48.0
	var altura := maxi(1,ceili(rect.w/GRID)) if eh_chao else 1
	for y in altura:
		for x in largura:
			var atlas_coord: Vector2i
			if not eh_chao:
				atlas_coord=coordenada_de_borda(dados.thin,x,largura)
			elif y==0:
				atlas_coord=coordenada_de_borda(dados.top,x,largura)
			else:
				atlas_coord=coordenada_de_borda(dados.body,x,largura)
			mapa.set_cell(Vector2i(x0+x,y0+y),0,atlas_coord,0)

func gerar_fase(dados: Dictionary) -> void:
	var root := Node2D.new()
	root.name = String(dados.nome).replace(" ","_")
	root.set_meta("nome",dados.nome)
	root.set_meta("subtitulo",dados.subtitulo)
	root.set_meta("bioma",dados.bioma)
	root.set_meta("tema",dados.tema)
	root.set_meta("largura_base",dados.largura)
	root.set_meta("grade",GRID)

	var mapa := TileMapLayer.new()
	mapa.name = "TileMap_Terreno_E_Plataformas"
	mapa.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	mapa.z_index = 2
	mapa.tile_set = criar_tileset(String(dados.tile),String(dados.arquivo).get_basename())
	adicionar(root,mapa,root)
	for rect in dados.plataformas:
		pintar_plataforma(mapa,rect,dados)

	var pontos := Node2D.new()
	pontos.name = "Pontos_Editaveis"
	adicionar(root,pontos,root)
	criar_marcador(pontos,root,"INICIO_JORGINHO",dados.jogador)
	criar_marcador(pontos,root,"PORTAL_APARECE_AQUI",dados.portal)

	var fragmentos := Node2D.new()
	fragmentos.name = "Fragmentos"
	adicionar(root,fragmentos,root)
	for index in dados.fragmentos.size():
		criar_marcador(fragmentos,root,"Fragmento_%02d"%(index+1),dados.fragmentos[index])

	var inimigos := Node2D.new()
	inimigos.name = "Inimigos"
	adicionar(root,inimigos,root)
	for index in dados.inimigos.size():
		var item: Array = dados.inimigos[index]
		var marker := criar_marcador(inimigos,root,"%s_%02d"%[String(item[0]).to_upper(),index+1],Vector2(float(item[1]),float(item[2])))
		marker.set_meta("tipo",String(item[0]))

	var segredos := Node2D.new()
	segredos.name = "Vidas_Secretas"
	adicionar(root,segredos,root)
	for index in dados.segredos.size():
		criar_marcador(segredos,root,"Vida_%02d"%(index+1),dados.segredos[index])

	var packed := PackedScene.new()
	var result := packed.pack(root)
	if result==OK:
		result=ResourceSaver.save(packed,OUTPUT+String(dados.arquivo))
	if result!=OK: push_error("Nao foi possivel salvar "+String(dados.arquivo))
	root.free()

func criar_marcador(parent: Node, root: Node, nome: String, posicao: Vector2) -> Marker2D:
	var marker := Marker2D.new()
	marker.name = nome
	marker.position = posicao
	marker.gizmo_extents = 18.0
	adicionar(parent,marker,root)
	return marker
