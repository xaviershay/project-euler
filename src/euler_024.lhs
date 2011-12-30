Problem 24
----------

 > A permutation is an ordered arrangement of objects. For example, 3124 is one
 > possible permutation of the digits 1, 2, 3 and 4. If all of the permutations
 > are listed numerically or alphabetically, we call it lexicographic order.
 > The lexicographic permutations of 0, 1 and 2 are:
 > 
 > 012, 021, 102, 120, 201, 210
 >
 > What is the millionth lexicographic permutation of the digits 0 to 9?

Haskell provides a built in `permutations` function, but it is not in lexical
order. It is not hard to define using list comprehensions.

> lexicalPermutations [] = [[]]
> lexicalPermutations xs = [x:ys | x  <- xs,
>                                  ys <- lexicalPermutations (delete x xs)]

There is a potential off-by-one error lurking here. The sixth permutation is at
index five in the list.

> euler24 range n = map intToDigit $ lexicalPermutations range !! (n-1)

> tests24 =
>   [ "#24 given"   ~: "210"        ~=? euler24 [0..2] 6
>   , "#24 problem" ~: "2783915460" ~=? euler24 [0..9] 1000000
>   ]
