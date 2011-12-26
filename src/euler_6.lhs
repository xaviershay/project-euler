Problem 6
---------

 > The sum of the squares of the first ten natural numbers is:
 >
 > 1<sup>2</sup> + 2<sup>2</sup> + ... + 10<sup>2</sup> = 385
 >
 > The square of the sum of the first ten natural numbers is:
 >
 > (1 + 2 + ... + 10)^2 = 55<sup>2</sup> = 3025
 >
 > The difference between the two is 3025 - 385 = 2640. Find the difference
 > between the sum of the squares of the first one hundred
 natural numbers and the square of the sum.

The problem translates naturally into code.

> euler6 n = (sum r)^2 - (sum $ map (^ 2) r)
>   where
>     r = [1..n]

> tests6 =
>   [ "#6 given"   ~: 2640     ~=? euler6 10
>   , "#6 problem" ~: 25164150 ~=? euler6 100
>   ]

There is alternative algebraic solution that relies on knowing that the sum of
the first `n` natural numbers is `n(n+1)/2` and that the sum of the first `n`
squares is `n(n+1)(2n+1)/6`. These are both easy to prove by induction, but I
wasn't able to derive them myself.
