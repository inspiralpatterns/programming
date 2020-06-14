-- simple implementation of Tree and few helpers
-- definition of a Tree
-- obs: an empty tree is a Tree
data Tree = Nil | Node Int Tree Tree
    deriving Show

-- compute the depth of a Tree
treeDepth :: Tree -> Int
treeDepth Nil = 0
treeDepth (Node _ lt rt) =
    1 + max (treeDepth lt) (treeDepth rt)

-- traverse the tree and adds up all values in its nodes
treeSum :: Tree -> Int
treeSum Nil = 0
treeSum (Node x lt rt) = 
    x + treeSum lt + treeSum rt

-- check if empty tree
isEmpty :: Tree -> Bool
isEmpty Nil = True
isEmpty (Node _ _ _) = False

-- get min value in non-empty tree
minT :: Tree -> Int
minT (Node x lt rt) = min x (min y z)
    where y = if isEmpty lt then x else minT lt
          z = if isEmpty rt then x else minT rt

-- get max value in non-empty tree
maxT :: Tree -> Int
maxT (Node x lt rt) = max x (max y z)
    where y = if isEmpty lt then x else maxT lt
          z = if isEmpty rt then x else maxT rt

-- helper: get the value of a node
getNodeValue :: Tree -> Int
getNodeValue (Node x _ _) = x

-- check whether a tree is sorted 
-- i.e. for any Node x, x > y for any y in lt and x < z for any z in rt
isSortedTree :: Tree -> Bool
isSortedTree Nil = True
isSortedTree (Node x lt rt) =
        isSortedTree lt && isSortedTree rt &&
        (isEmpty lt || x > maxT lt) && (isEmpty rt || x < minT rt)

-- convert a Tree into a list
treeToList :: Tree -> [Int]
treeToList Nil = []
treeToList (Node x lt rt) = 
    treeToList lt ++ [x] ++ treeToList rt

