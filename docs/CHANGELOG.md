# Histórico de versões

## Ajuste 2026-09-02 — pés, escala, rachadura e prólogo

- Personagem um pouco menor (`HERO_SPRITE_SCALE` 0.40 → 0.36). Pés do chão grosso recalibrados; plataformas finas descem só a colisão (`ELEVATED_PLATFORM_TOP_INSET`).
- Queda alta passou a usar `hero_new/rachadura.png`: cratera, fumaça em 3 quadros e pedras atrás do herói.
- Prólogo: o puxão do portal não inchava mais o sprite 256 px (escalas antigas 1.65). Travessia de fase sem `TRANS_BACK`.
- Tabela para calibrar depois: [docs/AJUSTE_PES_PLATAFORMA.md](AJUSTE_PES_PLATAFORMA.md).

## Ajuste 2026-09-02 — novo sprite do Jorginho

- Folhas do ChatGPT em `assets/hero_new/` identificadas e renomeadas (`hero_idle`, `hero_run`, `hero_attack`, etc.).
- Gameplay passou a usar faixas em `assets/hero/jorginho/` (256×256). O swordsman antigo fica só no histórico.
- Parado ~5,5 s: olhar, guarda e sacar a espada (`hero_poses`).
- Queda alta até o chão, sem pulo/dash no ar: fumaça e espinhos atrás dos pés (`hero_jump_fx`).
- Como desfazer / mapa dos arquivos: [docs/HEROI_SPRITES.md](HEROI_SPRITES.md).

## Ajuste 2026-09-02 — moeda CEP girando

- Coletável do mundo passou a usar `assets/selected/collectible/moeda-cep/` (quadros 1–12 em loop a 12 fps).
- Tamanho visual igual ao fragmento anterior (40,5 px). O prólogo segue com `portal_fragment.png`.
- Coleta: zoom da face CEP enquanto sobe; depois encolhe sugada pela barra de fragmentos e explode no HUD.
- Barra de fragmentos com moldura dourada da moeda; na chegada ela incha, brilha ouro/verde e um clarão atravessa o preenchimento.

## Ajuste 2026-09-02 — pés alinhados às plataformas

- Sprite do Jorginho: offset `-5` (flutuava) → `8`/`7` (afundava) → `3` (`PLAYER_SPRITE_FEET_OFFSET_Y`).
- Plataformas elevadas: colisão 16 px (antes 14) e margem one-way 2 (antes 10).
- Fantasma do dash acompanha o offset do sprite.
- Como desfazer: [docs/AJUSTE_PES_PLATAFORMA.md](AJUSTE_PES_PLATAFORMA.md).

## Versão 1.8 — prólogo RPG, Limiar vivo e direção visual

- Prólogo reconstruído como uma cena RPG contínua: narrativa reescrita, nome do interlocutor, retrato de Jorginho, texto progressivo, tempo confortável de leitura e comando para acelerar ou avançar.
- Portal do prólogo reposicionado e redimensionado para permanecer dentro do vão do arco; o despertar agora combina núcleo dimensional, dois anéis em sentidos opostos, luz e vento.
- Portal de fim de fase substituído por uma composição apoiada no terreno com moldura de pedra, núcleo animado, runas, centelhas e estados visuais ligados aos fragmentos coletados.
- Removido o movimento vertical do portal inteiro que criava a impressão de flutuação; somente seus efeitos internos permanecem em movimento.
- Fragmentos agora alimentam uma barra de sintonia no HUD e iluminam as runas do portal gradualmente.
- Travessia de fase ganhou entrada física de Jorginho no portal, contração e brilho do Limiar, partículas convergentes e cartão narrativo do capítulo seguinte.
- Portal foi afastado do limite lateral e as moedas mantêm uma área de exclusão maior, evitando colecionáveis escondidos atrás da estrutura.
- Fases receberam vida ambiente coerente com cada bioma: vaga-lumes e folhas na floresta, faíscas na forja e partículas frias nas regiões de gelo.
- QA visual capturou e inspecionou o novo painel do prólogo e o portal desperto; inicialização headless da cena principal passou sem erros de script ou execução.

## Versão 1.5 — modo mostra, narrativa e progressão por dificuldade

