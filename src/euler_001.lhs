Problem 1
---------

  > If we list all the natural numbers below 10 that are multiples of 3 or 5,
  we get 3, 5, 6 and 9. The sum of these multiples is 23.
  >
  > Find the sum of all the multiples of 3 or 5 below 1000.

Haskell allows an expressive solution to this problem. The only novelty is the
use of `nub`, a built in function for removing duplicates from an array, the
distinct naming of which I haven't seen elsewhere.

> euler1 max = sum . nub $ (multiplesOf 3) ++ (multiplesOf 5)
>   where
>     multiplesOf x = [x,x*2..max-1]

> tests1 =
>   [ "#1 given"   ~: 23     ~=? euler1 10
>   , "#1 problem" ~: 233168 ~=? euler1 1000
>   ]
