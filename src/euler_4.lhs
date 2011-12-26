Problem 4
---------

 > A palindromic number reads the same both ways. The largest palindrome made
 > from the product of two 2-digit numbers is 9009 = 91 99.

 > Find the largest palindrome made from the product of two 3-digit numbers.

The input set is relatively small, so it would suffice to generate a list of
all possible numbers and filter them. This can generate a solution on my
machine in approximately two seconds.

A solution with more finesse is possible.

It is know that the answer will be six digits long (maximum length of two
3-digit numbers multiplied), and will be of the form:

      100000a + 10000b + 1000c + 100c + 10b + a
    = 100001a + 10010b + 1100c
    = 11(9091a + 910b + 110c)

This tells us that the answer must be divisible by 11, which allows the input
set to be trimmed considerably, yielding an order of magnitude speed up.

Intuitively, the maximum palindrome will be the result of two digits in the
nine hundred range, which allows us to scope the search space even further.
While this may be presumptious, if no solution is found it is easy enough to
drop the lower bound.

> palindrome x = x' == reverse x' where x' = show x

> eulerFour r = maximum $ [x * y | x <- r, y <- r', palindrome $ x * y]
>   where
>     r' = [x | x <- r, rem x 11 == 0]

> testsFour =
>   [ "#4 test"    ~: 9009   ~=? eulerFour [10..99]
>   , "#4 problem" ~: 906609 ~=? eulerFour [900..999]
>   ]

