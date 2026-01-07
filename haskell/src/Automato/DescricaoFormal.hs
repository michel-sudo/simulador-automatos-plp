module Automato.DescricaoFormal (mostrarDescricaoFormal) where

import Automato.Types
import qualified Data.Map as Map
import qualified Data.Set as Set
import Data.List (intercalate)

-- Mostra a descrição formal do autômato

mostrarDescricaoFormal :: Automato -> IO ()
mostrarDescricaoFormal automato = do
    putStrLn "=== DESCRICAO FORMAL DO AUTOMATO ==="
    putStrLn $ "Q (estados): " ++ show (Set.toList(estados automato))
    putStrLn $ "Alfabeto: " ++ show (Set.toList(alfabeto automato))
    putStrLn $ "q0 (estado inicial): " ++ estadoInicial automato
    putStrLn $ "F (estados finais): " ++ show (Set.toList(estadosFinais automato))
    putStrLn $ "\n (função de transição):"
    mapM_ imprimirTransicao(Map.toList(transicoes automato))
    putStrLn ""


-- Função de imprimir transição--

imprimirTransicao :: ((Estado, Maybe String), Set.Set Estado) -> IO()
imprimirTransicao ((origem, simbolo), destinos) =
    putStrLn $ "(" ++ origem ++ ", " ++ show simbolo ++ ") = " ++ show (Set.toList destinos)
