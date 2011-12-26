Problem 3
---------

 > The prime factors of 13195 are 5, 7, 13 and 29.

 > What is the largest prime factor of the number 600851475143?

If we start from 2 and work up, dividing the target by found factors as we go,
then any factors we find will necessarily be prime: the factor "4" cannot be
found because we would have already found the factor "2" twice.

With this fact, we can write a solution without any explicit check for
"primeness" that simply accumulates factors until we have reached the target.

> primeFactors n n' p
>   | n' == 1       = []
>   | rem n' p == 0 = p:(primeFactors n (n' `div` p) p)
>   | otherwise     = primeFactors n n' (p + 1)

> eulerThree x = last $ primeFactors x x 2

> testsThree =
>   [ "#3 test"    ~: 29   ~=? eulerThree 13195
>   , "#3 problem" ~: 6857 ~=? eulerThree 600851475143
>   ]