- Retirada a faixa retangular de cor aplicada e	xclusivamente no interior das arenas de Boss; o jogador vê somente o cenário que corresponde ao espaço realmente jogável.
- Largura de fases, plataformas, câmera, portal e população de inimigos passam a escalar de forma coordenada com a dificuldade.
- Fragmentos são normalizados para posições visíveis, mantêm distância segura do portal e renderizam acima de cenário e decoração.
- Adicionada cutscene de origem em três atos, com Jorginho, fragmento, novo portal e opção de pular.
- Créditos finais automáticos adicionados após Pengu, com rolagem, nova experiência e retorno ao menu.
- Progresso de jornada transformado em save de sessão para a mostra: `Continuar esta sessão` funciona até fechar o jogo; a próxima execução remove somente o save de campanha.
- Resolução e tela cheia guardam a intenção escolhida mesmo em execução incorporada e são aplicadas quando houver uma janela externa compatível.
- Música inicial passa a carregar e tocar no volume final sem fade de entrada artificial.
- Portal antigo substituído pelo `Dimensional_Portal.png`, recortado em seis quadros de carga.
- Créditos técnicos e artísticos revisados, incluindo Ozzbit Games, ElvGames, rastreabilidade dos ZIPs sem metadados e OpenAI Codex na estruturação/migração HTML → GDScript/Godot.
- QA automatizado validou mapa/população por dificuldade, moedas, portal, modo mostra, créditos e remoção da faixa; regressão completa das seis fases também passou.

## Versão 1.4 — direção dos Bosses, dificuldades e HUD

- Badger, Cat e Pengu agora encaram Jorginho no início e no frame ativo de cada golpe. Projéteis, investidas, granadas, ondas sísmicas, gelo e raios usam essa direção recém-calculada.
- Ancoragem visual dos Bosses refeita pelo ponto dos pés, mantendo spritesheets de alturas diferentes em contato com o piso sem saltos ou afundamentos.
- Efeitos de superfície corrigidos: ondas de Badger, fissuras e lanças de Pengu nascem sobre a arena, e não debaixo da terra.
- Continuidade de animação ampliada entre antecipação, execução e recuperação. Badger reproduz seus quadros completos de ataque e anima a locomoção durante a investida.
- Adicionada seleção de dificuldade com quatro nomes próprios da jornada: Trilha dos Vaga-Lumes, Passos pelo Limiar, Jornada sem Retorno e Eclipse do Último Portal.
- Dificuldade altera resistência, dano e ritmo inimigos, velocidade dos Bosses, janela de defesa perfeita e chance de vidas; a opção fica registrada no save.
- HUD reconstruído com os painéis e botões do pacote visual selecionado, tipografia de fantasia, hierarquia mais clara, dificuldade visível e painel de Boss integrado.
- Terminologia da interface revisada para `Guarda`, `Aparar` e `Impulso`, mantendo as teclas e o comportamento existentes.
- QA automatizado validou direção, persistência da dificuldade, escalas de combate, continuidade das animações, ancoragem dos efeitos e nós essenciais do novo HUD.

## Versão 1.3 — rework de leitura, animação e identidade dos combates

- Corrigido o leitor de spritesheets dos três bosses: cada animação agora informa textura, largura lógica, altura, quadros, FPS, loop/one-shot e frame ativo. Folhas de 384×128 não são mais cortadas em três partes de 128 px.
- Badger, Cat e Pengu deixaram de herdar a orientação invertida dos inimigos comuns, eliminando moonwalk e trocas visuais incoerentes de direção.
- Telegraph universal inimigo→jogador substituído por seis famílias contextuais: área de chão, faixa/rachadura, arco, carga corporal, mira pontual e radial.
- Mushroom, Bramble, Flying, Skeleton, Sentinel e Spore receberam papéis e ataques próprios, com projéteis, gravidade, trails e impactos distintos quando aplicável.
- Badger recebeu tremor terrestre, investida aparável com stun na parede, rochas subterrâneas e colapso sequencial; a fase 2 encadeia tremor e investida.
- Cat integrou `cat_outofammo`, `cat_idle_noammo` e `cat_reload`, com 16 munições, janela vulnerável de recarga, rajadas, granadas físicas em arco, coronhada e fogo de supressão baixo→médio→alto; a fase 2 encadeia tiro e granada.
- Pengu recebeu lanças de gelo, raio visual próprio por altura, bicada aparável com frio leve e Zero Absoluto com zonas seguras; a fase 2 encadeia gelo e raio.
- Arenas deixaram de usar pilhas visíveis de blocos: limites físicos agora são invisíveis, têm 920 px de altura e não podem ser saltados. Os montículos abstratos do Covil foram removidos.
- Textos explicativos de ataques aparecem somente na primeira utilização; as repetições dependem de animação, VFX, SFX e pose.
- Criado `SFX_MANIFEST.md` com eventos dedicados e fallbacks válidos, sem referências para WAV inexistente.
- QA automatizado percorreu as seis fases e validou dimensões dos spritesheets, inimigos, bosses, portais, limites, parry, munição/recarga e expiração de projéteis.

