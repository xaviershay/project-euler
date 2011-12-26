Project Euler
=============

  > Project Euler is a series of challenging mathematical/computer programming
  problems that will require more than just mathematical insights to solve.
  Although mathematics will help you arrive at elegant and efficient methods,
  the use of a computer and programming skills will be required to solve most
  problems. -- [Project Euler](http://projecteuler.net)

Follows is my attempt at the problems. My goal is to improve my familiarity with
the Haskell language, work on my algorithmic chops, and document the
journey as I go.

This document is written in literate haskell, meaning it is executable as-is
with `ghc`. The source is available on GitHub.

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

The `Char` module is included for conversion functions handy for dealing with
different input and output formats of the problems, specifically `digitToInt`
to convert strings to integers.

> import Char

