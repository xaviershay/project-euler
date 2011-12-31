
Project Euler
=============

  > Project Euler is a series of challenging mathematical/computer programming
  problems that will require more than just mathematical insights to solve.
  Although mathematics will help you arrive at elegant and efficient methods,
  the use of a computer and programming skills will be required to solve most
  problems. -- [Project Euler](http://projecteuler.net)

Follows is my attempt at the problems. I use Haskell and mathematics, two
subjects in which I am a novice. In writing about my solutions and discoveries,
I hope to present a gentle introduction to both.

I do presume a basic understanding of Haskell syntax, but not in any of the
algorithmic techniques. Each solution should be comprehensible without former
exposure to the problem. If you are unfamiliar with Haskell, you may still be
able to follow along as many of the solutions are quite expressive ---
hopefully this will pique your interest in the language!

Building
--------

This document is written in Literate Haskell, meaning it is executable as-is
with `ghc` with the addition of two external packages. The easiest way to
obtain them is via `cabal`. Their use is described later when they are
imported.

    cabal install split data-memocombinators

It is prudent to enable compiler optimizations since some problems
require a lot of processing, though it does not currently speed them up
considerably.

    wget http://xaviershay.github.com/project-euler/euler.lhs
    ghc --make -O2 euler.lhs
    ./euler

Alternatively, the [source repository][source] can be used. This allows running of
individual problems, and the creation of this formatted HTML.

    git clone git@github.com:xaviershay/project-euler.git
    cd project-euler

    bin/run 1   # Run only problem 1
    ./build.sh  # Build full `.lhs` and `.html` files

[source]: https://github.com/xaviershay/project-euler

Preamble
--------

All imports are required to be at the top of the source file, so they are
presented here and not duplicated in the problems for which they are
specifically required.

Both sample input and expected answers (after they have been solved) will be
expressed as HUnit tests below each solution.

\begin{code}
import Test.HUnit
\end{code}

Importing the suite of `List` functions is non-controversial in a language that
specifically excels at list processing.

\begin{code}
import List
import Data.List
\end{code}

In addition to the standard list packages, a common external package is used
for basic string handling, primarly for parsing problem input.

\begin{code}
import Data.List.Split
\end{code}

In certain cases, the run-time characteristics of a list are not performant
enough to provide a timely solution. In theses cases where constant-time random
access is required, an array will be used instead.

\begin{code}
import Array
\end{code}

Simalarly, the standard generic math functions are not fast enough for some
tight inner loops. `Bits` gives access to bit shifting functions, useful in
particular for fast divide by two using `shiftR`.

\begin{code}
import Data.Bits
\end{code}

The `Char` module is included for conversion functions handy for dealing with
different input and output formats of the problems, specifically `digitToInt`
to convert strings to integers.

\begin{code}
import Char
\end{code}

Many solutions make heavy use of recursion, but Haskell leaves memoization as
an option to the programmer, optimizing for smaller memory use rather than
running time. As such, a package is used to provide easy memoization of
arbitrary functions.

\begin{code}
import qualified Data.MemoCombinators as Memo
\end{code}

Date functions are included for problem 19.

\begin{code}
import Data.Time.Calendar
import Data.Time.Calendar.OrdinalDate
\end{code}

Searching data structures is much easier using functions from `Maybe` such as
`fromJust`.

\begin{code}
import Data.Maybe
\end{code}

A helper function similar to `digitToInt` for use in parsing input. This is
extracted to a function primarily so a type signature can be applied to `read`,
so it knows what type to convert to.

\begin{code}
stringToInt :: String -> Int
stringToInt = read
\end{code}

With those out of the way, on to the problems!

Problem 1
---------

  > If we list all the natural numbers below 10 that are multiples of 3 or 5,
  > we get 3, 5, 6 and 9. The sum of these multiples is 23.
  >
  > Find the sum of all the multiples of 3 or 5 below 1000.

Haskell allows an expressive solution to this problem. Removing the sum of the
duplicate multiples afterwards is more efficient than trying to remove them
before summing, as no comparisons or branches are required.

\begin{code}
euler1 max = sumMultiples 3 + sumMultiples 5 - sumMultiples (3*5)
 where
   sumMultiples x = sum [x,x*2..max-1]
\end{code}

\begin{code}
tests1 =
  [ "#1 given"   ~: 23     ~=? euler1 10
  , "#1 problem" ~: 233168 ~=? euler1 1000
  ]
\end{code}

Problem 2
---------

 > Each new term in the Fibonacci sequence is generated by adding the previous
 two terms. By starting with 1 and 2, the first 10 terms will be:
 >
 > 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, ...
 >
 > By considering the terms in the Fibonacci sequence whose values do not
 exceed four million, find the sum of the even-valued terms.

Start by defining an infinite sequence to generate Fibonacci values, made
possible in Haskell by lazy evaluation. In many languages, this definition
would never terminate.

\begin{code}
fibonacci = seq 0 1 where seq x y = x+y:seq y (x+y)
\end{code}

Only as many values as are required will be generated.

\begin{code}
euler2 n = sum . filter even . takeWhile (<= n) $ fibonacci
\end{code}

\begin{code}
tests2 =
  [ "#2 test"    ~: 44      ~=? euler2 40
  , "#2 problem" ~: 4613732 ~=? euler2 4000000
  ]
\end{code}

Problem 3
---------

 > The prime factors of 13195 are 5, 7, 13 and 29.
 >
 > What is the largest prime factor of the number 600851475143?

Starting from two and working up, dividing the target by found factors on the
way, any found factors will necessarily be prime: 4 will not be found because 2
would have already been found twice.

`candidates` is extracted as an argument so that the algorithm can be reused in
a more optimal way for future problems.

\begin{code}
primeFactorsFromCandidates candidates n = primeFactors' n n candidates
  where
    primeFactors' n n' candidates
      | n' == 1       = []
      | rem n' p == 0 = p:(primeFactors' n (n' `div` p) candidates)
      | otherwise     = primeFactors' n n' (drop 1 candidates)
      where p = head candidates
\end{code}

\begin{code}
naivePrimeFactors = primeFactorsFromCandidates [2..]
\end{code}

The solution is then the last factor found. Note that no explicit logic for
"primeness" is required.

\begin{code}
euler3 = last . naivePrimeFactors
\end{code}

\begin{code}
tests3 =
  [ "#3 test"    ~: 29   ~=? euler3 13195
  , "#3 problem" ~: 6857 ~=? euler3 600851475143
  ]
\end{code}

Problem 4
---------

 > A palindromic number reads the same both ways. The largest palindrome made
 > from the product of two 2-digit numbers is<br />91 × 99 = 9009.
 >
 > Find the largest palindrome made from the product of two 3-digit numbers.

The easiest palindrome check is a string comparison between the number and its
reversed form.

\begin{code}
palindrome x = let x' = show x in x' == reverse x'
\end{code}

Since the input set is relatively small, it would suffice to generate a list of
all possible numbers and filter them. The search space can be reduced
dramatically, however, with two techniques.

It is known that the answer will be six digits long (maximum length of two
3-digit numbers multiplied), and will be of the form:

 > = 100000<i>a</i> + 10000<i>b</i> + 1000<i>c</i> + 100<i>c</i> + 10<i>b</i> + <i>a</i><br />
 > = 100001<i>a</i> + 10010<i>b</i> + 1100<i>c</i><br />
 > = 11(9091<i>a</i> + 910<i>b</i> + 110<i>c</i>)<br />

This informs us that the answer must be divisible by 11, which allows the input
set to be trimmed considerably, yielding an order of magnitude speed up.

Intuitively, the answer will be the product of two digits greater than nine
hundred, which allows us to scope the search space even further.  While this
may be presumptuous, if no solution is found it is easy enough to drop the
lower bound.

\begin{code}
euler4 r = maximum palindromes
  where
    palindromes = [z | x <- r, y <- ys, let z = x * y, palindrome z]
    ys          = [y | y <- r, rem y 11 == 0]
\end{code}

\begin{code}
tests4 =
  [ "#4 test"    ~: 9009   ~=? euler4 [90..99]
  , "#4 problem" ~: 906609 ~=? euler4 [900..999]
  ]
\end{code}


Problem 5
---------

 > 2520 is the smallest number that can be divided by each of the numbers from
 1 to 10 without any remainder.
 >
 > What is the smallest positive number that is evenly divisible by all of the
 numbers from 1 to 20?

Using the built-in `lcm` function is arguably cheating, but the prime-factoring
basis of the algorithm has already be written in problem three.

\begin{code}
euler5 = foldl1 lcm . enumFromTo 1
\end{code}

\begin{code}
tests5 =
  [ "#5 given"   ~: 2520      ~=? euler5 10
  , "#5 problem" ~: 232792560 ~=? euler5 20
  ]
\end{code}

Problem 6
---------

 > The sum of the squares of the first ten natural numbers is:
 >
 > 1<sup>2</sup> + 2<sup>2</sup> + ... + 10<sup>2</sup> = 385
 >
 > The square of the sum of the first ten natural numbers is:
 >
 > (1 + 2 + ... + 10)<sup>2</sup> = 55<sup>2</sup> = 3025
 >
 > The difference between the two is 3025 - 385 = 2640. Find the difference
 > between the sum of the squares of the first one hundred
 natural numbers and the square of the sum.

The problem translates naturally into code.

\begin{code}
euler6 n = (sum r)^2 - (sum $ map (^ 2) r)
  where
    r = [1..n]
\end{code}

\begin{code}
tests6 =
  [ "#6 given"   ~: 2640     ~=? euler6 10
  , "#6 problem" ~: 25164150 ~=? euler6 100
  ]
\end{code}

There is alternative algebraic solution that relies on knowing that the sum of
the first <i>n</i> natural numbers is <i>n</i>(<i>n</i>+1)/2 and that the sum of the first <i>n</i>
squares is <i>n</i>(<i>n</i>+1)(2<i>n</i>+1)/6. Squaring both and taking the difference with
<i>n</i> = 100 yields the correct answer.

Problem 7
---------

 > By listing the first six prime numbers: 2, 3, 5, 7, 11, and 13, we can see
 that the 6<sup>th</sup> prime is 13.
 >
 > What is the 10,001<sup>st</sup> prime number?

Having already read the [Haskell wiki page on prime
generation][haskell-wiki-primes] a few times, I cheated and nabbed an algorithm
with a good trade-off between readability and efficiency ("Optimal trial
divison").

It works by dividing each new candidate number by every prime generated so far
that is less than the square root of the number. If none divide evenly into the
number, then the number is prime. Non-prime divisors do not need to be checked
since they themselves would have had a prime factor which has already been
tested.

[haskell-wiki-primes]: http://www.haskell.org/haskellwiki/Prime_numbers

\begin{code}
coprime factors n =
  foldr (\p r -> p*p > n || (rem n p /= 0 && r)) True factors
\end{code}

\begin{code}
primes = 2 : 3 : filter (coprime $ tail primes) [5,7..]
\end{code}

\begin{code}
euler7 x = head $ drop (x - 1) primes
\end{code}

\begin{code}
tests7 =
  [ "#7 given"   ~: 13     ~=? euler7 6
  , "#7 problem" ~: 104743 ~=? euler7 10001
  ]
\end{code}

Problem 8
---------

 > Find the greatest product of five consecutive digits in the 1000-digit number
given below.

\begin{code}
number =
  "73167176531330624919225119674426574742355349194934" ++
  "96983520312774506326239578318016984801869478851843" ++
  "85861560789112949495459501737958331952853208805511" ++
  "12540698747158523863050715693290963295227443043557" ++
  "66896648950445244523161731856403098711121722383113" ++
  "62229893423380308135336276614282806444486645238749" ++
  "30358907296290491560440772390713810515859307960866" ++
  "70172427121883998797908792274921901699720888093776" ++
  "65727333001053367881220235421809751254540594752243" ++
  "52584907711670556013604839586446706324415722155397" ++
  "53697817977846174064955149290862569321978468622482" ++
  "83972241375657056057490261407972968652414535100474" ++
  "82166370484403199890008895243450658541227588666881" ++
  "16427171479924442928230863465674813919123162824586" ++
  "17866458359124566529476545682848912883142607690042" ++
  "24219022671055626321111109370544217506941658960408" ++
  "07198403850962455444362981230987879927244284909188" ++
  "84580156166097919133875499200524063689912560717606" ++
  "05886116467109405077541002256983155200055935729725" ++
  "71636269561882670428252483600823257530420752963450"
\end{code}

My first solution used a cumbersome arrangement of `splitAt` calls to compute a
list of all consecutive numbers. I was then made aware of the `tails` function,
which when combined with `take 5` does essentially the same thing. It does
return sequences of less than five digits (from the end of the string), but
these do not need to be filtered since their product will never be more than
the same string with an extra preceeding digit.

\begin{code}
euler8 input = maximum . map (product . take 5) $ tails digits
  where
    digits = map digitToInt input
\end{code}

\begin{code}
tests8 =
  [ "#8 problem" ~: 40824 ~=? euler8 number
  ]
\end{code}

Problem 9
---------

 > A Pythagorean triplet is a set of three natural numbers, <i>a</i> < <i>b</i> < <i>c</i>,
 > for which <i>a</i><sup>2</sup> + <i>b</i><sup>2</sup> = <i>c</i><sup>2</sup>.
 >
 > For example, 3<sup>2</sup> + 4<sup>2</sup> = 9 + 16 = 25 = 5<sup>2</sup>.
 >
 > There exists exactly one Pythagorean triplet for which <i>a</i> + <i>b</i> + <i>c</i> = 1000.
 > Find the product <i>abc</i>.

Using a brute force method, the inner loop is over values of _b_. It therefore
makes sense to optimize that loop by bounding its range as much as possible.
The lower bound is obvious since <i>a</i> < <i>b</i>. A naive upper bound is
1000 - <i>a</i> - <i>a</i>, since <i>b</i> > <i>a</i>, <i>c</i> > <i>a</i>, and the sum of all three must equal
1000. However, considering also that <i>c</i> > <i>b</i> allows us to further eliminate
the top half of the range.

\begin{code}
maxB n a = (n-a) `div` 2
\end{code}

\begin{code}
euler9 n = head [a*b*c | a <- [1..n],
                         b <- [a+1..maxB n a],
                         let c = n - b - a,
                         a * a + b * b == c * c
                ]
\end{code}

\begin{code}
tests9 =
 [ "#9 given"   ~: 60       ~=? euler9 12
 , "#9 problem" ~: 31875000 ~=? euler9 1000
 ]
\end{code}

For a brute force method that naturally maps to the problem description this
solution is not bad. Substitution and rearranging of the equations can lead to
better lower and upper bounds for the search space, but this is merely a
refinement of the same algorithm. There is a more elegant algorithmic
approach.

[Euclid's formula][euclid-wiki] states that for all Pythagorean triples the
following hold true where _m_ and _n_ are positive integers:

 > <i>a</i> = <i>m</i><sup>2</sup> - <i>n</i><sup>2</sup><br />
 > <i>b</i> = 2<i>mn</i><br />
 > <i>c</i> = <i>m</i><sup>2</sup> + <i>n</i><sup>2</sup><br />

This allows the problem equation to be simplified radically.

 > (<i>m</i><sup>2</sup> - <i>n</i><sup>2</sup>) + 2<i>mn</i> + (<i>m</i><sup>2</sup> + <i>n</i><sup>2</sup>) = 1000<br />
 > <i>m</i><sup>2</sup> + <i>mn</i> = 500<br />
 > <i>m</i>(<i>m</i> + <i>n</i>) = 500<br />

A solution can then be found by finding two matching candidates from the
factors of 500, in this case <i>m</i> = 20, <i>n</i> = 5.

[euclid-wiki]: http://en.wikipedia.org/wiki/Pythagorean_triple#Generating_a_triple

Problem 10
----------

 > The sum of the primes below 10 is 2 + 3 + 5 + 7 = 17.
 >
 > Find the sum of all the primes below two million.

Re-uses the `primes` function defined in problem seven. Takes a few seconds,
but gets the solution in the end.

\begin{code}
euler10 n = sum $ takeWhile (< n) primes
\end{code}

\begin{code}
tests10 =
  [ "#10 given"   ~: 17           ~=? euler10 10
  , "#10 problem" ~: 142913828922 ~=? euler10 2000000
  ]
\end{code}

Problem 11
----------

 > In the 20 × 20 grid below, what is the greatest product of four adjacent
 > numbers in a straight line in any direction (up, down, left, right, or
 > diagonally)?

\begin{code}
grid11 =
  "08 02 22 97 38 15 00 40 00 75 04 05 07 78 52 12 50 77 91 08 " ++
  "49 49 99 40 17 81 18 57 60 87 17 40 98 43 69 48 04 56 62 00 " ++
  "81 49 31 73 55 79 14 29 93 71 40 67 53 88 30 03 49 13 36 65 " ++
  "52 70 95 23 04 60 11 42 69 24 68 56 01 32 56 71 37 02 36 91 " ++
  "22 31 16 71 51 67 63 89 41 92 36 54 22 40 40 28 66 33 13 80 " ++
  "24 47 32 60 99 03 45 02 44 75 33 53 78 36 84 20 35 17 12 50 " ++
  "32 98 81 28 64 23 67 10 26 38 40 67 59 54 70 66 18 38 64 70 " ++
  "67 26 20 68 02 62 12 20 95 63 94 39 63 08 40 91 66 49 94 21 " ++
  "24 55 58 05 66 73 99 26 97 17 78 78 96 83 14 88 34 89 63 72 " ++
  "21 36 23 09 75 00 76 44 20 45 35 14 00 61 33 97 34 31 33 95 " ++
  "78 17 53 28 22 75 31 67 15 94 03 80 04 62 16 14 09 53 56 92 " ++
  "16 39 05 42 96 35 31 47 55 58 88 24 00 17 54 24 36 29 85 57 " ++
  "86 56 00 48 35 71 89 07 05 44 44 37 44 60 21 58 51 54 17 58 " ++
  "19 80 81 68 05 94 47 69 28 73 92 13 86 52 17 77 04 89 55 40 " ++
  "04 52 08 83 97 35 99 16 07 97 57 32 16 26 26 79 33 27 98 66 " ++
  "88 36 68 87 57 62 20 72 03 46 33 67 46 55 12 32 63 93 53 69 " ++
  "04 42 16 73 38 25 39 11 24 94 72 18 08 46 29 32 40 62 76 36 " ++
  "20 69 36 41 72 30 23 88 34 62 99 69 82 67 59 85 74 04 36 16 " ++
  "20 73 35 29 78 31 90 01 74 31 49 71 48 86 81 16 23 57 05 54 " ++
  "01 70 54 71 83 51 54 69 16 92 33 48 61 43 52 01 89 19 67 48 "
\end{code}

There is no shortcut method to calculating the greatest product for this
problem, so a search is in order. The difficulty is in enumerating all of the
candidates. If you are not familiar with [pointfree style][hwiki-pointfree],
this solution is going to be a baptism of fire!

[hwiki-pointfree]:http://www.haskell.org/haskellwiki/Pointfree

The solution can easily be expressed as high level concepts, with the details
to be filled in below.

\begin{code}
euler11 w l = maximum . map product . candidates
 where
   candidates input = concatMap (adjacent (parse input)) $ directions
\end{code}

The algorithm provides separate methods to enumerate candidates for each of the
four directions. The other four directions are equivalent and do not need to be
considered.

\begin{code}
   directions = [east, southEast, south, southWest]
\end{code}

`adjacent` will calculate all possible sublists of the grid that can be formed
by starting at each cell and walking `l` cells in the given direction.

\begin{code}
   adjacent grid direction = concat . direction $ grid
\end{code}

East is the simplest direction. For each row in the grid, generate the tails
and take the first four of each. As in problem eight, candidates less than the
required length do not need to be filtered since they cannot possibly provide
an incorrect answer, and add only a neglible amount to the running time.

\begin{code}
   east = map (map (take l) . tails)
\end{code}

South is exactly the same logic as east, except with rows and columns switched.

\begin{code}
   south = east . transpose
\end{code}

A cute functional trick is used to extract the diagonals from a grid. `zipWith`
shears off the south-west half of the grid, leaving the columns of the
resulting half-grid representing the diagonals. `transpose` makes them into the
rows.

\begin{code}
   diagonals = map (take l) . transpose . zipWith drop [0..]
\end{code}

This is not sufficient however. Diagonals from the excluded south-west half
still need to be included as candidates! Further, only the first four of each
diagonal is currently being included. To compensate, a series of sub-grids is
created each with the top row of the last grid dropped, and diagonals are
generated for each of them.  Note that `tails` here is being applied to the
grid itself, not the rows of the grid as it was above.

\begin{code}
   southEast = map diagonals . tails
\end{code}

South-west has a similar relationship to south-east as south does to east.

\begin{code}
   southWest = southEast . map reverse
\end{code}

Parsing is the least interesting part of the solution, so has been relegated to
the bottom of the definition.

\begin{code}
   parse = (chunk w) . map stringToInt . (chunk 3)
\end{code}

\begin{code}
tests11 =
  [ "#11 test" ~: 70600674 ~=? euler11 20 4 grid11
  ]
\end{code}

Problem 12
----------

 > The sequence of triangle numbers is generated by adding the natural numbers.
 > So the seventh triangle number would be 1 + 2 + 3 + 4 + 5 + 6 + 7 = 28. The
 > first ten terms would be:
 >
 > 1, 3, 6, 10, 15, 21, 28, 36, 45, 55, ...
 >
 > The factors of the seventh triangle number 28 are:
 >
 > 1, 2, 4, 7, 14, 28
 >
 > This is the first triangle number to have over five divisors. What is the
 > value of the first triangle number to have over five hundred divisors?

An infinite sequence of triangle numbers is a delight to define in Haskell.
This is an alternative approach than that used for the Fibonacci sequence in
problem two, though they are mostly interchangeable.

\begin{code}
triangles = 1:zipWith (+) triangles [2..]
\end{code}

The prime factorization algorithm from problem three is reused here, though
rather than naively testing all numbers it uses the `primes` generator from
problem seven to reduce the number of tests required.

\begin{code}
primeFactors = primeFactorsFromCandidates primes
\end{code}

The number of divisors a number has can be calculated by multiplying the powers
of each prime factor plus one. For example, the prime factors of 28 are
2<sup>2</sup> + 7<sup>1</sup> therefore the number of divisors is (2+1) × (1+1) = 6.

\begin{code}
numFactors = foldl1 (*) . map ((+ 1) . length) . group . primeFactors
\end{code}

A reasonable lower bound such as 500 × 500 could be specified for the
triangle numbers, but it makes a negligible difference to the running time of
the search. The number 1 is excluded since it has no prime factors.

\begin{code}
euler12 n = head [x | x <- drop 1 triangles, numFactors x > n]
\end{code}

\begin{code}
tests12 =
  [ "#12 given"    ~: 28       ~=? euler12 5
  , "#12 problems" ~: 76576500 ~=? euler12 500
  ]
\end{code}

Problem 13
----------

 > Work out the first ten digits of the sum of the following one-hundred
 > 50-digit numbers.

\begin{code}
numbers13 =
 [37107287533902102798797998220837590246510135740250
 ,46376937677490009712648124896970078050417018260538
 ,74324986199524741059474233309513058123726617309629
 ,91942213363574161572522430563301811072406154908250
 ,23067588207539346171171980310421047513778063246676
 ,89261670696623633820136378418383684178734361726757
 ,28112879812849979408065481931592621691275889832738
 ,44274228917432520321923589422876796487670272189318
 ,47451445736001306439091167216856844588711603153276
 ,70386486105843025439939619828917593665686757934951
 ,62176457141856560629502157223196586755079324193331
 ,64906352462741904929101432445813822663347944758178
 ,92575867718337217661963751590579239728245598838407
 ,58203565325359399008402633568948830189458628227828
 ,80181199384826282014278194139940567587151170094390
 ,35398664372827112653829987240784473053190104293586
 ,86515506006295864861532075273371959191420517255829
 ,71693888707715466499115593487603532921714970056938
 ,54370070576826684624621495650076471787294438377604
 ,53282654108756828443191190634694037855217779295145
 ,36123272525000296071075082563815656710885258350721
 ,45876576172410976447339110607218265236877223636045
 ,17423706905851860660448207621209813287860733969412
 ,81142660418086830619328460811191061556940512689692
 ,51934325451728388641918047049293215058642563049483
 ,62467221648435076201727918039944693004732956340691
 ,15732444386908125794514089057706229429197107928209
 ,55037687525678773091862540744969844508330393682126
 ,18336384825330154686196124348767681297534375946515
 ,80386287592878490201521685554828717201219257766954
 ,78182833757993103614740356856449095527097864797581
 ,16726320100436897842553539920931837441497806860984
 ,48403098129077791799088218795327364475675590848030
 ,87086987551392711854517078544161852424320693150332
 ,59959406895756536782107074926966537676326235447210
 ,69793950679652694742597709739166693763042633987085
 ,41052684708299085211399427365734116182760315001271
 ,65378607361501080857009149939512557028198746004375
 ,35829035317434717326932123578154982629742552737307
 ,94953759765105305946966067683156574377167401875275
 ,88902802571733229619176668713819931811048770190271
 ,25267680276078003013678680992525463401061632866526
 ,36270218540497705585629946580636237993140746255962
 ,24074486908231174977792365466257246923322810917141
 ,91430288197103288597806669760892938638285025333403
 ,34413065578016127815921815005561868836468420090470
 ,23053081172816430487623791969842487255036638784583
 ,11487696932154902810424020138335124462181441773470
 ,63783299490636259666498587618221225225512486764533
 ,67720186971698544312419572409913959008952310058822
 ,95548255300263520781532296796249481641953868218774
 ,76085327132285723110424803456124867697064507995236
 ,37774242535411291684276865538926205024910326572967
 ,23701913275725675285653248258265463092207058596522
 ,29798860272258331913126375147341994889534765745501
 ,18495701454879288984856827726077713721403798879715
 ,38298203783031473527721580348144513491373226651381
 ,34829543829199918180278916522431027392251122869539
 ,40957953066405232632538044100059654939159879593635
 ,29746152185502371307642255121183693803580388584903
 ,41698116222072977186158236678424689157993532961922
 ,62467957194401269043877107275048102390895523597457
 ,23189706772547915061505504953922979530901129967519
 ,86188088225875314529584099251203829009407770775672
 ,11306739708304724483816533873502340845647058077308
 ,82959174767140363198008187129011875491310547126581
 ,97623331044818386269515456334926366572897563400500
 ,42846280183517070527831839425882145521227251250327
 ,55121603546981200581762165212827652751691296897789
 ,32238195734329339946437501907836945765883352399886
 ,75506164965184775180738168837861091527357929701337
 ,62177842752192623401942399639168044983993173312731
 ,32924185707147349566916674687634660915035914677504
 ,99518671430235219628894890102423325116913619626622
 ,73267460800591547471830798392868535206946944540724
 ,76841822524674417161514036427982273348055556214818
 ,97142617910342598647204516893989422179826088076852
 ,87783646182799346313767754307809363333018982642090
 ,10848802521674670883215120185883543223812876952786
 ,71329612474782464538636993009049310363619763878039
 ,62184073572399794223406235393808339651327408011116
 ,66627891981488087797941876876144230030984490851411
 ,60661826293682836764744779239180335110989069790714
 ,85786944089552990653640447425576083659976645795096
 ,66024396409905389607120198219976047599490197230297
 ,64913982680032973156037120041377903785566085089252
 ,16730939319872750275468906903707539413042652315011
 ,94809377245048795150954100921645863754710598436791
 ,78639167021187492431995700641917969777599028300699
 ,15368713711936614952811305876380278410754449733078
 ,40789923115535562561142322423255033685442488917353
 ,44889911501440648020369068063960672322193204149535
 ,41503128880339536053299340368006977710650566631954
 ,81234880673210146739058568557934581403627822703280
 ,82616570773948327592232845941706525094512325230608
 ,22918802058777319719839450180888072429661980811197
 ,77158542502016545090413245809786882778948721859617
 ,72107838435069186155435662884062257473692284509516
 ,20849603980134001723930671666823555245252804609722
 ,53503534226472524250874054075591789781264330331690
 ]
\end{code}

There really is no trick to this. It is tempting to try summing only the first
11 digits of each number, and while that does work for this particular input it
is not a general solution, since additions from the remaining 39 digits can
cause carry overs that affect the result.

\begin{code}
euler13 = (take 10) . show . sum
\end{code}

\begin{code}
tests13 =
  [ "#13 problem" ~: "5537376230" ~=? euler13 numbers13
  ]
\end{code}

Problem 14
----------

 > The following iterative sequence is defined for the set of positive integers:
 >
 > <i>n</i> -> <i>n</i>/2 (<i>n</i> <i>is</i> <i>even</i>)<br />
 > <i>n</i> -> 3<i>n</i> + 1 (<i>n</i> <i>is</i> <i>odd</i>)
 >
 > Using the rule above and starting with 13, we generate the following
 > sequence:
 >
 > 13, 40, 20, 10, 5, 16, 8, 4, 2, 1
 >
 > It can be seen that this sequence contains 10 terms. Although it has not
 > been proved yet (Collatz Problem), it is thought that all starting numbers
 > finish at 1.
 >
 > Which starting number, under one million, produces the longest chain?
 >
 > Note that once the chain starts the terms are allowed to go above one
 > million.

A recursive function can be used to calculate the length of the collatz
sequence for a number. Memoization is critical here as it speeds up the
solution by an order of magnitude.

\begin{code}
collatz :: Integer -> Integer
collatz = Memo.arrayRange (1,1000000) collatz'
  where
    collatz' 1  = 1
    collatz' x
      | even x    = 1 + collatz (x `shiftR` 1)
      | otherwise = 1 + collatz (3 * x + 1)
\end{code}

Tuple comparison in Haskell is done using the first element, so `max (5,1)
(4,100)` will return `(5,1)`. This is taken advantage to find the maximum index
of a list by zipping the index of each element into the list (creating a list
of tuples), finding the maximum tuple (which will compare on the original
value), then returning the second element of that tuple.

The strict function `fold1' max` is used rather than `maximum` so that it
executes with a constant memory bound. See the Haskell wiki page on [stack
overflow][hwiki-stack-overflow] for more information.

[hwiki-stack-overflow]: http://www.haskell.org/haskellwiki/Stack_overflow

\begin{code}
maxIndex = snd . foldl1' max . (flip zip [0..])
\end{code}

The solution is a trivial combination of these two functions.

\begin{code}
euler14 n = (maxIndex lengths) + 1
  where
    lengths = map collatz [1..n-1]
\end{code}

\begin{code}
tests14 =
  [ "#14 given"   ~: 9      ~=? euler14 13
  , "#14 problem" ~: 837799 ~=? euler14 1000000
  ]
\end{code}

Problem 15
----------

 > Starting in the top left corner of a 2 × 2 grid, there are 6 routes
 > (without backtracking) to the bottom right corner.
 >
 > How many routes are there through a 20 × 20 grid?

Let the number of paths through a grid of <i>x</i> × <i>y</i> be a function <i>p</i>(<i>x</i>, <i>y</i>). For any
grid, there are only two immediate paths leading into the final corner.
Therefore, <i>p</i>(<i>x</i>, <i>y</i>) will be equal to <i>p</i>(<i>x</i>-1, <i>y</i>) + <i>p</i>(<i>x</i>, <i>y</i>-1), terminating at 1
whenever <i>x</i> or <i>y</i> is 0. In the case of a 2 × 2 grid:

 > = <i>p</i>(2, 2)<br />
 > = <i>p</i>(2, 1) + <i>p</i>(1, 2)<br />
 > = 2<i>p</i>(1, 1) + <i>p</i>(2, 0) + <i>p</i>(0, 2)<br />
 > = 2(<i>p</i>(0, 1) + <i>p</i>(1, 0)) + <i>p</i>(2, 0) + <i>p</i>(0, 2)<br />
 > = 2 × 2 + 1 + 1<br />
 > = 6<br />

As with the last problem, memoization is essential to allow this algorithm a
reasonable running time, though the extra speed up of an `arrayRange` is not
required. This is beneficial since the maximum input does not need to be hard
coded.

\begin{code}
gridPaths = Memo.memo2 Memo.integral Memo.integral f
  where
    f x 0 = 1
    f 0 x = 1
    f w h = (gridPaths (w-1) h) + (gridPaths w (h-1))
\end{code}

\begin{code}
euler15 n = gridPaths n n
\end{code}

\begin{code}
tests15 =
  [ "#15 given"   ~: 6            ~=? euler15 2
  , "#15 problem" ~: 137846528820 ~=? euler15 20
  ]
\end{code}

Another way of approaching the problem is to recognize that all routes must go
twenty steps left and twenty steps down, yielding a collection of forty
"moves". The total number of arrangements of moves is then 40!. This contains
duplicate paths however, since swapping two down moves results in the same
path. The possible arrangements for the down moves is is 20!, same for
left, so the total number of arrangements without duplicates is
40!/(20! × 20!).

This is a standard calculation in combinatorics known as a binomial
coefficient, or "n choose k" where <i>n</i> = 40 and <i>k</i> = 20.

Problem 16
----------

 > 2<sup>15</sup> = 32768 and the sum of its digits is 3 + 2 + 7 + 6 + 8 = 26.
 >
 > What is the sum of the digits of the number 2<sup>1000</sup>?

Does what is says on the packet.

\begin{code}
sumOfDigits = sum . map digitToInt . show
\end{code}

\begin{code}
euler16 = sumOfDigits . (^) 2
\end{code}

\begin{code}
tests16 =
  [ "#16 given"   ~: 26   ~=? euler16 15
  , "#16 problem" ~: 1366 ~=? euler16 1000
  ]
\end{code}

Problem 17
----------

 > If the numbers 1 to 5 are written out in words: one, two, three, four, five,
 > then there are 3 + 3 + 5 + 4 + 4 = 19 letters used in total.
 >
 > If all the numbers from 1 to 1000 (one thousand) inclusive were written out
 > in words, how many letters would be used?
 >
 > Do not count spaces or hyphens. For example, 342 (three hundred and
 > forty-two) contains 23 letters and 115 (one hundred and fifteen) contains 20
 > letters. The use of "and" when writing out numbers is in compliance with
 > British usage.

Some basic translations of numbers are required to bootstrap the algorithm.

\begin{code}
singles x = words !! (x - 1)
  where
    words =
      [ "one" , "two" , "three" , "four" , "five" , "six" , "seven" , "eight"
      , "nine" , "ten" , "eleven" , "twelve" , "thirteen" , "fourteen"
      , "fifteen" , "sixteen" , "seventeen" , "eighteen" , "nineteen" ]
tens x = words !! (x - 2)
  where
    words = [ "twenty" , "thirty" , "forty" , "fifty" , "sixty" , "seventy"
            , "eighty" , "ninety" , "hundred" ]
\end{code}


For numbers below 100, translating numbers to words is somewhat arbitary, but
the logic is not too cumbersome.

\begin{code}
formatBelow100 x
  | x < 20        = singles x
  | rem x 10 == 0 = formatTens x
  | otherwise     = formatTens x ++ " " ++ (singles $ rem x 10)
  where
    formatTens x = tens $ div x 10
\end{code}

For numbers greater than 100 the translation logic is much simpler and can be
coded inline. This data structure is the core of the algorithm, and it is
obvious how it could be extended to support millions, billions, and beyond.

\begin{code}
ranges = let f label x = (numberToWords x) ++ " " ++ label in
  [ (1, formatBelow100)
  , (10^2, f "hundred")
  , (10^3, f "thousand")
  , (10^6, (\x -> error "Number too large"))
  ]
\end{code}

Beautifying the output is not strictly necessary for the given problem, but
makes for a more useful general function.

\begin{code}
formatSentence [x]    = x
formatSentence [x, y] = x ++ " and " ++ y
formatSentence (x:xs) = x ++ ", " ++ formatSentence xs
\end{code}

The algorithm works backwards through the known ranges accumulating fragments
for each, before joining them together to make a sentence.

\begin{code}
numberToWords x = makeSentence $ foldr formatRange ([], x) ranges
  where
    makeSentence = formatSentence . reverse . fst
    formatRange (min, f) (a, remainder)
      | remainder >= min = (f major:a, minor)
      | otherwise        = (a, remainder)
      where
        (major, minor)
          | min == 0  = (remainder, 0)
          | otherwise = quotRem remainder min
\end{code}

For the solution to the problem, it is necessary to strip out spaces and
punctuation from the general algorithm.

\begin{code}
euler17 = sum . map (length . onlyAlpha . numberToWords) . enumFromTo 1
 where
   onlyAlpha = filter (flip elem ['a'..'z'])
\end{code}

\begin{code}
tests17 =
  [ "#17 given"   ~: 19    ~=? euler17 5
  , "#17 problem" ~: 21124 ~=? euler17 1000
  ]
\end{code}

Problem 18
----------

 > By starting at the top of the triangle below and moving to adjacent numbers
 > on the row below, the maximum total from top to bottom is 23.

\begin{code}
smallInput18 =
  "3 " ++
  "7 4 " ++
  "2 4 6 " ++
  "8 5 9 3 "
\end{code}

 > That is, 3 + 7 + 4 + 9 = 23.
 >
 > Find the maximum total from top to bottom of the larger triangle below.

\begin{code}
largeInput18 =
  "75 " ++
  "95 64 " ++
  "17 47 82 " ++
  "18 35 87 10 " ++
  "20 04 82 47 65 " ++
  "19 01 23 75 03 34 " ++
  "88 02 77 73 07 63 67 " ++
  "99 65 04 28 06 16 70 92 " ++
  "41 41 26 56 83 40 80 70 33 " ++
  "41 48 72 33 47 32 37 16 94 29 " ++
  "53 71 44 65 25 43 91 52 97 51 14 " ++
  "70 11 33 28 77 73 17 78 39 68 17 57 " ++
  "91 71 52 38 17 14 91 43 58 50 27 29 48 " ++
  "63 66 04 68 89 53 67 30 73 16 69 87 40 31 " ++
  "04 62 98 27 23 09 70 98 73 93 38 53 60 04 23 "
\end{code}

Starting at the bottom of the triangle, match the largest of each pair of
numbers to its parent. For the test input, this will be:

    [(9, 6), (9, 4), (8, 2)]

Summing the two gives the maximum total of this path, so it can be used to
replace the second bottom row. Continue folding the bottom row in until only
one row of one number remains.  This will be the maximum total.

\begin{code}
euler18 h w = head . foldl1' maxPath . parse h w
 where
   maxPath bs ts  = zipWith3 addMax ts bs (tail bs)
   addMax t b1 b2 = t + (max b1 b2)
\end{code}

To parse the input, read in as sequence integers then chunk it with a
descending width. To enable a nice functional style the input is reversed
before being chunked. This has the effect of mirroring the triangle, but this
has no bearing on the solution.

\begin{code}
   parse h w = triangleChunk h . reverse . map stringToInt . (chunk w)
\end{code}

\begin{code}
   triangleChunk 0 _ = []
   triangleChunk n x = take n x:triangleChunk (n-1) (drop n x)
\end{code}

\begin{code}
tests18 =
  [ "#18 given"   ~: 23   ~=? euler18 4 2 smallInput18
  , "#18 problem" ~: 1074 ~=? euler18 15 3 largeInput18
  ]
\end{code}

Problem 19
----------

 > How many Sundays fell on the first of the month during the twentieth century
 > (1 Jan 1901 to 31 Dec 2000)?

Define a data type `Month` that allows interation over all months in a range.
This is overkill for this problem, but allows a chance to investigate Haskell's
type system.

A `Month` is composed of a year and a month. 

\begin{code}
data Month = Month Integer Int
\end{code}

Provide a conversion to the built-in type `Day` that returns the first day of
the month.

\begin{code}
toDay (Month y m) = fromGregorian y m 1
\end{code}

For display, match the format of `Day` but with days truncated.

\begin{code}
instance Show Month where
  show (Month y m) = show y ++ "-" ++ show m
\end{code}

Map months to a contiguous range of integers. This is the minimal required
definition of `Enum` that will allow the use of `Month` in ranges.

\begin{code}
instance Enum Month where
  fromEnum (Month y m) = (fromInteger y) * 12 + m - 1
  toEnum x             = Month (toInteger y) (m + 1)
    where
      (y, m) = quotRem x 12
\end{code}

`sundayStartWeek` returns the day of the week as the second element of a tuple,
which is used to answer the problem.

\begin{code}
euler19 = length . filter ((== 0) . snd . sundayStartWeek . toDay)
\end{code}

\begin{code}
tests19 =
  [ "#19 problem" ~: 171 ~=? euler19 [Month 1901 1..Month 2000 12]
  ]
\end{code}

Problem 20
----------

 > <i>n</i>! means <i>n</i> × (<i>n</i> - 1) × ... × 3 × 2 × 1
 >
 > For example, 10! = 10 × 9 × ... × 3 × 2 × 1 = 3628800, and the sum of the
 > digits in the number 10! is 3 + 6 + 2 + 8 + 8 + 0 + 0 = 27.
 >
 > Find the sum of the digits in the number 100!

As with problem 16, this is trivial.

\begin{code}
factorial = product . enumFromTo 1
\end{code}

\begin{code}
euler20 = sumOfDigits . factorial
\end{code}

\begin{code}
tests20 =
 [ "#20 problem" ~: 648 ~=? euler20 100
 ]
\end{code}

Problem 21
----------

 > Let <i>d</i>(<i>n</i>) be defined as the sum of proper divisors of <i>n</i> (numbers less
 > than <i>n</i> which divide evenly into <i>n</i>).
 > If <i>d</i>(<i>a</i>) = <i>b</i> and <i>d</i>(<i>b</i>) = <i>a</i>, where <i>a</i> != <i>b</i>, then <i>a</i> and <i>b</i> are an
 > amicable pair and each of <i>a</i> and <i>b</i> are called amicable numbers.
 > 
 > For example, the proper divisors of 220 are 1, 2, 4, 5, 10, 11, 20, 22, 44,
 > 55 and 110; therefore d(220) = 284. The proper divisors of 284 are 1, 2, 4,
 > 71 and 142; so d(284) = 220.
 > 
 > Evaluate the sum of all the amicable numbers under 10000.

A function for calculating prime factors was formulated in problem 12.
Multiplying out all combinations of these factors gives all possible divisors.

\begin{code}
divisors = map product . foldl combinations [[]] . (group . primeFactors)
  where
    combinations xs ys = map concat [[x, y] | x <- xs, y <- tails ys]
\end{code}

The `divisors` function is guaranteed to always place <i>n</i> at the top of the
list, since `tails` returns the largest sublist first.

\begin{code}
properDivisors = tail . divisors
\end{code}

A special case is required for 1, since it has no proper divisors.

\begin{code}
amiacable 1 = False
amiacable n = b == n && a /= b
  where a = d n
        b = d a
        d = sum . properDivisors
\end{code}

\begin{code}
euler21 n = sum $ filter amiacable [1..n-1]
\end{code}

\begin{code}
tests21 =
 [ "#21 problem" ~: 31626 ~=? euler21 10000
 ]
\end{code}

Problem 22
----------

 > Using `names.txt`, a 46K text file containing over five-thousand first
 > names, begin by sorting it into alphabetical order. Then working out the
 > alphabetical value for each name, multiply this value by its alphabetical
 > position in the list to obtain a name score.
 >
 > For example, when the list is sorted into alphabetical order, COLIN, which
 > is worth 3 + 15 + 12 + 9 + 14 = 53, is the 938<sup>th</sup> name in the
 > list. So, COLIN would obtain a score of 938 × 53 = 49714.
 >
 > What is the total of all the name scores in the file?

The word scoring function takes advantage of all the names being uppercase A-Z,
though any different alphabet could be substituted easily. This is not the most
efficient algorithm since scoring a character is O(<i>n</i>), but is sufficient for
this problem. It could easily be improved by using a lookup table, or O(1) if
the ordinal values of the letters were used.

\begin{code}
scoreWord index word = index * sum (map scoreChar word)
  where
    alphabet    = ['A'..'Z']
    scoreChar x = fromJust (elemIndex x alphabet) + 1
\end{code}

\begin{code}
scoreArray = sum . zipWith scoreWord [1..] . sort
\end{code}

\begin{code}
euler22 = scoreArray . parse
  where
    parse = map (tail . init) . (splitOn ",")
\end{code}

This is the first problem to require input from an external file. Due to
Haskell's functional nature, this needs to be passed in from the external main
function.

\begin{code}
tests22 input =
  [ "#22 problem" ~: 871198282 ~=? euler22 input
  ]
\end{code}

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

\begin{code}
abundant 0 = False
abundant y = sum (properDivisors y) > y
\end{code}

Rather than enumerating all pairs of abundants that could potentially sum to
<i>n</i>, it is easier and cheaper to enumerate all pairs of numbers that sum to <i>n</i>
and check whether they are abundant.

\begin{code}
sumOf2 f n = or [f x && f (n-x) | x <- [0..quot n 2]]
\end{code}

\begin{code}
euler23 bound = sum $ filter (not . sumOf2 abundant') [1..bound]
  where
\end{code}

Memoization is desirable on `abundant` because it is an expensive function, and
will be called many times with the same input from a small domain.

\begin{code}
    abundant' = Memo.arrayRange(0, bound) abundant
\end{code}

\begin{code}
tests23 =
  [ "#23 problem" ~: 4179871 ~=? euler23 28123
  ]
\end{code}

Problem 24
----------

 > A permutation is an ordered arrangement of objects. For example, 3124 is one
 > possible permutation of the digits 1, 2, 3 and 4. If all of the permutations
 > are listed numerically or alphabetically, we call it lexicographic order.
 > The lexicographic permutations of 0, 1 and 2 are:
 >
 > 012, 021, 102, 120, 201, 210
 >
 > What is the millionth lexicographic permutation of the digits 0 to 9?

Haskell provides a built in `permutations` function, but it is not in lexical
order. List comprehensions can be used to build a new version.

\begin{code}
lexicalPermutations [] = [[]]
lexicalPermutations xs = [x:ys | x  <- xs,
                                 ys <- lexicalPermutations (delete x xs)]
\end{code}

There is a potential off-by-one error lurking here: the sixth permutation is at
index five in the list.

\begin{code}
euler24 range n = map intToDigit $ lexicalPermutations range !! (n-1)
\end{code}

\begin{code}
tests24 =
  [ "#24 given"   ~: "210"        ~=? euler24 [0..2] 6
  , "#24 problem" ~: "2783915460" ~=? euler24 [0..9] 1000000
  ]
\end{code}

Problem 25
----------

 > The Fibonacci sequence is defined by the recurrence relation:
 > 
 > F<sub>n</sub> = F<sub>n</sub>1 + F<sub>n</sub>2, where F<sub>1</sub> = 1 and
 > F<sub>2</sub> = 1.
 >
 > The 12<sup>th</sup> term, F<sub>12</sub>, is the first term to contain three
 > digits.  What is the first term in the Fibonacci sequence to contain 1000
 > digits?

The `fibonacci` method defined in problem 2 has a different starting index than
this problem requires, hence the prefixed digits.

\begin{code}
euler25 n = length $ takeWhile (< 10^(n-1)) (0:1:fibonacci)
\end{code}

\begin{code}
tests25 =
  [ "#25 given"   ~: 12   ~=? euler25 3
  , "#25 problem" ~: 4782 ~=? euler25 1000
  ]
\end{code}

Postamble
---------

There are over three hundred and fifty problems current on Project Euler, and I
have as yet tackled but a small sample of them here. In time, I hope to extend
this document further with more solutions. There is still plenty more Haskell
for me to learn. I haven't even started on monads!

As a final and closing convenience, a main function is provided to run all the
given test cases.

\begin{code}
main = do
  input22 <- readFile "data/names.txt"
  runTestTT $ TestList ( tests1
                      ++ tests2
                      ++ tests3
                      ++ tests4
                      ++ tests5
                      ++ tests6
                      ++ tests7
                      ++ tests8
                      ++ tests9
                      ++ tests10
                      ++ tests11
                      ++ tests12
                      ++ tests13
                      ++ tests14
                      ++ tests15
                      ++ tests16
                      ++ tests17
                      ++ tests18
                      ++ tests19
                      ++ tests20
                      ++ tests21
                      ++ (tests22 input22)
                      ++ tests23
                      ++ tests24
                      ++ tests25
                      )
\end{code}

Acknowledgements
----------------

The styling for this document is from Kevin Burke's excellent [Markdown
CSS][markdown-css].  I am grateful to Thomas Sutton for his [formatting
Literate Haskell blog post][thomas-sutton], that inspired the build scripts I
made for this project.  Many solutions were refined after-the-fact by
suggestions gleaned from other solutions in the Project Euler forums.

[markdown-css]: http://kevinburke.bitbucket.org/markdowncss/
[thomas-sutton]: http://passingcuriosity.com/2008/literate-haskell-with-markdown-syntax-hightlighting/
