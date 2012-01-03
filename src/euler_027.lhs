Problem 27
----------

 > Considering quadratics of the form:
 >
 > |n² + an + b|, where both |a| and |b| are between -1000 and 1000.
 >
 > Find the product of the coefficients, |a| and |b|, for the quadratic
 > expression that produces the maximum number of primes for consecutive values
 > of |n|, starting with |n = 0|.

The `primes` generator from problem 7 is used. Note that negative numbers are
not considered prime.

> isPrime x
>   | x < 2     = False
>   | otherwise = coprime primes x

For the equation to be prime when |n = 0|, |b| must be prime. For |n > 0|, |a|
must be odd.  If it was even, then all odd values of |n| would give an even
result: |n * n| would be odd, |n * a| even, and |b| is odd, the sum of which is
even and cannot be prime. In this case, the maximum length of a chain could
only ever be one, which is not going to be the answer.

> euler27 x = snd $ maximum [(f a b, a*b) | a <- [-x,-x+2..x],
>                                           b <- takeWhile (<= x) primes]
>   where
>     f a b = length $ takeWhile (isPrime . quadratic) [0..]
>       where
>         quadratic n = n*n + a*n + b

> tests27 =
>   [ "#27 problem" ~: -59231 ~=? euler27 999
>   ]