## Versão 1.2 — campanha em seis fases e três novos chefes

- Progressão reconstruída em seis capítulos: uma fase de exploração seguida por uma arena de Boss, repetida em três atos.
- Guardião Ancestral removido do elenco ativo e substituído pelos spritesheets completos de Badger, Cat e Pengu; Pengu encerra a campanha como chefe final.
- Badger usa garras, investida aparável, terremoto, rochas em arco e colapso radial na segunda fase.
- Cat alterna metralhadora de alta velocidade, granadas com área marcada, coronhada aparável e sobrecarga do arsenal.
- Pengu combina lanças de gelo com indicação no chão, raio glacial, bicada aparável e Zero Absoluto; efeitos de gelo do próprio pacote reforçam impactos e acertos.
- Cada chefe tem vida, escala, animações, nomes, cores, fase 2 e mensagens de telegraph próprias. As folhas de ataque reproduzem em 30 FPS para comunicar o golpe dentro da janela de gameplay.
- Covil das Raízes, Arsenal do Gato e Trono do Inverno receberam composição específica: raízes/montículos, marcações industriais e cristais de gelo, respectivamente.
- Transições agora anunciam quando o próximo portal leva a um confronto; HUD, objetivos, derrota e vitória foram atualizados para seis fases.
- Projeto validado por 81 verificações automatizadas em todas as seis fases, incluindo os três ciclos de Boss, portais, animações, projéteis e encerramento.

## Versão 1.1 — defesa ativa, arsenal ampliado e Boss revitalizado

- Execução de teste do Godot configurada para janela externa, eliminando os avisos `Embedded window can't be resized/moved` e permitindo que resolução e tela cheia alterem a janela real.
- O menu de vídeo agora detecta uma execução incorporada, evita chamadas incompatíveis e informa que as opções serão aplicadas na próxima execução externa.
- Corrigido `JORNINHO CAIU` para `JORGINHO CAIU` na tela de derrota.
- Nova ação `guard`, acessível por `K`, mouse direito, remapeamento ou botão no HUD.
- Defesa comum reduz o dano recebido para 35%; vida fracionária é comunicada pelo valor e pelo coração parcialmente iluminado.
- Janela de parry de 0,18 s anula todo o dano, produz efeito e hitstop próprios e atordoa inimigos por 1,65 s ou o Boss por 0,95 s.
- Voadores alternam mergulho e projétil; plantas rúnicas alternam explosão e globo; Bramble e Sentinela ganharam disparos direcionados.
- Guardião Ancestral recebeu quatro padrões telegrafados: ondas de solo, investida, rajada em leque e nova radial. A fase 2 acelera os padrões, amplia projéteis e altera barra/efeitos.
- Arena do Boss ganhou motes, pulso atmosférico, identificação de fase, mensagens de ataque e reações visuais na barra de vida.
- Quatro spritesheets selecionados de `Effect and FX Pixel All Free.zip` fornecem escudo/parry, impacto, projétil e arco energético; apenas as variações coerentes com a paleta do portal foram integradas.
- Testes automatizados confirmaram bloqueio parcial, parry sem dano, stun comum/Boss, projéteis, rajada, nova, texto de morte, inimigos, plataformas, áudio e controles. Teste nativo confirmou 1280×720, tela cheia e escala 115%.

