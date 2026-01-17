{-# LANGUAGE DeriveGeneric #-}
{-# OPTIONS_GHC -Wno-name-shadowing #-}
{-# LANGUAGE OverloadedStrings #-}

module Reader where

import qualified Types as T
import Types (Automato, Estado, Simbolo, TransicoesAFD, TransicoesAFN, epsilon)
import Data.Aeson 
import qualified Data.ByteString.Lazy as B
import Data.Text (Text)
import qualified Data.Set as Set
import qualified Data.Map as Map
import GHC.Generics (Generic)
import qualified Data.Text as Tx

-- Estrutura para representar transições em JSON
data TransicaoJSON = TransicaoAFDJSON {
    origem :: Text,
    simbolo :: Text,
    destino :: Text
    } | TransicaoAFNJSON {
    origem :: Text,
    simbolo :: Text,
    destinos :: [Text]
    } deriving (Show, Generic)

-- Estrutura para representar o autômato em JSON
data AutomatoJSON = AutomatoJSON {
    tipo :: Text,
    estados :: [Text],
    alfabeto :: [Text],
    estadoInicial :: Text,
    estadosFinais :: [Text],
    transicoes :: [TransicaoJSON]
} deriving (Show, Generic)

-- Função para construir um autômato (AFD ou AFN) a partir do JSON
construirAutomato :: AutomatoJSON -> Either String Automato
construirAutomato aj = do
    let estadosFinaisSet = Set.fromList (estadosFinais aj)
        estadosSet       = Set.fromList (estados aj)

    validarEstado estadosSet (estadoInicial aj)

    if not (estadosFinaisSet `Set.isSubsetOf` estadosSet)
        then Left "Estados finais inválidos"
        else Right ()
    
    case Tx.unpack(tipo aj) of
        "AFD" -> construirAFD aj 
        "AFN" -> construirAFN aj 
        _    -> Left "Tipo de autômato inválido"


-- Função para construir um AFD a partir do JSON
construirAFD :: AutomatoJSON -> Either String Automato
construirAFD aj = do
    let estadosSet       = Set.fromList (estados aj)
        estadosFinaisSet = Set.fromList (estadosFinais aj)
        alfabetoEither   = mapM validarCompSimbolo (alfabeto aj)
        transJson        = transicoes aj

    case alfabetoEither of
        Left err -> Left err
        Right alfabetoList -> do
            let alfabetoSet = Set.fromList alfabetoList
            transicoesMap <- construirTransicaoAFD estadosSet alfabetoSet transJson
            Right (T.AFD {
            T.estados = estadosSet,
            T.alfabeto = alfabetoSet,
            T.transicoesAFD = transicoesMap,
            T.estadoInicial = estadoInicial aj,
            T.estadosFinais = estadosFinaisSet
        })
        
-- Função para construir um AFN a partir do JSON
construirAFN :: AutomatoJSON -> Either String Automato
construirAFN aj = do
    let estadosSet       = Set.fromList (estados aj)
        estadosFinaisSet = Set.fromList (estadosFinais aj)

    alfabetoList <- mapM validarCompSimbolo (alfabeto aj)
    let alfabetoSet = Set.fromList alfabetoList

    transicoesMap <- construirTransicaoAFN estadosSet alfabetoSet (transicoes aj)

    Right (T.AFN {
        T.estados = estadosSet,
        T.alfabeto = alfabetoSet,
        T.transicoesAFN = transicoesMap,
        T.estadoInicial = estadoInicial aj,
        T.estadosFinais = estadosFinaisSet
    })


-- Valida se o estado pertence ao conjunto de estados
validarEstado :: Set.Set Estado -> Estado -> Either String ()
validarEstado estados e =
    if e `Set.member` estados
    then Right ()
    else Left ("Estado inválido: " ++ show e)

-- Valida se o símbolo pertence ao alfabeto
validarSimbolo :: Set.Set Simbolo -> Simbolo -> Either String ()
validarSimbolo alfabeto s
  | s == epsilon = Right ()
  | s `Set.member` alfabeto = Right ()
  | otherwise =
      Left ("Símbolo inválido: " ++ show s)

-- Valida se o símbolo é um único caracter
validarCompSimbolo :: Text -> Either String Text
validarCompSimbolo s
    | Tx.length s == 1 = Right s
    | otherwise        = Left ("Símbolo inválido (deve ser um único caracter): " ++ show s)

-- Função para construir a transição do AFD a partir do JSON
construirTransicaoAFD :: Set.Set Estado -> Set.Set Simbolo -> [TransicaoJSON] -> Either String TransicoesAFD
construirTransicaoAFD estados alfabeto = 
    foldl inserir (Right Map.empty)
    where 
        inserir acc tjson = do
            mapa <- acc 
            case tjson of
                TransicaoAFDJSON origem simbolo destino -> do
                    validarEstado estados origem
                    validarEstado estados destino
                    validarSimbolo alfabeto simbolo

                    let chave = (origem, simbolo)
                    if Map.member chave mapa
                    then Left ("Transição duplicada: " ++ show chave)
                    else Right (Map.insert chave destino mapa)
                
                TransicaoAFNJSON{} ->
                    Left "Transição AFN encontrada em definição de AFD"

-- Função para construir a transição do AFN a partir do JSON
construirTransicaoAFN :: Set.Set Estado -> Set.Set Simbolo -> [TransicaoJSON] -> Either String TransicoesAFN
construirTransicaoAFN estados alfabeto = 
    foldl inserir (Right Map.empty)
    where 
        inserir acc tjson = do
            mapa <- acc
            case tjson of
                TransicaoAFNJSON origem simbolo destinos -> do
                    validarEstado estados origem
                    mapM_ (validarEstado estados) destinos
                    validarSimbolo alfabeto simbolo

                    let chave = (origem, simbolo)
                    let destinosSet = Set.fromList destinos

                    Right (Map.insertWith Set.union chave destinosSet mapa)
                
                TransicaoAFDJSON origem simbolo destino -> do
                    validarEstado estados origem
                    validarEstado estados destino
                    validarSimbolo alfabeto simbolo

                    let chave = (origem, simbolo)
                    let destinosSet = Set.singleton destino
                    Right (Map.insertWith Set.union chave destinosSet mapa)

-- Instância FromJSON para TransicaoJSON
instance FromJSON TransicaoJSON where
    parseJSON = withObject "Transicao" $ \v -> do
        origem  <- v .: "origem"
        simbolo <- v .: "simbolo"

        -- tenta AFN primeiro (destino é lista)
        mDestinos <- v .:? "destino"
        case mDestinos of
            Just (Array _) -> do
                destinos <- v .: "destino"
                pure (TransicaoAFNJSON origem simbolo destinos)

            _ -> do
                destino <- v .: "destino"
                pure (TransicaoAFDJSON origem simbolo destino)

-- Instância FromJSON para AutomatoJSON
instance FromJSON AutomatoJSON where
    parseJSON = withObject "Automato" $ \v -> do
        tipo <- v .: "tipo"
        estados <- v .: "estados"
        alfabeto <- v .: "alfabeto"
        estadoInicial <- v .: "estadoInicial"
        estadosFinais <- v .: "estadosFinais"
        transicoes <- v .: "transicoes"
        pure AutomatoJSON {
            tipo = tipo,
            estados = estados,
            alfabeto = alfabeto,
            estadoInicial = estadoInicial,
            estadosFinais = estadosFinais,
            transicoes = transicoes
        }

-- Função para ler o autômato de um arquivo JSON
lerAutomatoJSON :: FilePath -> IO (Either String AutomatoJSON)
lerAutomatoJSON caminho = do
    conteudo <- B.readFile caminho
    pure (eitherDecode conteudo)

-- Função principal para ler e construir o autômato
lerAutomato :: FilePath -> IO (Either String Automato)
lerAutomato caminho = do
    resultado <- lerAutomatoJSON caminho
    pure (resultado >>= construirAutomato)
