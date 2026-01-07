module Automato.Interface (menu) where

import Automato.Types
import Automato.Reader
import Automato.AFD
import Automato.AFN
import Automato.DescricaoFormal

lerPalavrasTerminal :: IO [String]
lerPalavrasTerminal = do
  linha <- getLine
  if null linha
    then return []
    else do
      resto <- lerPalavrasTerminal
      return (linha : resto)

testarVariasPalavrasAFD :: Automato -> [String] -> IO ()
testarVariasPalavrasAFD automato palavras =
  mapM_ testar palavras
  where
    testar p =
      putStrLn $
        "Palavra: " ++ p ++ " -> " ++ show (testePalavraAFD automato p)

testarVariasPalavrasAFN :: Automato -> [String] -> IO ()
testarVariasPalavrasAFN automato palavras =
  mapM_ testar palavras
  where
    testar p =
      putStrLn $
        "Palavra: " ++ p ++ " -> " ++ show (testePalavraAFN automato p)

menu :: IO ()
menu = do
  putStrLn "=== SIMULADOR DE AUTÔMATOS ==="
  putStrLn "1 - Testar AFD"
  putStrLn "2 - Testar AFN"
  putStrLn "0 - Sair"
  opcao <- getLine
  case opcao of
    "1" -> executarAFD
    "2" -> executarAFN
    "0" -> putStrLn "Encerrando..."
    _   -> menu

executarAFD :: IO ()
executarAFD = do
  automato <- lerAutomato "examples/AFD.json"

  putStrLn "Digite as palavras (linha vazia para finalizar):"
  palavras <- lerPalavrasTerminal

  putStrLn ""
  testarVariasPalavrasAFD automato palavras

  putStrLn ""
  mostrarDescricaoFormal automato
  menu

executarAFN :: IO ()
executarAFN = do
  automato <- lerAutomato "examples/AFN.json"

  putStrLn "Digite as palavras (linha vazia para finalizar):"
  palavras <- lerPalavrasTerminal

  putStrLn ""
  testarVariasPalavrasAFN automato palavras

  putStrLn ""
  mostrarDescricaoFormal automato
  menu