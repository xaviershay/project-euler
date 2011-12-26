Problem 6
---------

 > The sum of the squares of the first ten natural numbers is:
 >
 > |1^2 + 2^2 + ... + 10^2 = 385|
 >
 > The square of the sum of the first ten natural numbers is:
 >
 > |(1 + 2 + ... + 10)^2 = 55^2 = 3025|
 >
 > The difference between the two is 3025 - 385 = 2640. Find the difference
 > between the sum of the squares of the first one hundred
 natural numbers and the square of the sum.

The problem translates naturally into code.

> euler6 n = (sum r)^2 - (sum . map (^ 2) $ r)
>   where
>     r = [1..n]

> tests6 =
>   [ "#6 given"   ~: 2640     ~=? euler6 10
>   , "#6 problem" ~: 25164150 ~=? euler6 100
>   ]

There is alternative algebraic solution that relies on knowing that the sum of
the first _n_ natural numbers is _n_(_n_+1)/2 and that the sum of the first _n_
squares is _n_(_n_+1)(2<i>n</i>+1)/6. These are both easy to prove by
induction, but I wasn't able to derive them myself.
