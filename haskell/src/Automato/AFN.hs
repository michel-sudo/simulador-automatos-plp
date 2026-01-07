module Automato.AFN (testePalavraAFN) where

import Automato.Types
import qualified Data.Map as Map
import qualified Data.Set as Set

--------------------------------------------------
-- Testar palavra em AFND (com ε)
--------------------------------------------------

testePalavraAFN :: Automato -> String -> ResultadoTeste
testePalavraAFN automato palavra =
  let iniciais = fechoEpsilon automato
                  (Set.singleton (estadoInicial automato))
      finais   = processar automato iniciais palavra
  in if not (Set.null (Set.intersection finais (estadosFinais automato)))
        then Aceita
        else Rejeita

--------------------------------------------------
-- Processar palavra inteira
--------------------------------------------------

processar :: Automato -> Set.Set Estado -> String -> Set.Set Estado
processar _ estados [] = estados
processar automato estados (s:resto) =
  let movidos   = mover automato estados [s]
      fechados  = fechoEpsilon automato movidos
  in processar automato fechados resto

--------------------------------------------------
-- Mover múltiplos estados
--------------------------------------------------

mover :: Automato -> Set.Set Estado -> Simbolo -> Set.Set Estado
mover automato estados simbolo =
  Set.unions
    [ destinos
    | estado <- Set.toList estados
    , Just destinos <- [Map.lookup (estado, Just simbolo)
                                    (transicoes automato)]
    ]

--------------------------------------------------
-- Fecho-ε
--------------------------------------------------

fechoEpsilon :: Automato -> Set.Set Estado -> Set.Set Estado
fechoEpsilon automato estados =
  let novos = Set.unions
        [ destinos
        | estado <- Set.toList estados
        , Just destinos <- [Map.lookup (estado, Nothing)
                                        (transicoes automato)]
        ]
      total = Set.union estados novos
  in if total == estados
        then estados
        else fechoEpsilon automato total