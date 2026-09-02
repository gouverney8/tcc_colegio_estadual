# Ajuste dos pés nas plataformas

Aplicado em 2 de setembro de 2026. Serve para desfazer o alinhamento se os pés ficarem baixo demais, se o pulo atravessar plataforma fina, ou se o visual do dash/ataque parecer deslocado.

## Problema

O Jorginho parecia flutuar em todas as plataformas: os pés desenhados ficavam acima do chão, embora a cápsula de colisão já estivesse apoiada.

## Avaliação de risco (antes da mudança)

| Sistema | Depende do sprite Y? | Risco |
| --- | --- | --- |
| Colisão, pulo, gravidade, `is_on_floor` | Não: usam o `CharacterBody2D` | Nenhum |
| Câmera | Não: é filha do corpo | Nenhum |
| Ataque, dash, dano | Quase não: usam `player.global_position` | O golpe visual pode ficar ~13 px acima dos pés; a hitbox não muda |
| Guarda / aparar | Ícone preso ao corpo | Escudo pode parecer um pouco alto no peito |
| Tween de squash no parry | Só altera `scale` | Nenhum |
| Fantasma do dash | Era spawnado em `player.position` sem o offset do sprite | Ajustado junto, para não ficar flutuando |
| Atravessar plataforma por baixo (one-way) | Margem menor (10 → 2) | Queda muito rápida *pode* furar plataforma fina. Se acontecer, subir a margem para `4.0` ou `6.0`, não voltar para `10.0` |
| TileMap das fases | Não foi editado | Coordenadas X/Y das cenas permanecem iguais |

Não foi alterado o array `levels[].platforms` nem as cenas em `scenes/levels`.

## Onde foi aplicado

Arquivo único: `Jorginho_Jornada_Sem_Retorno/scripts/main.gd`

### Constantes (topo do arquivo, junto de `BASE_RESOLUTION`)

| Constante | Original | Tentativas | Valor atual |
| --- | ---: | ---: | ---: |
| `PLAYER_SPRITE_FEET_OFFSET_Y` | `-5.0` (flutuava) | `8.0` → `7.0` (afundava) | `3.0` |
| `PLATFORM_ONE_WAY_MARGIN` | `10.0` | — | `2.0` |
| `ELEVATED_PLATFORM_COLLISION_HEIGHT` | `14.0` | — | `16.0` |

Número **menor** no offset do sprite **sobe** o desenho. Número **maior** **desce**. A colisão não muda.

### Usos

1. `create_player` — `player_sprite.position.y = PLAYER_SPRITE_FEET_OFFSET_Y`  
   Desce o desenho até o topo da colisão.
2. `create_platform` — `collision_height` das plataformas elevadas e `one_way_collision_margin`  
   Topo da colisão continua em `rect.y`. A caixa fica com 16 px (tile) e a margem one-way deixa de empurrar o corpo ~10 px para cima.
3. `create_dash_fx` — fantasma soma `player_sprite.position`  
   O rastro do dash acompanha os pés novos.

## Como desfazer manualmente

No topo de `scripts/main.gd`, volte as três constantes:

```gdscript
const PLAYER_SPRITE_FEET_OFFSET_Y := -5.0
const PLATFORM_ONE_WAY_MARGIN := 10.0
const ELEVATED_PLATFORM_COLLISION_HEIGHT := 14.0
```

Se só o dash ficar estranho, em `create_dash_fx` restaure:

```gdscript
ghost.position = player.position-Vector2(dash_direction*i*22.0,0)
```

Se os pés ainda afundarem, baixe o offset (ex.: `2.0` ou `1.0`). Se voltarem a flutuar, suba o offset (ex.: `4.0` ou `5.0`). Não mexa na margem.
