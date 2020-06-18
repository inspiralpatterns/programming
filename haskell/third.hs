{-
    HASKELL FIRST EXPERIMENTS
    (https://youtu.be/qcLLcpajp7M)
-}

import Data.Map hiding (map)


-- reimplementation of LiveCoder type
type Name = String
type Age = Maybe Int

data LiveCoder = LiveCoder {
    name :: Name,
    age :: Age,
    language :: Maybe LiveCodingLanguage        -- might not be given, though not optional
    } deriving (Show, Eq, Ord)


-- old way of defining types, no getter though
data LiveCoder' = LiveCoder' Name Age ( Maybe LiveCodingLanguage )

data LiveCodingLanguage =
    SuperCollider       |
    TidalCycles         |
    Extempore 
    deriving (Show, Eq, Ord)

pattern :: LiveCoder
pattern = LiveCoder "pattern" Nothing ( Just TidalCycles )
sergio = LiveCoder "sergio" ( Just 27 ) Nothing
caplaz = LiveCoder "caplaz" ( Just 33 ) ( Just SuperCollider )

-- Esemble as a map of LiveCoders
type Location = String

liveCoderMap :: Map Location LiveCoder
liveCoderMap = fromList [
    ("Copenhagen", pattern),
    ("Vicenza", sergio),
    ("Brighton", caplaz)
                        ]

getResponse :: String -> String
getResponse = liveCoderToString . queryLiveCoder

queryLiveCoder :: String -> Maybe LiveCoder
queryLiveCoder = \x -> Data.Map.lookup x liveCoderMap

liveCoderToString :: Maybe LiveCoder -> String
liveCoderToString (Just l) = show l
liveCoderToString Nothing = "Sorry, no livecoder found."

-- show livecoder info based on user prompt
main :: IO ()
main = do
    putStrLn "Please insert the livecoder location"
    l <- getLine
    putStrLn $ getResponse l
