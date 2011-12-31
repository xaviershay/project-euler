Problem 10
----------

 > The sum of the primes below 10 is |2 + 3 + 5 + 7 = 17|.
 >
 > Find the sum of all the primes below two million.

Re-uses the `primes` function defined in problem seven. Takes a few seconds,
but gets the solution in the end.

> euler10 n = sum $ takeWhile (< n) primes

> tests10 =
>   [ "#10 given"   ~: 17           ~=? euler10 10
>   , "#10 problem" ~: 142913828922 ~=? euler10 2000000
>   ]
