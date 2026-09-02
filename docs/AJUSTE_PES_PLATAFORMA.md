# Ajustes manuais do Jorginho (pés, tamanho, impacto, prólogo)

Tudo fica no topo de `Jorginho_Jornada_Sem_Retorno/scripts/main.gd`, junto de `BASE_RESOLUTION`.  
Mude **só as constantes**. Não é preciso editar plataformas, TileMap nem as cenas.

Número **maior** no offset do sprite **desce** o desenho. Número **menor** **sobe**. A colisão do corpo não muda.

## Onde mexer agora

| Constante | Valor atual | O que faz | Se ficar ruim |
| :--- | ---: | :--- | :--- |
| `HERO_SPRITE_SCALE` | `0.36` | Tamanho no jogo (era `0.40`) | Suba para `0.38` se ficar miúdo; desça para `0.34` se ainda tapar demais |
| `HERO_CUTSCENE_SCALE` | `0.38` | Tamanho do Jorginho no prólogo | Mantenha ~`0.02` acima do gameplay |
| `HERO_PORTRAIT_SCALE` | `0.30` | Retrato na caixa de diálogo | `0.26` se encostar no texto; `0.34` se sumir |
| `HERO_CUTSCENE_FEET_Y` | `502.0` | Altura dos pés no palco do prólogo | Maior = desce o herói no cenário |
| `PLAYER_SPRITE_FEET_OFFSET_Y` | `-7.0` | Alinha os pés ao chão grosso (imagem 1) | `-9` sobe (flutua); `-5` desce (afunda) |
| `ELEVATED_PLATFORM_TOP_INSET` | `4.0` | Desce só a colisão das plataformas finas (imagem 2) | `2` se afundar na musgo; `6` se ainda flutuar |
| `PLATFORM_ONE_WAY_MARGIN` | `2.0` | Passar plataforma por baixo | Só suba para `4` se o pulo furar plataforma fina |
| `ELEVATED_PLATFORM_COLLISION_HEIGHT` | `16.0` | Altura da caixa das plataformas | Não mexer sem motivo |
| `IMPACT_BURST_SCALE` | `0.42` | Fumaça + rachadura da queda alta | `0.34` menor; `0.50` maior |
| `IMPACT_CRACK_SCALE` | `0.28` | Cratera que fica no chão | Idem |
| `IMPACT_DEBRIS_SCALE` | `0.34` | Pedras que sobem | Idem |
| `HIGH_FALL_DROP` | `180.0` | Queda mínima (px) para o efeito | Maior = só quedas mais longas |
| `HIGH_FALL_GROUND_Y` | `500.0` | Só dispara perto do chão da fase | Menor = também em plataformas do meio |

## Como calibrar os pés

1. Fique parado no **chão grosso** da fase 1 (grama + terra). Esse é o alvo da imagem 1.
2. Se flutuar ou afundar **no chão**, mexa `PLAYER_SPRITE_FEET_OFFSET_Y` de 1 em 1.
3. Suba numa **plataforma fina**. Se flutuar e o chão estiver certo, mexa só `ELEVATED_PLATFORM_TOP_INSET`.
4. Se mudar `HERO_SPRITE_SCALE`, o sprite é centrado: encolher **sobe** os pés. Compense somando no offset cerca de `119 * (escala_antiga - escala_nova)`.

Exemplo: de `0.36` para `0.34` → offset sobe ~`2.4` (de `-7` para ~`-4.5`).

## Queda alta (rachadura)

Folha original: `assets/hero_new/rachadura.png` (4 fileiras × 3 intensidades).

O jogo usa a **3ª fileira** (rachadura + fumaça + pedras), que é o impacto completo:

- `assets/hero/jorginho/impact_burst.png` — 3 quadros da fileira combinada
- `assets/hero/jorginho/impact_crack.png` — cratera da 1ª fileira, fica um instante no solo
- `assets/hero/jorginho/impact_debris.png` — pedras da 4ª fileira

Nasce **atrás** do herói, nos pés, só se a queda for longa até o chão **sem** pulo extra nem dash no ar.

## Prólogo (portal puxando)

As escalas antigas (`1.65` / `0.10`) eram do swordsman 64 px e **inchavam** o herói 256 px.

Agora o resolve só dá um pulso de `HERO_CUTSCENE_SCALE * 1.06` e o portal encolhe até `HERO_CUTSCENE_SCALE * 0.16`, sem `TRANS_BACK` (esse easing crescia antes de encolher).

A travessia de fase no portal do mapa também encolhe com `TRANS_QUAD` + `EASE_IN`.

## Ultimate (conhecimento)

Ativação: tecla **U** (ou **Y** no controle), só no chão. A carga **não gasta** os fragmentos do portal.

| Constante | Valor | Função |
| :--- | ---: | :--- |
| `ULTIMATE_BASE_COST` | `10` | Primeira carga |
| `ULTIMATE_DAMAGE_MULT` | `4` | Dano = ataque normal × 4 |
| `ULTIMATE_BEAM_LENGTH` | `430` | Alcance horizontal |
| `ULTIMATE_POSE_SCALE` | `0.52` | Tamanho da pose/FX |
| `ULTIMATE_BEAM_SCALE` | `0.70` | Tamanho do feixe |

Depois de usar, o próximo custo **dobra** (10 → 20 → 40). A carga soma cada moeda da jornada.

## Como desfazer

```gdscript
const HERO_SPRITE_SCALE := 0.40
const HERO_CUTSCENE_SCALE := 0.44
const PLAYER_SPRITE_FEET_OFFSET_Y := -12.0
const ELEVATED_PLATFORM_TOP_INSET := 0.0
```

E, na ação `"resolve"` / `"pull"` de `show_origin_cutscene`, voltar os tweens `Vector2(1.65,1.65)` e `Vector2(0.10,0.10)`.
