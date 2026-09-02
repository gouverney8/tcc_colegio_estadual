# Assets selecionados

## Critério geral

A seleção segue esta ordem: funcionamento, fluidez, leitura do gameplay, consistência visual, acabamento e manutenção. O projeto usa pixel art com filtro nearest, resolução interna de 1152×648 e poucos efeitos curtos. Packs completos ficam fora do repositório; somente os arquivos efetivamente usados permanecem em `assets/selected`. As licenças originais estão em `credits/` e o documento final de créditos em `docs/CREDITOS.md`.

## Classificação

### Recomendado

- `assets/hero`: seis spritesheets coerentes, leves e com frames regulares de 128×128.
- `assets/enemies`: cogumelo e criatura voadora preservados por compatibilidade.
- `assets/selected/enemies`: Bramble, Sentinela e Guardião Ancestral com animações separadas de idle, caminhada, ataque e dano.
- `assets/selected/biomes/illusion`: duas camadas de parallax e plataformas da Floresta da Ilusão.
- `assets/selected/biomes/trapmoor`: plataformas, iluminação e inimigos menores das ruínas.
- `assets/selected/music`: quatro MP3 escolhidos por função, sem duplicatas WAV.
- `assets/selected/sfx`: seleção funcional de efeitos para interface, movimento, combate, inimigos, coleta, portal e encerramentos.

### Recomendado com ajustes

- Forest of Illusion: `back` e `middle` são repetidos em `Parallax2D`; o recorte de plataforma teve margens transparentes removidas para formar pisos contínuos.
- Trapmoor Dungeon Tileset: usado apenas nas ruínas e arena, com modulação teal/violeta para dialogar com o fundo.
- Crimson Fantasy GUI: somente coração cheio/vazio e a paleta vermelho-dourada do HUD.
- Portal States: somente quatro regiões de 360×320 foram extraídas da folha de 1536×1024.
- RPG Items Sheet: somente o fragmento legível de 18×18 foi extraído da folha de 912×1040.
- Retro Inventory: somente coração cheio e vazio de 32×32 foram mantidos.
- Mork Dungeon: restrita a títulos; o texto funcional usa a fonte padrão mais legível.

### Situacional

- `Dark Ambient 3.mp3`: somente Boss Arena.
- `Action 1.mp3`: fase mais intensa e combate do Boss.
- Portal detalhado: somente saída/progressão, com no máximo doze partículas de ativação.
- Guardião Ancestral: somente arena final, em escala maior, duas fases e barra de vida fixa no topo.

### Não recomendado

- Minotauro fornecido: fundo branco, escala pequena e acabamento incompatível com o herói e os guardiões; não foi usado.
- Mistura simultânea dos tilesets Forest of Illusion e Trapmoor: evitada. Cada um possui uma região própria para impedir o vale da estranheza.
- Demais painéis e slots do Retro Inventory: não existe inventário no jogo e adicioná-los criaria ruído visual e código sem função.
- Camadas extras de nuvem e árvore frontal do Forest Parallax: encobrem a UI e elevam custo sem melhorar a leitura.
- `spark.png`: efeito raster grande para uma função já atendida por impactos procedurais curtos e leves.

### Fora do repositório

Packs completos, cópias WAV duplicadas, previews de desenvolvimento e backups internos foram retirados para deixar o GitHub apresentável. O runtime usa só `assets/selected` e os sprites ainda referenciados em `assets/hero`, `assets/enemies` e `assets/world`.

## Menu

**Assets utilizados:** `biomes/illusion/back.png`, `biomes/illusion/middle.png`, `ui/logo.png`, `ui/button.png`, `ui/panel.png` e `ui/cursor.png`.

**Motivo:** duas camadas bem escolhidas criam profundidade sem poluição. Elas se deslocam automaticamente e respondem discretamente ao cursor. Castelo, piso artificial, herói correndo e inimigo decorativo foram removidos; o logotipo foi reduzido e o menu recebeu um único painel de navegação.

