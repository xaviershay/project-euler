Problem 14
----------

 > The following iterative sequence is defined for the set of positive integers:
 >
 > |n -> n/2 (n is even)|<br />
 > |n -> 3n + 1 (n is odd)|
 >
 > Using the rule above and starting with 13, we generate the following
 > sequence:
 >
 > 13, 40, 20, 10, 5, 16, 8, 4, 2, 1
 >
 > It can be seen that this sequence contains 10 terms. Although it has not
 > been proved yet (Collatz Problem), it is thought that all starting numbers
 > finish at 1.
 >
 > Which starting number, under one million, produces the longest chain?
 >
 > Note that once the chain starts the terms are allowed to go above one
 > million.

A recursive function can be used to calculate the length of the collatz
sequence for a number. Memoization is critical here as it speeds up the
solution by an order of magnitude.

> collatz :: Integer -> Integer
> collatz = Memo.arrayRange (1,1000000) collatz'
>   where
>     collatz' 1  = 1
>     collatz' x
>       | even x    = 1 + collatz (x `shiftR` 1)
>       | otherwise = 1 + collatz (3 * x + 1)

Tuple comparison in Haskell is done using the first element, so `max (5,1)
(4,100)` will return `(5,1)`. This is taken advantage to find the maximum index
of a list by zipping the index of each element into the list (creating a list
of tuples), finding the maximum tuple (which will compare on the original
value), then returning the second element of that tuple.

The strict function `fold1' max` is used rather than `maximum` so that it
executes with a constant memory bound. See the Haskell wiki page on [stack
overflow][hwiki-stack-overflow] for more information.

A signature is required to allow it to be generalized to lists of any type.

[hwiki-stack-overflow]: http://www.haskell.org/haskellwiki/Stack_overflow

> maxIndex :: (Ord a) => [a] -> Int
> maxIndex = snd . foldl1' max . (flip zip [0..])

The solution is a trivial combination of these two functions.

> euler14 n = (maxIndex lengths) + 1
>   where
>     lengths = map collatz [1..n-1]

> tests14 =
>   [ "#14 given"   ~: 9      ~=? euler14 13
>   , "#14 problem" ~: 837799 ~=? euler14 1000000
>   ]
