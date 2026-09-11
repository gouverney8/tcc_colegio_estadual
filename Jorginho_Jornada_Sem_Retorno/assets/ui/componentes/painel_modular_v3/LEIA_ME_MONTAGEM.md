# Painel modular v3

Este kit foi separado para evitar que a moldura inteira seja esticada junto com o fundo.

## Pastas e arquivos

- `fundo/madeira.png`: fundo limpo para receber textos, cartões e botões.
- `moldura/topo_cristal.png`: topo ornamental com folhas, flor, pedras e cristal.
- `moldura/lateral_esquerda.png`: coluna decorativa esquerda.
- `moldura/lateral_direita.png`: coluna decorativa direita.
- `moldura/rodape.png`: faixa inferior de pedra e madeira.
- `cantos/bloco_inferior_esquerdo.png`: bloco que une a lateral esquerda ao rodapé.
- `cantos/bloco_inferior_direito.png`: bloco que une a lateral direita ao rodapé.
- `cantos/folhas_flor_branca.png`: acabamento opcional da junção direita.
- `cantos/folhas_flor_vermelha.png`: acabamento opcional da junção direita.

## Ordem recomendada no Godot

1. Fundo de madeira.
2. Lateral esquerda e lateral direita.
3. Rodapé.
4. Topo com cristal.
5. Blocos inferiores por cima das junções.
6. Flores e folhas usadas apenas como acabamento.
7. Conteúdo da interface, como títulos, cartões e botões.

## Cuidados importantes

- Todos os PNGs possuem transparência real.
- Não altere largura e altura separadamente nas peças decorativas.
- Use escala uniforme e `Keep Aspect Centered` nas molduras.
- O fundo de madeira pode preencher o espaço interno porque não possui ornamentos que possam deformar.
- Encoste as laterais nos blocos inferiores; não sobreponha uma segunda lateral dentro do canto.
- Faça o rodapé começar depois do bloco esquerdo e terminar antes do bloco direito.
- Deixe folhas e flores por cima das junções apenas para esconder pequenas frestas.
- Para outras resoluções, reposicione as peças pelas âncoras em vez de esticar a arte.

## Cena pronta para reutilizar

Use `res://scenes/ui/components/ornamental_panel_v3.tscn`. A cena já traz a ordem de desenho e as junções corrigidas. Para alterar o tamanho, prefira ajustar os offsets internos da cena; não aplique escala diferente em X e Y na instância inteira.
