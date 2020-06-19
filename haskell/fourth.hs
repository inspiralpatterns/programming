{-
    HASKELL FIRST EXPERIMENTS
    (https://youtu.be/YCUYMNEfjb8)
-}

import Control.Monad.Trans.Except


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
    x   <- dbLookup1                      -- x :: IO (Either String Int)
    y   <- dbLookup2                      -- y :: IO (Either String Int)
    return $ addEitherValues x y          -- x, y :: Either String Int

-- needed to add Either values
addEitherValues :: Either String Int -> Either String Int -> Either String Int
addEitherValues (Left x) _ = Left x
addEitherValues _ (Left x) = Left x
addEitherValues (Right x) (Right y) = Right (x + y)


-- using monad transformers: ExceptT
-- newtype ExceptT e m a
-- ExceptT (m (Either e a))
type DatabaseIO = ExceptT String IO
dbLookup1' :: DatabaseIO Int            -- useful to think: (ExceptT String IO) = m => m Int
dbLookup1' = return 7

dbLookup2' :: DatabaseIO Int
dbLookup2' = return 8

dbProgram'' :: IO (Either String Int)
dbProgram'' = do
    putStrLn "This program is useless but nice."
    runExceptT $ do        -- unwrap IO () from ExceptT
        x   <- dbLookup1'         -- x :: Int
        y   <- dbLookup2'         -- y :: Int
        return ( x + y )

-- using applicative style instead of do
-- motivation: the function is pure, we can lift it to DatabaseIO context
dbProgram''' :: IO (Either String Int)
dbProgram''' = do
    putStrLn "This program is very useless but nicely written."
    runExceptT $ (\x y -> x + y) <$> dbLookup1' <*> dbLookup2'


