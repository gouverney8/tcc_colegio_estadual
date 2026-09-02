# Como exportar o executável (Windows)

O preset **Windows Desktop** já está configurado em `Jorginho_Jornada_Sem_Retorno/export_presets.cfg`.

## Requisitos

- Godot **4.7.x** stable (a mesma família do `project.godot`)
- Modelos de exportação oficiais dessa versão (cerca de 1 GB no download)

## Passos

1. Abra o projeto no Godot.
2. Vá em **Editor → Gerenciar modelos de exportação**.
3. Baixe e instale os modelos da versão **4.7.x stable**.
4. Vá em **Projeto → Exportar**.
5. Selecione **Windows Desktop**.
6. Clique em **Exportar Projeto**.

Saída sugerida: `Jorginho_Jornada_Sem_Retorno/build/Jorginho_Jornada_Sem_Retorno.exe`.

A pasta `build/` não entra no Git. Depois de exportar, teste o `.exe` fora do editor, em tela cheia e em janela.

## Observações

- Marque **Embed PCK** se quiser um único `.exe` (já é o padrão deste preset).
- O filtro de exportação ignora scripts de editor, cache `.godot` e a pasta `build`.
- Para mostrar o jogo na amostra de curso, o modo mais simples continua sendo **F5** dentro do Godot. O executável é opcional.
