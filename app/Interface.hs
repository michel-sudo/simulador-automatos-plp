{-# OPTIONS_GHC -Wno-name-shadowing #-}
module Interface where
import qualified Data.Text as Tx
import System.IO (hFlush, stdout)
import Types 
import Reader 
import qualified Types as T
import AFD
import AFN

-- Loop principal do programa
loop :: Maybe Automato -> IO ()
loop Nothing = menuInicial
loop (Just atm) = menuComAutomato atm 

-- Menu inicial para carregar autômato
menuInicial :: IO ()
menuInicial = do
    putStrLn "\n=== Simulador de Autômatos ==="
    putStrLn "1. Carregar autômato (JSON)"
    putStrLn "0. Sair"
    putStr "Escolha uma opção: "
    hFlush stdout

    opcao <- getLine
    case opcao of
        "1" -> carregarAutomato
        "0" -> putStrLn "Encerrando."
        _   -> do
            putStrLn "Opção inválida."
            menuInicial

-- Função para carregar o autômato a partir de um arquivo JSON
carregarAutomato :: IO ()
carregarAutomato = do
    putStr "Caminho do arquivo JSON: "
    hFlush stdout
    caminho <- getLine

    resultado <- lerAutomato caminho
    case resultado of
        Left err -> do
            putStrLn ("Erro ao carregar autômato: " ++ err)
            menuInicial
        Right atm -> do
            putStrLn "Autômato carregado com sucesso."
            loop (Just atm)

-- Menu após carregar o autômato
menuComAutomato :: Automato -> IO ()
menuComAutomato atm = do
    putStrLn "\n=== Autômato carregado ==="
    putStrLn "1. Testar palavra"
    putStrLn "2. Carregar novo autômato"
    putStrLn "0. Sair"
    putStr "Escolha uma opção: "
    hFlush stdout

    opcao <- getLine
    case opcao of
        "1" -> testarPalavra atm
        "2" -> loop Nothing
        "0" -> putStrLn "Encerrando."
        _   -> do
            putStrLn "Opção inválida."
            menuComAutomato atm

-- Função para testar uma palavra no autômato carregado
testarPalavra :: Automato -> IO ()
testarPalavra atm = do
    putStr "Digite a palavra: "
    hFlush stdout
    entrada <- getLine

    let palavra = map (Tx.pack . (:[])) entrada

    case atm of 
        T.AFD {} -> do  
            case simularAFD atm palavra of
                Left err -> do
                    putStrLn ("Erro: " ++ err)
                    menuComAutomato atm
                Right caminho -> do
                    exibirResultado [caminho] atm
                    menuComAutomato atm
        T.AFN {} -> do
            case simularAFN atm palavra of
                Left err -> do
                    putStrLn ("Erro: " ++ err)
                    menuComAutomato atm
                Right caminhos -> do
                    exibirResultado caminhos atm
                    menuComAutomato atm

-- Função para exibir o resultado da simulação
exibirResultado :: [Caminho] -> Automato -> IO ()
exibirResultado [] _ = putStrLn "Palavra rejeitada."
exibirResultado caminhos _ = do
    putStrLn "Palavra aceita."
    putStrLn "Caminhos de aceitação:"
    mapM_ exibirCaminho caminhos

-- Função para exibir um caminho
exibirCaminho :: Caminho -> IO ()
exibirCaminho caminho = do
    let partes = map Tx.unpack caminho
    putStrLn (concatMap (++ " -> ") (init partes) ++ last partes)
