Problem 26
----------

 > A unit fraction contains 1 in the numerator. The decimal representation of
 > some unit fractions are given:
 >
 > 1/2 = 0.5<br />
 > 1/6 = 0.1(6)<br />
 > 1/7 = 0.(142857)<br />
 > 1/8 = 0.125
 >
 > Where 0.1(6) means 0.166666..., and has a 1-digit recurring cycle. It can be
 > seen that 1/7 has a 6-digit recurring cycle.
 >
 > Find the value of |d < 1000| for which |1/d| contains the longest recurring
 > cycle in its decimal fraction part.

A naive approach long divides |1.000...| by |d| keeping track of intermediate
results at each step. If a result is calculated that has been seen before, this
indicates a cycle and the length is the number of steps since the value was
seen. If zero is reached, the result is not cyclic.

The algorithm looks scary, but models the exact process used to long divide
with a pen and paper.

> repetendLength 0 = 0
> repetendLength x = f x (((1 `div` x) + 1) * 10) []
>   where
>     f x a as
>       | a' == 0      = 0
>       | a' `elem` as = length $ dropWhile (/= a) as
>       | otherwise    = (f x a' (a':as))
>         where
>           a' = longDivideStep x a
>     longDivideStep x a = (a - b) * 10
>       where
>         b = (a `div` x) * x

`maxIndex` from problem 16 is reused to extract the solution.

> euler26 = maxIndex . map repetendLength . enumFromTo 0

> tests26 =
>   [ "#26 given"   ~: 7   ~=? euler26 10
>   , "#26 problem" ~: 983 ~=? euler26 1000
>   ]
