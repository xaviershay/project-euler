Problem 21
----------

 > Let |d(n)| be defined as the sum of proper divisors of |n| (numbers less
 > than |n| which divide evenly into |n|).
 > If |d(a) = b| and |d(b) = a|, where |a != b|, then |a| and |b| are an
 > amicable pair and each of |a| and |b| are called amicable numbers.
 > 
 > For example, the proper divisors of 220 are 1, 2, 4, 5, 10, 11, 20, 22, 44,
 > 55 and 110; therefore d(220) = 284. The proper divisors of 284 are 1, 2, 4,
 > 71 and 142; so d(284) = 220.
 > 
 > Evaluate the sum of all the amicable numbers under 10000.

A function for calculating prime factors was formulated in problem 12.
Multiplying out all combinations of these factors gives all possible divisors.

> divisors = map product . foldl combinations [[]] . (group . primeFactors)
>   where
>     combinations xs ys = map concat [[x, y] | x <- xs, y <- tails ys]

The `divisors` function is guaranteed to always place |n| at the top of the
list, since `tails` returns the largest sublist first.

> properDivisors = tail . divisors

A special case is required for 1, since it has no proper divisors.

> amiacable 1 = False
> amiacable n = b == n && a /= b
>   where a = d n
>         b = d a
>         d = sum . properDivisors

> euler21 n = sum $ filter amiacable [1..n-1]

> tests21 =
>  [ "#21 problem" ~: 31626 ~=? euler21 10000
>  ]
