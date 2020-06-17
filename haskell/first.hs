{-
    HASKELL FIRST EXPERIMENTS
    (follows https://youtu.be/kGbelVBCWDk)
-}

-- add 1 to in arg
-- obs:
--      1. in arg omitted (could be add1 x = x + 1)
--      2. use of sectioning (x + 1 => (+1))
add1 :: (Num a) => a -> a
add1 = (+1)

-- add 1 to the second item in a tuple
add1ToTuple :: (Num a) => (a, a) -> a
add1ToTuple x = snd x + 1

-- same, using pattern matching
add1ToTuple' :: (Num a) => (a, a) -> a
add1ToTuple' (_, y) = y + 1

-- same, return the tuple
add1ToTuple'' :: (Num a) => (a, a) -> (a, a)
add1ToTuple'' (x, y) = (x, y+1)

-- add a number to the second item in a tuple
-- (using lambda, in arg omitted)
addToTuple :: (Num a) => (a, a) -> a -> a
addToTuple (_, y) = \z -> (+z) y

-- add a number to the specified item in a tuple
-- (need Eq for pattern matching)
addToTuple' :: (Num a, Eq a) => (a, a) -> a -> a -> a
addToTuple' (x, _) 1 = \z -> (+z) x
addToTuple' (_, y) 2 = \z -> (+z) y


-- *type synonim:* useful for doc
type Age = Int

nextBirthday :: Age -> Age
nextBirthday = (+1)

-- defining an algebraic type for live coding languages
data LiveCodingLanguage = 
    SuperCollider | TidalCycles | Extempore
    -- deriving Show -- needed to inspect in ghci

-- return lines of code for each live coding language repo
-- (use of case of)
noCodeLines :: LiveCodingLanguage -> Int
noCodeLines x   = case x of
                    SuperCollider -> 100
                    TidalCycles -> 70
                    Extempore -> 60


-- define a record syntax
-- obs: not an algebraic data types i.e. number of livecoders not fixed
data LiveCoder = LiveCoder {
    name :: String,
    language :: LiveCodingLanguage,
    age :: Age, -- definition becomes a function from LiveCoder to Age
    performances :: Int
    }
    deriving Show

-- example
pattern :: LiveCoder
pattern = LiveCoder "pattern" TidalCycles 32 7
sergio = LiveCoder "sergio" SuperCollider 21 5
{-
name pattern -- => "pattern"
age pattern -- => 32
:t name -- name :: LiveCoder -> String
-}

-- find the lines of code for the livecoder's language
-- e.g. of function composition
patternCodeLines = noCodeLines . language $ pattern


-- typeclasses
-- create an instance of Show to print constructors
-- obs: this overrides `deriving Show`
instance Show LiveCodingLanguage where
    show SuperCollider = "SC"
    show TidalCycles = "Tidal"
    show Extempore = "Ex-tempore"


-- alias for list of livecoders
type Ensemble = [LiveCoder]

-- find the total no. of performances for each livecoder in an ensemble
totalNoPerformances :: Ensemble -> Int
totalNoPerformances [] = 0
totalNoPerformances (x:xs) = performances x + totalNoPerformances xs

-- using folds
totalNoPerformances' :: Ensemble -> Int
totalNoPerformances' x = foldl1 (+) y where
    y = map performances x

-- using folds and function composition
-- (in arg removed, more haskell-ish style)
totalNoPerformances'' :: Ensemble -> Int
totalNoPerformances'' = (foldl1 (+)) . (map performances)


-- make instance of Eq for the LiveCodingLanguage space
-- obs: can be simplified invoking deriving (Eq)
instance Eq LiveCodingLanguage where
    SuperCollider == SuperCollider = True
    TidalCycles == TidalCycles = True
    Extempore == Extempore = True
    _ == _ = False -- catch all not true

