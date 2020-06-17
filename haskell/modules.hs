{-
    On the definition of modules
    Rework of first.hs using Maybe module
-}

module Test.Livecoding where

import Data.Maybe

-- manage case where live coding language might not be there
data LiveCodingLanguage =
    SuperCollider       |
    TidalCycles         |
    Extempore 
    deriving (Show, Eq, Ord)

data LiveCoder = LiveCoder {
    name :: String,
    language :: Maybe LiveCodingLanguage,        -- Just the language, or Nothing
    age :: Maybe Age
    } deriving (Show)

type Ensemble = [LiveCoder]
type Age = Int


-- example of livecoders
pattern = LiveCoder "pattern" (Just TidalCycles) (Just 32)
sergio = LiveCoder "sergio" Nothing Nothing

noCodeLines :: LiveCodingLanguage -> Int
noCodeLines l = case l of
                  SuperCollider -> 100
                  TidalCycles -> 70
                  Extempore -> 60

noCodeLines' :: Maybe LiveCodingLanguage -> Int
noCodeLines' (Just l)    = noCodeLines l        -- using pattern matching to access l from its context
noCodeLines' Nothing     = 0

-- using maybe function (Data.Maybe)
noCodeLines'' :: Maybe LiveCodingLanguage -> Int
noCodeLines'' = maybe 0 noCodeLines

-- read age from Maybe
getAge :: Maybe Age -> Age
getAge (Just a) = a
getAge Nothing = 0

-- calculate age sum for ensemble
ensembleAge :: Ensemble -> Int
ensembleAge = (foldl1 (+) . (map extractAge)) where
    extractAge = getAge . age

-- using catMaybes
ensembleAge' :: Ensemble -> Int
ensembleAge' = \x -> foldl1 (+) (catMaybes $ map age x)














