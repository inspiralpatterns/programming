{- 2020-03-29 -}
-- following Learn You a Haskell for Great Good!

doubleMe x = x + x

doubleUs x y = doubleMe x + doubleMe y

doubleSmallNumber x = if x > 100
                         then x
                         else doubleMe x

doubleSmallNumber' x = (if x > 100 then x else doubleMe x) + 1

-- example of name definition
listDef = [0,1,2,3]

-- get the first n element from an infinite list
-- e.g. take the first 24 multipliers of 13
notAnInfiniteList = take 24 [13, 26..]

-- generate the set of all triangles with sides not larger than 10
triangles = [(a,b,c) | a<-[1..10], b<-[1..10], c<-[1..10]]

-- filter right triangles only
rightTriangles = [(a,b,c) | c<-[1..10], b<-[1..c], a<-[1..b], a^2 + b^2 == c^2]

-- function type declaration
removeNonUppercase :: [Char] -> [Char]
removeNonUppercase xs = [x | x <- xs, x `elem` ['A'..'Z']]


{- 2020-03-30 -}
-- PATTERN MATCHING
-- e.g. factorial function
factorial :: (Integral a) => a -> a
factorial 0 = 1
factorial n = n * factorial (n-1)

-- pattern matching on tuples
-- e.g. adding vectors
addVectors :: (Num a) => (a, a) -> (a, a) -> (a, a)
addVectors (x1, y1) (x2, y2) = (x1+x2, y1+y2)

-- extracting first element from triples (not allowed in standard lib)
fst' :: (Num a) => (a, a, a) -> a
fst' (x, _, _) = x

-- pattern matching on lists
-- bind first element to variable
isolateFirst :: [a] -> a
isolateFirst [] = error "No first"
isolateFirst (x:_) = x

-- bind second elements
isolateSecond :: [a] -> a
isolateSecond [] = error "No second"
isolateSecond (x:y:_) = y

-- length function in a recursive way
-- add one and filter first element
length' :: (Num b) => [a] -> b
length' [] = 0
length' (_:xs) = 1 + length' xs

-- sum function in a recursive way
sum' :: (Num a) => [a] -> a
sum' [] = 0
sum' (x:xs) = x + sum' xs

-- as patterns
-- keep the whole reference
capital :: String -> String
capital [] = "Oops, empty string"
capital wholeWord @ (x:_) = "The capital of " ++ wholeWord ++ " is " ++ [ x ]


{- 20200331 -}
-- GUARDS
bmiTell :: (RealFloat a) => a -> String
bmiTell bmi
    | bmi <= 18.5       = "Eat more"
    | bmi <= 25         = "Good"
    | bmi <= 30         = "Eat less"
    | otherwise         = "Don't eat"

-- max function
max' :: (Ord a) => a -> a -> a
max' x y
    | x < y             = y
    | otherwise         = x


-- `where` bindings
-- initials back given first and last name
initials :: String -> String -> String
initials firstName @ (x:_) lastName @ (y:_) 
  = "Your initials are " ++ init ++ " for the name " ++ firstName ++ " " ++ lastName
      where init = x:y:[]

-- second implementation
initials' :: String -> String -> String
initials' firstName lastName = [f] ++ ". " ++ [l] ++ "."
    where (f:_) = firstName
          (l:_) = lastName

-- function in bindings
calcBmis :: (RealFloat a) => [(a, a)] -> [a]
calcBmis xs = [bmi w h | (w, h) <- xs]
    where bmi weight height = weight / height^2 

-- using let binding as predicate in list comprehension
calcBmis' :: (RealFloat a) => [(a, a)] -> [a]
calcBmis' xs = [bmi w h | (w, h) <- xs, let bmi w h = w / h^2]


{- 20200410 -}
-- Currying and partial application
-- eg. compare a given no. with 100 (Num a required because of 100)
compareHundredWith :: (Num a, Ord a) => a -> Ordering
compareHundredWith = compare 100 

-- sectioning
doubleSection :: Fractional a => a -> a
doubleSection = (*2)

isCapitalLetter :: Char -> Bool
isCapitalLetter = (`elem` ['A'..'Z'])

-- EXAMPLES OF HIGHER ORDER FUNCTIONS
-- apply a function twice
applyTwice :: (a -> a) -> a -> a
applyTwice f x = f (f x)

-- own implementation of zipWith
zipWith' :: (a -> b -> c) -> [a] -> [b] -> [c]
zipWith' f = plh
    where 
        plh [] _                 = []
        plh _ []                 = []
        plh (x:xs) (y:ys)        = f x y : plh xs ys

-- own implementation of map
map' :: (a -> b) -> [a] -> [b]
map' f = go
    where
        go []         = []
        go (x:xs)       = f x : go xs

-- own implementation of filter
filter' :: (a -> Bool) -> [a] -> [a]
filter' p [] = []
filter' p (x:xs)
    | p x               = x : filter' p xs
    | otherwise         = filter' p xs


-- find the largest number under 10^5 divisible by a number
-- first implementation: map and filter
largestDivisor :: (Num a, Enum a, Ord a) => a -> a
largestDivisor x = last $ filter (< 100000) $  map (x*) [1..100000]
-- second implementation: filter over modulo (infinite list allowed by head)
largestDivisor' :: (Integral a) => a -> a
largestDivisor' x = head $ filter p [100000,99999..]
    where p y = y `mod` x == 0


{- 20200412 -}
-- compute a Collatz sequence
collatzSeq :: (Integral a) => a -> [a]
collatzSeq 1 = [1]
collatzSeq x
    | odd x             = x : collatzSeq (3*x + 1)
    | even x            = x : collatzSeq (x `div` 2)


-- no. of sequences larger than 15 for first 100 natural numbers
longSeqs :: Int
longSeqs = length $ filter isLong (map collatzSeq [1..100])
    where isLong xs = length xs > 15 -- predicate for filter 


-- create a list of functions, extract the 4th element 
-- and apply second parameter
multiply4th :: (Integral a) => a -> a 
multiply4th x =  (listOfFun !! 4) x
    where listOfFun = map (*) [0..]


{- 20200413 -}
-- FOLDS
-- implementation of sum using left fold
sum'' :: (Num a) => [a] -> a
sum'' = foldl (+) 0 

-- implementation of elem using left fold
elem' :: (Eq a) => a -> [a] -> Bool
elem' y ys = foldl (\acc x -> if x == y then True else acc) False ys

-- implementation of map using right fold
map'' :: (a -> b) -> [a] -> [b]
map'' f xs = foldr (\ x acc -> f x : acc) [] xs

-- using foldl1 and foldr1
max'' :: (Num a, Ord a) => [a] -> a
max'' = foldl1 (\ acc x -> if x > acc then x else acc)

-- implementation of reverse
reverse':: [a] -> [a]
reverse' = foldl (\ acc x -> x : acc) []

-- implementation of product
product' :: (Num a) => [a] -> a
product' = foldl1 (*)

-- implementation of filter
filter'' :: (a -> Bool) -> [a] -> [a]
filter'' p = foldr (\ x acc -> if p x then x : acc else acc) []

-- implementation of head
head' :: (Foldable t) => t a -> a
head' = foldr1 (\ x _ -> x)

-- implementation of last
last' :: (Foldable t) => t a -> a
last' = foldl1 (\ _ x -> x)


-- SCANS
-- example of using scan to keep track of intermediate acc values
sqrtSum :: Int
sqrtSum = length (takeWhile (< 1000) (scanl1 (+) (map sqrt [1..]))) + 1





