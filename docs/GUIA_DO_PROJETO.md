# Guia do projeto — Jorginho: Jornada Sem Retorno

## Visão geral

O ciclo central é **explorar → lutar → coletar fragmentos → alimentar o portal → avançar**. Nas arenas de chefe o portal permanece selado até a derrota do Guardião.

## Onde encontrar cada sistema

1. **Player e movimentação:** `scripts/main.gd`, seção de `_physics_process`, `start_dash` e `try_jump`. Os valores principais aparecem no Inspector do node `JorginhoGame`.
2. **Combate:** `perform_attack`, `damage_enemy`, `create_hit_impact` e `trigger_hitstop` em `scripts/main.gd`.
3. **Vida e dano:** exports `player_max_health`, `player_attack_damage` e `boss_max_health` no topo de `scripts/main.gd`.
4. **Inimigos:** `create_enemy` e `update_enemies`. Cogumelo, voador e Boss compartilham criação, mas possuem padrões separados.
5. **Fragmentos:** `create_coin` e `collect_coin` (internamente ainda usam esses nomes de função).
6. **Portal:** `create_portal`, `update_portal_charge`, `set_portal_active` e `create_portal_activation_fx`.
7. **Boss:** dados da fase III em `levels`, introdução em `start_boss_intro` e fases em `update_enemies`.
8. **HUD:** `create_hud` e `update_hud`.
9. **Menu:** `show_menu`, `make_menu_button` e `create_menu_motes`.
10. **Configurações e controles:** `show_settings`, `begin_remap`, `restore_default_controls`, `load_settings` e `save_settings`.
11. **Áudio:** `scripts/systems/audio_manager.gd`, registrado como Autoload `AudioManager` em `project.godot`.
12. **Fases:** cenas em `scenes/levels`. Plataformas, fragmentos e inimigos podem ser alterados no editor.

## Como adicionar uma fase

1. Duplique uma cena em `scenes/levels`.
2. Ajuste TileMap, início do Jorginho, portal, fragmentos e inimigos.
3. Inclua o caminho da nova cena no array `LEVEL_SCENES` em `scripts/main.gd`.

## Controles padrão

- A/D: mover
- Espaço: pular
- J: atacar
- Shift: dash
- Esc: pausar
- K+J: atalho de desenvolvedor para a próxima fase

Todos podem ser remapeados em Configurações e são salvos em `user://settings.cfg`.

# Roteiro para amostra de curso

1. **Apresentação:** explique o ciclo explorar, lutar, coletar e ativar o portal.
2. **Engine:** abra `project.godot` e mostre Godot 4.7.1, resolução base e InputMap.
3. **Cena principal:** abra `main.tscn`; use os nodes de `PresentationMap` como índice visual.
4. **Player:** abra o topo de `scripts/main.gd` e mostre os exports no Inspector.
5. **Movimentação:** mostre `_physics_process`, `try_jump` e `start_dash`.
6. **Combate:** mostre `perform_attack` e `damage_enemy`, destacando knockback e hitstop.
7. **Inimigos:** mostre `create_enemy` e os três ramos de `update_enemies`.
8. **Fragmentos:** mostre `create_coin` e `collect_coin`.
9. **Portal:** mostre os quatro métodos do portal e explique seus estados visuais.
10. **Boss:** mostre `start_boss_intro`, `boss_phase` e uma cena de arena em `scenes/levels`.
11. **HUD:** mostre `create_hud` e os corações cheios/vazios.
12. **Áudio:** abra `scripts/systems/audio_manager.gd` e explique a instância única com fade.
13. **Configurações:** execute o jogo, altere música, SFX, resolução, tela cheia e uma tecla.
14. **Level design:** abra uma cena em `scenes/levels` e mova uma plataforma ou um fragmento.
15. **Conclusão:** execute a sequência fase → fragmentos → portal e depois uma arena de chefe.

## Assets e créditos

Créditos verificáveis ficam em `docs/CREDITOS.md`, em `credits/ASSETS.md` e nas licenças originais da pasta `credits`. Itens cuja autoria não pôde ser confirmada estão marcados para revisão; nenhum autor foi inventado.
