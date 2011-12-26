Problem 4
---------

 > A palindromic number reads the same both ways. The largest palindrome made
 > from the product of two 2-digit numbers is<br />91 × 99 = 9009.
 >
 > Find the largest palindrome made from the product of two 3-digit numbers.

The easiest palindrome check is a string comparison between the number and its
reversed form.

> palindrome x = let x' = show x in x' == reverse x'

Since the input set is relatively small, it would suffice to generate a list of
all possible numbers and filter them. This can generate a solution on my
machine in approximately two seconds. The search space can be reduced
dramatically, however, with two techniques.

It is known that the answer will be six digits long (maximum length of two
3-digit numbers multiplied), and will be of the form:

) = 100000a + 10000b + 1000c + 100c + 10b + a
) = 100001a + 10010b + 1100c
) = 11(9091a + 910b + 110c)

This informs us that the answer must be divisible by 11, which allows the input
set to be trimmed considerably, yielding an order of magnitude speed up.

Intuitively, the answer will be the product of two digits greater than nine
hundred, which allows us to scope the search space even further.  While this
may be presumptious, if no solution is found it is easy enough to drop the
lower bound.

> euler4 r = maximum palindromes
>   where
>     palindromes = [x * y | x <- r, y <- ys, palindrome $ x * y]
>     ys          = [y | y <- r, rem y 11 == 0]

> tests4 =
>   [ "#4 test"    ~: 9009   ~=? euler4 [90..99]
>   , "#4 problem" ~: 906609 ~=? euler4 [900..999]
>   ]

