{-
   2020-07-10
   LEARN YOU A HASKELL / modules 
-}

import Data.List
import Data.Char
import qualified Data.Map as Map

-- count numbers of unique elements in list
uniqueCount :: ( Eq a ) => [a] -> Int
uniqueCount = length . nub


-- put a zero in between each element of the list
intersperseWithZero :: (Num a) => [a] -> [a]
intersperseWithZero = intersperse 0


-- check if a string is part of another string
isPartOf :: (Eq a) => [a] -> [a] -> Bool
isPartOf ss s = foldl (\acc x -> if take n x == ss then True else acc) False $ tails s
    where n = length ss


-- return the first element that satisfies a condition in a list
findFirstSuccess :: (a -> Bool) -> [a] -> Maybe a
findFirstSuccess f lst = find f lst
-- simplify
findFirstSuccess' :: (a -> Bool) -> [a] -> Maybe a
findFirstSuccess'= find 


-- insert a Fractional list in a Fractional list
insertFractionals :: (Ord a) => [a] -> [a] -> [a]
insertFractionals [] = \y -> y
insertFractionals (x:xs) = \y -> insertFractionals xs $ insert x y
-- rewrite in point free style
insertFractionals' :: (Ord a) => [a] -> [a] -> [a]
insertFractionals' [] = \y -> y
insertFractionals' (x:xs) = \y -> ( insertFractionals xs . insert x ) y


-- Caesar cipher
-- transform chars in numbers with `ord`, shifts and transform back with `chr`
caesarEncode :: [Char] -> Int -> [Char]
caesarEncode s n = map chr $ map (+ n) ords
    where ords = map ord s
-- using function composition
caesarEncode' :: Int -> [Char] -> [Char]
caesarEncode' n = map (chr . (+ n) . ord)


-- decode a ciphered message
caesarDecode :: Int -> [Char] -> [Char]
caesarDecode n = caesarEncode' $ negate n


-- lookup for a key in a list of key/values
lookup' :: (Eq k) => k -> [(k, v)] -> Maybe v
lookup' key [] = Nothing
lookup' key ((k,v):xs) = if k == key
                           then Just v
                           else lookup' key xs
-- using folds
lookup'' :: (Eq k) => k -> [(k, v)] -> Maybe v
lookup'' key = foldr (\(k,v) acc -> if key == k then Just v else acc) Nothing


-- own implementation of fromList using folds
fromList' :: (Ord k) => [(k, v)] -> Map.Map k v
fromList' = foldr (\(k,v) acc -> Map.insert k v acc) Map.empty

-- return keys in a map
getKeys :: Map.Map k v -> [ k ]
getKeys = \m -> map fst $ Map.toList m
-- using point-free style
getKeys' :: Map.Map k v -> [ k ]
getKeys' = map fst . Map.toList

-- return values in a map
getValues' :: Map.Map k v -> [ v ]
getValues' = map snd . Map.toList

