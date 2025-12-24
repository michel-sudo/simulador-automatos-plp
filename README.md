# Simulador de Autômatos - Versão Haskell

## Funcionalidades
✔ Leitura do autômato a partir de arquivo  
✔ Simulação de AFD  
✔ Simulação de AFN  
✔ Exibição dos estados percorridos  
✔ Verificação de aceitação

## Estrutura do projeto:

- `/src/Automato/Types.hs` → Definição de tipos
- `/src/Automato/Reader.hs` → Leitura e verificação de arquivos
- `/src/Automato/AFD.hs` → Lógica de simulação AFD
- `/src/Automato/AFN.hs` → Lógica de simulação AFN
- `/src/Automato/Interface.hs` → Exibição dos resultados
- `/examples/` → Exemplos testáveis
```
simulador-automatos/
│
├── haskell/
│   ├── app/
│   │   └── Main.hs
│   ├── src/
│   │   ├── Automato/
│   │   │   ├── Types.hs
│   │   │   ├── Reader.hs
│   │   │   ├── Interface.hs
│   │   │   ├── AFD.hs
│   │   │   ├── AFN.hs
│   ├── test/
│   │   ├── Spec.hs
│   │   ├── TestAFD.hs
│   │   ├── TestAFN.hs
│   ├── simulador-automatos-hs.cabal
│   ├── CHANGELOG.md
│   ├── README.md
├── docs/
│
├── .github/
│   ├── ISSUE_TEMPLATE/
│   │   ├── bug_report.md
│   │   ├── feature_request.md
│   ├── PULL_REQUEST_TEMPLATE.md
│   ├── workflows/
│       ├── haskell-ci.yml     % opcional
│       ├── prolog-ci.yml      % opcional
│
├── .gitignore
├── LICENSE
├── README.md
└── CHANGELOG.md
```
