Problem 7
---------

 > By listing the first six prime numbers: 2, 3, 5, 7, 11, and 13, we can see
 that the 6<sup>th</sup> prime is 13.
 >
 > What is the 10,001<sup>st</sup> prime number?

Having already read the [Haskell wiki page on prime
generation][haskell-wiki-primes] a few times, I cheated and nabbed an algorithm
with a good trade-off between readability and efficiency ("Optimal trial
divison").

It works by dividing each new candidate number by every prime generated so far
that is less than the square root of the number. If none divide evenly into the
number, then the number is prime. Non-prime divisors do not need to be checked
since they themselves would have had a prime factor which has already been
tested.

[haskell-wiki-primes]: http://www.haskell.org/haskellwiki/Prime_numbers

> coprime factors n =
>   foldr (\p r -> p*p > n || (rem n p /= 0 && r)) True factors

> primes = 2 : 3 : filter (coprime $ tail primes) [5,7..]

> euler7 x = head $ drop (x - 1) primes

> tests7 =
>   [ "#7 given"   ~: 13     ~=? euler7 6
>   , "#7 problem" ~: 104743 ~=? euler7 10001
>   ]
