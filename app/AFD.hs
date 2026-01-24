module AFD where

import Types 
import qualified Types as T
import qualified Data.Set as Set
import qualified Data.Map as Map
import Control.Monad (foldM)

-- Função para simular um AFD com uma palavra de entrada
simularAFD :: Automato -> Palavra -> Either String Caminho
simularAFD atm palavra = do
    case atm of
        T.AFN {} -> Left "Automato não é determinístico (AFD)"
        T.AFD {} -> do
            (_, caminhoFinal) <- foldM inserir (T.estadoInicial atm, [T.estadoInicial atm]) palavra
            if avaliarPalavra caminhoFinal atm
            then Right caminhoFinal
            else Left ("Palavra rejeitada \nEstado final " ++ show (last caminhoFinal) ++ " não é de aceitacao")
                where
                    inserir (estadoAtual, caminho) simbolo = do
                        proxEstado <- transicionarAFD estadoAtual simbolo (T.transicoesAFD atm)
                        Right (proxEstado, caminho ++ [proxEstado])

-- Função para avaliar se o caminho leva a um estado final
avaliarPalavra :: Caminho -> Automato -> Bool
avaliarPalavra caminho atm = Set.member (last caminho) (T.estadosFinais atm)

-- Função para realizar a transição em um AFD
transicionarAFD :: Estado -> Simbolo -> TransicoesAFD -> Either String Estado
transicionarAFD estado simbolo tranAFD = do 
    case Map.lookup (estado, simbolo) tranAFD of
        Just destino -> Right destino
        Nothing -> Left ("Palavra rejeitada! \nTransicao inexistente: (" ++ show estado ++ ", " ++ show simbolo ++ ")")
    