**Assets descartados:** nuvens adicionais, composição `forest full` e árvore frontal.

**Motivo:** sobreposição excessiva, dimensões verticais inadequadas e competição com título e botões.

## Level 1

**Assets utilizados:** Floresta da Ilusão, plataforma florestal contínua, cogumelo, criatura voadora e Bramble.

**Motivo:** fundo e plataformas pertencem à mesma família visual. Árvores soltas sem relação com a colisão foram removidas; a própria camada `middle` já fornece vegetação coerente.

## Level 2

**Assets utilizados:** plataforma verde de Trapmoor, esqueletos, plantas rúnicas, Sentinelas e iluminação mural do mesmo pack.

**Motivo:** Trapmoor aparece como região separada e recebe parallax frio de suporte, nunca dividido na mesma plataforma com a floresta.

## Boss Arena

**Assets utilizados:** plataforma azul de Trapmoor, fundo violeta, iluminação mural, Guardião Ancestral e `Dark Ambient 3.mp3`.

**Motivo:** arena contínua de 2.100 pixels, sem voids, com cinco plataformas estreitas de esquiva e Boss central como fonte de dificuldade.

## Moedas / fragmentos

**Asset escolhido:** `assets/selected/collectible/portal_fragment.png`.

**Motivo:** recorte de 18×18 com alto contraste, aura simples e movimento por rotação/bobbing. A folha completa de 912×1040 não é carregada.

## Portal

**Assets escolhidos:** `inactive.png`, `charging_1.png`, `charging_2.png`, `open.png`.

**Motivo:** quatro estados comunicam progressão claramente. Cada textura é 360×320 e substitui a folha original de 1536×1024.

## HUD

**Assets utilizados:** corações recortados do Crimson Fantasy GUI, `ui/button.png` no painel de fragmentos e painéis escuros com bordas douradas/teal.

**Motivo:** corações têm leitura imediata. Painéis nativos escalam para resoluções diferentes sem nove imagens e sem conflito com a direção teal.

## Efeitos

**Assets utilizados:** efeitos curtos selecionados do Interface SFX Pack 1 e FreeSFX; quatro folhas selecionadas de `Effect and FX Pixel All Free.zip`: `Part 1/03.png` (escudo/parry), `Part 5/220.png` (impacto), `Part 10/464.png` (chama/projétil) e `Part 15/700.png` (arco/onda energética).

**Motivo:** as linhas ciano, violeta, laranja e verde foram escolhidas por função e bioma. As 176 folhas restantes não foram importadas, evitando poluição visual e custo de importação sem uso.

## Inimigos

**Assets utilizados:** cogumelo, criatura voadora, planta rúnica, esqueleto, Bramble, Sentinela e Guardião Ancestral.

**Motivo:** cada bioma recebe inimigos do mesmo pack de seu piso. O lodo vertical foi retirado por não possuir silhueta ou animação de criatura compatível. O esqueleto usa folhas derivadas de seus GIFs de idle, caminhada e ataque; os três guardiões usam folhas de 96 pixels com escalas e orientações próprias.

## Chefes da campanha — versão 1.2

**Assets utilizados:** `Bosses_Badger.zip`, `Bosses_Cat.zip` e `Bosses_Pengu.zip`, organizados em `assets/selected/bosses`. Foram selecionadas as folhas de idle, movimento, dano e todas as habilidades usadas pelo combate; Pengu também usa `pengu_fx_ice.png` e `pengu_fx_freeze.png`.

**Motivo:** os três pacotes compartilham moldura de 128×128, transparência, densidade de pixel e direção de arte, evitando o vale da estranheza. Badger funciona como primeiro teste de parry e leitura de solo, Cat como prova de posicionamento contra tiros/áreas e Pengu combina os dois repertórios no confronto final.