## Versão 1.0 — estabilidade dos inimigos, áudio e configurações reais

- Cada família de inimigo recebeu escala, caixa física, pivô dos pés, orientação de origem e velocidade de animação próprios.
- O esqueleto deixou de reproduzir arbitrariamente uma folha mista de 19 quadros; idle, caminhada e ataque agora usam folhas separadas derivadas dos GIFs originais.
- Animações dos inimigos usam relógios independentes e reiniciam no primeiro quadro ao trocar de estado, eliminando saltos e poses aleatórias.
- IA de solo ganhou aceleração gradual, memória de direção e bloqueio de 0,32 s após detectar paredes ou bordas, removendo a inversão rápida semelhante a “ticks”.
- Planta de esporos virou sentinela imóvel com ataque radial telegrafado; o lodo vertical incompatível foi retirado dos encontros.
- Inimigos derrotados agora desativam colisão e IA, reproduzem morte/fade e são removidos corretamente da simulação.
- Escalas foram normalizadas em torno da silhueta de Jorginho; apenas o Guardião Ancestral permanece deliberadamente maior.
- Plataformas elevadas passaram a ter colisão de 14 px, arte de 24–32 px e comportamento unidirecional, preservando espaço de circulação por baixo.
- Tela de morte refeita com painel, floresta escurecida, partículas, estatísticas úteis e vinheta sonora; a música da fase é interrompida imediatamente.
- Vinte e dois eventos sonoros cobrem interface, movimento, combate, dano, inimigos, coleta, portal, Boss, morte e vitória.
- Tela cheia, resolução e escala visual agora alteram propriedades reais da janela e são persistidas.
- Remapeamento de controles ganhou abas, instruções, cancelamento com `Esc`, resolução de conflitos e preservação do ataque pelo mouse.
- QA dedicado observou todas as famílias por vários segundos: nenhum quadro fora da folha, nenhum inimigo sem contato físico e nenhuma inversão excessiva; as três fases e o fluxo de morte passaram integralmente.

## Versão 0.9 — biomas, transições e Guardião Ancestral

- Menu reconstruído sem castelo, piso ou personagens decorativos; duas camadas de `Forest of Illusion` se movem continuamente em parallax.
- Logotipo reduzido e convertido para `Sprite2D`, evitando que o tamanho original da textura force o layout.
- Navegação reunida em um painel único, com espaçamento, hierarquia e estados visuais consistentes.
- Fases reduzidas de 5.000/5.600/2.400 para 3.400/3.600/2.100 pixels, mantendo rotas elevadas e conteúdo por trecho.
- Floresta da Ilusão e Trapmoor foram isolados como biomas próprios; nenhum piso mistura estilos de tileset.
- Pisos principais agora são contínuos, enquanto plataformas opcionais têm entre 170 e 220 pixels e maior distância vertical do chão.
- Árvores, flores e pedras aleatórias do cenário anterior foram removidas; as camadas de fundo agora concentram a ambientação.
- Portal foi reposicionado matematicamente para que a base toque o topo do piso e recebeu sombra de contato.
- Shader fornecido em `SourceCode.zip` virou uma transição orgânica completa, com nome da próxima região e revelação do novo mapa.
- HUD usa corações Crimson, três painéis compactos e barra do Boss centralizada no topo.
- Bramble e Sentinela entraram como elites; lodo, planta e esqueleto ampliam Trapmoor; o Golem foi substituído pelo Guardião Ancestral animado.
- Arena final ganhou chão contínuo, cinco plataformas de esquiva, portão compatível com Trapmoor e paleta violeta própria.
- Minotauro não foi integrado por possuir fundo branco, escala menor e acabamento incompatível com o restante do elenco.
- Quarenta e cinco arquivos antigos foram movidos para `archive_unused/v09_superseded`, mantendo restauração possível e reduzindo a importação ativa.
- QA percorreu as três fases e validou movimento, salto, ataque, dash, coleta, portais, duas transições, Boss e encerramento.

## Versão 0.8 — identidade visual, exploração e arena justa

