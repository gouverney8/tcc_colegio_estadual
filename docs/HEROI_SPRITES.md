# Sprites novos do Jorginho

As imagens geradas no ChatGPT foram identificadas, renomeadas e recortadas para o jogo.

## Nomes em `assets/hero_new/`

| Nome antigo | Nome novo | O que é |
| :--- | :--- | :--- |
| `...15_09_39 (1).png` | `hero_combat_masks.png` | 1 pose colorida + máscaras brancas e FX (não usado no gameplay) |
| `...15_09_39 (2).png` | `hero_idle.png` | Idle em 2 quadros (respiração) |
| `...15_09_39 (3).png` | `hero_poses.png` | 4 poses: parado, olhar, guarda, sacar espada |
| `...15_09_39 (4).png` | `hero_attack.png` | Corte de espada em 4 quadros |
| `...15_09_39 (5).png` | `hero_run.png` | Corrida / passo (grade 3×3; o jogo usa só os que olham para a direita) |
| `...15_22_14 (1).png` | `hero_locomotion.png` | Pulo, queda, agachar, aterrissar, escorregar |
| `...15_22_15 (2).png` | `hero_jump_attack.png` | Ataque aéreo em 5 quadros |
| `...15_22_15 (3).png` | `hero_jump_fx.png` | Queda colorida + silhuetas e efeitos (reserva) |

## Folhas usadas no jogo

Em `assets/hero/jorginho/`, cada animação é uma faixa de quadros **256×256** com os pés alinhados embaixo:

- `jorginho_idle.png` (2)
- `jorginho_run.png` (4)
- `jorginho_jump.png` (1)
- `jorginho_fall.png` (2)
- `jorginho_attack.png` (4)
- `jorginho_jump_attack.png` (5)
- `jorginho_idle_fidget.png` (3) — olhar, guarda e sacar a espada após ficar parado
- `impact_burst.png`, `impact_crack.png`, `impact_debris.png` — recortes de `hero_new/rachadura.png` (fileira combinada + cratera + pedras)

Queda alta: cair da plataforma mais alta até o chão, sem pulo extra nem dash no ar. Aí o herói agacha e a rachadura nasce atrás dos pés.

O swordsman antigo permanece em `assets/hero/swordsman/` só como histórico.

## Ajustes no código

Valores atuais e como calibrar depois: [docs/AJUSTE_PES_PLATAFORMA.md](AJUSTE_PES_PLATAFORMA.md).

`scripts/main.gd`: `HERO_FRAME_SIZE = 256`, `HERO_SPRITE_SCALE = 0.36`, `PLAYER_SPRITE_FEET_OFFSET_Y = -7`, `ELEVATED_PLATFORM_TOP_INSET = 4`.
