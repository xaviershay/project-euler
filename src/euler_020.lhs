Problem 20
----------

 > |n!| means |n * (n - 1) * ... * 3 * 2 * 1|
 >
 > For example, |10! = 10 * 9 * ... * 3 * 2 * 1 = 3628800|, and the sum of the
 > digits in the number |10!| is |3 + 6 + 2 + 8 + 8 + 0 + 0 = 27|.
 >
 > Find the sum of the digits in the number |100!|

As with problem 16, this is trivial.

> factorial = product . enumFromTo 1

> euler20 = sumOfDigits . factorial

> tests20 =
>  [ "#20 problem" ~: 648 ~=? euler20 100
>  ]
