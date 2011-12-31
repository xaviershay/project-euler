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

> import Test.HUnit

Importing the suite of `List` functions is non-controversial in a language that
specifically excels at list processing.

> import List
> import Data.List

In addition to the standard list packages, a common external package is used
for basic string handling, primarly for parsing problem input.

> import Data.List.Split

In certain cases, the run-time characteristics of a list are not performant
enough to provide a timely solution. In theses cases where constant-time random
access is required, an array will be used instead.

> import Array

Simalarly, the standard generic math functions are not fast enough for some
tight inner loops. `Bits` gives access to bit shifting functions, useful in
particular for fast divide by two using `shiftR`.

> import Data.Bits

The `Char` module is included for conversion functions handy for dealing with
different input and output formats of the problems, specifically `digitToInt`
to convert strings to integers.

> import Char

Many solutions make heavy use of recursion, but Haskell leaves memoization as
an option to the programmer, optimizing for smaller memory use rather than
running time. As such, a package is used to provide easy memoization of
arbitrary functions.

> import qualified Data.MemoCombinators as Memo

Date functions are included for problem 19.

> import Data.Time.Calendar
> import Data.Time.Calendar.OrdinalDate

Searching data structures is much easier using functions from `Maybe` such as
`fromJust`.

> import Data.Maybe

A helper function similar to `digitToInt` for use in parsing input. This is
extracted to a function primarily so a type signature can be applied to `read`,
so it knows what type to convert to.

> stringToInt :: String -> Int
> stringToInt = read

With those out of the way, on to the problems!
