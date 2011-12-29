Problem 16
----------

 > |2^15| = 32768 and the sum of its digits is |3 + 2 + 7 + 6 + 8 = 26|.
 >
 > What is the sum of the digits of the number |2^1000|?

Does what is says on the packet.

> sumOfDigits = sum . map digitToInt . show

> euler16 = sumOfDigits . (^) 2

> tests16 =
>   [ "#16 given"   ~: 26   ~=? euler16 15
>   , "#16 problem" ~: 1366 ~=? euler16 1000
>   ]
