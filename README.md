# Simulador de Autômatos - Versão Haskell

## Funcionalidades
✔ Leitura do autômato a partir de arquivo  
✔ Simulação de AFD  
✔ Simulação de AFN  
✔ Exibição dos estados percorridos  
✔ Verificação de aceitação

## Estrutura do projeto:

- `/app/Types.hs` → Definição de tipos
- `/app/Reader.hs` → Leitura e verificação de arquivos
- `/app/AFD.hs` → Lógica de simulação AFD
- `/app/AFN.hs` → Lógica de simulação AFN
- `/app/Interface.hs` → Exibição dos resultados
- `/examples/` → Exemplos testáveis

```
simulador-automatos/
│
├── app/
│   ├── Types.hs
│   ├── Reader.hs
│   ├── Interface.hs
│   ├── AFD.hs
│   ├── AFN.hs
│   └── Main.hs
│
├── docs/
├── examples
├── dist-newstyle/
│
├── simulador-automatos-hs.cabal
├── README.md
├── .gitignore
├── LICENSE
└── CHANGELOG.md
```
