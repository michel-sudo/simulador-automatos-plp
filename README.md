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
##  Como utilizar:
- Os arquivos json **(autômatos)**, devem ser carregados no diretório `\examples\`.
- Executar `cabal run` no diretório raiz do projeto, para iniciar o programa.
- Após iniciar, selecionar opção `1. Carregar autômato (JSON)`.
- Em seguida indicar o **nome.json** de algum automato contido no diretório `\examples\`
- Após carregar o autômato com sucesso, é possível testar palavras, carregar um novo autômato ou encerrar o programa.
- O programa retorna um **(ou mais ramos em caso de AFN)**, como uma sequência de estados percorridos até o estado final, no caso de aceitação da palavra.
- Em caso de não aceitação, apenas uma mensagem de `Palvra rejeitada` é exibida.  
