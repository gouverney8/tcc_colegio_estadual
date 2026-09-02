# Jorginho: Jornada Sem Retorno

Jogo de ação e plataforma 2D em pixel art, desenvolvido como **trabalho de conclusão de curso** e apresentação da amostra de cursos.

**Autor:** Gustavo Bento Ouverney  
**Orientação:** Carlos Alcantara  
**Engine:** [Godot 4.7](https://godotengine.org/)  
**Versão:** 2.0.0

O ciclo do jogo é **explorar → lutar → coletar fragmentos → despertar o portal → avançar**. Em arenas de chefe, o portal só se revela depois da derrota do Guardião.

---

## Como executar

O passo a passo completo está em **[docs/COMO_RODAR.md](docs/COMO_RODAR.md)**.

Resumo:

1. Instale o **Godot 4.7** (versão estável).
2. Clone este repositório.
3. No Godot, importe a pasta `Jorginho_Jornada_Sem_Retorno` (arquivo `project.godot`).
4. Pressione **F5** para jogar.

Para gerar um `.exe` do Windows, veja [docs/COMO_EXPORTAR.md](docs/COMO_EXPORTAR.md).

---

## Controles

| Ação | Teclado | Controle |
| --- | --- | --- |
| Andar | A / D ou setas | Analógico ou D-pad |
| Pular (pulo duplo) | Espaço, W ou seta para cima | A |
| Atacar | Clique esquerdo, J ou Z | X |
| Guardar / aparar | Clique direito ou K | LB |
| Impulso (dash) | Shift | B |
| Pausar | Esc | Start |

Os comandos podem ser remapeados no menu de configurações. Há quatro dificuldades: Trilha dos Vaga-Lumes, Passos pelo Limiar, Jornada sem Retorno e Eclipse do Último Portal.

---

## Campanha

Seis fases editáveis no editor do Godot:

1. Floresta da Ilusão
2. Covil das Raízes
3. Forja de Trapmoor
4. Arsenal do Gato
5. Abismo Congelado
6. Trono do Inverno

Cada cena em `Jorginho_Jornada_Sem_Retorno/scenes/levels` contém o TileMap, o ponto inicial do Jorginho, a posição do portal, fragmentos, inimigos e vidas escondidas. Alterar esses marcadores no editor muda a fase de verdade.

---

## Estrutura do repositório

```
.
├── README.md                          ← você está aqui
├── docs/                              ← documentos finais do TCC
│   ├── COMO_RODAR.md
│   ├── COMO_EXPORTAR.md
│   ├── CREDITOS.md
│   ├── GUIA_DO_PROJETO.md
│   ├── CHANGELOG.md
│   └── atividade-amostra-de-cursos-2026.docx
└── Jorginho_Jornada_Sem_Retorno/      ← projeto Godot
    ├── project.godot
    ├── main.tscn
    ├── scenes/levels/
    ├── scripts/
    ├── assets/
    └── credits/                       ← licenças originais dos pacotes
```

Documentos úteis:

- [Como rodar o jogo](docs/COMO_RODAR.md)
- [Guia do projeto](docs/GUIA_DO_PROJETO.md) — onde está cada sistema e como apresentar em sala
- [Créditos e licenças](docs/CREDITOS.md) — autoria própria e contribuições de outros projetos
- [Assets selecionados](docs/ASSETS_SELECIONADOS.md)
- [Histórico de versões](docs/CHANGELOG.md)
- [Análise geral](docs/ANALISE_GERAL_DO_JOGO.md)

---

## Créditos

O código, a direção e o TCC são de **Gustavo Bento Ouverney**.

O jogo utiliza arte, música e efeitos de vários autores e pacotes (Kenney, ElvGames, Ozzbit Games, Analog Studios, CraftPix, AlkaKrab e outros). A lista completa, com licenças e arquivos originais, está em:

- **[docs/CREDITOS.md](docs/CREDITOS.md)** — documento final de créditos
- **[Jorginho_Jornada_Sem_Retorno/credits/](Jorginho_Jornada_Sem_Retorno/credits/)** — PDFs e textos de licença preservados dos pacotes

Este é um projeto educacional. Antes de republicar ou comercializar, confira os termos de cada pacote.
