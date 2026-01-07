
-- exportar funções
module Automato.Reader
  ( lerAutomato
  , lerPalavras
  ) where

import Automato.Types
import Data.Aeson (decode)
import qualified Data.ByteString.Lazy as B

-- Lê um autômato do JSON
lerAutomato :: FilePath -> IO Automato
lerAutomato caminho = do
  conteudo <- B.readFile caminho
  case decode conteudo of
    Just automato -> return automato
    Nothing -> do
      putStrLn "Falha ao decodificar JSON. Conteúdo do arquivo:"
      B.putStr conteudo  
      error "Erro ao ler o JSON do autômato"
      
-- Lê palavras de um arquivo .txt
lerPalavras :: FilePath -> IO [String]
lerPalavras caminho = do
  conteudo <- readFile caminho
  return (lines conteudo)