Problem 23
----------

 > A number n is called deficient if the sum of its proper divisors is less
 > than n and it is called abundant if this sum exceeds n.
 >
 > As 12 is the smallest abundant number, 1 + 2 + 3 + 4 + 6 = 16, the smallest
 > number that can be written as the sum of two abundant numbers is 24. By
 > mathematical analysis, it can be shown that all integers greater than 28123
 > can be written as the sum of two abundant numbers.
 >
 > Find the sum of all the positive integers which cannot be written as the sum
 > of two abundant numbers.

A function to testing abundance of a number can be built from the
`properDivisors` function defined in problem 21.

> abundant 0 = False
> abundant y = sum (properDivisors y) > y

Rather than enumerating all pairs of abundants that could potentially sum to
|n|, it is easier and cheaper to enumerate all pairs of numbers that sum to |n|
and check whether they are abundant.

> sumOf2 f n = or [f x && f (n-x) | x <- [0..quot n 2]]

> euler23 bound = sum $ filter (not . sumOf2 abundant') [1..bound]
>   where

Memoization is desirable on `abundant` because it is an expensive function, and
will be called many times with the same input from a small domain.

>     abundant' = Memo.arrayRange(0, bound) abundant

> tests23 =
>   [ "#23 problem" ~: 4179871 ~=? euler23 28123
>   ]
