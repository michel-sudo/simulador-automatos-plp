{-# OPTIONS_GHC -Wno-name-shadowing #-}
module AFN where

import Types 
import qualified Types as T
import qualified Data.Set as Set
import qualified Data.Map as Map
import Control.Monad (foldM)

-- Função para simular um AFN com uma palavra de entrada
simularAFN :: Automato -> Palavra -> Either String [Caminho]
simularAFN atm palavra =
    case atm of
        T.AFD {} -> Left "Autômato não é não-determinístico (AFN)"
        T.AFN {} ->
            let caminhosIniciais = concatMap (expandirEpsilon atm) [[estadoInicial atm]]
            in do
                caminhosFinais <- foldM (inserir atm) caminhosIniciais palavra
                let aceitos = filter (`avaliarPalavra` atm) caminhosFinais
                if null aceitos
                then Left "Palavra rejeitada! \nNenhum caminho leva a um estado final"
                else Right aceitos

-- Função auxiliar para inserir um símbolo em todos os caminhos atuais
inserir :: Automato -> [Caminho] -> Simbolo -> Either String [Caminho]
inserir atm caminhos simbolo = do
    let aposEpsilon = concatMap (expandirEpsilon atm) caminhos
        aposSimbolo = concatMap (expandirSimbolo atm simbolo) aposEpsilon
        finais      = concatMap (expandirEpsilon atm) aposSimbolo
    if null finais
        then Left ("Palavra rejeitada! \nNenhuma transição válida para o símbolo: " ++ show simbolo)
        else Right (Set.toList (Set.fromList finais)) -- Eliminar caminhos duplicados

-- Função para expandir um caminho com um símbolo específico
expandirSimbolo :: Automato -> Simbolo -> Caminho -> [Caminho]
expandirSimbolo atm simbolo caminho =
    [ caminho ++ [e] 
    | e <- Set.toList $ Map.findWithDefault Set.empty (last caminho, simbolo) (transicoesAFN atm)]

-- Função para expandir um caminho com transições epsilon
expandirEpsilon :: Automato -> Caminho -> [Caminho]
expandirEpsilon atm caminho =
    dfs (last caminho) (Set.singleton (last caminho)) caminho
  where
    dfs :: Estado -> Set.Set Estado -> Caminho -> [Caminho]
    dfs estadoAtual visitados caminhoAtual =
        let destinosEpsilon =
              Set.toList $
                Map.findWithDefault Set.empty (estadoAtual, epsilon) (transicoesAFN atm)

            novos =
              [ dfs prox (Set.insert prox visitados) (caminhoAtual ++ [prox])
              | prox <- destinosEpsilon
              , not (Set.member prox visitados)
              ]
        in caminhoAtual : concat novos


-- Função para calcular o fecho epsilon de um conjunto de estados
epsilonFecho :: Automato -> Set.Set Estado -> Set.Set Estado
epsilonFecho atm estadosIniciais =
    expandir estadosIniciais estadosIniciais
    where
        expandir visitados fronteira
            | Set.null fronteira = visitados
            | otherwise =
                let novos =
                        Set.unions
                        [ Map.findWithDefault Set.empty (e, epsilon) (transicoesAFN atm)
                        | e <- Set.toList fronteira]
                    naoVisitados = novos `Set.difference` visitados
                in expandir (visitados `Set.union` naoVisitados) naoVisitados

-- Função para avaliar se algum caminho leva a um estado final
avaliarPalavra :: Caminho -> Automato -> Bool
avaliarPalavra caminho atm =
  let finaisEpsilon =
        epsilonFecho atm (Set.singleton (last caminho))
  in not (Set.null (finaisEpsilon `Set.intersection` estadosFinais atm))
