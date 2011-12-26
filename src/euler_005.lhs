Problem 5
---------

 > 2520 is the smallest number that can be divided by each of the numbers from
 1 to 10 without any remainder.
 >
 > What is the smallest positive number that is evenly divisible by all of the
 numbers from 1 to 20?

Using the built-in `lcm` function is arguably cheating, but as the
prime-factoring basis of the algorithm has already be written in problem three,
I feel it is allowable.

> euler5 n = foldl1 lcm [1..n]

> tests5 =
>   [ "#5 given"   ~: 2520      ~=? euler5 10
>   , "#5 problem" ~: 232792560 ~=? euler5 20
>   ]
