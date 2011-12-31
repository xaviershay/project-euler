Problem 3
---------

 > The prime factors of 13195 are 5, 7, 13 and 29.
 >
 > What is the largest prime factor of the number 600851475143?

Starting from two and working up, dividing the target by found factors on the
way, any found factors will necessarily be prime: 4 will not be found because 2
would have already been found twice.

`candidates` is extracted as an argument so that the algorithm can be reused in
a more optimal way for future problems.

> primeFactorsFromCandidates candidates n = primeFactors' n n candidates
>   where
>     primeFactors' n n' candidates
>       | n' == 1       = []
>       | rem n' p == 0 = p:(primeFactors' n (n' `div` p) candidates)
>       | otherwise     = primeFactors' n n' (drop 1 candidates)
>       where p = head candidates

> naivePrimeFactors = primeFactorsFromCandidates [2..]

The solution is then the last factor found. Note that no explicit logic for
"primeness" is required.

> euler3 = last . naivePrimeFactors

> tests3 =
>   [ "#3 test"    ~: 29   ~=? euler3 13195
>   , "#3 problem" ~: 6857 ~=? euler3 600851475143
>   ]
