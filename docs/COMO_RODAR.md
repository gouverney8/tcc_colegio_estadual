# Como rodar Jorginho: Jornada Sem Retorno

Este guia ensina a abrir e jogar o projeto no computador, mesmo sem experiência anterior com Godot.

## O que você precisa

- Windows 10 ou 11 (também funciona em Linux e macOS)
- Conexão com a internet só para baixar o Godot e o repositório
- Cerca de 200 MB livres (o jogo em si é leve; o editor ocupa mais)

Não é necessário instalar Visual Studio, Python nem nenhum motor além do Godot.

---

## 1. Instalar o Godot 4.7

1. Abra o site oficial: [https://godotengine.org/download](https://godotengine.org/download)
2. Baixe a versão **4.7 stable** (Standard, não a .NET, a menos que você já use C#).
3. Extraia o ZIP em uma pasta fácil de achar, por exemplo `C:\Godot`.
4. Execute `Godot_v4.7-stable_win64.exe`.

Não existe instalador obrigatório: o Godot pode rodar só com o executável extraído.

Se a versão 4.7 ainda não estiver na página principal, use a aba **Previous versions** e escolha **4.7.x**. O arquivo `project.godot` deste repositório pede a família **4.7**.

---

## 2. Baixar o projeto

### Opção A — clonar com Git (recomendado)

No PowerShell ou no Git Bash:

```bash
git clone git@github.com:gouverney8/tcc_colegio_estadual.git
cd tcc_colegio_estadual
```

Se a chave SSH não estiver configurada, use HTTPS:

```bash
git clone https://github.com/gouverney8/tcc_colegio_estadual.git
cd tcc_colegio_estadual
```

### Opção B — baixar ZIP

1. Abra [https://github.com/gouverney8/tcc_colegio_estadual](https://github.com/gouverney8/tcc_colegio_estadual)
2. Clique em **Code → Download ZIP**
3. Extraia a pasta em um local sem acentos problemáticos, se possível

O projeto do jogo fica em:

```
tcc_colegio_estadual/Jorginho_Jornada_Sem_Retorno/
```

---

## 3. Importar no Godot

1. Abra o Godot.
2. Na tela de projetos, clique em **Importar** (ou **Import**).
3. Navegue até `Jorginho_Jornada_Sem_Retorno` e selecione o arquivo `project.godot`.
4. Confirme. Na primeira abertura o editor importa as imagens, músicas e efeitos. Espere a barra de importação terminar.
5. Clique em **Editar** / **Edit**.

Se o Godot avisar diferença de versão, escolha a 4.7. Não abra o projeto em Godot 3.

---

## 4. Jogar

Com o projeto aberto:

- **F5** — executa o jogo a partir da cena principal (`main.tscn`)
- **F6** — executa a cena que estiver aberta no editor
- **F8** — para a execução

O jogo começa na abertura (autoria e engine), depois no menu. Dali você escolhe a dificuldade, assiste à cutscene de origem (pode pular) e entra na campanha.

### Controles padrão

- **A / D** ou setas: andar
- **Espaço**, **W** ou seta para cima: pular (há pulo duplo)
- **Clique esquerdo**, **J** ou **Z**: atacar
- **Clique direito** ou **K**: guardar; no momento certo, aparar (parry)
- **Shift**: impulso
- **Esc**: pausar

Controle (gamepad) também funciona. Os comandos podem ser trocados em **Configurações**.

---

## 5. Editar uma fase (opcional)

As seis fases estão em `Jorginho_Jornada_Sem_Retorno/scenes/levels`.

Em cada cena você encontra:

| Nó | Função |
| --- | --- |
| `TileMap_Terreno_E_Plataformas` | chão e plataformas |
| `Pontos_Editaveis/INICIO_JORGINHO` | onde o personagem nasce |
| `Pontos_Editaveis/PORTAL_APARECE_AQUI` | onde o portal surge após o objetivo |
| `Fragmentos` | coletáveis |
| `Inimigos` | inimigos (o tipo fica nos metadados) |
| `Vidas_Secretas` | corações escondidos |

Mova os marcadores ou pinte o TileMap e pressione **F5**. A mudança aparece no jogo.

Mais detalhes de código e apresentação em sala: [GUIA_DO_PROJETO.md](GUIA_DO_PROJETO.md).

---

## Problemas comuns

**O Godot não lista o projeto**  
Importe `Jorginho_Jornada_Sem_Retorno/project.godot`, não a pasta raiz do repositório.

**Aviso de versão da engine**  
Use Godot 4.7. Godot 3 e Godot 4.2 não abrem este projeto corretamente.

**Primeira abertura demora**  
É a importação de texturas e áudio. Nas próximas vezes o projeto abre rápido.

**Não ouço música**  
Verifique o volume no menu de configurações e o volume do Windows. A trilha começa já no menu.

**Tela preta ou resolução estranha**  
No menu do jogo, abra Configurações e escolha 1280×720 ou 1920×1080. Há opção de tela cheia.

**Erro ao clonar por SSH**  
Use o clone HTTPS ou confira se a chave pública foi adicionada em GitHub → Settings → SSH and GPG keys.

**Quero só o executável, sem editor**  
Siga [COMO_EXPORTAR.md](COMO_EXPORTAR.md). É preciso ter o Godot e os modelos de exportação da mesma versão.

---

## Requisitos sugeridos para a mostra

- Resolução interna do jogo: 1152×648
- A jornada zera ao fechar o programa (modo mostra). Configurações e recordes continuam salvos.
- Feche outros jogos pesados. O projeto usa o renderizador `gl_compatibility`, pensado para PCs de escola.
