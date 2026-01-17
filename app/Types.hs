module Types where

import Data.Text 
import qualified Data.Set as Set
import qualified Data.Map as Map
import qualified Data.Text as Tx

type Estado = Text
type Simbolo = Text
type Palavra = [Simbolo]
type Caminho = [Estado]

--- Símbolo especial para transições epsilon
epsilon :: Simbolo
epsilon = Tx.pack "e"

-- Para AFD
type TransicoesAFD = Map.Map (Estado, Simbolo) Estado

-- Para AFN
type TransicoesAFN = Map.Map (Estado, Simbolo) (Set.Set Estado)

-- Estrutura que representa um autômato (AFD ou AFN)
data Automato = AFD { 
    estados :: Set.Set Estado, 
    alfabeto :: Set.Set Simbolo,
    transicoesAFD :: TransicoesAFD,
    estadoInicial :: Estado,
    estadosFinais :: Set.Set Estado
    } | AFN { 
    estados :: Set.Set Estado,
    alfabeto :: Set.Set Simbolo,
    transicoesAFN :: TransicoesAFN,
    estadoInicial :: Estado,
    estadosFinais :: Set.Set Estado
    } deriving (Show, Eq)

-- Resultado da simulação do autômato
data ResultadoSimulacao = Aceita { 
    menssagem :: Text, 
    caminhos :: [Caminho]
    } | Rejeita { 
    menssagem :: Text 
    } deriving (Show, Eq)
