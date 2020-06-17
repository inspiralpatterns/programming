{-
    HASKELL FIRST EXPERIMENTS
    (follows https://youtu.be/QgELJc0n_kI)
-}

-- the two declarations are equivalent
f :: Num a => a -> a -> a
f x y = x + y
g :: Num a => a -> (a -> a)
g x = \y -> x + y
-- e.g. the + operator and partial application
x = (+) 1 2     -- legal haskell, an expression of type Num a => a
y = (+1) 2      -- legal haskell, an expression of type Num a => a
z = (+1)        -- legal haskell, an expression of type Num a => a -> a (i.e a function)


-- currying functions
-- e.g. a function that takes a tuple (heigth, weight) and returns BMI
squaredHeigth :: (Floating a) => a -> a
squaredHeigth = (** 2) . (/ 100)

findBmi :: (Num a, Floating a) => (a, a) -> a           -- uncurried version
findBmi (w, h) = w / (squaredHeigth h)
findBmi' :: (Num a, Floating a) => a -> a -> a          -- same, but with distinct in args
findBmi' w h = w / (squaredHeigth h)
findBmi'' :: (Num a, Floating a) => (a, a) -> a         -- same, but going from original to prime via internal currying
findBmi'' (w, h) = curry findBmi w h

-- reverse the order of in args: `flip`
findBmi''' :: (Num a, Floating a) => a -> a -> a
findBmi''' = flip findBmi'

