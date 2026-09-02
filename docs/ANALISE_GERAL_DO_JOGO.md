# Análise geral do jogo

## O que estava dando problema

O portal já ficava no cenário desde o começo. Mesmo apagado, ele aparecia atrás do chefe e deixava a arena com aspecto de objeto esquecido. A música também estava com uma redução muito forte de volume, então os efeitos apareciam, mas a trilha quase sumia.

Outro problema era a organização. As fases eram montadas dentro de um script grande. Isso funcionava durante o jogo, porém dificultava abrir uma fase no Godot e trocar uma plataforma de lugar na frente do professor.

A abertura já contava uma história, mas entrava direto no menu e a cutscene ainda parecia rápida. A imagem antiga também não encaixava o portal tão bem no cenário.

## Como foi arrumado

- O portal agora fica totalmente invisível e sem colisão até todos os fragmentos serem coletados ou o chefe ser derrotado. Quando o objetivo termina, ele aparece com luz, som e animação.
- As músicas das fases subiram cerca de 10 dB. Os chefes receberam um pouco mais de presença para a batalha parecer importante, sem estourar o volume dos efeitos.
- Foram criadas seis cenas em `scenes/levels`. Cada uma tem TileMap, início do jogador, posição do portal, fragmentos, inimigos e vidas escondidas.
- O jogo passou a ler os marcadores e o TileMap dessas cenas. Isso significa que mover algo no editor não é só decoração: a mudança aparece jogando.
- A cena principal foi limpa. As pastas de fases, scripts, assets, créditos e documentação ficaram separadas por função.
- Os arquivos `RELEASE_NOTES` foram removidos porque serviam para acompanhar versões internas e não ajudavam na apresentação do TCC.
- A abertura ganhou uma tela curta com o nome do desenvolvedor, Godot Engine 4 e o ano do projeto.
- A cutscene recebeu uma nova floresta em pixel art, com o altar encaixado no chão. Os textos foram reescritos com mais contexto e ficaram mais lentos para facilitar a leitura.

## Bugs revisados durante o desenvolvimento

- Inimigos que viravam para o lado errado: a direção passou a ser atualizada antes dos ataques.
- Chefes atacando de costas ou com golpes saindo do chão: origem, direção e altura dos efeitos foram corrigidas.
- Plataformas muito grossas: as plataformas elevadas passaram a usar colisão fina e mão única.
- Portal flutuando ou escondendo moedas: a posição foi alinhada ao chão e os fragmentos têm área de segurança ao redor da saída.
- Música demorando para começar: a primeira faixa começa imediatamente; fade é usado somente na troca.
- Tela cheia e resolução: as opções passaram a usar janela externa e salvar a preferência.
- Progresso de outros jogadores na mostra: a jornada é zerada quando o jogo é reaberto, mas configurações e recordes continuam salvos.
- Ataques e efeitos sem resposta: foram incluídos sons, tremor configurável, hitstop, partículas e avisos antes dos golpes mais fortes.

## Resultado

O projeto continua simples o bastante para explicar em sala, mas agora está mais próximo da organização de um jogo completo. As partes importantes podem ser encontradas no painel do Godot sem procurar dentro de várias pastas, e as fases podem ser alteradas visualmente caso o professor peça uma mudança durante a apresentação.