- Folha de direção de arte fornecida foi convertida seletivamente em quatro assets funcionais: logo, botão reutilizável, painel escuro e cursor.
- Logo real substitui o título tipográfico do menu; movimento vertical discreto mantém a tela viva.
- Botões principais e secundários compartilham a mesma moldura, com estados normal, hover, pressionado e indisponível controlados por modulação.
- Configurações e créditos usam painel central coerente, com margens revisadas para não cortar conteúdo.
- Cursor tem hotspot correto, silhueta compacta de 32×32 e liberação explícita no encerramento.
- O botão `SAIR` agora interrompe e libera a música antes de fechar; o fluxo real terminou sem erros ou recursos residuais com o driver de áudio do sistema.
- Menu recebeu parallax reativo ao mouse, além do movimento ambiental já existente.
- As fases agora usam três camadas otimizadas do Forest Parallax Vertical em `Parallax2D`, repetidas horizontalmente e colorizadas por região.
- Level 1 cresceu para 5.000 pixels, com 15 fragmentos, novas sequências verticais e uma recompensa secreta.
- Level 2 cresceu para 5.600 pixels, com 17 fragmentos, duas rotas altas/recompensas e encontros adicionais.
- Boss Arena ganhou chão contínuo em toda a extensão, quatro plataformas de esquiva e portão formado por pedras/runa em vez de retângulo provisório.
- HUD preserva o painel de vida mais simples e legível; somente o painel de fragmentos recebe a moldura de UI, evitando excesso ornamental.
- QA agora verifica um único portal por fase, abertura após fragmentos/Boss, Golem visível e inputs de movimento, salto, ataque e dash.

## Versão 0.7 — curadoria e otimização de assets

- Criada seleção central em `assets/selected`, com somente quatro músicas, três SFX, quatro camadas do menu, quatro estados do portal, dois corações e um fragmento.
- Forest Parallax Vertical recortado de 1900×3450 para a viewport de 1152×648; ordem de desenho validada por captura real.
- Portal e fragmento deixam de carregar folhas completas e passam a usar recortes individuais.
- Música ativa migrou de WAV para MP3, reduzindo mais de 100 MB de áudio ativo para aproximadamente 24 MB.
- Mork Dungeon agora é fonte de exibição somente para títulos; textos funcionais permanecem legíveis.
- HUD completo deixou de ser reconstruído por frame; somente dash e cronômetro possuem atualização contínua necessária.
- Busca de grupo por frame no parallax do menu foi substituída por uma lista cacheada.
- Pixel snapping e resolução interna explícita foram habilitados.
- Packs originais e recursos mortos foram movidos para `archive_unused`, ignorado pelo importador e totalmente recuperável.
- A curadoria em `assets/selected` ficou com 23 arquivos-fonte (46 incluindo metadados de importação) e aproximadamente 26,5 MB.
- Smoke test percorreu as três fases simulando movimento, salto, ataque e dash; confirmou um portal em cada fase e Golem visível na arena.
- Passagem renderizada: média de 0,65 ms de CPU e 0,34 ms de GPU por frame na máquina de teste.

## Versão 0.6 — combate assistido e menu do castelo

- Assistência de ataque ampliada para priorizar automaticamente o inimigo alcançável mais próximo, mesmo com grande imprecisão do cursor em curta distância.
- Alcance dos três golpes ampliado e hitboxes agora consideram o volume visual diferente de cogumelos, criaturas voadoras e golems.
- Um anel rápido identifica o alvo escolhido pela assistência no instante do ataque.
- Pés de Jorginho realinhados ao topo do terreno na tela inicial.
- Menu recomposto como uma jornada: Jorginho corre pela floresta em direção a um castelo.
- Redução das árvores grandes do primeiro plano para melhorar a leitura e eliminar a sensação de cenário congestionado.
- Validação automatizada adicionada para assistência forte mesmo quando o cursor aponta para o lado oposto.

## Versão 0.5 — revisão profissional completa

