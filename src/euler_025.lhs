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

> euler25 n = length $ takeWhile (< 10^(n-1)) (0:1:fibonacci)

> tests25 =
>   [ "#25 given"   ~: 12   ~=? euler25 3
>   , "#25 problem" ~: 4782 ~=? euler25 1000
>   ]
