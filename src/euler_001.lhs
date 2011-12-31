Problem 1
---------

  > If we list all the natural numbers below 10 that are multiples of 3 or 5,
  > we get 3, 5, 6 and 9. The sum of these multiples is 23.
  >
  > Find the sum of all the multiples of 3 or 5 below 1000.

Haskell allows an expressive solution to this problem. Removing the sum of the
duplicate multiples afterwards is more efficient than trying to remove them
before summing, as no comparisons or branches are required.

> euler1 max = sumMultiples 3 + sumMultiples 5 - sumMultiples (3*5)
>  where
>    sumMultiples x = sum [x,x*2..max-1]

> tests1 =
>   [ "#1 given"   ~: 23     ~=? euler1 10
>   , "#1 problem" ~: 233168 ~=? euler1 1000
>   ]
