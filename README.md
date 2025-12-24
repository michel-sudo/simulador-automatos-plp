# Simulador de Autômatos - Versão Haskell

## Funcionalidades
✔ Leitura do autômato a partir de arquivo  
✔ Simulação de AFD  
✔ Simulação de AFN  
✔ Exibição dos estados percorridos  
✔ Verificação de aceitação

## Estrutura do projeto:

- `/src/Automato/tipos-validacao.hs` → Definição de tipos e validação
- `/src/Automato/entrada.hs` → Leitura de arquivos
- `/src/Automato/AFD.hs` → Lógica de simulação AFD
- `/src/Automato/AFN.hs` → AFN
- `/src/Automato/interface.hs` → Exibição dos resultados
- `/examples/` → Exemplos testáveis

simulador-automatos/
│
├── haskell/
│   ├── app/
│   │   └── Main.hs
│   ├── src/
│   │   ├── Automato/
│   │   │   ├── Types.hs
│   │   │   ├── Parser.hs
│   │   │   ├── Validator.hs
│   │   │   ├── AFD.hs
│   │   │   ├── AFN.hs
│   │   ├── Interface/
│   │   │   └── CLI.hs
│   ├── test/
│   │   ├── Spec.hs
│   │   ├── TestAFD.hs
│   │   ├── TestAFN.hs
│   ├── examples/
│   │   ├── afd1.txt
│   │   ├── afd2.txt
│   │   ├── afn1.txt
│   ├── simulador-automatos-hs.cabal
│   ├── cabal.project
│   ├── README.md
│
│
├── prolog/
│   ├── src/
│   │   ├── automato.pl
│   │   ├── simulador_afd.pl
│   │   ├── simulador_afn.pl
│   │   ├── parser.pl          % opcional
│   │   ├── util.pl            % funções auxiliares
│   ├── test/
│   │   ├── test_afd.pl
│   │   ├── test_afn.pl
│   ├── examples/
│   │   ├── afd_ex1.pl
│   │   ├── afd_ex2.pl
│   │   ├── afn_ex1.pl
│   ├── run.pl
│   ├── README.md
│
│
├── docs/
│   ├── requisitos.md
│   ├── especificacao.pdf
│   ├── arquitetura.md
│   ├── manual-usuario.md
│   ├── planejamento.md
│   ├── exemplos-de-autômatos.md
│
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

