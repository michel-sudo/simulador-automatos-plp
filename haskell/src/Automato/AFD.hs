module Automato.AFD (testePalavraAFD) where

import Automato.Types
import qualified Data.Map as Map
import qualified Data.Set as Set

--------------------------------------------------
-- Testar palavra em AFD
--------------------------------------------------

testePalavraAFD :: Automato -> String -> ResultadoTeste
testePalavraAFD automato palavra =
  let estadoFinal = processar automato (estadoInicial automato) palavra
  in if estadoFinal `Set.member` estadosFinais automato
        then Aceita
        else Rejeita

--------------------------------------------------
-- Processar palavra símbolo a símbolo
--------------------------------------------------

processar :: Automato -> Estado -> String -> Estado
processar _ estado [] = estado
processar automato estado (s:resto) =
  case mover automato estado [s] of
    Just novoEstado -> processar automato novoEstado resto
    Nothing         -> estadoErro

--------------------------------------------------
-- Função de transição determinística
--------------------------------------------------

mover :: Automato -> Estado -> Simbolo -> Maybe Estado
mover automato estado simbolo =
  case Map.lookup (estado, Just simbolo) (transicoes automato) of
    Just destinos ->
      case Set.toList destinos of
        [e] -> Just e
        _   -> Nothing
    Nothing -> Nothing

--------------------------------------------------
-- Estado de erro
--------------------------------------------------

estadoErro :: Estado
estadoErro = "__erro__"