Problem 9
---------

 > A Pythagorean triplet is a set of three natural numbers, _a_ < _b_ < _c_,
 > for which _a_<sup>2</sup> + _b_<sup>2</sup> = _c_<sup>2</sup>.
 >
 > For example, 3<sup>2</sup> + 4<sup>2</sup> = 9 + 16 = 25 = 5<sup>2</sup>.
 >
 > There exists exactly one Pythagorean triplet for which _a_ + _b_ + _c_ =
 > 1000.  Find the product _abc_.

While this problem can be readily expressed as a list comprehension, it is too
inefficent to calculate a timely answer. By way of optimization, a list of
potential _c_ values is precomputed and stored in a lookup table so that all
`sqrt` calls can be avoided.

> squaresTo n = M.fromList [(x * x, x) | x <- [1..n]]

The subsequent algorithm takes advantage of the ability to pattern match in
list comprehensions to filter out non-matching candidates.

> euler9 n = [a * b * c | a      <- [1..n],
>                         b      <- [a..n],
>                         Just c <- [naturalSqrt $ a^2 + b^2],
>                         a + b + c == n
>            ]
>   where
>     squares       = squaresTo n
>     naturalSqrt x = M.lookup x squares

> tests9 =
>  [ "#9 given"   ~: [60]       ~=? euler9 12
>  , "#9 problem" ~: [31875000] ~=? euler9 1000
>  ]

