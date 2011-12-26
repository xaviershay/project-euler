Project Euler
=============

  > Project Euler is a series of challenging mathematical/computer programming
  problems that will require more than just mathematical insights to solve.
  Although mathematics will help you arrive at elegant and efficient methods,
  the use of a computer and programming skills will be required to solve most
  problems. -- [Project Euler](http://projecteuler.net)

Follows is my attempt at the problems. My goal in writing this is threefold: to
improve my familiarity with the Haskell language, work on my algorithmic chops,
and further my technical writing skills.

I presume a basic understanding of Haskell, but not in any of the algorithmic
techniques. Each solution should be comprehensible without former exposure to
the problem. If you are unfamiliar with Haskell, you may still be able to
follow along as many of the solutions are quite expressive --- hopefully this
will pique your interest in the language!

This treatise is written in Literate Haskell, meaning it is executable as-is
with `ghc`. The [source is available on GitHub][source].

[source]: https://github.com/xaviershay/project-euler

Preamble
--------

All imports are required to be at the top of the source file, so they are
presented here and not duplicated in the problems for which they are
specifically required. I restrict myself to common packages.

Both sample input and expected answers (after they have been solved) will be
expressed as HUnit tests below each solution.

> import Test.HUnit

Importing the suite of `List` functions is non-controversial in a language that
specifically excels at list processing.

> import List
> import Data.List.Split

The `Char` module is included for conversion functions handy for dealing with
different input and output formats of the problems, specifically `digitToInt`
to convert strings to integers.

> import Char

Lookup tables are a useful optimization for some of the problems. Since the
function names in `Data.Map` conflict with many of the functions in the
`Prelude`, requrie the `M` prefix to reference them.

> import qualified Data.Map as M

A helper function similar to `digitToInt` for use in parsing input.

> stringToInt :: String -> Int
> stringToInt = read