**Substituição:** o antigo Guardião Ancestral saiu do carregamento e foi arquivado de forma recuperável fora da importação ativa. Bramble e Sentinela continuam como elites comuns, pois ainda cumprem funções diferentes nas fases de exploração.

**Arenas:** as faixas de fundo que acompanham os tilesets de floresta, fábrica e gelo fornecidos nesta etapa foram isoladas sem deformação e usadas apenas nos respectivos confrontos. Elas são ampliadas com filtro nearest e repetidas em `Parallax2D`; os objetos de colisão continuam sendo as plataformas finas e legíveis já testadas.

## Áudio

- Menu: `Light Ambience 2.mp3`.
- Level 1: `Ambient 4.mp3`.
- Level 2 e combate mais intenso: `Action 1.mp3`.
- Boss Arena: `Dark Ambient 3.mp3`.
- Morte: a música da fase para e `death_stinger.wav` assume a cena.
- Vitória: `victory_stinger.wav` encerra a jornada.

MP3 foi escolhido porque as quatro faixas ocupam aproximadamente 24 MB, contra mais de 100 MB nas cópias WAV ativas. A licença original está em `credits/Fantasy_RPG_Music_License.pdf`.

## Decisões de performance

- Filtro nearest e pixel snapping estão habilitados no projeto.
- O HUD completo só é recalculado em eventos; por frame, atualizam-se apenas dash e o segundo do cronômetro.
- As camadas do menu são armazenadas em uma lista, evitando busca de grupos a cada frame.
- Não há partículas infinitas, pathfinding, luzes dinâmicas em massa ou shaders globais.
- Músicas, sons e texturas recorrentes possuem caminhos centralizados; assets selecionados ficam em uma única árvore curta.

## Polimento Kenney — versão 1.9

**UI Audio:** `rollover2`, `click3` e `switch14` foram selecionados para foco, confirmação e alternância. A separação perceptiva evita que toda interação pareça o mesmo evento.

**Impact Sounds:** quinze variações de passos distinguem grama, concreto e neve; três impactos curtos reforçam peso, metal e parry. O runtime usa pool fixo de players, sem criar um nó novo a cada reprodução.

**Industrial Expansion:** somente `tile_0042` (placa de alerta) e `tile_0064` (beacon) foram integrados, pequenos e no plano secundário das áreas de Trapmoor. O tileset completo não foi misturado ao cenário porque sua densidade e acabamento são deliberadamente mais simples que a arte principal.

## Folha de UI fornecida

**Usado:** logo, base de botão, painel transparente e cursor, recriados como derivados isolados com canal alpha e tamanhos finais controlados.

**Não usado:** inventário, minimapa, barra de experiência, mana, scrollbar, alertas, painéis de pergaminho e dezenas de ícones. Esses sistemas não existem no gameplay atual ou ocupariam espaço sem função.

**Processo:** edição por ImageGen em modo integrado usando a folha como referência visual, seguida de remoção local de chroma key, recorte, redimensionamento e validação de alpha. Prompts exigiram texto exato no logo, centros vazios para texto renderizado pelo Godot e ausência de rótulos/mockup.

## Resultado medido

- Conjunto ativo completo em `assets`: 57 arquivos-fonte, aproximadamente 26,6 MB; originais e variações não utilizados permanecem fora da importação em `archive_unused`.
- Originais recuperáveis arquivados: 986 arquivos, aproximadamente 982,4 MB, fora da importação por `.gdignore`.
- Render de QA em 1152×648, OpenGL Compatibility, NVIDIA RTX 3060: média de 0,65 ms de CPU e 0,34 ms de GPU por frame.
- Três fases carregadas em sequência; movimento, salto, ataque e dash simulados; portal apoiado no piso em todas e Guardião Ancestral presente/visível na arena.
- Execução normal de 1.200 frames: encerramento limpo, sem warnings, erros ou missing resources.
