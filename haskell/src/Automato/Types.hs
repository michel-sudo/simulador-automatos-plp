{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE DeriveAnyClass #-}

module Automato.Types where

import GHC.Generics (Generic)
import Data.Aeson
import Data.Aeson.Types (Parser)
import qualified Data.Map as Map
import qualified Data.Set as Set

-- Tipos básicos
type Estado = String
type Simbolo = String
type Transicoes = Map.Map (Estado, Maybe Simbolo) (Set.Set Estado)

-- Transição JSON
data JsonTransicao = JsonTransicao
  { origem  :: Estado
  , simbolo :: Maybe Simbolo
  , destino :: [Estado]
  } deriving (Show, Generic, FromJSON) -- transformar json em valor haskell

-- Autômato
data Automato = Automato
  { estados       :: Set.Set Estado
  , alfabeto      :: Set.Set Simbolo
  , transicoes    :: Transicoes
  , estadoInicial :: Estado
  , estadosFinais :: Set.Set Estado
  } deriving (Show, Generic) -- transformar json em valor haskell

-- Resultado do teste
--Indica se uma palavra é aceita ou rejeitada pelo autômato.
data ResultadoTeste = Aceita | Rejeita
  deriving (Show, Eq)

-- Decodificação JSON
--Define como ler o JSON e transformar em Automato.
instance FromJSON Automato where
  parseJSON = withObject "Automato" $ \v -> do
    estadosLista       <- v .: "estados"
    alfabetoLista      <- v .: "alfabeto"
    estadoInicial      <- v .: "estadoInicial"
    estadosFinaisLista <- v .: "estadosFinais"
    transicoesLista    <- v .: "transicoes" :: Parser [JsonTransicao]

    -- Converter lista para Set/Map
    let estados = Set.fromList estadosLista
        alfabeto = Set.fromList alfabetoLista
        estadosFinais = Set.fromList estadosFinaisLista
        transicoes = foldr (\(JsonTransicao o s ds) acc ->
                              foldr (\d m -> Map.insert (o,s) (Set.singleton d) m) acc ds
                            ) Map.empty transicoesLista

    return Automato {..}