- Menu principal simplificado: a floresta ocupa toda a tela, Jorginho corre continuamente pelo primeiro plano e somente título/opções essenciais permanecem.
- Removidos textos narrativos e instruções excessivas da tela inicial.
- Novos botões arredondados e translúcidos integrados ao cenário.
- Moedas circulares substituídas por cristais de portal com facetas, aura, partículas orbitais, flutuação e explosão visual na coleta.
- Portais reconstruídos com arco de pedra, núcleo energético, dois anéis animados, identificação de estado e cores específicas por região.
- Ao coletar todos os cristais, o portal muda visualmente de adormecido para desperto.
- A passagem de fase agora possui fade e mensagem de travessia, em vez de uma troca instantânea.
- Mapa 1 recebeu agrupamentos florais e composição de vale vivo.
- Mapa 2 recebeu ruínas de pedra, arcos e tonalidade fria.
- Mapa 3 recebeu cristais ambientais e atmosfera corrompida.
- Terreno, vegetação e atmosfera recebem paletas diferentes por região.
- Adicionados coyote time e jump buffer para tornar os saltos mais responsivos.
- Novo teste completo percorre menu, todos os fragmentos, todos os portais, as três fases, chefe e vitória.

## Versão 0.4 — acessibilidade e acabamento visual

- Removida a luz local que escurecia uma região ao redor da câmera no renderizador Compatibility.
- Colisões recalibradas individualmente para cogumelo, criatura voadora e golem conforme os pixels visíveis.
- Reação a dano substituída por squash, coloração vermelha contínua, partículas e flash sutil; o personagem não desaparece mais.
- Ataque em 360 graus seguindo o mouse.
- Assistência de mira para o inimigo próximo à intenção do cursor, com atração maior em curta distância.
- Pulo duplo com anel visual no segundo impulso.
- Menu principal transformado em uma cena animada de Jorginho caminhando pela floresta enquanto uma criatura observa ao fundo.
- Novos testes para ausência da luz problemática, ataque vertical, assistência de mira e pulo duplo.

## Versão 0.3 — revisão de combate e interface

## Controles e movimento

- Corrigido o alinhamento entre os pés de Jorginho e a cápsula física.
- Ataque principal movido para o botão esquerdo do mouse; J/Z continuam como alternativa.
- Adicionado dash no Shift, com invencibilidade curta, rastro visual e recarga no HUD.

## Combate

- Combo de três golpes desacelerado e sincronizado com os frames da espada.
- Hitboxes retangulares orientadas para a direção do personagem.
- Terceiro golpe causa mais dano e knockback.
- Pular na cabeça de inimigos causa dano e rebate Jorginho para cima.
- Barras de vida aparecem quando inimigos recebem dano; a do chefe fica sempre visível.
- Jorginho perde exatamente um ponto por ataque recebido, pisca em vermelho e ganha invencibilidade temporária.

## Inimigos

- Cogumelo: sinaliza e executa uma investida curta.
- Criatura voadora: prepara e realiza um mergulho direcionado.
- Golem: alterna entre carga e impacto no chão com onda de choque.
- Todos os ataques perigosos possuem sinalização visual antes do dano.

## Interface e progressão

- Novo menu principal animado e contextualizado na narrativa.
- Continuar, Nova Jornada, Configurações, Créditos e Sair.
- Salvamento automático no começo da jornada e ao alcançar cada novo portal.
- Configurações persistentes de volume, tela cheia e tremor de câmera.
- HUD redesenhado com barra de vida, dash, fragmentos, objetivo e cronômetro.
- Pausa com continuar, reiniciar fase e voltar ao menu.
- Tela final com ranking, tempo, quedas e melhor tempo.

## Validação

- Testes automatizados cobrem alinhamento, inputs, coleta, ataque, dash, pisão, dano, IA, portal, menus, salvamento e carregamento das três fases.
# v1.9 — auditoria profissional e polimento

- Pausa confiável em `Esc`/Start e suporte completo a gamepad.
- Música serializada, volume por faixa respeitado e SFX em pool fixo.
- Câmera direcional com shake em offset, sem deslocamento residual.
- Fragmentos com magnetismo suave, terminologia e feedback integrados.
- Arenas proporcionais à dificuldade e landmarks coerentes por bioma.
- Áudio/props Kenney CC0 selecionados sem misturar o tileset completo.
- Save versionado, records separados, 2560×1440 e intensidade de flashes.
- Preset Windows, PCK e matriz QA automatizada.
