{-
    HASKELL FIRST EXPERIMENTS
    (https://youtu.be/YCUYMNEfjb8)
-}


-- Monad Transformers
--
-- database lookup simulation with Either
dbLookup1 :: IO (Either String Int)
dbLookup1 = return $ return 7           -- double context, double return

dbLookup2 :: IO (Either String Int)
dbLookup2 = return $ return 8

-- sequentially perform computation
dbProgram = dbLookup1 >>= \x -> 
    ( dbLookup2 >>= \y -> return $ addEitherValues x y)         -- obs: return (x + y) won't work as they are pure values

-- using do notation, equivalent to above
dbProgram' = do
    x   <- dbLookup1                                            -- x :: IO (Either String Int)
    y   <- dbLookup2                                            -- y :: IO (Either String Int)
    return $ addEitherValues x y                                -- x, y :: Either String Int

-- needed to add Either values
addEitherValues :: Either String Int -> Either String Int -> Either String Int
addEitherValues (Left x) _ = Left x
addEitherValues _ (Left x) = Left x
addEitherValues (Right x) (Right y) = Right (x + y)


