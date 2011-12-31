Problem 9
---------

 > A Pythagorean triplet is a set of three natural numbers, |a < b < c|,
 > for which |a^2 + b^2 = c^2|.
 >
 > For example, |3^2 + 4^2 = 9 + 16 = 25 = 5^2|.
 >
 > There exists exactly one Pythagorean triplet for which |a + b + c = 1000|.
 > Find the product |abc|.

Using a brute force method, the inner loop is over values of _b_. It therefore
makes sense to optimize that loop by bounding its range as much as possible.
The lower bound is obvious since |a < b|. A naive upper bound is
|1000 - a - a|, since |b > a|, |c > a|, and the sum of all three must equal
1000. However, considering also that |c > b| allows us to further eliminate
the top half of the range.

> maxB n a = (n-a) `div` 2

> euler9 n = head [a*b*c | a <- [1..n],
>                          b <- [a+1..maxB n a],
>                          let c = n - b - a,
>                          a * a + b * b == c * c
>                 ]

> tests9 =
>  [ "#9 given"   ~: 60       ~=? euler9 12
>  , "#9 problem" ~: 31875000 ~=? euler9 1000
>  ]

For a brute force method that naturally maps to the problem description this
solution is not bad. Substitution and rearranging of the equations can lead to
better lower and upper bounds for the search space, but this is merely a
refinement of the same algorithm. There is a more elegant algorithmic
approach.

[Euclid's formula][euclid-wiki] states that for all Pythagorean triples the
following hold true where _m_ and _n_ are positive integers:

) a = m^2 - n^2
) b = 2mn
) c = m^2 + n^2

This allows the problem equation to be simplified radically.

) (m^2 - n^2) + 2mn + (m^2 + n^2) = 1000
) m^2 + mn = 500
) m(m + n) = 500

A solution can then be found by finding two matching candidates from the
factors of 500, in this case |m = 20, n = 5|.

[euclid-wiki]: http://en.wikipedia.org/wiki/Pythagorean_triple#Generating_a_triple
